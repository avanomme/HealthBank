# Created with the Assistance of Claude Code
# backend/tests/api/test_profile_completion.py
"""Tests for the profile completion endpoint and needs_profile_completion flag."""

import pytest
from unittest.mock import patch, MagicMock
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


# ── POST /api/v1/auth/complete_profile ──────────────────────────────

class TestCompleteProfile:
    """Tests for POST /auth/complete_profile endpoint."""

    def test_participant_completes_profile(self):
        """Participant can submit birthdate and gender."""
        with patch("app.api.v1.auth.get_db_connection") as mock_db:
            conn = MagicMock()
            cursor = MagicMock()
            conn.cursor.return_value = cursor
            mock_db.return_value = conn

            # SELECT RoleID returns participant (1)
            cursor.fetchone.return_value = (1,)

            response = client.post(
                "/api/v1/auth/complete_profile",
                json={"birthdate": "1990-05-15", "gender": "Male"},
            )

            assert response.status_code == 200
            assert response.json()["message"] == "Profile completed successfully"

            # Verify UPDATE was called
            update_call = cursor.execute.call_args_list[-1]
            assert "UPDATE AccountData SET Birthdate" in update_call[0][0]

    def test_researcher_rejected(self):
        """Non-participants get 403."""
        with patch("app.api.v1.auth.get_db_connection") as mock_db:
            conn = MagicMock()
            cursor = MagicMock()
            conn.cursor.return_value = cursor
            mock_db.return_value = conn

            # SELECT RoleID returns researcher (2)
            cursor.fetchone.return_value = (2,)

            response = client.post(
                "/api/v1/auth/complete_profile",
                json={"birthdate": "1990-05-15", "gender": "Male"},
            )

            assert response.status_code == 403
            assert "Only participants" in response.json()["detail"]

    def test_hcp_rejected(self):
        """HCPs get 403."""
        with patch("app.api.v1.auth.get_db_connection") as mock_db:
            conn = MagicMock()
            cursor = MagicMock()
            conn.cursor.return_value = cursor
            mock_db.return_value = conn

            # SELECT RoleID returns HCP (3)
            cursor.fetchone.return_value = (3,)

            response = client.post(
                "/api/v1/auth/complete_profile",
                json={"birthdate": "1990-05-15", "gender": "Male"},
            )

            assert response.status_code == 403

    def test_missing_birthdate_returns_422(self):
        """Missing birthdate returns 422 validation error."""
        response = client.post(
            "/api/v1/auth/complete_profile",
            json={"gender": "Male"},
        )
        assert response.status_code == 422

    def test_missing_gender_returns_422(self):
        """Missing gender returns 422 validation error."""
        response = client.post(
            "/api/v1/auth/complete_profile",
            json={"birthdate": "1990-05-15"},
        )
        assert response.status_code == 422

    def test_empty_gender_returns_422(self):
        """Empty gender string returns 422 validation error."""
        response = client.post(
            "/api/v1/auth/complete_profile",
            json={"birthdate": "1990-05-15", "gender": ""},
        )
        assert response.status_code == 422


# ── Login response includes needs_profile_completion ────────────────

class TestLoginNeedsProfileCompletion:
    """Tests that login response includes needs_profile_completion flag."""

    @pytest.fixture(autouse=True)
    def clear_auth_override(self):
        """Clear the autouse mock_auth so we test real auth flow."""
        from app.api.deps import get_current_user
        app.dependency_overrides.pop(get_current_user, None)
        yield

    def test_participant_null_birthday_needs_profile(self):
        """Participant with null Birthdate gets needs_profile_completion=True."""
        with patch("app.api.v1.auth.get_db_connection") as mock_auth_db, \
             patch("app.api.v1.sessions.get_db_connection") as mock_session_db:

            # Auth DB: login query returns participant with null birthday/gender
            auth_conn = MagicMock()
            auth_cursor = MagicMock()
            auth_conn.cursor.return_value = auth_cursor
            mock_auth_db.return_value = auth_conn

            # Login SELECT: AccountID, PasswordHash, MustChangePassword, RoleID, Birthdate, Gender, IsActive, AuthID, FailedAttempts, LockedUntil
            from app.api.v1.auth import hash_password
            pw_hash = hash_password("TestPass123!")
            auth_cursor.fetchone.return_value = (1, pw_hash, False, 1, None, None, True, 1, 0, None)

            # Session DB
            session_conn = MagicMock()
            session_cursor = MagicMock()
            session_conn.cursor.return_value = session_cursor
            mock_session_db.return_value = session_conn

            # create_session_for_account: check for existing session, then fetch user details
            # First fetchone: check existing session (None = no existing)
            # Second fetchone: user details
            session_cursor.fetchone.side_effect = [
                None,  # No existing session
                # AccountID, FirstName, LastName, Email, RoleName, RoleID, ConsentVersion, Birthdate, Gender
                (1, "Test", "User", "test@test.com", "participant", 1, None, None, None),
            ]
            session_cursor.lastrowid = 1

            response = client.post(
                "/api/v1/auth/login",
                json={"email": "test@test.com", "password": "TestPass123!"},
            )

            assert response.status_code == 200
            data = response.json()
            assert data["needs_profile_completion"] is True

    def test_participant_with_profile_no_completion_needed(self):
        """Participant with filled Birthdate and Gender gets needs_profile_completion=False."""
        from datetime import date

        with patch("app.api.v1.auth.get_db_connection") as mock_auth_db, \
             patch("app.api.v1.sessions.get_db_connection") as mock_session_db:

            auth_conn = MagicMock()
            auth_cursor = MagicMock()
            auth_conn.cursor.return_value = auth_cursor
            mock_auth_db.return_value = auth_conn

            from app.api.v1.auth import hash_password
            pw_hash = hash_password("TestPass123!")
            # Has birthday and gender filled
            auth_cursor.fetchone.return_value = (1, pw_hash, False, 1, date(1990, 5, 15), "Male", True, 1, 0, None)

            session_conn = MagicMock()
            session_cursor = MagicMock()
            session_conn.cursor.return_value = session_cursor
            mock_session_db.return_value = session_conn

            session_cursor.fetchone.side_effect = [
                None,
                (1, "Test", "User", "test@test.com", "participant", 1, "1.0", date(1990, 5, 15), "Male"),
            ]
            session_cursor.lastrowid = 1

            response = client.post(
                "/api/v1/auth/login",
                json={"email": "test@test.com", "password": "TestPass123!"},
            )

            assert response.status_code == 200
            data = response.json()
            assert data["needs_profile_completion"] is False

    def test_researcher_never_needs_profile(self):
        """Researcher never gets needs_profile_completion=True."""
        with patch("app.api.v1.auth.get_db_connection") as mock_auth_db, \
             patch("app.api.v1.sessions.get_db_connection") as mock_session_db:

            auth_conn = MagicMock()
            auth_cursor = MagicMock()
            auth_conn.cursor.return_value = auth_cursor
            mock_auth_db.return_value = auth_conn

            from app.api.v1.auth import hash_password
            pw_hash = hash_password("TestPass123!")
            # Researcher (role_id=2) with null birthday
            auth_cursor.fetchone.return_value = (2, pw_hash, False, 2, None, None, True, 2, 0, None)

            session_conn = MagicMock()
            session_cursor = MagicMock()
            session_conn.cursor.return_value = session_cursor
            mock_session_db.return_value = session_conn

            session_cursor.fetchone.side_effect = [
                None,
                (2, "Test", "Researcher", "researcher@test.com", "researcher", 2, None, None, None),
            ]
            session_cursor.lastrowid = 1

            response = client.post(
                "/api/v1/auth/login",
                json={"email": "researcher@test.com", "password": "TestPass123!"},
            )

            assert response.status_code == 200
            data = response.json()
            assert data["needs_profile_completion"] is False
