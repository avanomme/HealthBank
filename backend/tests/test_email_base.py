# Created with the Assistance of Claude Code
# backend/tests/test_email_base.py
"""
Tests for email base classes.

Covers missing lines: 43 (send abstract), 56 (send_bulk abstract).
"""

import pytest
from app.services.email.base import EmailProvider, EmailMessage


class ConcreteEmailProvider(EmailProvider):
    """Concrete implementation for testing the abstract base."""

    def __init__(self):
        self.sent = []
        self.bulk_sent = []

    def send(self, message: EmailMessage) -> bool:
        self.sent.append(message)
        return True

    def send_bulk(self, messages: list[EmailMessage]) -> dict[str, bool]:
        result = {}
        for msg in messages:
            self.bulk_sent.append(msg)
            result[msg.to] = True
        return result


class TestEmailMessage:

    def test_email_message_defaults(self):
        msg = EmailMessage(to="test@example.com", subject="Hi", body_text="Hello")
        assert msg.to == "test@example.com"
        assert msg.subject == "Hi"
        assert msg.body_text == "Hello"
        assert msg.body_html is None
        assert msg.from_name == "HealthBank"


class TestEmailProvider:
    """Cover lines 43 and 56: abstract methods are callable via concrete impl."""

    def test_send(self):
        """Line 43: send method works via concrete implementation."""
        provider = ConcreteEmailProvider()
        msg = EmailMessage(to="a@b.com", subject="Test", body_text="Body")
        result = provider.send(msg)
        assert result is True
        assert len(provider.sent) == 1

    def test_send_bulk(self):
        """Line 56: send_bulk method works via concrete implementation."""
        provider = ConcreteEmailProvider()
        messages = [
            EmailMessage(to="a@b.com", subject="T1", body_text="B1"),
            EmailMessage(to="c@d.com", subject="T2", body_text="B2"),
        ]
        result = provider.send_bulk(messages)
        assert result == {"a@b.com": True, "c@d.com": True}
        assert len(provider.bulk_sent) == 2

    def test_cannot_instantiate_abstract(self):
        """EmailProvider cannot be instantiated directly."""
        with pytest.raises(TypeError):
            EmailProvider()
