# Gmail Email Provider

Gmail SMTP-based email provider implementation.

**File:** `backend/app/services/email/gmail.py`

---

## Overview

This module provides a concrete implementation of the `EmailProvider` interface using Gmail's SMTP server with TLS.

It supports:

- Plain text and HTML email content
- Single email sending
- Bulk email sending using a shared SMTP connection
- Structured logging for success and error cases
- Secure authentication via Gmail App Password

This provider is designed to integrate seamlessly with the `EmailMessage` data structure defined in `base.py`.

---

## Source Code

```python
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
```

---

## Configuration Requirements

This provider requires:

- A Gmail account
- Two-Factor Authentication enabled
- A generated Gmail App Password

### Required Credentials

| Parameter | Description |
|------------|-------------|
| `user` | Gmail email address |
| `app_password` | 16-character Gmail App Password |

Example environment configuration:

```env
GMAIL_USER=healthbank.notifications@gmail.com
GMAIL_APP_PASSWORD=xxxxxxxxxxxxxxxx
```

---

## SMTP Settings

| Setting | Value |
|----------|--------|
| Host | `smtp.gmail.com` |
| Port | `587` |
| Encryption | TLS (`starttls()`) |

---

## Email Creation

The `_create_message()` method builds either:

- A multipart email (plain + HTML) when `body_html` is provided
- A simple plain text email otherwise

Headers set:

- `From`
- `To`
- `Subject`

---

## API Reference

### `send(message: EmailMessage) -> bool`

Send a single email using a new SMTP connection.

Returns:

- `True` if sent successfully
- `False` if authentication or SMTP errors occur

---

### `send_bulk(messages: list[EmailMessage]) -> dict[str, bool]`

Send multiple emails using a single SMTP connection.

Returns:

- Dictionary mapping recipient email to success status

Example:

```python
{
    "user1@example.com": True,
    "user2@example.com": False
}
```

---

## Error Handling

The provider handles:

| Exception | Behavior |
|------------|-----------|
| `SMTPAuthenticationError` | Logs authentication failure and returns `False` |
| `SMTPException` | Logs SMTP error and returns `False` |
| General `Exception` | Logs unexpected error and returns `False` |

For bulk sending:

- If connection fails, all unsent messages are marked as `False`
- Individual send failures do not stop remaining emails

---

## Logging

This provider uses Python's `logging` module:

- `logger.info` for successful sends
- `logger.error` for failures

Ensure logging is properly configured in your application to capture these events.

---

## Files

- `backend/app/services/email/gmail.py` — Gmail provider implementation
- `backend/app/services/email/base.py` — Email provider base interface
- `backend/app/services/email/config.py` — Email configuration and validation