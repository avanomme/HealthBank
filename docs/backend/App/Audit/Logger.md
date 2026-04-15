# `markdown/audit_logger.md` — Audit Logger (`app/audit/logger.py`)

## Overview

`app/audit/logger.py` provides a manual, best-effort audit logging utility for writing structured events to the `AuditEvent` table.

Although currently unused (audit events are logged automatically via middleware), this module can be used to:

- Log domain-specific business events
- Record service-level operations
- Write additional metadata beyond request lifecycle logging
- Support future audit tables or extended logging scenarios

Failures in this logger **do not raise exceptions** and will not break request handling.

---

## Architecture / Design Explanation

### Logging Strategy

The `audit_log()` function:

1. Extracts request-level context (if available) from `request.state.audit_ctx`
2. Converts IP addresses to packed binary for `VARBINARY(16)` storage
3. Serializes optional metadata to JSON
4. Inserts a row into `AuditEvent`
5. Commits the transaction
6. Silently ignores any exception (best-effort model)

This design ensures audit logging never disrupts application behavior.

### Request Context Integration

If a `Request` object is provided and contains:

```python
request.state.audit_ctx