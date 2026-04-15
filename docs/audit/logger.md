# Audit Logger

**File:** `app/audit/logger.py`  
**Status:** Currently not used (events are logged automatically via middleware).  
**Purpose:** Provides a reusable, database-backed audit logging utility for recording structured audit events.

---

## Overview

This module defines a `audit_log()` function that inserts structured audit events into an `AuditEvent` database table. It is designed to be:

- **Best-effort** — failures will not interrupt or crash application requests.
- **Structured** — supports metadata, actor typing, HTTP context, and resource identification.
- **Extensible** — can be reused later for more granular or explicit event logging.

Although middleware currently handles automatic logging, this module can be used to log domain-specific or sensitive actions that require additional context.

---

## Key Concepts

### Actor Types

The module defines a strict set of allowed actor types:

```python
ActorType = Literal["user", "admin", "system", "service"]