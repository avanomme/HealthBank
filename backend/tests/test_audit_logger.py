# tests/test_audit_logger.py
"""
Tests for app/audit/logger.py — audit_log() and _ip_to_varbinary().
"""

import json
import ipaddress
from unittest.mock import patch, MagicMock, PropertyMock
from types import SimpleNamespace

from app.audit.logger import _ip_to_varbinary, audit_log


# ---------------------------------------------------------------------------
# _ip_to_varbinary
# ---------------------------------------------------------------------------

class TestIpToVarbinary:

    def test_none(self):
        assert _ip_to_varbinary(None) is None

    def test_empty_string(self):
        assert _ip_to_varbinary("") is None

    def test_ipv4(self):
        result = _ip_to_varbinary("127.0.0.1")
        assert result == ipaddress.ip_address("127.0.0.1").packed
        assert len(result) == 4

    def test_ipv6(self):
        result = _ip_to_varbinary("::1")
        assert result == ipaddress.ip_address("::1").packed
        assert len(result) == 16

    def test_invalid(self):
        assert _ip_to_varbinary("not-an-ip") is None


# ---------------------------------------------------------------------------
# audit_log
# ---------------------------------------------------------------------------

class TestAuditLog:

    @patch("app.audit.logger.get_db_connection")
    def test_basic_success(self, mock_db):
        cursor = MagicMock()
        conn = MagicMock()
        conn.cursor.return_value = cursor
        mock_db.return_value = conn

        audit_log(
            request=None,
            action="login",
            resource_type="session",
            status="success",
        )

        cursor.execute.assert_called_once()
        conn.commit.assert_called_once()
        cursor.close.assert_called_once()
        conn.close.assert_called_once()

    @patch("app.audit.logger.get_db_connection")
    def test_with_request_context(self, mock_db):
        cursor = MagicMock()
        conn = MagicMock()
        conn.cursor.return_value = cursor
        mock_db.return_value = conn

        # Build a fake request with audit_ctx on state
        request = MagicMock()
        request.state.audit_ctx = SimpleNamespace(
            request_id="req-123",
            ip="192.168.1.1",
            user_agent="Mozilla/5.0",
            method="POST",
            path="/api/v1/login",
        )
        # hasattr check must work
        type(request.state).audit_ctx = PropertyMock(
            return_value=request.state.audit_ctx
        )

        audit_log(
            request=request,
            action="login",
            resource_type="session",
            resource_id="42",
            status="success",
            actor_type="user",
            actor_account_id=1,
            http_status_code=200,
            error_code=None,
            metadata={"detail": "ok"},
        )

        cursor.execute.assert_called_once()
        call_args = cursor.execute.call_args
        params = call_args[0][1]
        # request_id
        assert params[0] == "req-123"
        # actor_type
        assert params[1] == "user"
        # actor_account_id
        assert params[2] == 1
        # ip_bin is packed bytes for 192.168.1.1
        assert params[3] == ipaddress.ip_address("192.168.1.1").packed
        # metadata JSON
        assert json.loads(params[13]) == {"detail": "ok"}

    @patch("app.audit.logger.get_db_connection")
    def test_request_without_audit_ctx(self, mock_db):
        """Request exists but has no audit_ctx attribute on state."""
        cursor = MagicMock()
        conn = MagicMock()
        conn.cursor.return_value = cursor
        mock_db.return_value = conn

        request = MagicMock()
        # Remove audit_ctx so hasattr returns False
        del request.state.audit_ctx

        audit_log(
            request=request,
            action="test",
            resource_type="test",
            status="success",
        )

        cursor.execute.assert_called_once()
        params = cursor.execute.call_args[0][1]
        # All request-derived fields should be None
        assert params[0] is None  # request_id
        assert params[3] is None  # ip_bin
        assert params[4] is None  # user_agent
        assert params[5] is None  # method
        assert params[6] is None  # path

    @patch("app.audit.logger.get_db_connection")
    def test_metadata_none(self, mock_db):
        cursor = MagicMock()
        conn = MagicMock()
        conn.cursor.return_value = cursor
        mock_db.return_value = conn

        audit_log(
            request=None,
            action="test",
            resource_type="test",
            status="success",
            metadata=None,
        )

        params = cursor.execute.call_args[0][1]
        assert params[13] is None

    @patch("app.audit.logger.get_db_connection")
    def test_metadata_unserializable(self, mock_db):
        """Metadata with non-JSON-serializable values falls back to str()."""
        cursor = MagicMock()
        conn = MagicMock()
        conn.cursor.return_value = cursor
        mock_db.return_value = conn

        audit_log(
            request=None,
            action="test",
            resource_type="test",
            status="success",
            metadata={"obj": object()},
        )

        params = cursor.execute.call_args[0][1]
        parsed = json.loads(params[13])
        # The object should be stringified
        assert "object" in parsed["obj"].lower()

    @patch("app.audit.logger.get_db_connection")
    def test_db_error_silenced(self, mock_db):
        """DB errors in audit logging should never raise."""
        mock_db.side_effect = Exception("DB connection failed")

        # Should NOT raise
        audit_log(
            request=None,
            action="test",
            resource_type="test",
            status="failure",
        )

    @patch("app.audit.logger.get_db_connection")
    def test_cursor_execute_error_silenced(self, mock_db):
        cursor = MagicMock()
        cursor.execute.side_effect = Exception("insert failed")
        conn = MagicMock()
        conn.cursor.return_value = cursor
        mock_db.return_value = conn

        # Should NOT raise
        audit_log(
            request=None,
            action="test",
            resource_type="test",
            status="failure",
        )

    @patch("app.audit.logger.get_db_connection")
    def test_all_optional_params(self, mock_db):
        cursor = MagicMock()
        conn = MagicMock()
        conn.cursor.return_value = cursor
        mock_db.return_value = conn

        audit_log(
            request=None,
            action="account.create",
            resource_type="account",
            resource_id="123",
            status="success",
            actor_type="admin",
            actor_account_id=999,
            http_status_code=201,
            error_code="NONE",
            metadata={"new_role": "participant"},
        )

        params = cursor.execute.call_args[0][1]
        assert params[1] == "admin"
        assert params[2] == 999
        assert params[7] == "account.create"
        assert params[8] == "account"
        assert params[9] == "123"
        assert params[10] == "success"
        assert params[11] == 201
        assert params[12] == "NONE"
