"""Tests for app.core.enums — verify all enum values and string representations."""

import pytest
from enum import IntEnum, Enum

from app.core.enums import (
    RoleID,
    PublicationStatus,
    SurveyStatus,
    AssignmentStatus,
    ResponseType,
    HcpLinkStatus,
    AccountRequestStatus,
)


# ── RoleID ──────────────────────────────────────────────────────────────────

class TestRoleID:
    def test_is_int_enum(self):
        assert issubclass(RoleID, IntEnum)

    def test_values(self):
        assert RoleID.PARTICIPANT == 1
        assert RoleID.RESEARCHER == 2
        assert RoleID.HCP == 3
        assert RoleID.ADMIN == 4

    def test_member_count(self):
        assert len(RoleID) == 4

    def test_int_comparison(self):
        assert RoleID.ADMIN > RoleID.PARTICIPANT
        assert int(RoleID.HCP) == 3


# ── PublicationStatus ───────────────────────────────────────────────────────

class TestPublicationStatus:
    def test_is_str_enum(self):
        assert issubclass(PublicationStatus, str)
        assert issubclass(PublicationStatus, Enum)

    def test_values(self):
        assert PublicationStatus.DRAFT == "draft"
        assert PublicationStatus.PUBLISHED == "published"
        assert PublicationStatus.CLOSED == "closed"

    def test_member_count(self):
        assert len(PublicationStatus) == 3

    def test_string_usage(self):
        assert PublicationStatus.DRAFT.value == "draft"
        assert f"{PublicationStatus.DRAFT.value}" == "draft"


# ── SurveyStatus ───────────────────────────────────────────────────────────

class TestSurveyStatus:
    def test_values(self):
        assert SurveyStatus.IN_PROGRESS == "in-progress"
        assert SurveyStatus.COMPLETE == "complete"
        assert SurveyStatus.NOT_STARTED == "not-started"
        assert SurveyStatus.CANCELLED == "cancelled"

    def test_member_count(self):
        assert len(SurveyStatus) == 4


# ── AssignmentStatus ────────────────────────────────────────────────────────

class TestAssignmentStatus:
    def test_values(self):
        assert AssignmentStatus.PENDING == "pending"
        assert AssignmentStatus.COMPLETED == "completed"
        assert AssignmentStatus.EXPIRED == "expired"

    def test_member_count(self):
        assert len(AssignmentStatus) == 3


# ── ResponseType ────────────────────────────────────────────────────────────

class TestResponseType:
    def test_values(self):
        assert ResponseType.NUMBER == "number"
        assert ResponseType.YESNO == "yesno"
        assert ResponseType.OPENENDED == "openended"
        assert ResponseType.SINGLE_CHOICE == "single_choice"
        assert ResponseType.MULTI_CHOICE == "multi_choice"
        assert ResponseType.SCALE == "scale"

    def test_member_count(self):
        assert len(ResponseType) == 6


# ── HcpLinkStatus ──────────────────────────────────────────────────────────

class TestHcpLinkStatus:
    def test_values(self):
        assert HcpLinkStatus.PENDING == "pending"
        assert HcpLinkStatus.ACTIVE == "active"
        assert HcpLinkStatus.REJECTED == "rejected"
        assert HcpLinkStatus.REMOVED == "removed"

    def test_member_count(self):
        assert len(HcpLinkStatus) == 4


# ── AccountRequestStatus ───────────────────────────────────────────────────

class TestAccountRequestStatus:
    def test_values(self):
        assert AccountRequestStatus.PENDING == "pending"
        assert AccountRequestStatus.APPROVED == "approved"
        assert AccountRequestStatus.REJECTED == "rejected"

    def test_member_count(self):
        assert len(AccountRequestStatus) == 3
