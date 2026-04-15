# Created with the Assistance of Claude Code
# backend/tests/api/test_responses.py
"""
Tests for Response Submission API in app/api/v1/responses.py.

Tests cover:
- POST /api/v1/responses/ — submit survey responses
- Validation: survey published, participant assigned, question in survey, type matching
- Auth: participant only (401, 403 for researcher/admin)
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


def _mock_participant_auth():
    """Set up mocks for get_current_user + require_role(1) as participant.

    Single DB connection: get_current_user JOINs RoleID and ViewingAsUserID.
    require_role reuses data from get_current_user (no second connection).
    """
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


def _mock_researcher_auth():
    """Set up mocks for researcher (will be denied on require_role(1)).

    Single DB connection: get_current_user JOINs RoleID and ViewingAsUserID.
    require_role reuses data — researcher (RoleID=2) denied on require_role(1).
    """
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


VALID_BODY = {
    "survey_id": 1,
    "responses": [
        {"question_id": 1, "response_value": "yes"},
    ],
}


# ============================================================================
# AUTH TESTS
# ============================================================================

class TestResponseAuth:
    """Auth enforcement for response submission."""

    def test_no_token_returns_401(self, client):
        """Should return 401 without Authorization header."""
        response = client.post("/api/v1/responses/", json=VALID_BODY)
        assert response.status_code == 401

    @patch("app.api.deps.get_db_connection")
    def test_researcher_returns_403(self, mock_db, client):
        """Researcher (RoleID=2) should be denied on participant-only endpoint."""
        mock_db.side_effect = _mock_researcher_auth()

        response = client.post(
            "/api/v1/responses/",
            json=VALID_BODY,
            headers={"Authorization": "Bearer researcher_token"},
        )

        assert response.status_code == 403

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.responses.get_db_connection")
    def test_admin_passes_auth(self, mock_resp_db, mock_deps_db, client):
        """Admin (RoleID=4) always passes require_role() — SYSTEM_ADMIN_ROLE_ID bypass."""
        auth_cursor = MagicMock()
        auth_cursor.fetchone.return_value = {
            "AccountID": 1, "Email": "admin@example.com",
            "TosAcceptedAt": "2026-01-01", "TosVersion": "1.0",
            "RoleID": 4, "ViewingAsUserID": None,
        }
        auth_conn = MagicMock()
        auth_conn.cursor.return_value = auth_cursor
        mock_deps_db.side_effect = [auth_conn]

        # Mock the responses DB — admin passes auth, endpoint runs business logic
        resp_cursor = MagicMock()
        resp_cursor.fetchone.side_effect = [
            {"PublicationStatus": "published"},   # survey check
            {"AssignmentID": 1},                   # assignment check
        ]
        resp_cursor.fetchall.return_value = [
            {"QuestionID": 1, "ResponseType": "yesno", "IsRequired": False},
        ]
        resp_conn = MagicMock()
        resp_conn.cursor.return_value = resp_cursor
        mock_resp_db.return_value = resp_conn

        response = client.post(
            "/api/v1/responses/",
            json=VALID_BODY,
            headers={"Authorization": "Bearer admin_token"},
        )

        # Admin passes auth and succeeds with proper mocks
        assert response.status_code == 201


# ============================================================================
# SUCCESS TESTS
# ============================================================================

class TestSubmitSuccess:
    """Tests for successful response submission."""

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.responses.get_db_connection")
    def test_valid_submission_returns_201(self, mock_resp_db, mock_deps_db, client):
        """Valid responses should return 201."""
        mock_deps_db.side_effect = _mock_participant_auth()

        resp_cursor = MagicMock()
        resp_cursor.fetchone.side_effect = [
            {"PublicationStatus": "published"},          # survey check
            {"AssignmentID": 1},                          # assignment check
        ]
        resp_cursor.fetchall.return_value = [
            {"QuestionID": 1, "ResponseType": "yesno", "IsRequired": False},  # question map
        ]
        resp_conn = MagicMock()
        resp_conn.cursor.return_value = resp_cursor
        mock_resp_db.return_value = resp_conn

        response = client.post(
            "/api/v1/responses/",
            json=VALID_BODY,
            headers={"Authorization": "Bearer participant_token"},
        )

        assert response.status_code == 201
        data = response.json()
        assert data["message"] == "Responses submitted successfully"
        assert data["survey_id"] == 1
        assert data["responses_count"] == 1
        assert resp_conn.commit.called


# ============================================================================
# VALIDATION TESTS
# ============================================================================

class TestSubmitValidation:
    """Tests for validation rules in response submission."""

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.responses.get_db_connection")
    def test_unpublished_survey_returns_400(self, mock_resp_db, mock_deps_db, client):
        """Should reject responses for draft survey."""
        mock_deps_db.side_effect = _mock_participant_auth()

        resp_cursor = MagicMock()
        resp_cursor.fetchone.return_value = {"PublicationStatus": "draft"}
        resp_conn = MagicMock()
        resp_conn.cursor.return_value = resp_cursor
        mock_resp_db.return_value = resp_conn

        response = client.post(
            "/api/v1/responses/",
            json=VALID_BODY,
            headers={"Authorization": "Bearer participant_token"},
        )

        assert response.status_code == 400
        assert "not published" in response.json()["detail"]

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.responses.get_db_connection")
    def test_unassigned_participant_returns_403(self, mock_resp_db, mock_deps_db, client):
        """Should reject participant not assigned to survey."""
        mock_deps_db.side_effect = _mock_participant_auth()

        resp_cursor = MagicMock()
        resp_cursor.fetchone.side_effect = [
            {"PublicationStatus": "published"},  # survey OK
            None,                                 # not assigned
        ]
        resp_conn = MagicMock()
        resp_conn.cursor.return_value = resp_cursor
        mock_resp_db.return_value = resp_conn

        response = client.post(
            "/api/v1/responses/",
            json=VALID_BODY,
            headers={"Authorization": "Bearer participant_token"},
        )

        assert response.status_code == 403
        assert "not assigned" in response.json()["detail"]

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.responses.get_db_connection")
    def test_question_not_in_survey_returns_400(self, mock_resp_db, mock_deps_db, client):
        """Should reject question not in survey's QuestionList."""
        mock_deps_db.side_effect = _mock_participant_auth()

        resp_cursor = MagicMock()
        resp_cursor.fetchone.side_effect = [
            {"PublicationStatus": "published"},
            {"AssignmentID": 1},
        ]
        resp_cursor.fetchall.return_value = [
            {"QuestionID": 99, "ResponseType": "yesno", "IsRequired": False},  # only Q99 in survey
        ]
        resp_conn = MagicMock()
        resp_conn.cursor.return_value = resp_cursor
        mock_resp_db.return_value = resp_conn

        body = {"survey_id": 1, "responses": [{"question_id": 1, "response_value": "yes"}]}

        response = client.post(
            "/api/v1/responses/",
            json=body,
            headers={"Authorization": "Bearer participant_token"},
        )

        assert response.status_code == 400
        assert "not in this survey" in response.json()["detail"]

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.responses.get_db_connection")
    def test_non_numeric_for_number_type_returns_422(self, mock_resp_db, mock_deps_db, client):
        """Should reject non-numeric value for 'number' type."""
        mock_deps_db.side_effect = _mock_participant_auth()

        resp_cursor = MagicMock()
        resp_cursor.fetchone.side_effect = [
            {"PublicationStatus": "published"},
            {"AssignmentID": 1},
        ]
        resp_cursor.fetchall.return_value = [
            {"QuestionID": 1, "ResponseType": "number", "IsRequired": False},
        ]
        resp_conn = MagicMock()
        resp_conn.cursor.return_value = resp_cursor
        mock_resp_db.return_value = resp_conn

        body = {"survey_id": 1, "responses": [{"question_id": 1, "response_value": "abc"}]}

        response = client.post(
            "/api/v1/responses/",
            json=body,
            headers={"Authorization": "Bearer participant_token"},
        )

        assert response.status_code == 422
        assert "numeric" in response.json()["detail"].lower()

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.responses.get_db_connection")
    def test_invalid_yesno_returns_422(self, mock_resp_db, mock_deps_db, client):
        """Should reject invalid yesno value."""
        mock_deps_db.side_effect = _mock_participant_auth()

        resp_cursor = MagicMock()
        resp_cursor.fetchone.side_effect = [
            {"PublicationStatus": "published"},
            {"AssignmentID": 1},
        ]
        resp_cursor.fetchall.return_value = [
            {"QuestionID": 1, "ResponseType": "yesno", "IsRequired": False},
        ]
        resp_conn = MagicMock()
        resp_conn.cursor.return_value = resp_cursor
        mock_resp_db.return_value = resp_conn

        body = {"survey_id": 1, "responses": [{"question_id": 1, "response_value": "maybe"}]}

        response = client.post(
            "/api/v1/responses/",
            json=body,
            headers={"Authorization": "Bearer participant_token"},
        )

        assert response.status_code == 422
        assert "yes/no" in response.json()["detail"].lower()

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.responses.get_db_connection")
    def test_valid_single_choice_accepted(self, mock_resp_db, mock_deps_db, client):
        """Should accept valid single_choice value from QuestionOptions."""
        mock_deps_db.side_effect = _mock_participant_auth()

        resp_cursor = MagicMock()
        resp_cursor.fetchone.side_effect = [
            {"PublicationStatus": "published"},
            {"AssignmentID": 1},
        ]
        resp_cursor.fetchall.side_effect = [
            [{"QuestionID": 1, "ResponseType": "single_choice", "IsRequired": False}],  # question map
            [{"OptionText": "Red"}, {"OptionText": "Blue"}],        # options
        ]
        resp_conn = MagicMock()
        resp_conn.cursor.return_value = resp_cursor
        mock_resp_db.return_value = resp_conn

        body = {"survey_id": 1, "responses": [{"question_id": 1, "response_value": "Red"}]}

        response = client.post(
            "/api/v1/responses/",
            json=body,
            headers={"Authorization": "Bearer participant_token"},
        )

        assert response.status_code == 201

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.responses.get_db_connection")
    def test_invalid_single_choice_returns_422(self, mock_resp_db, mock_deps_db, client):
        """Should reject single_choice value not in QuestionOptions."""
        mock_deps_db.side_effect = _mock_participant_auth()

        resp_cursor = MagicMock()
        resp_cursor.fetchone.side_effect = [
            {"PublicationStatus": "published"},
            {"AssignmentID": 1},
        ]
        resp_cursor.fetchall.side_effect = [
            [{"QuestionID": 1, "ResponseType": "single_choice", "IsRequired": False}],
            [{"OptionText": "Red"}, {"OptionText": "Blue"}],
        ]
        resp_conn = MagicMock()
        resp_conn.cursor.return_value = resp_cursor
        mock_resp_db.return_value = resp_conn

        body = {"survey_id": 1, "responses": [{"question_id": 1, "response_value": "Green"}]}

        response = client.post(
            "/api/v1/responses/",
            json=body,
            headers={"Authorization": "Bearer participant_token"},
        )

        assert response.status_code == 422
        assert "not a valid option" in response.json()["detail"]


# ============================================================================
# ADDITIONAL VALIDATION TESTS — covering missing lines
# ============================================================================

class TestSubmitValidationExtra:
    """Tests for validation paths not yet covered: scale, duplicate, exception."""

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.responses.get_db_connection")
    def test_scale_out_of_range_returns_422(self, mock_resp_db, mock_deps_db, client):
        """Should reject scale value outside 1-10."""
        mock_deps_db.side_effect = _mock_participant_auth()

        resp_cursor = MagicMock()
        resp_cursor.fetchone.side_effect = [
            {"PublicationStatus": "published"},
            {"AssignmentID": 1},
        ]
        resp_cursor.fetchall.return_value = [
            {"QuestionID": 1, "ResponseType": "scale", "IsRequired": False},
        ]
        resp_conn = MagicMock()
        resp_conn.cursor.return_value = resp_cursor
        mock_resp_db.return_value = resp_conn

        body = {"survey_id": 1, "responses": [{"question_id": 1, "response_value": "15"}]}

        response = client.post(
            "/api/v1/responses/",
            json=body,
            headers={"Authorization": "Bearer participant_token"},
        )

        assert response.status_code == 422
        assert "scale" in response.json()["detail"].lower()

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.responses.get_db_connection")
    def test_scale_non_numeric_returns_422(self, mock_resp_db, mock_deps_db, client):
        """Should reject non-numeric scale value."""
        mock_deps_db.side_effect = _mock_participant_auth()

        resp_cursor = MagicMock()
        resp_cursor.fetchone.side_effect = [
            {"PublicationStatus": "published"},
            {"AssignmentID": 1},
        ]
        resp_cursor.fetchall.return_value = [
            {"QuestionID": 1, "ResponseType": "scale", "IsRequired": False},
        ]
        resp_conn = MagicMock()
        resp_conn.cursor.return_value = resp_cursor
        mock_resp_db.return_value = resp_conn

        body = {"survey_id": 1, "responses": [{"question_id": 1, "response_value": "abc"}]}

        response = client.post(
            "/api/v1/responses/",
            json=body,
            headers={"Authorization": "Bearer participant_token"},
        )

        assert response.status_code == 422
        assert "scale" in response.json()["detail"].lower()

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.responses.get_db_connection")
    def test_valid_scale_accepted(self, mock_resp_db, mock_deps_db, client):
        """Should accept valid scale value between 1 and 10."""
        mock_deps_db.side_effect = _mock_participant_auth()

        resp_cursor = MagicMock()
        resp_cursor.fetchone.side_effect = [
            {"PublicationStatus": "published"},
            {"AssignmentID": 1},
        ]
        resp_cursor.fetchall.return_value = [
            {"QuestionID": 1, "ResponseType": "scale", "IsRequired": False},
        ]
        resp_conn = MagicMock()
        resp_conn.cursor.return_value = resp_cursor
        mock_resp_db.return_value = resp_conn

        body = {"survey_id": 1, "responses": [{"question_id": 1, "response_value": "7"}]}

        response = client.post(
            "/api/v1/responses/",
            json=body,
            headers={"Authorization": "Bearer participant_token"},
        )

        assert response.status_code == 201

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.responses.get_db_connection")
    def test_multi_choice_invalid_selection_returns_422(self, mock_resp_db, mock_deps_db, client):
        """Should reject multi_choice with invalid selection not in options."""
        mock_deps_db.side_effect = _mock_participant_auth()

        resp_cursor = MagicMock()
        resp_cursor.fetchone.side_effect = [
            {"PublicationStatus": "published"},
            {"AssignmentID": 1},
        ]
        resp_cursor.fetchall.side_effect = [
            [{"QuestionID": 1, "ResponseType": "multi_choice", "IsRequired": False}],  # question map
            [{"OptionText": "Red"}, {"OptionText": "Blue"}],       # options
        ]
        resp_conn = MagicMock()
        resp_conn.cursor.return_value = resp_cursor
        mock_resp_db.return_value = resp_conn

        body = {"survey_id": 1, "responses": [{"question_id": 1, "response_value": "Red,Green"}]}

        response = client.post(
            "/api/v1/responses/",
            json=body,
            headers={"Authorization": "Bearer participant_token"},
        )

        assert response.status_code == 422
        assert "invalid" in response.json()["detail"].lower()

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.responses.get_db_connection")
    def test_survey_not_found_returns_404(self, mock_resp_db, mock_deps_db, client):
        """Should return 404 when survey does not exist."""
        mock_deps_db.side_effect = _mock_participant_auth()

        resp_cursor = MagicMock()
        resp_cursor.fetchone.return_value = None  # Survey not found
        resp_conn = MagicMock()
        resp_conn.cursor.return_value = resp_cursor
        mock_resp_db.return_value = resp_conn

        response = client.post(
            "/api/v1/responses/",
            json=VALID_BODY,
            headers={"Authorization": "Bearer participant_token"},
        )

        assert response.status_code == 404
        assert "not found" in response.json()["detail"].lower()

    @patch("app.api.deps.get_db_connection")
    @patch("app.api.v1.responses.get_db_connection")
    def test_generic_exception_returns_500(self, mock_resp_db, mock_deps_db, client):
        """Generic exception during submission returns 500."""
        mock_deps_db.side_effect = _mock_participant_auth()

        resp_conn = MagicMock()
        resp_cursor = MagicMock()
        resp_cursor.fetchone.side_effect = [
            {"PublicationStatus": "published"},
            {"AssignmentID": 1},
        ]
        resp_cursor.fetchall.return_value = [
            {"QuestionID": 1, "ResponseType": "yesno", "IsRequired": False},
        ]
        # Make INSERT raise an unexpected error
        resp_cursor.execute.side_effect = [
            None,  # survey SELECT
            None,  # assignment SELECT
            None,  # question_map SELECT
            RuntimeError("Unexpected DB error"),  # INSERT
        ]
        resp_conn.cursor.return_value = resp_cursor
        mock_resp_db.return_value = resp_conn

        response = client.post(
            "/api/v1/responses/",
            json=VALID_BODY,
            headers={"Authorization": "Bearer participant_token"},
        )

        assert response.status_code == 500
        assert "Failed to submit responses" in response.json()["detail"]


# ============================================================================
# UNIT TESTS — _parse_multi_choice and _normalize_response_value (lines 96-97, 107-108)
# ============================================================================

class TestParseMultiChoice:
    """Cover lines 96-97: _parse_multi_choice JSON array parsing."""

    def test_parse_json_array(self):
        from app.api.v1.responses import _parse_multi_choice
        result = _parse_multi_choice('["Red", "Blue"]')
        assert result == ["Red", "Blue"]

    def test_parse_csv_fallback(self):
        from app.api.v1.responses import _parse_multi_choice
        result = _parse_multi_choice("Red,Blue,Green")
        assert result == ["Red", "Blue", "Green"]

    def test_parse_invalid_json_falls_back(self):
        from app.api.v1.responses import _parse_multi_choice
        result = _parse_multi_choice("{not_array}")
        assert result == ["{not_array}"]

    def test_parse_json_non_list_falls_back(self):
        """Line 98: parsed is not a list -> falls back to csv."""
        from app.api.v1.responses import _parse_multi_choice
        result = _parse_multi_choice('"just_a_string"')
        assert result == ['"just_a_string"']


class TestNormalizeResponseValue:
    """Cover lines 107-108: _normalize_response_value for multi_choice."""

    def test_normalize_multi_choice_csv(self):
        from app.api.v1.responses import _normalize_response_value
        result = _normalize_response_value("Red,Blue", "multi_choice")
        assert result == '["Red", "Blue"]'

    def test_normalize_non_multi_choice(self):
        from app.api.v1.responses import _normalize_response_value
        result = _normalize_response_value("42", "number")
        assert result == "42"
