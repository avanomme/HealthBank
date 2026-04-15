# Created with the Assistance of Claude Code
# backend/tests/api/test_aggregation.py
"""
Tests for AggregationService in app/services/aggregation.py.

Tests cover:
- get_survey_overview: normal, suppressed (<5 respondents), nonexistent survey
- get_question_aggregate: all 6 response types, suppression, nonexistent question
- get_survey_aggregates: filters (category, response_type)
- get_csv_export: CSV output format
- K-anonymity enforcement throughout
- Individual ResponseValue rows never returned
"""

import pytest
from unittest.mock import patch, MagicMock, call

from app.services.aggregation import AggregationService, K_ANONYMITY_THRESHOLD, _ANONYMIZATION_SALT


@pytest.fixture
def service():
    return AggregationService()


def _set_k5():
    """Seed settings cache with k=5 for tests that verify suppression with small counts."""
    import app.services.settings as _s
    _s._cache = {"k_anonymity_threshold": "5"}
    _s._cache_at = 9e18


# ============================================================================
# get_survey_overview TESTS
# ============================================================================

class TestGetSurveyOverview:
    """Tests for AggregationService.get_survey_overview."""

    @patch("app.services.aggregation.get_db_connection")
    def test_returns_overview_with_correct_stats(self, mock_db, service):
        """Should return respondent count, completion rate, question count."""
        cur = MagicMock()
        cur.fetchone.side_effect = [
            {"SurveyID": 1, "Title": "Health Survey"},   # survey
            {"cnt": 10},                                    # respondent count
            {"cnt": 5},                                     # question count
            {"total_assigned": 20, "completed": 15},        # assignments
        ]
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_survey_overview(1)

        assert result is not None
        assert result["survey_id"] == 1
        assert result["title"] == "Health Survey"
        assert result["respondent_count"] == 10
        assert result["question_count"] == 5
        assert result["completion_rate"] == 75.0
        assert result["suppressed"] is False

    @patch("app.services.aggregation.get_db_connection")
    def test_returns_suppressed_when_under_threshold(self, mock_db, service):
        """Should return suppressed=True when respondents < K (0 is always below any K)."""
        import app.services.settings as svc_settings
        svc_settings._cache = {"k_anonymity_threshold": "5"}
        svc_settings._cache_at = 9e18  # won't expire during test
        cur = MagicMock()
        cur.fetchone.side_effect = [
            {"SurveyID": 1, "Title": "Small Survey"},
            {"cnt": 3},                                     # only 3 respondents; k=5 → suppressed
            {"cnt": 2},
            {"total_assigned": 5, "completed": 3},
        ]
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_survey_overview(1)

        assert result["suppressed"] is True
        assert result["reason"] == "insufficient_responses"
        assert result["respondent_count"] == 3

    @patch("app.services.aggregation.get_db_connection")
    def test_returns_none_for_nonexistent_survey(self, mock_db, service):
        """Should return None when survey does not exist."""
        cur = MagicMock()
        cur.fetchone.return_value = None  # no survey
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_survey_overview(999)

        assert result is None


# ============================================================================
# get_question_aggregate TESTS — number type
# ============================================================================

class TestAggregateNumber:
    """Tests for number/scale response type aggregation."""

    @patch("app.services.aggregation.get_db_connection")
    def test_number_returns_stats_and_histogram(self, mock_db, service):
        """Should return min, max, mean, median, std_dev, histogram for numbers."""
        cur = MagicMock()
        cur.fetchone.side_effect = [
            {"QuestionID": 1, "QuestionContent": "Pain level?",
             "ResponseType": "number", "Category": "health"},
            {"cnt": 6},  # 6 responses (>= K)
        ]
        cur.fetchall.return_value = [
            {"ResponseValue": "2"}, {"ResponseValue": "4"},
            {"ResponseValue": "6"}, {"ResponseValue": "8"},
            {"ResponseValue": "3"}, {"ResponseValue": "5"},
        ]
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_question_aggregate(1, 1)

        assert result["suppressed"] is False
        assert result["response_count"] == 6
        data = result["data"]
        assert data["min"] == 2.0
        assert data["max"] == 8.0
        assert "mean" in data
        assert "median" in data
        assert "std_dev" in data
        assert "histogram" in data

    @patch("app.services.aggregation.get_db_connection")
    def test_scale_returns_integer_histogram_buckets(self, mock_db, service):
        """Scale type should produce integer bucket labels."""
        cur = MagicMock()
        cur.fetchone.side_effect = [
            {"QuestionID": 2, "QuestionContent": "Rate 1-10",
             "ResponseType": "scale", "Category": "rating"},
            {"cnt": 10},
        ]
        # 10 responses: five 3s and five 7s
        cur.fetchall.return_value = [
            {"ResponseValue": "3"}, {"ResponseValue": "3"},
            {"ResponseValue": "3"}, {"ResponseValue": "3"},
            {"ResponseValue": "3"}, {"ResponseValue": "7"},
            {"ResponseValue": "7"}, {"ResponseValue": "7"},
            {"ResponseValue": "7"}, {"ResponseValue": "7"},
        ]
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_question_aggregate(1, 2)

        data = result["data"]
        histogram = data["histogram"]
        labels = [b["label"] for b in histogram]
        # Should have integer labels from 3 to 7
        assert "3" in labels
        assert "7" in labels
        # Bucket for "3" should have count=5 (meets K threshold)
        bucket_3 = next(b for b in histogram if b["label"] == "3")
        assert bucket_3["count"] == 5


# ============================================================================
# get_question_aggregate TESTS — yesno type
# ============================================================================

class TestAggregateYesNo:
    """Tests for yesno response type aggregation."""

    @patch("app.services.aggregation.get_db_connection")
    def test_yesno_returns_counts_and_percentages(self, mock_db, service):
        """Should return yes_count, no_count, yes_pct, no_pct."""
        cur = MagicMock()
        cur.fetchone.side_effect = [
            {"QuestionID": 3, "QuestionContent": "Smoke?",
             "ResponseType": "yesno", "Category": "habits"},
            {"cnt": 8},
        ]
        cur.fetchall.return_value = [
            {"ResponseValue": "yes"}, {"ResponseValue": "yes"},
            {"ResponseValue": "yes"}, {"ResponseValue": "no"},
            {"ResponseValue": "no"}, {"ResponseValue": "yes"},
            {"ResponseValue": "yes"}, {"ResponseValue": "no"},
        ]
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_question_aggregate(1, 3)

        data = result["data"]
        assert data["yes_count"] == 5
        assert data["no_count"] == 3
        assert data["yes_pct"] == 62.5
        assert data["no_pct"] == 37.5


# ============================================================================
# get_question_aggregate TESTS — choice types
# ============================================================================

class TestAggregateChoice:
    """Tests for single_choice and multi_choice response types."""

    @patch("app.services.aggregation.get_db_connection")
    def test_single_choice_returns_option_counts(self, mock_db, service):
        """Should return counts from QuestionOptions for single_choice."""
        cur = MagicMock()
        cur.fetchone.side_effect = [
            {"QuestionID": 4, "QuestionContent": "Fav color?",
             "ResponseType": "single_choice", "Category": "prefs"},
            {"cnt": 10},
        ]
        # fetchall calls: responses, then options
        cur.fetchall.side_effect = [
            # Responses
            [{"ResponseValue": "Red"}, {"ResponseValue": "Blue"},
             {"ResponseValue": "Red"}, {"ResponseValue": "Red"},
             {"ResponseValue": "Blue"}, {"ResponseValue": "Red"},
             {"ResponseValue": "Red"}, {"ResponseValue": "Blue"},
             {"ResponseValue": "Red"}, {"ResponseValue": "Blue"}],
            # QuestionOptions query
            [{"OptionText": "Red"}, {"OptionText": "Blue"}, {"OptionText": "Green"}],
        ]
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_question_aggregate(1, 4)

        data = result["data"]
        opts = {o["option"]: o for o in data["options"]}
        assert opts["Red"]["count"] == 6
        assert opts["Blue"]["count"] == 4
        assert opts["Green"]["count"] == 0
        # Green has 0 < K, so should be suppressed
        assert opts["Green"].get("suppressed") is True

    @patch("app.services.aggregation.get_db_connection")
    def test_multi_choice_parses_json_array(self, mock_db, service):
        """Should parse JSON array values for multi_choice responses."""
        _set_k5()  # Fatigue count=4 must be below k to verify suppression
        cur = MagicMock()
        cur.fetchone.side_effect = [
            {"QuestionID": 5, "QuestionContent": "Select symptoms",
             "ResponseType": "multi_choice", "Category": "health"},
            {"cnt": 6},
        ]
        cur.fetchall.side_effect = [
            # Responses (JSON arrays)
            [{"ResponseValue": '["Headache", "Fatigue"]'},
             {"ResponseValue": '["Headache", "Nausea"]'},
             {"ResponseValue": '["Fatigue"]'},
             {"ResponseValue": '["Headache", "Fatigue", "Nausea"]'},
             {"ResponseValue": '["Headache", "Fatigue"]'},
             {"ResponseValue": '["Headache"]'}],
            # QuestionOptions
            [{"OptionText": "Headache"}, {"OptionText": "Fatigue"}, {"OptionText": "Nausea"}],
        ]
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_question_aggregate(1, 5)

        data = result["data"]
        opts = {o["option"]: o for o in data["options"]}
        assert opts["Headache"]["count"] == 5  # meets K
        assert opts["Fatigue"]["count"] == 4   # under K
        assert opts["Fatigue"].get("suppressed") is True
        assert data["total_respondents"] == 6


# ============================================================================
# get_question_aggregate TESTS — openended type
# ============================================================================

class TestAggregateOpenEnded:
    """Tests for openended response type — no text content exposed."""

    @patch("app.services.aggregation.get_db_connection")
    def test_openended_returns_empty_data(self, mock_db, service):
        """Should return empty data dict (no text exposed for privacy)."""
        cur = MagicMock()
        cur.fetchone.side_effect = [
            {"QuestionID": 6, "QuestionContent": "Additional comments?",
             "ResponseType": "openended", "Category": None},
            {"cnt": 10},
        ]
        cur.fetchall.return_value = [
            {"ResponseValue": "Some private text"}, {"ResponseValue": "More text"},
            {"ResponseValue": "Text 3"}, {"ResponseValue": "Text 4"},
            {"ResponseValue": "Text 5"}, {"ResponseValue": "Text 6"},
            {"ResponseValue": "Text 7"}, {"ResponseValue": "Text 8"},
            {"ResponseValue": "Text 9"}, {"ResponseValue": "Text 10"},
        ]
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_question_aggregate(1, 6)

        assert result["suppressed"] is False
        assert result["response_count"] == 10
        assert result["data"] == {}
        # Ensure no text content leaked
        assert "Some private text" not in str(result)


# ============================================================================
# SUPPRESSION TESTS
# ============================================================================

class TestKAnonymitySuppression:
    """Tests for k-anonymity enforcement."""

    @patch("app.services.aggregation.get_db_connection")
    def test_question_suppressed_under_threshold(self, mock_db, service):
        """Question with < K responses should be suppressed."""
        _set_k5()  # cnt=3 must be below k
        cur = MagicMock()
        cur.fetchone.side_effect = [
            {"QuestionID": 7, "QuestionContent": "Q?",
             "ResponseType": "yesno", "Category": "test"},
            {"cnt": 3},  # only 3 responses
        ]
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_question_aggregate(1, 7)

        assert result["suppressed"] is True
        assert result["reason"] == "insufficient_responses"
        assert result["data"] is None

    @patch("app.services.aggregation.get_db_connection")
    def test_choice_option_suppressed_under_threshold(self, mock_db, service):
        """Individual choice option with < K selections should be marked suppressed."""
        _set_k5()  # B count=1 must be below k to verify per-option suppression
        cur = MagicMock()
        cur.fetchone.side_effect = [
            {"QuestionID": 8, "QuestionContent": "Pick one",
             "ResponseType": "single_choice", "Category": "test"},
            {"cnt": 8},
        ]
        cur.fetchall.side_effect = [
            # 7 chose A, 1 chose B
            [{"ResponseValue": "A"}] * 7 + [{"ResponseValue": "B"}],
            # Options
            [{"OptionText": "A"}, {"OptionText": "B"}],
        ]
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_question_aggregate(1, 8)

        opts = {o["option"]: o for o in result["data"]["options"]}
        assert "suppressed" not in opts["A"]  # 7 >= K
        assert opts["B"].get("suppressed") is True  # 1 < K

    @patch("app.services.aggregation.get_db_connection")
    def test_nonexistent_question_returns_none(self, mock_db, service):
        """Question not in survey should return None."""
        cur = MagicMock()
        cur.fetchone.return_value = None  # not found
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_question_aggregate(1, 999)

        assert result is None


# ============================================================================
# get_survey_aggregates FILTER TESTS
# ============================================================================

class TestSurveyAggregatesFilters:
    """Tests for get_survey_aggregates with filters."""

    @patch("app.services.aggregation.get_db_connection")
    def test_category_filter(self, mock_db, service):
        """Should filter questions by category."""
        # Connection for get_survey_aggregates
        outer_cur = MagicMock()
        outer_cur.fetchone.side_effect = [
            {"SurveyID": 1, "Title": "Survey"},
            {"cnt": 10},
        ]
        outer_cur.fetchall.return_value = [
            {"QuestionID": 1, "QuestionContent": "Q1",
             "ResponseType": "yesno", "Category": "health"},
        ]
        outer_conn = MagicMock()
        outer_conn.cursor.return_value = outer_cur

        # Connection for get_question_aggregate (called for each question)
        inner_cur = MagicMock()
        inner_cur.fetchone.side_effect = [
            {"QuestionID": 1, "QuestionContent": "Q1",
             "ResponseType": "yesno", "Category": "health"},
            {"cnt": 6},
        ]
        inner_cur.fetchall.return_value = [
            {"ResponseValue": "yes"}, {"ResponseValue": "no"},
            {"ResponseValue": "yes"}, {"ResponseValue": "yes"},
            {"ResponseValue": "no"}, {"ResponseValue": "yes"},
        ]
        inner_conn = MagicMock()
        inner_conn.cursor.return_value = inner_cur

        mock_db.side_effect = [outer_conn, inner_conn]

        result = service.get_survey_aggregates(1, category="health")

        assert result is not None
        assert len(result["aggregates"]) == 1
        # Verify the category filter was passed to the SQL
        executed_query = outer_cur.execute.call_args_list[-1][0][0]
        assert "Category = %s" in executed_query

    @patch("app.services.aggregation.get_db_connection")
    def test_response_type_filter(self, mock_db, service):
        """Should filter questions by response_type."""
        outer_cur = MagicMock()
        outer_cur.fetchone.side_effect = [
            {"SurveyID": 1, "Title": "Survey"},
            {"cnt": 10},
        ]
        outer_cur.fetchall.return_value = []  # no matching questions
        outer_conn = MagicMock()
        outer_conn.cursor.return_value = outer_cur
        mock_db.return_value = outer_conn

        result = service.get_survey_aggregates(1, response_type="yesno")

        assert result is not None
        executed_query = outer_cur.execute.call_args_list[-1][0][0]
        assert "ResponseType = %s" in executed_query


# ============================================================================
# get_csv_export TESTS
# ============================================================================

class TestCsvExport:
    """Tests for CSV export output."""

    @patch("app.services.aggregation.get_db_connection")
    def test_csv_has_correct_columns(self, mock_db, service):
        """CSV should have Question, Type, Category, Responses, Suppressed columns."""
        # Outer connection (get_survey_aggregates)
        outer_cur = MagicMock()
        outer_cur.fetchone.side_effect = [
            {"SurveyID": 1, "Title": "Survey"},
            {"cnt": 10},
        ]
        outer_cur.fetchall.return_value = [
            {"QuestionID": 1, "QuestionContent": "Rate pain",
             "ResponseType": "number", "Category": "health"},
        ]
        outer_conn = MagicMock()
        outer_conn.cursor.return_value = outer_cur

        # Inner connection (get_question_aggregate)
        inner_cur = MagicMock()
        inner_cur.fetchone.side_effect = [
            {"QuestionID": 1, "QuestionContent": "Rate pain",
             "ResponseType": "number", "Category": "health"},
            {"cnt": 6},
        ]
        inner_cur.fetchall.return_value = [
            {"ResponseValue": "1"}, {"ResponseValue": "3"},
            {"ResponseValue": "5"}, {"ResponseValue": "7"},
            {"ResponseValue": "2"}, {"ResponseValue": "4"},
        ]
        inner_conn = MagicMock()
        inner_conn.cursor.return_value = inner_cur

        mock_db.side_effect = [outer_conn, inner_conn]

        csv_str = service.get_csv_export(1)

        assert csv_str is not None
        lines = csv_str.strip().split("\n")
        header = lines[0]
        assert "Question" in header
        assert "Type" in header
        assert "Category" in header
        assert "Responses" in header
        assert "Min" in header
        assert "Max" in header
        assert "Mean" in header
        # Data row should exist
        assert len(lines) >= 2

    @patch("app.services.aggregation.get_db_connection")
    def test_csv_suppressed_row_no_aggregate_columns(self, mock_db, service):
        """Suppressed rows should not have aggregate stat values."""
        _set_k5()  # inner cnt=2 must be below k
        outer_cur = MagicMock()
        outer_cur.fetchone.side_effect = [
            {"SurveyID": 1, "Title": "Survey"},
            {"cnt": 10},
        ]
        outer_cur.fetchall.return_value = [
            {"QuestionID": 1, "QuestionContent": "Q1",
             "ResponseType": "yesno", "Category": "test"},
        ]
        outer_conn = MagicMock()
        outer_conn.cursor.return_value = outer_cur

        # Inner: under threshold
        inner_cur = MagicMock()
        inner_cur.fetchone.side_effect = [
            {"QuestionID": 1, "QuestionContent": "Q1",
             "ResponseType": "yesno", "Category": "test"},
            {"cnt": 2},  # under K
        ]
        inner_conn = MagicMock()
        inner_conn.cursor.return_value = inner_cur

        mock_db.side_effect = [outer_conn, inner_conn]

        csv_str = service.get_csv_export(1)

        assert csv_str is not None
        assert "True" in csv_str  # Suppressed column = True

    @patch("app.services.aggregation.get_db_connection")
    def test_csv_returns_none_for_nonexistent_survey(self, mock_db, service):
        """Should return None when survey doesn't exist."""
        cur = MagicMock()
        cur.fetchone.return_value = None
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_csv_export(999)

        assert result is None


# ============================================================================
# PRIVACY TESTS
# ============================================================================

class TestPrivacy:
    """Ensure individual ResponseValue rows are NEVER returned."""

    @patch("app.services.aggregation.get_db_connection")
    def test_no_individual_values_in_overview(self, mock_db, service):
        """get_survey_overview should never contain individual response values."""
        cur = MagicMock()
        cur.fetchone.side_effect = [
            {"SurveyID": 1, "Title": "Survey"},
            {"cnt": 10},
            {"cnt": 3},
            {"total_assigned": 15, "completed": 10},
        ]
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_survey_overview(1)

        result_str = str(result)
        assert "ResponseValue" not in result_str
        assert "ParticipantID" not in result_str

    def test_k_anonymity_threshold_is_1(self):
        """K_ANONYMITY_THRESHOLD default should be 1 (admin can raise it in settings)."""
        assert K_ANONYMITY_THRESHOLD == 1


# ============================================================================
# _anonymize_id TESTS
# ============================================================================

class TestAnonymizeId:
    """Tests for participant ID anonymization."""

    def test_deterministic_same_inputs(self, service):
        """Same participant should produce same anonymous ID."""
        id1 = service._anonymize_id_cross(42)
        id2 = service._anonymize_id_cross(42)
        assert id1 == id2

    def test_different_participants_different_ids(self, service):
        """Different participants should have different IDs."""
        id1 = service._anonymize_id_cross(1)
        id2 = service._anonymize_id_cross(2)
        assert id1 != id2

    def test_same_participant_same_id_across_surveys(self, service):
        """Same participant should have the same ID regardless of survey."""
        id1 = service._anonymize_id_cross(42)
        id2 = service._anonymize_id_cross(42)
        assert id1 == id2

    def test_format_starts_with_x_prefix(self, service):
        """Anonymous ID should start with 'X-' followed by hex chars."""
        anon_id = service._anonymize_id_cross(1)
        assert anon_id.startswith("X-")
        assert len(anon_id) == 10  # "X-" + 8 hex chars

    def test_no_participant_id_in_output(self, service):
        """Output should not contain the raw participant ID."""
        anon_id = service._anonymize_id_cross(12345)
        assert "12345" not in anon_id


# ============================================================================
# get_individual_responses TESTS
# ============================================================================

class TestGetIndividualResponses:
    """Tests for AggregationService.get_individual_responses."""

    @patch("app.services.aggregation.get_db_connection")
    def test_returns_individual_rows_with_anonymous_ids(self, mock_db, service):
        """Should return one row per participant with anonymized IDs."""
        cur = MagicMock()
        cur.fetchone.side_effect = [
            {"SurveyID": 1, "Title": "Health Survey"},
            {"cnt": 6},  # 6 respondents >= K
        ]
        cur.fetchall.side_effect = [
            # Questions
            [
                {"QuestionID": 1, "QuestionContent": "Age?", "ResponseType": "number", "Category": "demographics"},
                {"QuestionID": 2, "QuestionContent": "Exercise?", "ResponseType": "yesno", "Category": "lifestyle"},
            ],
            # Responses
            [
                {"ParticipantID": 101, "QuestionID": 1, "ResponseValue": "25"},
                {"ParticipantID": 101, "QuestionID": 2, "ResponseValue": "Yes"},
                {"ParticipantID": 102, "QuestionID": 1, "ResponseValue": "30"},
                {"ParticipantID": 102, "QuestionID": 2, "ResponseValue": "No"},
                {"ParticipantID": 103, "QuestionID": 1, "ResponseValue": "45"},
                {"ParticipantID": 103, "QuestionID": 2, "ResponseValue": "Yes"},
                {"ParticipantID": 104, "QuestionID": 1, "ResponseValue": "22"},
                {"ParticipantID": 104, "QuestionID": 2, "ResponseValue": "No"},
                {"ParticipantID": 105, "QuestionID": 1, "ResponseValue": "35"},
                {"ParticipantID": 105, "QuestionID": 2, "ResponseValue": "Yes"},
                {"ParticipantID": 106, "QuestionID": 1, "ResponseValue": "28"},
                {"ParticipantID": 106, "QuestionID": 2, "ResponseValue": "No"},
            ],
            [],  # _fetch_demographics
        ]
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_individual_responses(1)

        assert result is not None
        assert result["survey_id"] == 1
        assert result["title"] == "Health Survey"
        assert result["respondent_count"] == 6
        assert result["suppressed"] is False
        assert len(result["questions"]) == 2
        assert len(result["rows"]) == 6

        # Check anonymous IDs are present and consistent
        row_0 = result["rows"][0]
        assert row_0["anonymous_id"].startswith("X-")
        assert "1" in row_0["responses"]  # question_id as string key
        assert "2" in row_0["responses"]

    @patch("app.services.aggregation.get_db_connection")
    def test_suppressed_when_under_threshold(self, mock_db, service):
        """Should suppress data when fewer than K respondents."""
        _set_k5()  # cnt=3 must be below k
        cur = MagicMock()
        cur.fetchone.side_effect = [
            {"SurveyID": 1, "Title": "Small Survey"},
            {"cnt": 3},  # only 3 respondents
        ]
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_individual_responses(1)

        assert result["suppressed"] is True
        assert result["reason"] == "insufficient_responses"
        assert result["questions"] == []
        assert result["rows"] == []

    @patch("app.services.aggregation.get_db_connection")
    def test_returns_none_for_nonexistent_survey(self, mock_db, service):
        """Should return None when survey does not exist."""
        cur = MagicMock()
        cur.fetchone.return_value = None
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_individual_responses(999)
        assert result is None

    @patch("app.services.aggregation.get_db_connection")
    def test_category_filter(self, mock_db, service):
        """Should filter questions by category."""
        cur = MagicMock()
        cur.fetchone.side_effect = [
            {"SurveyID": 1, "Title": "Survey"},
            {"cnt": 6},
        ]
        cur.fetchall.side_effect = [
            # Only demographics questions returned (filtered)
            [{"QuestionID": 1, "QuestionContent": "Age?", "ResponseType": "number", "Category": "demographics"}],
            # Responses
            [
                {"ParticipantID": 101, "QuestionID": 1, "ResponseValue": "25"},
                {"ParticipantID": 102, "QuestionID": 1, "ResponseValue": "30"},
                {"ParticipantID": 103, "QuestionID": 1, "ResponseValue": "45"},
                {"ParticipantID": 104, "QuestionID": 1, "ResponseValue": "22"},
                {"ParticipantID": 105, "QuestionID": 1, "ResponseValue": "35"},
                {"ParticipantID": 106, "QuestionID": 1, "ResponseValue": "28"},
            ],
            [],  # _fetch_demographics
        ]
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_individual_responses(1, category="demographics")

        assert len(result["questions"]) == 1
        assert result["questions"][0]["category"] == "demographics"
        # Verify category filter was in the SQL
        executed_query = cur.execute.call_args_list[2][0][0]
        assert "Category = %s" in executed_query

    @patch("app.services.aggregation.get_db_connection")
    def test_response_type_filter(self, mock_db, service):
        """Should filter questions by response_type."""
        cur = MagicMock()
        cur.fetchone.side_effect = [
            {"SurveyID": 1, "Title": "Survey"},
            {"cnt": 6},
        ]
        cur.fetchall.side_effect = [
            [{"QuestionID": 2, "QuestionContent": "Exercise?", "ResponseType": "yesno", "Category": "lifestyle"}],
            [
                {"ParticipantID": 101, "QuestionID": 2, "ResponseValue": "Yes"},
                {"ParticipantID": 102, "QuestionID": 2, "ResponseValue": "No"},
                {"ParticipantID": 103, "QuestionID": 2, "ResponseValue": "Yes"},
                {"ParticipantID": 104, "QuestionID": 2, "ResponseValue": "No"},
                {"ParticipantID": 105, "QuestionID": 2, "ResponseValue": "Yes"},
                {"ParticipantID": 106, "QuestionID": 2, "ResponseValue": "No"},
            ],
            [],  # _fetch_demographics
        ]
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_individual_responses(1, response_type="yesno")

        assert len(result["questions"]) == 1
        assert result["questions"][0]["response_type"] == "yesno"
        executed_query = cur.execute.call_args_list[2][0][0]
        assert "ResponseType = %s" in executed_query

    @patch("app.services.aggregation.get_db_connection")
    def test_includes_openended_responses(self, mock_db, service):
        """Open-ended text responses should be included in individual data."""
        cur = MagicMock()
        cur.fetchone.side_effect = [
            {"SurveyID": 1, "Title": "Survey"},
            {"cnt": 5},
        ]
        cur.fetchall.side_effect = [
            [{"QuestionID": 1, "QuestionContent": "Comments?", "ResponseType": "openended", "Category": None}],
            [
                {"ParticipantID": 101, "QuestionID": 1, "ResponseValue": "Great survey"},
                {"ParticipantID": 102, "QuestionID": 1, "ResponseValue": "No comment"},
                {"ParticipantID": 103, "QuestionID": 1, "ResponseValue": "Interesting"},
                {"ParticipantID": 104, "QuestionID": 1, "ResponseValue": "N/A"},
                {"ParticipantID": 105, "QuestionID": 1, "ResponseValue": "Thanks"},
            ],
            [],  # _fetch_demographics
        ]
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_individual_responses(1)

        assert result["suppressed"] is False
        assert len(result["rows"]) == 5
        # Open-ended text should be in the response values
        values = [row["responses"]["1"] for row in result["rows"]]
        assert "Great survey" in values

    @patch("app.services.aggregation.get_db_connection")
    def test_no_raw_participant_ids_in_result(self, mock_db, service):
        """Result should not contain raw ParticipantID values."""
        cur = MagicMock()
        cur.fetchone.side_effect = [
            {"SurveyID": 1, "Title": "Survey"},
            {"cnt": 5},
        ]
        cur.fetchall.side_effect = [
            [{"QuestionID": 1, "QuestionContent": "Q?", "ResponseType": "yesno", "Category": None}],
            [
                {"ParticipantID": 12345, "QuestionID": 1, "ResponseValue": "Yes"},
                {"ParticipantID": 12346, "QuestionID": 1, "ResponseValue": "No"},
                {"ParticipantID": 12347, "QuestionID": 1, "ResponseValue": "Yes"},
                {"ParticipantID": 12348, "QuestionID": 1, "ResponseValue": "No"},
                {"ParticipantID": 12349, "QuestionID": 1, "ResponseValue": "Yes"},
            ],
            [],  # _fetch_demographics
        ]
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_individual_responses(1)

        result_str = str(result)
        assert "12345" not in result_str
        assert "12346" not in result_str
        assert "ParticipantID" not in result_str


# ============================================================================
# get_individual_csv_export TESTS
# ============================================================================

class TestIndividualCsvExport:
    """Tests for individual response CSV export."""

    @patch("app.services.aggregation.get_db_connection")
    def test_csv_has_anonymous_id_and_question_columns(self, mock_db, service):
        """CSV should have Anonymous ID as first column, questions as remaining columns."""
        cur = MagicMock()
        cur.fetchone.side_effect = [
            {"SurveyID": 1, "Title": "Survey"},
            {"cnt": 5},
        ]
        cur.fetchall.side_effect = [
            [
                {"QuestionID": 1, "QuestionContent": "Age?", "ResponseType": "number", "Category": "demographics"},
                {"QuestionID": 2, "QuestionContent": "Exercise?", "ResponseType": "yesno", "Category": "lifestyle"},
            ],
            [
                {"ParticipantID": 101, "QuestionID": 1, "ResponseValue": "25"},
                {"ParticipantID": 101, "QuestionID": 2, "ResponseValue": "Yes"},
                {"ParticipantID": 102, "QuestionID": 1, "ResponseValue": "30"},
                {"ParticipantID": 102, "QuestionID": 2, "ResponseValue": "No"},
                {"ParticipantID": 103, "QuestionID": 1, "ResponseValue": "45"},
                {"ParticipantID": 103, "QuestionID": 2, "ResponseValue": "Yes"},
                {"ParticipantID": 104, "QuestionID": 1, "ResponseValue": "22"},
                {"ParticipantID": 104, "QuestionID": 2, "ResponseValue": "No"},
                {"ParticipantID": 105, "QuestionID": 1, "ResponseValue": "35"},
                {"ParticipantID": 105, "QuestionID": 2, "ResponseValue": "Yes"},
            ],
            [],  # _fetch_demographics
        ]
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        csv_str = service.get_individual_csv_export(1)

        assert csv_str is not None
        lines = csv_str.strip().split("\n")
        header = lines[3]
        assert "Anonymous ID" in header
        assert "Age?" in header
        assert "Exercise?" in header
        # Should have header + 5 data rows
        assert len(lines) == 9

    @patch("app.services.aggregation.get_db_connection")
    def test_csv_suppressed_message(self, mock_db, service):
        """CSV should return suppression message when < K respondents."""
        _set_k5()  # cnt=2 must be below k
        cur = MagicMock()
        cur.fetchone.side_effect = [
            {"SurveyID": 1, "Title": "Survey"},
            {"cnt": 2},
        ]
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        csv_str = service.get_individual_csv_export(1)

        assert "suppressed" in csv_str.lower()

    @patch("app.services.aggregation.get_db_connection")
    def test_csv_returns_none_for_nonexistent(self, mock_db, service):
        """Should return None for nonexistent survey."""
        cur = MagicMock()
        cur.fetchone.return_value = None
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        result = service.get_individual_csv_export(999)
        assert result is None

    @patch("app.services.aggregation.get_db_connection")
    def test_csv_no_raw_participant_ids(self, mock_db, service):
        """CSV content should not contain raw participant IDs."""
        cur = MagicMock()
        cur.fetchone.side_effect = [
            {"SurveyID": 1, "Title": "Survey"},
            {"cnt": 5},
        ]
        cur.fetchall.side_effect = [
            [{"QuestionID": 1, "QuestionContent": "Q?", "ResponseType": "yesno", "Category": None}],
            [
                {"ParticipantID": 99901, "QuestionID": 1, "ResponseValue": "Yes"},
                {"ParticipantID": 99902, "QuestionID": 1, "ResponseValue": "No"},
                {"ParticipantID": 99903, "QuestionID": 1, "ResponseValue": "Yes"},
                {"ParticipantID": 99904, "QuestionID": 1, "ResponseValue": "No"},
                {"ParticipantID": 99905, "QuestionID": 1, "ResponseValue": "Yes"},
            ],
            [],  # _fetch_demographics
        ]
        conn = MagicMock()
        conn.cursor.return_value = cur
        mock_db.return_value = conn

        csv_str = service.get_individual_csv_export(1)

        assert "99901" not in csv_str
        assert "99902" not in csv_str
