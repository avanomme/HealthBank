# tests/test_email.py
"""
Tests for email modules:
- app/services/email/gmail.py (GmailProvider)
- app/services/email/service.py (EmailService)
- app/services/email/templates.py (template functions)
- app/services/email/config.py (configuration)
"""

import pytest
import smtplib
from unittest.mock import patch, MagicMock, PropertyMock
from dataclasses import dataclass

# ── gmail.py ──────────────────────────────────────────────────────────────

from app.services.email.base import EmailMessage
from app.services.email.gmail import GmailProvider


class TestGmailProviderCreateMessage:

    def test_plain_text_only(self):
        provider = GmailProvider(user="bot@gmail.com", app_password="secret")
        msg = EmailMessage(
            to="user@example.com",
            subject="Hello",
            body_text="Plain text body",
        )
        result = provider._create_message(msg)
        assert result["To"] == "user@example.com"
        assert result["Subject"] == "Hello"
        assert "HealthBank" in result["From"]

    def test_html_multipart(self):
        provider = GmailProvider(user="bot@gmail.com", app_password="secret")
        msg = EmailMessage(
            to="user@example.com",
            subject="Hi",
            body_text="plain",
            body_html="<h1>HTML</h1>",
        )
        result = provider._create_message(msg)
        assert result["To"] == "user@example.com"
        # MIMEMultipart has payloads
        payloads = result.get_payload()
        assert len(payloads) == 2  # plain + html


class TestGmailProviderSend:

    @patch("app.services.email.gmail.smtplib.SMTP")
    def test_send_success(self, mock_smtp_cls):
        smtp_instance = MagicMock()
        mock_smtp_cls.return_value.__enter__ = MagicMock(return_value=smtp_instance)
        mock_smtp_cls.return_value.__exit__ = MagicMock(return_value=False)

        provider = GmailProvider(user="bot@gmail.com", app_password="secret")
        msg = EmailMessage(to="user@example.com", subject="Hi", body_text="body")
        result = provider.send(msg)
        assert result is True

    @patch("app.services.email.gmail.smtplib.SMTP")
    def test_send_auth_failure(self, mock_smtp_cls):
        smtp_instance = MagicMock()
        smtp_instance.login.side_effect = smtplib.SMTPAuthenticationError(535, b"Bad credentials")
        mock_smtp_cls.return_value.__enter__ = MagicMock(return_value=smtp_instance)
        mock_smtp_cls.return_value.__exit__ = MagicMock(return_value=False)

        provider = GmailProvider(user="bot@gmail.com", app_password="bad")
        msg = EmailMessage(to="user@example.com", subject="Hi", body_text="body")
        result = provider.send(msg)
        assert result is False

    @patch("app.services.email.gmail.smtplib.SMTP")
    def test_send_smtp_exception(self, mock_smtp_cls):
        smtp_instance = MagicMock()
        smtp_instance.send_message.side_effect = smtplib.SMTPException("error")
        mock_smtp_cls.return_value.__enter__ = MagicMock(return_value=smtp_instance)
        mock_smtp_cls.return_value.__exit__ = MagicMock(return_value=False)

        provider = GmailProvider(user="bot@gmail.com", app_password="secret")
        msg = EmailMessage(to="user@example.com", subject="Hi", body_text="body")
        result = provider.send(msg)
        assert result is False

    @patch("app.services.email.gmail.smtplib.SMTP")
    def test_send_unexpected_exception(self, mock_smtp_cls):
        smtp_instance = MagicMock()
        smtp_instance.send_message.side_effect = RuntimeError("boom")
        mock_smtp_cls.return_value.__enter__ = MagicMock(return_value=smtp_instance)
        mock_smtp_cls.return_value.__exit__ = MagicMock(return_value=False)

        provider = GmailProvider(user="bot@gmail.com", app_password="secret")
        msg = EmailMessage(to="user@example.com", subject="Hi", body_text="body")
        result = provider.send(msg)
        assert result is False


class TestGmailProviderSendBulk:

    @patch("app.services.email.gmail.smtplib.SMTP")
    def test_send_bulk_success(self, mock_smtp_cls):
        smtp_instance = MagicMock()
        mock_smtp_cls.return_value.__enter__ = MagicMock(return_value=smtp_instance)
        mock_smtp_cls.return_value.__exit__ = MagicMock(return_value=False)

        provider = GmailProvider(user="bot@gmail.com", app_password="secret")
        messages = [
            EmailMessage(to="a@example.com", subject="Hi", body_text="body"),
            EmailMessage(to="b@example.com", subject="Hi", body_text="body"),
        ]
        results = provider.send_bulk(messages)
        assert results == {"a@example.com": True, "b@example.com": True}

    def test_send_bulk_empty(self):
        provider = GmailProvider(user="bot@gmail.com", app_password="secret")
        results = provider.send_bulk([])
        assert results == {}

    @patch("app.services.email.gmail.smtplib.SMTP")
    def test_send_bulk_partial_failure(self, mock_smtp_cls):
        smtp_instance = MagicMock()
        call_count = 0

        def side_effect(msg):
            nonlocal call_count
            call_count += 1
            if call_count == 2:
                raise Exception("fail")

        smtp_instance.send_message.side_effect = side_effect
        mock_smtp_cls.return_value.__enter__ = MagicMock(return_value=smtp_instance)
        mock_smtp_cls.return_value.__exit__ = MagicMock(return_value=False)

        provider = GmailProvider(user="bot@gmail.com", app_password="secret")
        messages = [
            EmailMessage(to="a@example.com", subject="Hi", body_text="body"),
            EmailMessage(to="b@example.com", subject="Hi", body_text="body"),
        ]
        results = provider.send_bulk(messages)
        assert results["a@example.com"] is True
        assert results["b@example.com"] is False

    @patch("app.services.email.gmail.smtplib.SMTP")
    def test_send_bulk_auth_failure(self, mock_smtp_cls):
        smtp_instance = MagicMock()
        smtp_instance.login.side_effect = smtplib.SMTPAuthenticationError(535, b"Bad")
        mock_smtp_cls.return_value.__enter__ = MagicMock(return_value=smtp_instance)
        mock_smtp_cls.return_value.__exit__ = MagicMock(return_value=False)

        provider = GmailProvider(user="bot@gmail.com", app_password="bad")
        messages = [
            EmailMessage(to="a@example.com", subject="Hi", body_text="body"),
        ]
        results = provider.send_bulk(messages)
        assert results["a@example.com"] is False

    @patch("app.services.email.gmail.smtplib.SMTP")
    def test_send_bulk_connection_error(self, mock_smtp_cls):
        mock_smtp_cls.return_value.__enter__ = MagicMock(
            side_effect=Exception("connection failed")
        )
        mock_smtp_cls.return_value.__exit__ = MagicMock(return_value=False)

        provider = GmailProvider(user="bot@gmail.com", app_password="secret")
        messages = [
            EmailMessage(to="a@example.com", subject="Hi", body_text="body"),
        ]
        results = provider.send_bulk(messages)
        assert results["a@example.com"] is False


# ── templates.py ──────────────────────────────────────────────────────────

from app.services.email.templates import (
    _base_html,
    account_created,
    password_reset_request,
    password_changed,
    two_factor_setup,
)


class TestTemplates:

    def test_base_html(self):
        html = _base_html("<p>Hello</p>")
        assert "<p>Hello</p>" in html
        assert "HealthBank" in html
        assert "<!DOCTYPE html>" in html

    def test_account_created(self):
        subject, text, html = account_created(
            user_name="John",
            user_email="john@example.com",
            temporary_password="TempPass123!",
            login_url="https://app.example.com/login",
        )
        assert "Welcome" in subject
        assert "John" in text
        assert "TempPass123!" in text
        assert "john@example.com" in text
        assert "https://app.example.com/login" in text
        assert "John" in html
        assert "TempPass123!" in html

    def test_password_reset_request(self):
        subject, text, html = password_reset_request(
            user_name="Jane",
            reset_url="https://app.example.com/reset?token=abc123",
            expiry_minutes=30,
        )
        assert "Password Reset" in subject
        assert "Jane" in text
        assert "abc123" in text
        assert "30" in text
        assert "Jane" in html
        assert "30" in html

    def test_password_reset_request_default_expiry(self):
        subject, text, html = password_reset_request(
            user_name="Jane",
            reset_url="https://app.example.com/reset",
        )
        assert "60" in text  # default 60 minutes

    def test_password_changed(self):
        subject, text, html = password_changed(
            user_name="Bob",
            user_email="bob@example.com",
        )
        assert "Changed" in subject
        assert "Bob" in text
        assert "bob@example.com" in text
        assert "Bob" in html

    def test_two_factor_setup(self):
        subject, text, html = two_factor_setup(
            user_name="Alice",
            setup_url="https://app.example.com/setup-2fa",
        )
        assert "Two-Factor" in subject
        assert "Alice" in text
        assert "https://app.example.com/setup-2fa" in text
        assert "Alice" in html


# ── service.py (EmailService) ────────────────────────────────────────────

from app.services.email.service import EmailService


class TestEmailService:

    @patch("app.services.email.service.config")
    @patch("app.services.email.service.validate_email_config")
    def test_get_provider_creates_gmail(self, mock_validate, mock_config):
        mock_config.GMAIL_USER = "bot@gmail.com"
        mock_config.GMAIL_APP_PASSWORD = "secret"
        svc = EmailService()
        provider = svc._get_provider()
        assert isinstance(provider, GmailProvider)
        mock_validate.assert_called_once()

    @patch("app.services.email.service.config")
    @patch("app.services.email.service.validate_email_config")
    def test_get_provider_caches(self, mock_validate, mock_config):
        mock_config.GMAIL_USER = "bot@gmail.com"
        mock_config.GMAIL_APP_PASSWORD = "secret"
        svc = EmailService()
        p1 = svc._get_provider()
        p2 = svc._get_provider()
        assert p1 is p2
        assert mock_validate.call_count == 1

    def test_send_account_created_email(self):
        svc = EmailService()
        mock_provider = MagicMock()
        mock_provider.send.return_value = True
        svc._provider = mock_provider

        result = svc.send_account_created_email(
            user_name="John",
            user_email="john@example.com",
            temporary_password="pass123",
            login_url="https://example.com/login",
        )
        assert result is True
        mock_provider.send.assert_called_once()

    def test_send_account_created_email_failure(self):
        svc = EmailService()
        mock_provider = MagicMock()
        mock_provider.send.return_value = False
        svc._provider = mock_provider

        result = svc.send_account_created_email(
            user_name="John",
            user_email="john@example.com",
            temporary_password="pass123",
        )
        assert result is False

    def test_send_password_reset_email(self):
        svc = EmailService()
        mock_provider = MagicMock()
        mock_provider.send.return_value = True
        svc._provider = mock_provider

        result = svc.send_password_reset_email(
            user_name="Jane",
            user_email="jane@example.com",
            reset_token="token123",
        )
        assert result is True
        mock_provider.send.assert_called_once()

    def test_send_password_reset_email_failure(self):
        svc = EmailService()
        mock_provider = MagicMock()
        mock_provider.send.return_value = False
        svc._provider = mock_provider

        result = svc.send_password_reset_email(
            user_name="Jane",
            user_email="jane@example.com",
            reset_token="token123",
        )
        assert result is False

    def test_send_password_changed_email(self):
        svc = EmailService()
        mock_provider = MagicMock()
        mock_provider.send.return_value = True
        svc._provider = mock_provider

        result = svc.send_password_changed_email(
            user_name="Bob",
            user_email="bob@example.com",
        )
        assert result is True

    def test_send_password_changed_email_failure(self):
        svc = EmailService()
        mock_provider = MagicMock()
        mock_provider.send.return_value = False
        svc._provider = mock_provider

        result = svc.send_password_changed_email(
            user_name="Bob",
            user_email="bob@example.com",
        )
        assert result is False

    def test_send_2fa_setup_email(self):
        svc = EmailService()
        mock_provider = MagicMock()
        mock_provider.send.return_value = True
        svc._provider = mock_provider

        result = svc.send_2fa_setup_email(
            user_name="Alice",
            user_email="alice@example.com",
        )
        assert result is True

    def test_send_2fa_setup_email_failure(self):
        svc = EmailService()
        mock_provider = MagicMock()
        mock_provider.send.return_value = False
        svc._provider = mock_provider

        result = svc.send_2fa_setup_email(
            user_name="Alice",
            user_email="alice@example.com",
        )
        assert result is False

    def test_send_2fa_setup_email_custom_url(self):
        svc = EmailService()
        mock_provider = MagicMock()
        mock_provider.send.return_value = True
        svc._provider = mock_provider

        result = svc.send_2fa_setup_email(
            user_name="Alice",
            user_email="alice@example.com",
            setup_url="https://custom.example.com/2fa",
        )
        assert result is True


# ── config.py ─────────────────────────────────────────────────────────────

from app.services.email.config import validate_email_config
from app.core.config import SMTPConfig


class TestEmailConfig:

    @patch("app.services.email.config.GMAIL_USER", "bot@gmail.com")
    @patch("app.services.email.config.GMAIL_APP_PASSWORD", "secret")
    def test_validate_config_ok(self):
        validate_email_config()  # should not raise

    @patch("app.services.email.config.GMAIL_USER", None)
    @patch("app.services.email.config.GMAIL_APP_PASSWORD", None)
    def test_validate_config_missing(self):
        with pytest.raises(RuntimeError, match="Missing required"):
            validate_email_config()


# ── SMTPConfig from core/config.py ────────────────────────────────────────

class TestSMTPConfig:

    def test_is_configured_true(self):
        cfg = SMTPConfig(
            host="smtp.test.com", port=587,
            user="user@test.com", password="pass",
            from_name="Test", timeout=30,
        )
        assert cfg.is_configured is True

    def test_is_configured_false(self):
        cfg = SMTPConfig(
            host="smtp.test.com", port=587,
            user=None, password=None,
            from_name="Test", timeout=30,
        )
        assert cfg.is_configured is False

    def test_from_address_with_user(self):
        cfg = SMTPConfig(
            host="smtp.test.com", port=587,
            user="user@test.com", password="pass",
            from_name="HealthBank", timeout=30,
        )
        assert "HealthBank" in cfg.from_address
        assert "user@test.com" in cfg.from_address

    def test_from_address_without_user(self):
        cfg = SMTPConfig(
            host="smtp.test.com", port=587,
            user=None, password=None,
            from_name="HealthBank", timeout=30,
        )
        assert cfg.from_address == "HealthBank"
