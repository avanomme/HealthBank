# Created with the Assistance of Claude Code
# backend/tests/test_config.py
"""Tests for app/core/config.py — SMTPConfig and app constants."""

import pytest
from app.core.config import (
    SMTPConfig,
    get_smtp_config,
    K_ANONYMITY_THRESHOLD,
    DEFAULT_PAGE_LIMIT,
    MAX_PAGE_LIMIT,
    TEMP_PASSWORD_LENGTH,
    CURRENT_CONSENT_VERSION,
    CURRENT_TOS_VERSION,
    MAX_ACTIVE_SESSIONS,
    MFA_CHALLENGE_TTL_MINUTES,
    MFA_MAX_ATTEMPTS,
)


# ---------------------------------------------------------------------------
# SMTPConfig.from_address property (missing lines 38-40)
# ---------------------------------------------------------------------------

class TestSMTPConfigFromAddress:
    """Cover the from_address property branch logic."""

    def test_from_address_with_user(self):
        cfg = SMTPConfig(
            host="smtp.example.com",
            port=587,
            user="alice@example.com",
            password="secret",
            from_name="HealthBank",
            timeout=30,
        )
        assert cfg.from_address == "HealthBank <alice@example.com>"

    def test_from_address_without_user(self):
        cfg = SMTPConfig(
            host="smtp.example.com",
            port=587,
            user=None,
            password=None,
            from_name="HealthBank",
            timeout=30,
        )
        assert cfg.from_address == "HealthBank"

    def test_from_address_empty_user(self):
        cfg = SMTPConfig(
            host="smtp.example.com",
            port=587,
            user="",
            password=None,
            from_name="Fallback",
            timeout=30,
        )
        # Empty string is falsy, so should return from_name only
        assert cfg.from_address == "Fallback"

    def test_is_configured_true(self):
        cfg = SMTPConfig(
            host="h", port=587, user="u", password="p",
            from_name="n", timeout=10,
        )
        assert cfg.is_configured is True

    def test_is_configured_false_no_password(self):
        cfg = SMTPConfig(
            host="h", port=587, user="u", password=None,
            from_name="n", timeout=10,
        )
        assert cfg.is_configured is False


# ---------------------------------------------------------------------------
# get_smtp_config with environment variables
# ---------------------------------------------------------------------------

class TestGetSmtpConfig:
    def test_defaults(self, monkeypatch):
        monkeypatch.delenv("SMTP_HOST", raising=False)
        monkeypatch.delenv("SMTP_PORT", raising=False)
        monkeypatch.delenv("SMTP_USER", raising=False)
        monkeypatch.delenv("SMTP_PASSWORD", raising=False)
        monkeypatch.delenv("SMTP_FROM_NAME", raising=False)
        monkeypatch.delenv("SMTP_TIMEOUT", raising=False)

        cfg = get_smtp_config()
        assert cfg.host == "smtp.gmail.com"
        assert cfg.port == 587
        assert cfg.user is None
        assert cfg.password is None
        assert cfg.from_name == "HealthBank"
        assert cfg.timeout == 30

    def test_custom_values(self, monkeypatch):
        monkeypatch.setenv("SMTP_HOST", "mail.test.com")
        monkeypatch.setenv("SMTP_PORT", "465")
        monkeypatch.setenv("SMTP_USER", "me@test.com")
        monkeypatch.setenv("SMTP_PASSWORD", "pass123")
        monkeypatch.setenv("SMTP_FROM_NAME", "TestApp")
        monkeypatch.setenv("SMTP_TIMEOUT", "60")

        cfg = get_smtp_config()
        assert cfg.host == "mail.test.com"
        assert cfg.port == 465
        assert cfg.user == "me@test.com"
        assert cfg.password == "pass123"
        assert cfg.from_name == "TestApp"
        assert cfg.timeout == 60


# ---------------------------------------------------------------------------
# Application constants — existence and correct types
# ---------------------------------------------------------------------------

class TestAppConstants:
    def test_k_anonymity_threshold(self):
        assert isinstance(K_ANONYMITY_THRESHOLD, int)
        assert K_ANONYMITY_THRESHOLD == 1

    def test_page_limits(self):
        assert isinstance(DEFAULT_PAGE_LIMIT, int)
        assert isinstance(MAX_PAGE_LIMIT, int)
        assert DEFAULT_PAGE_LIMIT == 500
        assert MAX_PAGE_LIMIT == 1000

    def test_temp_password_length(self):
        assert isinstance(TEMP_PASSWORD_LENGTH, int)
        assert TEMP_PASSWORD_LENGTH == 16

    def test_consent_version_is_string(self):
        assert isinstance(CURRENT_CONSENT_VERSION, str)

    def test_tos_version_is_string(self):
        assert isinstance(CURRENT_TOS_VERSION, str)

    def test_session_and_mfa_constants_are_int(self):
        assert isinstance(MAX_ACTIVE_SESSIONS, int)
        assert isinstance(MFA_CHALLENGE_TTL_MINUTES, int)
        assert isinstance(MFA_MAX_ATTEMPTS, int)
