# Created with the Assistance of Claude Code
"""Tests for app.services.aggregation — cross-survey methods and helpers."""

import pytest
from unittest.mock import patch, MagicMock
from datetime import date

from app.services.aggregation import AggregationService, K_ANONYMITY_THRESHOLD


DB_PATCH = "app.services.aggregation.get_db_connection"


def _set_k5():
    """Seed settings cache with k=5 for tests that verify suppression with small counts."""
    import app.services.settings as _s
    _s._cache = {"k_anonymity_threshold": "5"}
    _s._cache_at = 9e18


def _make_cursor(execute_results):
    """Build a MagicMock cursor whose fetchone/fetchall return values
    change on successive execute() calls according to *execute_results*.

    Each entry in execute_results is a dict with optional keys:
      - 'one': value for fetchone()
      - 'all': value for fetchall()
    """
    cursor = MagicMock()
    cursor.__enter__ = MagicMock(return_value=cursor)
    cursor.__exit__ = MagicMock(return_value=False)

    idx = {"i": 0}
    originals = list(execute_results)

    def _on_execute(*args, **kwargs):
        # Advance index (capped at last entry to avoid IndexError)
        i = min(idx["i"], len(originals) - 1)
        entry = originals[i]
        cursor.fetchone.return_value = entry.get("one")
        cursor.fetchall.return_value = entry.get("all", [])
        idx["i"] += 1

    cursor.execute.side_effect = _on_execute
    return cursor


def _make_conn(cursor):
    conn = MagicMock()
    conn.cursor.return_value = cursor
    return conn


# ------------------------------------------------------------------ #
# _anonymize_id_cross
# ------------------------------------------------------------------ #

class TestAnonymizeIdCross:
    def test_returns_string_with_x_prefix(self):
        result = AggregationService._anonymize_id_cross(42)
        assert result.startswith("X-")
        assert len(result) == 10  # X- + 8 hex chars

    def test_deterministic(self):
        a = AggregationService._anonymize_id_cross(42)
        b = AggregationService._anonymize_id_cross(42)
        assert a == b

    def test_different_ids_produce_different_hashes(self):
        a = AggregationService._anonymize_id_cross(1)
        b = AggregationService._anonymize_id_cross(2)
        assert a != b


# ------------------------------------------------------------------ #
# get_cross_survey_overview
# ------------------------------------------------------------------ #

class TestGetCrossSurveyOverview:
    @patch(DB_PATCH)
    def test_no_surveys_found(self, mock_get_conn):
        cur = _make_cursor([
            {"all": []},  # SELECT surveys
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_overview(survey_ids=[999])

        assert result["suppressed"] is True
        assert result["reason"] == "no_surveys_found"
        assert result["total_respondent_count"] == 0

    @patch(DB_PATCH)
    def test_no_survey_ids_resolves_all(self, mock_get_conn):
        """When survey_ids is None, all surveys with responses are used."""
        cur = _make_cursor([
            {"all": [{"SurveyID": 1, "Title": "S1"}, {"SurveyID": 2, "Title": "S2"}]},
            # per-survey respondent count survey 1
            {"one": {"cnt": 10}},
            # per-survey respondent count survey 2
            {"one": {"cnt": 8}},
            # total distinct respondents
            {"one": {"cnt": 15}},
            # total questions
            {"one": {"cnt": 5}},
            # assignment completion
            {"one": {"total_assigned": 20, "completed": 15}},
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_overview(survey_ids=None)

        assert result["suppressed"] is False
        assert result["total_respondent_count"] == 15
        assert result["total_question_count"] == 5
        assert result["avg_completion_rate"] == 75.0
        assert len(result["surveys"]) == 2

    @patch(DB_PATCH)
    def test_suppressed_when_below_k(self, mock_get_conn):
        _set_k5()  # cnt=3 must be below k
        cur = _make_cursor([
            {"all": [{"SurveyID": 1, "Title": "S1"}]},
            {"one": {"cnt": 3}},   # per-survey count
            {"one": {"cnt": 3}},   # total distinct
            {"one": {"cnt": 2}},   # total questions
            {"one": {"total_assigned": 5, "completed": 3}},
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_overview(survey_ids=[1])

        assert result["suppressed"] is True
        assert result["reason"] == "insufficient_responses"

    @patch(DB_PATCH)
    def test_with_date_filters(self, mock_get_conn):
        cur = _make_cursor([
            {"all": [{"SurveyID": 1, "Title": "S1"}]},
            {"one": {"cnt": 10}},  # per-survey count (date filtered)
            {"one": {"cnt": 10}},  # total distinct
            {"one": {"cnt": 3}},   # total questions
            {"one": {"total_assigned": 12, "completed": 10}},
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_overview(
            survey_ids=[1], date_from="2026-01-01", date_to="2026-12-31"
        )

        assert result["suppressed"] is False
        assert result["total_respondent_count"] == 10

    @patch(DB_PATCH)
    def test_zero_assignments(self, mock_get_conn):
        """avg_completion_rate is 0.0 when no assignments exist."""
        cur = _make_cursor([
            {"all": [{"SurveyID": 1, "Title": "S1"}]},
            {"one": {"cnt": 6}},
            {"one": {"cnt": 6}},
            {"one": {"cnt": 1}},
            {"one": {"total_assigned": 0, "completed": 0}},
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_overview(survey_ids=[1])
        assert result["avg_completion_rate"] == 0.0


# ------------------------------------------------------------------ #
# get_cross_survey_responses
# ------------------------------------------------------------------ #

class TestGetCrossSurveyResponses:
    @patch(DB_PATCH)
    def test_no_surveys_found(self, mock_get_conn):
        cur = _make_cursor([{"all": []}])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_responses(survey_ids=[999])

        assert result["suppressed"] is True
        assert result["reason"] == "no_surveys_found"
        assert result["rows"] == []

    @patch(DB_PATCH)
    def test_all_surveys_suppressed(self, mock_get_conn):
        _set_k5()  # cnt=2 must be below k
        cur = _make_cursor([
            {"all": [{"SurveyID": 1, "Title": "S1", "StartDate": date(2026, 1, 1)}]},
            {"one": {"cnt": 2}},  # below K
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_responses(survey_ids=[1])

        assert result["suppressed"] is True
        assert result["reason"] == "insufficient_responses"
        assert 1 in result["suppressed_surveys"]

    @patch(DB_PATCH)
    def test_successful_responses(self, mock_get_conn):
        cur = _make_cursor([
            # survey lookup
            {"all": [{"SurveyID": 1, "Title": "S1", "StartDate": date(2026, 1, 1)}]},
            # per-survey k-anon check
            {"one": {"cnt": 6}},
            # total distinct respondents
            {"one": {"cnt": 6}},
            # question list
            {"all": [{"QuestionID": 10, "QuestionContent": "Q?", "ResponseType": "number",
                       "Category": "Health", "SurveyID": 1}]},
            # responses for survey 1
            {"all": [
                {"ParticipantID": 100, "QuestionID": 10, "ResponseValue": "5"},
                {"ParticipantID": 101, "QuestionID": 10, "ResponseValue": "8"},
            ]},
            # _fetch_demographics
            {"all": []},
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_responses(survey_ids=[1])

        assert result["suppressed"] is False
        assert result["total_respondent_count"] == 6
        assert len(result["rows"]) == 2
        # Each row should have an anonymous_id starting with X-
        for row in result["rows"]:
            assert row["anonymous_id"].startswith("X-")
            assert "10" in row["responses"]

    @patch(DB_PATCH)
    def test_no_questions_after_filter(self, mock_get_conn):
        cur = _make_cursor([
            {"all": [{"SurveyID": 1, "Title": "S1", "StartDate": date(2026, 1, 1)}]},
            {"one": {"cnt": 10}},
            {"one": {"cnt": 10}},
            {"all": []},  # no questions match filter
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_responses(
            survey_ids=[1], category="nonexistent"
        )

        assert result["suppressed"] is False
        assert result["questions"] == []
        assert result["rows"] == []

    @patch(DB_PATCH)
    def test_with_date_filter(self, mock_get_conn):
        cur = _make_cursor([
            {"all": [{"SurveyID": 1, "Title": "S1", "StartDate": date(2026, 1, 1)}]},
            {"one": {"cnt": 7}},
            {"one": {"cnt": 7}},
            {"all": [{"QuestionID": 10, "QuestionContent": "Q?", "ResponseType": "number",
                       "Category": "Health", "SurveyID": 1}]},
            {"all": [
                {"ParticipantID": 100, "QuestionID": 10, "ResponseValue": "3"},
            ]},
            # _fetch_demographics
            {"all": []},
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_responses(
            survey_ids=[1], date_from="2026-01-01", date_to="2026-06-30"
        )

        assert result["suppressed"] is False
        assert result["date_from"] == "2026-01-01"
        assert result["date_to"] == "2026-06-30"

    @patch(DB_PATCH)
    def test_none_survey_ids_resolves_all(self, mock_get_conn):
        cur = _make_cursor([
            {"all": [{"SurveyID": 1, "Title": "S1", "StartDate": date(2026, 1, 1)}]},
            {"one": {"cnt": 5}},
            {"one": {"cnt": 5}},
            {"all": [{"QuestionID": 10, "QuestionContent": "Q?", "ResponseType": "number",
                       "Category": "Health", "SurveyID": 1}]},
            {"all": []},
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_responses(survey_ids=None)
        assert result["suppressed"] is False


# ------------------------------------------------------------------ #
# get_cross_survey_csv_export
# ------------------------------------------------------------------ #

class TestGetCrossSurveyCsvExport:
    @patch.object(AggregationService, "get_cross_survey_responses")
    def test_suppressed_returns_message(self, mock_responses):
        mock_responses.return_value = {"suppressed": True}

        svc = AggregationService()
        result = svc.get_cross_survey_csv_export(survey_ids=[1])

        assert "suppressed" in result.lower()

    @patch.object(AggregationService, "get_cross_survey_responses")
    def test_no_questions_returns_header_only(self, mock_responses):
        mock_responses.return_value = {
            "suppressed": False,
            "questions": [],
            "rows": [],
        }

        svc = AggregationService()
        result = svc.get_cross_survey_csv_export(survey_ids=[1])
        assert result.strip() == "Anonymous ID"

    @patch.object(AggregationService, "get_cross_survey_responses")
    def test_csv_with_data(self, mock_responses):
        mock_responses.return_value = {
            "suppressed": False,
            "questions": [
                {
                    "question_id": 10,
                    "question_content": "Hours of sleep?",
                    "response_type": "number",
                    "category": "Health",
                    "survey_id": 1,
                    "survey_title": "Sleep Survey",
                    "survey_start_date": "2026-01-15",
                },
            ],
            "rows": [
                {"anonymous_id": "X-abc12345", "responses": {"10": "7"}},
                {"anonymous_id": "X-def67890", "responses": {"10": "6"}},
            ],
        }

        svc = AggregationService()
        result = svc.get_cross_survey_csv_export(survey_ids=[1])

        lines = result.strip().split("\n")
        assert len(lines) == 3  # header + 2 data rows
        assert "Anonymous ID" in lines[0]
        assert "Sleep Survey" in lines[0]
        assert "X-abc12345" in lines[1]


# ------------------------------------------------------------------ #
# get_available_questions
# ------------------------------------------------------------------ #

class TestGetAvailableQuestions:
    @patch(DB_PATCH)
    def test_with_survey_ids(self, mock_get_conn):
        cur = _make_cursor([
            {"all": [
                {"QuestionID": 1, "QuestionContent": "Q1", "ResponseType": "number",
                 "Category": "Health", "SurveyID": 1, "SurveyTitle": "S1"},
            ]},
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_available_questions(survey_ids=[1])

        assert len(result) == 1
        assert result[0]["question_id"] == 1
        assert result[0]["survey_title"] == "S1"

    @patch(DB_PATCH)
    def test_without_survey_ids(self, mock_get_conn):
        cur = _make_cursor([
            {"all": [
                {"QuestionID": 1, "QuestionContent": "Q1", "ResponseType": "number",
                 "Category": "Health", "SurveyID": 1, "SurveyTitle": "S1"},
            ]},
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_available_questions(survey_ids=None)
        assert len(result) == 1

    @patch(DB_PATCH)
    def test_with_filters(self, mock_get_conn):
        cur = _make_cursor([{"all": []}])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_available_questions(
            survey_ids=[1], category="Sleep", response_type="number"
        )
        assert result == []

    @patch(DB_PATCH)
    def test_empty_result(self, mock_get_conn):
        cur = _make_cursor([{"all": []}])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_available_questions(survey_ids=[1])
        assert result == []


# ------------------------------------------------------------------ #
# get_cross_survey_aggregates
# ------------------------------------------------------------------ #

class TestGetCrossSurveyAggregates:
    @patch(DB_PATCH)
    def test_no_surveys(self, mock_get_conn):
        cur = _make_cursor([{"all": []}])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_aggregates(survey_ids=[999])
        assert result["total_respondents"] == 0
        assert result["aggregates"] == []

    @patch(DB_PATCH)
    def test_all_surveys_below_k_anonymity(self, mock_get_conn):
        _set_k5()  # cnt=3 must be below k
        cur = _make_cursor([
            {"all": [{"SurveyID": 1, "Title": "S1"}]},
            {"one": {"cnt": 3}},  # below K
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_aggregates(survey_ids=[1])
        assert result["total_respondents"] == 0
        assert result["aggregates"] == []

    @patch(DB_PATCH)
    def test_numeric_aggregation(self, mock_get_conn):
        cur = _make_cursor([
            # surveys
            {"all": [{"SurveyID": 1, "Title": "S1"}]},
            # k-anon check: 6 respondents
            {"one": {"cnt": 6}},
            # question list
            {"all": [{"QuestionID": 10, "QuestionContent": "Hours?",
                       "ResponseType": "number", "Category": "Health"}]},
            # responses for question 10
            {"all": [
                {"ResponseValue": "5"}, {"ResponseValue": "7"},
                {"ResponseValue": "6"}, {"ResponseValue": "8"},
                {"ResponseValue": "5"}, {"ResponseValue": "9"},
            ]},
            # total respondents
            {"one": {"cnt": 6}},
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_aggregates(survey_ids=[1])

        assert result["total_respondents"] == 6
        assert len(result["aggregates"]) == 1
        agg = result["aggregates"][0]
        assert agg["suppressed"] is False
        assert agg["data"]["mean"] is not None
        assert agg["data"]["median"] is not None

    @patch(DB_PATCH)
    def test_yesno_aggregation(self, mock_get_conn):
        cur = _make_cursor([
            {"all": [{"SurveyID": 1, "Title": "S1"}]},
            {"one": {"cnt": 5}},
            {"all": [{"QuestionID": 20, "QuestionContent": "Smoke?",
                       "ResponseType": "yesno", "Category": "Health"}]},
            {"all": [
                {"ResponseValue": "yes"}, {"ResponseValue": "no"},
                {"ResponseValue": "yes"}, {"ResponseValue": "yes"},
                {"ResponseValue": "no"},
            ]},
            {"one": {"cnt": 5}},
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_aggregates(survey_ids=[1])

        agg = result["aggregates"][0]
        assert agg["suppressed"] is False
        assert agg["data"]["yes_count"] == 3
        assert agg["data"]["no_count"] == 2

    @patch(DB_PATCH)
    def test_single_choice_aggregation(self, mock_get_conn):
        cur = _make_cursor([
            {"all": [{"SurveyID": 1, "Title": "S1"}]},
            {"one": {"cnt": 6}},
            {"all": [{"QuestionID": 30, "QuestionContent": "Frequency?",
                       "ResponseType": "single_choice", "Category": "Exercise"}]},
            # responses
            {"all": [
                {"ResponseValue": "Daily"}, {"ResponseValue": "Daily"},
                {"ResponseValue": "Weekly"}, {"ResponseValue": "Daily"},
                {"ResponseValue": "Weekly"}, {"ResponseValue": "Daily"},
            ]},
            # QuestionOptions lookup (inside _aggregate_choice)
            {"all": [{"OptionText": "Daily"}, {"OptionText": "Weekly"}, {"OptionText": "Never"}]},
            # total respondents
            {"one": {"cnt": 6}},
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_aggregates(survey_ids=[1])

        agg = result["aggregates"][0]
        assert agg["suppressed"] is False
        options = agg["data"]["options"]
        daily = next(o for o in options if o["option"] == "Daily")
        assert daily["count"] == 4

    @patch(DB_PATCH)
    def test_multi_choice_aggregation(self, mock_get_conn):
        cur = _make_cursor([
            {"all": [{"SurveyID": 1, "Title": "S1"}]},
            {"one": {"cnt": 5}},
            {"all": [{"QuestionID": 40, "QuestionContent": "Symptoms?",
                       "ResponseType": "multi_choice", "Category": "Health"}]},
            # responses (JSON array format)
            {"all": [
                {"ResponseValue": '["Headache", "Fatigue"]'},
                {"ResponseValue": '["Headache"]'},
                {"ResponseValue": '["Fatigue", "Nausea"]'},
                {"ResponseValue": '["Headache", "Fatigue"]'},
                {"ResponseValue": '["Nausea"]'},
            ]},
            # QuestionOptions lookup
            {"all": [{"OptionText": "Headache"}, {"OptionText": "Fatigue"}, {"OptionText": "Nausea"}]},
            # total respondents
            {"one": {"cnt": 5}},
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_aggregates(survey_ids=[1])

        agg = result["aggregates"][0]
        assert agg["suppressed"] is False
        options = agg["data"]["options"]
        headache = next(o for o in options if o["option"] == "Headache")
        assert headache["count"] == 3

    @patch(DB_PATCH)
    def test_question_below_k_suppressed(self, mock_get_conn):
        """Individual question with fewer than K responses is suppressed."""
        _set_k5()  # question has 3 responses, must be below k
        cur = _make_cursor([
            {"all": [{"SurveyID": 1, "Title": "S1"}]},
            {"one": {"cnt": 6}},  # survey passes k-anon
            {"all": [{"QuestionID": 10, "QuestionContent": "Q?",
                       "ResponseType": "number", "Category": "Health"}]},
            # only 3 responses for this question
            {"all": [
                {"ResponseValue": "5"}, {"ResponseValue": "7"}, {"ResponseValue": "6"},
            ]},
            {"one": {"cnt": 6}},
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_aggregates(survey_ids=[1])

        agg = result["aggregates"][0]
        assert agg["suppressed"] is True
        assert agg["data"] is None

    @patch(DB_PATCH)
    def test_openended_aggregation(self, mock_get_conn):
        cur = _make_cursor([
            {"all": [{"SurveyID": 1, "Title": "S1"}]},
            {"one": {"cnt": 5}},
            {"all": [{"QuestionID": 50, "QuestionContent": "Comments?",
                       "ResponseType": "openended", "Category": "General"}]},
            {"all": [
                {"ResponseValue": "a"}, {"ResponseValue": "b"},
                {"ResponseValue": "c"}, {"ResponseValue": "d"},
                {"ResponseValue": "e"},
            ]},
            {"one": {"cnt": 5}},
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_aggregates(survey_ids=[1])

        agg = result["aggregates"][0]
        assert agg["suppressed"] is False
        assert agg["data"] == {}

    @patch(DB_PATCH)
    def test_unknown_response_type(self, mock_get_conn):
        cur = _make_cursor([
            {"all": [{"SurveyID": 1, "Title": "S1"}]},
            {"one": {"cnt": 5}},
            {"all": [{"QuestionID": 60, "QuestionContent": "X?",
                       "ResponseType": "unknown_type", "Category": "Misc"}]},
            {"all": [
                {"ResponseValue": "a"}, {"ResponseValue": "b"},
                {"ResponseValue": "c"}, {"ResponseValue": "d"},
                {"ResponseValue": "e"},
            ]},
            {"one": {"cnt": 5}},
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_aggregates(survey_ids=[1])

        agg = result["aggregates"][0]
        assert agg["suppressed"] is False
        assert agg["data"] == {}

    @patch(DB_PATCH)
    def test_with_date_filter(self, mock_get_conn):
        cur = _make_cursor([
            {"all": [{"SurveyID": 1, "Title": "S1"}]},
            {"one": {"cnt": 5}},
            {"all": [{"QuestionID": 10, "QuestionContent": "Q?",
                       "ResponseType": "number", "Category": "Health"}]},
            {"all": [
                {"ResponseValue": "5"}, {"ResponseValue": "7"},
                {"ResponseValue": "6"}, {"ResponseValue": "8"},
                {"ResponseValue": "9"},
            ]},
            {"one": {"cnt": 5}},
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_aggregates(
            survey_ids=[1], date_from="2026-01-01", date_to="2026-06-30"
        )

        assert result["total_respondents"] == 5
        assert len(result["aggregates"]) == 1

    @patch(DB_PATCH)
    def test_with_question_ids_filter(self, mock_get_conn):
        cur = _make_cursor([
            {"all": [{"SurveyID": 1, "Title": "S1"}]},
            {"one": {"cnt": 5}},
            {"all": []},  # no questions match
            {"one": {"cnt": 5}},
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_aggregates(
            survey_ids=[1], question_ids=[999]
        )

        assert result["aggregates"] == []

    @patch(DB_PATCH)
    def test_none_survey_ids_resolves_all(self, mock_get_conn):
        cur = _make_cursor([
            {"all": [{"SurveyID": 1, "Title": "S1"}]},
            {"one": {"cnt": 5}},
            {"all": []},
            {"one": {"cnt": 5}},
        ])
        mock_get_conn.return_value = _make_conn(cur)

        svc = AggregationService()
        result = svc.get_cross_survey_aggregates(survey_ids=None)
        assert 1 in result["survey_ids"]


# ------------------------------------------------------------------ #
# _aggregate_numeric edge cases
# ------------------------------------------------------------------ #

class TestAggregateNumericEdgeCases:
    def test_non_numeric_values_skipped(self):
        svc = AggregationService()
        result = svc._aggregate_numeric(["abc", "5", "def", "10"], "number")
        assert result["mean"] == 7.5
        assert result["min"] == 5.0
        assert result["max"] == 10.0

    def test_all_non_numeric_returns_empty(self):
        svc = AggregationService()
        result = svc._aggregate_numeric(["abc", "def"], "number")
        assert result == {}

    def test_scale_type_histogram(self):
        svc = AggregationService()
        result = svc._aggregate_numeric(["1", "2", "2", "3", "3", "3"], "scale")
        assert "histogram" in result
        # Should have integer buckets
        labels = [b["label"] for b in result["histogram"]]
        assert "1" in labels
        assert "3" in labels

    def test_number_type_histogram(self):
        svc = AggregationService()
        result = svc._aggregate_numeric(
            ["1.5", "2.5", "3.5", "4.5", "5.5", "6.5"], "number"
        )
        assert "histogram" in result
        assert len(result["histogram"]) >= 2

    def test_single_value_std_dev_zero(self):
        svc = AggregationService()
        result = svc._aggregate_numeric(["5"], "number")
        assert result["std_dev"] == 0.0


# ------------------------------------------------------------------ #
# _aggregate_multi_choice edge cases
# ------------------------------------------------------------------ #

class TestAggregateMultiChoiceEdgeCases:
    def test_legacy_comma_separated(self):
        """Comma-separated format (legacy) is parsed correctly."""
        svc = AggregationService()
        cur = MagicMock()
        cur.fetchall.return_value = []  # no defined options

        result = svc._aggregate_multi_choice(
            ["Headache,Fatigue", "Nausea", "Headache"], cur, 1
        )

        opts = {o["option"]: o["count"] for o in result["options"]}
        assert opts["Headache"] == 2
        assert opts["Fatigue"] == 1
        assert opts["Nausea"] == 1

    def test_json_non_list_parsed(self):
        """A JSON value that is not a list (e.g. a string) is handled."""
        svc = AggregationService()
        cur = MagicMock()
        cur.fetchall.return_value = []

        result = svc._aggregate_multi_choice(
            ['"SingleValue"'], cur, 1
        )

        opts = {o["option"]: o["count"] for o in result["options"]}
        assert opts["SingleValue"] == 1


# ================================================================== #
# Additional coverage: missing lines
# ================================================================== #

class TestGetQuestionAggregateUnknownType:
    """Cover line 192: unknown response_type returns empty data dict."""

    @patch(DB_PATCH)
    def test_unknown_response_type_returns_empty_data(self, mock_db):
        """Line 192: response_type not in known types -> data = {}."""
        svc = AggregationService()

        cursor = _make_cursor([
            # 1. Question metadata (JOIN QuestionList + QuestionBank)
            {"one": {"QuestionID": 5, "QuestionContent": "Q?", "ResponseType": "unknown_type", "Category": None}},
            # 2. Response count
            {"one": {"cnt": 10}},
            # 3. Response values
            {"all": [{"ResponseValue": "val1"}, {"ResponseValue": "val2"}]},
        ])
        conn = _make_conn(cursor)
        mock_db.return_value = conn

        result = svc.get_question_aggregate(1, 5)
        assert result is not None
        assert result["suppressed"] is False
        assert result["data"] == {}


class TestGetSurveyAggregatesQuestionIds:
    """Cover lines 247-249: question_ids filter in get_survey_aggregates."""

    @patch(DB_PATCH)
    def test_question_ids_filter(self, mock_db):
        """Lines 247-249: question_ids parameter adds IN clause."""
        svc = AggregationService()

        cursor = _make_cursor([
            # Survey metadata
            {"one": {"SurveyID": 1, "Title": "Survey"}},
            # Total respondents
            {"one": {"cnt": 10}},
            # Questions (filtered by question_ids)
            {"all": []},
        ])
        conn = _make_conn(cursor)
        mock_db.return_value = conn

        result = svc.get_survey_aggregates(1, question_ids=[5, 10])
        assert result is not None
        assert result["aggregates"] == []


class TestGetIndividualResponsesNoQuestions:
    """Cover line 426: no questions returns empty response."""

    @patch(DB_PATCH)
    def test_no_questions_returns_empty(self, mock_db):
        """Line 426: empty question list -> empty rows."""
        svc = AggregationService()

        cursor = _make_cursor([
            # Survey metadata
            {"one": {"SurveyID": 1, "Title": "Survey"}},
            # Respondent count
            {"one": {"cnt": 10}},
            # Questions (empty)
            {"all": []},
        ])
        conn = _make_conn(cursor)
        mock_db.return_value = conn

        result = svc.get_individual_responses(1)
        assert result is not None
        assert result["questions"] == []
        assert result["rows"] == []


class TestGetIndividualCsvSuppressed:
    """Cover line 511: suppressed CSV returns message."""

    @patch(DB_PATCH)
    def test_suppressed_csv_returns_message(self, mock_db):
        """Line 511: suppressed -> returns suppression message CSV."""
        _set_k5()  # cnt=2 must be below k
        svc = AggregationService()

        cursor = _make_cursor([
            # Survey metadata
            {"one": {"SurveyID": 1, "Title": "Survey"}},
            # Respondent count (below threshold)
            {"one": {"cnt": 2}},
        ])
        conn = _make_conn(cursor)
        mock_db.return_value = conn

        result = svc.get_individual_csv_export(1)
        assert result is not None
        assert "suppressed" in result.lower()


class TestCrossSurveyResponsesNoQuestions:
    """Cover lines 842-843, 845-847, 886: cross-survey no questions empty response."""

    @patch(DB_PATCH)
    def test_cross_survey_no_questions_returns_empty(self, mock_db):
        """Lines 866-877: no questions in cross-survey -> empty."""
        svc = AggregationService()

        cursor = _make_cursor([
            # Survey list
            {"all": [
                {"SurveyID": 1, "Title": "S1", "StartDate": None},
            ]},
            # Respondent count per survey (above threshold)
            {"one": {"cnt": 10}},
            # Total respondents
            {"one": {"cnt": 10}},
            # Questions (empty)
            {"all": []},
        ])
        conn = _make_conn(cursor)
        mock_db.return_value = conn

        result = svc.get_cross_survey_responses([1])
        assert result is not None
        assert result["questions"] == []
        assert result["rows"] == []


class TestCrossSurveyAggregatesCategoryFilter:
    """Cover lines 1135-1136, 1138-1139: category/response_type filters."""

    @patch(DB_PATCH)
    def test_category_and_response_type_filters_no_surveys(self, mock_db):
        """Lines 1135-1139: filters applied; empty surveys -> early return."""
        svc = AggregationService()

        cursor = _make_cursor([
            # Survey list query returns empty
            {"all": []},
        ])
        conn = _make_conn(cursor)
        mock_db.return_value = conn

        result = svc.get_cross_survey_aggregates(
            [999], category="health", response_type="number"
        )
        assert result is not None
        assert result["total_respondents"] == 0
        assert result["aggregates"] == []

    @patch(DB_PATCH)
    def test_category_and_response_type_below_threshold(self, mock_db):
        """Lines 1135-1139: all surveys below threshold -> empty aggregates."""
        _set_k5()  # cnt=2 must be below k
        svc = AggregationService()

        cursor = _make_cursor([
            # Survey list
            {"all": [{"SurveyID": 1, "Title": "S1"}]},
            # Per-survey respondent count (below threshold)
            {"one": {"cnt": 2}},
        ])
        conn = _make_conn(cursor)
        mock_db.return_value = conn

        result = svc.get_cross_survey_aggregates(
            [1], category="health", response_type="number"
        )
        assert result is not None
        assert result["total_respondents"] == 0
        assert result["aggregates"] == []
