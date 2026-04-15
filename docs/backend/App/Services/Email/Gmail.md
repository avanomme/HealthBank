# `markdown/email_gmail_provider.md` — Gmail SMTP Provider (`backend/app/services/email/gmail.py`)

## Overview

`backend/app/services/email/gmail.py` implements a concrete `EmailProvider` using Gmail’s SMTP server over TLS.

It supports:

- Sending single emails
- Sending multiple emails over a shared SMTP connection
- Multipart (text + HTML) messages
- Structured logging for success and failure cases

Authentication requires a **Google App Password**, not a regular Gmail password.

---

## Architecture / Design Explanation

### Provider Role

`GmailProvider` implements the `EmailProvider` abstract base class:

- `send(message: EmailMessage) -> bool`
- `send_bulk(messages: list[EmailMessage]) -> dict[str, bool]`

This allows it to be swapped with other providers (e.g., SendGrid, Mailgun, AWS SES) without changing calling code.

### SMTP Configuration

Hardcoded constants:

- `SMTP_HOST = "smtp.gmail.com"`
- `SMTP_PORT = 587` (TLS)

Connection flow:

1. Open `smtplib.SMTP(host, port)`
2. Call `starttls()` for encrypted transport
3. Call `login(user, app_password)`
4. Send message(s)
5. Close connection via context manager

### Message Construction

Email messages are built using:

- `email.message.EmailMessage` (text-only)
- `email.mime.multipart.MIMEMultipart` (when HTML body exists)
- `email.mime.text.MIMEText` for plain and HTML parts

If `body_html` is provided:

- A `multipart/alternative` message is created
- Plain text is attached first
- HTML version is attached second

Otherwise:

- A simple text-only message is created

### Logging Strategy

Uses Python’s `logging` module:

- Logs success via `logger.info`
- Logs SMTP/authentication errors via `logger.error`
- Never raises exceptions outward; returns boolean status instead

---

## Configuration (if applicable)

### Required Inputs

The provider must be instantiated with:

- `user: str`
- `app_password: str`

These are typically loaded from environment variables:

- `GMAIL_USER`
- `GMAIL_APP_PASSWORD`

See: `backend/app/services/email/config.py`

### Gmail Requirements

To use Gmail SMTP:

1. Enable 2FA on the Google account
2. Generate an App Password:
   - Google Account → Security → App Passwords
   - Select “Mail”
3. Use the generated 16-character app password (no spaces)

---

## API Reference

### Class: `GmailProvider`

Inherits from `EmailProvider`.

---

### `__init__(self, user: str, app_password: str)`

**Parameters**

- `user: str`
  - Gmail email address (e.g., `"example@gmail.com"`)
- `app_password: str`
  - Google App Password (16-character string)

Stores credentials for use during SMTP login.

---

### `_create_message(self, message: EmailMessage) -> StdEmailMessage | MIMEMultipart`

Internal helper method.

Builds either:

- A text-only `EmailMessage`
- A `multipart/alternative` message if `body_html` is provided

Sets headers:

- `From`
- `To`
- `Subject`

---

### `send(self, message: EmailMessage) -> bool`

Send a single email.

**Parameters**

- `message: EmailMessage`

**Returns**

- `True` if successfully sent
- `False` if any SMTP or unexpected error occurs

**Error Handling**

Catches:

- `smtplib.SMTPAuthenticationError`
- `smtplib.SMTPException`
- Generic `Exception`

Logs errors and returns `False`.

---

### `send_bulk(self, messages: list[EmailMessage]) -> dict[str, bool]`

Send multiple emails using a single SMTP connection.

**Parameters**

- `messages: list[EmailMessage]`

**Returns**

- `dict[str, bool]`
  - Keys: recipient email addresses
  - Values: `True` (sent) or `False` (failed)

**Behavior**

- Opens one SMTP connection
- Logs in once
- Iterates through messages
- Sends individually inside a try/except per message
- If authentication fails:
  - All unsent messages are marked `False`
- If connection fails:
  - All unsent messages are marked `False`

---

## Parameters and Return Types

### `send`

- **Parameters**
  - `EmailMessage`
- **Returns**
  - `bool`

### `send_bulk`

- **Parameters**
  - `list[EmailMessage]`
- **Returns**
  - `dict[str, bool]`

### `_create_message`

- **Parameters**
  - `EmailMessage`
- **Returns**
  - `EmailMessage` (standard) or `MIMEMultipart`

---

## Error Handling

### Authentication Errors

- `SMTPAuthenticationError`
  - Logged as authentication failure
  - `send()` returns `False`
  - `send_bulk()` marks all remaining messages as failed

### SMTP Errors

- `SMTPException`
  - Logged per message
  - Message marked as failed
  - Does not stop other messages from sending (in bulk)

### Unexpected Errors

- Caught and logged
- Converted to `False` return values
- Exceptions are not propagated upward

---

## Usage Examples (only where helpful)

### Instantiate provider

```python
from backend.app.services.email.gmail import GmailProvider
from backend.app.services.email.base import EmailMessage

provider = GmailProvider(
    user="example@gmail.com",
    app_password="your-16-char-app-password",
)