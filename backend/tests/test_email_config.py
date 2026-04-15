# Created with the Assistance of Claude Code
# backend/tests/test_email_config.py
"""
Tests for email config validation.

Covers missing lines: 29-37 in app/services/email/config.py.
"""

import pytest
from unittest.mock import patch


class TestValidateEmailConfig:
    """Cover lines 29-37: validate_email_config raises on missing env vars."""

    def test_validate_missing_all_vars(self):
        """Lines 29-37: Missing both GMAIL_USER and GMAIL_APP_PASSWORD."""
        with patch.dict("os.environ", {}, clear=True):
            # Need to reload the module to pick up new env values
            import importlib
            import app.services.email.config as config_mod
            importlib.reload(config_mod)

            with pytest.raises(RuntimeError, match="Missing required email environment variables"):
                config_mod.validate_email_config()

    def test_validate_missing_gmail_password(self):
        """Lines 34-37: Missing only GMAIL_APP_PASSWORD."""
        with patch.dict("os.environ", {"GMAIL_USER": "test@gmail.com"}, clear=True):
            import importlib
            import app.services.email.config as config_mod
            importlib.reload(config_mod)

            with pytest.raises(RuntimeError, match="GMAIL_APP_PASSWORD"):
                config_mod.validate_email_config()

    def test_validate_missing_gmail_user(self):
        """Lines 34-37: Missing only GMAIL_USER."""
        with patch.dict("os.environ", {"GMAIL_APP_PASSWORD": "secret"}, clear=True):
            import importlib
            import app.services.email.config as config_mod
            importlib.reload(config_mod)

            with pytest.raises(RuntimeError, match="GMAIL_USER"):
                config_mod.validate_email_config()

    def test_validate_all_present(self):
        """All required vars present - no error."""
        with patch.dict("os.environ", {
            "GMAIL_USER": "test@gmail.com",
            "GMAIL_APP_PASSWORD": "secret",
        }, clear=True):
            import importlib
            import app.services.email.config as config_mod
            importlib.reload(config_mod)

            # Should not raise
            config_mod.validate_email_config()
