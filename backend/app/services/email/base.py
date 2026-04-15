# Created with the assistance of Claude Code
# backend/app/services/email/base.py
"""
Abstract base class for email providers.
Implement this interface to add support for different email services.
"""
from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import Optional


@dataclass
class EmailMessage:
    """Standard email message structure."""
    to: str
    subject: str
    body_text: str
    body_html: Optional[str] = None
    from_name: str = "HealthBank"


class EmailProvider(ABC):
    """
    Abstract base class for email providers.

    To switch email services (e.g., SendGrid, Mailgun, AWS SES):
    1. Create a new class that inherits from EmailProvider
    2. Implement the send() method
    3. Update email_config.py to use the new provider
    """

    @abstractmethod
    def send(self, message: EmailMessage) -> bool:
        """
        Send an email message.

        Args:
            message: EmailMessage object containing email details

        Returns:
            True if email was sent successfully, False otherwise
        """
        pass

    @abstractmethod
    def send_bulk(self, messages: list[EmailMessage]) -> dict[str, bool]:
        """
        Send multiple email messages.

        Args:
            messages: List of EmailMessage objects

        Returns:
            Dict mapping recipient addresses to success status
        """
        pass
