"""
TDD Tests for Auth API

Tests Genereated with ChatGPT

These tests are written BEFORE implementation (TDD red phase).
They should FAIL until the auth API is implemented.

Endpoints and features tested:
- POST   /api/v1/auth/create_account         (account creation, duplicate, missing/invalid fields)
- POST   /api/v1/auth/login                 (login success, invalid password, nonexistent user, missing/empty fields)
- DELETE /api/v1/auth/account/{id}          (delete account, delete nonexistent)
- POST   /api/v1/auth/password_reset_request (reset request: existing, nonexistent, invalid/missing/empty email, sends email, case-insensitive, multiple requests)
- POST   /api/v1/auth/validate_password_reset (validate reset token: valid, invalid, expired, missing/empty/short)
- POST   /api/v1/auth/confirm_password_reset (confirm reset: success, invalid/expired token, short/missing/empty password, token reuse, db failure)
- POST   /api/v1/auth/change_password        (change password: success, invalid old, same as old, too short, unauthenticated)
"""

import pytest


# ------------------------
# Test data fixtures
# ------------------------

@pytest.fixture
def sample_account():
    """Valid account creation payload"""
    return {
        "email": "testuser@example.com",
        "password": "StrongPassword123!",
        "first_name": "Test",
        "last_name": "User"
    }


@pytest.fixture
def login_payload(sample_account):
    """Valid login payload"""
    return {
        "email": sample_account["email"],
        "password": sample_account["password"]
    }


# --------------------------------
# POST /api/v1/auth/create_account
# --------------------------------

class TestCreateAccount:
    """Tests for POST /api/v1/auth/create_account"""

    def test_create_account_success(self, client, sample_account):
        """Should create an account successfully"""
        response = client.post(
            "/api/v1/auth/create_account",
            json=sample_account
        )

        assert response.status_code == 201
        data = response.json()
        assert "message" in data
        assert data["message"].lower().startswith("account")

    def test_create_account_duplicate_email(self, client, sample_account):
        """Should reject duplicate email"""
        client.post("/api/v1/auth/create_account", json=sample_account)

        response = client.post(
            "/api/v1/auth/create_account",
            json=sample_account
        )

        assert response.status_code == 409  # Conflict

    def test_create_account_missing_password(self, client):
        """Should reject missing password"""
        response = client.post("/api/v1/auth/create_account", json={
            "email": "missingpass@example.com"
        })

        assert response.status_code == 422  # Validation error

    def test_create_account_invalid_email(self, client):
        """Should reject invalid email"""
        response = client.post("/api/v1/auth/create_account", json={
            "email": "not-an-email",
            "password": "password123"
        })

        assert response.status_code == 422

# ------------------------
# POST /api/v1/auth/login
# ------------------------

class TestLogin:
    """Tests for POST /api/v1/auth/login"""

    def test_login_success(self, client, sample_account, login_payload):
        """Should return session token on valid login"""
        client.post("/api/v1/auth/create_account", json=sample_account)

        response = client.post(
            "/api/v1/auth/login",
            json=login_payload
        )

        assert response.status_code == 200
        data = response.json()
        # session_token is set as HttpOnly cookie, NOT in response body
        assert "session_token" not in data
        assert "expires_at" in data

    def test_login_invalid_password(self, client, sample_account):
        """Should reject incorrect password"""
        client.post("/api/v1/auth/create_account", json=sample_account)

        response = client.post("/api/v1/auth/login", json={
            "email": sample_account["email"],
            "password": "WrongPassword!"
        })

        assert response.status_code == 401

    def test_login_nonexistent_user(self, client):
        """Should reject login for nonexistent account"""
        response = client.post("/api/v1/auth/login", json={
            "email": "doesnotexist@example.com",
            "password": "password123"
        })

        assert response.status_code == 401

    def test_login_missing_password_field(self, client):
        """Should reject missing email or password"""
        response = client.post("/api/v1/auth/login", json={
            "email": "test@example.com"
        })

        assert response.status_code == 422

    def test_login_missimg_email_field(self, client):
        """Should reject login for nonexistent account"""
        response = client.post("/api/v1/auth/login", json={
            "password": "password123"
        })

        assert response.status_code == 422

    def test_login_empty_fields(self, client):
        """Should reject login for nonexistent account"""
        response = client.post("/api/v1/auth/login", json={})

        assert response.status_code == 422

# -----------------------------------------
# DELETE /api/v1/auth/account/{account_id}
# -----------------------------------------

class TestDeleteAccount:
    """Tests for DELETE /api/v1/auth/account/{id}"""

    def test_delete_account_success(self, client, sample_account):
        """Should delete account by ID"""
        create_response = client.post(
            "/api/v1/auth/create_account",
            json=sample_account
        )
        print(create_response.status_code, create_response.json())
        account_id = create_response.json().get("account_id")
        assert account_id is not None

        response = client.delete(f"/api/v1/auth/account/{account_id}")

        assert response.status_code == 204

    def test_delete_nonexistent_account(self, client):
        """Should return 404 for nonexistent account"""
        response = client.delete("/api/v1/auth/account/999999")

        assert response.status_code == 404

# --------------------------------------
# POST /api/v1/auth/account/{account_id}
# --------------------------------------

class TestPasswordResetRequest:
    """Tests for POST /api/v1/auth/password_reset_request"""

    def test_password_reset_request_success_with_existing_email(self, client, sample_account):
        """Should accept password reset request for existing account"""
        # First create an account
        client.post("/api/v1/auth/create_account", json=sample_account)

        # Request password reset
        response = client.post(
            "/api/v1/auth/password_reset_request",
            json={"email": sample_account["email"]}
        )

        assert response.status_code == 202
        data = response.json()
        assert "message" in data
        assert "reset" in data["message"].lower()

    def test_password_reset_request_nonexistent_email(self, client):
        """Should return 202 (generic success) for nonexistent email (security: prevent account enumeration)"""
        response = client.post(
            "/api/v1/auth/password_reset_request",
            json={"email": "doesnotexist@example.com"}
        )

        assert response.status_code == 202
        data = response.json()
        assert "message" in data
        # Should NOT reveal whether account exists
        assert "If an account exists" in data["message"]

    def test_password_reset_request_invalid_email_format(self, client):
        """Should reject invalid email format"""
        response = client.post(
            "/api/v1/auth/password_reset_request",
            json={"email": "not-an-email"}
        )

        assert response.status_code == 422

    def test_password_reset_request_missing_email(self, client):
        """Should reject missing email field"""
        response = client.post(
            "/api/v1/auth/password_reset_request",
            json={}
        )

        assert response.status_code == 422

    def test_password_reset_request_empty_email(self, client):
        """Should reject empty email string"""
        response = client.post(
            "/api/v1/auth/password_reset_request",
            json={"email": ""}
        )

        assert response.status_code == 422

    def test_password_reset_request_sends_email(self, client, sample_account):
        """Should send email to existing account with reset link"""
        from unittest.mock import patch, MagicMock, AsyncMock
        from datetime import datetime, timedelta

        # Create an account
        create_resp = client.post("/api/v1/auth/create_account", json=sample_account)
        assert create_resp.status_code == 201

        # Mock the entire password reset flow to test the email sending part
        with patch("app.api.v1.auth.generate_reset_token_for_email") as mock_token_gen, \
             patch("app.api.v1.auth.get_db_connection") as mock_db_conn, \
             patch("app.api.v1.auth._email_service") as mock_email_svc:

            mock_token_gen.return_value = ("test_token_12345", datetime.utcnow() + timedelta(hours=1))
            mock_cursor = MagicMock()
            mock_cursor.fetchone.return_value = (sample_account["first_name"],)
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db_conn.return_value = mock_conn
            mock_email_svc.send_forgot_password_email.return_value = True

            response = client.post(
                "/api/v1/auth/password_reset_request",
                json={"email": sample_account["email"]}
            )

            assert response.status_code == 202
            mock_email_svc.send_forgot_password_email.assert_called_once()
            call_args = mock_email_svc.send_forgot_password_email.call_args
            assert sample_account["email"] in str(call_args)

    def test_password_reset_request_does_not_reveal_nonexistent_user(self, client):
        """Should return identical response for existent and non-existent emails (security)"""
        from unittest.mock import patch, MagicMock

        # Create an account
        sample_account = {
            "email": "exists@example.com",
            "password": "StrongPassword123!",
            "first_name": "Test",
            "last_name": "User"
        }
        client.post("/api/v1/auth/create_account", json=sample_account)

        with patch("app.api.v1.auth._email_service"):

            # Request for existing account
            response_existing = client.post(
                "/api/v1/auth/password_reset_request",
                json={"email": "exists@example.com"}
            )

            # Request for non-existent account
            response_nonexistent = client.post(
                "/api/v1/auth/password_reset_request",
                json={"email": "doesnotexist@example.com"}
            )

            # Both should return 202
            assert response_existing.status_code == 202
            assert response_nonexistent.status_code == 202

            # Both should have similar message structure (generic response)
            data_existing = response_existing.json()
            data_nonexistent = response_nonexistent.json()
            assert data_existing["message"] == data_nonexistent["message"]

    def test_password_reset_request_case_insensitive_email(self, client, sample_account):
        """Should handle email lookup case-insensitively"""
        from unittest.mock import patch, MagicMock

        # Create account with lowercase email
        client.post("/api/v1/auth/create_account", json=sample_account)

        with patch("app.api.v1.auth._email_service"):

            # Request with uppercase email
            response = client.post(
                "/api/v1/auth/password_reset_request",
                json={"email": sample_account["email"].upper()}
            )

            assert response.status_code == 202

    def test_password_reset_request_includes_reset_link(self, client, sample_account):
        """Should include reset link in email content"""
        from unittest.mock import patch, MagicMock, AsyncMock
        from datetime import datetime, timedelta

        create_resp = client.post("/api/v1/auth/create_account", json=sample_account)
        assert create_resp.status_code == 201

        with patch("app.api.v1.auth.generate_reset_token_for_email") as mock_token_gen, \
             patch("app.api.v1.auth.get_db_connection") as mock_db_conn, \
             patch("app.api.v1.auth._email_service") as mock_email_svc:

            mock_token_gen.return_value = ("test_reset_token_abc123", datetime.utcnow() + timedelta(hours=1))
            mock_cursor = MagicMock()
            mock_cursor.fetchone.return_value = (sample_account["first_name"],)
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db_conn.return_value = mock_conn
            mock_email_svc.send_forgot_password_email.return_value = True

            response = client.post(
                "/api/v1/auth/password_reset_request",
                json={"email": sample_account["email"]}
            )

            assert response.status_code == 202
            mock_email_svc.send_forgot_password_email.assert_called_once()
            call_args = mock_email_svc.send_forgot_password_email.call_args
            # Check that the reset link containing the token was passed
            email_content = str(call_args)
            assert "reset-password" in email_content and "token" in email_content.lower()

    def test_password_reset_request_multiple_requests_same_email(self, client, sample_account):
        """Should allow multiple reset requests for same email"""
        from unittest.mock import patch, MagicMock, AsyncMock
        from datetime import datetime, timedelta

        create_resp = client.post("/api/v1/auth/create_account", json=sample_account)
        assert create_resp.status_code == 201

        with patch("app.api.v1.auth.generate_reset_token_for_email") as mock_token_gen, \
             patch("app.api.v1.auth.get_db_connection") as mock_db_conn, \
             patch("app.api.v1.auth._email_service") as mock_email_svc:

            mock_token_gen.return_value = ("test_token_xyz", datetime.utcnow() + timedelta(hours=1))
            mock_cursor = MagicMock()
            mock_cursor.fetchone.return_value = (sample_account["first_name"],)
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db_conn.return_value = mock_conn
            mock_email_svc.send_forgot_password_email.return_value = True

            # First request
            response1 = client.post(
                "/api/v1/auth/password_reset_request",
                json={"email": sample_account["email"]}
            )

            # Second request
            response2 = client.post(
                "/api/v1/auth/password_reset_request",
                json={"email": sample_account["email"]}
            )

            assert response1.status_code == 202
            assert response2.status_code == 202
            # Email service should be called twice
            assert mock_email_svc.send_forgot_password_email.call_count == 2

# --------------------------------------
# POST /api/v1/auth/validate_password_reset
# --------------------------------------

class TestValidatePasswordReset:
    """Tests for POST /api/v1/auth/validate_password_reset"""

    def test_validate_password_reset_valid_token(self, client):
        """Should return valid=True for a valid token"""
        from unittest.mock import patch

        with patch("app.api.v1.auth.get_authid_by_valid_reset_token") as mock_validate:
            mock_validate.return_value = 123  # Return a valid auth_id

            response = client.post(
                "/api/v1/auth/validate_password_reset",
                json={"token": "valid_token_12345"}
            )

            assert response.status_code == 200
            data = response.json()
            assert data["valid"] is True

    def test_validate_password_reset_invalid_token(self, client):
        """Should return 400 for invalid token"""
        from unittest.mock import patch

        with patch("app.api.v1.auth.get_authid_by_valid_reset_token") as mock_validate:
            mock_validate.return_value = None  # Invalid token

            response = client.post(
                "/api/v1/auth/validate_password_reset",
                json={"token": "invalid_token"}
            )

            assert response.status_code == 400
            data = response.json()
            assert "detail" in data
            assert "invalid" in data["detail"].lower() or "expired" in data["detail"].lower()

    def test_validate_password_reset_expired_token(self, client):
        """Should return 400 for expired token"""
        from unittest.mock import patch

        with patch("app.api.v1.auth.get_authid_by_valid_reset_token") as mock_validate:
            mock_validate.return_value = None  # Expired token returns None

            response = client.post(
                "/api/v1/auth/validate_password_reset",
                json={"token": "expired_token_xyz"}
            )

            assert response.status_code == 400

    def test_validate_password_reset_missing_token(self, client):
        """Should return 422 for missing token field"""
        response = client.post(
            "/api/v1/auth/validate_password_reset",
            json={}
        )

        assert response.status_code == 422

    def test_validate_password_reset_empty_token(self, client):
        """Should return 422 for empty token"""
        response = client.post(
            "/api/v1/auth/validate_password_reset",
            json={"token": ""}
        )

        assert response.status_code == 422

    def test_validate_password_reset_token_too_short(self, client):
        """Should return 422 for token that's too short"""
        response = client.post(
            "/api/v1/auth/validate_password_reset",
            json={"token": "short"}
        )

        assert response.status_code == 422

# --------------------------------------
# POST /api/v1/auth/confirm_password_reset
# --------------------------------------

class TestConfirmPasswordReset:
    """Tests for POST /api/v1/auth/confirm_password_reset"""

    def test_confirm_password_reset_success(self, client):
        """Should successfully reset password with valid token"""
        from unittest.mock import patch, MagicMock

        with patch("app.api.v1.auth.get_authid_by_valid_reset_token") as mock_validate, \
             patch("app.api.v1.auth.hash_password") as mock_hash, \
             patch("app.api.v1.auth.get_db_connection") as mock_db_conn, \
             patch("app.api.v1.auth.clear_reset_token") as mock_clear:
            
            mock_validate.return_value = 123  # Valid auth_id
            mock_hash.return_value = "hashed_new_password"
            
            # Mock database update
            mock_cursor = MagicMock()
            mock_cursor.rowcount = 1
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db_conn.return_value = mock_conn

            response = client.post(
                "/api/v1/auth/confirm_password_reset",
                json={
                    "token": "valid_reset_token_12345",
                    "new_password": "NewSecurePass123!"
                }
            )

            assert response.status_code == 200
            data = response.json()
            assert "message" in data
            assert "reset" in data["message"].lower() or "success" in data["message"].lower()
            
            # Verify token was cleared
            mock_clear.assert_called_once_with("valid_reset_token_12345")

    def test_confirm_password_reset_invalid_token(self, client):
        """Should reject invalid token"""
        from unittest.mock import patch

        with patch("app.api.v1.auth.get_authid_by_valid_reset_token") as mock_validate:
            mock_validate.return_value = None  # Invalid token

            response = client.post(
                "/api/v1/auth/confirm_password_reset",
                json={
                    "token": "invalid_token",
                    "new_password": "NewSecurePass123!"
                }
            )

            assert response.status_code == 400
            data = response.json()
            assert "detail" in data
            assert "invalid" in data["detail"].lower() or "expired" in data["detail"].lower()

    def test_confirm_password_reset_expired_token(self, client):
        """Should reject expired token"""
        from unittest.mock import patch

        with patch("app.api.v1.auth.get_authid_by_valid_reset_token") as mock_validate:
            mock_validate.return_value = None  # Expired token returns None

            response = client.post(
                "/api/v1/auth/confirm_password_reset",
                json={
                    "token": "expired_token_xyz",
                    "new_password": "NewSecurePass123!"
                }
            )

            assert response.status_code == 400

    def test_confirm_password_reset_password_too_short(self, client):
        """Should reject password shorter than 8 characters"""
        response = client.post(
            "/api/v1/auth/confirm_password_reset",
            json={
                "token": "valid_token_12345",
                "new_password": "Short1!"
            }
        )

        assert response.status_code == 422

    def test_confirm_password_reset_missing_token(self, client):
        """Should reject missing token field"""
        response = client.post(
            "/api/v1/auth/confirm_password_reset",
            json={
                "new_password": "NewSecurePass123!"
            }
        )

        assert response.status_code == 422

    def test_confirm_password_reset_missing_password(self, client):
        """Should reject missing password field"""
        response = client.post(
            "/api/v1/auth/confirm_password_reset",
            json={
                "token": "valid_token_12345"
            }
        )

        assert response.status_code == 422

    def test_confirm_password_reset_empty_password(self, client):
        """Should reject empty password"""
        response = client.post(
            "/api/v1/auth/confirm_password_reset",
            json={
                "token": "valid_token_12345",
                "new_password": ""
            }
        )

        assert response.status_code == 422

    def test_confirm_password_reset_token_reuse(self, client):
        """Should not allow token reuse after successful reset"""
        from unittest.mock import patch, MagicMock

        with patch("app.api.v1.auth.get_authid_by_valid_reset_token") as mock_validate, \
             patch("app.api.v1.auth.hash_password") as mock_hash, \
             patch("app.api.v1.auth.get_db_connection") as mock_db_conn, \
             patch("app.api.v1.auth.clear_reset_token"):
            
            # First request - token is valid
            mock_validate.return_value = 123
            mock_hash.return_value = "hashed_new_password"
            
            mock_cursor = MagicMock()
            mock_cursor.rowcount = 1
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db_conn.return_value = mock_conn

            response1 = client.post(
                "/api/v1/auth/confirm_password_reset",
                json={
                    "token": "one_time_token_abc",
                    "new_password": "NewSecurePass123!"
                }
            )
            assert response1.status_code == 200

            # Second request - token should be invalid now
            mock_validate.return_value = None  # Token cleared after first use

            response2 = client.post(
                "/api/v1/auth/confirm_password_reset",
                json={
                    "token": "one_time_token_abc",
                    "new_password": "AnotherPassword456!"
                }
            )
            assert response2.status_code == 400

    def test_confirm_password_reset_database_failure(self, client):
        """Should handle database update failure"""
        from unittest.mock import patch, MagicMock

        with patch("app.api.v1.auth.get_authid_by_valid_reset_token") as mock_validate, \
             patch("app.api.v1.auth.hash_password") as mock_hash, \
             patch("app.api.v1.auth.get_db_connection") as mock_db_conn:
            
            mock_validate.return_value = 123
            mock_hash.return_value = "hashed_new_password"
            
            # Mock database failure (rowcount = 0)
            mock_cursor = MagicMock()
            mock_cursor.rowcount = 0  # Update failed
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db_conn.return_value = mock_conn

            response = client.post(
                "/api/v1/auth/confirm_password_reset",
                json={
                    "token": "valid_token_12345",
                    "new_password": "NewSecurePass123!"
                }
            )

            assert response.status_code == 400

# ------------------------
# POST /api/v1/auth/change_password
# ------------------------

class TestChangePassword:
    """Tests for POST /api/v1/auth/change_password"""


    def test_change_password_success(self, client, sample_account):
        """Should change password successfully for authenticated user (mocked get_current_user, DB, and password verification)"""
        from unittest.mock import patch, MagicMock

        # Create account
        create_resp = client.post("/api/v1/auth/create_account", json=sample_account)
        assert create_resp.status_code == 201
        account_id = create_resp.json().get("account_id", 1)

        # Patch get_current_user, get_db_connection, and verify_password
        with patch("app.api.v1.auth.get_current_user", return_value={
            "account_id": account_id,
            "email": sample_account["email"]
        }), patch("app.api.v1.auth.get_db_connection") as mock_db_conn, \
            patch("app.api.v1.auth.verify_password", return_value=True):
            # Mock DB cursor to simulate user lookup and password update
            mock_cursor = MagicMock()
            # First fetchone returns (auth_id, password_hash)
            mock_cursor.fetchone.side_effect = [
                (1, "irrelevant_hash"),  # user lookup
            ]
            mock_cursor.rowcount = 1  # Simulate successful update
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db_conn.return_value = mock_conn

            new_password = "NewPassword456!"
            resp = client.post(
                "/api/v1/auth/change_password",
                json={
                    "old_password": sample_account["password"],
                    "new_password": new_password
                }
            )
            assert resp.status_code == 200
            assert "message" in resp.json()

    def test_change_password_invalid_old_password(self, client, sample_account, login_payload):
        """Should reject if old password is incorrect (mocked get_current_user, DB, and password verification)"""
        from unittest.mock import patch, MagicMock

        # Create account
        create_resp = client.post("/api/v1/auth/create_account", json=sample_account)
        assert create_resp.status_code == 201
        account_id = create_resp.json().get("account_id", 1)

        # Patch get_current_user, get_db_connection, and verify_password (return False)
        with patch("app.api.v1.auth.get_current_user", return_value={
            "account_id": account_id,
            "email": sample_account["email"]
        }), patch("app.api.v1.auth.get_db_connection") as mock_db_conn, \
            patch("app.api.v1.auth.verify_password", return_value=False):
            # Mock DB cursor to simulate user lookup
            mock_cursor = MagicMock()
            mock_cursor.fetchone.side_effect = [
                (1, "irrelevant_hash"),  # user lookup
            ]
            mock_cursor.rowcount = 1
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db_conn.return_value = mock_conn

            resp = client.post(
                "/api/v1/auth/change_password",
                json={
                    "old_password": "WrongOldPassword!",
                    "new_password": "AnotherNewPass123!"
                }
            )
            assert resp.status_code == 401
            assert "Invalid old password" in resp.json().get("detail", "")

    def test_change_password_same_as_old(self, client, sample_account, login_payload):
        """Should reject if new password is the same as old password (mocked get_current_user, DB, and password verification)"""
        from unittest.mock import patch, MagicMock

        # Create account
        create_resp = client.post("/api/v1/auth/create_account", json=sample_account)
        assert create_resp.status_code == 201
        account_id = create_resp.json().get("account_id", 1)

        # Patch get_current_user, get_db_connection, and verify_password (return True)
        with patch("app.api.v1.auth.get_current_user", return_value={
            "account_id": account_id,
            "email": sample_account["email"]
        }), patch("app.api.v1.auth.get_db_connection") as mock_db_conn, \
            patch("app.api.v1.auth.verify_password", return_value=True):
            # Mock DB cursor to simulate user lookup
            mock_cursor = MagicMock()
            mock_cursor.fetchone.side_effect = [
                (1, "irrelevant_hash"),  # user lookup
            ]
            mock_cursor.rowcount = 1
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db_conn.return_value = mock_conn

            resp = client.post(
                "/api/v1/auth/change_password",
                json={
                    "old_password": sample_account["password"],
                    "new_password": sample_account["password"]
                }
            )
            assert resp.status_code == 400
            assert "New password must be different" in resp.json().get("detail", "")

    def test_change_password_too_short(self, client, sample_account, login_payload):
        """Should reject if new password is too short"""
        client.post("/api/v1/auth/create_account", json=sample_account)
        login_resp = client.post("/api/v1/auth/login", json=login_payload)
        assert login_resp.status_code == 200

        resp = client.post(
            "/api/v1/auth/change_password",
            json={
                "old_password": sample_account["password"],
                "new_password": "short"
            },
            cookies=login_resp.cookies
        )
        assert resp.status_code == 422

    def test_change_password_unauthenticated(self, client, sample_account):
        """Should reject if not authenticated (no session) (mocked get_current_user to raise 401 and DB to prevent lookup)"""
        from unittest.mock import patch, MagicMock
        from fastapi import HTTPException

        # Create account
        client.post("/api/v1/auth/create_account", json=sample_account)

        # Patch get_current_user to raise HTTPException(401) and get_db_connection to prevent DB lookup
        def raise_unauth(*args, **kwargs):
            raise HTTPException(status_code=401, detail="Not authenticated")

        with patch("app.api.v1.auth.get_current_user", side_effect=raise_unauth), \
             patch("app.api.v1.auth.get_db_connection") as mock_db_conn:
            mock_db_conn.return_value = MagicMock()  # Prevent any real DB access
            resp = client.post(
                "/api/v1/auth/change_password",
                json={
                    "old_password": sample_account["password"],
                    "new_password": "AnotherNewPass123!"
                }
            )
            if resp.status_code not in (401, 403):
                print("change_password_unauthenticated resp.status_code:", resp.status_code)
                print("change_password_unauthenticated resp.json():", resp.json())
            assert resp.status_code in (401, 403)


# ------------------------------------------------
# Additional coverage tests for missing lines
# ------------------------------------------------

class TestCreateAccountErrorPaths:
    """Cover lines 36, 38, 45, 63, 70, 173-176 in auth.py"""

    def test_create_account_empty_name_after_strip(self, client):
        """Line 36: Name cannot be empty (whitespace-only first name)."""
        response = client.post("/api/v1/auth/create_account", json={
            "email": "emptyname@example.com",
            "password": "StrongPassword123!",
            "first_name": "   ",
            "last_name": "User",
        })
        assert response.status_code == 422

    def test_create_account_long_name(self, client):
        """Line 38: Name cannot exceed 100 characters."""
        response = client.post("/api/v1/auth/create_account", json={
            "email": "longname@example.com",
            "password": "StrongPassword123!",
            "first_name": "A" * 101,
            "last_name": "User",
        })
        assert response.status_code == 422

    def test_create_account_short_password(self, client):
        """Line 45: Password must be at least 8 characters."""
        response = client.post("/api/v1/auth/create_account", json={
            "email": "shortpw@example.com",
            "password": "short",
            "first_name": "Test",
            "last_name": "User",
        })
        assert response.status_code == 422

    def test_create_account_integrity_error_non_duplicate(self, client):
        """Lines 173-176: IntegrityError with non-1062 errno re-raises, then
        mysql.connector.Error handler catches it as 500."""
        from unittest.mock import patch, MagicMock
        import mysql.connector

        with patch("app.api.v1.auth.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            mock_cursor.execute.side_effect = mysql.connector.Error(
                msg="Some DB error", errno=9999
            )
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            response = client.post("/api/v1/auth/create_account", json={
                "email": "integ@example.com",
                "password": "StrongPassword123!",
                "first_name": "Test",
                "last_name": "User",
            })
            assert response.status_code == 500

    def test_create_account_mysql_error(self, client):
        """Lines 175-178: Generic mysql.connector.Error -> 500."""
        from unittest.mock import patch, MagicMock
        import mysql.connector

        with patch("app.api.v1.auth.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            mock_cursor.execute.side_effect = mysql.connector.Error(
                msg="Connection refused"
            )
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            response = client.post("/api/v1/auth/create_account", json={
                "email": "dberr@example.com",
                "password": "StrongPassword123!",
                "first_name": "Test",
                "last_name": "User",
            })
            assert response.status_code == 500
            assert response.json()["detail"] == "Account creation failed"


class TestLoginErrorPaths:
    """Cover lines 63, 70, 315-317, 391-392."""

    def test_login_expand_email_shortcut(self, client, sample_account):
        """Line 63: Login email shortcut (no @) -> appends @hb.com."""
        # We just want to verify the validator doesn't crash
        response = client.post("/api/v1/auth/login", json={
            "email": "admin",
            "password": "StrongPassword123!",
        })
        # Will get 401 because no account, but the shortcut was applied
        assert response.status_code == 401

    def test_login_short_password_validation(self, client):
        """Line 70: Login password < 8 chars."""
        response = client.post("/api/v1/auth/login", json={
            "email": "test@example.com",
            "password": "short",
        })
        assert response.status_code == 422

    def test_login_deactivated_account(self, client):
        """Lines 314-317: Deactivated account returns 403."""
        from unittest.mock import patch, MagicMock

        with patch("app.api.v1.auth.get_db_connection") as mock_db, \
             patch("app.api.v1.auth.verify_password", return_value=True):
            mock_cursor = MagicMock()
            # AccountID, PasswordHash, MustChangePassword, RoleID, Birthdate, Gender, IsActive
            mock_cursor.fetchone.return_value = (1, "hash", False, 1, None, None, 0, 1, 0, None)
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            response = client.post("/api/v1/auth/login", json={
                "email": "deactivated@example.com",
                "password": "StrongPassword123!",
            })
            assert response.status_code == 403
            assert response.json()["detail"] == "account_deactivated"

    def test_login_mysql_error(self, client):
        """Lines 390-392: mysql.connector.Error -> 500."""
        from unittest.mock import patch, MagicMock
        import mysql.connector

        with patch("app.api.v1.auth.get_db_connection") as mock_db:
            mock_db.side_effect = mysql.connector.Error(msg="Connection refused")

            response = client.post("/api/v1/auth/login", json={
                "email": "test@example.com",
                "password": "StrongPassword123!",
            })
            assert response.status_code == 500
            assert response.json()["detail"] == "Login failed"


class TestRequestAccountErrorPaths:
    """Cover lines 99, 125, 245-246."""

    def test_account_request_name_empty_after_strip(self, client):
        """Line 125: AccountRequestCreate name validation."""
        response = client.post("/api/v1/auth/request_account", json={
            "first_name": "   ",
            "last_name": "User",
            "email": "emptyreq@example.com",
            "role_id": 1,
        })
        assert response.status_code == 422

    def test_account_request_mysql_error(self, client):
        """Lines 245-246: mysql.connector.Error -> 500."""
        from unittest.mock import patch, MagicMock
        import mysql.connector

        with patch("app.api.v1.auth.get_db_connection") as mock_db:
            mock_db.side_effect = mysql.connector.Error(msg="Connection refused")

            response = client.post("/api/v1/auth/request_account", json={
                "first_name": "Test",
                "last_name": "User",
                "email": "reqerr@example.com",
                "role_id": 1,
            })
            assert response.status_code == 500
            assert response.json()["detail"] == "Failed to submit account request"


class TestDeleteAccountErrorPaths:
    """Cover lines 276-277."""

    def test_delete_account_mysql_error(self, client):
        """Lines 276-277: mysql.connector.Error on delete -> 500."""
        from unittest.mock import patch, MagicMock
        import mysql.connector

        with patch("app.api.v1.auth.get_db_connection") as mock_db:
            mock_db.side_effect = mysql.connector.Error(msg="Connection refused")

            response = client.delete("/api/v1/auth/account/1")
            assert response.status_code == 500
            assert response.json()["detail"] == "Delete failed"


class TestPasswordResetErrorPaths:
    """Cover lines 444-449, 508."""

    def test_password_reset_request_lookup_error(self, client):
        """Lines 444-446: LookupError from generate_reset_token_for_email."""
        from unittest.mock import patch

        with patch("app.api.v1.auth.generate_reset_token_for_email") as mock_gen:
            mock_gen.side_effect = LookupError("Email not found")

            response = client.post("/api/v1/auth/password_reset_request", json={
                "email": "notfound@example.com",
            })
            assert response.status_code == 202
            assert "If an account exists" in response.json()["message"]

    def test_password_reset_request_mysql_error(self, client):
        """Lines 447-449: mysql.connector.Error during reset request."""
        from unittest.mock import patch
        import mysql.connector

        with patch("app.api.v1.auth.generate_reset_token_for_email") as mock_gen:
            mock_gen.side_effect = mysql.connector.Error(msg="DB down")

            response = client.post("/api/v1/auth/password_reset_request", json={
                "email": "dberror@example.com",
            })
            assert response.status_code == 202
            assert "If an account exists" in response.json()["message"]

    def test_confirm_password_reset_mysql_error(self, client):
        """Line 508: mysql.connector.Error during confirm reset -> 500."""
        from unittest.mock import patch, MagicMock
        import mysql.connector

        with patch("app.api.v1.auth.get_authid_by_valid_reset_token") as mock_validate, \
             patch("app.api.v1.auth.hash_password") as mock_hash, \
             patch("app.api.v1.auth.get_db_connection") as mock_db:
            mock_validate.return_value = 123
            mock_hash.return_value = "hashed"
            mock_db.side_effect = mysql.connector.Error(msg="DB down")

            response = client.post("/api/v1/auth/confirm_password_reset", json={
                "token": "valid_token_12345",
                "new_password": "NewSecurePass123!",
            })
            assert response.status_code == 500
            assert response.json()["detail"] == "Failed to reset password."


class TestChangePasswordErrorPaths:
    """Cover lines 99, 536-538, 588-589."""

    def test_change_password_short_new_password_validator(self, client):
        """Line 99: ChangePassword new_password < 8 chars."""
        response = client.post("/api/v1/auth/change_password", json={
            "old_password": "OldPass123!",
            "new_password": "short",
        })
        assert response.status_code == 422

    def test_change_password_account_not_found(self, client):
        """Lines 536-538: Account not found in DB."""
        from unittest.mock import patch, MagicMock

        with patch("app.api.v1.auth.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            mock_cursor.fetchone.return_value = None
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            response = client.post("/api/v1/auth/change_password", json={
                "old_password": "OldPassword123!",
                "new_password": "NewPassword456!",
            })
            assert response.status_code == 404
            assert response.json()["detail"] == "Account not found"

    def test_change_password_mysql_error(self, client):
        """Lines 588-589: mysql.connector.Error -> 500."""
        from unittest.mock import patch
        import mysql.connector

        with patch("app.api.v1.auth.get_db_connection") as mock_db:
            mock_db.side_effect = mysql.connector.Error(msg="DB down")

            response = client.post("/api/v1/auth/change_password", json={
                "old_password": "OldPassword123!",
                "new_password": "NewPassword456!",
            })
            assert response.status_code == 500
            assert response.json()["detail"] == "Failed to change password"


class TestCompleteProfileErrorPaths:
    """Cover lines 635-638."""

    def test_complete_profile_mysql_error(self, client):
        """Lines 635-638: mysql.connector.Error -> 500."""
        from unittest.mock import patch, MagicMock
        import mysql.connector

        with patch("app.api.v1.auth.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            mock_cursor.execute.side_effect = mysql.connector.Error(msg="DB down")
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            response = client.post("/api/v1/auth/complete_profile", json={
                "birthdate": "1990-01-01",
                "gender": "Male",
            })
            assert response.status_code == 500
            assert response.json()["detail"] == "Failed to complete profile"


class TestDeletionRequestErrorPaths:
    """Cover deletion-request error paths."""

    def test_deletion_request_mysql_error(self, client):
        """mysql.connector.Error -> 500 (participant user, DB fails)."""
        from unittest.mock import patch, MagicMock
        import mysql.connector
        from app.main import app as _app
        from app.api.deps import get_current_user

        participant_user = {
            "account_id": 999,
            "email": "p@example.com",
            "role_id": 1,
            "viewing_as_user_id": None,
            "effective_account_id": 999,
            "effective_role_id": 1,
        }
        _app.dependency_overrides[get_current_user] = lambda: participant_user
        try:
            with patch("app.api.v1.auth.get_db_connection") as mock_db:
                mock_cursor = MagicMock()
                mock_cursor.execute.side_effect = mysql.connector.Error(msg="DB down")
                mock_conn = MagicMock()
                mock_conn.cursor.return_value = mock_cursor
                mock_db.return_value = mock_conn

                response = client.post("/api/v1/auth/me/deletion-request")
                assert response.status_code == 500
                assert response.json()["detail"] == "Failed to submit deletion request"
        finally:
            _app.dependency_overrides.pop(get_current_user, None)

    def test_admin_cannot_request_own_deletion(self, client):
        """Admin user gets 403 when trying to submit their own deletion request."""
        response = client.post("/api/v1/auth/me/deletion-request")
        assert response.status_code == 403
        assert "admin" in response.json()["detail"].lower()


class TestHashPasswordEdge:
    """Cover line 707: hash_password raises ValueError for empty string."""

    def test_hash_password_empty_string_raises(self):
        from app.api.v1.auth import hash_password
        with pytest.raises(ValueError, match="non-empty string"):
            hash_password("")

    def test_hash_password_non_string_raises(self):
        from app.api.v1.auth import hash_password
        with pytest.raises(ValueError, match="non-empty string"):
            hash_password(123)


class TestAccountRequestGenderValidation:
    """Cover line 132: invalid gender raises 422."""

    def test_account_request_invalid_gender(self, client):
        response = client.post("/api/v1/auth/request_account", json={
            "first_name": "Test",
            "last_name": "User",
            "email": "gendererr@example.com",
            "role_id": 1,
            "gender": "InvalidGender",
        })
        assert response.status_code == 422

