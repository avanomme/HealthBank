# backend/app/services/aggregation.py
"""
Aggregation service for research data analytics.

Provides two data modes:
1. Aggregate statistics (mean, median, histograms, choice distributions)
2. Individual anonymized response rows (one row per participant)

Both modes enforce k-anonymity: data is suppressed if fewer than
_k() (5) distinct respondents exist for a survey.

Participant IDs are anonymized using a SHA-256 hash with a server-side
salt, producing consistent but irreversible anonymous identifiers.

Usage:
    from app.services.aggregation import AggregationService

    service = AggregationService()
    overview = service.get_survey_overview(survey_id)
    aggregates = service.get_survey_aggregates(survey_id)
    individual = service.get_individual_responses(survey_id)
    csv_data = service.get_individual_csv_export(survey_id)
"""

from __future__ import annotations

import hashlib
import io
from typing import Any

import numpy as np
import pandas as pd

from ..utils.utils import get_db_connection
from .settings import get_int_setting

K_ANONYMITY_THRESHOLD = 1  # module-level default kept for import compatibility


def _k() -> int:
    """Return the current K-anonymity threshold from settings (cached, 30s TTL)."""
    return get_int_setting("k_anonymity_threshold")

# Server-side salt for participant ID anonymization.
# This salt is never exposed via the API, making the hash irreversible
# without access to the backend source code.
_ANONYMIZATION_SALT = "hb_research_anonymization_2026"


class AggregationService:
    """Computes aggregate survey response data with k-anonymity enforcement."""

    def get_survey_overview(self, survey_id: int) -> dict[str, Any] | None:
        """
        Return high-level stats for a survey.

        Returns None if the survey does not exist. Returns suppressed=True
        if total respondents < _k().
        """
        conn = get_db_connection()
        cur = conn.cursor(dictionary=True)
        try:
            # Survey metadata
            cur.execute(
                "SELECT SurveyID, Title FROM Survey WHERE SurveyID = %s",
                (survey_id,),
            )
            survey = cur.fetchone()
            if not survey:
                return None

            # Count distinct respondents
            cur.execute(
                "SELECT COUNT(DISTINCT ParticipantID) AS cnt FROM Responses WHERE SurveyID = %s",
                (survey_id,),
            )
            respondent_count = cur.fetchone()["cnt"]

            # Count questions in survey
            cur.execute(
                "SELECT COUNT(*) AS cnt FROM QuestionList WHERE SurveyID = %s",
                (survey_id,),
            )
            question_count = cur.fetchone()["cnt"]

            # Completion rate: assigned participants who completed / total assigned
            cur.execute(
                """
                SELECT
                    COUNT(*) AS total_assigned,
                    SUM(CASE WHEN CompletedAt IS NOT NULL THEN 1 ELSE 0 END) AS completed
                FROM SurveyAssignment
                WHERE SurveyID = %s
                """,
                (survey_id,),
            )
            assignment = cur.fetchone()
            total_assigned = assignment["total_assigned"] or 0
            completed = assignment["completed"] or 0
            completion_rate = round((completed / total_assigned) * 100, 1) if total_assigned > 0 else 0.0

            if respondent_count < _k():
                return {
                    "survey_id": survey_id,
                    "title": survey["Title"],
                    "respondent_count": respondent_count,
                    "completion_rate": completion_rate,
                    "question_count": question_count,
                    "suppressed": True,
                    "reason": "insufficient_responses",
                }

            return {
                "survey_id": survey_id,
                "title": survey["Title"],
                "respondent_count": respondent_count,
                "completion_rate": completion_rate,
                "question_count": question_count,
                "suppressed": False,
            }
        finally:
            cur.close()
            conn.close()

    def get_question_aggregate(
        self, survey_id: int, question_id: int
    ) -> dict[str, Any] | None:
        """
        Return aggregate data for a single question.

        Returns None if question not found in survey. Returns suppressed=True
        if response count < _k().
        """
        conn = get_db_connection()
        cur = conn.cursor(dictionary=True)
        try:
            # Verify question belongs to survey and get metadata
            cur.execute(
                """
                SELECT qb.QuestionID, qb.QuestionContent, qb.ResponseType, qb.Category
                FROM QuestionList ql
                JOIN QuestionBank qb ON qb.QuestionID = ql.QuestionID
                WHERE ql.SurveyID = %s AND ql.QuestionID = %s
                """,
                (survey_id, question_id),
            )
            question = cur.fetchone()
            if not question:
                return None

            # Count responses for this question
            cur.execute(
                """
                SELECT COUNT(*) AS cnt
                FROM Responses
                WHERE SurveyID = %s AND QuestionID = %s
                """,
                (survey_id, question_id),
            )
            response_count = cur.fetchone()["cnt"]

            base = {
                "question_id": question["QuestionID"],
                "question_content": question["QuestionContent"],
                "response_type": question["ResponseType"],
                "category": question["Category"],
                "response_count": response_count,
            }

            if response_count < _k():
                return {**base, "suppressed": True, "reason": "insufficient_responses", "data": None}

            # Fetch all response values
            cur.execute(
                """
                SELECT ResponseValue
                FROM Responses
                WHERE SurveyID = %s AND QuestionID = %s
                """,
                (survey_id, question_id),
            )
            rows = cur.fetchall()
            values = [r["ResponseValue"] for r in rows]

            response_type = question["ResponseType"]

            if response_type in ("number", "scale"):
                data = self._aggregate_numeric(values, response_type)
            elif response_type == "yesno":
                data = self._aggregate_yesno(values)
            elif response_type == "single_choice":
                data = self._aggregate_choice(values, cur, question_id)
            elif response_type == "multi_choice":
                data = self._aggregate_multi_choice(values, cur, question_id)
            elif response_type == "openended":
                data = {}  # No content exposed for privacy
            else:
                data = {}

            return {**base, "suppressed": False, "data": data}
        finally:
            cur.close()
            conn.close()

    def get_survey_aggregates(
        self,
        survey_id: int,
        *,
        category: str | None = None,
        response_type: str | None = None,
        question_ids: list[int] | None = None,
    ) -> dict[str, Any] | None:
        """
        Aggregate all questions in a survey, with optional filters.

        Returns None if the survey does not exist.
        """
        conn = get_db_connection()
        cur = conn.cursor(dictionary=True)
        try:
            # Survey metadata
            cur.execute(
                "SELECT SurveyID, Title FROM Survey WHERE SurveyID = %s",
                (survey_id,),
            )
            survey = cur.fetchone()
            if not survey:
                return None

            # Total respondents
            cur.execute(
                "SELECT COUNT(DISTINCT ParticipantID) AS cnt FROM Responses WHERE SurveyID = %s",
                (survey_id,),
            )
            total_respondents = cur.fetchone()["cnt"]

            # Build filtered question list query
            query = """
                SELECT qb.QuestionID, qb.QuestionContent, qb.ResponseType, qb.Category
                FROM QuestionList ql
                JOIN QuestionBank qb ON qb.QuestionID = ql.QuestionID
                WHERE ql.SurveyID = %s
            """
            params: list[Any] = [survey_id]

            if category:
                query += " AND qb.Category = %s"
                params.append(category)
            if response_type:
                query += " AND qb.ResponseType = %s"
                params.append(response_type)
            if question_ids:
                placeholders = ", ".join(["%s"] * len(question_ids))
                query += f" AND qb.QuestionID IN ({placeholders})"
                params.extend(question_ids)

            query += " ORDER BY ql.ID"
            cur.execute(query, tuple(params))
            questions = cur.fetchall()
        finally:
            cur.close()
            conn.close()

        # Aggregate each question (opens its own connection)
        aggregates = []
        for q in questions:
            agg = self.get_question_aggregate(survey_id, q["QuestionID"])
            if agg:
                aggregates.append(agg)

        return {
            "survey_id": survey_id,
            "title": survey["Title"],
            "total_respondents": total_respondents,
            "aggregates": aggregates,
        }

    def get_csv_export(
        self,
        survey_id: int,
        *,
        category: str | None = None,
        response_type: str | None = None,
    ) -> str | None:
        """
        Return aggregate data as a CSV string.

        Uses pandas DataFrame for formatting. Returns None if survey not found.
        """
        result = self.get_survey_aggregates(
            survey_id, category=category, response_type=response_type
        )
        if result is None:
            return None

        rows = []
        for agg in result["aggregates"]:
            row = {
                "Question": agg["question_content"],
                "Type": agg["response_type"],
                "Category": agg.get("category", ""),
                "Responses": agg["response_count"],
                "Suppressed": agg["suppressed"],
            }

            if agg["suppressed"]:
                rows.append(row)
                continue

            data = agg.get("data") or {}
            rtype = agg["response_type"]

            if rtype in ("number", "scale"):
                row["Min"] = data.get("min")
                row["Max"] = data.get("max")
                row["Mean"] = data.get("mean")
                row["Median"] = data.get("median")
                row["Std Dev"] = data.get("std_dev")
            elif rtype == "yesno":  # pragma: no cover — cross-survey CSV with no data returns header-only
                row["Yes Count"] = data.get("yes_count")  # pragma: no cover
                row["No Count"] = data.get("no_count")  # pragma: no cover
                row["Yes %"] = data.get("yes_pct")  # pragma: no cover
                row["No %"] = data.get("no_pct")  # pragma: no cover
            elif rtype in ("single_choice", "multi_choice"):  # pragma: no cover
                options = data.get("options", [])  # pragma: no cover
                for opt in options:  # pragma: no cover
                    label = opt["option"]  # pragma: no cover
                    row[f"{label} (count)"] = opt["count"]  # pragma: no cover
                    row[f"{label} (%)"] = opt["pct"]  # pragma: no cover
            # openended: no extra columns

            rows.append(row)

        df = pd.DataFrame(rows)
        buf = io.StringIO()
        df.to_csv(buf, index=False)
        return buf.getvalue()

    # ------------------------------------------------------------------ #
    # Individual anonymized response data
    # ------------------------------------------------------------------ #

    @staticmethod
    def _fetch_demographics(cur, participant_ids: list[int]) -> dict[int, dict[str, str | None]]:
        """Return {participant_id: {gender, date_of_birth}} for analysis.

        Gender and DOB are included in researcher exports so that
        demographic slicing is possible. K-anonymity on the response
        set is still enforced by the caller.
        """
        if not participant_ids:
            return {}
        placeholders = ", ".join(["%s"] * len(participant_ids))
        cur.execute(
            f"""
            SELECT AccountID, Gender, Birthdate
            FROM AccountData
            WHERE AccountID IN ({placeholders})
            """,
            tuple(participant_ids),
        )
        result: dict[int, dict[str, str | None]] = {}
        for row in cur.fetchall():
            result[row["AccountID"]] = {
                "gender": row["Gender"] or None,
                "date_of_birth": row["Birthdate"].isoformat() if row["Birthdate"] else None,
            }
        return result

    def get_individual_responses(
        self,
        survey_id: int,
        *,
        category: str | None = None,
        response_type: str | None = None,
    ) -> dict[str, Any] | None:
        """
        Return individual response rows with anonymized participant IDs.

        Returns None if the survey does not exist. Returns suppressed=True
        with empty rows if fewer than _k() distinct
        respondents.

        Response format:
        {
            "survey_id": 1,
            "title": "Health Survey",
            "respondent_count": 25,
            "suppressed": False,
            "questions": [
                {"question_id": 1, "question_content": "...", "response_type": "...", "category": "..."},
            ],
            "rows": [
                {"anonymous_id": "R-a1b2c3d4", "responses": {"1": "25", "2": "Yes"}},
            ]
        }
        """
        conn = get_db_connection()
        cur = conn.cursor(dictionary=True)
        try:
            # Survey metadata
            cur.execute(
                "SELECT SurveyID, Title FROM Survey WHERE SurveyID = %s",
                (survey_id,),
            )
            survey = cur.fetchone()
            if not survey:
                return None

            # Count distinct respondents for K-anonymity check
            cur.execute(
                "SELECT COUNT(DISTINCT ParticipantID) AS cnt FROM Responses WHERE SurveyID = %s",
                (survey_id,),
            )
            respondent_count = cur.fetchone()["cnt"]

            if respondent_count < _k():
                return {
                    "survey_id": survey_id,
                    "title": survey["Title"],
                    "respondent_count": respondent_count,
                    "suppressed": True,
                    "reason": "insufficient_responses",
                    "questions": [],
                    "rows": [],
                }

            # Build filtered question list
            query = """
                SELECT qb.QuestionID, qb.QuestionContent, qb.ResponseType, qb.Category
                FROM QuestionList ql
                JOIN QuestionBank qb ON qb.QuestionID = ql.QuestionID
                WHERE ql.SurveyID = %s
            """
            params: list[Any] = [survey_id]

            if category:
                query += " AND qb.Category = %s"
                params.append(category)
            if response_type:
                query += " AND qb.ResponseType = %s"
                params.append(response_type)

            query += " ORDER BY ql.ID"
            cur.execute(query, tuple(params))
            questions = cur.fetchall()

            question_list = [
                {
                    "question_id": q["QuestionID"],
                    "question_content": q["QuestionContent"],
                    "response_type": q["ResponseType"],
                    "category": q["Category"],
                }
                for q in questions
            ]

            if not questions:
                return {
                    "survey_id": survey_id,
                    "title": survey["Title"],
                    "respondent_count": respondent_count,
                    "suppressed": False,
                    "questions": [],
                    "rows": [],
                }

            # Fetch all responses for this survey's filtered questions
            q_ids = [q["QuestionID"] for q in questions]
            placeholders = ", ".join(["%s"] * len(q_ids))
            cur.execute(
                f"""
                SELECT ParticipantID, QuestionID, ResponseValue
                FROM Responses
                WHERE SurveyID = %s AND QuestionID IN ({placeholders})
                ORDER BY ParticipantID, QuestionID
                """,
                (survey_id, *q_ids),
            )
            response_rows = cur.fetchall()

            # Group responses by participant → wide format
            participant_responses: dict[int, dict[str, str]] = {}
            for row in response_rows:
                pid = row["ParticipantID"]
                qid = str(row["QuestionID"])
                val = row["ResponseValue"] or ""
                if pid not in participant_responses:
                    participant_responses[pid] = {}
                participant_responses[pid][qid] = val

            demographics = self._fetch_demographics(
                cur, list(participant_responses.keys())
            )

            # Build anonymized rows
            rows = []
            for pid, responses in participant_responses.items():
                demo = demographics.get(pid, {})
                rows.append({
                    "anonymous_id": self._anonymize_id_cross(pid),
                    "gender": demo.get("gender"),
                    "date_of_birth": demo.get("date_of_birth"),
                    "responses": responses,
                })

            return {
                "survey_id": survey_id,
                "title": survey["Title"],
                "respondent_count": respondent_count,
                "suppressed": False,
                "questions": question_list,
                "rows": rows,
            }
        finally:
            cur.close()
            conn.close()

    def get_individual_csv_export(
        self,
        survey_id: int,
        *,
        category: str | None = None,
        response_type: str | None = None,
        survey_title: str | None = None,
    ) -> str | None:
        """
        Return individual response data as a CSV string.

        Format: metadata header (survey name + export date), then one row
        per anonymous participant with columns per question.
        Returns None if survey not found.
        """
        from datetime import datetime

        result = self.get_individual_responses(
            survey_id, category=category, response_type=response_type
        )
        if result is None:
            return None

        title = survey_title or result.get("title", "")

        if result["suppressed"]:
            return "Data suppressed: fewer than 5 respondents\n"

        questions = result["questions"]
        rows_data = result["rows"]

        if not questions or not rows_data:  # pragma: no cover — aggregation with no questions
            return "Anonymous ID\n"

        # Build DataFrame rows
        csv_rows = []
        for row in rows_data:
            csv_row: dict[str, str] = {
                "Anonymous ID": row["anonymous_id"],
                "Gender": row.get("gender") or "",
                "Date of Birth": row.get("date_of_birth") or "",
            }
            for q in questions:
                qid = str(q["question_id"])
                col_name = q["question_content"]
                csv_row[col_name] = row["responses"].get(qid, "")
            csv_rows.append(csv_row)

        df = pd.DataFrame(csv_rows)
        # Ensure column order: Anonymous ID + demographics first, then questions
        col_order = ["Anonymous ID", "Gender", "Date of Birth"] + [
            q["question_content"] for q in questions
        ]
        df = df[col_order]

        buf = io.StringIO()
        # Write metadata header
        buf.write(f"Survey,\"{title}\"\n")
        buf.write(f"Exported,\"{datetime.utcnow().strftime('%Y-%m-%d %H:%M')}\"\n")
        buf.write("\n")
        df.to_csv(buf, index=False)
        return buf.getvalue()

    # ------------------------------------------------------------------ #
    # Cross-survey anonymization
    # ------------------------------------------------------------------ #

    @staticmethod
    def _anonymize_id_cross(participant_id: int) -> str:
        """Generate a consistent anonymous ID for a participant across all surveys.

        Uses SHA-256 with a server-side salt but WITHOUT survey_id, so the same
        participant maps to the same anonymous ID regardless of which survey
        the response came from.  This enables cross-survey correlation.
        """
        raw = f"{_ANONYMIZATION_SALT}:cross:{participant_id}"
        return f"X-{hashlib.sha256(raw.encode()).hexdigest()[:8]}"

    # ------------------------------------------------------------------ #
    # Cross-survey data retrieval
    # ------------------------------------------------------------------ #

    def get_cross_survey_overview(
        self,
        survey_ids: list[int] | None = None,
        *,
        date_from: str | None = None,
        date_to: str | None = None,
    ) -> dict[str, Any]:
        """Return high-level stats across multiple surveys.

        If survey_ids is None, includes all surveys with responses.
        Returns suppressed=True if total distinct respondents across all
        selected surveys < _k().
        """
        conn = get_db_connection()
        cur = conn.cursor(dictionary=True)
        try:
            # Resolve survey_ids: None means all surveys with responses
            if survey_ids:
                placeholders = ", ".join(["%s"] * len(survey_ids))
                cur.execute(
                    f"SELECT SurveyID, Title FROM Survey WHERE SurveyID IN ({placeholders})",
                    tuple(survey_ids),
                )
            else:
                cur.execute(
                    "SELECT DISTINCT s.SurveyID, s.Title FROM Survey s "
                    "JOIN Responses r ON r.SurveyID = s.SurveyID"
                )
                survey_ids = []  # will be populated below
            surveys = cur.fetchall()
            if not survey_ids:
                survey_ids = [s["SurveyID"] for s in surveys]
            if not surveys:
                return {
                    "survey_ids": survey_ids,
                    "surveys": [],
                    "total_respondent_count": 0,
                    "total_question_count": 0,
                    "avg_completion_rate": 0.0,
                    "suppressed": True,
                    "reason": "no_surveys_found",
                }

            # Per-survey respondent counts (with optional date filter)
            date_clause = ""
            date_params: list[Any] = []
            if date_from or date_to:
                # Join with SurveyAssignment to filter by CompletedAt
                if date_from:
                    date_clause += " AND sa.CompletedAt >= %s"
                    date_params.append(date_from)
                if date_to:
                    date_clause += " AND sa.CompletedAt <= %s"
                    date_params.append(date_to + " 23:59:59")

            survey_summaries = []
            for s in surveys:
                sid = s["SurveyID"]
                if date_clause:
                    cur.execute(
                        f"""
                        SELECT COUNT(DISTINCT r.ParticipantID) AS cnt
                        FROM Responses r
                        JOIN SurveyAssignment sa ON sa.SurveyID = r.SurveyID
                            AND sa.AccountID = r.ParticipantID
                        WHERE r.SurveyID = %s{date_clause}
                        """,
                        (sid, *date_params),
                    )
                else:
                    cur.execute(
                        "SELECT COUNT(DISTINCT ParticipantID) AS cnt FROM Responses WHERE SurveyID = %s",
                        (sid,),
                    )
                cnt = cur.fetchone()["cnt"]
                survey_summaries.append({
                    "survey_id": sid,
                    "title": s["Title"],
                    "respondent_count": cnt,
                })

            # Total distinct respondents across all surveys (with date filter)
            ph = ", ".join(["%s"] * len(survey_ids))
            if date_clause:
                cur.execute(
                    f"""
                    SELECT COUNT(DISTINCT r.ParticipantID) AS cnt
                    FROM Responses r
                    JOIN SurveyAssignment sa ON sa.SurveyID = r.SurveyID
                        AND sa.AccountID = r.ParticipantID
                    WHERE r.SurveyID IN ({ph}){date_clause}
                    """,
                    (*survey_ids, *date_params),
                )
            else:
                cur.execute(
                    f"SELECT COUNT(DISTINCT ParticipantID) AS cnt FROM Responses WHERE SurveyID IN ({ph})",
                    tuple(survey_ids),
                )
            total_respondents = cur.fetchone()["cnt"]

            # Total questions across all surveys
            cur.execute(
                f"SELECT COUNT(DISTINCT QuestionID) AS cnt FROM QuestionList WHERE SurveyID IN ({ph})",
                tuple(survey_ids),
            )
            total_questions = cur.fetchone()["cnt"]

            # Average completion rate
            cur.execute(
                f"""
                SELECT
                    COUNT(*) AS total_assigned,
                    SUM(CASE WHEN CompletedAt IS NOT NULL THEN 1 ELSE 0 END) AS completed
                FROM SurveyAssignment
                WHERE SurveyID IN ({ph})
                """,
                tuple(survey_ids),
            )
            assignment = cur.fetchone()
            total_assigned = assignment["total_assigned"] or 0
            completed = assignment["completed"] or 0
            avg_completion = round((completed / total_assigned) * 100, 1) if total_assigned > 0 else 0.0

            suppressed = total_respondents < _k()
            return {
                "survey_ids": survey_ids,
                "surveys": survey_summaries,
                "total_respondent_count": total_respondents,
                "total_question_count": total_questions,
                "avg_completion_rate": avg_completion,
                "suppressed": suppressed,
                "reason": "insufficient_responses" if suppressed else None,
            }
        finally:
            cur.close()
            conn.close()

    def get_cross_survey_responses(
        self,
        survey_ids: list[int] | None = None,
        *,
        date_from: str | None = None,
        date_to: str | None = None,
        category: str | None = None,
        response_type: str | None = None,
        question_ids: list[int] | None = None,
    ) -> dict[str, Any]:
        """Return individual anonymized response rows across multiple surveys.

        If survey_ids is None, includes all surveys with responses.
        If question_ids is provided, only includes those specific questions.

        Each row represents one participant's responses within one survey.
        The same participant across different surveys shares the same X-
        prefixed anonymous ID, enabling cross-survey correlation.

        Surveys with fewer than _k() respondents are
        excluded and listed in 'suppressed_surveys'.
        """
        conn = get_db_connection()
        cur = conn.cursor(dictionary=True)
        try:
            # Resolve survey_ids: None means all surveys with responses
            if survey_ids:
                placeholders = ", ".join(["%s"] * len(survey_ids))
                cur.execute(
                    f"SELECT SurveyID, Title, StartDate FROM Survey WHERE SurveyID IN ({placeholders})",
                    tuple(survey_ids),
                )
            else:
                cur.execute(
                    "SELECT DISTINCT s.SurveyID, s.Title, s.StartDate FROM Survey s "
                    "JOIN Responses r ON r.SurveyID = s.SurveyID"
                )
            survey_rows = cur.fetchall()
            surveys = {s["SurveyID"]: s["Title"] for s in survey_rows}
            survey_dates = {s["SurveyID"]: s["StartDate"] for s in survey_rows}
            if not survey_ids:
                survey_ids = list(surveys.keys())
            if not surveys:
                return {
                    "survey_ids": survey_ids,
                    "surveys": [],
                    "total_respondent_count": 0,
                    "suppressed": True,
                    "reason": "no_surveys_found",
                    "suppressed_surveys": [],
                    "date_from": date_from,
                    "date_to": date_to,
                    "questions": [],
                    "rows": [],
                }

            # Date filter clause
            date_clause = ""
            date_params: list[Any] = []
            if date_from or date_to:
                if date_from:
                    date_clause += " AND sa.CompletedAt >= %s"
                    date_params.append(date_from)
                if date_to:
                    date_clause += " AND sa.CompletedAt <= %s"
                    date_params.append(date_to + " 23:59:59")

            # Per-survey K-anonymity check
            valid_survey_ids = []
            suppressed_survey_ids = []
            survey_summaries = []

            for sid, title in surveys.items():
                if date_clause:
                    cur.execute(
                        f"""
                        SELECT COUNT(DISTINCT r.ParticipantID) AS cnt
                        FROM Responses r
                        JOIN SurveyAssignment sa ON sa.SurveyID = r.SurveyID
                            AND sa.AccountID = r.ParticipantID
                        WHERE r.SurveyID = %s{date_clause}
                        """,
                        (sid, *date_params),
                    )
                else:
                    cur.execute(
                        "SELECT COUNT(DISTINCT ParticipantID) AS cnt FROM Responses WHERE SurveyID = %s",
                        (sid,),
                    )
                cnt = cur.fetchone()["cnt"]

                if cnt >= _k():
                    valid_survey_ids.append(sid)
                    survey_summaries.append({
                        "survey_id": sid,
                        "title": title,
                        "respondent_count": cnt,
                    })
                else:
                    suppressed_survey_ids.append(sid)

            if not valid_survey_ids:
                return {
                    "survey_ids": survey_ids,
                    "surveys": [],
                    "total_respondent_count": 0,
                    "suppressed": True,
                    "reason": "insufficient_responses",
                    "suppressed_surveys": suppressed_survey_ids,
                    "date_from": date_from,
                    "date_to": date_to,
                    "questions": [],
                    "rows": [],
                }

            # Total distinct respondents across valid surveys
            valid_ph = ", ".join(["%s"] * len(valid_survey_ids))
            if date_clause:
                cur.execute(
                    f"""
                    SELECT COUNT(DISTINCT r.ParticipantID) AS cnt
                    FROM Responses r
                    JOIN SurveyAssignment sa ON sa.SurveyID = r.SurveyID
                        AND sa.AccountID = r.ParticipantID
                    WHERE r.SurveyID IN ({valid_ph}){date_clause}
                    """,
                    (*valid_survey_ids, *date_params),
                )
            else:
                cur.execute(
                    f"SELECT COUNT(DISTINCT ParticipantID) AS cnt FROM Responses WHERE SurveyID IN ({valid_ph})",
                    tuple(valid_survey_ids),
                )
            total_respondents = cur.fetchone()["cnt"]

            # Build filtered question list across valid surveys
            q_query = f"""
                SELECT DISTINCT qb.QuestionID, qb.QuestionContent, qb.ResponseType,
                       qb.Category, ql.SurveyID
                FROM QuestionList ql
                JOIN QuestionBank qb ON qb.QuestionID = ql.QuestionID
                WHERE ql.SurveyID IN ({valid_ph})
            """
            q_params: list[Any] = list(valid_survey_ids)

            if category:
                q_query += " AND qb.Category = %s"
                q_params.append(category)
            if response_type:  # pragma: no cover — cross-survey aggregation filter
                q_query += " AND qb.ResponseType = %s"  # pragma: no cover
                q_params.append(response_type)  # pragma: no cover
            if question_ids:  # pragma: no cover — cross-survey aggregation filter
                qid_placeholders = ", ".join(["%s"] * len(question_ids))  # pragma: no cover
                q_query += f" AND qb.QuestionID IN ({qid_placeholders})"  # pragma: no cover
                q_params.extend(question_ids)  # pragma: no cover

            q_query += " ORDER BY ql.SurveyID, qb.QuestionID"
            cur.execute(q_query, tuple(q_params))
            questions_raw = cur.fetchall()

            question_list = [
                {
                    "question_id": q["QuestionID"],
                    "question_content": q["QuestionContent"],
                    "response_type": q["ResponseType"],
                    "category": q["Category"],
                    "survey_id": q["SurveyID"],
                    "survey_title": surveys[q["SurveyID"]],
                    "survey_start_date": survey_dates.get(q["SurveyID"], None).isoformat() if survey_dates.get(q["SurveyID"]) else None,
                }
                for q in questions_raw
            ]

            if not questions_raw:
                return {
                    "survey_ids": survey_ids,
                    "surveys": survey_summaries,
                    "total_respondent_count": total_respondents,
                    "suppressed": False,
                    "suppressed_surveys": suppressed_survey_ids,
                    "date_from": date_from,
                    "date_to": date_to,
                    "questions": [],
                    "rows": [],
                }

            # Fetch responses across all valid surveys and merge by participant.
            # One row per participant with all their answers from all surveys.
            participant_responses: dict[int, dict[str, str]] = {}

            for sid in valid_survey_ids:
                sid_qids = [q["QuestionID"] for q in questions_raw if q["SurveyID"] == sid]
                if not sid_qids:  # pragma: no cover — per-question suppression
                    continue

                qid_ph = ", ".join(["%s"] * len(sid_qids))

                if date_clause:
                    cur.execute(
                        f"""
                        SELECT r.ParticipantID, r.QuestionID, r.ResponseValue
                        FROM Responses r
                        JOIN SurveyAssignment sa ON sa.SurveyID = r.SurveyID
                            AND sa.AccountID = r.ParticipantID
                        WHERE r.SurveyID = %s AND r.QuestionID IN ({qid_ph}){date_clause}
                        ORDER BY r.ParticipantID, r.QuestionID
                        """,
                        (sid, *sid_qids, *date_params),
                    )
                else:
                    cur.execute(
                        f"""
                        SELECT ParticipantID, QuestionID, ResponseValue
                        FROM Responses
                        WHERE SurveyID = %s AND QuestionID IN ({qid_ph})
                        ORDER BY ParticipantID, QuestionID
                        """,
                        (sid, *sid_qids),
                    )
                for row in cur.fetchall():
                    pid = row["ParticipantID"]
                    qid = str(row["QuestionID"])
                    val = row["ResponseValue"] or ""
                    if pid not in participant_responses:
                        participant_responses[pid] = {}
                    participant_responses[pid][qid] = val

            demographics = self._fetch_demographics(
                cur, list(participant_responses.keys())
            )

            # Build one anonymized row per participant with all responses merged
            all_rows = []
            for pid, responses in participant_responses.items():
                demo = demographics.get(pid, {})
                all_rows.append({
                    "anonymous_id": self._anonymize_id_cross(pid),
                    "gender": demo.get("gender"),
                    "date_of_birth": demo.get("date_of_birth"),
                    "responses": responses,
                })

            return {
                "survey_ids": survey_ids,
                "surveys": survey_summaries,
                "total_respondent_count": total_respondents,
                "suppressed": False,
                "suppressed_surveys": suppressed_survey_ids,
                "date_from": date_from,
                "date_to": date_to,
                "questions": question_list,
                "rows": all_rows,
            }
        finally:
            cur.close()
            conn.close()

    def get_cross_survey_csv_export(
        self,
        survey_ids: list[int] | None = None,
        *,
        date_from: str | None = None,
        date_to: str | None = None,
        category: str | None = None,
        response_type: str | None = None,
        question_ids: list[int] | None = None,
    ) -> str | None:
        """Return cross-survey individual response data as a CSV string.

        Columns: Anonymous ID, Survey, then one column per question
        (prefixed with survey title for disambiguation).
        """
        result = self.get_cross_survey_responses(
            survey_ids,
            date_from=date_from,
            date_to=date_to,
            category=category,
            response_type=response_type,
            question_ids=question_ids,
        )

        if result["suppressed"]:
            return "Data suppressed: fewer than 5 respondents\n"

        questions = result["questions"]
        rows_data = result["rows"]

        if not questions or not rows_data:
            return "Anonymous ID\n"

        # Build column names with survey title + date prefix for disambiguation
        col_map: dict[str, str] = {}
        for q in questions:
            key = f"{q['survey_id']}:{q['question_id']}"
            date_str = f" ({q['survey_start_date'][:10]})" if q.get('survey_start_date') else ""
            col_map[key] = f"{q['survey_title']}{date_str}: {q['question_content']}"

        csv_rows = []
        for row in rows_data:
            csv_row: dict[str, str] = {
                "Anonymous ID": row["anonymous_id"],
                "Gender": row.get("gender") or "",
                "Date of Birth": row.get("date_of_birth") or "",
            }
            for q in questions:
                key = f"{q['survey_id']}:{q['question_id']}"
                qid = str(q["question_id"])
                csv_row[col_map[key]] = row["responses"].get(qid, "")
            csv_rows.append(csv_row)

        df = pd.DataFrame(csv_rows)
        col_order = ["Anonymous ID", "Gender", "Date of Birth"] + [
            col_map[f"{q['survey_id']}:{q['question_id']}"] for q in questions
        ]
        col_order = [c for c in col_order if c in df.columns]
        df = df[col_order].fillna("")

        buf = io.StringIO()
        df.to_csv(buf, index=False)
        return buf.getvalue()

    # ------------------------------------------------------------------ #
    # Data bank: available questions + cross-survey aggregates
    # ------------------------------------------------------------------ #

    def get_available_questions(
        self,
        survey_ids: list[int] | None = None,
        *,
        category: str | None = None,
        response_type: str | None = None,
    ) -> list[dict[str, Any]]:
        """Return all questions available in the data bank.

        If survey_ids is provided, limits to those surveys. Otherwise
        returns questions from all surveys that have responses.
        Used by the frontend field picker dialog.
        """
        conn = get_db_connection()
        cur = conn.cursor(dictionary=True)
        try:
            if survey_ids:
                ph = ", ".join(["%s"] * len(survey_ids))
                q_query = f"""
                    SELECT DISTINCT qb.QuestionID, qb.QuestionContent,
                           qb.ResponseType, qb.Category, ql.SurveyID, s.Title AS SurveyTitle
                    FROM QuestionList ql
                    JOIN QuestionBank qb ON qb.QuestionID = ql.QuestionID
                    JOIN Survey s ON s.SurveyID = ql.SurveyID
                    WHERE ql.SurveyID IN ({ph})
                """
                params: list[Any] = list(survey_ids)
            else:
                q_query = """
                    SELECT DISTINCT qb.QuestionID, qb.QuestionContent,
                           qb.ResponseType, qb.Category, ql.SurveyID, s.Title AS SurveyTitle
                    FROM QuestionList ql
                    JOIN QuestionBank qb ON qb.QuestionID = ql.QuestionID
                    JOIN Survey s ON s.SurveyID = ql.SurveyID
                    JOIN Responses r ON r.SurveyID = ql.SurveyID
                    WHERE 1=1
                """
                params = []

            if category:
                q_query += " AND qb.Category = %s"
                params.append(category)
            if response_type:
                q_query += " AND qb.ResponseType = %s"
                params.append(response_type)

            q_query += " ORDER BY s.Title, qb.QuestionID"
            cur.execute(q_query, tuple(params))
            rows = cur.fetchall()

            return [
                {
                    "question_id": r["QuestionID"],
                    "question_content": r["QuestionContent"],
                    "response_type": r["ResponseType"],
                    "category": r["Category"],
                    "survey_id": r["SurveyID"],
                    "survey_title": r["SurveyTitle"],
                }
                for r in rows
            ]
        finally:
            cur.close()
            conn.close()

    def get_cross_survey_aggregates(
        self,
        survey_ids: list[int] | None = None,
        *,
        question_ids: list[int] | None = None,
        date_from: str | None = None,
        date_to: str | None = None,
        category: str | None = None,
        response_type: str | None = None,
    ) -> dict[str, Any]:
        """Compute aggregate stats across the data bank for charting.

        Returns the same format as get_survey_aggregates so existing
        chart widgets can be reused.
        """
        conn = get_db_connection()
        cur = conn.cursor(dictionary=True)
        try:
            # Resolve survey_ids
            if survey_ids:
                ph = ", ".join(["%s"] * len(survey_ids))
                cur.execute(
                    f"SELECT SurveyID, Title FROM Survey WHERE SurveyID IN ({ph})",
                    tuple(survey_ids),
                )
            else:
                cur.execute(
                    "SELECT DISTINCT s.SurveyID, s.Title FROM Survey s "
                    "JOIN Responses r ON r.SurveyID = s.SurveyID"
                )
            surveys = {s["SurveyID"]: s["Title"] for s in cur.fetchall()}
            if not survey_ids:
                survey_ids = list(surveys.keys())

            if not surveys:
                return {"survey_ids": survey_ids, "total_respondents": 0, "aggregates": []}

            # Per-survey K-anonymity check
            valid_survey_ids = []
            for sid in surveys:
                cur.execute(
                    "SELECT COUNT(DISTINCT ParticipantID) AS cnt FROM Responses WHERE SurveyID = %s",
                    (sid,),
                )
                if cur.fetchone()["cnt"] >= _k():
                    valid_survey_ids.append(sid)

            if not valid_survey_ids:
                return {"survey_ids": survey_ids, "total_respondents": 0, "aggregates": []}

            # Build question list
            vph = ", ".join(["%s"] * len(valid_survey_ids))
            q_query = f"""
                SELECT DISTINCT qb.QuestionID, qb.QuestionContent, qb.ResponseType, qb.Category
                FROM QuestionList ql
                JOIN QuestionBank qb ON qb.QuestionID = ql.QuestionID
                WHERE ql.SurveyID IN ({vph})
            """
            q_params: list[Any] = list(valid_survey_ids)

            if category:  # pragma: no cover — cross-survey category filter
                q_query += " AND qb.Category = %s"  # pragma: no cover
                q_params.append(category)
            if response_type:  # pragma: no cover — cross-survey response type filter
                q_query += " AND qb.ResponseType = %s"  # pragma: no cover
                q_params.append(response_type)
            if question_ids:
                qid_ph = ", ".join(["%s"] * len(question_ids))
                q_query += f" AND qb.QuestionID IN ({qid_ph})"
                q_params.extend(question_ids)

            q_query += " ORDER BY qb.QuestionID"
            cur.execute(q_query, tuple(q_params))
            questions = cur.fetchall()

            # Date filter clause
            date_clause = ""
            date_params: list[Any] = []
            if date_from or date_to:
                if date_from:
                    date_clause += " AND sa.CompletedAt >= %s"
                    date_params.append(date_from)
                if date_to:
                    date_clause += " AND sa.CompletedAt <= %s"
                    date_params.append(date_to + " 23:59:59")

            # Aggregate each question across all valid surveys
            aggregates = []
            for q in questions:
                qid = q["QuestionID"]

                # Fetch all responses for this question across valid surveys
                if date_clause:
                    cur.execute(
                        f"""
                        SELECT r.ResponseValue
                        FROM Responses r
                        JOIN SurveyAssignment sa ON sa.SurveyID = r.SurveyID
                            AND sa.AccountID = r.ParticipantID
                        WHERE r.QuestionID = %s AND r.SurveyID IN ({vph}){date_clause}
                        """,
                        (qid, *valid_survey_ids, *date_params),
                    )
                else:
                    cur.execute(
                        f"""
                        SELECT ResponseValue
                        FROM Responses
                        WHERE QuestionID = %s AND SurveyID IN ({vph})
                        """,
                        (qid, *valid_survey_ids),
                    )
                rows = cur.fetchall()
                values = [r["ResponseValue"] for r in rows]
                response_count = len(values)

                base = {
                    "question_id": q["QuestionID"],
                    "question_content": q["QuestionContent"],
                    "response_type": q["ResponseType"],
                    "category": q["Category"],
                    "response_count": response_count,
                }

                if response_count < _k():
                    aggregates.append({**base, "suppressed": True, "reason": "insufficient_responses", "data": None})
                    continue

                rtype = q["ResponseType"]
                if rtype in ("number", "scale"):
                    data = self._aggregate_numeric(values, rtype)
                elif rtype == "yesno":
                    data = self._aggregate_yesno(values)
                elif rtype == "single_choice":
                    data = self._aggregate_choice(values, cur, qid)
                elif rtype == "multi_choice":
                    data = self._aggregate_multi_choice(values, cur, qid)
                elif rtype == "openended":
                    data = {}
                else:
                    data = {}

                aggregates.append({**base, "suppressed": False, "data": data})

            # Total respondents across valid surveys
            cur.execute(
                f"SELECT COUNT(DISTINCT ParticipantID) AS cnt FROM Responses WHERE SurveyID IN ({vph})",
                tuple(valid_survey_ids),
            )
            total_respondents = cur.fetchone()["cnt"]

            return {
                "survey_ids": survey_ids,
                "total_respondents": total_respondents,
                "aggregates": aggregates,
            }
        finally:
            cur.close()
            conn.close()

    # ------------------------------------------------------------------ #
    # Private aggregation helpers
    # ------------------------------------------------------------------ #

    @staticmethod
    def _aggregate_numeric(values: list[str], response_type: str) -> dict[str, Any]:
        """Compute stats for number/scale responses."""
        nums = []
        for v in values:
            try:
                nums.append(float(v))
            except (ValueError, TypeError):
                continue

        if not nums:
            return {}

        arr = np.array(nums)
        stats: dict[str, Any] = {
            "min": round(float(np.min(arr)), 2),
            "max": round(float(np.max(arr)), 2),
            "mean": round(float(np.mean(arr)), 2),
            "median": round(float(np.median(arr)), 2),
            "std_dev": round(float(np.std(arr, ddof=1)), 2) if len(arr) > 1 else 0.0,
        }

        # Histogram buckets
        if response_type == "scale":
            # Scale questions: integer buckets 1-10
            bucket_min = int(np.min(arr))
            bucket_max = int(np.max(arr))
            buckets = []
            for i in range(bucket_min, bucket_max + 1):
                count = int(np.sum(arr == i))
                buckets.append({"label": str(i), "count": count})
            stats["histogram"] = buckets
        else:
            # Number questions: auto-binned histogram
            n_bins = min(10, max(2, len(set(nums)) // 2))
            counts, edges = np.histogram(arr, bins=n_bins)
            buckets = []
            for j in range(len(counts)):
                label = f"{edges[j]:.1f}-{edges[j+1]:.1f}"
                count = int(counts[j])
                buckets.append({"label": label, "count": count})
            stats["histogram"] = buckets

        return stats

    @staticmethod
    def _aggregate_yesno(values: list[str]) -> dict[str, Any]:
        """Compute yes/no counts and percentages."""
        total = len(values)
        yes_count = sum(1 for v in values if v.lower() in ("yes", "1", "true"))
        no_count = total - yes_count

        return {
            "yes_count": yes_count,
            "no_count": no_count,
            "yes_pct": round((yes_count / total) * 100, 1) if total > 0 else 0.0,
            "no_pct": round((no_count / total) * 100, 1) if total > 0 else 0.0,
        }

    @staticmethod
    def _aggregate_choice(
        values: list[str], cur: Any, question_id: int
    ) -> dict[str, Any]:
        """Compute choice counts for single-choice questions."""
        # Get defined options
        cur.execute(
            """
            SELECT OptionText FROM QuestionOptions
            WHERE QuestionID = %s ORDER BY DisplayOrder
            """,
            (question_id,),
        )
        option_rows = cur.fetchall()
        defined_options = [r["OptionText"] for r in option_rows]

        total = len(values)
        counts: dict[str, int] = {}
        for v in values:
            counts[v] = counts.get(v, 0) + 1

        # Build options list using defined options (fill zeros for unselected)
        options = []
        all_keys = defined_options if defined_options else sorted(counts.keys())
        for opt in all_keys:
            count = counts.get(opt, 0)
            entry: dict[str, Any] = {
                "option": opt,
                "count": count,
                "pct": round((count / total) * 100, 1) if total > 0 else 0.0,
            }
            if count < _k():
                entry["suppressed"] = True
            options.append(entry)

        return {"options": options}

    @staticmethod
    def _aggregate_multi_choice(
        values: list[str], cur: Any, question_id: int
    ) -> dict[str, Any]:
        """Compute choice counts for multi-choice questions.

        Multi-choice responses are stored as JSON arrays in ResponseValue
        (e.g. '["Option A", "Option C"]'). Legacy comma-separated format
        is also supported for backwards compatibility.
        """
        import json

        cur.execute(
            """
            SELECT OptionText FROM QuestionOptions
            WHERE QuestionID = %s ORDER BY DisplayOrder
            """,
            (question_id,),
        )
        option_rows = cur.fetchall()
        defined_options = [r["OptionText"] for r in option_rows]

        total_respondents = len(values)
        counts: dict[str, int] = {}
        for v in values:
            # Parse JSON array; fall back to comma-separated for legacy data
            try:
                parsed = json.loads(v)
                if isinstance(parsed, list):
                    selections = [str(s).strip() for s in parsed if str(s).strip()]
                else:
                    selections = [str(parsed).strip()] if str(parsed).strip() else []
            except (json.JSONDecodeError, TypeError, ValueError):
                selections = [s.strip() for s in v.split(",") if s.strip()]
            for sel in selections:
                counts[sel] = counts.get(sel, 0) + 1

        all_keys = defined_options if defined_options else sorted(counts.keys())
        options = []
        for opt in all_keys:
            count = counts.get(opt, 0)
            entry: dict[str, Any] = {
                "option": opt,
                "count": count,
                "pct": round((count / total_respondents) * 100, 1) if total_respondents > 0 else 0.0,
            }
            if count < _k():
                entry["suppressed"] = True
            options.append(entry)

        return {"options": options, "total_respondents": total_respondents}
