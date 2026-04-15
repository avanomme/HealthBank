# Email Service

High-level email service for HealthBank.

**File:** `backend/app/services/email/service.py`

---

## Overview

This module provides a high-level abstraction for sending transactional emails within the HealthBank application.

It:

- Wraps the underlying email provider implementation
- Uses predefined email templates
- Centralizes common email workflows
- Lazily initializes the configured provider
- Logs success and failure outcomes

Application code should use this service instead of interacting directly with the provider layer.

---

## Architecture

The `EmailService` acts as a façade over:

- `EmailProvider` (interface)
- `GmailProvider` (concrete implementation)
- Email templates
- Environment-based configuration

### Provider Initialization

The provider is:

- Lazily instantiated on first use
- Validated using `validate_email_config()`
- Cached for reuse

To switch providers (e.g., SendGrid, SES), modify the `_get_provider()` method to construct a different `EmailProvider` implementation.

---

## Public API

### `send_account_created_email(...) -> bool`

Send an account creation email containing a temporary password.

**Parameters:**

- `user_name` (`str`) — Name of the new user  
- `user_email` (`str`) — Recipient email address  
- `temporary_password` (`str`) — Temporary login password  
- `login_url` (`Optional[str]`) — Optional override for login URL  

**Behavior:**

- Uses `templates.account_created`
- Defaults to `config.LOGIN_URL` if no custom URL is provided
- Logs success or failure
- Returns `True` if email sent successfully

---

### `send_password_reset_email(...) -> bool`

Send a password reset email containing a secure reset link.

**Important:** Should only be called after the user has verified 2FA.

**Parameters:**

- `user_name` (`str`) — Name of the user  
- `user_email` (`str`) — Recipient email address  
- `reset_token` (`str`) — Secure password reset token  
- `base_url` (`Optional[str]`) — Optional override for reset URL  

**Behavior:**

- Constructs reset URL as:

  ```
  {base_url}?token={reset_token}
  ```

- Defaults to `config.PASSWORD_RESET_URL`
- Uses `templates.password_reset_request`
- Includes token expiry information from `config.PASSWORD_RESET_EXPIRY_MINUTES`
- Returns `True` if email sent successfully

---

### `send_password_changed_email(...) -> bool`

Send a confirmation email after a password change.

**Parameters:**

- `user_name` (`str`) — Name of the user  
- `user_email` (`str`) — Recipient email address  

**Behavior:**

- Uses `templates.password_changed`
- Confirms successful password update
- Logs success or failure
- Returns `True` if email sent successfully

---

### `send_2fa_setup_email(...) -> bool`

Send a reminder email to complete two-factor authentication setup.

**Parameters:**

- `user_name` (`str`) — Name of the user  
- `user_email` (`str`) — Recipient email address  
- `setup_url` (`Optional[str]`) — Optional override for setup URL  

**Behavior:**

- Defaults to `config.TWO_FACTOR_SETUP_URL`
- Uses `templates.two_factor_setup`
- Logs success or failure
- Returns `True` if email sent successfully

---

## Internal Methods

### `_get_provider() -> EmailProvider`

- Validates required environment variables
- Constructs a `GmailProvider`
- Caches the instance for reuse

This is the only place where the concrete provider is selected.

---

### `_send(to, subject, body_text, body_html=None) -> bool`

Internal helper that:

1. Creates an `EmailMessage`
2. Delegates sending to the configured provider

Ensures consistent message construction across all workflows.

---

## Usage Example

```python
from app.services.email import email_service

# Account creation
email_service.send_account_created_email(
    user_name="John Doe",
    user_email="john@example.com",
    temporary_password="TempPass123!"
)

# Password reset
email_service.send_password_reset_email(
    user_name="John Doe",
    user_email="john@example.com",
    reset_token="abc123..."
)
```

---

## Logging

The service uses Python's `logging` module:

- `logger.info` for successful sends
- `logger.error` for failures

Ensure logging is properly configured in your application to capture these events.

---

## Configuration Dependencies

This service depends on:

- `config.GMAIL_USER`
- `config.GMAIL_APP_PASSWORD`
- `config.LOGIN_URL`
- `config.PASSWORD_RESET_URL`
- `config.TWO_FACTOR_SETUP_URL`
- `config.PASSWORD_RESET_EXPIRY_MINUTES`

`validate_email_config()` is called automatically before provider initialization.

---

## Singleton Instance

The module exposes a singleton instance:

```python
email_service = EmailService()
```

This allows simple imports across the application without repeated instantiation.

---

## Related Files

- `backend/app/services/email/base.py` — Email provider interface  
- `backend/app/services/email/gmail.py` — Gmail provider implementation  
- `backend/app/services/email/config.py` — Email configuration and validation  
- `backend/app/services/email/templates.py` — Email content templates  