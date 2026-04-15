# backend/tests/api/test_sessions.py

"""
TDD Tests for Session API

Endpoints tested:
- POST   /api/v1/sessions/validate
- DELETE /api/v1/sessions/logout
- GET    /api/v1/sessions/me
"""

import pytest
from unittest.mock import patch, MagicMock
from datetime import datetime, timedelta


class TestValidateSession:

    def test_validate_valid_session(self, client):
        """Validate with a token in the request body."""
        with patch("app.api.v1.sessions.get_db_connection") as mock_db, \
             patch("app.api.v1.sessions.hash_token", return_value="hashed"):

            mock_cursor = MagicMock()
            mock_cursor.fetchone.return_value = {
                "SessionID": 1,
                "AccountID": 1,
                "ExpiresAt": datetime.utcnow() + timedelta(hours=1),
            }
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            response = client.post(
                "/api/v1/sessions/validate",
                json={"token": "some-token"},
            )

            assert response.status_code == 200
            data = response.json()
            assert data["valid"] is True
            assert "account_id" in data

    def test_validate_invalid_token(self, client):
        """Invalid token returns 401."""
        with patch("app.api.v1.sessions.get_db_connection") as mock_db, \
             patch("app.api.v1.sessions.hash_token", return_value="hashed"):

            mock_cursor = MagicMock()
            mock_cursor.fetchone.return_value = None
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            response = client.post(
                "/api/v1/sessions/validate",
                json={"token": "totally-invalid-token"},
            )

            assert response.status_code == 401


class TestLogoutSession:

    def test_logout_success_via_cookie(self, client):
        """Logout using cookie-based session token."""
        with patch("app.api.v1.sessions.get_db_connection") as mock_db, \
             patch("app.api.v1.sessions.hash_token", return_value="hashed"):

            mock_cursor = MagicMock()
            mock_cursor.rowcount = 1
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            response = client.request(
                "DELETE",
                "/api/v1/sessions/logout",
                cookies={"session_token": "valid-token"},
            )

            assert response.status_code == 200
            assert response.json()["message"] == "logged out"

    def test_logout_no_cookie_returns_401(self, client):
        """Logout without a cookie returns 401."""
        response = client.request(
            "DELETE",
            "/api/v1/sessions/logout",
        )

        assert response.status_code == 401

    def test_logout_nonexistent_session_returns_404(self, client):
        """Logout with a cookie whose session doesn't exist returns 404."""
        with patch("app.api.v1.sessions.get_db_connection") as mock_db, \
             patch("app.api.v1.sessions.hash_token", return_value="hashed"):

            mock_cursor = MagicMock()
            mock_cursor.rowcount = 0
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            response = client.request(
                "DELETE",
                "/api/v1/sessions/logout",
                cookies={"session_token": "expired-token"},
            )

            assert response.status_code == 404


class TestSessionsCreateRemoved:

    def test_create_endpoint_removed(self, client):
        """POST /sessions/create should no longer exist (returns 405 or 404)."""
        response = client.post(
            "/api/v1/sessions/create",
            json={"account_id": 1},
        )

        # FastAPI returns 405 Method Not Allowed when no POST route, or 404
        assert response.status_code in (404, 405)


class TestGetSessionMe:

    def test_session_me_returns_user_info(self, client):
        """GET /sessions/me returns user info via get_current_user (mocked by conftest)."""
        with patch("app.api.v1.sessions.get_db_connection") as mock_db:

            mock_cursor = MagicMock()
            mock_cursor.fetchone.return_value = {
                "FirstName": "Test",
                "LastName": "Admin",
                "Email": "testadmin@example.com",
                "RoleID": 4,
                "RoleName": "admin",
                "ExpiresAt": datetime.utcnow() + timedelta(hours=1),
                "ImpersonatedBy": None,
                "Birthdate": None,
                "Gender": None,
            }
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            response = client.get("/api/v1/sessions/me")

            assert response.status_code == 200
            data = response.json()
            assert data["user"]["account_id"] == 999  # from conftest mock
            assert data["is_impersonating"] is False


# ------------------------------------------------
# Additional coverage tests for missing lines
# ------------------------------------------------

class TestCreateSessionErrorPath:
    """Cover lines 128-130 in sessions.py (create_session_for_account mysql error)."""

    def test_create_session_mysql_error(self):
        """Lines 128-130: mysql.connector.Error -> HTTPException 500."""
        import mysql.connector
        from app.api.v1.sessions import create_session_for_account

        with patch("app.api.v1.sessions.get_db_connection") as mock_db:
            mock_db.side_effect = mysql.connector.Error(msg="Connection refused")

            with pytest.raises(Exception) as exc_info:
                create_session_for_account(1, "127.0.0.1", "test-agent")
            # Should raise HTTPException with status 500
            assert exc_info.value.status_code == 500
            assert "Failed to create session" in exc_info.value.detail


class TestValidateSessionErrorPaths:
    """Cover lines 259, 267-268."""

    def test_validate_expired_session(self, client):
        """Line 259: Expired session -> 401."""
        with patch("app.api.v1.sessions.get_db_connection") as mock_db, \
             patch("app.api.v1.sessions.hash_token", return_value="hashed"):
            mock_cursor = MagicMock()
            mock_cursor.fetchone.return_value = {
                "SessionID": 1,
                "AccountID": 1,
                "ExpiresAt": datetime.utcnow() - timedelta(hours=1),
            }
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            response = client.post(
                "/api/v1/sessions/validate",
                json={"token": "expired-token"},
            )
            assert response.status_code == 401
            assert "expired" in response.json()["detail"].lower()

    def test_validate_mysql_error(self, client):
        """Lines 267-268: mysql.connector.Error -> 500."""
        import mysql.connector

        with patch("app.api.v1.sessions.get_db_connection") as mock_db, \
             patch("app.api.v1.sessions.hash_token", return_value="hashed"):
            mock_db.side_effect = mysql.connector.Error(msg="DB down")

            response = client.post(
                "/api/v1/sessions/validate",
                json={"token": "some-token"},
            )
            assert response.status_code == 500
            assert "Session validation failed" in response.json()["detail"]


class TestLogoutErrorPath:
    """Cover lines 309-310."""

    def test_logout_mysql_error(self, client):
        """Lines 309-310: mysql.connector.Error -> 500."""
        import mysql.connector

        with patch("app.api.v1.sessions.get_db_connection") as mock_db, \
             patch("app.api.v1.sessions.hash_token", return_value="hashed"):
            mock_db.side_effect = mysql.connector.Error(msg="DB down")

            response = client.request(
                "DELETE",
                "/api/v1/sessions/logout",
                cookies={"session_token": "valid-token"},
            )
            assert response.status_code == 500
            assert "Logout failed" in response.json()["detail"]


class TestSessionMeErrorPaths:
    """Cover lines 209, 342, 408-419, 446-450."""

    def test_session_me_no_row_returns_500(self, client):
        """Line 342: No row found -> 500."""
        with patch("app.api.v1.sessions.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            mock_cursor.fetchone.return_value = None
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            response = client.get("/api/v1/sessions/me")
            assert response.status_code == 500
            assert "Failed to get session info" in response.json()["detail"]

    def test_session_me_with_consent_and_profile_status(self, client):
        """Lines 408-419: Cover has_signed_consent=False and needs_profile_completion=True."""
        from app.api.deps import get_current_user
        from app.main import app

        mock_user = {
            "account_id": 10,
            "email": "participant@test.com",
            "role_id": 1,
            "viewing_as_user_id": None,
        }

        with patch("app.api.v1.sessions.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            mock_cursor.fetchone.return_value = {
                "FirstName": "Participant",
                "LastName": "User",
                "Email": "participant@test.com",
                "RoleID": 1,
                "RoleName": "participant",
                "ExpiresAt": datetime.utcnow() + timedelta(hours=1),
                "ImpersonatedBy": None,
                "ConsentVersion": None,
                "Birthdate": None,
                "Gender": None,
            }
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            app.dependency_overrides[get_current_user] = lambda: mock_user
            try:
                response = client.get("/api/v1/sessions/me")
                assert response.status_code == 200
                data = response.json()
                assert data["has_signed_consent"] is False
                assert data["needs_profile_completion"] is True
            finally:
                app.dependency_overrides.pop(get_current_user, None)

    def test_session_me_legacy_impersonation(self, client):
        """Lines 408-419: ImpersonatedBy is not None -> legacy impersonation info."""
        with patch("app.api.v1.sessions.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            # First call: user row, Second call: admin row
            mock_cursor.fetchone.side_effect = [
                {
                    "FirstName": "Test",
                    "LastName": "Admin",
                    "Email": "testadmin@example.com",
                    "RoleID": 4,
                    "RoleName": "admin",
                    "ExpiresAt": datetime.utcnow() + timedelta(hours=1),
                    "ImpersonatedBy": 888,
                    "ConsentVersion": "1.0",
                    "Birthdate": None,
                    "Gender": None,
                },
                {
                    "AccountID": 888,
                    "FirstName": "Real",
                    "LastName": "Admin",
                    "Email": "realadmin@example.com",
                },
            ]
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            response = client.get("/api/v1/sessions/me")
            assert response.status_code == 200
            data = response.json()
            assert data["is_impersonating"] is True
            assert data["impersonation_info"]["admin_account_id"] == 888

    def test_session_me_mysql_error(self, client):
        """Lines 446-450: mysql.connector.Error -> 500."""
        import mysql.connector

        with patch("app.api.v1.sessions.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            mock_cursor.execute.side_effect = mysql.connector.Error(msg="DB down")
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            response = client.get("/api/v1/sessions/me")
            assert response.status_code == 500
            assert "Failed to get session info" in response.json()["detail"]

    def test_session_me_returns_must_change_password_true(self, client):
        """must_change_password=True is propagated when MustChangePassword flag is set."""
        with patch("app.api.v1.sessions.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            mock_cursor.fetchone.return_value = {
                "FirstName": "Temp",
                "LastName": "User",
                "Email": "temp@example.com",
                "RoleID": 1,
                "RoleName": "participant",
                "ExpiresAt": datetime.utcnow() + timedelta(hours=1),
                "ImpersonatedBy": None,
                "ConsentVersion": None,
                "Birthdate": None,
                "Gender": None,
                "MustChangePassword": True,
            }
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            response = client.get("/api/v1/sessions/me")
            assert response.status_code == 200
            assert response.json()["must_change_password"] is True

    def test_session_me_returns_must_change_password_false_by_default(self, client):
        """must_change_password defaults to False when flag is not set."""
        with patch("app.api.v1.sessions.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            from datetime import date
            mock_cursor.fetchone.return_value = {
                "FirstName": "Normal",
                "LastName": "User",
                "Email": "normal@example.com",
                "RoleID": 1,
                "RoleName": "participant",
                "ExpiresAt": datetime.utcnow() + timedelta(hours=1),
                "ImpersonatedBy": None,
                "ConsentVersion": "1.0",
                "Birthdate": date(1990, 1, 1),
                "Gender": "Female",
                "MustChangePassword": False,
            }
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            response = client.get("/api/v1/sessions/me")
            assert response.status_code == 200
            assert response.json()["must_change_password"] is False


class TestConsentRequiredSetting:
    """When consent_required=False, has_signed_consent must be True regardless of ConsentVersion."""

    def test_session_me_consent_not_required_returns_has_signed_true(self, client):
        """has_signed_consent=True when consent_required setting is disabled."""
        from app.api.deps import get_current_user
        from app.main import app

        mock_user = {
            "account_id": 10,
            "email": "participant@test.com",
            "role_id": 1,
            "viewing_as_user_id": None,
        }

        with patch("app.api.v1.sessions.get_db_connection") as mock_db, \
             patch("app.api.v1.sessions.get_bool_setting", return_value=False):

            mock_cursor = MagicMock()
            mock_cursor.fetchone.return_value = {
                "FirstName": "Participant",
                "LastName": "User",
                "Email": "participant@test.com",
                "RoleID": 1,
                "RoleName": "participant",
                "ExpiresAt": datetime.utcnow() + timedelta(hours=1),
                "ImpersonatedBy": None,
                "ConsentVersion": None,  # would normally force has_signed=False
                "Birthdate": None,
                "Gender": None,
                "MustChangePassword": False,
            }
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            app.dependency_overrides[get_current_user] = lambda: mock_user
            try:
                response = client.get("/api/v1/sessions/me")
                assert response.status_code == 200
                assert response.json()["has_signed_consent"] is True
            finally:
                app.dependency_overrides.pop(get_current_user, None)


class TestGetToken:
    """Cover line 209: get_token extracts from Authorization header."""

    def test_get_token_from_bearer_header(self):
        """Line 209: Authorization Bearer fallback."""
        from app.api.v1.sessions import get_token

        request = MagicMock()
        request.cookies.get.return_value = None
        request.headers.get.return_value = "Bearer my_token_123"

        result = get_token(request)
        assert result == "my_token_123"

    def test_get_token_no_token(self):
        """Returns None when no token available."""
        from app.api.v1.sessions import get_token

        request = MagicMock()
        request.cookies.get.return_value = None
        request.headers.get.return_value = None

        result = get_token(request)
        assert result is None
