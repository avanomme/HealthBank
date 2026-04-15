# Created with the Assistance of Claude Code
# backend/tests/test_audit_middleware.py
"""
Tests for AuditEveryRequestToAuditEventMiddleware.

Covers missing lines: 20, 62-64, 78-79, 154-156.
"""

import pytest
from unittest.mock import patch, MagicMock, AsyncMock
from app.middleware.audit_to_auditevent import (
    _ip_to_varbinary,
    _get_client_ip,
    _status_from_http,
    AuditEveryRequestToAuditEventMiddleware,
)


class TestIpToVarbinary:
    """Cover line 20: _ip_to_varbinary with empty/None input."""

    def test_none_returns_none(self):
        assert _ip_to_varbinary(None) is None

    def test_empty_string_returns_none(self):
        assert _ip_to_varbinary("") is None

    def test_invalid_ip_returns_none(self):
        assert _ip_to_varbinary("not-an-ip") is None

    def test_valid_ipv4(self):
        result = _ip_to_varbinary("192.168.1.1")
        assert result is not None
        assert len(result) == 4

    def test_valid_ipv6(self):
        result = _ip_to_varbinary("::1")
        assert result is not None
        assert len(result) == 16


class TestStatusFromHttp:

    def test_401_denied(self):
        assert _status_from_http(401) == "denied"

    def test_403_denied(self):
        assert _status_from_http(403) == "denied"

    def test_200_success(self):
        assert _status_from_http(200) == "success"

    def test_399_success(self):
        assert _status_from_http(399) == "success"

    def test_500_failure(self):
        assert _status_from_http(500) == "failure"

    def test_404_failure(self):
        assert _status_from_http(404) == "failure"


class TestMiddlewareExcludedPaths:
    """Cover lines 62-64: excluded paths skip audit logging."""

    @pytest.mark.anyio
    async def test_excluded_path_skips_audit(self):
        """Lines 62-64: When path is in exclude_paths, skip audit logging."""
        mock_app = MagicMock()
        middleware = AuditEveryRequestToAuditEventMiddleware(
            mock_app, exclude_paths={"/health"}
        )

        mock_request = MagicMock()
        mock_request.url.path = "/health"
        mock_request.headers = {"x-request-id": "test-123"}
        mock_request.state = MagicMock()

        mock_response = MagicMock()
        mock_response.headers = {}

        async def call_next(req):
            return mock_response

        response = await middleware.dispatch(mock_request, call_next)
        assert response.headers["x-request-id"] == "test-123"


class TestMiddlewareContentLength:
    """Cover lines 78-79: non-numeric content-length."""

    @pytest.mark.anyio
    async def test_invalid_content_length(self):
        """Lines 78-79: ValueError when content-length is not numeric."""
        mock_app = MagicMock()
        middleware = AuditEveryRequestToAuditEventMiddleware(mock_app)

        mock_request = MagicMock()
        mock_request.url.path = "/api/test"
        mock_request.url.query = None
        mock_request.method = "GET"
        mock_request.headers = {
            "content-length": "not-a-number",
            "user-agent": "test",
        }
        mock_request.client = MagicMock()
        mock_request.client.host = "127.0.0.1"
        mock_request.state = MagicMock()
        mock_request.state.actor_account_id = None
        mock_request.state.actor_type = "user"
        mock_request.state.session_id = None

        mock_response = MagicMock()
        mock_response.status_code = 200
        mock_response.headers = {}

        async def call_next(req):
            return mock_response

        with patch("app.middleware.audit_to_auditevent.get_db_connection") as mock_db:
            mock_cursor = MagicMock()
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db.return_value = mock_conn

            response = await middleware.dispatch(mock_request, call_next)
            assert response.status_code == 200


class TestMiddlewareDbWriteFailure:
    """Cover lines 154-156: DB write failure is silently caught."""

    @pytest.mark.anyio
    async def test_db_write_failure_silent(self):
        """Lines 154-156: Exception during DB insert is caught silently."""
        mock_app = MagicMock()
        middleware = AuditEveryRequestToAuditEventMiddleware(mock_app)

        mock_request = MagicMock()
        mock_request.url.path = "/api/test"
        mock_request.url.query = None
        mock_request.method = "GET"
        mock_request.headers = {
            "user-agent": "test",
        }
        mock_request.client = MagicMock()
        mock_request.client.host = "127.0.0.1"
        mock_request.state = MagicMock()
        mock_request.state.actor_account_id = None
        mock_request.state.actor_type = "user"
        mock_request.state.session_id = None

        mock_response = MagicMock()
        mock_response.status_code = 200
        mock_response.headers = {}

        async def call_next(req):
            return mock_response

        with patch("app.middleware.audit_to_auditevent.get_db_connection") as mock_db:
            mock_db.side_effect = Exception("DB connection failed")

            # Should not raise - silently catches the error
            response = await middleware.dispatch(mock_request, call_next)
            assert response.status_code == 200
