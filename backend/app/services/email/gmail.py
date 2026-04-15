# Created with the assistance of Claude Code
# backend/app/services/email/gmail.py
"""
Gmail SMTP email provider implementation.
"""
import smtplib
import logging
from email.message import EmailMessage as StdEmailMessage
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

from .base import EmailProvider, EmailMessage

logger = logging.getLogger(__name__)


class GmailProvider(EmailProvider):
    """
    Gmail SMTP email provider.

    Uses Gmail's SMTP server with TLS.
    Requires an App Password for authentication (not regular password).

    To generate an App Password:
    1. Enable 2FA on your Google account
    2. Go to Google Account > Security > App Passwords
    3. Generate a new app password for "Mail"
    """

    SMTP_HOST = "smtp.gmail.com"
    SMTP_PORT = 587  # TLS

    def __init__(self, user: str, app_password: str):
        """
        Initialize Gmail provider.

        Args:
            user: Gmail address (e.g., "example@gmail.com")
            app_password: Google App Password (16 characters, no spaces)
        """
        self.user = user
        self.app_password = app_password

    def _create_message(self, message: EmailMessage) -> StdEmailMessage | MIMEMultipart:
        """Create email message object."""
        if message.body_html:
            msg = MIMEMultipart("alternative")
            msg.attach(MIMEText(message.body_text, "plain"))
            msg.attach(MIMEText(message.body_html, "html"))
        else:
            msg = StdEmailMessage()
            msg.set_content(message.body_text)

        msg["From"] = f"{message.from_name} <{self.user}>"
        msg["To"] = message.to
        msg["Subject"] = message.subject

        return msg

    def send(self, message: EmailMessage) -> bool:
        """
        Send a single email via Gmail SMTP.

        Args:
            message: EmailMessage object

        Returns:
            True if sent successfully, False otherwise
        """
        try:
            msg = self._create_message(message)

            with smtplib.SMTP(self.SMTP_HOST, self.SMTP_PORT) as smtp:
                smtp.starttls()
                smtp.login(self.user, self.app_password)
                smtp.send_message(msg)

            logger.info(f"Email sent successfully to {message.to}")
            return True

        except smtplib.SMTPAuthenticationError as e:
            logger.error(f"Gmail authentication failed: {e}")
            return False
        except smtplib.SMTPException as e:
            logger.error(f"SMTP error sending email to {message.to}: {e}")
            return False
        except Exception as e:
            logger.error(f"Unexpected error sending email to {message.to}: {e}")
            return False

    def send_bulk(self, messages: list[EmailMessage]) -> dict[str, bool]:
        """
        Send multiple emails via Gmail SMTP.

        Opens a single SMTP connection for all messages.

        Args:
            messages: List of EmailMessage objects

        Returns:
            Dict mapping recipient addresses to success status
        """
        results = {}

        if not messages:
            return results

        try:
            with smtplib.SMTP(self.SMTP_HOST, self.SMTP_PORT) as smtp:
                smtp.starttls()
                smtp.login(self.user, self.app_password)

                for message in messages:
                    try:
                        msg = self._create_message(message)
                        smtp.send_message(msg)
                        results[message.to] = True
                        logger.info(f"Email sent successfully to {message.to}")
                    except Exception as e:
                        results[message.to] = False
                        logger.error(f"Failed to send email to {message.to}: {e}")

        except smtplib.SMTPAuthenticationError as e:
            logger.error(f"Gmail authentication failed: {e}")
            for message in messages:
                if message.to not in results:
                    results[message.to] = False
        except Exception as e:
            logger.error(f"SMTP connection error: {e}")
            for message in messages:
                if message.to not in results:
                    results[message.to] = False

        return results
