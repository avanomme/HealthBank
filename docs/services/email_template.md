# Legacy Email Templates

Inline HTML and plain-text email template helpers for HealthBank.

**File:** `backend/app/services/email_templates.py`

---

## Overview

This module provides email templates as Python functions that return rendered strings. It avoids external template files by embedding HTML and plain-text content directly in code.

It includes templates for:

- Administrator-initiated password reset (temporary password)
- User-initiated "forgot password" reset (reset link)
- Plain-text equivalents for both email types

These templates return **fully rendered content strings** and do not include subject lines; subject handling is expected to occur in the calling service.

---

## Template Types

### Administrator Password Reset (Temporary Password)

Used when a system administrator resets a user's password and provides a new temporary password.

- HTML: `password_reset_email(user_name, temporary_password) -> str`
- Plain text: `password_reset_plain(user_name, temporary_password) -> str`

#### Content Features

- Personalized greeting using `user_name`
- Prominent display of the temporary password
- "Next Steps" instructions to change password after login
- Security notice if the user did not request the reset
- Standard automated footer

---

### Forgot Password (Reset Link)

Used when a user requests a password reset and receives a reset link.

- HTML: `forgot_password_email(user_name, reset_link) -> str`
- Plain text: `forgot_password_plain(user_name, reset_link) -> str`

#### Content Features

- Personalized greeting using `user_name`
- Prominent display of the reset link
- Security notice if the user did not request the reset
- Standard automated footer

---

## API Reference

### `password_reset_email(user_name: str, temporary_password: str) -> str`

Generate an HTML email body for an administrator-initiated password reset.

**Parameters:**

- `user_name` (`str`) — User's first name for personalization
- `temporary_password` (`str`) — Newly generated temporary password

**Returns:**

- `str` — Fully rendered HTML email body

---

### `password_reset_plain(user_name: str, temporary_password: str) -> str`

Generate a plain-text email body for an administrator-initiated password reset.

**Parameters:**

- `user_name` (`str`) — User's first name for personalization
- `temporary_password` (`str`) — Newly generated temporary password

**Returns:**

- `str` — Plain-text email body

---

### `forgot_password_email(user_name: str, reset_link: str) -> str`

Generate an HTML email body for a user-initiated password reset request.

**Parameters:**

- `user_name` (`str`) — User's first name for personalization
- `reset_link` (`str`) — Reset link to the frontend application

**Returns:**

- `str` — Fully rendered HTML email body

---

### `forgot_password_plain(user_name: str, reset_link: str) -> str`

Generate a plain-text email body for a user-initiated password reset request.

**Parameters:**

- `user_name` (`str`) — User's first name for personalization
- `reset_link` (`str`) — Reset link to the frontend application

**Returns:**

- `str` — Plain-text email body

---

## Usage Examples

### Administrator Password Reset

```python
from app.services.email_templates import password_reset_email, password_reset_plain

html = password_reset_email(user_name="Zak", temporary_password="TempPass123!")
text = password_reset_plain(user_name="Zak", temporary_password="TempPass123!")
```

---

### Forgot Password Reset

```python
from app.services.email_templates import forgot_password_email, forgot_password_plain

html = forgot_password_email(user_name="Zak", reset_link="https://app.example.com/reset-password?token=abc123")
text = forgot_password_plain(user_name="Zak", reset_link="https://app.example.com/reset-password?token=abc123")
```

---

## Design Notes

### Why Inline Templates

This module explicitly avoids external template dependencies by embedding templates directly in Python. This can simplify deployments where file-based templates are inconvenient or where packaging must remain minimal.

### HTML Structure

The HTML templates use:

- Table-based layout for broad email client compatibility
- Inline styles for consistent rendering
- Header/body/footer sections
- High-contrast callouts for passwords and reset links

---

## Security Considerations

- Temporary passwords should be randomly generated, strong, and short-lived.
- Reset links should contain secure, time-limited tokens.
- Avoid logging rendered templates, temporary passwords, or reset links.
- In production, reset links should always be HTTPS.

---

## Relationship to Newer Template System

This repository also contains a newer template module under:

- `backend/app/services/email/templates.py`

That newer system standardizes templates to return:

```
(subject, body_text, body_html)
```

This file appears to be an earlier or alternate approach where templates return only the rendered body content.

If both systems exist simultaneously, ensure callers consistently use the intended template API.

---

## Related Files

- `backend/app/services/email/templates.py` — Standard template system returning `(subject, body_text, body_html)`
- `backend/app/services/email/service.py` — High-level email service that uses provider + templates
- `backend/app/services/email/gmail.py` — Gmail SMTP provider