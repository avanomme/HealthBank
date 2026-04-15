# Created with the Assistance of Claude Code
# backend/app/api/v1/responses.py
"""
Response Submission API — Participant Survey Responses

Endpoints:
- POST / — Submit responses for a survey (participant only)

Validates:
- Participant is assigned to survey via SurveyAssignment
- Survey PublicationStatus is 'published'
- Each question exists in survey's QuestionList
- ResponseValue matches QuestionBank.ResponseType

SECURITY: All queries use parameterized statements to prevent SQL injection.
"""

import json

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel, field_validator
from typing import Optional

from ...utils.utils import get_db_connection
from ..deps import require_role, sanitized_string

router = APIRouter()


# ---------------------------------------------------------------------------
# Request models
# ---------------------------------------------------------------------------

class ResponseItem(BaseModel):
    question_id: int
    response_value: str

    @field_validator('response_value', mode='before')
    @classmethod
    def sanitize(cls, v):
        return sanitized_string(v)


class SubmitResponsesRequest(BaseModel):
    survey_id: int
    responses: list[ResponseItem]


# ---------------------------------------------------------------------------
# Validation helpers
# ---------------------------------------------------------------------------

VALID_YESNO = {"yes", "no", "1", "0", "true", "false"}
VALID_RESPONSE_TYPES = {"number", "yesno", "openended", "single_choice", "multi_choice", "scale"}


def _validate_response_value(value: str, response_type: str, options: list[str]) -> Optional[str]:
    """Return an error message if value doesn't match response_type, else None."""
    if response_type == "number":
        try:
            float(value)
        except (ValueError, TypeError):
            return f"Expected numeric value, got '{value}'"

    elif response_type == "scale":
        try:
            n = float(value)
            if not (1 <= n <= 10):
                return f"Scale value must be between 1 and 10, got '{value}'"
        except (ValueError, TypeError):
            return f"Expected numeric scale value, got '{value}'"

    elif response_type == "yesno":
        if value.lower() not in VALID_YESNO:
            return f"Expected yes/no value, got '{value}'"

    elif response_type == "single_choice":
        if options and value not in options:
            return f"'{value}' is not a valid option. Valid: {options}"

    elif response_type == "multi_choice":
        if options:
            selections = _parse_multi_choice(value)
            invalid = [s for s in selections if s not in options]
            if invalid:
                return f"Invalid selections: {invalid}. Valid: {options}"

    # openended accepts any string
    return None


def _parse_multi_choice(value: str) -> list[str]:
    """Parse a multi-choice value from JSON array or legacy comma-separated."""
    try:
        parsed = json.loads(value)
        if isinstance(parsed, list):
            return [str(s).strip() for s in parsed if str(s).strip()]
    except (json.JSONDecodeError, TypeError, ValueError):
        pass
    # Legacy comma-separated fallback
    return [s.strip() for s in value.split(",") if s.strip()]


def _normalize_response_value(value: str, response_type: str) -> str:
    """Normalize multi_choice values to JSON array format before storage."""
    if response_type == "multi_choice":
        selections = _parse_multi_choice(value)
        return json.dumps(selections)
    return value


# ---------------------------------------------------------------------------
# Endpoint
# ---------------------------------------------------------------------------

@router.post("/", status_code=201)
def submit_responses(
    body: SubmitResponsesRequest,
    user=Depends(require_role(1)),
):
    """
    Submit survey responses for a participant.

    Only participants (RoleID=1) can submit responses.
    """
    participant_id = user["effective_account_id"]
    survey_id = body.survey_id

    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        # 1. Validate survey exists and is published
        cur.execute(
            "SELECT PublicationStatus FROM Survey WHERE SurveyID = %s",
            (survey_id,),
        )
        survey = cur.fetchone()
        if not survey:
            raise HTTPException(status_code=404, detail="Survey not found")
        if survey["PublicationStatus"] != "published":
            raise HTTPException(status_code=400, detail="Survey is not published")

        # 2. Validate participant is assigned to survey
        cur.execute(
            """
            SELECT AssignmentID FROM SurveyAssignment
            WHERE SurveyID = %s AND AccountID = %s
            """,
            (survey_id, participant_id),
        )
        if not cur.fetchone():
            raise HTTPException(
                status_code=403, detail="Participant is not assigned to this survey"
            )

        # 3. Get all questions in survey with their types and required flags
        cur.execute(
            """
            SELECT qb.QuestionID, qb.ResponseType, ql.IsRequired
            FROM QuestionList ql
            JOIN QuestionBank qb ON qb.QuestionID = ql.QuestionID
            WHERE ql.SurveyID = %s
            """,
            (survey_id,),
        )
        question_map = {
            row["QuestionID"]: {
                "response_type": row["ResponseType"],
                "is_required": bool(row["IsRequired"]),
            }
            for row in cur.fetchall()
        }

        # 3.5 Validate required questions are present
        submitted_question_ids = {resp.question_id for resp in body.responses}
        missing_required = [
            question_id
            for question_id, meta in question_map.items()
            if meta["is_required"] and question_id not in submitted_question_ids
        ]
        if missing_required:
            raise HTTPException(
                status_code=422,
                detail=f"Missing required responses for question ids: {missing_required}",
            )

        # 4. Validate and insert each response
        for resp in body.responses:
            if resp.question_id not in question_map:
                raise HTTPException(
                    status_code=400,
                    detail=f"Question {resp.question_id} is not in this survey",
                )

            response_type = question_map[resp.question_id]["response_type"]

            # Get options for choice questions
            options = []
            if response_type in ("single_choice", "multi_choice"):
                cur.execute(
                    "SELECT OptionText FROM QuestionOptions WHERE QuestionID = %s ORDER BY DisplayOrder",
                    (resp.question_id,),
                )
                options = [r["OptionText"] for r in cur.fetchall()]

            # Validate value matches type
            error = _validate_response_value(resp.response_value, response_type, options)
            if error:
                raise HTTPException(status_code=422, detail=error)

            # Normalize multi_choice to JSON array before storage
            stored_value = _normalize_response_value(resp.response_value, response_type)

            # Insert response
            cur.execute(
                """
                INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue)
                VALUES (%s, %s, %s, %s)
                """,
                (survey_id, participant_id, resp.question_id, stored_value),
            )

        # 5. Mark assignment as completed
        cur.execute(
            """
            UPDATE SurveyAssignment
            SET CompletedAt = UTC_TIMESTAMP(), Status = 'completed'
            WHERE SurveyID = %s AND AccountID = %s AND CompletedAt IS NULL
            """,
            (survey_id, participant_id),
        )

        conn.commit()

        return {
            "message": "Responses submitted successfully",
            "survey_id": survey_id,
            "responses_count": len(body.responses),
        }

    except HTTPException:
        raise
    except Exception as e:
        import logging
        logging.getLogger(__name__).error("Failed to submit responses: %s", e, exc_info=True)
        conn.rollback()
        raise HTTPException(
            status_code=500, detail="Failed to submit responses"
        )
    finally:
        cur.close()
        conn.close()