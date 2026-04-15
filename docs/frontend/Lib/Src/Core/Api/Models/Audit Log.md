# Audit Log API Models

**File:** `frontend/lib/src/core/api/models/audit_log.dart`  
**Purpose:** Defines immutable models for audit logging data returned from backend audit endpoints.

---

## Overview

This file provides models for:

- A single audit event
- A paginated audit log response

The models are aligned with backend audit logging structures and support:

- Security auditing
- Administrative review
- Compliance and traceability

All models use:

- `freezed` for immutability and value equality
- `json_serializable` for JSON serialization
- Explicit `@JsonKey` mappings for snake_case backend fields

---

## Code Generation

After modifying this file, run:

```bash
dart run build_runner build