# `markdown/email_base.md` — Email Provider Abstraction (`backend/app/services/email/base.py`)

## Overview

`backend/app/services/email/base.py` defines the abstraction layer for sending emails within the application.

It provides:

- A standardized `EmailMessage` dataclass
- An abstract `EmailProvider` base class that defines the interface all email services must implement

This design allows the application to switch between email providers (e.g., SMTP, SendGrid, Mailgun, AWS SES) without changing higher-level business logic.

---

## Architecture / Design Explanation

### Abstraction Layer

The `EmailProvider` abstract base class (ABC):

- Defines the required interface for any email service implementation.
- Enforces consistency across providers.
- Allows dependency injection of different email backends.

All concrete providers must implement:

- `send(message: EmailMessage) -> bool`
- `send_bulk(messages: list[EmailMessage]) -> dict[str, bool]`

### Standardized Message Structure

The `EmailMessage` dataclass:

- Normalizes how email payloads are passed to providers.
- Supports both text-only and multipart (text + HTML) emails.
- Separates provider-specific logic from message formatting.

### Provider Swapping Strategy

To change providers:

1. Create a new class that inherits from `EmailProvider`.
2. Implement `send()` and `send_bulk()`.
3. Configure application startup (e.g., `email_config.py` or service factory) to use the new provider.

No changes are required in calling code as long as it depends only on the `EmailProvider` interface.

---

## Configuration (if applicable)

This module does not directly read environment variables.

Provider implementations typically rely on:

- SMTP configuration (`backend/app/core/config.py`)
- API keys (e.g., `SENDGRID_API_KEY`)
- Cloud service credentials

The abstraction ensures those details remain isolated within provider implementations.

---

## API Reference

### `EmailMessage`

Dataclass representing a standardized email message.

#### Fields

- `to: str`
  - Recipient email address.
- `subject: str`
  - Email subject line.
- `body_text: str`
  - Plain text version of the email body.
- `body_html: Optional[str]`
  - Optional HTML version of the email body.
- `from_name: str` (default `"HealthBank"`)
  - Display name used in the "From" header.

---

### `EmailProvider` (Abstract Base Class)

Defines the required interface for all email providers.

#### `send(self, message: EmailMessage) -> bool`

Send a single email message.

**Parameters**
- `message: EmailMessage`

**Returns**
- `True` if email was sent successfully
- `False` otherwise

**Implementation Responsibility**
- Format email according to provider requirements
- Handle provider-specific authentication
- Catch provider exceptions and return boolean status

---

#### `send_bulk(self, messages: list[EmailMessage]) -> dict[str, bool]`

Send multiple email messages.

**Parameters**
- `messages: list[EmailMessage]`

**Returns**
- `dict[str, bool]`
  - Keys: recipient email addresses
  - Values: success status (`True` or `False`)

**Implementation Responsibility**
- May send emails sequentially or using provider batch APIs
- Should isolate failures per recipient where possible
- Must return status per recipient

---

## Parameters and Return Types

### `EmailMessage`

- `to: str`
- `subject: str`
- `body_text: str`
- `body_html: Optional[str]`
- `from_name: str`

### `EmailProvider.send`

- **Parameters**
  - `message: EmailMessage`
- **Returns**
  - `bool`

### `EmailProvider.send_bulk`

- **Parameters**
  - `messages: list[EmailMessage]`
- **Returns**
  - `dict[str, bool]`

---

## Error Handling

### Interface-Level Expectations

The abstract base class does not implement error handling directly.

Concrete implementations should:

- Catch provider-specific exceptions
- Return `False` for failed sends (single email)
- Return per-recipient success/failure in bulk sends
- Avoid raising unhandled exceptions unless explicitly required

### Failure Semantics

- `send()` should return `False` if the provider rejects the message or an error occurs.
- `send_bulk()` should continue sending remaining emails even if one fails, when feasible.

---

## Usage Examples (only where helpful)

### Example Provider Skeleton

```python
from backend.app.services.email.base import EmailProvider, EmailMessage

class SMTPEmailProvider(EmailProvider):
    def send(self, message: EmailMessage) -> bool:
        try:
            # SMTP send logic here
            return True
        except Exception:
            return False

    def send_bulk(self, messages: list[EmailMessage]) -> dict[str, bool]:
        results = {}
        for msg in messages:
            results[msg.to] = self.send(msg)
        return results