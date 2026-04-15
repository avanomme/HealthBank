# Created with the assistance of Claude Code
# backend/app/services/email/__init__.py
"""
HealthBank Email Service

A standardized email service with support for multiple providers.

Quick Start:
    from app.services.email import email_service

    # Send account creation email
    email_service.send_account_created_email(
        user_name="John Doe",
        user_email="john@example.com",
        temporary_password="TempPass123!"
    )

    # Send password reset email (after 2FA verification)
    email_service.send_password_reset_email(
        user_name="John Doe",
        user_email="john@example.com",
        reset_token="secure_token_here"
    )

Switching Providers:
    To switch from Gmail to another service (SendGrid, Mailgun, AWS SES, etc.):
    1. Create a new provider class in this package that implements EmailProvider
    2. Update EmailService._get_provider() in service.py to use the new provider
    3. Add any new config values to config.py

Architecture:
    base.py      - Abstract EmailProvider interface
    gmail.py     - Gmail SMTP implementation
    templates.py - Email content templates
    config.py    - Configuration and credentials
    service.py   - High-level EmailService class
"""

from .base import EmailMessage, EmailProvider
from .gmail import GmailProvider
from .service import EmailService, email_service
from . import templates
from . import config

__all__ = [
    # Main service (use this!)
    "email_service",
    "EmailService",

    # Base classes (for extending)
    "EmailMessage",
    "EmailProvider",

    # Providers
    "GmailProvider",

    # Modules
    "templates",
    "config",
]
