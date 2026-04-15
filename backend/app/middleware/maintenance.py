# Created with the Assistance of Claude Code
# backend/app/middleware/maintenance.py
"""
Maintenance mode middleware.

When the 'maintenance_mode' system setting is true, all requests to
non-admin, non-auth paths return 503 with a machine-readable detail
field so the Flutter app can display a localized maintenance banner.

Admin paths (/api/v1/admin/*) are always allowed through so admins
can turn maintenance mode back off without a redeploy.
Auth paths (login, me) are also exempt so admins can authenticate.

Settings are read through the shared cached settings service (30 s TTL),
so enabling/disabling maintenance mode takes effect within 30 seconds
without a restart.
"""
from __future__ import annotations

import hashlib

from starlette.middleware.base import BaseHTTPMiddleware
from starlette.responses import JSONResponse
from fastapi import Request

from ..services.settings import get_bool_setting
from ..utils.utils import get_db_connection

# Paths always allowed regardless of maintenance mode
_ALWAYS_EXEMPT = frozenset({
    "/api/v1/auth/login",
    "/api/v1/auth/logout",
    "/api/v1/auth/me",
    "/api/v1/auth/2fa/verify",
    "/api/v1/auth/2fa/challenge",
    "/api/v1/auth/password_reset",
    "/api/v1/auth/password_reset_request",
    "/api/v1/auth/public-config",  # needed so the frontend can fetch maintenance status
    "/health",
    "/",
})

_ADMIN_PREFIX = "/api/v1/admin"
_ADMIN_ROLE_ID = 4
_SESSION_COOKIE = "session_token"


def _is_admin_session(request: Request) -> bool:
    """Return True if the request carries a valid active admin session."""
    token = request.cookies.get(_SESSION_COOKIE)
    if not token:
        auth = request.headers.get("Authorization", "")
        if auth.lower().startswith("bearer "):
            token = auth[7:]
    if not token:
        return False
    token_hash = hashlib.sha256(token.encode()).hexdigest()
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute(
            """
            SELECT ad.RoleID
            FROM Sessions s
            JOIN AccountData ad ON ad.AccountID = s.AccountID
            WHERE s.TokenHash = %s
              AND ad.IsActive = 1
              AND s.IsActive = 1
              AND s.ExpiresAt > UTC_TIMESTAMP()
            LIMIT 1
            """,
            (token_hash,),
        )
        row = cur.fetchone()
        cur.close()
        conn.close()
        return row is not None and row[0] == _ADMIN_ROLE_ID
    except Exception:
        return False


class MaintenanceModeMiddleware(BaseHTTPMiddleware):
    """Return 503 for non-admin users when maintenance_mode setting is true."""

    async def dispatch(self, request: Request, call_next):
        path = request.url.path

        # Admin paths and always-exempt paths pass through unconditionally
        if path.startswith(_ADMIN_PREFIX) or path in _ALWAYS_EXEMPT:
            return await call_next(request)

        if get_bool_setting("maintenance_mode"):
            # Authenticated admins may use any endpoint during maintenance
            if _is_admin_session(request):
                return await call_next(request)

            return JSONResponse(
                status_code=503,
                content={
                    "detail": "maintenance_mode",
                    "message": "The system is currently under maintenance. Please try again later.",
                },
                headers={"Retry-After": "300"},
            )

        return await call_next(request)
