# `markdown/email_config.md` — Email Configuration (`backend/app/services/email/config.py`)

## Overview

`backend/app/services/email/config.py` centralizes environment-driven configuration for:

- Gmail-based email credentials
- Application frontend URLs used in email templates
- Password reset expiry settings
- Basic startup validation for required email environment variables

This module is intended to support email provider implementations and authentication-related email flows (e.g., password reset, login links, 2FA setup).

---

## Architecture / Design Explanation

### Separation of Concerns

This module:

- Loads environment variables at import time
- Exposes derived constants (e.g., URLs)
- Provides a simple validation function

It does not:

- Send email
- Perform SMTP operations
- Define provider interfaces

Those responsibilities are handled elsewhere (e.g., provider implementations under `services/email/`).

### Environment-Driven Configuration

Email credentials and application URLs are loaded via `os.getenv`.

Derived constants such as `LOGIN_URL` are constructed from `APP_BASE_URL`.

### Fail-Fast Validation

The `validate_email_config()` function:

- Checks required credentials
- Raises `RuntimeError` if missing
- Intended to be called during application startup

This ensures misconfiguration is detected early rather than at send time.

---

## Configuration

### Environment Variables

#### Required (for Gmail provider)

| Variable              | Description |
|-----------------------|-------------|
| `GMAIL_USER`          | Gmail email address used for sending |
| `GMAIL_APP_PASSWORD`  | Gmail app-specific password |

These are required if using a Gmail SMTP provider.

---

#### Optional

| Variable        | Default                  | Description |
|----------------|--------------------------|-------------|
| `APP_BASE_URL` | `http://localhost:3000`  | Base URL of the frontend application |

---

### Derived URLs

These URLs are built from `APP_BASE_URL`:

- `LOGIN_URL`
  - `{APP_BASE_URL}/login`
- `PASSWORD_RESET_URL`
  - `{APP_BASE_URL}/reset-password`
- `TWO_FACTOR_SETUP_URL`
  - `{APP_BASE_URL}/setup-2fa`

These constants are typically embedded in email templates.

---

### Other Settings

#### `PASSWORD_RESET_EXPIRY_MINUTES`

- Default: `60`
- Defines the expiration window for password reset tokens.
- Intended to be used by password reset logic in authentication services.

---

## API Reference

### Constants

- `GMAIL_USER: str | None`
- `GMAIL_APP_PASSWORD: str | None`
- `APP_BASE_URL: str`
- `LOGIN_URL: str`
- `PASSWORD_RESET_URL: str`
- `TWO_FACTOR_SETUP_URL: str`
- `PASSWORD_RESET_EXPIRY_MINUTES: int`

---

### `validate_email_config() -> None`

Validates required email configuration variables.

**Behavior**

- Checks:
  - `GMAIL_USER`
  - `GMAIL_APP_PASSWORD`
- If any are missing or falsy:
  - Raises `RuntimeError`
  - Error message lists missing variable names

**Returns**
- `None` (no return value on success)

**Raises**
- `RuntimeError` if required variables are missing

---

## Parameters and Return Types

### `validate_email_config`

- **Parameters**
  - None
- **Returns**
  - `None`
- **Raises**
  - `RuntimeError`

---

## Error Handling

### Validation Errors

If required environment variables are not set:

```text
RuntimeError: Missing required email environment variables: GMAIL_USER, GMAIL_APP_PASSWORD