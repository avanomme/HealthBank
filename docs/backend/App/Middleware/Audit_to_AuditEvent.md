# `markdown/audit_middleware.md` — Audit-to-AuditEvent Middleware (`app/middleware/audit_to_auditevent.py`)

## Overview

`app/middleware/audit_to_auditevent.py` defines `AuditEveryRequestToAuditEventMiddleware`, a Starlette/FastAPI middleware that logs **every HTTP request** into the `AuditEvent` database table using a best-effort approach.

Key behaviors:

- Logs one row per request, including timing, actor identity (if set by auth), and request metadata.
- Does not log request/response bodies or sensitive headers.
- Adds/propagates a correlation identifier (`x-request-id`) for tracing.
- Never breaks request handling if audit logging fails.

This middleware is intended to provide comprehensive request-level audit trails.

---

## Architecture / Design Explanation

### Request Lifecycle Logging

The middleware wraps request processing:

1. Captures start time via `time.perf_counter()`
2. Generates/propagates a request correlation ID:
   - Uses `x-request-id` header if provided
   - Otherwise generates a UUID
3. Optionally bypasses logging for configured `exclude_paths`
4. Calls the downstream application (`call_next`)
5. In a `finally` block, writes an audit record regardless of outcome:
   - `success`, `failure`, or `denied` derived from HTTP status
   - Includes duration and safe request metadata

### Actor Attribution

Actor identity is pulled from `request.state`, typically set by authentication dependencies:

- `request.state.actor_account_id`
- `request.state.actor_type`
- `request.state.session_id` (read but not stored by this middleware)

If these fields are absent:

- `actor_account_id` defaults to `None`
- `actor_type` defaults to `"user"`

### Safe Metadata Only

The middleware stores only safe metadata:

- Query string (`request.url.query`)
- Request body size (from `Content-Length`, if parseable)
- Request duration
- Error type name if an exception occurred

No authorization headers or request bodies are logged.

### IP Address Storage

Client IP is derived by:

- Using `x-forwarded-for` first (first value), otherwise:
- `request.client.host`

IP is converted to packed binary for `VARBINARY(16)` storage.

### Best-Effort Database Writes

The `AuditEvent` insert is wrapped in a broad exception handler.

- Any DB failure is swallowed
- The request continues unaffected

---

## Configuration (if applicable)

### Middleware Construction

```python
AuditEveryRequestToAuditEventMiddleware(app, exclude_paths: Optional[set[str]] = None)