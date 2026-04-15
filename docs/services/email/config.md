# Email Configuration

Environment-based configuration for email services and related application URLs.

**File:** `backend/app/services/email/config.py`

---

## Overview

This module centralizes configuration values used by the email system, including:

- Gmail SMTP credentials
- Frontend application URLs
- Email-related settings
- Startup validation for required environment variables

All sensitive values are loaded from environment variables to ensure credentials are not hardcoded.

---

## Source Code

```python
# backend/app/services/email/config.py

import os

# ------------------------------------------------------------
# EMAIL CREDENTIALS (loaded from environment)
# ------------------------------------------------------------
GMAIL_USER = os.getenv("GMAIL_USER")
GMAIL_APP_PASSWORD = os.getenv("GMAIL_APP_PASSWORD")

# ------------------------------------------------------------
# APPLICATION URLS
# ------------------------------------------------------------
APP_BASE_URL = os.getenv("APP_BASE_URL", "http://localhost:3000")

LOGIN_URL = f"{APP_BASE_URL}/login"
PASSWORD_RESET_URL = f"{APP_BASE_URL}/reset-password"
TWO_FACTOR_SETUP_URL = f"{APP_BASE_URL}/setup-2fa"

# ------------------------------------------------------------
# EMAIL SETTINGS
# ------------------------------------------------------------
PASSWORD_RESET_EXPIRY_MINUTES = 60

# ------------------------------------------------------------
# VALIDATIONS
# ------------------------------------------------------------
def validate_email_config() -> None:
    required = {
        "GMAIL_USER": GMAIL_USER,
        "GMAIL_APP_PASSWORD": GMAIL_APP_PASSWORD,
    }

    missing = [k for k, v in required.items() if not v]

    if missing:
        raise RuntimeError(
            f"Missing required email environment variables: {', '.join(missing)}"
        )
```

---

## Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `GMAIL_USER` | Gmail email address used for sending emails | Yes | None |
| `GMAIL_APP_PASSWORD` | Gmail App Password (not regular password) | Yes | None |
| `APP_BASE_URL` | Base URL of the frontend application | No | `http://localhost:3000` |

---

## Derived URLs

The following URLs are constructed dynamically using `APP_BASE_URL`:

| Constant | Value |
|----------|--------|
| `LOGIN_URL` | `{APP_BASE_URL}/login` |
| `PASSWORD_RESET_URL` | `{APP_BASE_URL}/reset-password` |
| `TWO_FACTOR_SETUP_URL` | `{APP_BASE_URL}/setup-2fa` |

These URLs are typically embedded in transactional emails such as:

- Password reset emails
- Login prompts
- Two-factor authentication setup messages

---

## Email Settings

| Setting | Value | Description |
|----------|--------|-------------|
| `PASSWORD_RESET_EXPIRY_MINUTES` | `60` | Time before password reset tokens expire |

This value can be used when generating reset tokens and crafting email messaging.

---

## Validation

### `validate_email_config() -> None`

Ensures required email credentials are present.

**Behavior:**

- Checks for missing required environment variables
- Raises `RuntimeError` if any are missing
- Lists all missing variables in the error message

Example failure message:

```
Missing required email environment variables: GMAIL_USER, GMAIL_APP_PASSWORD
```

This function should typically be called during application startup to fail fast if configuration is incomplete.

---

## Example Environment Configuration

```env
GMAIL_USER=healthbank.notifications@gmail.com
GMAIL_APP_PASSWORD=xxxx xxxx xxxx xxxx
APP_BASE_URL=https://app.healthbank.com
```

---

## Files

- `backend/app/services/email/config.py` — Email configuration and validation
- `backend/app/services/email/base.py` — Email provider interface