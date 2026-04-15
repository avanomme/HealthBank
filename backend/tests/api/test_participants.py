# Created with the Assistance of Claude Code
# backend/tests/api/test_participants.py
"""
Tests for Participant Data API endpoints in app/api/v1/participants.py.
"""

import pytest
from unittest.mock import patch, MagicMock
from app.main import app
from app.api.deps import get_current_user
from tests.mocks.db import FakeCursor

@pytest.fixture(autouse=True)
def clear_auth_override():
    """Remove the conftest mock_auth override so real auth is tested."""
    app.dependency_overrides.pop(get_current_user, None)
    yield



def _make_auth_conn(user_dict):
    """Create a mock DB connection for get_current_user auth lookup."""
    auth_cursor = MagicMock()
    auth_cursor.fetchone.return_value = user_dict
    auth_conn = MagicMock()
    auth_conn.cursor.return_value = auth_cursor
    return auth_conn


def _participant_user():
    return {
        "AccountID": 20,
        "Email": "participant@example.com",
        "TosAcceptedAt": "2026-01-01",
        "TosVersion": "1.0",
        "RoleID": 1,
        "ViewingAsUserID": None,
    }


def _researcher_user():
    return {
        "AccountID": 10,
        "Email": "researcher@example.com",
        "TosAcceptedAt": "2026-01-01",
        "TosVersion": "1.0",
        "RoleID": 2,
        "ViewingAsUserID": None,
    }


def _admin_viewing_as_participant():
    return {
        "AccountID": 99,
        "Email": "admin@example.com",
        "TosAcceptedAt": "2026-01-01",
        "TosVersion": "1.0",
        "RoleID": 4,
        "ViewingAsUserID": 50,
    }


# ============================================================================
# AUTH TESTS
# ============================================================================

class TestParticipantAuth:
    """Auth enforcement on participant endpoints."""

    def test_no_token_returns_401(self, client):
        """Endpoints return 401 without Authorization header."""
        resp = client.get("/api/v1/participants/surveys/data")
        assert resp.status_code == 401

    @patch("app.api.deps.get_db_connection")
    def test_researcher_gets_403(self, mock_deps_db, client):
        """Researcher (RoleID=2) is denied — only participant/admin allowed."""
        mock_deps_db.side_effect = [_make_auth_conn(_researcher_user())]

        resp = client.get(
            "/api/v1/participants/surveys/data",
            headers={"Authorization": "Bearer researcher_token"},
        )
        assert resp.status_code == 403

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_participant_allowed(self, mock_deps_db, mock_part_db, client):
        """Participant (RoleID=1) is allowed."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchall.return_value = []
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/data",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 200


# ============================================================================
# POST /participants/surveys/{survey_id}/submit — SURVEY SUBMISSION
# ============================================================================

class TestSubmitSurveyAnswers:
    """Tests for POST /api/v1/participants/surveys/{survey_id}/submit."""

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_successful_submission(self, mock_deps_db, mock_part_db, client):
        """Successfully submit survey answers."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        # Survey exists and is published
        survey_row = (1, "published", None, None)
        # Assignment is pending
        assignment_row = (100, "pending", None, None)
        data_cursor.fetchone.side_effect = [
            survey_row, assignment_row, (0,),
        ]
        data_cursor.fetchall.return_value = [
            (10, "yesno", False),
            (11, "number", False),
        ]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {
            "question_responses": [
                {"question_id": 10, "response_value": "yes"},
                {"question_id": 11, "response_value": "7"},
            ]
        }

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 201
        data = resp.json()
        assert data["survey_id"] == 1
        assert data["participant_id"] == 20  # from _participant_user
        assert data["submitted_count"] == 2
        assert data["status"] == "ok"

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_survey_not_found(self, mock_deps_db, mock_part_db, client):
        """Return 404 when survey does not exist."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchone.return_value = None  # Survey not found
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": []}

        resp = client.post(
            "/api/v1/participants/surveys/999/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 404
        assert "Survey not found" in resp.json()["detail"]

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_survey_not_published(self, mock_deps_db, mock_part_db, client):
        """Return 400 when survey is not published (draft/closed)."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        # Survey exists but is draft
        survey_row = (1, "draft", None, None)
        data_cursor.fetchone.return_value = survey_row
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": []}

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 400
        assert "not accepting submissions" in resp.json()["detail"]

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_participant_not_assigned(self, mock_deps_db, mock_part_db, client):
        """Return 403 when participant is not assigned to survey."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        survey_row = (1, "published", None, None)
        # No assignment found (None)
        data_cursor.fetchone.side_effect = [survey_row, None]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": []}

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 403
        assert "not assigned" in resp.json()["detail"]

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_assignment_already_completed(self, mock_deps_db, mock_part_db, client):
        """Return 400 when assignment is already completed."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        survey_row = (1, "published", None, None)
        # Assignment exists but is completed
        assignment_row = (100, "completed", None, None)
        data_cursor.fetchone.side_effect = [survey_row, assignment_row]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": []}

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 400
        assert "already completed" in resp.json()["detail"]

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_assignment_expired(self, mock_deps_db, mock_part_db, client):
        """Return 400 when assignment status is expired."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        survey_row = (1, "published", None, None)
        # Assignment status is expired
        assignment_row = (100, "expired", None, None)
        data_cursor.fetchone.side_effect = [survey_row, assignment_row]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": []}

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 400
        assert "is expired" in resp.json()["detail"]

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_due_date_not_passed(self, mock_deps_db, mock_part_db, client):
        """Allow submission when due date is in the future."""
        from datetime import datetime, timedelta

        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        survey_row = (1, "published", None, None)
        future_due_date = datetime(2026, 12, 31, 23, 59, 59)
        # Assignment with future due date
        assignment_row = (100, "pending", future_due_date, None)
        # UTC_TIMESTAMP will return now (before due date)
        # fetchone() returns a tuple; [0] extracts the datetime value
        now = datetime(2026, 2, 10, 12, 0, 0)
        data_cursor.fetchone.side_effect = [
            survey_row,
            assignment_row,
            (now,),  # UTC_TIMESTAMP — must be a tuple so fetchone()[0] works
            (0,),  # No existing responses
        ]
        data_cursor.fetchall.return_value = [
            (10, "yesno", False),
        ]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": [{"question_id": 10, "response_value": "yes"}]}

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 201

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_due_date_passed_expires_assignment(self, mock_deps_db, mock_part_db, client):
        """Return 400 and expire assignment when due date has passed."""
        from datetime import datetime, timedelta

        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        survey_row = (1, "published", None, None)
        past_due_date = datetime(2026, 1, 1, 0, 0, 0)
        assignment_row = (100, "pending", past_due_date, None)
        # UTC_TIMESTAMP returns now (after due date)
        # fetchone() returns a tuple; [0] extracts the datetime value
        now = datetime(2026, 2, 10, 12, 0, 0)
        data_cursor.fetchone.side_effect = [survey_row, assignment_row, (now,)]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": []}

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 400
        assert "past due" in resp.json()["detail"]
        # Verify that UPDATE was called to mark as expired
        data_conn.commit.assert_called()

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_survey_already_submitted(self, mock_deps_db, mock_part_db, client):
        """Return 400 when survey responses already exist."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        survey_row = (1, "published", None, None)
        assignment_row = (100, "pending", None, None)
        # Responses already exist (COUNT(*) returns 1)
        data_cursor.fetchone.side_effect = [survey_row, assignment_row, (1,)]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": []}

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 400
        assert "already submitted" in resp.json()["detail"]

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_multiple_question_responses(self, mock_deps_db, mock_part_db, client):
        """Submit multiple question responses in a single request."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        survey_row = (1, "published", None, None)
        assignment_row = (100, "pending", None, None)
        data_cursor.fetchone.side_effect = [
            survey_row, assignment_row, (0,),
        ]
        data_cursor.fetchall.return_value = [
            (10, "yesno", False),
            (11, "number", False),
            (12, "openended", False),
        ]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {
            "question_responses": [
                {"question_id": 10, "response_value": "yes"},
                {"question_id": 11, "response_value": "7"},
                {"question_id": 12, "response_value": "exercise daily"},
            ]
        }

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 201
        data = resp.json()
        assert data["submitted_count"] == 3

    def test_no_token_returns_401(self, client):
        """Return 401 without Authorization header."""
        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json={"question_responses": []},
        )
        assert resp.status_code == 401

    @patch("app.api.deps.get_db_connection")
    def test_researcher_gets_403(self, mock_deps_db, client):
        """Researcher (RoleID=2) is denied — only participant/admin allowed."""
        mock_deps_db.side_effect = [_make_auth_conn(_researcher_user())]

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json={"question_responses": []},
            headers={"Authorization": "Bearer researcher_token"},
        )
        assert resp.status_code == 403

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_updates_assignment_to_completed(self, mock_deps_db, mock_part_db, client):
        """Verify that assignment status is updated to completed with timestamp."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        survey_row = (1, "published", None, None)
        assignment_row = (100, "pending", None, None)
        data_cursor.fetchone.side_effect = [
            survey_row, assignment_row, (0,),
        ]
        data_cursor.fetchall.return_value = [
            (10, "yesno", False),
        ]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": [{"question_id": 10, "response_value": "yes"}]}

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 201

        # Verify UPDATE call for assignment completion
        update_calls = [
            call for call in data_cursor.execute.call_args_list
            if "UPDATE SurveyAssignment" in str(call) and "Status = 'completed'" in str(call)
        ]
        assert len(update_calls) > 0


# ============================================================================
# GET /api/v1/participants/surveys/{survey_id}/questions — List My Responded Surveys
# ============================================================================

class TestGetPartSurveyQuestions:
    """Tests for GET /api/v1/participants/surveys/{survey_id}/questions."""

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_returns_questions_for_survey(self, mock_deps_db, mock_part_db, client):
        """Should return a list of questions for the given survey_id."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        # Simulate survey metadata fetch (e.g., title) and questions for survey_id=1
        # First fetchone() for survey metadata, then fetchall() for questions
        data_cursor.fetchone.return_value = "Health Survey"  # Only the title as a string
        question_rows = [
            (10, "Sleep Hours", "How many hours of sleep?", "number", 1, "Sleep"),
            (11, "Exercise?", "Do you exercise?", "yesno", 1, "Exercise"),
        ]
        data_cursor.fetchall.return_value = question_rows
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/1/questions",
            headers={"Authorization": "Bearer participant_token"},
        )

        assert resp.status_code == 200
        data = resp.json()
        assert isinstance(data, dict)
        assert "questions" in data
        assert isinstance(data["questions"], list)
        assert len(data["questions"]) == 2
        assert data["questions"][0]["question_id"] == 10
        assert data["questions"][1]["question_id"] == 11

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_no_questions_returns_empty_list(self, mock_deps_db, mock_part_db, client):
        """Should return an empty list if no questions exist for the survey."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchone.return_value = "Health Survey"  # Mock survey title fetch
        data_cursor.fetchall.return_value = []
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/2/questions",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert isinstance(data, dict)
        assert "questions" in data
        assert isinstance(data["questions"], list)
        assert data["questions"] == []

    def test_no_token_returns_401(self, client):
        """Should return 401 if no Authorization header is provided."""
        resp = client.get("/api/v1/participants/surveys/1/questions")
        assert resp.status_code == 401

    @patch("app.api.deps.get_db_connection")
    def test_researcher_gets_403(self, mock_deps_db, client):
        """Researcher (RoleID=2) is denied access."""
        mock_deps_db.side_effect = [_make_auth_conn(_researcher_user())]
        resp = client.get(
            "/api/v1/participants/surveys/1/questions",
            headers={"Authorization": "Bearer researcher_token"},
        )
        assert resp.status_code == 403


# ============================================================================
# GET /api/v1/participants/surveys — List My Surveys
# ============================================================================

class TestListMySurveys:
    """Tests for GET /api/v1/participants/surveys."""

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_returns_empty_list_when_no_surveys(self, mock_deps_db, mock_part_db, client):
        """Should return an empty list if no surveys assigned."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchall.return_value = []
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 200
        assert resp.json() == []

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_returns_pending_completed_expired(self, mock_deps_db, mock_part_db, client):
        """Should return all assigned surveys with correct fields."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        survey_rows = [
            # survey_id, title, start_date, end_date, assignment_status, draft_data, assigned_at, due_date, completed_at, publication_status
            (1, "Health Survey", None, None, "pending", None, None, None, None, "published"),
            (2, "Wellness Survey", None, None, "completed", None, None, None, None, "published"),
            (3, "Old Survey", None, None, "expired", None, None, None, None, "published"),
        ]
        data_cursor.fetchall.return_value = survey_rows
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert len(data) == 3
        assert data[0]["survey_id"] == 1
        assert data[1]["assignment_status"] == "completed"
        assert data[2]["assignment_status"] == "expired"

    def test_filter_pending_only(self, client, mock_db, reset_fake_db_state):
        """Should return only pending surveys if filters are set, not completed/expired."""

        # Set dependency override for this test only
        def _fake_participant_user():
            return {
                "account_id": 20,
                "email": "participant@example.com",
                "tos_accepted_at": "2026-01-01",
                "tos_version": "1.0",
                "role_id": 1,
                "viewing_as_user_id": None,
                "effective_account_id": 20,
                "effective_role_id": 1,
            }
        app.dependency_overrides[get_current_user] = _fake_participant_user

        try:
            # Setup: create surveys and assignments for the participant
            participant_id = 20
            # Add surveys
            FakeCursor.surveys[1] = {
                "SurveyID": 1,
                "Title": "Health Survey",
                "Description": None,
                "Status": "not-started",
                "PublicationStatus": "published",
                "StartDate": None,
                "EndDate": None,
                "CreatedAt": None,
                "UpdatedAt": None,
            }
            FakeCursor.surveys[2] = {
                "SurveyID": 2,
                "Title": "Wellness Survey",
                "Description": None,
                "Status": "not-started",
                "PublicationStatus": "published",
                "StartDate": None,
                "EndDate": None,
                "CreatedAt": None,
                "UpdatedAt": None,
            }
            FakeCursor.surveys[3] = {
                "SurveyID": 3,
                "Title": "Old Survey",
                "Description": None,
                "Status": "not-started",
                "PublicationStatus": "published",
                "StartDate": None,
                "EndDate": None,
                "CreatedAt": None,
                "UpdatedAt": None,
            }
            # Add assignments for the participant
            FakeCursor.assignments[100] = {
                "AssignmentID": 100,
                "SurveyID": 1,
                "AccountID": participant_id,
                "AssignedAt": None,
                "DueDate": None,
                "CompletedAt": None,
                "Status": "pending",
            }
            FakeCursor.assignments[101] = {
                "AssignmentID": 101,
                "SurveyID": 2,
                "AccountID": participant_id,
                "AssignedAt": None,
                "DueDate": None,
                "CompletedAt": None,
                "Status": "completed",
            }
            FakeCursor.assignments[102] = {
                "AssignmentID": 102,
                "SurveyID": 3,
                "AccountID": participant_id,
                "AssignedAt": None,
                "DueDate": None,
                "CompletedAt": None,
                "Status": "expired",
            }

            resp = client.get(
                "/api/v1/participants/surveys?include_completed=false&include_expired=false",
                headers={"Authorization": "Bearer participant_token"},
            )
            assert resp.status_code == 200
            data = resp.json()
            # Only pending surveys should be present in the response
            assert len(data) == 1
            assert data[0]["assignment_status"] == "pending"
            assignment_statuses = [s["assignment_status"] for s in data]
            assert "completed" not in assignment_statuses
            assert "expired" not in assignment_statuses
        finally:
            # Clean up override
            app.dependency_overrides.pop(get_current_user, None)

    def test_no_token_returns_401(self, client):
        """Should return 401 if no Authorization header is provided."""
        resp = client.get("/api/v1/participants/surveys")
        assert resp.status_code == 401

    @patch("app.api.deps.get_db_connection")
    def test_researcher_gets_403(self, mock_deps_db, client):
        """Researcher (RoleID=2) is denied access."""
        mock_deps_db.side_effect = [_make_auth_conn(_researcher_user())]
        resp = client.get(
            "/api/v1/participants/surveys",
            headers={"Authorization": "Bearer researcher_token"},
        )
        assert resp.status_code == 403


# ============================================================================
# GET /participants/surveys/data — PERSONAL DATA VIEW
# ============================================================================

class TestListMyRespondedSurveys:
    """Tests for GET /api/v1/participants/surveys/data."""

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_returns_empty_list_when_no_responses(
        self, mock_deps_db, mock_part_db, client
    ):
        """Empty list returned when participant has no responses."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchall.return_value = []
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/data",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 200
        assert resp.json() == []

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_returns_survey_with_questions_and_responses(
        self, mock_deps_db, mock_part_db, client
    ):
        """Returns survey data with questions, response_type, category, and response values."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        # 3 sequential fetchall calls for the 3 SQL queries:
        survey_rows = [
            (1, "Health Survey", None, None, "published", "completed", None, None, "2026-02-01"),
        ]
        question_rows = [
            (1, 10, "Sleep Hours", "How many hours of sleep?", "number", 1, "Sleep"),
            (1, 11, "Exercise?", "Do you exercise?", "yesno", 1, "Exercise"),
        ]
        response_rows = [
            (1, 10, "7"),
            (1, 11, "yes"),
        ]
        data_cursor.fetchall.side_effect = [survey_rows, question_rows, response_rows]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/data",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert len(data) == 1

        survey = data[0]
        assert survey["survey_id"] == 1
        assert survey["title"] == "Health Survey"
        assert len(survey["questions"]) == 2

        q1 = survey["questions"][0]
        assert q1["question_id"] == 10
        assert q1["question_content"] == "How many hours of sleep?"
        assert q1["response_type"] == "number"
        assert q1["category"] == "Sleep"
        assert q1["response_value"] == "7"

        q2 = survey["questions"][1]
        assert q2["response_type"] == "yesno"
        assert q2["response_value"] == "yes"

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_uses_effective_account_id(
        self, mock_deps_db, mock_part_db, client
    ):
        """Admin viewing-as participant 50 uses effective_account_id=50 for queries."""
        auth_conn = _make_auth_conn(_admin_viewing_as_participant())

        # _get_role_for_account may be called multiple times (router-level +
        # endpoint-level require_role both resolve viewing-as).
        def _make_role_conn():
            rc = MagicMock()
            rc.fetchone.return_value = {"RoleID": 1}
            c = MagicMock()
            c.cursor.return_value = rc
            return c

        mock_deps_db.side_effect = [
            auth_conn,
            _make_role_conn(),
            _make_role_conn(),
            _make_role_conn(),
        ]

        data_cursor = MagicMock()
        data_cursor.fetchall.return_value = []  # No responses
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/data",
            headers={"Authorization": "Bearer admin_token"},
        )
        assert resp.status_code == 200

        # Verify the SQL used participant_id=50 (the effective account)
        data_cursor.execute.assert_called()
        first_call_args = data_cursor.execute.call_args_list[0]
        assert 50 in first_call_args[0][1]

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_returns_multiple_surveys(
        self, mock_deps_db, mock_part_db, client
    ):
        """Returns multiple completed surveys with their respective responses."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        survey_rows = [
            (1, "Health Survey", None, None, "published", "completed", None, None, "2026-02-01"),
            (2, "Wellness Survey", None, None, "published", "completed", None, None, "2026-02-02"),
        ]
        question_rows = [
            (1, 10, None, "Question for S1", "number", 1, None),
            (2, 20, None, "Question for S2", "yesno", 0, None),
        ]
        response_rows = [
            (1, 10, "42"),
            (2, 20, "no"),
        ]
        data_cursor.fetchall.side_effect = [survey_rows, question_rows, response_rows]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/data",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert len(data) == 2
        assert data[0]["survey_id"] == 1
        assert data[1]["survey_id"] == 2
        assert data[0]["questions"][0]["response_value"] == "42"
        assert data[1]["questions"][0]["response_value"] == "no"


# ============================================================================
# GET /api/v1/participants/surveys/{id}/compare — Compare to Aggragate
# ============================================================================

class TestCompareMyResponses:
    """Tests for GET /api/v1/participants/surveys/{id}/compare."""

    @patch("app.api.v1.participants._aggregation")
    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_returns_comparison_data(
        self, mock_deps_db, mock_part_db, mock_agg, client
    ):
        """Returns participant answers alongside aggregate data."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        # Assignment check
        data_cursor.fetchone.return_value = (100,)
        # Participant responses
        data_cursor.fetchall.return_value = [
            (10, "7"),
            (20, "Yes"),
        ]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        mock_agg.get_survey_aggregates.return_value = {
            "survey_id": 1,
            "title": "Health Survey",
            "total_respondents": 10,
            "aggregates": [
                {"question_id": 10, "suppressed": False, "data": {"mean": 6.5}},
                {"question_id": 20, "suppressed": False, "data": {"yes_count": 7, "no_count": 3}},
            ],
        }

        resp = client.get(
            "/api/v1/participants/surveys/1/compare",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["survey_id"] == 1
        assert len(data["participant_answers"]) == 2
        assert data["participant_answers"][0]["question_id"] == 10
        assert data["participant_answers"][0]["response_value"] == "7"
        assert "aggregates" in data["aggregates"]
        assert len(data["aggregates"]["aggregates"]) == 2

    @patch("app.api.v1.participants._aggregation")
    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_suppression_in_compare(
        self, mock_deps_db, mock_part_db, mock_agg, client
    ):
        """Aggregate data is suppressed when fewer than K=5 respondents."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchone.return_value = (100,)
        data_cursor.fetchall.return_value = [(10, "5")]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        mock_agg.get_survey_aggregates.return_value = {
            "survey_id": 1,
            "title": "Small Survey",
            "total_respondents": 3,
            "aggregates": [
                {
                    "question_id": 10,
                    "suppressed": True,
                    "reason": "insufficient_responses",
                    "data": None,
                }
            ],
        }

        resp = client.get(
            "/api/v1/participants/surveys/1/compare",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 200
        data = resp.json()
        # Participant answer is still visible
        assert data["participant_answers"][0]["response_value"] == "5"
        # Aggregate is suppressed
        agg_q = data["aggregates"]["aggregates"][0]
        assert agg_q["suppressed"] is True
        assert agg_q["data"] is None

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_not_assigned_returns_403(
        self, mock_deps_db, mock_part_db, client
    ):
        """Returns 403 when participant is not assigned to the survey."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchone.return_value = None  # no assignment
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/999/compare",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 403
        assert "not assigned" in resp.json()["detail"]

    @patch("app.api.v1.participants._aggregation")
    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_survey_not_found_returns_404(
        self, mock_deps_db, mock_part_db, mock_agg, client
    ):
        """Returns 404 when aggregation returns None (survey not found)."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchone.return_value = (100,)  # assignment exists
        data_cursor.fetchall.return_value = [(10, "7")]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        mock_agg.get_survey_aggregates.return_value = None

        resp = client.get(
            "/api/v1/participants/surveys/1/compare",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 404
        assert "not found" in resp.json()["detail"].lower()

    def test_no_token_returns_401(self, client):
        """Returns 401 without Authorization header."""
        resp = client.get("/api/v1/participants/surveys/1/compare")
        assert resp.status_code == 401


# ============================================================================
# GET /participants/surveys/{survey_id}/chart-data — CHART DATA
# ============================================================================

class TestGetChartData:
    """Tests for GET /api/v1/participants/surveys/{id}/chart-data."""

    @patch("app.api.v1.participants._aggregation")
    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_returns_chart_data_with_aggregates(
        self, mock_deps_db, mock_part_db, mock_agg, client
    ):
        """Returns participant responses + aggregate data per question."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        # 1) Assignment check
        data_cursor.fetchone.side_effect = [
            (100,),  # assignment exists
            (1, "Health Survey"),  # survey metadata
        ]
        # 2) Questions, then participant responses
        data_cursor.fetchall.side_effect = [
            [(10, "How many hours of sleep?", "number", "Sleep")],  # questions
            [(10, "7")],  # participant responses
        ]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        # Aggregation service returns data
        mock_agg.get_survey_aggregates.return_value = {
            "total_respondents": 10,
            "aggregates": [
                {
                    "question_id": 10,
                    "suppressed": False,
                    "data": {
                        "mean": 6.5,
                        "median": 7.0,
                        "histogram": [{"label": "5-7", "count": 6}],
                    },
                }
            ],
        }

        resp = client.get(
            "/api/v1/participants/surveys/1/chart-data",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["survey_id"] == 1
        assert data["title"] == "Health Survey"
        assert data["total_respondents"] == 10
        assert len(data["questions"]) == 1

        q = data["questions"][0]
        assert q["question_id"] == 10
        assert q["response_value"] == "7"
        assert q["response_type"] == "number"
        assert q["suppressed"] is False
        assert q["aggregate"]["mean"] == 6.5

    @patch("app.api.v1.participants._aggregation")
    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_suppressed_when_fewer_than_k_respondents(
        self, mock_deps_db, mock_part_db, mock_agg, client
    ):
        """Aggregate data is suppressed (null) when fewer than K=5 respondents."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchone.side_effect = [
            (100,),  # assignment exists
            (1, "Small Survey"),  # survey metadata
        ]
        data_cursor.fetchall.side_effect = [
            [(10, "Question?", "number", None)],  # questions
            [(10, "5")],  # participant responses
        ]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        # Aggregation returns suppressed data
        mock_agg.get_survey_aggregates.return_value = {
            "total_respondents": 3,
            "aggregates": [
                {
                    "question_id": 10,
                    "suppressed": True,
                    "reason": "insufficient_responses",
                    "data": None,
                }
            ],
        }

        resp = client.get(
            "/api/v1/participants/surveys/1/chart-data",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 200
        data = resp.json()
        q = data["questions"][0]
        assert q["suppressed"] is True
        assert q["aggregate"] is None
        # Participant's own value is still visible
        assert q["response_value"] == "5"

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_not_assigned_returns_403(
        self, mock_deps_db, mock_part_db, client
    ):
        """Returns 403 when participant is not assigned to the survey."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchone.return_value = None  # no assignment
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/999/chart-data",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 403
        assert "not assigned" in resp.json()["detail"]

    @patch("app.api.v1.participants._aggregation")
    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_empty_questions_returns_empty_list(
        self, mock_deps_db, mock_part_db, mock_agg, client
    ):
        """Returns empty questions list when no questions match filters."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchone.side_effect = [
            (100,),  # assignment exists
            (1, "Empty Survey"),  # survey metadata
        ]
        data_cursor.fetchall.return_value = []  # no questions
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/1/chart-data",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["questions"] == []
        assert data["total_respondents"] == 0

    @patch("app.api.v1.participants._aggregation")
    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_survey_not_found_returns_404(
        self, mock_deps_db, mock_part_db, mock_agg, client
    ):
        """Returns 404 when survey does not exist."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchone.side_effect = [
            (100,),  # assignment exists
            None,  # survey not found
        ]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/1/chart-data",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 404
        assert "Survey not found" in resp.json()["detail"]

    def test_no_token_returns_401(self, client):
        """Returns 401 without Authorization header."""
        resp = client.get("/api/v1/participants/surveys/1/chart-data")
        assert resp.status_code == 401

    @patch("app.api.v1.participants._aggregation")
    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_choice_data_with_options(
        self, mock_deps_db, mock_part_db, mock_agg, client
    ):
        """Returns choice option distribution for single_choice questions."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchone.side_effect = [
            (100,),
            (1, "Choice Survey"),
        ]
        data_cursor.fetchall.side_effect = [
            [(20, "Favorite color?", "single_choice", None)],
            [(20, "Blue")],
        ]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        mock_agg.get_survey_aggregates.return_value = {
            "total_respondents": 8,
            "aggregates": [
                {
                    "question_id": 20,
                    "suppressed": False,
                    "data": {
                        "options": [
                            {"option": "Red", "count": 3, "pct": 37.5},
                            {"option": "Blue", "count": 5, "pct": 62.5},
                        ]
                    },
                }
            ],
        }

        resp = client.get(
            "/api/v1/participants/surveys/1/chart-data",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 200
        q = resp.json()["questions"][0]
        assert q["response_type"] == "single_choice"
        assert q["response_value"] == "Blue"
        assert len(q["aggregate"]["options"]) == 2


# ============================================================================
# PUT /api/v1/participants/surveys/{survey_id}/draft — Save Draft
# ============================================================================

class TestSaveDraft:
    """Tests for PUT /api/v1/participants/surveys/{survey_id}/draft."""

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_save_draft_success(self, mock_deps_db, mock_part_db, client):
        """Should save draft data and return 204."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        # Assignment found, status is pending
        data_cursor.fetchone.return_value = (100, "pending")
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": [
            {"question_id": 10, "response_value": "yes"},
            {"question_id": 11, "response_value": "7"},
        ]}

        resp = client.put(
            "/api/v1/participants/surveys/1/draft",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 204

        # Verify UPDATE was called with draft JSON
        update_calls = [
            call for call in data_cursor.execute.call_args_list
            if "UPDATE SurveyAssignment SET DraftData" in str(call)
        ]
        assert len(update_calls) == 1
        data_conn.commit.assert_called()

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_save_draft_not_assigned_returns_404(self, mock_deps_db, mock_part_db, client):
        """Should return 404 when no assignment found."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchone.return_value = None  # No assignment
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": [{"question_id": 10, "response_value": "yes"}]}

        resp = client.put(
            "/api/v1/participants/surveys/1/draft",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 404
        assert "Assignment not found" in resp.json()["detail"]

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_save_draft_completed_silently_ignored(self, mock_deps_db, mock_part_db, client):
        """Should silently ignore draft save for completed assignments."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        # Assignment is completed
        data_cursor.fetchone.return_value = (100, "completed")
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": [{"question_id": 10, "response_value": "yes"}]}

        resp = client.put(
            "/api/v1/participants/surveys/1/draft",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 204
        # No UPDATE should have been executed
        update_calls = [
            call for call in data_cursor.execute.call_args_list
            if "UPDATE SurveyAssignment SET DraftData" in str(call)
        ]
        assert len(update_calls) == 0


# ============================================================================
# GET /api/v1/participants/surveys/{survey_id}/draft — Load Draft
# ============================================================================

class TestGetDraft:
    """Tests for GET /api/v1/participants/surveys/{survey_id}/draft."""

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_get_draft_with_data(self, mock_deps_db, mock_part_db, client):
        """Should return saved draft JSON."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        draft_json = '{"10": "yes", "11": "7"}'
        data_cursor.fetchone.return_value = (draft_json,)
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/1/draft",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["draft"]["10"] == "yes"
        assert data["draft"]["11"] == "7"

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_get_draft_empty(self, mock_deps_db, mock_part_db, client):
        """Should return empty dict when no draft data exists."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchone.return_value = (None,)  # No draft data
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/1/draft",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 200
        assert resp.json()["draft"] == {}

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_get_draft_not_assigned_returns_404(self, mock_deps_db, mock_part_db, client):
        """Should return 404 when no assignment found."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchone.return_value = None  # No assignment
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/1/draft",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 404
        assert "Assignment not found" in resp.json()["detail"]


# ============================================================================
# POST /participants/surveys/{survey_id}/submit — Multi-choice & Scale validation
# ============================================================================

class TestSubmitMultiChoiceAndScale:
    """Tests for multi-choice validation path and scale in submit_survey_answers."""

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_single_choice_valid_option(self, mock_deps_db, mock_part_db, client):
        """Submit single_choice: valid option_id is resolved to OptionText."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        survey_row = (1, "published", None, None)
        assignment_row = (100, "pending", None, None)
        data_cursor.fetchone.side_effect = [
            survey_row,
            assignment_row,
            (0,),   # No existing responses
            ("Red",),  # OptionText for option_id=63
        ]
        data_cursor.fetchall.return_value = [(10, "single_choice", False)]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": [
            {"question_id": 10, "response_value": "63"},
        ]}

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 201

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_single_choice_invalid_option(self, mock_deps_db, mock_part_db, client):
        """Submit single_choice: invalid option_id returns 400."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        survey_row = (1, "published", None, None)
        assignment_row = (100, "pending", None, None)
        data_cursor.fetchone.side_effect = [
            survey_row,
            assignment_row,
            (0,),   # No existing responses
            None,   # OptionText not found — invalid option
        ]
        data_cursor.fetchall.return_value = [(10, "single_choice", False)]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": [
            {"question_id": 10, "response_value": "999"},
        ]}

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 400
        assert "Invalid option" in resp.json()["detail"]

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_single_choice_non_numeric_returns_400(self, mock_deps_db, mock_part_db, client):
        """Submit single_choice: non-numeric response_value returns 400."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        survey_row = (1, "published", None, None)
        assignment_row = (100, "pending", None, None)
        data_cursor.fetchone.side_effect = [
            survey_row,
            assignment_row,
            (0,),   # No existing responses
        ]
        data_cursor.fetchall.return_value = [(10, "single_choice", False)]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": [
            {"question_id": 10, "response_value": "not_a_number"},
        ]}

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 400
        assert "Invalid single_choice" in resp.json()["detail"]

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_multi_choice_json_array(self, mock_deps_db, mock_part_db, client):
        """Submit multi_choice: JSON array format resolves to comma-separated text."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        survey_row = (1, "published", None, None)
        assignment_row = (100, "pending", None, None)
        data_cursor.fetchone.side_effect = [
            survey_row,
            assignment_row,
            (0,),   # No existing responses
        ]
        data_cursor.fetchall.side_effect = [
            [(10, "multi_choice", False)],  # question map
            [(32, "Apple"), (33, "Banana")],  # options
        ]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": [
            {"question_id": 10, "response_value": '[32, 33]'},
        ]}

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 201

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_multi_choice_comma_separated(self, mock_deps_db, mock_part_db, client):
        """Submit multi_choice: comma-separated format (legacy) works."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        survey_row = (1, "published", None, None)
        assignment_row = (100, "pending", None, None)
        data_cursor.fetchone.side_effect = [
            survey_row,
            assignment_row,
            (0,),
        ]
        data_cursor.fetchall.side_effect = [
            [(10, "multi_choice", False)],  # question map
            [(31, "Cat"), (34, "Dog")],  # options
        ]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": [
            {"question_id": 10, "response_value": "31,34"},
        ]}

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 201

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_multi_choice_invalid_option(self, mock_deps_db, mock_part_db, client):
        """Submit multi_choice: invalid option_id returns 400."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        survey_row = (1, "published", None, None)
        assignment_row = (100, "pending", None, None)
        data_cursor.fetchone.side_effect = [
            survey_row,
            assignment_row,
            (0,),
        ]
        # Only 1 option found, but 2 were requested => mismatch
        data_cursor.fetchall.side_effect = [
            [(10, "multi_choice", False)],  # question map
            [(32, "Apple")],  # only 1 valid option returned
        ]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": [
            {"question_id": 10, "response_value": '[32, 999]'},
        ]}

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 400
        assert "invalid options" in resp.json()["detail"].lower()

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_multi_choice_empty_list(self, mock_deps_db, mock_part_db, client):
        """Submit multi_choice: empty list results in empty string response."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        survey_row = (1, "published", None, None)
        assignment_row = (100, "pending", None, None)
        data_cursor.fetchone.side_effect = [
            survey_row,
            assignment_row,
            (0,),
        ]
        data_cursor.fetchall.return_value = [(10, "multi_choice", False)]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": [
            {"question_id": 10, "response_value": '[]'},
        ]}

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 201

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_multi_choice_invalid_format_returns_400(self, mock_deps_db, mock_part_db, client):
        """Submit multi_choice: completely invalid format returns 400."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        survey_row = (1, "published", None, None)
        assignment_row = (100, "pending", None, None)
        data_cursor.fetchone.side_effect = [
            survey_row,
            assignment_row,
            (0,),
        ]
        data_cursor.fetchall.return_value = [(10, "multi_choice", False)]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": [
            {"question_id": 10, "response_value": "abc,xyz"},
        ]}

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 400
        assert "Invalid multi_choice" in resp.json()["detail"]

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_invalid_question_id_returns_400(self, mock_deps_db, mock_part_db, client):
        """Submit with invalid question_id (not in survey question map) returns 400."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        survey_row = (1, "published", None, None)
        assignment_row = (100, "pending", None, None)
        data_cursor.fetchone.side_effect = [
            survey_row,
            assignment_row,
            (0,),
        ]
        data_cursor.fetchall.return_value = []  # question 9999 not in survey
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": [
            {"question_id": 9999, "response_value": "test"},
        ]}

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 400
        assert "not in this survey" in resp.json()["detail"]

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_submit_generic_exception_returns_500(self, mock_deps_db, mock_part_db, client):
        """Generic exception in submit is caught and returns 500."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        survey_row = (1, "published", None, None)
        assignment_row = (100, "pending", None, None)
        data_cursor.fetchone.side_effect = [
            survey_row,
            assignment_row,
            (0,),              # No existing responses
        ]
        data_cursor.fetchall.side_effect = RuntimeError("DB exploded")  # question map fetch fails
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": [
            {"question_id": 10, "response_value": "yes"},
        ]}

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 500
        assert "Failed to submit survey" in resp.json()["detail"]


# ============================================================================
# GET /participants/surveys/{survey_id}/chart-data — Category/ResponseType filters
# ============================================================================

class TestChartDataFilters:
    """Tests for category and response_type filter params on chart-data."""

    @patch("app.api.v1.participants._aggregation")
    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_chart_data_with_category_filter(self, mock_deps_db, mock_part_db, mock_agg, client):
        """Category filter produces WHERE clause with extra param."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchone.side_effect = [
            (100,),  # assignment
            (1, "Health Survey"),  # survey
        ]
        data_cursor.fetchall.side_effect = [
            [(10, "Sleep hours?", "number", "Sleep")],  # questions
            [(10, "7")],  # responses
        ]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        mock_agg.get_survey_aggregates.return_value = {
            "total_respondents": 10,
            "aggregates": [
                {"question_id": 10, "suppressed": False, "data": {"mean": 7.0}},
            ],
        }

        resp = client.get(
            "/api/v1/participants/surveys/1/chart-data?category=Sleep",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 200
        assert resp.json()["questions"][0]["category"] == "Sleep"

    @patch("app.api.v1.participants._aggregation")
    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_chart_data_with_response_type_filter(self, mock_deps_db, mock_part_db, mock_agg, client):
        """Response type filter produces WHERE clause with extra param."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchone.side_effect = [
            (100,),
            (1, "Survey"),
        ]
        data_cursor.fetchall.side_effect = [
            [(10, "Do you exercise?", "yesno", None)],
            [(10, "yes")],
        ]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        mock_agg.get_survey_aggregates.return_value = {
            "total_respondents": 10,
            "aggregates": [
                {"question_id": 10, "suppressed": False, "data": {"yes": 7, "no": 3}},
            ],
        }

        resp = client.get(
            "/api/v1/participants/surveys/1/chart-data?response_type=yesno",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 200
        assert resp.json()["questions"][0]["response_type"] == "yesno"

    @patch("app.api.v1.participants._aggregation")
    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_chart_data_generic_exception_returns_500(self, mock_deps_db, mock_part_db, mock_agg, client):
        """Generic exception in chart-data is caught and returns 500."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_conn = MagicMock()
        data_cursor = MagicMock()
        data_cursor.fetchone.side_effect = [
            (100,),  # assignment
            (1, "Survey"),  # survey
        ]
        data_cursor.fetchall.side_effect = RuntimeError("DB error")
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/1/chart-data",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 500
        assert "Failed to load chart data" in resp.json()["detail"]


# ============================================================================
# GET /participants/surveys/data — List Responded Surveys (error path)
# ============================================================================

class TestListRespondedSurveysErrors:
    """Tests covering error/edge paths for GET /participants/surveys/data."""

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_generic_exception_returns_500(self, mock_deps_db, mock_part_db, client):
        """Generic exception in list_my_responded_surveys returns 500."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_conn = MagicMock()
        data_cursor = MagicMock()
        data_cursor.fetchall.side_effect = RuntimeError("DB gone")
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/data",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 500
        assert "Failed to load responded surveys" in resp.json()["detail"]


# ============================================================================
# GET /participants/surveys — List My Surveys (error path)
# ============================================================================

class TestListMySurveysErrors:
    """Tests covering error/edge paths for GET /participants/surveys."""

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_generic_exception_returns_500(self, mock_deps_db, mock_part_db, client):
        """Generic exception in list_my_surveys returns 500."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_conn = MagicMock()
        data_cursor = MagicMock()
        data_cursor.fetchall.side_effect = RuntimeError("DB error")
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 500
        assert "Failed to load participant surveys" in resp.json()["detail"]


# ============================================================================
# GET /participants/surveys/{id}/questions — Error paths
# ============================================================================

class TestGetSurveyQuestionsErrors:
    """Tests covering error/edge paths for GET /participants/surveys/{id}/questions."""

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_no_pending_assignment_returns_403(self, mock_deps_db, mock_part_db, client):
        """Returns 403 when participant has no pending assignment."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchone.return_value = None  # No pending assignment
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/1/questions",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 403
        assert "No pending assignment" in resp.json()["detail"]

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_survey_not_found_returns_404(self, mock_deps_db, mock_part_db, client):
        """Returns 404 when survey doesn't exist after assignment check."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchone.side_effect = [
            (100,),  # Assignment exists
            None,    # Survey not found
        ]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/1/questions",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 404
        assert "Survey not found" in resp.json()["detail"]

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_choice_question_fetches_options(self, mock_deps_db, mock_part_db, client):
        """single_choice/multi_choice questions trigger QuestionOptions lookup."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchone.side_effect = [
            (100,),          # Assignment
            ("Survey",),     # Survey title
            None,            # get_translated_question returns None
        ]
        question_rows = [
            (10, "Fav Color", "What color?", "single_choice", 1, None),
        ]
        option_rows = [
            (1, "Red", 1),
            (2, "Blue", 2),
        ]
        data_cursor.fetchall.side_effect = [
            question_rows,
            option_rows,
        ]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/1/questions",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert len(data["questions"]) == 1
        assert data["questions"][0]["response_type"] == "single_choice"
        assert len(data["questions"][0]["options"]) == 2

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_generic_exception_returns_500(self, mock_deps_db, mock_part_db, client):
        """Generic exception in get_participant_survey_questions returns 500."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_conn = MagicMock()
        data_conn.cursor.side_effect = RuntimeError("DB error")
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/1/questions",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 500
        assert "Failed to load survey questions" in resp.json()["detail"]

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_translated_options_for_non_english(self, mock_deps_db, mock_part_db, client):
        """Non-English lang triggers option translation lookup."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        # fetchone calls in order:
        # 1. assignment check -> (100,)
        # 2. survey title -> ("Sondage",)
        # 3. get_translated_question(cursor, qid, "fr") -> fetchone() returns None (no translation)
        data_cursor.fetchone.side_effect = [
            (100,),          # Assignment check
            ("Sondage",),    # Survey title
            None,            # get_translated_question -> no translation row
        ]
        question_rows = [
            (10, "Couleur", "Quelle couleur?", "single_choice", 1, None),
        ]
        option_rows = [
            (1, "Red", 1),
            (2, "Blue", 2),
        ]
        # fetchall calls in order:
        # 1. questions for survey
        # 2. QuestionOptions for question 10 (single_choice)
        # 3. get_translated_options -> QuestionOptionTranslations fetchall()
        data_cursor.fetchall.side_effect = [
            question_rows,
            option_rows,
            [],  # get_translated_options returns empty (no translations)
        ]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/1/questions?lang=fr",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 200


# ============================================================================
# Additional coverage: missing lines 304, 481-482, 487, 791-792
# ============================================================================

class TestSubmitSurveyInvalidSingleChoice:
    """Cover line 304: invalid single_choice (non-numeric) returns 400."""

    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_invalid_single_choice_non_numeric(self, mock_deps_db, mock_part_db, client):
        """Line 304: non-numeric single_choice response_value raises 400."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchone.side_effect = [
            (1, "published", None, None),  # survey row
            (100, "pending", None, None),  # assignment row
            (0,),  # COUNT(*) responses = 0 (not yet submitted)
        ]
        data_cursor.fetchall.return_value = [(10, "single_choice", False)]  # question map
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        payload = {"question_responses": [
            {"question_id": 10, "response_value": "not_a_number"},
        ]}

        resp = client.post(
            "/api/v1/participants/surveys/1/submit",
            json=payload,
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 400
        assert "Invalid single_choice" in resp.json()["detail"]


class TestCompareMyResponsesException:
    """Cover lines 791-792: generic exception in compare -> 500."""

    @patch("app.api.v1.participants._aggregation")
    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_compare_generic_exception_returns_500(
        self, mock_deps_db, mock_part_db, mock_agg, client
    ):
        """Lines 791-792: non-HTTP exception -> 500."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchone.side_effect = [
            (100,),  # assignment exists
        ]
        # fetchall raises unexpected error
        data_cursor.fetchall.side_effect = RuntimeError("unexpected error")
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        resp = client.get(
            "/api/v1/participants/surveys/1/compare",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 500
        assert "Failed to load comparison data" in resp.json()["detail"]


class TestGetSurveyQuestionsTranslation:
    """Cover lines 481-482, 487: translation applied when available."""

    @patch("app.api.v1.participants.get_translated_options")
    @patch("app.api.v1.participants.get_translated_question")
    @patch("app.api.v1.participants.get_db_connection")
    @patch("app.api.deps.get_db_connection")
    def test_translated_question_content_applied(
        self, mock_deps_db, mock_part_db, mock_trans_q, mock_trans_opts, client
    ):
        """Lines 481-482: translated question title/content is used."""
        mock_deps_db.side_effect = [_make_auth_conn(_participant_user())]

        data_cursor = MagicMock()
        data_cursor.fetchone.side_effect = [
            (100,),  # pending assignment
            ("Original Title",),  # survey title
        ]
        data_cursor.fetchall.side_effect = [
            [(10, "OrigTitle", "OrigContent", "number", 1, "Health")],  # questions
        ]
        data_conn = MagicMock()
        data_conn.cursor.return_value = data_cursor
        mock_part_db.return_value = data_conn

        mock_trans_q.return_value = {"title": "Titre Traduit", "question_content": "Contenu Traduit"}

        resp = client.get(
            "/api/v1/participants/surveys/1/questions?lang=fr",
            headers={"Authorization": "Bearer participant_token"},
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["questions"][0]["title"] == "Titre Traduit"
        assert data["questions"][0]["question_content"] == "Contenu Traduit"

