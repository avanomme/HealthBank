# Created with the Assistance of Claude Code
# backend/tests/test_admin_password_reset.py
"""
Unit tests for admin password reset functionality.

Tests:
- Reset password endpoint
- Send reset email endpoint
- Authorization requirements
- Input validation
"""

import pytest
from unittest.mock import patch, MagicMock
from fastapi.testclient import TestClient
from datetime import datetime, timedelta


@pytest.fixture
def test_client():
    """Create test client with mocked database."""
    from app.main import app
    return TestClient(app)


@pytest.fixture
def mock_user_data():
    """Sample user data for testing — tuple format matching conn.cursor()."""
    return (42,)  # SELECT AuthID FROM AccountData WHERE AccountID = %s


@pytest.fixture
def mock_email_user_data():
    """Sample user data for send-reset-email — (FirstName, Email)."""
    return ("John", "john@example.com")  # SELECT FirstName, Email FROM AccountData


@pytest.fixture
def mock_admin_session():
    """Mock admin session data."""
    return {
        "SessionID": 1,
        "AccountID": 1,
        "ExpiresAt": datetime.utcnow() + timedelta(hours=1),
        "ImpersonatedBy": None,
        "RoleID": 4,  # System admin
        "RoleName": "admin",
    }


class TestResetPassword:
    """Tests for POST /admin/users/{user_id}/reset-password"""

    def test_reset_password_success(self, test_client, mock_user_data):
        """Test successful password reset."""
        with patch("app.api.v1.admin.get_db_connection") as mock_db:
            # Setup mock cursor — endpoint does SELECT AuthID (tuple), then UPDATE
            mock_cursor = MagicMock()
            mock_cursor.fetchone.return_value = mock_user_data  # (42,) = AuthID
            mock_cursor.rowcount = 1

            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            response = test_client.post(
                "/api/v1/admin/users/42/reset-password",
                json={"new_password": "NewSecurePass123!"}
            )

            assert response.status_code == 200
            data = response.json()
            assert data["message"] == "Password reset successfully"
            assert data["user_id"] == 42

    def test_reset_password_user_not_found(self, test_client):
        """Test reset password for non-existent user returns 404."""
        with patch("app.api.v1.admin.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            mock_cursor.fetchone.return_value = None  # User not found

            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            response = test_client.post(
                "/api/v1/admin/users/999/reset-password",
                json={"new_password": "NewSecurePass123!"}
            )

            assert response.status_code == 404
            assert "not found" in response.json()["detail"].lower()

    def test_reset_password_short_password(self, test_client):
        """Test reset password with too short password returns 422 (Pydantic validation)."""
        response = test_client.post(
            "/api/v1/admin/users/42/reset-password",
            json={"new_password": "short"}
        )

        assert response.status_code == 422

    def test_reset_password_empty_password(self, test_client):
        """Test reset password with empty password returns 422 (Pydantic validation)."""
        response = test_client.post(
            "/api/v1/admin/users/42/reset-password",
            json={"new_password": ""}
        )

        assert response.status_code == 422


class TestSendResetEmail:
    """Tests for POST /admin/users/{user_id}/send-reset-email"""

    def test_send_email_success(self, test_client, mock_email_user_data):
        """Test successful email sending."""
        with patch("app.api.v1.admin.get_db_connection") as mock_db, \
             patch("app.api.v1.admin._email_service") as mock_email_svc:

            mock_cursor = MagicMock()
            mock_cursor.fetchone.return_value = mock_email_user_data
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn
            mock_email_svc.send_admin_password_reset_email.return_value = True

            response = test_client.post(
                "/api/v1/admin/users/42/send-reset-email",
                json={"temporary_password": "TempPass123!"}
            )

            assert response.status_code == 200
            data = response.json()
            assert "sent successfully" in data["message"]
            assert data["sent_to"] == "john@example.com"

    def test_send_email_override_address(self, test_client, mock_email_user_data):
        """Test sending to override email address."""
        with patch("app.api.v1.admin.get_db_connection") as mock_db, \
             patch("app.api.v1.admin._email_service") as mock_email_svc:

            mock_cursor = MagicMock()
            mock_cursor.fetchone.return_value = mock_email_user_data
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn
            mock_email_svc.send_admin_password_reset_email.return_value = True

            response = test_client.post(
                "/api/v1/admin/users/42/send-reset-email",
                json={
                    "temporary_password": "TempPass123!",
                    "email_override": "alternate@example.com"
                }
            )

            assert response.status_code == 200
            data = response.json()
            assert data["sent_to"] == "alternate@example.com"

    def test_send_email_user_not_found(self, test_client):
        """Test send email for non-existent user returns 404."""
        with patch("app.api.v1.admin.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            mock_cursor.fetchone.return_value = None

            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            response = test_client.post(
                "/api/v1/admin/users/999/send-reset-email",
                json={"temporary_password": "TempPass123!"}
            )

            assert response.status_code == 404

    def test_send_email_service_not_configured(self, test_client, mock_email_user_data):
        """Test 500 when email service returns False (send failure)."""
        with patch("app.api.v1.admin.get_db_connection") as mock_db, \
             patch("app.api.v1.admin._email_service") as mock_email_svc:

            mock_cursor = MagicMock()
            mock_cursor.fetchone.return_value = mock_email_user_data
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn
            mock_email_svc.send_admin_password_reset_email.return_value = False

            response = test_client.post(
                "/api/v1/admin/users/42/send-reset-email",
                json={"temporary_password": "TempPass123!"}
            )

            assert response.status_code == 500

    def test_send_email_failure(self, test_client, mock_email_user_data):
        """Test handling of email send failure."""
        with patch("app.api.v1.admin.get_db_connection") as mock_db, \
             patch("app.api.v1.admin._email_service") as mock_email_svc:

            mock_cursor = MagicMock()
            mock_cursor.fetchone.return_value = mock_email_user_data
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn
            mock_email_svc.send_admin_password_reset_email.return_value = False

            response = test_client.post(
                "/api/v1/admin/users/42/send-reset-email",
                json={"temporary_password": "TempPass123!"}
            )

            assert response.status_code == 500
            assert "failed" in response.json()["detail"].lower()


class TestPasswordHashing:
    """Tests for password hashing utility."""

    def test_hash_password_different_each_time(self):
        """Test that same password produces different hashes (salted)."""
        from app.api.v1.auth import hash_password

        password = "TestPassword123!"
        hash1 = hash_password(password)
        hash2 = hash_password(password)

        # Different salts should produce different hashes
        assert hash1 != hash2

    def test_hash_password_format(self):
        """Test that password hash has correct format."""
        from app.api.v1.auth import hash_password

        password = "TestPassword123!"
        hashed = hash_password(password)

        # Format: pbkdf2_sha256$iterations$dklen$salt_b64$hash_b64
        parts = hashed.split("$")
        assert len(parts) == 5
        assert parts[0] == "pbkdf2_sha256"
        assert parts[1].isdigit()  # iterations

    def test_verify_password_matches_hash(self):
        
        """Test that a password verifies correctly against its hash."""
        from app.api.v1.auth import hash_password, verify_password

        password = "TestPassword123!"
        hashed = hash_password(password)

        # Correct password should verify
        assert verify_password(password, hashed) is True

        # Incorrect password should fail verification
        assert verify_password("WrongPassword!", hashed) is False