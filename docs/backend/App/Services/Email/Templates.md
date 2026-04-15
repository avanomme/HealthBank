# `markdown/email_templates.md` — Email Templates (`backend/app/services/email/templates.py`)

## Overview

`backend/app/services/email/templates.py` defines all HTML and plain-text templates used by the HealthBank email system.

Each template function returns a tuple:

(subject, body_text, body_html)

These templates are consumed by `EmailService` and rendered through a provider (e.g., `GmailProvider`).

The module includes:

- A shared HTML wrapper (`_base_html`)
- Account creation template
- Password reset request template
- Password changed confirmation template
- Two-factor authentication setup template

---

## Architecture / Design Explanation

### Dual-Format Emails

Each template returns:

- `subject: str`
- `body_text: str` (plain-text version)
- `body_html: str` (styled HTML version)

This ensures compatibility with:

- Modern email clients (HTML rendering)
- Text-only clients and spam filters (plain text fallback)

### Base HTML Wrapper

All HTML templates are wrapped using `_base_html(content: str)`.

The base wrapper provides:

- Header with “HealthBank” branding
- Styled content container
- Call-to-action button styling
- Code block styling (for temporary passwords)
- Warning block styling
- Footer with:
  - Automated message disclaimer
  - Project attribution

This guarantees consistent branding and layout across all email types.

### Styling Approach

Inline `<style>` definitions include:

- System font stack
- Responsive meta tag
- Styled button
- Highlighted code block
- Warning boxes
- Footer styling

No external CSS is used to maximize compatibility with email clients.

---

## Configuration (if applicable)

This module has no environment dependencies.

However, calling code typically supplies:

- `login_url`
- `reset_url`
- `setup_url`
- `expiry_minutes`

These values originate from:

- `backend/app/services/email/config.py`

---

## API Reference

### `_base_html(content: str) -> str`

Internal helper that wraps the provided content in the standard HTML email layout.

**Parameters**
- `content: str` (HTML fragment)

**Returns**
- `str` full HTML email document

---

## Templates

Each template returns:

Tuple[str, str, str]  
→ (subject, body_text, body_html)

---

### `account_created(...)`

**Purpose**

Sent when an administrator creates a new account.

Includes:

- Email address
- Temporary password
- Login button
- Security instructions

**Parameters**

- `user_name: str`
- `user_email: str`
- `temporary_password: str`
- `login_url: str`

**Subject**
