# `markdown/email_service.md` — High-Level Email Service (`backend/app/services/email/service.py`)

## Overview

`backend/app/services/email/service.py` defines a high-level `EmailService` that sends common application emails using:

- A provider abstraction (`EmailProvider`)
- Provider implementation (currently `GmailProvider`)
- Prebuilt templates (`backend/app/services/email/templates.py` or package)

It centralizes email composition and sending for flows such as:

- Account creation (temporary password)
- Password reset (tokenized link)
- Password change confirmation
- 2FA setup reminders

A singleton instance `email_service` is exported for convenient imports.

---

## Architecture / Design Explanation

### Layered Email Design

This module sits above lower-level provider logic:

- **Templates layer** (`templates`)
  - Produces `(subject, body_text, body_html)` for different email types.
- **Service layer** (`EmailService`)
  - Chooses provider, builds `EmailMessage`, invokes provider send.
  - Adds logging and config-based defaults.
- **Provider layer** (`EmailProvider` / `GmailProvider`)
  - Implements the mechanics of email delivery (SMTP/API).

This structure isolates:

- Template content from delivery concerns
- Delivery concerns from application/business logic

### Provider Initialization and Caching

`EmailService` lazily creates and caches a single provider instance:

- `self._provider: Optional[EmailProvider]`
- `_get_provider()` constructs the provider once and reuses it

Before constructing the provider, it validates required environment variables via:

- `validate_email_config()`

### Provider Selection

Currently, `_get_provider()` constructs:

- `GmailProvider(user=config.GMAIL_USER, app_password=config.GMAIL_APP_PASSWORD)`

To switch providers, the intended change point is `_get_provider()`.

### Message Creation

`_send(...)` constructs a standard `EmailMessage`:

- `to`
- `subject`
- `body_text`
- optional `body_html`

Then calls provider `.send(...)` and returns its boolean result.

### URL Construction

URLs default to config constants unless overridden by method parameters:

- Account creation uses `LOGIN_URL`
- Password reset uses `PASSWORD_RESET_URL` and appends `?token=...`
- 2FA setup uses `TWO_FACTOR_SETUP_URL`

---

## Configuration (if applicable)

This module depends on:

- `backend/app/services/email/config.py`
  - `GMAIL_USER`, `GMAIL_APP_PASSWORD`
  - `LOGIN_URL`, `PASSWORD_RESET_URL`, `TWO_FACTOR_SETUP_URL`
  - `PASSWORD_RESET_EXPIRY_MINUTES`
  - `validate_email_config()`

The email provider will fail to initialize if required Gmail credentials are missing.

---

## API Reference

### Class: `EmailService`

High-level interface for sending application emails.

#### `__init__(self)`

Initializes the service with no provider instantiated.

- `_provider` is set to `None` initially.

---

### `_get_provider(self) -> EmailProvider`

Returns a cached provider instance or constructs it on first use.

**Behavior**
- Calls `validate_email_config()` before constructing provider
- Instantiates `GmailProvider` using Gmail credentials from config
- Caches the instance

**Returns**
- `EmailProvider`

**Raises**
- `RuntimeError` if validation fails (missing required env vars)

---

### `_send(self, to: str, subject: str, body_text: str, body_html: str | None = None) -> bool`

Internal helper for sending a single email.

**Parameters**
- `to: str`
- `subject: str`
- `body_text: str`
- `body_html: Optional[str]`

**Returns**
- `bool` (provider send status)

---

### `send_account_created_email(...) -> bool`

Sends an account creation email including a temporary password.

**Parameters**
- `user_name: str`
- `user_email: str`
- `temporary_password: str`
- `login_url: Optional[str]` (defaults to `config.LOGIN_URL`)

**Template**
- `templates.account_created(...)`

**Returns**
- `bool`

---

### `send_password_reset_email(...) -> bool`

Sends a password reset email containing a tokenized reset link.

This method is intended to be used after 2FA verification.

**Parameters**
- `user_name: str`
- `user_email: str`
- `reset_token: str`
- `base_url: Optional[str]` (defaults to `config.PASSWORD_RESET_URL`)

**Behavior**
- Constructs `reset_url = f"{base}?token={reset_token}"`

**Template**
- `templates.password_reset_request(...)`
  - Receives `expiry_minutes=config.PASSWORD_RESET_EXPIRY_MINUTES`

**Returns**
- `bool`

---

### `send_password_changed_email(...) -> bool`

Sends a password change confirmation email.

**Parameters**
- `user_name: str`
- `user_email: str`

**Template**
- `templates.password_changed(...)`

**Returns**
- `bool`

---

### `send_2fa_setup_email(...) -> bool`

Sends a 2FA setup reminder email.

**Parameters**
- `user_name: str`
- `user_email: str`
- `setup_url: Optional[str]` (defaults to `config.TWO_FACTOR_SETUP_URL`)

**Template**
- `templates.two_factor_setup(...)`

**Returns**
- `bool`

---

### Singleton: `email_service`

A module-level singleton instance:

- `email_service = EmailService()`

Intended for import and reuse across the application.

---

## Parameters and Return Types

### `EmailService.send_account_created_email`

- **Returns**: `bool`

### `EmailService.send_password_reset_email`

- **Returns**: `bool`

### `EmailService.send_password_changed_email`

- **Returns**: `bool`

### `EmailService.send_2fa_setup_email`

- **Returns**: `bool`

---

## Error Handling

### Provider Initialization

- `_get_provider()` calls `validate_email_config()`.
- If required env vars are missing, `validate_email_config()` raises `RuntimeError`.
- This exception is not caught in `EmailService` and will propagate to callers.

### Send Failures

Provider `.send(...)` returns `True/False` and typically logs errors internally.

This service:

- Logs `info` on success
- Logs `error` on failure
- Returns the provider boolean result

No exceptions are intentionally raised for send failures (beyond provider initialization).

---

## Usage Examples (only where helpful)

### Send an account creation email

```python
from backend.app.services.email.service import email_service

email_service.send_account_created_email(
    user_name="John Doe",
    user_email="john@example.com",
    temporary_password="TempPass123!",
)