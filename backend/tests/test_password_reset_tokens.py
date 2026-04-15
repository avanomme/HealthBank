# backend/tests/test_password_reset_tokens.py
"""Tests for app/utils/password_reset_tokens.py — generate, validate, clear."""

import pytest
from unittest.mock import patch, MagicMock


# ---------------------------------------------------------------------------
# generate_reset_token_for_email (lines 40-43: no-match branch)
# ---------------------------------------------------------------------------

class TestGenerateResetToken:

    @patch("app.utils.password_reset_tokens.get_db_connection")
    def test_success_returns_token_and_expiry(self, mock_conn):
        from app.utils.password_reset_tokens import generate_reset_token_for_email

        mock_cur = MagicMock()
        mock_cur.rowcount = 1
        mock_conn.return_value.cursor.return_value = mock_cur

        token, expires_at = generate_reset_token_for_email("user@test.com")

        assert isinstance(token, str)
        assert len(token) > 0
        assert expires_at is not None
        mock_conn.return_value.commit.assert_called_once()
        mock_cur.close.assert_called_once()
        mock_conn.return_value.close.assert_called_once()

    @patch("app.utils.password_reset_tokens.get_db_connection")
    def test_no_matching_email_raises_lookup_error(self, mock_conn):
        from app.utils.password_reset_tokens import generate_reset_token_for_email

        mock_cur = MagicMock()
        mock_cur.rowcount = 0
        mock_conn.return_value.cursor.return_value = mock_cur

        with pytest.raises(LookupError, match="No account with that email"):
            generate_reset_token_for_email("nobody@test.com")

        # Should close but NOT commit
        mock_conn.return_value.commit.assert_not_called()
        mock_cur.close.assert_called_once()
        mock_conn.return_value.close.assert_called_once()


# ---------------------------------------------------------------------------
# clear_reset_token (lines 56-71)
# ---------------------------------------------------------------------------

class TestClearResetToken:

    @patch("app.utils.password_reset_tokens.get_db_connection")
    def test_clears_token(self, mock_conn):
        from app.utils.password_reset_tokens import clear_reset_token

        mock_cur = MagicMock()
        mock_conn.return_value.cursor.return_value = mock_cur

        clear_reset_token("some-token-value")

        mock_cur.execute.assert_called_once()
        # Verify the token was passed as parameter
        call_args = mock_cur.execute.call_args
        assert call_args[0][1] == ("some-token-value",)
        mock_conn.return_value.commit.assert_called_once()
        mock_cur.close.assert_called_once()
        mock_conn.return_value.close.assert_called_once()


# ---------------------------------------------------------------------------
# get_authid_by_valid_reset_token (lines 78-96)
# ---------------------------------------------------------------------------

class TestGetAuthIdByValidResetToken:

    @patch("app.utils.password_reset_tokens.get_db_connection")
    def test_valid_token_returns_auth_id(self, mock_conn):
        from app.utils.password_reset_tokens import get_authid_by_valid_reset_token

        mock_cur = MagicMock()
        mock_cur.fetchone.return_value = (42,)
        mock_conn.return_value.cursor.return_value = mock_cur

        result = get_authid_by_valid_reset_token("valid-token")

        assert result == 42
        mock_cur.close.assert_called_once()
        mock_conn.return_value.close.assert_called_once()

    @patch("app.utils.password_reset_tokens.get_db_connection")
    def test_invalid_token_returns_none(self, mock_conn):
        from app.utils.password_reset_tokens import get_authid_by_valid_reset_token

        mock_cur = MagicMock()
        mock_cur.fetchone.return_value = None
        mock_conn.return_value.cursor.return_value = mock_cur

        result = get_authid_by_valid_reset_token("expired-token")

        assert result is None
        mock_cur.close.assert_called_once()
        mock_conn.return_value.close.assert_called_once()
