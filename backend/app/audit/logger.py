# generated with chatgpt
# app/audit/logger.py
"""
Manual audit logging helper for the HealthBank application.

This module is currently not used for general request logging — all HTTP
requests are captured automatically by AuditEveryRequestToAuditEventMiddleware.
It is retained for future use when individual actions need richer, custom-structured
audit entries written to the AuditEvent table outside of the middleware path.
"""

# file is currently not used as all events are being automatically logged through middleware
# this can be used perhaps with a different table later to give more specific details on specific events

from __future__ import annotations

import ipaddress
import json
import logging
from typing import Any, Dict, Optional, Literal

from fastapi import Request

from app.utils.utils import get_db_connection

_logger = logging.getLogger(__name__)

ActorType = Literal["user", "admin", "system", "service"]
StatusType = Literal["success", "failure", "denied"]


def _ip_to_varbinary(ip: Optional[str]) -> Optional[bytes]:
    """
    Store IPv4/IPv6 in VARBINARY(16).
    """
    if not ip:
        return None
    try:
        return ipaddress.ip_address(ip).packed
    except ValueError:
        return None


def audit_log(
    *,
    request: Optional[Request],
    action: str,
    resource_type: str,
    resource_id: Optional[str] = None,
    status: StatusType,
    actor_type: ActorType = "user",
    actor_account_id: Optional[int] = None,
    http_status_code: Optional[int] = None,
    error_code: Optional[str] = None,
    metadata: Optional[Dict[str, Any]] = None,
) -> None:
    """Write a single audit event to the AuditEvent table.

    Best-effort: any database failure is logged but never re-raised so
    audit writes cannot crash the calling request handler.

    Args:
        request: The current FastAPI request, used to extract IP, user-agent
            and request context. May be None for system-generated events.
        action: Semantic action name (e.g. "user_login", "survey_created").
        resource_type: Category of the affected resource (e.g. "auth", "survey").
        resource_id: Optional identifier of the specific resource affected.
        status: Outcome — "success", "failure", or "denied".
        actor_type: Who performed the action (default "user").
        actor_account_id: AccountID of the acting user, if available.
        http_status_code: HTTP status code returned for the request.
        error_code: Machine-readable error code for failed/denied events.
        metadata: Arbitrary JSON-serializable metadata dict.
    """
    request_id = None
    ip = None
    user_agent = None
    method = None
    path = None

    if request is not None and hasattr(request.state, "audit_ctx"):
        ctx = request.state.audit_ctx
        request_id = ctx.request_id
        ip = ctx.ip
        user_agent = ctx.user_agent
        method = ctx.method
        path = ctx.path

    ip_bin = _ip_to_varbinary(ip)

    # Ensure metadata is JSON serializable
    metadata_json = None
    if metadata is not None:
        try:
            metadata_json = json.dumps(metadata, separators=(",", ":"), ensure_ascii=False)
        except TypeError:
            # last resort: stringify unserializable values
            safe = {k: str(v) for k, v in metadata.items()}
            metadata_json = json.dumps(safe, separators=(",", ":"), ensure_ascii=False)

    try:
        conn = get_db_connection()
        cur = conn.cursor()

        cur.execute(
            """
            INSERT INTO AuditEvent
              (RequestID, ActorType, ActorAccountID,
               IpAddress, UserAgent, HttpMethod, Path,
               Action, ResourceType, ResourceID,
               Status, HttpStatusCode, ErrorCode, MetadataJSON)
            VALUES
              (%s, %s, %s,
               %s, %s, %s, %s,
               %s, %s, %s,
               %s, %s, %s, %s)
            """,
            (
                request_id,
                actor_type,
                actor_account_id,
                ip_bin,
                user_agent,
                method,
                path,
                action,
                resource_type,
                resource_id,
                status,
                http_status_code,
                error_code,
                metadata_json,
            ),
        )

        conn.commit()
        cur.close()
        conn.close()
    except Exception as exc:
        # not raising exception to avoid breaking calls due to audit failures
        _logger.error("Audit log write failed: %s", exc)
        return
