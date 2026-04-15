# Created with the Assistance of Claude Code
# backend/tests/api/test_admin_settings.py
"""
Tests for:
  GET  /api/v1/admin/settings
  PUT  /api/v1/admin/settings
  settings service caching
  login lockout enforcement (max_login_attempts / lockout_duration_minutes)
  registration_open check in request_account
"""

from unittest.mock import patch, MagicMock
from datetime import datetime, timedelta

import pytest

DB_SETTINGS = "app.services.settings.get_db_connection"
DB_ADMIN    = "app.api.v1.admin.get_db_connection"
DB_AUTH     = "app.api.v1.auth.get_db_connection"

_VALID_PASSWORD = "Password1!"   # satisfies the ≥8 char validator


def _make_cursor(rows=None):
    cur = MagicMock()
    cur.fetchone.return_value = rows[0] if rows else None
    cur.fetchall.return_value = rows or []
    cur.rowcount = 1
    return cur


def _make_conn(cursor):
    conn = MagicMock()
    conn.cursor.return_value = cursor
    return conn


def _bust_settings_cache():
    """Force the settings service to hit the DB on the next read."""
    import app.services.settings as svc
    svc._cache_at = 0.0


def _set_settings_cache(**kwargs):
    """Seed the settings cache directly to avoid DB hits in non-settings tests."""
    import app.services.settings as svc
    svc._cache = {k: str(v) for k, v in kwargs.items()}
    svc._cache_at = 9e18  # far future — won't expire during tests


# ── GET /admin/settings ────────────────────────────────────────────────────────

class TestGetSettings:
    def test_returns_db_values(self, client):
        db_rows = [
            ("k_anonymity_threshold",    "3"),
            ("registration_open",        "false"),
            ("maintenance_mode",         "true"),
            ("max_login_attempts",       "5"),
            ("lockout_duration_minutes", "15"),
            ("consent_required",         "false"),
        ]
        cur = _make_cursor()
        cur.fetchall.return_value = db_rows
        conn = _make_conn(cur)

        _bust_settings_cache()
        with patch(DB_SETTINGS, return_value=conn):
            resp = client.get("/api/v1/admin/settings")

        assert resp.status_code == 200
        data = resp.json()
        assert data["k_anonymity_threshold"] == 3
        assert data["registration_open"] is False
        assert data["maintenance_mode"] is True
        assert data["max_login_attempts"] == 5
        assert data["lockout_duration_minutes"] == 15
        assert data["consent_required"] is False

    def test_falls_back_to_defaults_when_db_empty(self, client):
        cur = _make_cursor()
        cur.fetchall.return_value = []
        conn = _make_conn(cur)

        _bust_settings_cache()
        with patch(DB_SETTINGS, return_value=conn):
            resp = client.get("/api/v1/admin/settings")

        assert resp.status_code == 200
        data = resp.json()
        assert data["k_anonymity_threshold"] == 1
        assert data["registration_open"] is True
        assert data["maintenance_mode"] is False
        assert data["max_login_attempts"] == 10
        assert data["lockout_duration_minutes"] == 30
        assert data["consent_required"] is True  # default is true

    def test_response_includes_defaults_dict(self, client):
        cur = _make_cursor()
        cur.fetchall.return_value = []
        conn = _make_conn(cur)

        _bust_settings_cache()
        with patch(DB_SETTINGS, return_value=conn):
            resp = client.get("/api/v1/admin/settings")

        data = resp.json()
        assert "defaults" in data
        assert data["defaults"]["k_anonymity_threshold"] == 1


# ── PUT /admin/settings ────────────────────────────────────────────────────────

class TestUpdateSettings:
    _VALID_PAYLOAD = {
        "k_anonymity_threshold":    1,
        "registration_open":        True,
        "maintenance_mode":         False,
        "max_login_attempts":       10,
        "lockout_duration_minutes": 30,
        "consent_required":         True,
    }

    def test_saves_all_fields(self, client):
        cur = _make_cursor()
        conn = _make_conn(cur)
        payload = {
            "k_anonymity_threshold":    2,
            "registration_open":        False,
            "maintenance_mode":         True,
            "max_login_attempts":       7,
            "lockout_duration_minutes": 60,
            "consent_required":         False,
        }
        with patch(DB_ADMIN, return_value=conn):
            resp = client.put("/api/v1/admin/settings", json=payload)

        assert resp.status_code == 200
        data = resp.json()
        assert data["k_anonymity_threshold"] == 2
        assert data["registration_open"] is False
        assert data["maintenance_mode"] is True
        assert data["max_login_attempts"] == 7
        assert data["lockout_duration_minutes"] == 60
        assert data["consent_required"] is False

    def test_rejects_k_below_1(self, client):
        payload = {**self._VALID_PAYLOAD, "k_anonymity_threshold": 0}
        resp = client.put("/api/v1/admin/settings", json=payload)
        assert resp.status_code == 422

    def test_rejects_lockout_below_1(self, client):
        payload = {**self._VALID_PAYLOAD, "lockout_duration_minutes": 0}
        resp = client.put("/api/v1/admin/settings", json=payload)
        assert resp.status_code == 422

    def test_allows_max_login_attempts_zero(self, client):
        """0 = unlimited — must be accepted."""
        cur = _make_cursor()
        conn = _make_conn(cur)
        payload = {**self._VALID_PAYLOAD, "max_login_attempts": 0}
        with patch(DB_ADMIN, return_value=conn):
            resp = client.put("/api/v1/admin/settings", json=payload)
        assert resp.status_code == 200

    def test_db_error_returns_500(self, client):
        import mysql.connector
        cur = MagicMock()
        cur.execute.side_effect = mysql.connector.Error("db down")
        conn = _make_conn(cur)
        with patch(DB_ADMIN, return_value=conn):
            resp = client.put("/api/v1/admin/settings", json=self._VALID_PAYLOAD)
        assert resp.status_code == 500


# ── Login lockout ──────────────────────────────────────────────────────────────

class TestLoginLockout:
    """
    Login result tuple order (after auth.py changes):
    0  AccountID
    1  PasswordHash
    2  MustChangePassword
    3  RoleID
    4  Birthdate
    5  Gender
    6  IsActive
    7  AuthID
    8  FailedLoginAttempts
    9  LockedUntil
    """

    def _result(self, failed=0, locked_until=None, is_active=True):
        return (1, "hash", False, 1, None, None, is_active, 10, failed, locked_until)

    def test_locked_account_returns_429(self, client):
        _set_settings_cache(max_login_attempts="10", lockout_duration_minutes="30")
        locked_until = datetime.utcnow() + timedelta(minutes=25)
        cur = _make_cursor()
        cur.fetchone.return_value = self._result(failed=10, locked_until=locked_until)
        conn = _make_conn(cur)

        with patch(DB_AUTH, return_value=conn):
            resp = client.post("/api/v1/auth/login",
                               json={"email": "x@x.com", "password": _VALID_PASSWORD})

        assert resp.status_code == 429
        assert "account_locked" in resp.json()["detail"]

    def test_expired_lockout_allows_attempt(self, client):
        """LockedUntil in the past should not block login (just wrong password here)."""
        _set_settings_cache(max_login_attempts="10", lockout_duration_minutes="30")
        expired_lock = datetime.utcnow() - timedelta(minutes=5)
        cur = _make_cursor()
        cur.fetchone.return_value = self._result(failed=10, locked_until=expired_lock)
        conn = _make_conn(cur)

        with patch(DB_AUTH, return_value=conn), \
             patch("app.api.v1.auth.verify_password", return_value=False):
            resp = client.post("/api/v1/auth/login",
                               json={"email": "x@x.com", "password": _VALID_PASSWORD})

        # 401 wrong password — NOT 429 locked
        assert resp.status_code == 401

    def test_failed_attempt_increments_counter(self, client):
        _set_settings_cache(max_login_attempts="10", lockout_duration_minutes="30")
        cur = _make_cursor()
        cur.fetchone.return_value = self._result(failed=2)
        conn = _make_conn(cur)

        with patch(DB_AUTH, return_value=conn), \
             patch("app.api.v1.auth.verify_password", return_value=False):
            resp = client.post("/api/v1/auth/login",
                               json={"email": "x@x.com", "password": _VALID_PASSWORD})

        assert resp.status_code == 401
        # An UPDATE on Auth should have been executed
        update_calls = [str(c) for c in cur.execute.call_args_list]
        assert any("FailedLoginAttempts" in c for c in update_calls)

    def test_unlimited_when_max_attempts_zero(self, client):
        """max_login_attempts=0 → no lockout, even with many prior failures."""
        _set_settings_cache(max_login_attempts="0", lockout_duration_minutes="30")
        cur = _make_cursor()
        cur.fetchone.return_value = self._result(failed=99)
        conn = _make_conn(cur)

        with patch(DB_AUTH, return_value=conn), \
             patch("app.api.v1.auth.verify_password", return_value=False):
            resp = client.post("/api/v1/auth/login",
                               json={"email": "x@x.com", "password": _VALID_PASSWORD})

        # Must be 401 (wrong password), NOT 429 (locked)
        assert resp.status_code == 401


# ── Registration open / closed ─────────────────────────────────────────────────

class TestRegistrationOpen:
    def test_closed_returns_503(self, client):
        _set_settings_cache(registration_open="false")
        resp = client.post("/api/v1/auth/request_account", json={
            "first_name": "Test",
            "last_name":  "User",
            "email":      "test@example.com",
            "role_id":    1,
        })
        assert resp.status_code == 503
        assert resp.json()["detail"] == "registration_closed"

    def test_open_proceeds_past_check(self, client):
        _set_settings_cache(registration_open="true")
        cur = _make_cursor()
        cur.fetchone.return_value = None   # no existing account/request
        conn = _make_conn(cur)

        with patch(DB_AUTH, return_value=conn):
            resp = client.post("/api/v1/auth/request_account", json={
                "first_name": "Test",
                "last_name":  "User",
                "email":      "newuser@example.com",
                "role_id":    1,
            })
        # Any status other than 503 means it got past the registration_open check
        assert resp.status_code != 503


# ── Consent Required setting ───────────────────────────────────────────────────

class TestConsentRequiredSetting:
    def test_get_returns_consent_required_true_by_default(self, client):
        """GET /admin/settings includes consent_required=true when not in DB."""
        cur = _make_cursor()
        cur.fetchall.return_value = []   # empty DB → use defaults
        conn = _make_conn(cur)

        _bust_settings_cache()
        with patch(DB_SETTINGS, return_value=conn):
            resp = client.get("/api/v1/admin/settings")

        assert resp.status_code == 200
        assert resp.json()["consent_required"] is True

    def test_get_returns_consent_required_false_from_db(self, client):
        """GET returns consent_required=false when the DB row is false."""
        cur = _make_cursor()
        cur.fetchall.return_value = [("consent_required", "false")]
        conn = _make_conn(cur)

        _bust_settings_cache()
        with patch(DB_SETTINGS, return_value=conn):
            resp = client.get("/api/v1/admin/settings")

        assert resp.status_code == 200
        assert resp.json()["consent_required"] is False

    def test_update_consent_required_false(self, client):
        """PUT with consent_required=false saves and returns false."""
        cur = _make_cursor()
        conn = _make_conn(cur)
        payload = {
            "k_anonymity_threshold":    5,
            "registration_open":        True,
            "maintenance_mode":         False,
            "max_login_attempts":       10,
            "lockout_duration_minutes": 30,
            "consent_required":         False,
        }
        with patch(DB_ADMIN, return_value=conn):
            resp = client.put("/api/v1/admin/settings", json=payload)

        assert resp.status_code == 200
        assert resp.json()["consent_required"] is False

    def test_update_consent_required_true(self, client):
        """PUT with consent_required=true saves and returns true."""
        cur = _make_cursor()
        conn = _make_conn(cur)
        payload = {
            "k_anonymity_threshold":    5,
            "registration_open":        True,
            "maintenance_mode":         False,
            "max_login_attempts":       10,
            "lockout_duration_minutes": 30,
            "consent_required":         True,
        }
        with patch(DB_ADMIN, return_value=conn):
            resp = client.put("/api/v1/admin/settings", json=payload)

        assert resp.status_code == 200
        assert resp.json()["consent_required"] is True

    def test_missing_consent_required_returns_422(self, client):
        """PUT without consent_required in body returns 422 (required field)."""
        payload = {
            "k_anonymity_threshold":    5,
            "registration_open":        True,
            "maintenance_mode":         False,
            "max_login_attempts":       10,
            "lockout_duration_minutes": 30,
            # consent_required intentionally omitted
        }
        resp = client.put("/api/v1/admin/settings", json=payload)
        assert resp.status_code == 422
