# Created with the Assistance of Claude Code
"""
Centralized enums and constants for the HealthBank application.

All role IDs, statuses, and response types should be referenced from here
instead of using hardcoded strings/ints throughout the codebase.
"""
from enum import IntEnum, Enum


class RoleID(IntEnum):
    """Database RoleID values matching the Roles table."""
    PARTICIPANT = 1
    RESEARCHER = 2
    HCP = 3
    ADMIN = 4


class PublicationStatus(str, Enum):
    DRAFT = "draft"
    PUBLISHED = "published"
    CLOSED = "closed"


class SurveyStatus(str, Enum):
    IN_PROGRESS = "in-progress"
    COMPLETE = "complete"
    NOT_STARTED = "not-started"
    CANCELLED = "cancelled"


class AssignmentStatus(str, Enum):
    PENDING = "pending"
    COMPLETED = "completed"
    EXPIRED = "expired"


class ResponseType(str, Enum):
    NUMBER = "number"
    YESNO = "yesno"
    OPENENDED = "openended"
    SINGLE_CHOICE = "single_choice"
    MULTI_CHOICE = "multi_choice"
    SCALE = "scale"


class HcpLinkStatus(str, Enum):
    PENDING = "pending"
    ACTIVE = "active"
    REJECTED = "rejected"
    REMOVED = "removed"


class AccountRequestStatus(str, Enum):
    PENDING = "pending"
    APPROVED = "approved"
    REJECTED = "rejected"
