# Created with the Assistance of Claude Code
# backend/tests/api/test_research.py
"""
Tests for Research Data API endpoints in app/api/v1/research.py.

Tests cover:
- GET /api/v1/research/surveys — list surveys with response counts
- GET /api/v1/research/surveys/{id}/overview — survey overview
- GET /api/v1/research/surveys/{id}/aggregates — aggregates with filters
- GET /api/v1/research/surveys/{id}/aggregates/{qid} — single question
- GET /api/v1/research/surveys/{id}/export/csv — CSV download
- GET /api/v1/research/cross-survey/overview — cross-survey overview
- GET /api/v1/research/cross-survey/responses — cross-survey responses
- GET /api/v1/research/cross-survey/export/csv — cross-survey CSV
- Auth: 401 without token, 403 for participant, 200 for researcher/admin
"""

import pytest
from unittest.mock import patch, MagicMock
from fastapi.testclient import TestClient

from app.main import app
from app.api.deps import get_current_user


@pytest.fixture(autouse=True)
def clear_auth_override():
    """Remove the conftest mock_auth override so real auth is tested."""
    app.dependency_overrides.pop(get_current_user, None)
    yield


@pytest.fixture
def client():
    return TestClient(app)


def _mock_researcher_auth(mock_db):
    """Set up mock for get_current_user as researcher (single DB connection)."""
    auth_cursor = MagicMock()
    auth_cursor.fetchone.return_value = {
        "AccountID": 10,
        "Email": "researcher@example.com",
        "TosAcceptedAt": "2026-01-01",
        "TosVersion": "1.0",
        "RoleID": 2,
        "ViewingAsUserID": None,
    }
    auth_conn = MagicMock()
    auth_conn.cursor.return_value = auth_cursor

    return [auth_conn]


def _mock_participant_auth(mock_db):
    """Set up mock for get_current_user as participant (denied by require_role)."""
    auth_cursor = MagicMock()
    auth_cursor.fetchone.return_value = {
        "AccountID": 20,
        "Email": "participant@example.com",
        "TosAcceptedAt": "2026-01-01",
        "TosVersion": "1.0",
        "RoleID": 1,
        "ViewingAsUserID": None,
    }
    auth_conn = MagicMock()
    auth_conn.cursor.return_value = auth_cursor

    return [auth_conn]


# ============================================================================
# AUTH TESTS — apply to all endpoints
# ============================================================================

class TestResearchAuth:
    """Auth enforcement on all research endpoints."""

    def test_no_token_returns_401(self, client):
        """All endpoints return 401 without Authorization header."""
        endpoints = [
            "/api/v1/research/surveys",
            "/api/v1/research/surveys/1/overview",
            "/api/v1/research/surveys/1/aggregates",
            "/api/v1/research/surveys/1/aggregates/1",
            "/api/v1/research/surveys/1/export/csv",
        ]
        for endpoint in endpoints:
            response = client.get(endpoint)
            assert response.status_code == 401, f"Expected 401 for {endpoint}"

    @patch("app.api.deps.get_db_connection")
    def test_participant_gets_403(self, mock_db, client):
        """Participant (RoleID=1) should be denied on research endpoints."""
        mock_db.side_effect = _mock_participant_auth(mock_db)

        response = client.get(
            "/api/v1/research/surveys",
            headers={"Authorization": "Bearer participant_token"},
        )

        assert response.status_code == 403

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research.get_db_connection")
    def test_researcher_allowed(self, mock_research_db, mock_deps_db, client):
        """Researcher (RoleID=2) should access research endpoints."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)

        # Mock the research endpoint DB call
        research_cursor = MagicMock()
        research_cursor.fetchall.return_value = []
        research_conn = MagicMock()
        research_conn.cursor.return_value = research_cursor
        mock_research_db.return_value = research_conn

        response = client.get(
            "/api/v1/research/surveys",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200


# ============================================================================
# GET /surveys TESTS
# ============================================================================

class TestListSurveys:
    """Tests for GET /api/v1/research/surveys."""

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research.get_db_connection")
    def test_returns_survey_list(self, mock_research_db, mock_deps_db, client):
        """Should return list of surveys with response counts."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)

        research_cursor = MagicMock()
        research_cursor.fetchall.return_value = [
            {"SurveyID": 1, "Title": "Health Survey", "PublicationStatus": "published",
             "response_count": 42, "question_count": 10},
            {"SurveyID": 2, "Title": "Sleep Survey", "PublicationStatus": "draft",
             "response_count": 0, "question_count": 5},
        ]
        research_conn = MagicMock()
        research_conn.cursor.return_value = research_cursor
        mock_research_db.return_value = research_conn

        response = client.get(
            "/api/v1/research/surveys",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 2
        assert data[0]["survey_id"] == 1
        assert data[0]["response_count"] == 42

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research.get_db_connection")
    def test_returns_empty_list(self, mock_research_db, mock_deps_db, client):
        """Should return empty list when no surveys exist."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)

        research_cursor = MagicMock()
        research_cursor.fetchall.return_value = []
        research_conn = MagicMock()
        research_conn.cursor.return_value = research_cursor
        mock_research_db.return_value = research_conn

        response = client.get(
            "/api/v1/research/surveys",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        assert response.json() == []

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research.get_db_connection")
    def test_response_count_uses_participant_id(self, mock_research_db, mock_deps_db, client):
        """response_count must COUNT(DISTINCT ParticipantID), not ResponseID."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)

        research_cursor = MagicMock()
        research_cursor.fetchall.return_value = [
            {"SurveyID": 1, "Title": "S", "PublicationStatus": "published",
             "response_count": 5, "question_count": 10},
        ]
        research_conn = MagicMock()
        research_conn.cursor.return_value = research_cursor
        mock_research_db.return_value = research_conn

        response = client.get(
            "/api/v1/research/surveys",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        # Verify the SQL query counts distinct participants, not response rows
        executed_sql = research_cursor.execute.call_args[0][0]
        assert "COUNT(DISTINCT r.ParticipantID)" in executed_sql
        assert "COUNT(DISTINCT r.ResponseID)" not in executed_sql


# ============================================================================
# GET /surveys/{id}/overview TESTS
# ============================================================================

class TestSurveyOverview:
    """Tests for GET /api/v1/research/surveys/{id}/overview."""

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_returns_overview(self, mock_agg, mock_deps_db, client):
        """Should return survey overview stats."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_survey_overview.return_value = {
            "survey_id": 1, "title": "Health Survey",
            "respondent_count": 25, "completion_rate": 80.0,
            "question_count": 10, "suppressed": False,
        }

        response = client.get(
            "/api/v1/research/surveys/1/overview",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        data = response.json()
        assert data["respondent_count"] == 25
        assert data["suppressed"] is False

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_returns_404_for_nonexistent(self, mock_agg, mock_deps_db, client):
        """Should return 404 for nonexistent survey."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_survey_overview.return_value = None

        response = client.get(
            "/api/v1/research/surveys/999/overview",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 404


# ============================================================================
# GET /surveys/{id}/aggregates TESTS
# ============================================================================

class TestSurveyAggregates:
    """Tests for GET /api/v1/research/surveys/{id}/aggregates."""

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_returns_aggregates(self, mock_agg, mock_deps_db, client):
        """Should return all question aggregates."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_survey_aggregates.return_value = {
            "survey_id": 1, "title": "Survey", "total_respondents": 20,
            "aggregates": [
                {"question_id": 1, "question_content": "Q1?",
                 "response_type": "yesno", "category": "health",
                 "response_count": 20, "suppressed": False,
                 "data": {"yes_count": 15, "no_count": 5, "yes_pct": 75.0, "no_pct": 25.0}},
            ],
        }

        response = client.get(
            "/api/v1/research/surveys/1/aggregates",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        data = response.json()
        assert data["total_respondents"] == 20
        assert len(data["aggregates"]) == 1

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_passes_category_filter(self, mock_agg, mock_deps_db, client):
        """Should pass category query param to aggregation service."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_survey_aggregates.return_value = {
            "survey_id": 1, "title": "Survey", "total_respondents": 10,
            "aggregates": [],
        }

        response = client.get(
            "/api/v1/research/surveys/1/aggregates?category=health",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        mock_agg.get_survey_aggregates.assert_called_once_with(
            1, category="health", response_type=None
        )

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_passes_response_type_filter(self, mock_agg, mock_deps_db, client):
        """Should pass response_type query param to aggregation service."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_survey_aggregates.return_value = {
            "survey_id": 1, "title": "Survey", "total_respondents": 10,
            "aggregates": [],
        }

        response = client.get(
            "/api/v1/research/surveys/1/aggregates?response_type=yesno",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        mock_agg.get_survey_aggregates.assert_called_once_with(
            1, category=None, response_type="yesno"
        )


# ============================================================================
# GET /surveys/{id}/aggregates/{qid} TESTS
# ============================================================================

class TestQuestionAggregate:
    """Tests for GET /api/v1/research/surveys/{id}/aggregates/{qid}."""

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_returns_single_question(self, mock_agg, mock_deps_db, client):
        """Should return aggregate for a single question."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_question_aggregate.return_value = {
            "question_id": 5, "question_content": "Pain level?",
            "response_type": "scale", "category": "health",
            "response_count": 15, "suppressed": False,
            "data": {"min": 1.0, "max": 10.0, "mean": 5.5, "median": 5.0, "std_dev": 2.1},
        }

        response = client.get(
            "/api/v1/research/surveys/1/aggregates/5",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        data = response.json()
        assert data["question_id"] == 5
        assert data["data"]["mean"] == 5.5

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_returns_404_for_nonexistent_question(self, mock_agg, mock_deps_db, client):
        """Should return 404 for question not in survey."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_question_aggregate.return_value = None

        response = client.get(
            "/api/v1/research/surveys/1/aggregates/999",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 404


# ============================================================================
# GET /surveys/{id}/export/csv TESTS
# ============================================================================

class TestIndividualResponses:
    """Tests for GET /api/v1/research/surveys/{id}/responses."""

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_returns_individual_rows(self, mock_agg, mock_deps_db, client):
        """Should return individual anonymized response rows."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_individual_responses.return_value = {
            "survey_id": 1, "title": "Health Survey",
            "respondent_count": 10, "suppressed": False,
            "questions": [
                {"question_id": 1, "question_content": "Age?",
                 "response_type": "number", "category": "demographics"},
            ],
            "rows": [
                {"anonymous_id": "R-abc12345", "responses": {"1": "25"}},
                {"anonymous_id": "R-def67890", "responses": {"1": "30"}},
            ],
        }

        response = client.get(
            "/api/v1/research/surveys/1/responses",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        data = response.json()
        assert data["respondent_count"] == 10
        assert data["suppressed"] is False
        assert len(data["questions"]) == 1
        assert len(data["rows"]) == 2
        assert data["rows"][0]["anonymous_id"] == "R-abc12345"

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_returns_suppressed_when_under_threshold(self, mock_agg, mock_deps_db, client):
        """Should return suppressed=True when < 5 respondents."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_individual_responses.return_value = {
            "survey_id": 1, "title": "Small Survey",
            "respondent_count": 3, "suppressed": True,
            "reason": "insufficient_responses",
            "questions": [], "rows": [],
        }

        response = client.get(
            "/api/v1/research/surveys/1/responses",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        data = response.json()
        assert data["suppressed"] is True
        assert data["rows"] == []

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_returns_404_for_nonexistent(self, mock_agg, mock_deps_db, client):
        """Should return 404 for nonexistent survey."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_individual_responses.return_value = None

        response = client.get(
            "/api/v1/research/surveys/999/responses",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 404

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_passes_filters(self, mock_agg, mock_deps_db, client):
        """Should pass category and response_type filters."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_individual_responses.return_value = {
            "survey_id": 1, "title": "Survey",
            "respondent_count": 10, "suppressed": False,
            "questions": [], "rows": [],
        }

        response = client.get(
            "/api/v1/research/surveys/1/responses?category=health&response_type=yesno",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        mock_agg.get_individual_responses.assert_called_once_with(
            1, category="health", response_type="yesno"
        )


class TestExportCsv:
    """Tests for GET /api/v1/research/surveys/{id}/export/csv."""

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_returns_csv_content_type(self, mock_agg, mock_deps_db, client):
        """Should return text/csv content type."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_individual_csv_export.return_value = "Anonymous ID,Age?\nR-abc12345,25\n"

        response = client.get(
            "/api/v1/research/surveys/1/export/csv",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        assert "text/csv" in response.headers["content-type"]
        assert "attachment" in response.headers.get("content-disposition", "")

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_csv_contains_individual_data(self, mock_agg, mock_deps_db, client):
        """Should return CSV with anonymous IDs and individual responses."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        csv_content = "Anonymous ID,Age?,Exercise?\nR-abc12345,25,Yes\nR-def67890,30,No\n"
        mock_agg.get_individual_csv_export.return_value = csv_content

        response = client.get(
            "/api/v1/research/surveys/1/export/csv",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        body = response.text
        assert "Anonymous ID" in body
        assert "R-abc12345" in body

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_csv_404_for_nonexistent(self, mock_agg, mock_deps_db, client):
        """Should return 404 for nonexistent survey."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_individual_csv_export.return_value = None

        response = client.get(
            "/api/v1/research/surveys/999/export/csv",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 404


# ============================================================================
# CROSS-SURVEY AUTH TESTS
# ============================================================================

class TestCrossSurveyAuth:
    """Auth enforcement on cross-survey endpoints."""

    def test_no_token_returns_401(self, client):
        """All cross-survey endpoints return 401 without Authorization header."""
        endpoints = [
            "/api/v1/research/cross-survey/overview?survey_ids=1",
            "/api/v1/research/cross-survey/responses?survey_ids=1",
            "/api/v1/research/cross-survey/export/csv?survey_ids=1",
        ]
        for endpoint in endpoints:
            response = client.get(endpoint)
            assert response.status_code == 401, f"Expected 401 for {endpoint}"

    @patch("app.api.deps.get_db_connection")
    def test_participant_gets_403(self, mock_db, client):
        """Participant (RoleID=1) should be denied on cross-survey endpoints."""
        mock_db.side_effect = _mock_participant_auth(mock_db)

        response = client.get(
            "/api/v1/research/cross-survey/overview?survey_ids=1",
            headers={"Authorization": "Bearer participant_token"},
        )

        assert response.status_code == 403


# ============================================================================
# CROSS-SURVEY OVERVIEW TESTS
# ============================================================================

class TestCrossSurveyOverview:
    """Tests for GET /api/v1/research/cross-survey/overview."""

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_returns_overview(self, mock_agg, mock_deps_db, client):
        """Should return cross-survey overview stats."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_cross_survey_overview.return_value = {
            "survey_ids": [1, 2],
            "surveys": [
                {"survey_id": 1, "title": "Health Survey", "respondent_count": 20},
                {"survey_id": 2, "title": "Sleep Survey", "respondent_count": 15},
            ],
            "total_respondent_count": 30,
            "total_question_count": 15,
            "avg_completion_rate": 85.0,
            "suppressed": False,
            "reason": None,
        }

        response = client.get(
            "/api/v1/research/cross-survey/overview?survey_ids=1&survey_ids=2",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        data = response.json()
        assert data["total_respondent_count"] == 30
        assert data["suppressed"] is False
        assert len(data["surveys"]) == 2

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_passes_date_filters(self, mock_agg, mock_deps_db, client):
        """Should pass date_from and date_to to aggregation service."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_cross_survey_overview.return_value = {
            "survey_ids": [1],
            "surveys": [{"survey_id": 1, "title": "Survey", "respondent_count": 10}],
            "total_respondent_count": 10,
            "total_question_count": 5,
            "avg_completion_rate": 100.0,
            "suppressed": False,
            "reason": None,
        }

        response = client.get(
            "/api/v1/research/cross-survey/overview?survey_ids=1&date_from=2026-01-01&date_to=2026-02-01",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        mock_agg.get_cross_survey_overview.assert_called_once_with(
            [1], date_from="2026-01-01", date_to="2026-02-01"
        )


# ============================================================================
# CROSS-SURVEY RESPONSES TESTS
# ============================================================================

class TestCrossSurveyResponses:
    """Tests for GET /api/v1/research/cross-survey/responses."""

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_returns_cross_survey_rows(self, mock_agg, mock_deps_db, client):
        """Should return merged rows from multiple surveys."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_cross_survey_responses.return_value = {
            "survey_ids": [1, 3],
            "surveys": [
                {"survey_id": 1, "title": "Health Survey", "respondent_count": 20},
                {"survey_id": 3, "title": "Lifestyle Survey", "respondent_count": 15},
            ],
            "total_respondent_count": 28,
            "suppressed": False,
            "suppressed_surveys": [],
            "date_from": None,
            "date_to": None,
            "questions": [
                {"question_id": 1, "question_content": "Age?",
                 "response_type": "number", "category": "demographics",
                 "survey_id": 1, "survey_title": "Health Survey"},
            ],
            "rows": [
                {"anonymous_id": "X-abc12345", "survey_id": 1,
                 "survey_title": "Health Survey", "responses": {"1": "25"}},
                {"anonymous_id": "X-def67890", "survey_id": 3,
                 "survey_title": "Lifestyle Survey", "responses": {"1": "30"}},
            ],
        }

        response = client.get(
            "/api/v1/research/cross-survey/responses?survey_ids=1&survey_ids=3",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        data = response.json()
        assert data["total_respondent_count"] == 28
        assert len(data["rows"]) == 2
        assert data["rows"][0]["anonymous_id"].startswith("X-")

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_returns_suppressed(self, mock_agg, mock_deps_db, client):
        """Should return suppressed=True when under threshold."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_cross_survey_responses.return_value = {
            "survey_ids": [1],
            "surveys": [],
            "total_respondent_count": 3,
            "suppressed": True,
            "reason": "insufficient_responses",
            "suppressed_surveys": [1],
            "date_from": None,
            "date_to": None,
            "questions": [],
            "rows": [],
        }

        response = client.get(
            "/api/v1/research/cross-survey/responses?survey_ids=1",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        data = response.json()
        assert data["suppressed"] is True
        assert data["rows"] == []

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_passes_all_filters(self, mock_agg, mock_deps_db, client):
        """Should pass category, response_type, date_from, date_to filters."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_cross_survey_responses.return_value = {
            "survey_ids": [1, 2],
            "surveys": [],
            "total_respondent_count": 0,
            "suppressed": False,
            "suppressed_surveys": [],
            "date_from": "2026-01-01",
            "date_to": "2026-02-01",
            "questions": [],
            "rows": [],
        }

        response = client.get(
            "/api/v1/research/cross-survey/responses"
            "?survey_ids=1&survey_ids=2"
            "&category=health&response_type=yesno"
            "&date_from=2026-01-01&date_to=2026-02-01",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        mock_agg.get_cross_survey_responses.assert_called_once_with(
            [1, 2],
            date_from="2026-01-01",
            date_to="2026-02-01",
            category="health",
            response_type="yesno",
            question_ids=None,
        )


# ============================================================================
# CROSS-SURVEY CSV EXPORT TESTS
# ============================================================================

class TestCrossSurveyCsvExport:
    """Tests for GET /api/v1/research/cross-survey/export/csv."""

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_returns_csv_content_type(self, mock_agg, mock_deps_db, client):
        """Should return text/csv content type."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_cross_survey_csv_export.return_value = (
            "Anonymous ID,Survey,Age?\nX-abc12345,Health,25\n"
        )

        response = client.get(
            "/api/v1/research/cross-survey/export/csv?survey_ids=1&survey_ids=2",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        assert "text/csv" in response.headers["content-type"]
        assert "attachment" in response.headers.get("content-disposition", "")
        assert "X-abc12345" in response.text

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_csv_404_when_none(self, mock_agg, mock_deps_db, client):
        """Should return 404 when no surveys found."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_cross_survey_csv_export.return_value = None

        response = client.get(
            "/api/v1/research/cross-survey/export/csv?survey_ids=999",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 404


# ============================================================================
# DATA BANK: NO SURVEY_IDS (ALL DATA) TESTS
# ============================================================================

class TestDataBankAllData:
    """Tests for data bank endpoints without survey_ids (returns all)."""

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_overview_no_survey_ids(self, mock_agg, mock_deps_db, client):
        """Overview endpoint should work without survey_ids."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_cross_survey_overview.return_value = {
            "survey_ids": [1, 2, 3],
            "surveys": [
                {"survey_id": 1, "title": "S1", "respondent_count": 10},
                {"survey_id": 2, "title": "S2", "respondent_count": 8},
            ],
            "total_respondent_count": 18,
            "total_question_count": 20,
            "avg_completion_rate": 75.0,
            "suppressed": False,
            "reason": None,
        }

        response = client.get(
            "/api/v1/research/cross-survey/overview",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        mock_agg.get_cross_survey_overview.assert_called_once_with(
            None, date_from=None, date_to=None
        )

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_responses_no_survey_ids(self, mock_agg, mock_deps_db, client):
        """Responses endpoint should work without survey_ids."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_cross_survey_responses.return_value = {
            "survey_ids": [1, 2],
            "surveys": [],
            "total_respondent_count": 10,
            "suppressed": False,
            "suppressed_surveys": [],
            "date_from": None,
            "date_to": None,
            "questions": [],
            "rows": [],
        }

        response = client.get(
            "/api/v1/research/cross-survey/responses",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        mock_agg.get_cross_survey_responses.assert_called_once_with(
            None,
            date_from=None,
            date_to=None,
            category=None,
            response_type=None,
            question_ids=None,
        )

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_responses_with_question_ids(self, mock_agg, mock_deps_db, client):
        """Responses endpoint should pass question_ids filter."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_cross_survey_responses.return_value = {
            "survey_ids": [1],
            "surveys": [],
            "total_respondent_count": 10,
            "suppressed": False,
            "suppressed_surveys": [],
            "date_from": None,
            "date_to": None,
            "questions": [],
            "rows": [],
        }

        response = client.get(
            "/api/v1/research/cross-survey/responses"
            "?question_ids=5&question_ids=10",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        mock_agg.get_cross_survey_responses.assert_called_once_with(
            None,
            date_from=None,
            date_to=None,
            category=None,
            response_type=None,
            question_ids=[5, 10],
        )


# ============================================================================
# DATA BANK: AVAILABLE QUESTIONS TESTS
# ============================================================================

class TestAvailableQuestions:
    """Tests for GET /api/v1/research/cross-survey/questions."""

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_returns_questions(self, mock_agg, mock_deps_db, client):
        """Should return list of available questions."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_available_questions.return_value = [
            {
                "question_id": 1,
                "question_content": "Blood Pressure",
                "response_type": "number",
                "category": "vitals",
                "survey_id": 1,
                "survey_title": "Health Survey",
            },
            {
                "question_id": 2,
                "question_content": "Mood Rating",
                "response_type": "scale",
                "category": "mental_health",
                "survey_id": 2,
                "survey_title": "Wellness Survey",
            },
        ]

        response = client.get(
            "/api/v1/research/cross-survey/questions",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        data = response.json()
        assert len(data) == 2
        assert data[0]["question_content"] == "Blood Pressure"
        assert data[1]["survey_title"] == "Wellness Survey"

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_filters_by_survey(self, mock_agg, mock_deps_db, client):
        """Should pass survey_ids filter to service."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_available_questions.return_value = []

        response = client.get(
            "/api/v1/research/cross-survey/questions?survey_ids=1",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        mock_agg.get_available_questions.assert_called_once_with(
            [1], category=None, response_type=None
        )


# ============================================================================
# DATA BANK: AGGREGATES TESTS
# ============================================================================

class TestCrossSurveyAggregates:
    """Tests for GET /api/v1/research/cross-survey/aggregates."""

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_returns_aggregates(self, mock_agg, mock_deps_db, client):
        """Should return aggregate data for charting."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_cross_survey_aggregates.return_value = {
            "survey_ids": [1, 2],
            "total_respondents": 25,
            "aggregates": [
                {
                    "question_id": 1,
                    "question_content": "Blood Pressure",
                    "response_type": "number",
                    "category": "vitals",
                    "response_count": 25,
                    "suppressed": False,
                    "data": {"mean": 120.5, "median": 118.0},
                },
            ],
        }

        response = client.get(
            "/api/v1/research/cross-survey/aggregates",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        data = response.json()
        assert data["total_respondents"] == 25
        assert len(data["aggregates"]) == 1
        assert data["aggregates"][0]["question_content"] == "Blood Pressure"

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_passes_question_ids(self, mock_agg, mock_deps_db, client):
        """Should pass question_ids filter."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_cross_survey_aggregates.return_value = {
            "survey_ids": [],
            "total_respondents": 0,
            "aggregates": [],
        }

        response = client.get(
            "/api/v1/research/cross-survey/aggregates"
            "?question_ids=5&question_ids=10",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        mock_agg.get_cross_survey_aggregates.assert_called_once_with(
            None,
            question_ids=[5, 10],
            date_from=None,
            date_to=None,
            category=None,
            response_type=None,
        )


# ============================================================================
# SINGLE-SURVEY CSV METADATA TESTS
# ============================================================================

class TestSingleSurveyCsvMetadata:
    """Tests for survey name + export date in single-survey CSV."""

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_csv_includes_survey_name(self, mock_agg, mock_deps_db, client):
        """CSV should contain survey name and export date metadata."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_survey_overview.return_value = {
            "survey_id": 1, "title": "Health Survey",
            "respondent_count": 10, "completion_rate": 90.0,
            "question_count": 5, "suppressed": False,
        }
        mock_agg.get_individual_csv_export.return_value = (
            'Survey,"Health Survey"\n'
            'Exported,"2026-02-08 12:00"\n'
            '\n'
            'Anonymous ID,Blood Pressure\n'
            'R-abc12345,120\n'
        )

        response = client.get(
            "/api/v1/research/surveys/1/export/csv",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 200
        assert "Health Survey" in response.text
        assert "Exported" in response.text
        # Filename should use survey title
        assert "Health_Survey" in response.headers.get("content-disposition", "")


# ============================================================================
# GET /surveys/{id}/aggregates — returns None -> 404 (line 231)
# ============================================================================

class TestAggregatesNotFound:
    """Cover line 231: get_survey_aggregates returns None -> 404."""

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.research._aggregation")
    def test_aggregates_returns_404_for_nonexistent(self, mock_agg, mock_deps_db, client):
        """Line 231: aggregates returns None -> 404."""
        mock_deps_db.side_effect = _mock_researcher_auth(mock_deps_db)
        mock_agg.get_survey_aggregates.return_value = None

        response = client.get(
            "/api/v1/research/surveys/999/aggregates",
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 404
