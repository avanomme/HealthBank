# Email Provider Base Interface

Abstract base definitions for pluggable email providers.

**File:** `backend/app/services/email/base.py`

---

## Overview

This module defines the foundational interface for implementing email delivery providers within the application. It provides:

- A standardized `EmailMessage` data structure
- An abstract `EmailProvider` interface
- Support for single and bulk email sending
- A provider-agnostic architecture for switching services

By implementing this interface, the system can integrate with different email services (e.g., SendGrid, Mailgun, AWS SES, SMTP) without modifying higher-level application logic.

---

## Source Code

```python
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
```

---

## Architecture

The email system is designed around abstraction and provider interchangeability.

To switch email services:

1. Create a new class that inherits from `EmailProvider`
2. Implement the required `send()` and `send_bulk()` methods
3. Update `email_config.py` to use the new provider implementation

This design ensures:

- No coupling between business logic and provider implementation
- Easy migration between email vendors
- Consistent behavior across all email services
- Clean separation of responsibilities

---

## Data Structures

### EmailMessage

Standardized email message structure used by all providers.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `to` | `str` | Yes | Recipient email address |
| `subject` | `str` | Yes | Email subject line |
| `body_text` | `str` | Yes | Plain text email content |
| `body_html` | `Optional[str]` | No | HTML version of the email |
| `from_name` | `str` | No | Display name of sender (default: `HealthBank`) |

This structure guarantees a consistent message format across all providers.

---

## API Reference

### EmailProvider

Abstract base class that defines the required contract for all email providers.

---

### `send(message: EmailMessage) -> bool`

Send a single email message.

**Parameters:**

- `message` (`EmailMessage`) — Structured email message containing recipient, subject, and content.

**Returns:**

- `bool` — `True` if the email was successfully sent, `False` otherwise.

---

### `send_bulk(messages: list[EmailMessage]) -> dict[str, bool]`

Send multiple email messages in a single operation.

**Parameters:**

- `messages` (`list[EmailMessage]`) — List of structured email messages.

**Returns:**

- `dict[str, bool]` — Mapping of recipient email address to success status.

Example return value:

```python
{
    "user1@example.com": True,
    "user2@example.com": False
}
```

---

## Extension Strategy

To integrate a new email provider:

1. Implement a subclass of `EmailProvider`
2. Add any required provider configuration (API keys, credentials, endpoints)
3. Wire the provider into `email_config.py`
4. Ensure both `send()` and `send_bulk()` are fully implemented

This abstraction layer allows the application to switch providers without modifying business logic or higher-level services.