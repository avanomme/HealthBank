# Created with the Assistance of Claude Code
# backend/app/core/config.py
"""
Application configuration loaded from environment variables.

Environment variables:
- SMTP_HOST: SMTP server hostname (default: smtp.gmail.com)
- SMTP_PORT: SMTP server port (default: 587)
- SMTP_USER: SMTP username/email for authentication
- SMTP_PASSWORD: SMTP password or app password
- SMTP_FROM_NAME: Display name for sent emails (default: HealthBank)
- SMTP_TIMEOUT: Connection timeout in seconds (default: 30)
"""

import os
from dataclasses import dataclass
from typing import Optional


@dataclass
class SMTPConfig:
    """SMTP configuration for email service."""
    host: str
    port: int
    user: Optional[str]
    password: Optional[str]
    from_name: str
    timeout: int

    @property
    def is_configured(self) -> bool:
        """Check if SMTP credentials are configured."""
        return bool(self.user and self.password)

    @property
    def from_address(self) -> str:
        """Get the from address for emails."""
        if self.user:
            return f"{self.from_name} <{self.user}>"
        return self.from_name


def get_smtp_config() -> SMTPConfig:
    """Load SMTP configuration from environment variables."""
    return SMTPConfig(
        host=os.getenv("SMTP_HOST", "smtp.gmail.com"),
        port=int(os.getenv("SMTP_PORT", "587")),
        user=os.getenv("SMTP_USER"),
        password=os.getenv("SMTP_PASSWORD"),
        from_name=os.getenv("SMTP_FROM_NAME", "HealthBank"),
        timeout=int(os.getenv("SMTP_TIMEOUT", "30")),
    )


# ── Application-wide constants ──────────────────────────────────────────────

# K-anonymity threshold: suppress aggregate data when fewer than K respondents
K_ANONYMITY_THRESHOLD = 1

# Maximum active sessions per user before oldest are revoked
MAX_ACTIVE_SESSIONS = int(os.getenv("MAX_ACTIVE_SESSIONS", "5"))

# MFA challenge settings
MFA_CHALLENGE_TTL_MINUTES = int(os.getenv("MFA_CHALLENGE_TTL_MINUTES", "10"))
MFA_MAX_ATTEMPTS = int(os.getenv("MFA_MAX_ATTEMPTS", "5"))

# Consent version (compared against user's stored version)
CURRENT_CONSENT_VERSION = os.getenv("CURRENT_CONSENT_VERSION", "1.0")

# TOS version
CURRENT_TOS_VERSION = os.getenv("CURRENT_TOS_VERSION", "2026-01-31")

# Pagination defaults
DEFAULT_PAGE_LIMIT = 500
MAX_PAGE_LIMIT = 1000

# Temporary password length for admin-created accounts
TEMP_PASSWORD_LENGTH = 16
