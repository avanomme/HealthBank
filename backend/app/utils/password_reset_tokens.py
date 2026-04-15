# generated with the help of chatgpt
# app/utils/password_reset_tokens.py
from __future__ import annotations

from datetime import datetime, timedelta, timezone
import secrets
from typing import Optional, Tuple

from app.utils.utils import get_db_connection


def _utc_now() -> datetime:
    return datetime.now(timezone.utc)


def generate_reset_token_for_email(email: str) -> Tuple[str, datetime]:
    """
    Generates a secure reset token and stores it with a 1-hour expiry.
    Returns (token, expires_at_utc).
    """
    token = secrets.token_urlsafe(32)
    expires_at = _utc_now() + timedelta(hours=1)

    conn = get_db_connection()
    cur = conn.cursor()

    # Update Auth row via AccountData.Email -> AccountData.AuthID -> Auth.AuthID
    cur.execute(
        """
        UPDATE Auth a
        JOIN AccountData ad ON ad.AuthID = a.AuthID
        SET a.ResetToken = %s,
            a.ResetTokenExpires = %s
        WHERE ad.Email = %s
        """,
        (token, expires_at.replace(tzinfo=None), email),
    )

    if cur.rowcount == 0:
        cur.close()
        conn.close()
        # Caller should respond with generic success anyway (avoid account enumeration)
        raise LookupError("No account with that email")

    conn.commit()
    cur.close()
    conn.close()

    return token, expires_at


def clear_reset_token(token: str) -> None:
    """
    Clears a reset token (used after successful reset, or to invalidate).
    """
    conn = get_db_connection()
    cur = conn.cursor()

    cur.execute(
        """
        UPDATE Auth
        SET ResetToken = NULL,
            ResetTokenExpires = NULL
        WHERE ResetToken = %s
        """,
        (token,),
    )

    conn.commit()
    cur.close()
    conn.close()


def get_authid_by_valid_reset_token(token: str) -> Optional[int]:
    """
    Validates the token + expiry and returns AuthID if valid, else None.
    """
    conn = get_db_connection()
    cur = conn.cursor()

    cur.execute(
        """
        SELECT AuthID
        FROM Auth
        WHERE ResetToken = %s
          AND ResetTokenExpires IS NOT NULL
          AND ResetTokenExpires > UTC_TIMESTAMP()
        """,
        (token,),
    )

    row = cur.fetchone()
    cur.close()
    conn.close()

    return int(row[0]) if row else None
