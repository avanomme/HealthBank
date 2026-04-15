# tests/api/test_2fa.py
"""
Tests for 2FA endpoints: enroll, confirm, verify, disable, status.

The FakeCursor in tests/mocks/db.py does NOT handle Account2FA or
mfa_challenges tables, so we patch get_db_connection at the two_factor
import site with custom MagicMock cursors for each test.
"""

import pytest
from unittest.mock import patch, MagicMock
from datetime import datetime, timedelta
from fastapi.testclient import TestClient


# ---------------------------------------------------------------------------
# helpers
# ---------------------------------------------------------------------------

MOCK_MASTERKEY = "test-master-key-for-2fa-unit-tests"
MOCK_SECRET = "JBSWY3DPEHPK3PXP"  # a valid base32 secret
MOCK_ENCRYPTED_SECRET = "some-encrypted-token"


def _make_conn(cursor):
    """Build a MagicMock connection that returns the given cursor."""
    conn = MagicMock()
    conn.cursor.return_value = cursor
    return conn


# ---------------------------------------------------------------------------
# POST /2fa/enroll
# ---------------------------------------------------------------------------

class TestEnroll2FA:

    @patch("app.api.v1.two_factor.encrypt_2fa_secret_for_db", return_value=MOCK_ENCRYPTED_SECRET)
    @patch("app.api.v1.two_factor.pyotp")
    @patch("app.api.v1.two_factor.get_db_connection")
    def test_enroll_success(self, mock_db, mock_pyotp, mock_encrypt, client):
        mock_pyotp.random_base32.return_value = MOCK_SECRET
        mock_totp = MagicMock()
        mock_totp.provisioning_uri.return_value = "otpauth://totp/HealthDataBank:testadmin%40example.com?secret=JBSWY3DPEHPK3PXP&issuer=HealthDataBank"
        mock_pyotp.TOTP.return_value = mock_totp

        cursor = MagicMock()
        mock_db.return_value = _make_conn(cursor)

        resp = client.post("/api/v1/2fa/enroll")
        assert resp.status_code == 201
        data = resp.json()
        assert "provisioning_uri" in data
        assert "otpauth://" in data["provisioning_uri"]

    @patch("app.api.v1.two_factor.encrypt_2fa_secret_for_db", return_value=MOCK_ENCRYPTED_SECRET)
    @patch("app.api.v1.two_factor.pyotp")
    @patch("app.api.v1.two_factor.get_db_connection")
    def test_enroll_db_error(self, mock_db, mock_pyotp, mock_encrypt, client):
        import mysql.connector
        mock_pyotp.random_base32.return_value = MOCK_SECRET

        cursor = MagicMock()
        cursor.execute.side_effect = mysql.connector.Error("DB error")
        mock_db.return_value = _make_conn(cursor)

        resp = client.post("/api/v1/2fa/enroll")
        assert resp.status_code == 500
        assert "Failed to enroll 2FA" in resp.json()["detail"]


# ---------------------------------------------------------------------------
# POST /2fa/confirm
# ---------------------------------------------------------------------------

class TestConfirm2FA:

    @patch("app.api.v1.two_factor.decrypt_2fa_secret_from_db", return_value=MOCK_SECRET)
    @patch("app.api.v1.two_factor.pyotp")
    @patch("app.api.v1.two_factor.get_db_connection")
    def test_confirm_success(self, mock_db, mock_pyotp, mock_decrypt, client):
        cursor = MagicMock()
        # SELECT TotpSecret returns a row
        cursor.fetchone.return_value = (MOCK_ENCRYPTED_SECRET,)
        mock_db.return_value = _make_conn(cursor)

        mock_totp = MagicMock()
        mock_totp.verify.return_value = True
        mock_pyotp.TOTP.return_value = mock_totp

        resp = client.post("/api/v1/2fa/confirm", json={"code": "123456"})
        assert resp.status_code == 200
        assert resp.json()["message"] == "2FA enabled"

    @patch("app.api.v1.two_factor.get_db_connection")
    def test_confirm_not_enrolled(self, mock_db, client):
        cursor = MagicMock()
        cursor.fetchone.return_value = None
        mock_db.return_value = _make_conn(cursor)

        resp = client.post("/api/v1/2fa/confirm", json={"code": "123456"})
        assert resp.status_code == 404
        assert "not enrolled" in resp.json()["detail"]

    @patch("app.api.v1.two_factor.decrypt_2fa_secret_from_db", return_value=MOCK_SECRET)
    @patch("app.api.v1.two_factor.pyotp")
    @patch("app.api.v1.two_factor.get_db_connection")
    def test_confirm_invalid_code(self, mock_db, mock_pyotp, mock_decrypt, client):
        cursor = MagicMock()
        cursor.fetchone.return_value = (MOCK_ENCRYPTED_SECRET,)
        mock_db.return_value = _make_conn(cursor)

        mock_totp = MagicMock()
        mock_totp.verify.return_value = False
        mock_pyotp.TOTP.return_value = mock_totp

        resp = client.post("/api/v1/2fa/confirm", json={"code": "000000"})
        assert resp.status_code == 401
        assert "Invalid 2FA code" in resp.json()["detail"]

    @patch("app.api.v1.two_factor.get_db_connection")
    def test_confirm_db_error(self, mock_db, client):
        import mysql.connector
        cursor = MagicMock()
        cursor.execute.side_effect = mysql.connector.Error("DB error")
        mock_db.return_value = _make_conn(cursor)

        resp = client.post("/api/v1/2fa/confirm", json={"code": "123456"})
        assert resp.status_code == 500
        assert "Failed to confirm 2FA" in resp.json()["detail"]

    def test_confirm_bad_code_format(self, client):
        """Code must be exactly 6 digits."""
        resp = client.post("/api/v1/2fa/confirm", json={"code": "12345"})
        assert resp.status_code == 422  # pydantic validation

    @patch("app.api.v1.two_factor.decrypt_2fa_secret_from_db", return_value=MOCK_SECRET)
    @patch("app.api.v1.two_factor.pyotp")
    @patch("app.api.v1.two_factor.get_db_connection")
    def test_confirm_secret_is_bytes(self, mock_db, mock_pyotp, mock_decrypt, client):
        """When TotpSecret comes back as bytes, it should be decoded."""
        cursor = MagicMock()
        cursor.fetchone.return_value = (MOCK_ENCRYPTED_SECRET.encode("utf-8"),)
        mock_db.return_value = _make_conn(cursor)

        mock_totp = MagicMock()
        mock_totp.verify.return_value = True
        mock_pyotp.TOTP.return_value = mock_totp

        resp = client.post("/api/v1/2fa/confirm", json={"code": "123456"})
        assert resp.status_code == 200
        assert resp.json()["message"] == "2FA enabled"


# ---------------------------------------------------------------------------
# POST /2fa/verify
# ---------------------------------------------------------------------------

class TestVerify2FA:

    @patch("app.api.v1.two_factor.set_session_cookie")
    @patch("app.api.v1.two_factor.create_session_for_account")
    @patch("app.api.v1.two_factor.decrypt_2fa_secret_from_db", return_value=MOCK_SECRET)
    @patch("app.api.v1.two_factor.pyotp")
    @patch("app.api.v1.two_factor._hash_token", return_value="hashed-token")
    @patch("app.api.v1.two_factor.get_db_connection")
    def test_verify_success(self, mock_db, mock_hash, mock_pyotp,
                            mock_decrypt, mock_create_session,
                            mock_set_cookie, client):
        now = datetime.utcnow()
        future = now + timedelta(minutes=5)

        cursor = MagicMock()
        # First fetchone: mfa_challenges row
        # Second fetchone: Account2FA row
        cursor.fetchone.side_effect = [
            (1, 42, future, None, None, 0),       # challenge row
            (MOCK_ENCRYPTED_SECRET, 1),             # Account2FA row
        ]
        mock_db.return_value = _make_conn(cursor)

        mock_totp = MagicMock()
        mock_totp.verify.return_value = True
        mock_pyotp.TOTP.return_value = mock_totp

        expires_at_str = (now + timedelta(hours=8)).isoformat()
        mock_create_session.return_value = {
            "session_token": "real-session-token",
            "expires_at": expires_at_str,
            "account_id": 42,
            "first_name": "Test",
            "last_name": "User",
            "email": "test@example.com",
            "role": "admin",
            "has_signed_consent": True,
            "needs_profile_completion": False,
        }

        resp = client.post("/api/v1/2fa/verify", json={
            "challenge_token": "a-valid-challenge-token-string",
            "code": "123456",
        })
        assert resp.status_code == 200
        data = resp.json()
        assert data["valid"] is True
        assert "session_token" not in data  # token is popped from response

    @patch("app.api.v1.two_factor._hash_token", return_value="hashed-token")
    @patch("app.api.v1.two_factor.get_db_connection")
    def test_verify_invalid_challenge(self, mock_db, mock_hash, client):
        cursor = MagicMock()
        cursor.fetchone.return_value = None
        mock_db.return_value = _make_conn(cursor)

        resp = client.post("/api/v1/2fa/verify", json={
            "challenge_token": "a-valid-challenge-token-string",
            "code": "123456",
        })
        assert resp.status_code == 401
        assert "Invalid or expired challenge" in resp.json()["detail"]

    @patch("app.api.v1.two_factor._hash_token", return_value="hashed-token")
    @patch("app.api.v1.two_factor.get_db_connection")
    def test_verify_expired_challenge(self, mock_db, mock_hash, client):
        past = datetime.utcnow() - timedelta(minutes=1)
        cursor = MagicMock()
        cursor.fetchone.return_value = (1, 42, past, None, None, 0)
        mock_db.return_value = _make_conn(cursor)

        resp = client.post("/api/v1/2fa/verify", json={
            "challenge_token": "a-valid-challenge-token-string",
            "code": "123456",
        })
        assert resp.status_code == 401
        assert "Invalid or expired challenge" in resp.json()["detail"]

    @patch("app.api.v1.two_factor._hash_token", return_value="hashed-token")
    @patch("app.api.v1.two_factor.get_db_connection")
    def test_verify_used_challenge(self, mock_db, mock_hash, client):
        future = datetime.utcnow() + timedelta(minutes=5)
        used_at = datetime.utcnow() - timedelta(minutes=1)
        cursor = MagicMock()
        cursor.fetchone.return_value = (1, 42, future, used_at, None, 0)
        mock_db.return_value = _make_conn(cursor)

        resp = client.post("/api/v1/2fa/verify", json={
            "challenge_token": "a-valid-challenge-token-string",
            "code": "123456",
        })
        assert resp.status_code == 401

    @patch("app.api.v1.two_factor._hash_token", return_value="hashed-token")
    @patch("app.api.v1.two_factor.get_db_connection")
    def test_verify_revoked_challenge(self, mock_db, mock_hash, client):
        future = datetime.utcnow() + timedelta(minutes=5)
        revoked_at = datetime.utcnow() - timedelta(minutes=1)
        cursor = MagicMock()
        cursor.fetchone.return_value = (1, 42, future, None, revoked_at, 0)
        mock_db.return_value = _make_conn(cursor)

        resp = client.post("/api/v1/2fa/verify", json={
            "challenge_token": "a-valid-challenge-token-string",
            "code": "123456",
        })
        assert resp.status_code == 401

    @patch("app.api.v1.two_factor._hash_token", return_value="hashed-token")
    @patch("app.api.v1.two_factor.get_db_connection")
    def test_verify_too_many_attempts(self, mock_db, mock_hash, client):
        future = datetime.utcnow() + timedelta(minutes=5)
        cursor = MagicMock()
        cursor.fetchone.return_value = (1, 42, future, None, None, 5)
        mock_db.return_value = _make_conn(cursor)

        resp = client.post("/api/v1/2fa/verify", json={
            "challenge_token": "a-valid-challenge-token-string",
            "code": "123456",
        })
        assert resp.status_code == 429
        assert "Too many attempts" in resp.json()["detail"]

    @patch("app.api.v1.two_factor.decrypt_2fa_secret_from_db", return_value=MOCK_SECRET)
    @patch("app.api.v1.two_factor.pyotp")
    @patch("app.api.v1.two_factor._hash_token", return_value="hashed-token")
    @patch("app.api.v1.two_factor.get_db_connection")
    def test_verify_2fa_not_enabled(self, mock_db, mock_hash, mock_pyotp,
                                     mock_decrypt, client):
        future = datetime.utcnow() + timedelta(minutes=5)
        cursor = MagicMock()
        cursor.fetchone.side_effect = [
            (1, 42, future, None, None, 0),  # challenge row
            (MOCK_ENCRYPTED_SECRET, 0),       # Account2FA: IsEnabled=0
        ]
        mock_db.return_value = _make_conn(cursor)

        resp = client.post("/api/v1/2fa/verify", json={
            "challenge_token": "a-valid-challenge-token-string",
            "code": "123456",
        })
        assert resp.status_code == 409
        assert "2FA not enabled" in resp.json()["detail"]

    @patch("app.api.v1.two_factor.decrypt_2fa_secret_from_db", return_value=MOCK_SECRET)
    @patch("app.api.v1.two_factor.pyotp")
    @patch("app.api.v1.two_factor._hash_token", return_value="hashed-token")
    @patch("app.api.v1.two_factor.get_db_connection")
    def test_verify_2fa_no_record(self, mock_db, mock_hash, mock_pyotp,
                                   mock_decrypt, client):
        future = datetime.utcnow() + timedelta(minutes=5)
        cursor = MagicMock()
        cursor.fetchone.side_effect = [
            (1, 42, future, None, None, 0),  # challenge row
            None,                              # no Account2FA record
        ]
        mock_db.return_value = _make_conn(cursor)

        resp = client.post("/api/v1/2fa/verify", json={
            "challenge_token": "a-valid-challenge-token-string",
            "code": "123456",
        })
        assert resp.status_code == 409
        assert "2FA not enabled" in resp.json()["detail"]

    @patch("app.api.v1.two_factor.decrypt_2fa_secret_from_db", return_value=MOCK_SECRET)
    @patch("app.api.v1.two_factor.pyotp")
    @patch("app.api.v1.two_factor._hash_token", return_value="hashed-token")
    @patch("app.api.v1.two_factor.get_db_connection")
    def test_verify_invalid_code(self, mock_db, mock_hash, mock_pyotp,
                                  mock_decrypt, client):
        future = datetime.utcnow() + timedelta(minutes=5)
        cursor = MagicMock()
        cursor.fetchone.side_effect = [
            (1, 42, future, None, None, 0),
            (MOCK_ENCRYPTED_SECRET, 1),
        ]
        mock_db.return_value = _make_conn(cursor)

        mock_totp = MagicMock()
        mock_totp.verify.return_value = False
        mock_pyotp.TOTP.return_value = mock_totp

        resp = client.post("/api/v1/2fa/verify", json={
            "challenge_token": "a-valid-challenge-token-string",
            "code": "000000",
        })
        assert resp.status_code == 401
        assert "Invalid 2FA code" in resp.json()["detail"]

    @patch("app.api.v1.two_factor._hash_token", return_value="hashed-token")
    @patch("app.api.v1.two_factor.get_db_connection")
    def test_verify_db_error(self, mock_db, mock_hash, client):
        import mysql.connector
        cursor = MagicMock()
        cursor.execute.side_effect = mysql.connector.Error("DB error")
        mock_db.return_value = _make_conn(cursor)

        resp = client.post("/api/v1/2fa/verify", json={
            "challenge_token": "a-valid-challenge-token-string",
            "code": "123456",
        })
        assert resp.status_code == 500
        assert "Failed to verify 2FA" in resp.json()["detail"]

    def test_verify_bad_code_format(self, client):
        """Code must be 6 digits."""
        resp = client.post("/api/v1/2fa/verify", json={
            "challenge_token": "a-valid-challenge-token-string",
            "code": "abc",
        })
        assert resp.status_code == 422

    def test_verify_short_challenge_token(self, client):
        """challenge_token must be >= 10 chars."""
        resp = client.post("/api/v1/2fa/verify", json={
            "challenge_token": "short",
            "code": "123456",
        })
        assert resp.status_code == 422


# ---------------------------------------------------------------------------
# POST /2fa/disable
# ---------------------------------------------------------------------------

class TestDisable2FA:

    @patch("app.api.v1.two_factor.get_db_connection")
    def test_disable_success(self, mock_db, client):
        cursor = MagicMock()
        cursor.fetchone.return_value = (1,)  # IsEnabled=1
        mock_db.return_value = _make_conn(cursor)

        resp = client.post("/api/v1/2fa/disable")
        assert resp.status_code == 200
        assert resp.json()["message"] == "2FA disabled"

    @patch("app.api.v1.two_factor.get_db_connection")
    def test_disable_not_set_up(self, mock_db, client):
        cursor = MagicMock()
        cursor.fetchone.return_value = None
        mock_db.return_value = _make_conn(cursor)

        resp = client.post("/api/v1/2fa/disable")
        assert resp.status_code == 400
        assert "not been set up" in resp.json()["detail"]

    @patch("app.api.v1.two_factor.get_db_connection")
    def test_disable_already_disabled(self, mock_db, client):
        cursor = MagicMock()
        cursor.fetchone.return_value = (0,)  # IsEnabled=0
        mock_db.return_value = _make_conn(cursor)

        resp = client.post("/api/v1/2fa/disable")
        assert resp.status_code == 400
        assert "already disabled" in resp.json()["detail"]

    @patch("app.api.v1.two_factor.get_db_connection")
    def test_disable_db_error(self, mock_db, client):
        import mysql.connector
        cursor = MagicMock()
        cursor.execute.side_effect = mysql.connector.Error("DB error")
        mock_db.return_value = _make_conn(cursor)

        resp = client.post("/api/v1/2fa/disable")
        assert resp.status_code == 500
        assert "Failed to disable 2FA" in resp.json()["detail"]
