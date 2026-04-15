# Created with the Assistance of Claude Code
# backend/tests/api/test_require_role.py
"""
Tests for require_role() dependency factory in app/api/deps.py.

Tests cover:
- Role-based access: allowed roles pass, disallowed roles get 403
- Admin impersonation via ViewingAsUserID in Sessions
- Error handling: missing auth (401), DB errors (500)
- Return value: enriched user dict with effective_account_id and effective_role_id
"""

import pytest
from unittest.mock import patch, MagicMock
from fastapi import FastAPI, Depends
from fastapi.testclient import TestClient
import mysql.connector

from app.api.deps import require_role, hash_token


# ---------------------------------------------------------------------------
# Test app with a require_role(2, 4) endpoint
# ---------------------------------------------------------------------------

_test_app = FastAPI()


@_test_app.get("/protected")
def protected_endpoint(user=Depends(require_role(2, 4))):
    """Endpoint requiring researcher (2) or admin (4) role."""
    return {
        "account_id": user["account_id"],
        "effective_account_id": user["effective_account_id"],
        "effective_role_id": user["effective_role_id"],
    }


@pytest.fixture
def client():
    return TestClient(_test_app)


def _mock_auth_and_role(mock_db, *, account_id=1, email="user@example.com",
                        role_id=2, viewing_as_user_id=None,
                        target_role_id=None):
    """
    Helper to set up mocked DB for get_current_user + require_role flow.

    get_current_user opens one connection that JOINs RoleID and ViewingAsUserID.
    require_role only opens a second connection via _get_role_for_account()
    when viewing_as_user_id is set.
    """
    # --- Connection 1: get_current_user ---
    auth_cursor = MagicMock()
    auth_cursor.fetchone.return_value = {
        "AccountID": account_id,
        "Email": email,
        "TosAcceptedAt": "2026-01-01",
        "TosVersion": "1.0",
        "RoleID": role_id,
        "ViewingAsUserID": viewing_as_user_id,
    }
    auth_conn = MagicMock()
    auth_conn.cursor.return_value = auth_cursor

    if viewing_as_user_id is not None:
        # --- Connection 2: _get_role_for_account (only when viewing-as) ---
        effective_role = target_role_id if target_role_id is not None else role_id
        role_cursor = MagicMock()
        role_cursor.fetchone.return_value = {"RoleID": effective_role}
        role_conn = MagicMock()
        role_conn.cursor.return_value = role_cursor
        mock_db.side_effect = [auth_conn, role_conn]
    else:
        mock_db.side_effect = [auth_conn]


# ============================================================================
# ROLE ACCESS TESTS
# ============================================================================

class TestRoleAccess:
    """Tests that require_role allows/denies based on RoleID."""

    @patch("app.api.deps.get_db_connection")
    def test_researcher_allowed(self, mock_db, client):
        """Researcher (RoleID=2) should access require_role(2, 4) endpoint."""
        _mock_auth_and_role(mock_db, account_id=10, role_id=2)

        response = client.get(
            "/protected",
            headers={"Authorization": "Bearer valid_token"}
        )

        assert response.status_code == 200
        data = response.json()
        assert data["account_id"] == 10
        assert data["effective_account_id"] == 10
        assert data["effective_role_id"] == 2

    @patch("app.api.deps.get_db_connection")
    def test_admin_allowed(self, mock_db, client):
        """Admin (RoleID=4) should access require_role(2, 4) endpoint."""
        _mock_auth_and_role(mock_db, account_id=1, role_id=4)

        response = client.get(
            "/protected",
            headers={"Authorization": "Bearer admin_token"}
        )

        assert response.status_code == 200
        data = response.json()
        assert data["effective_role_id"] == 4

    @patch("app.api.deps.get_db_connection")
    def test_participant_denied(self, mock_db, client):
        """Participant (RoleID=1) should be denied with 403."""
        _mock_auth_and_role(mock_db, account_id=5, role_id=1)

        response = client.get(
            "/protected",
            headers={"Authorization": "Bearer participant_token"}
        )

        assert response.status_code == 403
        assert "Insufficient role permissions" in response.json()["detail"]

    @patch("app.api.deps.get_db_connection")
    def test_hcp_denied(self, mock_db, client):
        """HCP (RoleID=3) should be denied with 403 on require_role(2, 4)."""
        _mock_auth_and_role(mock_db, account_id=7, role_id=3)

        response = client.get(
            "/protected",
            headers={"Authorization": "Bearer hcp_token"}
        )

        assert response.status_code == 403


# ============================================================================
# IMPERSONATION TESTS
# ============================================================================

class TestImpersonation:
    """Tests for admin ViewingAsUserID impersonation in require_role."""

    @patch("app.api.deps.get_db_connection")
    def test_admin_impersonating_researcher_allowed(self, mock_db, client):
        """Admin viewing-as researcher should pass require_role(2, 4)."""
        _mock_auth_and_role(
            mock_db,
            account_id=1,        # admin's own account
            role_id=4,           # admin's role
            viewing_as_user_id=5,  # target user
            target_role_id=2,      # target is researcher
        )

        response = client.get(
            "/protected",
            headers={"Authorization": "Bearer admin_token"}
        )

        assert response.status_code == 200
        data = response.json()
        assert data["account_id"] == 1            # original admin
        assert data["effective_account_id"] == 5   # impersonated user
        assert data["effective_role_id"] == 2      # researcher role

    @patch("app.api.deps.get_db_connection")
    def test_admin_impersonating_participant_still_allowed(self, mock_db, client):
        """Admin viewing-as participant should still pass require_role(2, 4)
        because real_role is admin (4). This allows admin to reach endpoints
        like view-as/end even while viewing-as a lower-role user."""
        _mock_auth_and_role(
            mock_db,
            account_id=1,
            role_id=4,
            viewing_as_user_id=8,
            target_role_id=1,  # participant
        )

        response = client.get(
            "/protected",
            headers={"Authorization": "Bearer admin_token"}
        )

        assert response.status_code == 200
        data = response.json()
        assert data["account_id"] == 1            # original admin
        assert data["effective_account_id"] == 8   # viewed-as user
        assert data["effective_role_id"] == 1      # participant role (for business logic)


# ============================================================================
# AUTH ERROR TESTS
# ============================================================================

class TestAuthErrors:
    """Tests for authentication and error handling in require_role."""

    def test_missing_token_returns_401(self, client):
        """Missing Authorization header should return 401."""
        response = client.get("/protected")

        assert response.status_code == 401
        assert "Not authenticated" in response.json()["detail"]

    @patch("app.api.deps.get_db_connection")
    def test_invalid_token_returns_401(self, mock_db, client):
        """Invalid/expired session token should return 401."""
        auth_cursor = MagicMock()
        auth_cursor.fetchone.return_value = None  # no session found
        auth_conn = MagicMock()
        auth_conn.cursor.return_value = auth_cursor
        mock_db.return_value = auth_conn

        response = client.get(
            "/protected",
            headers={"Authorization": "Bearer invalid_token"}
        )

        assert response.status_code == 401
        assert "Invalid or expired session" in response.json()["detail"]

    @patch("app.api.deps.get_db_connection")
    def test_db_error_in_role_check_returns_500(self, mock_db, client):
        """Database error during view-as role lookup should return 500."""
        # Auth connection succeeds — admin viewing-as another user
        auth_cursor = MagicMock()
        auth_cursor.fetchone.return_value = {
            "AccountID": 1,
            "Email": "admin@example.com",
            "TosAcceptedAt": "2026-01-01",
            "TosVersion": "1.0",
            "RoleID": 4,
            "ViewingAsUserID": 5,
        }
        auth_conn = MagicMock()
        auth_conn.cursor.return_value = auth_cursor

        # _get_role_for_account connection raises DB error
        role_conn = MagicMock()
        role_cursor = MagicMock()
        role_cursor.fetchone.side_effect = mysql.connector.Error("Connection lost")
        role_conn.cursor.return_value = role_cursor

        mock_db.side_effect = [auth_conn, role_conn]

        response = client.get(
            "/protected",
            headers={"Authorization": "Bearer valid_token"}
        )

        assert response.status_code == 500
        assert "Role check failed" in response.json()["detail"]


# ============================================================================
# RETURN VALUE TESTS
# ============================================================================

class TestReturnValue:
    """Tests that require_role returns the correct enriched user dict."""

    @patch("app.api.deps.get_db_connection")
    def test_returns_effective_fields(self, mock_db, client):
        """Should return effective_account_id and effective_role_id in user dict."""
        _mock_auth_and_role(mock_db, account_id=10, role_id=2)

        response = client.get(
            "/protected",
            headers={"Authorization": "Bearer valid_token"}
        )

        assert response.status_code == 200
        data = response.json()
        assert "account_id" in data
        assert "effective_account_id" in data
        assert "effective_role_id" in data
        assert data["account_id"] == 10
        assert data["effective_account_id"] == 10  # no impersonation
        assert data["effective_role_id"] == 2
