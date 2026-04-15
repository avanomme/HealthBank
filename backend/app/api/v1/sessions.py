# code generated with the help of ChatGPT
# app/api/v1/sessions.py
"""
Sessions API - Session Management & Authentication

Endpoints:
- POST   /api/v1/sessions/validate  - Validate a session token
- DELETE /api/v1/sessions/logout    - Invalidate session (logout)
- GET    /api/v1/sessions/me        - Get current session info with impersonation status
"""

import secrets
import hashlib
from datetime import datetime, timedelta
from typing import Optional
from fastapi import APIRouter, Depends, Request, HTTPException, Response, status
from ..deps import get_current_user
from pydantic import BaseModel, Field
import mysql.connector

from ...utils.utils import get_db_connection
from ...services.settings import get_bool_setting
import os

router = APIRouter()

CURRENT_CONSENT_VERSION = os.getenv("CURRENT_CONSENT_VERSION", "1.0")
COOKIE_SECURE = os.getenv("COOKIE_SECURE", "true").lower() != "false"


# ------------------------
# Helpers
# ------------------------

SESSION_EXPIRY_HOURS = 8  # 8 hours - reasonable for a workday
MAX_ACTIVE_SESSIONS = 5 # might want to reduce this later


def generate_session_token() -> str:
    """Generate a secure random session token"""
    return secrets.token_urlsafe(32)


def hash_token(token: str) -> str:
    """Hash session token before storage"""
    return hashlib.sha256(token.encode()).hexdigest()

def create_session_for_account(account_id: int, ip_address: str | None, user_agent: str | None,) -> dict:
    """Generate a secure session token, hash it, persist the session row, and return session metadata including the raw token."""
    token = generate_session_token()
    token_hash = hash_token(token)

    now = datetime.utcnow()
    expires_at = now + timedelta(hours=SESSION_EXPIRY_HOURS)

    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            """
            INSERT INTO Sessions (AccountID, TokenHash, CreatedAt, ExpiresAt, IpAddress, UserAgent, IsActive)
            VALUES (%s, %s, %s, %s, %s, %s, 1)
            """,
            (account_id, token_hash, now, expires_at, ip_address, user_agent)
        )


        # Cap active sessions: deactivate older sessions beyond MAX_ACTIVE_SESSIONS
        # Keep the newest MAX_ACTIVE_SESSIONS by CreatedAt (or ExpiresAt).
        cursor.execute(
            f"""
            UPDATE Sessions
            SET IsActive = 0,
                RevokedAt = UTC_TIMESTAMP()
            WHERE AccountID = %s
              AND IsActive = 1
              AND TokenHash NOT IN (
                SELECT TokenHash FROM (
                  SELECT TokenHash
                  FROM Sessions
                  WHERE AccountID = %s
                    AND IsActive = 1
                  ORDER BY CreatedAt DESC
                  LIMIT {MAX_ACTIVE_SESSIONS}
                ) AS keep
              )
            """,
            (account_id, account_id)
        )



        # Fetch user details including role and consent status for the response
        cursor.execute(
            """
            SELECT a.AccountID, a.FirstName, a.LastName, a.Email, r.RoleName,
                   a.RoleID, a.ConsentVersion, a.Birthdate, a.Gender
            FROM AccountData a
            LEFT JOIN Roles r ON a.RoleID = r.RoleID
            WHERE a.AccountID = %s
            """,
            (account_id,)
        )
        user_row = cursor.fetchone()

        conn.commit()
        cursor.close()
        conn.close()

        role_id = user_row[5] if user_row else None
        consent_version = user_row[6] if user_row else None
        consent_required = get_bool_setting("consent_required")
        has_signed = (not consent_required) or (role_id == 4) or (consent_version == CURRENT_CONSENT_VERSION)
        birthdate = user_row[7] if user_row else None
        gender = user_row[8] if user_row else None
        needs_profile = (role_id == 1) and (birthdate is None or gender is None)

        return {
            "session_token": token,
            "expires_at": expires_at.isoformat(),
            "account_id": account_id,
            "first_name": user_row[1] if user_row else None,
            "last_name": user_row[2] if user_row else None,
            "email": user_row[3] if user_row else None,
            "role": user_row[4] if user_row else None,
            "has_signed_consent": has_signed,
            "needs_profile_completion": needs_profile,
        }

    except mysql.connector.Error as err:
        print(err)
        raise HTTPException(status_code=500, detail="Failed to create session")

def set_session_cookie(response: Response, token: str, expires_at: datetime) -> None:
    """Set session cookie with secure configuration"""
    max_age = int((expires_at - datetime.utcnow()).total_seconds())
    
    response.set_cookie(
        key="session_token",
        value=token,
        max_age=max_age,
        httponly=True,   # Prevents JavaScript access (XSS protection)
        secure=COOKIE_SECURE,  # True by default; set COOKIE_SECURE=false for local HTTP dev
        samesite="strict"  # CSRF protection
    )

# ------------------------
# Schemas
# ------------------------

class SessionValidate(BaseModel):
    token: str | None = Field(None, min_length=1)


class UserInfo(BaseModel):
    """Basic user information."""
    account_id: int
    first_name: Optional[str]
    last_name: Optional[str]
    email: str
    role: str
    role_id: int
    birthdate: Optional[str] = None
    gender: Optional[str] = None


class ImpersonationInfo(BaseModel):
    """Information about the admin who initiated impersonation."""
    admin_account_id: int
    admin_first_name: Optional[str]
    admin_last_name: Optional[str]
    admin_email: str



class ViewingAsUserInfo(BaseModel):
    """Information about the user being viewed as."""
    user_id: int
    first_name: Optional[str]
    last_name: Optional[str]
    email: str
    role: str
    role_id: int
    birthdate: Optional[str] = None
    gender: Optional[str] = None


class SessionMeResponse(BaseModel):
    """Response for /sessions/me endpoint."""
    user: UserInfo
    is_impersonating: bool
    impersonation_info: Optional[ImpersonationInfo] = None
    viewing_as: Optional[ViewingAsUserInfo] = None
    session_expires_at: str
    has_signed_consent: bool = True
    needs_profile_completion: bool = False
    must_change_password: bool = False



# ------------------------
# Helper Functions
# ------------------------


def get_token(request: Request) -> Optional[str]:
    """Extract session token from cookie or Authorization header."""
    token = request.cookies.get("session_token")
    if not token:
        auth_header = request.headers.get("Authorization")
        if auth_header and auth_header.startswith("Bearer "):
            token = auth_header[7:]
    return token


# ------------------------
# Endpoints
# ------------------------

@router.post("/validate")
async def validate_session(request: Request, data: SessionValidate = None):
    """
    Validate a session token.
    Used by other services to authorize requests.
    Accepts token from request body or cookie.
    """
    # Try to get token from body first, then from cookie
    token = None
    if data and data.token:
        token = data.token
    else:
        token = request.cookies.get("session_token")
    
    if not token:
        raise HTTPException(status_code=401, detail="No session token provided")
    
    token_hash = hash_token(token)
    now = datetime.utcnow()

    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.execute(
            """
            SELECT SessionID, AccountID, ExpiresAt
            FROM Sessions
            WHERE TokenHash = %s
            """,
            (token_hash,)
        )

        session = cursor.fetchone()

        cursor.close()
        conn.close()

        if not session:
            raise HTTPException(status_code=401, detail="Invalid session token")

        if session["ExpiresAt"] < now:
            raise HTTPException(status_code=401, detail="Session expired")

        return {
            "valid": True,
            "account_id": session["AccountID"]
        }

    except mysql.connector.Error as err:
        print(err)
        raise HTTPException(status_code=500, detail="Session validation failed")


@router.delete("/logout")
async def logout(request: Request, response: Response):
    """
    Invalidate the current session (logout).
    Token is extracted from the HttpOnly session cookie only.
    """
    token = request.cookies.get("session_token")
    if not token:
        raise HTTPException(status_code=401, detail="No session token provided")

    token_hash = hash_token(token)

    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            """
            UPDATE Sessions
            SET IsActive = 0, RevokedAt = UTC_TIMESTAMP()
            WHERE TokenHash = %s AND IsActive = 1
            """,
            (token_hash,)
        )

        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="Session not found")

        conn.commit()
        cursor.close()
        conn.close()

        # Clear the cookie
        response.delete_cookie(key="session_token", samesite="strict")

        return {"message": "logged out"}

    except mysql.connector.Error as err:
        print(err)
        raise HTTPException(status_code=500, detail="Logout failed")


@router.get("/me")
async def get_session_info(user=Depends(get_current_user)) -> SessionMeResponse:
    """
    Get current session info using standardized auth.

    Uses get_current_user for authentication (cookie or Bearer fallback).
    Returns user info with impersonation/viewing-as status.
    """
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        # Get user details + session expiry + impersonation info + consent status
        cursor.execute(
            """
            SELECT ad.FirstName, ad.LastName, ad.Email, ad.RoleID,
                   r.RoleName, s.ExpiresAt, s.ImpersonatedBy,
                   ad.ConsentVersion, ad.Birthdate, ad.Gender,
                   au.MustChangePassword
            FROM AccountData ad
            JOIN Roles r ON ad.RoleID = r.RoleID
            JOIN Sessions s ON s.AccountID = ad.AccountID
            JOIN Auth au ON au.AuthID = ad.AuthID
            WHERE ad.AccountID = %s
            ORDER BY s.ExpiresAt DESC LIMIT 1
            """,
            (user["account_id"],),
        )
        row = cursor.fetchone()

        if not row:
            raise HTTPException(status_code=500, detail="Failed to get session info")

        # Check if viewing-as another user
        viewing_as = None
        is_impersonating = False
        impersonation_info = None

        if user.get("viewing_as_user_id"):
            # Admin is viewing as another user
            cursor.execute(
                """
                SELECT a.AccountID, a.FirstName, a.LastName, a.Email,
                       a.RoleID, r.RoleName, a.Birthdate, a.Gender
                FROM AccountData a
                JOIN Roles r ON a.RoleID = r.RoleID
                WHERE a.AccountID = %s
                """,
                (user["viewing_as_user_id"],),
            )
            viewed_user = cursor.fetchone()

            if viewed_user:
                viewing_as = ViewingAsUserInfo(
                    user_id=viewed_user["AccountID"],
                    first_name=viewed_user["FirstName"],
                    last_name=viewed_user["LastName"],
                    email=viewed_user["Email"],
                    role=viewed_user["RoleName"],
                    role_id=viewed_user["RoleID"],
                    birthdate=viewed_user["Birthdate"].isoformat() if viewed_user["Birthdate"] else None,
                    gender=viewed_user["Gender"],
                )
                is_impersonating = True
                # Admin info from the session owner
                impersonation_info = ImpersonationInfo(
                    admin_account_id=user["account_id"],
                    admin_first_name=row["FirstName"],
                    admin_last_name=row["LastName"],
                    admin_email=row["Email"],
                )

        if viewing_as:
            user_info = UserInfo(
                account_id=viewing_as.user_id,
                first_name=viewing_as.first_name,
                last_name=viewing_as.last_name,
                email=viewing_as.email,
                role=viewing_as.role,
                role_id=viewing_as.role_id,
                birthdate=viewing_as.birthdate,
                gender=viewing_as.gender,
            )
        else:
            user_info = UserInfo(
                account_id=user["account_id"],
                first_name=row["FirstName"],
                last_name=row["LastName"],
                email=row["Email"],
                role=row["RoleName"],
                role_id=row["RoleID"],
                birthdate=row["Birthdate"].isoformat() if row["Birthdate"] else None,
                gender=row["Gender"],
            )

            # Check legacy impersonation
            if row["ImpersonatedBy"] is not None:
                is_impersonating = True
                cursor.execute(
                    """
                    SELECT AccountID, FirstName, LastName, Email
                    FROM AccountData
                    WHERE AccountID = %s
                    """,
                    (row["ImpersonatedBy"],),
                )
                admin = cursor.fetchone()
                if admin:
                    impersonation_info = ImpersonationInfo(
                        admin_account_id=admin["AccountID"],
                        admin_first_name=admin["FirstName"],
                        admin_last_name=admin["LastName"],
                        admin_email=admin["Email"],
                    )

        # Compute consent status
        consent_version = row.get("ConsentVersion")
        role_id = row["RoleID"]
        consent_required = get_bool_setting("consent_required")
        has_signed_consent = (not consent_required) or (role_id == 4) or (consent_version == CURRENT_CONSENT_VERSION)

        # Compute profile completion (participants need birthday + gender)
        birthdate = row.get("Birthdate")
        gender = row.get("Gender")
        needs_profile = (role_id == 1) and (birthdate is None or gender is None)

        must_change = bool(row.get("MustChangePassword", False))

        return SessionMeResponse(
            user=user_info,
            is_impersonating=is_impersonating,
            impersonation_info=impersonation_info,
            viewing_as=viewing_as,
            session_expires_at=row["ExpiresAt"].isoformat(),
            has_signed_consent=has_signed_consent,
            needs_profile_completion=needs_profile,
            must_change_password=must_change,
        )

    except HTTPException:
        raise
    except mysql.connector.Error as err:
        print(err)
        raise HTTPException(status_code=500, detail="Failed to get session info")
    finally:
        cursor.close()
        conn.close()
