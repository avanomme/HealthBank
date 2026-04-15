# Created with the Assistance of Claude Code
# app/middleware/audit_to_auditevent.py
"""
Middleware that automatically records every HTTP request in the AuditEvent table.

Classifies requests using a regex route table (_ROUTE_ACTIONS) to assign a
semantic action name and resource type. Falls back to "http_request" / "HTTP"
for unknown routes. Endpoints may override the classification at runtime by
setting request.state.audit_action and request.state.audit_resource_type.
"""
from __future__ import annotations

import re
import time
import uuid
import ipaddress
import json
import logging
from typing import Optional

from fastapi import Request
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.responses import Response

from app.utils.utils import get_db_connection

logger = logging.getLogger(__name__)


# ── Route → semantic action mapping ──────────────────────────────────────────
#
# Each entry: (HTTP_method_or_None, path_regex, action_name, resource_type)
# method=None matches any HTTP method.
# Entries are checked in order — first match wins.
# Unmatched requests fall back to ("http_request", "HTTP").
#
_ROUTE_ACTIONS: list[tuple[Optional[str], str, str, str]] = [
    # ── Health / internal ────────────────────────────────────────────────────
    ("GET",    r"^/health$",                                        "health_check",                 "system"),

    # ── Auth ─────────────────────────────────────────────────────────────────
    ("POST",   r"^/api/v1/auth/login$",                             "user_login",                   "auth"),
    ("POST",   r"^/api/v1/auth/logout$",                            "user_logout",                  "auth"),
    ("POST",   r"^/api/v1/auth/create_account$",                    "account_created",              "auth"),
    ("POST",   r"^/api/v1/auth/complete_profile$",                  "profile_completed",            "auth"),
    ("POST",   r"^/api/v1/auth/change_password$",                   "password_changed",             "auth"),
    ("POST",   r"^/api/v1/auth/request$",                           "password_reset_requested",     "auth"),
    ("POST",   r"^/api/v1/auth/validate_password_reset$",           "password_reset_validated",     "auth"),
    ("POST",   r"^/api/v1/auth/confirm_password_reset$",            "password_reset_confirmed",     "auth"),

    # ── Session ───────────────────────────────────────────────────────────────
    ("GET",    r"^/api/v1/sessions/me$",                            "session_check",                "session"),

    # ── Two-factor authentication ─────────────────────────────────────────────
    ("POST",   r"^/api/v1/2fa/enroll$",                             "2fa_enroll_started",           "2fa"),
    ("POST",   r"^/api/v1/2fa/confirm$",                            "2fa_enrolled",                 "2fa"),
    ("POST",   r"^/api/v1/2fa/verify$",                             "2fa_verified",                 "2fa"),
    ("POST",   r"^/api/v1/2fa/disable$",                            "2fa_disabled",                 "2fa"),
    ("GET",    r"^/api/v1/2fa/status$",                             "2fa_status_checked",           "2fa"),

    # ── Consent ───────────────────────────────────────────────────────────────
    (None,     r"^/api/v1/consent/[^/]+/accept$",                   "consent_accepted",             "consent"),
    (None,     r"^/api/v1/consent/[^/]+/revoke-consent$",           "consent_revoked",              "consent"),
    (None,     r"^/api/v1/consent/[^/]+/restore-consent$",          "consent_restored",             "consent"),
    ("GET",    r"^/api/v1/consent/[^/]+$",                          "consent_viewed",               "consent"),

    # ── Admin — backups ───────────────────────────────────────────────────────
    ("POST",   r"^/api/v1/admin/backups/trigger$",                  "backup_manual_created",        "backup"),
    ("GET",    r"^/api/v1/admin/backups/[^/]+/[^/]+/download$",     "backup_downloaded",            "backup"),
    ("GET",    r"^/api/v1/admin/backups$",                          "backup_list_viewed",           "backup"),

    # ── Admin — view-as / impersonation ───────────────────────────────────────
    ("POST",   r"^/api/v1/admin/users/\d+/view-as$",                "view_as_start",                "account"),
    ("POST",   r"^/api/v1/admin/view-as/end$",                      "view_as_end",                  "account"),
    ("POST",   r"^/api/v1/admin/users/\d+/impersonate$",            "impersonate_start",            "account"),
    ("POST",   r"^/api/v1/admin/impersonate/end$",                  "impersonate_end",              "account"),

    # ── Admin — user management ───────────────────────────────────────────────
    ("POST",   r"^/api/v1/admin/users/\d+/reset-password$",         "admin_password_reset",         "account"),
    ("POST",   r"^/api/v1/admin/users/\d+/send-reset-email$",       "admin_password_reset_email",   "account"),
    ("POST",   r"^/api/v1/admin/users/\d+/purge$",                  "user_purged",                  "account"),
    (None,     r"^/api/v1/admin/users/\d+/status$",                 "user_status_changed",          "account"),
    ("GET",    r"^/api/v1/admin/users$",                            "user_list_viewed",             "account"),
    ("GET",    r"^/api/v1/admin/users/\d+$",                        "user_viewed",                  "account"),

    # ── Admin — account requests ──────────────────────────────────────────────
    ("POST",   r"^/api/v1/admin/account-requests/\d+/approve$",     "account_request_approved",     "account"),
    ("POST",   r"^/api/v1/admin/account-requests/\d+/reject$",      "account_request_rejected",     "account"),
    ("GET",    r"^/api/v1/admin/account-requests$",                 "account_requests_viewed",      "account"),

    # ── Admin — deletion requests ─────────────────────────────────────────────
    ("POST",   r"^/api/v1/admin/deletion-requests/\d+/approve$",    "deletion_request_approved",    "account"),
    ("POST",   r"^/api/v1/admin/deletion-requests/\d+/reject$",     "deletion_request_rejected",    "account"),
    ("GET",    r"^/api/v1/admin/deletion-requests$",                "deletion_requests_viewed",     "account"),

    # ── Admin — database viewer ───────────────────────────────────────────────
    ("GET",    r"^/api/v1/admin/tables$",                           "db_tables_listed",             "database"),
    ("GET",    r"^/api/v1/admin/tables/[^/]+/data$",                "db_table_data_viewed",         "database"),
    ("GET",    r"^/api/v1/admin/tables/[^/]+$",                     "db_table_viewed",              "database"),

    # ── Admin — audit log ─────────────────────────────────────────────────────
    ("GET",    r"^/api/v1/admin/audit-logs/actions$",               "audit_log_actions_viewed",     "audit"),
    ("GET",    r"^/api/v1/admin/audit-logs/resource-types$",        "audit_log_resource_types_viewed", "audit"),
    ("GET",    r"^/api/v1/admin/audit-logs$",                       "audit_log_viewed",             "audit"),

    # ── Admin — system settings ───────────────────────────────────────────────
    ("GET",    r"^/api/v1/admin/settings$",                         "settings_viewed",              "system_setting"),
    ("PUT",    r"^/api/v1/admin/settings$",                         "settings_updated",             "system_setting"),

    # ── Admin — dashboard ─────────────────────────────────────────────────────
    ("GET",    r"^/api/v1/admin/dashboard/stats$",                  "admin_dashboard_viewed",       "admin"),

    # ── Admin — account requests (count before list) ──────────────────────────
    ("GET",    r"^/api/v1/admin/account-requests/count$",           "account_requests_count_viewed", "account"),
    ("GET",    r"^/api/v1/admin/deletion-requests/count$",          "deletion_requests_count_viewed", "account"),

    # ── Admin — user consent view ─────────────────────────────────────────────
    ("GET",    r"^/api/v1/admin/users/\d+/consent$",                "admin_user_consent_viewed",    "consent"),

    # ── Admin — create user directly ──────────────────────────────────────────
    ("POST",   r"^/api/v1/admin/users$",                            "admin_user_created",           "account"),

    # ── Admin — backup delete ─────────────────────────────────────────────────
    ("DELETE", r"^/api/v1/admin/backups/manual/[^/]+$",             "backup_deleted",               "backup"),

    # ── Surveys — write operations ────────────────────────────────────────────
    ("POST",   r"^/api/v1/surveys/from-template/[^/]+$",            "survey_created_from_template", "survey"),
    ("POST",   r"^/api/v1/surveys$",                                "survey_created",               "survey"),
    ("PATCH",  r"^/api/v1/surveys/[^/]+/publish$",                  "survey_published",             "survey"),
    ("PATCH",  r"^/api/v1/surveys/[^/]+/close$",                    "survey_closed",                "survey"),
    ("PUT",    r"^/api/v1/surveys/[^/]+$",                          "survey_updated",               "survey"),
    ("DELETE", r"^/api/v1/surveys/[^/]+$",                          "survey_deleted",               "survey"),
    ("GET",    r"^/api/v1/surveys/[^/]+/assignments/preview-target$","survey_assignment_preview",   "survey"),
    ("GET",    r"^/api/v1/surveys/[^/]+/assignments$",              "survey_assignments_viewed",    "survey"),
    ("POST",   r"^/api/v1/surveys/[^/]+/assign$",                   "survey_assigned",              "survey"),
    ("GET",    r"^/api/v1/surveys$",                                "survey_list_viewed",           "survey"),
    ("GET",    r"^/api/v1/surveys/[^/]+$",                          "survey_viewed",                "survey"),

    # ── Survey responses ──────────────────────────────────────────────────────
    ("POST",   r"^/api/v1/responses/[^/]+/submit$",                 "response_submitted",           "response"),
    ("GET",    r"^/api/v1/surveys/[^/]+/responses$",                "survey_responses_viewed",      "response"),

    # ── Templates ─────────────────────────────────────────────────────────────
    ("POST",   r"^/api/v1/templates$",                              "template_created",             "template"),
    ("POST",   r"^/api/v1/templates/[^/]+/duplicate$",              "template_duplicated",          "template"),
    ("GET",    r"^/api/v1/templates$",                              "template_list_viewed",         "template"),
    ("GET",    r"^/api/v1/templates/[^/]+$",                        "template_viewed",              "template"),
    ("DELETE", r"^/api/v1/templates/[^/]+$",                        "template_deleted",             "template"),

    # ── Participants ──────────────────────────────────────────────────────────
    ("PUT",    r"^/api/v1/participants/surveys/[^/]+/draft$",        "participant_draft_saved",      "response"),
    ("GET",    r"^/api/v1/participants/surveys/[^/]+/draft$",        "participant_draft_loaded",     "response"),
    ("POST",   r"^/api/v1/participants/surveys/[^/]+/submit$",       "participant_survey_submitted", "response"),
    ("GET",    r"^/api/v1/participants/surveys/[^/]+/questions$",    "participant_survey_questions_viewed", "survey"),
    ("GET",    r"^/api/v1/participants/surveys/data$",               "participant_survey_data_viewed", "response"),
    ("GET",    r"^/api/v1/participants/surveys/[^/]+/compare$",      "participant_survey_compared",  "response"),
    ("GET",    r"^/api/v1/participants/surveys/[^/]+/chart-data$",   "participant_chart_data_viewed","response"),
    ("GET",    r"^/api/v1/participants/surveys$",                    "participant_surveys_viewed",   "survey"),

    # ── Assignments ───────────────────────────────────────────────────────────
    ("GET",    r"^/api/v1/assignments/me$",                         "assignments_viewed",           "survey"),
    ("PUT",    r"^/api/v1/assignments/[^/]+$",                      "assignment_updated",           "survey"),
    ("DELETE", r"^/api/v1/assignments/[^/]+$",                      "assignment_deleted",           "survey"),

    # ── Question bank ─────────────────────────────────────────────────────────
    ("GET",    r"^/api/v1/questions/categories$",                   "question_categories_viewed",   "question"),
    ("POST",   r"^/api/v1/questions/?$",                            "question_created",             "question"),
    ("GET",    r"^/api/v1/questions/[^/]+$",                        "question_viewed",              "question"),
    ("PUT",    r"^/api/v1/questions/[^/]+$",                        "question_updated",             "question"),
    ("DELETE", r"^/api/v1/questions/[^/]+$",                        "question_deleted",             "question"),
    ("GET",    r"^/api/v1/questions/?$",                            "question_list_viewed",         "question"),

    # ── User self-service ─────────────────────────────────────────────────────
    ("POST",   r"^/api/v1/users/me/deletion-request$",              "deletion_request_submitted",   "account"),
    ("GET",    r"^/api/v1/users/me$",                               "profile_viewed",               "account"),

    # ── Terms of Service ──────────────────────────────────────────────────────
    ("POST",   r"^/api/v1/tos/accept$",                             "tos_accepted",                 "auth"),

    # ── HCP links ─────────────────────────────────────────────────────────────
    ("POST",   r"^/api/v1/hcp-links/request$",                      "hcp_link_requested",           "hcp"),
    ("GET",    r"^/api/v1/hcp-links/?$",                            "hcp_links_viewed",             "hcp"),
    ("PUT",    r"^/api/v1/hcp-links/[^/]+/respond$",                "hcp_link_responded",           "hcp"),
    ("POST",   r"^/api/v1/hcp-links/[^/]+/revoke-consent$",         "hcp_link_consent_revoked",     "hcp"),
    ("POST",   r"^/api/v1/hcp-links/[^/]+/restore-consent$",        "hcp_link_consent_restored",    "hcp"),
    ("DELETE", r"^/api/v1/hcp-links/[^/]+$",                        "hcp_link_deleted",             "hcp"),

    # ── Messaging ─────────────────────────────────────────────────────────────
    ("POST",   r"^/api/v1/messages/conversations$",                 "conversation_created",         "message"),
    ("GET",    r"^/api/v1/messages/conversations$",                 "conversations_viewed",         "message"),
    ("GET",    r"^/api/v1/messages/conversations/[^/]+/messages$",  "conversation_messages_viewed", "message"),
    ("POST",   r"^/api/v1/messages/conversations/[^/]+/messages$",  "message_sent",                 "message"),
    ("POST",   r"^/api/v1/messages/friend-request$",                "friend_request_sent",          "message"),
    ("GET",    r"^/api/v1/messages/friends$",                       "friends_viewed",               "message"),
    ("GET",    r"^/api/v1/messages/researchers/search$",            "researcher_search",            "message"),
    ("GET",    r"^/api/v1/messages/researchers$",                   "researchers_listed",           "researcher"),
    ("POST",   r"^/api/v1/messages/friend-request/direct$",         "direct_contact_request_sent",  "friend_request"),
    ("GET",    r"^/api/v1/messages/friend-requests/incoming$",      "friend_requests_viewed",       "message"),
    ("PUT",    r"^/api/v1/messages/friend-requests/[^/]+/respond$", "friend_request_responded",     "message"),

    # ── HCP patients ─────────────────────────────────────────────────────────
    ("GET",    r"^/api/v1/hcp/patients$",                           "patient_list_viewed",          "hcp"),
    ("GET",    r"^/api/v1/hcp/patients/[^/]+/surveys$",             "patient_surveys_viewed",       "hcp"),
    ("GET",    r"^/api/v1/hcp/patients/[^/]+/responses/[^/]+$",     "patient_responses_viewed",     "hcp"),

    # ── Research / aggregation ────────────────────────────────────────────────
    ("GET",    r"^/api/v1/research/cross-survey/",                  "research_cross_survey_accessed","research"),
    ("GET",    r"^/api/v1/research/surveys/[^/]+/export/csv$",      "research_survey_exported",     "research"),
    ("GET",    r"^/api/v1/research/",                               "research_data_accessed",       "research"),
]


def _classify_request(method: str, path: str) -> tuple[str, str]:
    """Return (action, resource_type) for a given HTTP method + path."""
    for route_method, pattern, action, resource_type in _ROUTE_ACTIONS:
        if route_method is not None and route_method != method:
            continue
        if re.match(pattern, path):
            return action, resource_type
    return "http_request", "HTTP"


# ── Helpers ───────────────────────────────────────────────────────────────────

def _ip_to_varbinary(ip: Optional[str]) -> Optional[bytes]:
    if not ip:
        return None
    try:
        return ipaddress.ip_address(ip).packed
    except ValueError:
        return None


def _get_client_ip(request: Request) -> Optional[str]:
    xff = request.headers.get("x-forwarded-for")
    if xff:
        return xff.split(",")[0].strip()
    return request.client.host if request.client else None


def _status_from_http(code: int) -> str:
    if code in (401, 403):
        return "denied"
    if 200 <= code <= 399:
        return "success"
    return "failure"


# ── Middleware ────────────────────────────────────────────────────────────────

class AuditEveryRequestToAuditEventMiddleware(BaseHTTPMiddleware):
    """
    Logs every HTTP request into the AuditEvent table (best-effort).
    Uses semantic action names for known routes; falls back to "http_request".
    Endpoints can override action/resource_type via request.state:
        request.state.audit_action = "custom_action"
        request.state.audit_resource_type = "custom_type"
    Does not log request bodies or sensitive headers.
    """

    def __init__(self, app, exclude_paths: Optional[set[str]] = None):
        super().__init__(app)
        self.exclude_paths = exclude_paths or set()

    async def dispatch(self, request: Request, call_next):
        start = time.perf_counter()

        request_id = request.headers.get("x-request-id") or str(uuid.uuid4())
        request.state.request_id = request_id

        path = request.url.path
        if path in self.exclude_paths:
            response = await call_next(request)
            response.headers["x-request-id"] = request_id
            return response

        method  = request.method
        ip      = _get_client_ip(request)
        ip_bin  = _ip_to_varbinary(ip)
        ua      = request.headers.get("user-agent")
        query   = request.url.query or None

        try:
            req_bytes = int(request.headers.get("content-length", 0)) or None
        except ValueError:
            req_bytes = None

        error_type  = None
        status_code = 500

        try:
            response: Response = await call_next(request)
            status_code = response.status_code
            return response
        except Exception as exc:
            error_type = exc.__class__.__name__
            raise
        finally:
            actor_account_id = getattr(request.state, "actor_account_id", None)
            actor_type       = getattr(request.state, "actor_type", "user")

            duration_ms = int((time.perf_counter() - start) * 1000)
            status      = _status_from_http(status_code)

            # Semantic classification — endpoint may override via request.state
            action, resource_type = _classify_request(method, path)
            if hasattr(request.state, "audit_action"):
                action = request.state.audit_action
            if hasattr(request.state, "audit_resource_type"):
                resource_type = request.state.audit_resource_type

            metadata = {"duration_ms": duration_ms, "query": query, "request_bytes": req_bytes}
            if error_type:
                metadata["error_type"] = error_type

            try:
                conn = get_db_connection()
                cur  = conn.cursor()
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
                        request_id, actor_type, actor_account_id,
                        ip_bin, ua, method, path,
                        action, resource_type, f"{method} {path}",
                        status, status_code,
                        "UNHANDLED_EXCEPTION" if error_type else None,
                        json.dumps(metadata, separators=(",", ":"), ensure_ascii=False),
                    ),
                )
                conn.commit()
                cur.close()
                conn.close()
            except Exception as exc:
                logger.error("Audit write failed: %s", exc)  # Never break the request due to audit failure
