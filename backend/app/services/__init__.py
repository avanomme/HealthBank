# Created with the Assistance of Claude Code
from .email.service import EmailService, email_service

def get_email_service() -> EmailService:
    return email_service

__all__ = [
    "EmailService",
    "email_service",
    "get_email_service",
]
