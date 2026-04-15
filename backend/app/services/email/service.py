# Created with the assistance of Claude Code
# backend/app/services/email/service.py
"""
High-level email service for HealthBank.

This module provides easy-to-use functions for sending common emails.
It abstracts away the provider implementation details.

Usage:
    from app.services.email import email_service

    # Send account creation email
    email_service.send_account_created_email(
        user_name="John Doe",
        user_email="john@example.com",
        temporary_password="TempPass123!"
    )

    # Send password reset email
    email_service.send_password_reset_email(
        user_name="John Doe",
        user_email="john@example.com",
        reset_token="abc123..."
    )
"""
import logging
from typing import Optional

from . import config
from .base import EmailProvider, EmailMessage
from .gmail import GmailProvider
from .config import validate_email_config
from . import templates

logger = logging.getLogger(__name__)


class EmailService:
    """
    High-level email service for HealthBank.

    Provides methods for common email operations with built-in templates.
    To switch email providers, modify the _get_provider() method.
    """

    def __init__(self):
        self._provider: Optional[EmailProvider] = None

    def _get_provider(self) -> EmailProvider:
        """
        Get or create the email provider instance.

        To switch providers (e.g., SendGrid), change the construction here.
        """
        if self._provider is None:
            # Ensure required env vars are present before constructing provider
            validate_email_config()

            self._provider = GmailProvider(
                user=config.GMAIL_USER,
                app_password=config.GMAIL_APP_PASSWORD
            )
        return self._provider

    def _send(self, to: str, subject: str, body_text: str, body_html: Optional[str] = None) -> bool:
        """Internal method to send an email."""
        message = EmailMessage(
            to=to,
            subject=subject,
            body_text=body_text,
            body_html=body_html
        )
        return self._get_provider().send(message)

    # ------------------------------------------------------------
    # Account Creation
    # ------------------------------------------------------------

    def send_account_created_email(
        self,
        user_name: str,
        user_email: str,
        temporary_password: str,
        login_url: Optional[str] = None
    ) -> bool:
        """
        Send account creation email with temporary password.

        Args:
            user_name: Name of the new user
            user_email: Email address to send to
            temporary_password: Temporary password for first login
            login_url: Optional custom login URL (defaults to config)

        Returns:
            True if email sent successfully
        """
        url = login_url or config.LOGIN_URL
        subject, body_text, body_html = templates.account_created(
            user_name=user_name,
            user_email=user_email,
            temporary_password=temporary_password,
            login_url=url
        )

        success = self._send(user_email, subject, body_text, body_html)
        if success:
            logger.info(f"Account creation email sent to {user_email}")
        else:
            logger.error(f"Failed to send account creation email to {user_email}")
        return success

    # ------------------------------------------------------------
    # Password Reset
    # ------------------------------------------------------------

    def send_password_reset_email(
        self,
        user_name: str,
        user_email: str,
        reset_token: str,
        base_url: Optional[str] = None
    ) -> bool:
        """
        Send password reset email with secure link.

        Should only be called AFTER user has verified 2FA.

        Args:
            user_name: Name of the user
            user_email: Email address to send to
            reset_token: Secure token for password reset
            base_url: Optional custom base URL for reset link

        Returns:
            True if email sent successfully
        """
        base = base_url or config.PASSWORD_RESET_URL
        reset_url = f"{base}?token={reset_token}"

        subject, body_text, body_html = templates.password_reset_request(
            user_name=user_name,
            reset_url=reset_url,
            expiry_minutes=config.PASSWORD_RESET_EXPIRY_MINUTES
        )

        success = self._send(user_email, subject, body_text, body_html)
        if success:
            logger.info(f"Password reset email sent to {user_email}")
        else:
            logger.error(f"Failed to send password reset email to {user_email}")
        return success

    def send_password_changed_email(
        self,
        user_name: str,
        user_email: str
    ) -> bool:
        """
        Send password change confirmation email.

        Args:
            user_name: Name of the user
            user_email: Email address to send to

        Returns:
            True if email sent successfully
        """
        subject, body_text, body_html = templates.password_changed(
            user_name=user_name,
            user_email=user_email
        )

        success = self._send(user_email, subject, body_text, body_html)
        if success:
            logger.info(f"Password changed confirmation sent to {user_email}")
        else:
            logger.error(f"Failed to send password changed email to {user_email}")
        return success

    # ------------------------------------------------------------
    # Two-Factor Authentication
    # ------------------------------------------------------------

    def send_2fa_setup_email(
        self,
        user_name: str,
        user_email: str,
        setup_url: Optional[str] = None
    ) -> bool:
        """
        Send 2FA setup reminder email.

        Args:
            user_name: Name of the user
            user_email: Email address to send to
            setup_url: Optional custom setup URL

        Returns:
            True if email sent successfully
        """
        url = setup_url or config.TWO_FACTOR_SETUP_URL

        subject, body_text, body_html = templates.two_factor_setup(
            user_name=user_name,
            setup_url=url
        )

        success = self._send(user_email, subject, body_text, body_html)
        if success:
            logger.info(f"2FA setup email sent to {user_email}")
        else:
            logger.error(f"Failed to send 2FA setup email to {user_email}")
        return success

    # ------------------------------------------------------------
    # Admin Password Reset (temp password)
    # ------------------------------------------------------------

    def send_admin_password_reset_email(
        self,
        user_name: str,
        user_email: str,
        temporary_password: str,
    ) -> bool:
        """Send admin-initiated password reset email with a temporary password."""
        subject, body_text, body_html = templates.admin_password_reset(
            user_name=user_name,
            temporary_password=temporary_password,
        )
        success = self._send(user_email, subject, body_text, body_html)
        if success:
            logger.info(f"Admin password reset email sent to {user_email}")
        else:
            logger.error(f"Failed to send admin password reset email to {user_email}")
        return success

    # ------------------------------------------------------------
    # Account Rejection
    # ------------------------------------------------------------

    def send_account_rejected_email(
        self,
        user_name: str,
        user_email: str,
        admin_notes: Optional[str] = None,
    ) -> bool:
        """Send account request rejection notification."""
        subject, body_text, body_html = templates.account_rejected(
            user_name=user_name,
            admin_notes=admin_notes,
        )
        success = self._send(user_email, subject, body_text, body_html)
        if success:
            logger.info(f"Account rejection email sent to {user_email}")
        else:
            logger.error(f"Failed to send account rejection email to {user_email}")
        return success

    # ------------------------------------------------------------
    # Self-service Forgot Password
    # ------------------------------------------------------------

    def send_account_deletion_rejected_email(
        self,
        user_name: str,
        user_email: str,
        admin_notes: Optional[str] = None,
    ) -> bool:
        """Send notification when an admin rejects an account deletion request."""
        subject, body_text, body_html = templates.account_deletion_rejected(
            user_name=user_name,
            admin_notes=admin_notes,
        )
        success = self._send(user_email, subject, body_text, body_html)
        if success:
            logger.info(f"Account deletion rejected email sent to {user_email}")
        else:
            logger.error(f"Failed to send account deletion rejected email to {user_email}")
        return success

    def send_account_deletion_approved_email(
        self,
        user_name: str,
        user_email: str,
    ) -> bool:
        """Send notification when an admin approves an account deletion request."""
        subject, body_text, body_html = templates.account_deletion_approved(
            user_name=user_name,
        )
        success = self._send(user_email, subject, body_text, body_html)
        if success:
            logger.info(f"Account deletion approved email sent to {user_email}")
        else:
            logger.error(f"Failed to send account deletion approved email to {user_email}")
        return success

    def send_forgot_password_email(
        self,
        user_name: str,
        user_email: str,
        reset_link: str,
    ) -> bool:
        """Send self-service forgot-password email with a reset link."""
        subject, body_text, body_html = templates.forgot_password(
            user_name=user_name,
            reset_link=reset_link,
        )
        success = self._send(user_email, subject, body_text, body_html)
        if success:
            logger.info(f"Forgot password email sent to {user_email}")
        else:
            logger.error(f"Failed to send forgot password email to {user_email}")
        return success


# Singleton instance for easy imports
email_service = EmailService()
