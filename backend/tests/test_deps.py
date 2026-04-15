# backend/tests/test_deps.py
"""Tests for app/api/deps.py — rate limiting, role checking edge cases,
_get_role_for_account, require_tos_accepted, _extract_session_token."""

import time
import pytest
from unittest.mock import patch, MagicMock, PropertyMock
from fastapi import HTTPException
import mysql.connector


# ---------------------------------------------------------------------------
# _extract_session_token
# ---------------------------------------------------------------------------

class TestExtractSessionToken:

    def test_returns_cookie_token_when_present(self):
        from app.api.deps import _extract_session_token

        request = MagicMock()
        request.cookies = {"session_token": "cookie-abc"}
        credentials = None

        result = _extract_session_token(request, credentials)
        assert result == "cookie-abc"

    def test_returns_bearer_when_no_cookie(self):
        from app.api.deps import _extract_session_token

        request = MagicMock()
        request.cookies = {}
        credentials = MagicMock()
        credentials.scheme = "Bearer"
        credentials.credentials = "bearer-xyz"

        result = _extract_session_token(request, credentials)
        assert result == "bearer-xyz"

    def test_returns_none_when_neither(self):
        from app.api.deps import _extract_session_token

        request = MagicMock()
        request.cookies = {}

        result = _extract_session_token(request, None)
        assert result is None


# ---------------------------------------------------------------------------
# get_current_user — mysql.connector.Error branch (line 137)
# ---------------------------------------------------------------------------

class TestGetCurrentUserDbError:

    @patch("app.api.deps._extract_session_token", return_value="tok")
    @patch("app.api.deps.get_db_connection")
    def test_db_error_raises_500(self, mock_conn, mock_extract):
        from app.api.deps import get_current_user

        mock_conn.side_effect = mysql.connector.Error("db down")
        request = MagicMock()

        with pytest.raises(HTTPException) as exc_info:
            get_current_user(request, None)

        assert exc_info.value.status_code == 500
        assert exc_info.value.detail == "Authentication failed"


# ---------------------------------------------------------------------------
# require_tos_accepted (lines 145-158)
# ---------------------------------------------------------------------------

class TestRequireTosAccepted:

    def test_no_tos_accepted_raises_403(self):
        from app.api.deps import require_tos_accepted

        user = {
            "account_id": 1,
            "email": "a@b.com",
            "tos_accepted_at": None,
            "tos_version": None,
            "role_id": 1,
            "viewing_as_user_id": None,
        }

        with pytest.raises(HTTPException) as exc_info:
            require_tos_accepted(user)

        assert exc_info.value.status_code == 403
        assert exc_info.value.detail == "TOS_NOT_ACCEPTED"

    @patch("app.api.deps.CURRENT_TOS_VERSION", "2.0")
    def test_outdated_tos_version_raises_403(self):
        from app.api.deps import require_tos_accepted

        user = {
            "account_id": 1,
            "email": "a@b.com",
            "tos_accepted_at": "2026-01-01",
            "tos_version": "1.0",
            "role_id": 1,
            "viewing_as_user_id": None,
        }

        with pytest.raises(HTTPException) as exc_info:
            require_tos_accepted(user)

        assert exc_info.value.status_code == 403
        assert exc_info.value.detail == "TOS_REQUIRES_REACCEPT"

    @patch("app.api.deps.CURRENT_TOS_VERSION", "1.0")
    def test_current_tos_passes(self):
        from app.api.deps import require_tos_accepted

        user = {
            "account_id": 1,
            "email": "a@b.com",
            "tos_accepted_at": "2026-01-01",
            "tos_version": "1.0",
            "role_id": 1,
            "viewing_as_user_id": None,
        }

        result = require_tos_accepted(user)
        assert result is user


# ---------------------------------------------------------------------------
# _get_role_for_account (lines 163-176)
# ---------------------------------------------------------------------------

class TestGetRoleForAccount:

    @patch("app.api.deps.get_db_connection")
    def test_returns_role_id_when_found(self, mock_conn):
        from app.api.deps import _get_role_for_account

        mock_cur = MagicMock()
        mock_cur.fetchone.return_value = {"RoleID": 2}
        mock_conn.return_value.cursor.return_value = mock_cur

        result = _get_role_for_account(42)
        assert result == 2
        mock_cur.close.assert_called_once()
        mock_conn.return_value.close.assert_called_once()

    @patch("app.api.deps.get_db_connection")
    def test_returns_none_when_not_found(self, mock_conn):
        from app.api.deps import _get_role_for_account

        mock_cur = MagicMock()
        mock_cur.fetchone.return_value = None
        mock_conn.return_value.cursor.return_value = mock_cur

        result = _get_role_for_account(999)
        assert result is None


# ---------------------------------------------------------------------------
# require_role — viewing-as edge cases (lines 204-218)
# ---------------------------------------------------------------------------

class TestRequireRoleViewingAs:

    def test_viewing_as_target_role_none_raises_403(self):
        """When target account doesn't exist, should raise 403 (line 214)."""
        from app.api.deps import require_role

        dep = require_role(1, 2)

        user = {
            "account_id": 10,
            "email": "admin@test.com",
            "role_id": 4,
            "viewing_as_user_id": 999,
            "tos_accepted_at": "2026-01-01",
            "tos_version": "1.0",
        }

        with patch("app.api.deps._get_role_for_account", return_value=None):
            with pytest.raises(HTTPException) as exc_info:
                dep(user)

            assert exc_info.value.status_code == 403
            assert "Insufficient role permissions" in exc_info.value.detail

    def test_viewing_as_db_error_raises_500(self):
        """When _get_role_for_account raises mysql.connector.Error (line 208-212)."""
        from app.api.deps import require_role

        dep = require_role(1, 2)

        user = {
            "account_id": 10,
            "email": "admin@test.com",
            "role_id": 4,
            "viewing_as_user_id": 50,
            "tos_accepted_at": "2026-01-01",
            "tos_version": "1.0",
        }

        with patch("app.api.deps._get_role_for_account", side_effect=mysql.connector.Error("fail")):
            with pytest.raises(HTTPException) as exc_info:
                dep(user)

            assert exc_info.value.status_code == 500
            assert exc_info.value.detail == "Role check failed"

    def test_viewing_as_success_returns_effective_ids(self):
        """Viewing as another user should return effective account and role."""
        from app.api.deps import require_role

        dep = require_role(1, 2)

        user = {
            "account_id": 10,
            "email": "admin@test.com",
            "role_id": 4,
            "viewing_as_user_id": 50,
            "tos_accepted_at": "2026-01-01",
            "tos_version": "1.0",
        }

        with patch("app.api.deps._get_role_for_account", return_value=1):
            result = dep(user)

        assert result["effective_account_id"] == 50
        assert result["effective_role_id"] == 1

    def test_non_matching_role_denied(self):
        """User with role not in allowed list and not admin should get 403."""
        from app.api.deps import require_role

        dep = require_role(2)  # only researcher allowed

        user = {
            "account_id": 10,
            "email": "user@test.com",
            "role_id": 1,  # participant
            "viewing_as_user_id": None,
            "tos_accepted_at": "2026-01-01",
            "tos_version": "1.0",
        }

        with pytest.raises(HTTPException) as exc_info:
            dep(user)

        assert exc_info.value.status_code == 403


# ---------------------------------------------------------------------------
# _get_client_ip (line 247)
# ---------------------------------------------------------------------------

class TestGetClientIp:

    def test_xff_header_returns_first_ip(self):
        from app.api.deps import _get_client_ip

        request = MagicMock()
        request.headers = {"x-forwarded-for": "1.2.3.4, 5.6.7.8"}

        assert _get_client_ip(request) == "1.2.3.4"

    def test_no_xff_returns_client_host(self):
        from app.api.deps import _get_client_ip

        request = MagicMock()
        request.headers = {}
        request.client.host = "10.0.0.1"

        assert _get_client_ip(request) == "10.0.0.1"


# ---------------------------------------------------------------------------
# rate_limit (lines 272, 285, 291-293)
# ---------------------------------------------------------------------------

class TestRateLimit:

    def test_rate_limit_allows_under_limit(self):
        from app.api.deps import rate_limit, RateLimitRule, _BUCKETS
        _BUCKETS.clear()

        rule = RateLimitRule(max_requests=5, window_seconds=60)
        dep = rate_limit(rule)

        request = MagicMock()
        request.headers = {}
        request.client.host = "1.1.1.1"

        # Should not raise for first 5 requests
        for _ in range(5):
            dep(request)

    def test_rate_limit_blocks_over_limit(self):
        from app.api.deps import rate_limit, RateLimitRule, _BUCKETS
        _BUCKETS.clear()

        rule = RateLimitRule(max_requests=2, window_seconds=60)
        dep = rate_limit(rule)

        request = MagicMock()
        request.headers = {}
        request.client.host = "2.2.2.2"

        dep(request)
        dep(request)

        with pytest.raises(HTTPException) as exc_info:
            dep(request)

        assert exc_info.value.status_code == 429
        assert exc_info.value.detail == "RATE_LIMITED"
        assert "Retry-After" in exc_info.value.headers

    def test_rate_limit_window_reset(self):
        """After window expires, counter resets (line 285)."""
        from app.api.deps import rate_limit, RateLimitRule, _BUCKETS
        _BUCKETS.clear()

        rule = RateLimitRule(max_requests=1, window_seconds=1)
        dep = rate_limit(rule)

        request = MagicMock()
        request.headers = {}
        request.client.host = "3.3.3.3"

        dep(request)  # 1st request ok

        # Manually expire the window
        key = "ip:3.3.3.3"
        _BUCKETS[key] = (time.time() - 2, 1)

        dep(request)  # should reset window and succeed

    def test_rate_limit_by_account(self):
        from app.api.deps import rate_limit, RateLimitRule, _BUCKETS
        _BUCKETS.clear()

        rule = RateLimitRule(max_requests=1, window_seconds=60)
        dep = rate_limit(rule, by="account")

        request = MagicMock()
        request.headers = {}
        request.state.actor_account_id = 42

        dep(request)

        with pytest.raises(HTTPException) as exc_info:
            dep(request)

        assert exc_info.value.status_code == 429

    def test_rate_limit_by_account_fallback_to_ip(self):
        """When actor_account_id is not set, falls back to IP."""
        from app.api.deps import rate_limit, RateLimitRule, _BUCKETS
        _BUCKETS.clear()

        rule = RateLimitRule(max_requests=1, window_seconds=60)
        dep = rate_limit(rule, by="account")

        request = MagicMock()
        request.headers = {}
        # state exists but actor_account_id is None
        request.state.actor_account_id = None
        request.client.host = "5.5.5.5"

        dep(request)

        with pytest.raises(HTTPException):
            dep(request)


# ---------------------------------------------------------------------------
# _prune_buckets (lines 307-329)
# ---------------------------------------------------------------------------

class TestPruneBuckets:

    def test_prune_removes_expired(self):
        from app.api.deps import _prune_buckets, _BUCKETS, EXPIRE_GRACE_SECONDS
        _BUCKETS.clear()

        now = time.time()
        _BUCKETS["ip:old"] = (now - 7200, 5)  # 2 hours ago
        _BUCKETS["ip:recent"] = (now - 10, 2)   # 10 seconds ago

        _prune_buckets(now, max_window_seconds=3600)

        assert "ip:old" not in _BUCKETS
        assert "ip:recent" in _BUCKETS

    def test_prune_empty_buckets_noop(self):
        from app.api.deps import _prune_buckets, _BUCKETS
        _BUCKETS.clear()

        _prune_buckets(time.time(), max_window_seconds=3600)
        assert len(_BUCKETS) == 0

    def test_prune_safety_cap(self):
        """When buckets exceed MAX_BUCKETS, oldest 10% are dropped (lines 324-329)."""
        from app.api.deps import _prune_buckets, _BUCKETS, MAX_BUCKETS
        _BUCKETS.clear()

        now = time.time()
        # Fill beyond MAX_BUCKETS with non-expired entries
        for i in range(MAX_BUCKETS + 100):
            _BUCKETS[f"ip:{i}"] = (now - i * 0.001, 1)

        _prune_buckets(now, max_window_seconds=3600)

        assert len(_BUCKETS) <= MAX_BUCKETS

    def test_prune_triggered_by_rate_limit_calls(self):
        """Every PRUNE_EVERY_N_CALLS calls, prune is invoked (line 272)."""
        from app.api import deps
        from app.api.deps import rate_limit, RateLimitRule, _BUCKETS, PRUNE_EVERY_N_CALLS

        _BUCKETS.clear()

        # Set _CALLS to just before threshold
        deps._CALLS = PRUNE_EVERY_N_CALLS - 1

        # Add an expired bucket
        now = time.time()
        _BUCKETS["ip:stale"] = (now - 7200, 1)

        rule = RateLimitRule(max_requests=999, window_seconds=60)
        dep = rate_limit(rule)

        request = MagicMock()
        request.headers = {}
        request.client.host = "9.9.9.9"

        dep(request)  # This should trigger prune

        assert "ip:stale" not in _BUCKETS
