# generated with the help of ChatGPT
# app/api/v1/two_factor.py

from fastapi import APIRouter, Depends, HTTPException, status, Response, Request
from pydantic import BaseModel, Field, EmailStr
from .sessions import create_session_for_account, set_session_cookie
from .auth import _hash_token
from datetime import datetime
import logging
import mysql.connector
import pyotp
import time
import os

logger = logging.getLogger(__name__)
from ...utils.utils import get_db_connection
from ...core.totp import encrypt_2fa_secret_for_db, decrypt_2fa_secret_from_db
from ..deps import get_current_user, rate_limit, RateLimitRule


masterkey = os.getenv("2FA_MASTER_KEY")
MFA_CHALLENGE_TTL_MINUTES = 10
MFA_MAX_ATTEMPTS = 5

router = APIRouter()

APP_NAME = "HealthDataBank"   # issuer name in authenticator apps


class Enroll2FA(BaseModel):
    account_email: EmailStr  # shown in authenticator app


class Confirm2FA(BaseModel):
    #account_id: int = Field(..., gt=0)
    code: str = Field(..., pattern=r"^\d{6}$")


class Verify2FAChallenge(BaseModel):
    challenge_token: str = Field(..., min_length=10, max_length=300)
    code: str = Field(..., pattern=r"^\d{6}$")

class Disable(BaseModel):
    account_email: EmailStr


@router.post("/enroll", status_code=status.HTTP_201_CREATED)
async def enroll_2fa(user=Depends(get_current_user)):
    """
    Create or rotate a TOTP secret and return a provisioning URI.
    Frontend can render a QR code from this URI.
    """
    

    secret = pyotp.random_base32()
    encrypted_secret = encrypt_2fa_secret_for_db(secret, masterkey)

    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # lookup account id from email
        #cursor.execute(
        #    "SELECT AccountID FROM AccountData WHERE Email = %s AND IsActive = TRUE LIMIT 1",
        #    (data.account_email,)
        #)
        #row = cursor.fetchone()#

        #if not row:
        #    cursor.close()
        #   conn.close()
        #    raise HTTPException(
        #        status_code=status.HTTP_404_NOT_FOUND,
        #        detail="Account not found for that email"
        #    )

        account_id = user["account_id"]
        email = user["email"]
        #account_id = row[0]

        # Upsert: if row exists, overwrite secret + disable until confirmed
        cursor.execute(
            """
            INSERT INTO Account2FA (AccountID, TotpSecret, IsEnabled, CreatedAt)
            VALUES (%s, %s, 0, UTC_TIMESTAMP())
            ON DUPLICATE KEY UPDATE
              TotpSecret = VALUES(TotpSecret),
              IsEnabled = 0,
              VerifiedAt = NULL,
              LastUsedAt = NULL
            """,
            (account_id, encrypted_secret)
        )

        conn.commit()
        cursor.close()
        conn.close()

        uri = pyotp.TOTP(secret).provisioning_uri(
            #name=data.account_email,
            name=email,
            issuer_name=APP_NAME
        )

        return {"provisioning_uri": uri}

    except mysql.connector.Error as err:
        logger.error("2FA DB error: %s", err)
        raise HTTPException(status_code=500, detail="Failed to enroll 2FA")


@router.post("/confirm", dependencies=[Depends(rate_limit(RateLimitRule(5, 60), by="account"))])
async def confirm_2fa(data: Confirm2FA, user=Depends(get_current_user)):
    """
    Confirm enrollment by verifying a TOTP code.
    Enables 2FA if code is valid.
    """
    try:
        account_id = user["account_id"]
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            "SELECT TotpSecret FROM Account2FA WHERE AccountID = %s",
            (account_id,)
        )
        row = cursor.fetchone()

        if row is None:
            cursor.close()
            conn.close()
            raise HTTPException(status_code=404, detail="2FA not enrolled")

        secret = row[0]
        if isinstance(secret, (bytes, bytearray)):
            secret = secret.decode("utf-8")
            secret = secret.strip()

        secret = decrypt_2fa_secret_from_db(secret, masterkey)

        totp = pyotp.TOTP(secret)

        if not totp.verify(data.code, valid_window=1):
            cursor.close()
            conn.close()
            raise HTTPException(status_code=401, detail="Invalid 2FA code")

        cursor.execute(
            """
            UPDATE Account2FA
            SET IsEnabled = 1, VerifiedAt = UTC_TIMESTAMP(), LastUsedAt = UTC_TIMESTAMP()
            WHERE AccountID = %s
            """,
            (account_id,)
        )

        conn.commit()
        cursor.close()
        conn.close()

        return {"message": "2FA enabled"}

    except mysql.connector.Error as err:
        logger.error("2FA DB error: %s", err)
        raise HTTPException(status_code=500, detail="Failed to confirm 2FA")


@router.post("/verify", dependencies=[Depends(rate_limit(RateLimitRule(5, 60), by="ip"))])
async def verify_2fa_challenge(data: Verify2FAChallenge, request: Request, response: Response):
    """
    Verify TOTP during login using a challenge token.
    If valid, mints the real session cookie.
    """
    try:
        token_hash = _hash_token(data.challenge_token)

        conn = get_db_connection()
        cursor = conn.cursor()

        # Load challenge
        cursor.execute(
            """
            SELECT ChallengeID, AccountID, ExpiresAt, UsedAt, RevokedAt, AttemptCount
            FROM mfa_challenges
            WHERE TokenHash = %s
            """,
            (token_hash,)
        )
        ch = cursor.fetchone()
        if not ch:
            cursor.close(); conn.close()
            raise HTTPException(status_code=401, detail="Invalid or expired challenge")

        challenge_id, account_id, expires_at, used_at, revoked_at, attempt_count = ch

        now = datetime.utcnow()
        if revoked_at is not None or used_at is not None or expires_at <= now:
            cursor.close(); conn.close()
            raise HTTPException(status_code=401, detail="Invalid or expired challenge")

        if attempt_count >= MFA_MAX_ATTEMPTS:
            # optionally revoke it
            cursor.execute(
                "UPDATE mfa_challenges SET RevokedAt = UTC_TIMESTAMP() WHERE ChallengeID = %s",
                (challenge_id,)
            )
            conn.commit()
            cursor.close(); conn.close()
            raise HTTPException(status_code=429, detail="Too many attempts")

        # Increment attempt count BEFORE verifying code (counts failures, and successes too—fine either way)
        cursor.execute(
            """
            UPDATE mfa_challenges
            SET AttemptCount = AttemptCount + 1, LastAttemptAt = UTC_TIMESTAMP()
            WHERE ChallengeID = %s
            """,
            (challenge_id,)
        )

        # Load 2FA secret for account
        cursor.execute(
            "SELECT TotpSecret, IsEnabled FROM Account2FA WHERE AccountID = %s",
            (account_id,)
        )
        row = cursor.fetchone()
        if row is None or not bool(row[1]):
            conn.commit()
            cursor.close(); conn.close()
            raise HTTPException(status_code=409, detail="2FA not enabled")

        secret_enc = row[0]
        secret = decrypt_2fa_secret_from_db(secret_enc, masterkey)

        totp = pyotp.TOTP(secret)
        if not totp.verify(data.code, valid_window=1):
            conn.commit()
            cursor.close(); conn.close()
            raise HTTPException(status_code=401, detail="Invalid 2FA code")

        # Mark challenge used + update last used at
        cursor.execute(
            "UPDATE mfa_challenges SET UsedAt = UTC_TIMESTAMP() WHERE ChallengeID = %s",
            (challenge_id,)
        )
        cursor.execute(
            "UPDATE Account2FA SET LastUsedAt = UTC_TIMESTAMP() WHERE AccountID = %s",
            (account_id,)
        )

        conn.commit()
        cursor.close(); conn.close()

        # Mint real session cookie
        ip_address = request.client.host if request.client else None
        user_agent = request.headers.get("user-agent")
        session_data = create_session_for_account(account_id, ip_address, user_agent)

        expires_cookie = datetime.fromisoformat(session_data["expires_at"])
        set_session_cookie(response, session_data["session_token"], expires_cookie)

        # TODO(HTTPS): Remove once HTTPS + SameSite=None;Secure is in place.
        # DEV/MOBILE ONLY — mirror the same logic as auth.py login.
        if request.headers.get("x-client-type") != "native":
            session_data.pop("session_token", None)
        return {"valid": True, **session_data}

    except mysql.connector.Error as err:
        logger.error("2FA DB error: %s", err)
        raise HTTPException(status_code=500, detail="Failed to verify 2FA")


@router.post("/disable")
async def disable_2fa(user=Depends(get_current_user)):
    """
    Disable 2FA for an account. Requires authentication.
    """
    try:
        account_id = user["account_id"]
        #account_email = user["email"]
        conn = get_db_connection()
        cursor = conn.cursor()

        # lookup account id from email
        #cursor.execute(
        #    "SELECT AccountID FROM AccountData WHERE Email = %s AND IsActive = TRUE LIMIT 1",
        #    (account_email,)
        #)
        #row = cursor.fetchone()

        #if not row:
        #    cursor.close()
        #    conn.close()
        #    raise HTTPException(
        #        status_code=status.HTTP_404_NOT_FOUND,
        #        detail="Account not found for that email"
        #    )

        #account_id = row[0]

        # Check if 2FA is set up and enabled
        cursor.execute(
            "SELECT IsEnabled FROM Account2FA WHERE AccountID = %s",
            (account_id,)
        )
        row = cursor.fetchone()

        if not row:
            cursor.close()
            conn.close()
            raise HTTPException(
                status_code=400,
                detail="Two-factor authentication has not been set up on this account"
            )

        if not bool(row[0]):
            cursor.close()
            conn.close()
            raise HTTPException(
                status_code=400,
                detail="Two-factor authentication is already disabled"
            )

        cursor.execute(
            "UPDATE Account2FA SET IsEnabled = 0 WHERE AccountID = %s",
            (account_id,)
        )

        conn.commit()
        cursor.close()
        conn.close()

        return {"message": "2FA disabled"}

    except mysql.connector.Error as err:
        logger.error("2FA DB error: %s", err)
        raise HTTPException(status_code=500, detail="Failed to disable 2FA")
