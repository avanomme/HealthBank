# Email Service

Backend service for sending emails via SMTP (Gmail).

## Overview

The email service provides a simple interface for sending HTML emails through Gmail's SMTP server. It supports:

- HTML and plain text content
- Async and sync send methods
- Configurable via environment variables
- Proper error handling with detailed results

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `SMTP_HOST` | SMTP server hostname | `smtp.gmail.com` |
| `SMTP_PORT` | SMTP server port | `587` |
| `SMTP_USER` | SMTP username (email address) | None |
| `SMTP_PASSWORD` | SMTP password or app password | None |
| `SMTP_FROM_NAME` | Display name for sent emails | `HealthBank` |
| `SMTP_TIMEOUT` | Connection timeout in seconds | `30` |

### Gmail App Password Setup

For Gmail, you need to use an App Password (not your regular password):

1. Go to [Google Account Security](https://myaccount.google.com/security)
2. Enable 2-Step Verification if not already enabled
3. Go to "App passwords" (under 2-Step Verification)
4. Select "Mail" and your device
5. Click "Generate"
6. Use the generated 16-character password as `SMTP_PASSWORD`

### Example Environment File

```env
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=healthbank.notifications@gmail.com
SMTP_PASSWORD=xxxx xxxx xxxx xxxx
SMTP_FROM_NAME=HealthBank
SMTP_TIMEOUT=30
```

## Usage

### Async Usage (Recommended)

```python
from app.services import get_email_service

email_service = get_email_service()

result = await email_service.send_email(
    to_email="user@example.com",
    subject="Password Reset",
    html_content="<h1>Hello!</h1><p>Your password has been reset.</p>"
)

if result.success:
    print(f"Email sent to {result.recipient}")
else:
    print(f"Failed: {result.message}")
```

### Sync Usage

```python
from app.services import get_email_service

email_service = get_email_service()

result = email_service.send_email_sync(
    to_email="user@example.com",
    subject="Password Reset",
    html_content="<h1>Hello!</h1>"
)
```

### With Custom Plain Text

```python
result = await email_service.send_email(
    to_email="user@example.com",
    subject="Password Reset",
    html_content="<h1>Hello!</h1><p>Your new password is below.</p>",
    plain_content="Hello! Your new password is below."
)
```

## API Reference

### EmailService

#### `send_email(to_email, subject, html_content, plain_content=None) -> EmailResult`

Send an email asynchronously.

**Parameters:**
- `to_email` (str): Recipient email address
- `subject` (str): Email subject line
- `html_content` (str): HTML content of the email
- `plain_content` (str, optional): Plain text fallback (auto-generated if not provided)

**Returns:** `EmailResult`

#### `send_email_sync(...)`

Same as `send_email` but synchronous (blocking).

### EmailResult

```python
@dataclass
class EmailResult:
    success: bool      # Whether email was sent
    message: str       # Status message or error description
    recipient: str     # The recipient email address
```

## Error Handling

The service catches and handles various SMTP errors:

| Error | Result Message |
|-------|----------------|
| Not configured | "SMTP credentials not configured" |
| Auth failure | "SMTP authentication failed - check credentials" |
| Bad recipient | "Recipient address rejected: {email}" |
| Timeout | "Connection timeout - check SMTP server" |
| Other SMTP errors | "SMTP error: {details}" |

## Files

- `backend/app/services/email_service.py` - Main service class
- `backend/app/core/config.py` - SMTP configuration
