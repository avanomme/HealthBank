# Created with the Assistance of Claude Code
# backend/app/api/v1/consent.py
"""
Consent API

Endpoints:
- GET  /api/v1/consent/status  - Check if user has signed current consent version
- POST /api/v1/consent/submit  - Submit signed consent form

Admin users (RoleID=4) are exempt from consent requirements.
"""
from fastapi import APIRouter, Depends, Request, HTTPException, status
from pydantic import BaseModel, Field, field_validator
from typing import Optional
import os
import ipaddress
import mysql.connector
from ...utils.utils import get_db_connection
from ...services.settings import get_bool_setting
from ..deps import get_current_user, sanitized_string

router = APIRouter()

CURRENT_CONSENT_VERSION = os.getenv("CURRENT_CONSENT_VERSION", "1.0")


def ip_to_varbinary(ip: str | None) -> bytes | None:
    """Convert IP address string to packed binary for VARBINARY storage."""
    if not ip:
        return None
    try:
        return ipaddress.ip_address(ip).packed
    except ValueError:
        return None


# --- Pydantic Models ---

class ConsentStatusResponse(BaseModel):
    has_signed_consent: bool
    consent_version: Optional[str] = None
    consent_signed_at: Optional[str] = None
    current_version: str
    needs_consent: bool


class ConsentSubmitRequest(BaseModel):
    document_text: str = Field(..., min_length=10)
    document_language: str = Field(..., pattern=r"^(en|fr)$")
    signature_name: str = Field(..., min_length=1, max_length=128)

    @field_validator('document_text', 'signature_name', mode='before')
    @classmethod
    def sanitize_text(cls, v):
        return sanitized_string(v)


class ConsentSubmitResponse(BaseModel):
    accepted: bool
    version: str
    consent_record_id: int


# --- Endpoints ---

@router.get("/status")
async def get_consent_status(user=Depends(get_current_user)) -> ConsentStatusResponse:
    """Check if authenticated user has signed the current consent version."""
    if user["role_id"] == 4:
        return ConsentStatusResponse(
            has_signed_consent=True,
            consent_version=None,
            consent_signed_at=None,
            current_version=CURRENT_CONSENT_VERSION,
            needs_consent=False,
        )

    # If consent has been disabled system-wide by an admin, no one needs to sign
    if not get_bool_setting("consent_required"):
        return ConsentStatusResponse(
            has_signed_consent=True,
            consent_version=None,
            consent_signed_at=None,
            current_version=CURRENT_CONSENT_VERSION,
            needs_consent=False,
        )

    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(
            "SELECT ConsentSignedAt, ConsentVersion FROM AccountData WHERE AccountID = %s",
            (user["account_id"],),
        )
        row = cur.fetchone()

        signed_at = row["ConsentSignedAt"] if row else None
        version = row["ConsentVersion"] if row else None
        has_signed = version == CURRENT_CONSENT_VERSION

        return ConsentStatusResponse(
            has_signed_consent=has_signed,
            consent_version=version,
            consent_signed_at=signed_at.isoformat() if signed_at else None,
            current_version=CURRENT_CONSENT_VERSION,
            needs_consent=not has_signed,
        )
    finally:
        cur.close()
        conn.close()


@router.post("/submit", status_code=status.HTTP_201_CREATED)
async def submit_consent(
    data: ConsentSubmitRequest,
    request: Request,
    user=Depends(get_current_user),
) -> ConsentSubmitResponse:
    """Submit signed consent. Inserts ConsentRecord and updates AccountData atomically."""
    if user["role_id"] == 4:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Admin users do not need to sign consent",
        )

    ip = (
        request.headers.get("x-forwarded-for", "").split(",")[0].strip()
        or (request.client.host if request.client else None)
    )
    ip_bin = ip_to_varbinary(ip)
    user_agent = request.headers.get("user-agent")

    conn = get_db_connection()
    cur = conn.cursor()
    try:
        # 1) INSERT into ConsentRecord
        cur.execute(
            """
            INSERT INTO ConsentRecord
                (AccountID, RoleID, ConsentVersion, DocumentLanguage, DocumentText,
                 SignatureName, SignedAt, IpAddress, UserAgent)
            VALUES (%s, %s, %s, %s, %s, %s, UTC_TIMESTAMP(), %s, %s)
            """,
            (
                user["account_id"],
                user["role_id"],
                CURRENT_CONSENT_VERSION,
                data.document_language,
                data.document_text,
                data.signature_name,
                ip_bin,
                user_agent,
            ),
        )
        consent_record_id = cur.lastrowid

        # 2) UPDATE AccountData (atomic with the INSERT)
        cur.execute(
            """
            UPDATE AccountData
            SET ConsentSignedAt = UTC_TIMESTAMP(),
                ConsentVersion = %s
            WHERE AccountID = %s
            """,
            (CURRENT_CONSENT_VERSION, user["account_id"]),
        )

        conn.commit()

        return ConsentSubmitResponse(
            accepted=True,
            version=CURRENT_CONSENT_VERSION,
            consent_record_id=consent_record_id,
        )
    except mysql.connector.Error:
        conn.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to record consent",
        )
    finally:
        cur.close()
        conn.close()
