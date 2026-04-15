# generated with chatgpt
# app/api/deps.py
from __future__ import annotations

from fastapi import Depends, HTTPException, status, Request
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import mysql.connector
import hashlib
import os
import time
from dataclasses import dataclass
from typing import Dict, Tuple, Optional
from ..utils.utils import get_db_connection
from ..utils.sanitize import sanitizeData

CURRENT_TOS_VERSION = os.getenv("CURRENT_TOS_VERSION")
SESSION_COOKIE_NAME = "session_token"

# System admin RoleID — always allowed through require_role()
SYSTEM_ADMIN_ROLE_ID = 4

security = HTTPBearer(auto_error=False)


def sanitized_string(v):
    """Pydantic field validator helper — runs sanitizeData on string inputs.

    Usage in a Pydantic model::

        @field_validator("title", "description", mode="before")
        @classmethod
        def sanitize(cls, v):
            return sanitized_string(v)
    """
    if not v or not isinstance(v, str):
        return v
    return sanitizeData(v)

@dataclass
class RateLimitRule:
    max_requests: int
    window_seconds: int

def hash_token(token: str) -> str:
    """Hash session token before storage"""
    return hashlib.sha256(token.encode()).hexdigest()



def _extract_session_token(request: Request, credentials: HTTPAuthorizationCredentials | None) -> str | None:
    """
    Cookie-first session extraction.
    - Prefer HttpOnly cookie `session_token`
    - Fallback to Authorization: Bearer <token> (optional migration path)
    """
    # 1) Cookie (preferred)
    cookie_token = request.cookies.get(SESSION_COOKIE_NAME)
    if cookie_token:
        return cookie_token

    # 2) Bearer fallback (during transition)
    if credentials and credentials.scheme and credentials.credentials:
        if credentials.scheme.lower() == "bearer":
            return credentials.credentials

    return None



def get_current_user(
    request: Request,
    credentials: HTTPAuthorizationCredentials | None = Depends(security),
):
    """
    Resolves the currently authenticated user from a Bearer session token
    or session_token cookie (web builds use HttpOnly cookies).
    Returns a dict with user/account info.
    """

    token = _extract_session_token(request, credentials)

    if not token:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Not authenticated",
        )
    tokenhash = hash_token(token)

    try:
        conn = get_db_connection()
        cur = conn.cursor(dictionary=True)

        cur.execute(
            """
            SELECT
              ad.AccountID,
              ad.Email,
              ad.TosAcceptedAt,
              ad.TosVersion,
              ad.RoleID,
              s.ViewingAsUserID
            FROM Sessions s
            JOIN AccountData ad ON ad.AccountID = s.AccountID
            WHERE s.TokenHash = %s
              AND ad.IsActive = 1
              AND s.IsActive = 1
              AND s.ExpiresAt > UTC_TIMESTAMP()
            """,
            (tokenhash,),
        )

        user = cur.fetchone()
        cur.close()
        conn.close()

        if not user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid or expired session",
            )

        # Make audit middleware happy
        request.state.actor_account_id = user["AccountID"]
        request.state.actor_type = "user"
        request.state.session_id = token

        return {
            "account_id": user["AccountID"],
            "email": user["Email"],
            "tos_accepted_at": user["TosAcceptedAt"],
            "tos_version": user["TosVersion"],
            "role_id": user["RoleID"],
            "viewing_as_user_id": user["ViewingAsUserID"],
        }

    except mysql.connector.Error:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Authentication failed",
        )



def require_tos_accepted(user=Depends(get_current_user)):
    if not user.get("tos_accepted_at"):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="TOS_NOT_ACCEPTED",
        )

    # Optional: enforce latest ToS version
    if user.get("tos_version") != CURRENT_TOS_VERSION:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="TOS_REQUIRES_REACCEPT",
        )

    return user




def _get_role_for_account(account_id: int) -> Optional[int]:
    """Look up a single account's RoleID. Used only for view-as resolution."""
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(
            "SELECT RoleID FROM AccountData WHERE AccountID = %s",
            (account_id,),
        )
        row = cur.fetchone()
        return row["RoleID"] if row else None
    finally:
        cur.close()
        conn.close()


def require_role(*allowed_role_ids: int):
    """
    Factory that returns a dependency requiring the user to have one of the
    specified roles.  Also supports admin (RoleID=4) viewing as another
    user via the ViewingAsUserID column in Sessions.

    Usage:
        @router.get("/", dependencies=[Depends(require_role(2, 4))])
        async def researcher_only(user=Depends(require_role(2, 4))):
            ...

    Returns the standard user dict enriched with:
        effective_account_id  – the account whose role is being used
        effective_role_id     – that account's RoleID

    Performance: Reuses data from get_current_user (which already JOINs
    RoleID and ViewingAsUserID). Only opens a second DB connection when
    ViewingAsUserID is set (to fetch the target user's role).
    """

    def dep(user=Depends(get_current_user)):
        effective_id = user["account_id"]
        effective_role = user["role_id"]

        # If admin is viewing-as another user, resolve target's role
        if user.get("viewing_as_user_id"):
            effective_id = user["viewing_as_user_id"]
            try:
                target_role = _get_role_for_account(effective_id)
            except mysql.connector.Error:
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail="Role check failed",
                )
            if target_role is None:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Insufficient role permissions",
                )
            effective_role = target_role

        # Allow access if effective role matches, OR if the real user is a
        # system admin (so admin can always reach admin-only endpoints like
        # view-as/end even while viewing-as a lower-role user).
        real_role = user["role_id"]
        if (
            effective_role not in allowed_role_ids
            and effective_role != SYSTEM_ADMIN_ROLE_ID
            and real_role != SYSTEM_ADMIN_ROLE_ID
        ):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient role permissions",
            )

        return {
            **user,
            "effective_account_id": effective_id,
            "effective_role_id": effective_role,
        }

    return dep


def _get_client_ip(request: Request) -> str:
    # Only trust X-Forwarded-For if you control your reverse proxy config
    xff = request.headers.get("x-forwarded-for")
    if xff:
        return xff.split(",")[0].strip()
    return request.client.host if request.client else "unknown"


_BUCKETS: Dict[str, Tuple[float, int]] = {}
# pruning controls
_CALLS = 0
PRUNE_EVERY_N_CALLS = 500          # prune every 500 rate-limit checks
EXPIRE_GRACE_SECONDS = 5           # small grace to avoid boundary weirdness
MAX_BUCKETS = 200_000              # safety cap to avoid memory blowups


def rate_limit(rule: RateLimitRule, *, by: str = "ip", max_window_seconds: int = 3600):
    """
    Factory that returns a dependency function.
    by: 'ip' or 'account'
    """

    def dep(request: Request):
        global _CALLS
        _CALLS += 1

        now = time.time()

        if _CALLS % PRUNE_EVERY_N_CALLS == 0:
            _prune_buckets(now, max_window_seconds=max_window_seconds)

        if by == "account":
            # Set by get_current_user (see below). Fallback to IP if missing.
            account_id = getattr(request.state, "actor_account_id", None)
            key = f"acct:{account_id}" if account_id else f"ip:{_get_client_ip(request)}"
        else:
            key = f"ip:{_get_client_ip(request)}"

        window_start, count = _BUCKETS.get(key, (now, 0))

        # Reset window if expired
        if now - window_start >= rule.window_seconds:
            window_start, count = now, 0

        count += 1
        _BUCKETS[key] = (window_start, count)

        if count > rule.max_requests:
            retry_after = int(rule.window_seconds - (now - window_start))
            # Optional: expose for clients
            raise HTTPException(
                status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                detail="RATE_LIMITED",
                headers={"Retry-After": str(max(retry_after, 0))},
            )

    return dep


def _prune_buckets(now: float, max_window_seconds: int) -> None:
    """
    Remove expired buckets. We use the *largest* window in the system as the prune threshold
    because different endpoints may use different windows.
    """
    if not _BUCKETS:
        return

    cutoff = now - max_window_seconds - EXPIRE_GRACE_SECONDS

    # Build list of keys to delete to avoid mutating dict during iteration
    to_delete = []
    for k, (window_start, _count) in _BUCKETS.items():
        if window_start < cutoff:
            to_delete.append(k)

    for k in to_delete:
        _BUCKETS.pop(k, None)

    # Hard safety cap: if buckets grow unbounded, drop oldest-ish entries.
    # This is a last resort and can make limiting less accurate under heavy abuse,
    # but prevents memory death.
    if len(_BUCKETS) > MAX_BUCKETS:
        # sort by window_start ascending and delete oldest 10%
        items = sorted(_BUCKETS.items(), key=lambda kv: kv[1][0])
        n_drop = max(1, len(items) // 10)
        for i in range(n_drop):
            _BUCKETS.pop(items[i][0], None)