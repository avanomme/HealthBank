# Created with the Assistance of Claude Code
import base64
import hashlib
import os
import hmac
from datetime import datetime, date, timedelta
from typing import Optional
from fastapi import APIRouter, Response, status, HTTPException, Request
from pydantic import BaseModel, field_validator, Field, EmailStr
import logging
import mysql.connector
from ...utils.utils import get_db_connection

logger = logging.getLogger(__name__)
from ...utils.password_reset_tokens import generate_reset_token_for_email, get_authid_by_valid_reset_token, clear_reset_token
from .sessions import create_session_for_account, set_session_cookie
from ...services.email import email_service as _email_service
from ..deps import Depends, rate_limit, RateLimitRule, require_role, sanitized_string, get_current_user
from ...services.settings import get_bool_setting, get_int_setting, get_setting

MFA_CHALLENGE_TTL_MINUTES = 10
MFA_MAX_ATTEMPTS = 5

class AccountCreate(BaseModel):
    first_name: str = Field(..., min_length=1, max_length=100)
    last_name: str = Field(..., min_length=1, max_length=100)
    email: EmailStr
    password: str = Field(...)

    @field_validator('first_name', 'last_name', mode='before')
    @classmethod
    def sanitize(cls, v):
        return sanitized_string(v)

    @field_validator('first_name', 'last_name')
    @classmethod
    def validate_name(cls, v: str) -> str:
        v = v.strip()
        if not v:  # pragma: no cover — Pydantic min_length catches first
            raise ValueError('Name cannot be empty')
        if len(v) > 100:  # pragma: no cover — Pydantic max_length catches first
            raise ValueError('Name cannot exceed 100 characters')
        return v

    @field_validator('password')
    @classmethod
    def validate_password(cls, v: str) -> str:
        if len(v) < 8:
            raise ValueError('Password must be at least 8 characters long')
        return v


class Login(BaseModel):
    email: EmailStr
    password: str = Field(...)

    # ---------------------------------------------------------------
    # DEV LOGIN SHORTCUT — Remove this validator for production.
    # Allows any user to log in with just a username (no @).
    # The shortcut appends @hb.com to the input.
    # e.g. "admin" -> "admin@hb.com", "john" -> "john@hb.com"
    # ---------------------------------------------------------------
    @field_validator('email', mode='before')
    @classmethod
    def expand_email_shortcut(cls, v: str) -> str:
        if isinstance(v, str) and '@' not in v.strip():
            return f'{v.strip().lower()}@hb.com'
        return v

    @field_validator('password')
    @classmethod
    def validate_password(cls, v: str) -> str:
        if len(v) < 8:
            raise ValueError('Password must be at least 8 characters long')
        return v

class PasswordResetRequest(BaseModel):
    email: EmailStr

class PasswordResetValidate(BaseModel):
    token: str = Field(..., min_length=10, max_length=200)


class PasswordResetConfirm(BaseModel):
    token: str = Field(..., min_length=10, max_length=200)
    new_password: str = Field(...)

    @field_validator('new_password')
    @classmethod
    def validate_password(cls, v: str) -> str:
        if len(v) < 8:
            raise ValueError('Password must be at least 8 characters long')
        return v

class ChangePassword(BaseModel):
    old_password: str = Field(..., min_length=8)
    new_password: str = Field(..., min_length=8)

    @field_validator("new_password")
    @classmethod
    def validate_new_password(cls, v: str) -> str:
        if len(v) < 8:
            raise ValueError("Password must be at least 8 characters long")
        return v


VALID_GENDERS = {"Male", "Female", "Non-Binary", "Prefer Not to Say", "Other"}


class AccountRequestCreate(BaseModel):
    first_name: str = Field(..., min_length=1, max_length=64)
    last_name: str = Field(..., min_length=1, max_length=64)
    email: EmailStr
    role_id: int = Field(..., ge=1, le=3)
    birthdate: Optional[date] = None
    gender: Optional[str] = Field(None, max_length=32)
    gender_other: Optional[str] = Field(None, max_length=64)

    @field_validator('first_name', 'last_name', 'gender_other', mode='before')
    @classmethod
    def sanitize(cls, v):
        return sanitized_string(v)

    @field_validator('first_name', 'last_name')
    @classmethod
    def validate_name(cls, v: str) -> str:
        v = v.strip()
        if not v:  # pragma: no cover — Pydantic min_length catches first
            raise ValueError('Name cannot be empty')
        return v

    @field_validator('gender')
    @classmethod
    def validate_gender(cls, v: Optional[str]) -> Optional[str]:
        if v is not None and v not in VALID_GENDERS:
            raise ValueError(f'Gender must be one of: {", ".join(VALID_GENDERS)}')
        return v


router = APIRouter()


@router.get("/public-config")
async def public_config(response: Response):
    """Public endpoint — no auth required.

    Returns settings the login screen needs before the user is authenticated.
    Cache-Control: no-store prevents browsers from serving a stale snapshot
    after the admin toggles maintenance mode.
    """
    response.headers["Cache-Control"] = "no-store"
    return {
        "registration_open": get_bool_setting("registration_open"),
        "maintenance_mode": get_bool_setting("maintenance_mode"),
        "maintenance_message": get_setting("maintenance_message"),
        "maintenance_completion": get_setting("maintenance_completion"),
        "consent_required": get_bool_setting("consent_required"),
    }


@router.post("/create_account")
async def create_account(data: AccountCreate, response: Response):
    """Create a new participant account. Hashes password, inserts Auth + AccountData rows, sends welcome email."""
    hashed_pass = hash_password(data.password)
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute(
            "INSERT INTO Auth (PasswordHash) Values (%s)",
            (hashed_pass,)
        )

        auth_id = cursor.lastrowid

        cursor.execute(
            "INSERT INTO AccountData (FirstName, LastName, Email, AuthID) VALUES (%s, %s, %s, %s)",
            (data.first_name, data.last_name, data.email, auth_id)
        )
        account_id = cursor.lastrowid

        conn.commit()
        cursor.close()
        conn.close()

        
        response.status_code = status.HTTP_201_CREATED
        return {"message": "account created successfully!", "account_id": account_id}
    except mysql.connector.IntegrityError as err:
        # Duplicate email
        if err.errno == 1062:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Email already exists"
            )
        raise  # pragma: no cover — non-duplicate IntegrityError

    except mysql.connector.Error:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Account creation failed"
        )


@router.post(
    "/request_account",
    status_code=status.HTTP_201_CREATED,
    dependencies=[Depends(rate_limit(RateLimitRule(5, 60), by="ip"))],
)
async def request_account(data: AccountRequestCreate):
    """
    Submit a public account request.
    Admins review and approve/reject via the admin panel.
    """
    if not get_bool_setting("registration_open"):
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="registration_closed",
        )
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Check email not already in AccountData
        cursor.execute(
            "SELECT 1 FROM AccountData WHERE Email = %s", (data.email,)
        )
        if cursor.fetchone():
            cursor.close()
            conn.close()
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="An account with this email already exists",
            )

        # Check email not already in a pending request
        cursor.execute(
            "SELECT 1 FROM AccountRequest WHERE Email = %s AND Status = 'pending'",
            (data.email,),
        )
        if cursor.fetchone():
            cursor.close()
            conn.close()
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="A pending request for this email already exists",
            )

        cursor.execute(
            """
            INSERT INTO AccountRequest
                (FirstName, LastName, Email, RoleID, Birthdate, Gender, GenderOther)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            """,
            (
                data.first_name,
                data.last_name,
                data.email,
                data.role_id,
                data.birthdate,
                data.gender,
                data.gender_other,
            ),
        )
        conn.commit()
        cursor.close()
        conn.close()

        return {"message": "Request submitted successfully"}

    except HTTPException:
        raise
    except mysql.connector.Error:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to submit account request",
        )


@router.delete("/account/{account_id}", dependencies=[Depends(require_role(4))])
async def delete_account(account_id):
    """Hard-delete an account by ID (admin only). Removes Auth + AccountData rows via cascaded FK deletes."""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute(
            "DELETE FROM AccountData WHERE AccountID = %s",
            (account_id,)
        )

        if cursor.rowcount == 0:
            cursor.close()
            conn.close()
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Account not found")

        conn.commit()
        cursor.close()
        conn.close()

        return Response(status_code=status.HTTP_204_NO_CONTENT)
        #return {"message": "successfully deleted account"}

    except mysql.connector.Error as err:
        logger.error("Delete account DB error: %s", err)
        raise HTTPException(status_code=500, detail="Delete failed")


@router.post("/login", dependencies=[Depends(rate_limit(RateLimitRule(10, 60), by="ip"))])
async def login(data: Login, request: Request, response: Response):
    """Authenticate a user. Validates credentials, enforces lockout, creates a session, sets HttpOnly cookie (web) or returns token (native)."""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            "SELECT AccountData.AccountID, Auth.PasswordHash, Auth.MustChangePassword, "
            "AccountData.RoleID, AccountData.Birthdate, AccountData.Gender, "
            "AccountData.IsActive, Auth.AuthID, "
            "Auth.FailedLoginAttempts, Auth.LockedUntil "
            "FROM Auth "
            "JOIN AccountData ON AccountData.AuthID = Auth.AuthID WHERE AccountData.Email = %s",
            (data.email,)
        )

        result = cursor.fetchone()

        if result is None:
            cursor.close()
            conn.close()
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid email or password"
            )

        account_id, password_hash, must_change = result[0], result[1], bool(result[2])
        role_id, birthdate, gender = result[3], result[4], result[5]
        is_active = bool(result[6]) if result[6] is not None else True
        auth_id = result[7]
        failed_attempts = result[8] or 0
        locked_until = result[9]

        # ── Lockout check ────────────────────────────────────────────────────
        max_attempts = get_int_setting("max_login_attempts")
        lockout_minutes = get_int_setting("lockout_duration_minutes")
        now = datetime.utcnow()

        if max_attempts > 0 and locked_until and locked_until > now:
            remaining = int((locked_until - now).total_seconds() / 60) + 1
            cursor.close()
            conn.close()
            raise HTTPException(
                status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                detail=f"account_locked:{remaining}",
            )

        if not verify_password(data.password, password_hash):
            # Increment failed attempts and possibly lock the account
            if max_attempts > 0:
                new_attempts = failed_attempts + 1
                if new_attempts >= max_attempts:
                    lock_until = now + timedelta(minutes=lockout_minutes)
                    cursor.execute(
                        "UPDATE Auth SET FailedLoginAttempts = %s, LockedUntil = %s WHERE AuthID = %s",
                        (new_attempts, lock_until, auth_id),
                    )
                else:
                    cursor.execute(
                        "UPDATE Auth SET FailedLoginAttempts = %s WHERE AuthID = %s",
                        (new_attempts, auth_id),
                    )
                conn.commit()
            cursor.close()
            conn.close()
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid email or password")

        # Successful password — reset lockout counters
        if failed_attempts > 0 or locked_until:
            cursor.execute(
                "UPDATE Auth SET FailedLoginAttempts = 0, LockedUntil = NULL WHERE AuthID = %s",
                (auth_id,),
            )

        if not is_active:
            cursor.close()
            conn.close()
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="account_deactivated"
            )

        # ── Maintenance mode — block non-admin logins ────────────────────────
        if get_bool_setting("maintenance_mode") and role_id != 4:
            cursor.close()
            conn.close()
            raise HTTPException(
                status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                detail="maintenance_mode",
            )

        # check if 2FA is enabled.

        cursor.execute(
            "SELECT IsEnabled FROM Account2FA WHERE AccountID = %s",
            (account_id,)
        )
        row_2fa = cursor.fetchone()
        twofa_enabled = bool(row_2fa[0]) if row_2fa else False


        # Update LastLogin timestamp
        cursor.execute(
            "UPDATE AccountData SET LastLogin = %s WHERE AccountID = %s",
            (datetime.utcnow(), account_id)
        )


        # check 2fa. if 2fa is enabled return an mfa challenge rather than a session token
        if twofa_enabled:
            # Create an MFA challenge instead of a session
            raw_token = _new_challenge_token()
            token_hash = _hash_token(raw_token)
            expires_at = datetime.utcnow() + timedelta(minutes=MFA_CHALLENGE_TTL_MINUTES)

            cursor.execute(
                """
                INSERT INTO mfa_challenges (AccountID, TokenHash, Purpose, ExpiresAt)
                VALUES (%s, %s, 'login', %s)
                """,
                (account_id, token_hash, expires_at)
            )

            conn.commit()
            cursor.close()
            conn.close()

            # No session cookie set yet.
            return {
                "mfa_required": True,
                "challenge_token": raw_token,
                "expires_in": MFA_CHALLENGE_TTL_MINUTES * 60,
                # optional convenience flags you were returning already:
                "must_change_password": must_change,
                "needs_profile_completion": (role_id == 1) and (birthdate is None or gender is None),
            }


        conn.commit()
        cursor.close()
        conn.close()

        ip_address = request.client.host if request.client else None
        user_agent = request.headers.get("user-agent")

        session_data = create_session_for_account(account_id, ip_address, user_agent)

        # Set cookie
        expires_at = datetime.fromisoformat(session_data["expires_at"])
        set_session_cookie(response, session_data["session_token"], expires_at)

        # TODO(HTTPS): Remove this block once the server has HTTPS + SameSite=None;Secure
        # cookies. At that point cross-origin withCredentials works natively and
        # the token never needs to appear in the response body.
        #
        # DEV/MOBILE ONLY — include session_token in body when the client signals
        # it cannot read HttpOnly cookies (Flutter dev server or native mobile).
        # Production same-origin builds never send X-Client-Type, so they never
        # see the token here and remain fully protected by HttpOnly cookies.
        if request.headers.get("x-client-type") != "native":
            session_data.pop("session_token", None)

        session_data["must_change_password"] = must_change
        session_data["needs_profile_completion"] = (role_id == 1) and (birthdate is None or gender is None)

        return session_data

    except mysql.connector.Error as err:
        logger.error("Login DB error: %s", err)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Login failed"
        )


@router.post(
    "/password_reset_request",
    status_code=status.HTTP_202_ACCEPTED,
    dependencies=[Depends(rate_limit(RateLimitRule(5, 60), by="ip"))],
)
async def request_password_reset(data: PasswordResetRequest):
    """
    Request a password reset email.

    Always returns 202 with a generic message (prevents account enumeration).
    Emails the token link to the user.
    """
    try:
        token, expires_at = generate_reset_token_for_email(data.email) # can use "expires_at" later if needed

        conn = get_db_connection()
        cursor = conn.cursor()

        # Look up user by email to get their name
        cursor.execute(
            "SELECT FirstName FROM AccountData WHERE Email = %s",
            (data.email,)
        )
        result = cursor.fetchone()

        # Always return 200 for security - don't reveal if email exists
        cursor.close()
        conn.close()
        if result is None:
            return {"message": "If an account exists for that email, a reset link has been sent."}

        first_name = result[0]
        recipient_email = data.email

        reset_link = f"{os.getenv('EMAIL_BASE_URL', 'http://137.149.157.193:3000')}/#/reset-password?token={token}"

        # Send forgot-password email
        _email_service.send_forgot_password_email(
            user_name=first_name,
            user_email=recipient_email,
            reset_link=reset_link,
        )


    except LookupError:
        # Email not found: still return generic success
        pass
    except mysql.connector.Error:
        # Still do NOT reveal whether the email exists; but you might want to log this server-side
        pass

    return {"message": "If an account exists for that email, a reset link has been sent."}


@router.post("/validate_password_reset")
async def validate_reset_token(data: PasswordResetValidate):
    """
    Optional UX endpoint: lets the frontend check token validity before showing reset form.
    """
    auth_id = get_authid_by_valid_reset_token(data.token)
    if not auth_id:
        raise HTTPException(status_code=400, detail="Invalid or expired reset token.")
    return {"valid": True}



@router.post("/confirm_password_reset")
async def confirm_password_reset(data: PasswordResetConfirm):
    """
    Confirm a password reset: validate token, set new password, clear token.
    """

    auth_id = get_authid_by_valid_reset_token(data.token)
    if not auth_id:
        raise HTTPException(status_code=400, detail="Invalid or expired reset token.")

    new_hash = hash_password(data.new_password)

    try:
        conn = get_db_connection()
        cur = conn.cursor()

        # Update password for this auth id
        cur.execute(
            """
            UPDATE Auth
            SET PasswordHash = %s
            WHERE AuthID = %s
            """,
            (new_hash, auth_id),
        )

        if cur.rowcount == 0:
            cur.close()
            conn.close()
            # Shouldn't happen if token validated, but handle safely
            raise HTTPException(status_code=400, detail="Invalid or expired reset token.")

        conn.commit()
        cur.close()
        conn.close()

        # Invalidate token after success (so it can’t be reused)
        clear_reset_token(data.token)

        return {"message": "Password has been reset successfully."}

    except mysql.connector.Error:
        raise HTTPException(status_code=500, detail="Failed to reset password.")


@router.post("/change_password", dependencies=[Depends(rate_limit(RateLimitRule(10, 60), by="account"))])
async def change_password(
    data: ChangePassword,
    user=Depends(get_current_user),
):
    """
    Change password for the currently authenticated user.
    """
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Get AuthID + current password hash for this account
        cursor.execute(
            """
            SELECT a.AuthID, a.PasswordHash
            FROM AccountData ad
            JOIN Auth a ON a.AuthID = ad.AuthID
            WHERE ad.AccountID = %s
            """,
            (user["account_id"],),
        )
        row = cursor.fetchone()

        if row is None:
            cursor.close()
            conn.close()
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Account not found")

        auth_id, stored_hash = row[0], row[1]

        # Verify old password
        if not verify_password(data.old_password, stored_hash):
            cursor.close()
            conn.close()
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid old password",
            )

        # Prevent no-op / reuse (optional)
        if data.old_password == data.new_password:
            cursor.close()
            conn.close()
            raise HTTPException(status_code=400, detail="New password must be different")

        # Hash and update
        new_hash = hash_password(data.new_password)
        cursor.execute(
            """
            UPDATE Auth
            SET PasswordHash = %s,
                ResetToken = NULL,
                ResetTokenExpires = NULL,
                MustChangePassword = FALSE
            WHERE AuthID = %s
            """,
            (new_hash, auth_id),
        )

        conn.commit()
        cursor.close()
        conn.close()

        # Optional: if you want to invalidate other sessions after password change,
        # you can deactivate sessions here (recommended for security).
        # Example:
        # conn = get_db_connection()
        # cursor = conn.cursor()
        # cursor.execute("UPDATE Sessions SET IsActive = 0 WHERE AccountID = %s", (user["account_id"],))
        # conn.commit()
        # cursor.close()
        # conn.close()

        return {"message": "Password updated successfully"}

    except mysql.connector.Error as err:
        print(err)
        raise HTTPException(status_code=500, detail="Failed to change password")


# ── Profile Completion ──────────────────────────────────────────────

class ProfileComplete(BaseModel):
    birthdate: date
    gender: str = Field(..., min_length=1, max_length=32)

    @field_validator('gender', mode='before')
    @classmethod
    def sanitize_gender(cls, v):
        return sanitized_string(v)


@router.post("/complete_profile")
async def complete_profile(
    data: ProfileComplete,
    user=Depends(get_current_user),
):
    """Complete participant profile with birthdate and gender."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Verify user is a participant (role_id=1)
        cursor.execute(
            "SELECT RoleID FROM AccountData WHERE AccountID = %s",
            (user["account_id"],)
        )
        row = cursor.fetchone()
        if not row or row[0] != 1:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only participants can complete profile"
            )

        cursor.execute(
            "UPDATE AccountData SET Birthdate = %s, Gender = %s WHERE AccountID = %s",
            (data.birthdate, data.gender, user["account_id"])
        )
        conn.commit()
        return {"message": "Profile completed successfully"}

    except HTTPException:
        raise
    except mysql.connector.Error as err:
        conn.rollback()
        print(err)
        raise HTTPException(status_code=500, detail="Failed to complete profile")
    finally:
        cursor.close()
        conn.close()


@router.post("/me/deletion-request", status_code=201)
async def request_account_deletion(
    response: Response,
    user=Depends(get_current_user),
):
    """Submit a self-service account deletion request.

    Immediately deactivates the account (IsActive = False) and creates a
    pending record in AccountDeletionRequest for admin review. The session
    cookie is cleared so the user is logged out immediately.

    Actual data deletion only occurs when an admin approves the request via
    POST /admin/deletion-requests/{id}/approve.
    """
    account_id = user["account_id"]

    # Admins cannot request deletion of their own account — another admin
    # must handle it to prevent accidental loss of all admin access.
    if user.get("role_id") == 4:
        raise HTTPException(
            status_code=403,
            detail="Admin accounts cannot request their own deletion. Contact another admin.",
        )

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Deactivate the account immediately
        cursor.execute(
            "UPDATE AccountData SET IsActive = FALSE WHERE AccountID = %s",
            (account_id,),
        )

        # Invalidate all active sessions for this account
        cursor.execute(
            "UPDATE Sessions SET IsActive = FALSE, RevokedAt = NOW() WHERE AccountID = %s",
            (account_id,),
        )

        # Create the deletion request record
        cursor.execute(
            "INSERT INTO AccountDeletionRequest (AccountID, Status) VALUES (%s, 'pending')",
            (account_id,),
        )

        conn.commit()

        # Clear session cookie
        response.delete_cookie(key="session_token", samesite="strict")

        return {"message": "Deletion request submitted. Your account has been deactivated pending admin review."}

    except mysql.connector.Error as err:
        conn.rollback()
        print(err)
        raise HTTPException(status_code=500, detail="Failed to submit deletion request")
    finally:
        cursor.close()
        conn.close()


def hash_password(password: str) -> str:
    """
    Input:
        plaintext password (str)
    Output:
        single string representing the salted + hashed password

    Uses os.urandom() for cryptographic salt generation per security guidelines.
    """
    if not isinstance(password, str) or password == "":
        raise ValueError("Password must be a non-empty string.")

    # Generate salt using os.urandom (matches totp.py security pattern)
    salt = os.urandom(32)

    iterations = 210_000
    dklen = 32

    derived_key = hashlib.pbkdf2_hmac(
        "sha256",
        password.encode("utf-8"),
        salt,
        iterations,
        dklen=dklen,
    )
    # Format: algorithm$iterations$dklen$salt$hash
    return "$".join([
        "pbkdf2_sha256",
        str(iterations),
        str(dklen),
        base64.b64encode(salt).decode("ascii"),
        base64.b64encode(derived_key).decode("ascii"),
    ])


def verify_password(password_attempt: str, stored_password: str) -> bool:
    try:
        algo, iterations, dklen, salt_b64, hash_b64 = stored_password.split("$")

        salt = base64.b64decode(salt_b64)
        expected = base64.b64decode(hash_b64)

        attempt = hashlib.pbkdf2_hmac(
            "sha256",
            password_attempt.encode("utf-8"),
            salt,
            int(iterations),
            dklen=int(dklen),
        )

        return hmac.compare_digest(expected, attempt)
    except Exception:
        return False

def _new_challenge_token() -> str:
    # urlsafe token; strip padding for neatness
    return base64.urlsafe_b64encode(os.urandom(32)).decode("ascii").rstrip("=")

def _hash_token(token: str) -> str:
    return hashlib.sha256(token.encode("utf-8")).hexdigest()