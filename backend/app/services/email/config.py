# backend/app/services/email/config.py

import os

# ------------------------------------------------------------
# EMAIL CREDENTIALS (loaded from environment)
# ------------------------------------------------------------
GMAIL_USER = os.getenv("GMAIL_USER") or os.getenv("SMTP_USER")
GMAIL_APP_PASSWORD = os.getenv("GMAIL_APP_PASSWORD") or os.getenv("SMTP_PASSWORD")

# ------------------------------------------------------------
# APPLICATION URLS
# ------------------------------------------------------------
# EMAIL_BASE_URL is the public-facing frontend URL embedded in all outgoing
# emails (account creation, password reset, etc.).  It must always point to
# the live server so recipients can click the link regardless of where the
# backend is running.  Set APP_BASE_URL separately for CORS / local dev.
EMAIL_BASE_URL = os.getenv("EMAIL_BASE_URL", "http://137.149.157.193:3000")

LOGIN_URL = f"{EMAIL_BASE_URL}/#/login"
PASSWORD_RESET_URL = f"{EMAIL_BASE_URL}/#/reset-password"
TWO_FACTOR_SETUP_URL = f"{EMAIL_BASE_URL}/#/setup-2fa"

# ------------------------------------------------------------
# EMAIL SETTINGS
# ------------------------------------------------------------
PASSWORD_RESET_EXPIRY_MINUTES = 60

# ------------------------------------------------------------
# VALIDATIONS
# ------------------------------------------------------------
def validate_email_config() -> None:
    missing = []
    if not GMAIL_USER:
        missing.append("GMAIL_USER (or SMTP_USER)")
    if not GMAIL_APP_PASSWORD:
        missing.append("GMAIL_APP_PASSWORD (or SMTP_PASSWORD)")

    if missing:
        raise RuntimeError(
            f"Missing required email environment variables: {', '.join(missing)}"
        )