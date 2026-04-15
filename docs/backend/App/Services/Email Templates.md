# `markdown/email.md` — Email Delivery + Templates

HealthBank currently has **three overlapping email/template implementations**. This doc maps what exists, what’s used, and what to consolidate.

---

## 1) Async SMTP Sender (used by admin endpoints)

### Files
- `backend/app/services/email_service.py`
- `backend/app/core/config.py`

### What it does
- Sends multipart email (plain + html) via SMTP + STARTTLS.
- Async wrapper uses `run_in_executor()` to avoid blocking the event loop.
- Returns `EmailResult(success, message, recipient)`.

### Env vars (from `core/config.py`)
- `SMTP_HOST` (default `smtp.gmail.com`)
- `SMTP_PORT` (default `587`)
- `SMTP_USER`
- `SMTP_PASSWORD`
- `SMTP_FROM_NAME` (default `HealthBank`)
- `SMTP_TIMEOUT` (default `30`)

### Where it’s used (in your snippets)
- `backend/app/api/v1/admin.py` calls:
  - `email_service = get_email_service()`
  - `await email_service.send_email(...)`
  - and passes HTML/plain from template helpers

---

## 2) Standalone Template Functions (HTML + Plain) (used by admin)

### File
- `backend/app/services/email_templates.py`

### Templates included
- `password_reset_email(user_name, temporary_password) -> str` (HTML)
- `password_reset_plain(user_name, temporary_password) -> str` (plain)
- `forgot_password_email(user_name, reset_link) -> str` (HTML)
- `forgot_password_plain(user_name, reset_link) -> str` (plain)

### Notes
- These are **simple function templates** (no provider abstraction), designed to be fed into the SMTP sender above.
- Your `admin.py` already imports `password_reset_email` / `password_reset_plain` (matches this style).

---

## 3) Provider-based Email Module (duplicate stack)

### Files
- `backend/app/services/email/base.py`
- `backend/app/services/email/gmail.py`
- `backend/app/services/email/service.py`
- `backend/app/services/email/config.py`
- `backend/app/services/email/templates.py`

### What it does
- A provider interface + Gmail provider + an EmailService wrapper with templates.
- Uses a *different* env var set:
  - `GMAIL_USER`
  - `GMAIL_APP_PASSWORD`
  - plus `APP_BASE_URL` for URL building in templates

### Status
- Functionally overlaps with:
  - `backend/app/services/email_service.py` (sending)
  - `backend/app/services/email_templates.py` (templates)

---

## Recommended consolidation (pick one, delete the rest)

### Recommended path (least churn given your current usage)
**Keep:**
- `backend/app/services/email_service.py` (SMTP sender)
- `backend/app/core/config.py` (SMTP_* env vars)
- `backend/app/services/email_templates.py` (your HTML/plain templates)

**Remove / archive:**
- `backend/app/services/email/` provider module

This matches how `admin.py` is already written: *generate templates → send via SMTP service*.

### Alternative path (more extensible, more refactor)
Standardize on `backend/app/services/email/` and migrate `admin.py` + any template usage to it, then remove `email_service.py` + `email_templates.py`.

---

## Quick gotchas / improvements

- Your `forgot_password_email()` currently renders the reset link inside a monospace “box”. For UX, consider making it a clickable button (`<a href="...">Reset Password</a>`) and include the raw link below as fallback.
- Ensure you never email secrets that should be one-time tokens unless they have an expiry and are hashed server-side where applicable.
- If you’re behind a proxy, be sure outbound SMTP is allowed from the deployment environment.

---