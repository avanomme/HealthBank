# `markdown/admin.md` — Admin API (`backend/app/api/v1/admin.py`)

## Overview

`backend/app/api/v1/admin.py` implements admin-privileged endpoints for:

- Database viewer (table list, schema, data preview with sensitive-column filtering)
- Admin-initiated user creation with temporary passwords
- Password reset operations and reset-email sending
- System-admin-only user “view-as” (preferred) and legacy “impersonation” (deprecated)
- Audit log browsing with rich filtering
- Permanent user data purging (system admin only)
- Account request review (approve/reject) and request listing/count
- Viewing a user’s most recent consent record (admin only)

All routes are mounted under `/api/v1/admin` and protected by role enforcement at the router level.

---

## Architecture / Design Explanation

### Router-Level Authorization

The router is initialized with:

- `APIRouter(dependencies=[Depends(require_role(4))])`

Meaning all endpoints require RoleID 4 access per `require_role`. In this codebase, RoleID 4 is treated as “System Admin” and bypass logic is handled in `require_role` (see `app/api/deps.py`).

> Note: Some endpoint docstrings describe “admin-only” (RoleID=3) vs “system admin” (RoleID=4), but this module’s router-level dependency enforces RoleID 4 for every endpoint unless `require_role` itself allows otherwise.

### Database Viewer Controls

The database viewer is constrained by:

- `ALLOWED_TABLES`: explicit allowlist of table names
- `SENSITIVE_COLUMNS`: per-table sensitive columns excluded from schema and data output (e.g., password/token hashes)
- Use of parameterized queries where values are provided

Schema inspection uses `INFORMATION_SCHEMA` to build a structured view (`TableSchema`) and returns row counts.

### Authentication / Session Handling for View-As

There are two approaches:

- **Deprecated impersonation**: creates a new session token for the target user and sets it as the session cookie.
- **View-as (preferred)**: updates the existing admin session record by setting `Sessions.ViewingAsUserID` to the target user ID. No token switching.

View-as is simpler for frontends and aligns with the role resolution logic in `require_role`, which supports “effective role” based on `ViewingAsUserID`.

### Audit Log Retrieval

Audit log listing:

- Filters dynamically based on query params
- Uses a count query for pagination metadata
- Joins `AuditEvent` with `AccountData` to add actor identity fields
- Converts binary IP address fields to readable strings where possible
- Parses `MetadataJSON` if present

### User Purge Strategy

The purge endpoint performs a hard delete of user-linked data:

- Deletes sessions owned by the user and sessions referencing them in impersonation/view-as fields
- Deletes responses, survey assignments, and 2FA rows
- Deletes account and auth rows
- Optionally scrubs audit event metadata while keeping audit records (privacy-preserving approach)

Operations occur in one DB transaction (commit/rollback).

### Account Request Workflow

Supports reviewing sign-up requests stored in `AccountRequest`:

- List requests by status (default: pending)
- Count pending requests
- Approve creates an account and attempts to email a temp password
- Reject optionally stores admin notes

Email failures during approval do not roll back account creation.

---

## Configuration (if applicable)

### Table Viewer Configuration

- `ALLOWED_TABLES`: controls which tables can be queried through viewer endpoints.
- `SENSITIVE_COLUMNS`: controls which columns are excluded from schema/data responses.

### Session / Cookie Utilities

This module depends on session helpers from `backend/app/api/v1/sessions.py`, including:

- `get_token(request)` for retrieving the current session token
- `set_session_cookie(response, token, expires_at)` for setting cookies (impersonation flow)
- `SESSION_EXPIRY_HOURS` for impersonation token expiry duration

---

## API Reference

All endpoints below are relative to the router prefix: `/api/v1/admin`.

### Database Viewer

#### `GET /tables`

Lists available tables (from `ALLOWED_TABLES`) with schema summaries and row counts.

**Response model:** `TableListResponse`

#### `GET /tables/{table_name}`

Returns schema + paginated data preview for a single allowed table.

**Query parameters**
- `limit: int` (default 100, min 1, max 1000)
- `offset: int` (default 0, min 0)

**Response model:** `TableDetailResponse`

#### `GET /tables/{table_name}/data`

Returns paginated data preview only (no schema).

**Query parameters**
- `limit: int` (default 100, min 1, max 1000)
- `offset: int` (default 0, min 0)

**Response model:** `TableData`

---

### User Management

#### `POST /users`

Creates a new user with an auto-generated temporary password.

**Request model:** `AdminUserCreate`

**Response model:** `AdminUserCreateResponse`

#### `POST /users/{user_id}/reset-password`

Sets a user’s password directly (hashing it before storage).

**Request model:** `PasswordResetRequest`

**Response model:** `PasswordResetResponse`

#### `POST /users/{user_id}/send-reset-email`

Sends a reset email containing a provided temporary password. Supports optional override recipient email.

**Request model:** `SendResetEmailRequest`

**Response model:** `SendResetEmailResponse`

---

### View-As (Preferred) and Impersonation (Deprecated)

#### `POST /users/{user_id}/view-as`

System-admin-only. Updates the caller’s existing session to set `ViewingAsUserID`.

**Response model:** `ViewAsResponse`

#### `POST /view-as/end`

Clears `ViewingAsUserID` from the current session.

**Response model:** `EndViewAsResponse`

#### `POST /users/{user_id}/impersonate` (Deprecated)

Creates a new impersonation session token for the target user and sets it as an HttpOnly cookie.

**Response model:** `ImpersonateResponse`

#### `POST /impersonate/end` (Deprecated)

Deletes the impersonation session and clears the cookie.

**Response model:** `EndImpersonationResponse`

---

### Audit Logs

#### `GET /audit-logs`

Returns paginated audit events with optional filtering.

**Query parameters**
- `limit: int` (default 50, min 1, max 500)
- `offset: int` (default 0, min 0)
- `action: str | None`
- `status: str | None` (e.g., success, failure, denied)
- `actor_account_id: int | None`
- `resource_type: str | None`
- `http_method: str | None`
- `search: str | None` (matches `Path` or `Action` via `LIKE`)
- `start_date: str | None` (ISO string; passed to SQL)
- `end_date: str | None` (ISO string; passed to SQL)

**Response model:** `AuditLogResponse`

#### `GET /audit-logs/actions`

Returns distinct `Action` values.

**Response type:** `List[str]`

#### `GET /audit-logs/resource-types`

Returns distinct `ResourceType` values.

**Response type:** `List[str]`

---

### User Data Purge

#### `DELETE /users/{user_id}/purge`

Permanently deletes a user and associated data. System-admin-only.

**Query parameters**
- `scrub_audit_metadata: bool` (default `True`)
  - If `True`, sets `IpAddress`, `UserAgent`, and `MetadataJSON` to `NULL` on audit events where `ActorAccountID` matches the user.

**Response model:** `PurgeUserResponse`

---

### Account Requests

#### `GET /account-requests`

Lists account requests filtered by status (default: pending).

**Query parameters**
- `status: str` (alias for `request_status`, default `"pending"`)
  - Allowed: `pending`, `approved`, `rejected`

**Response type:** `List[AccountRequestResponse]`

#### `GET /account-requests/count`

Counts pending account requests.

**Response model:** `AccountRequestCountResponse`

#### `POST /account-requests/{request_id}/approve`

Approves a request, creates `Auth` + `AccountData`, marks request approved, and attempts to email a temp password.

**Response type:** `dict`
- `message: str`
- `account_id: int`
- `email: str`

#### `POST /account-requests/{request_id}/reject`

Rejects a request and optionally stores `AdminNotes`.

**Request model:** `AccountRequestRejectBody` (optional)

**Response type:** `dict`
- `message: str`

---

### Consent Records

#### `GET /users/{user_id}/consent`

Returns the most recent consent record for a user.

**Response model:** `UserConsentRecordResponse | None`

---

## Parameters and Return Types

### Common Query Parameters

- `limit`
  - `int`, bounded per endpoint (tables: 1–1000; audit logs: 1–500)
- `offset`
  - `int`, minimum 0
- Table viewer `table_name`
  - `str`, must exist in `ALLOWED_TABLES`

### Key Request Models

- `AdminUserCreate`
  - `email: EmailStr`
  - `first_name: str` (1–50)
  - `last_name: str` (1–50)
  - `role_id: int` (1–4)
  - Sanitizes and normalizes email and trims names.

- `PasswordResetRequest`
  - `new_password: str` (min 8)

- `SendResetEmailRequest`
  - `temporary_password: str` (min 1)
  - `email_override: str | None`

- `AccountRequestRejectBody`
  - `admin_notes: str | None` (max 1000), sanitized

### Representative Response Models

- Table viewer
  - `TableSchema`, `TableData`, `TableListResponse`, `TableDetailResponse`
- User management
  - `AdminUserCreateResponse`, `PasswordResetResponse`, `SendResetEmailResponse`
- View-as / impersonation
  - `ViewAsResponse`, `EndViewAsResponse`, `ImpersonateResponse`, `EndImpersonationResponse`
- Audit logs
  - `AuditEventResponse`, `AuditLogResponse`
- Purge
  - `PurgeUserResponse` includes per-table delete counts
- Account requests
  - `AccountRequestResponse`, `AccountRequestCountResponse`
- Consent records
  - `UserConsentRecordResponse`

---

## Error Handling

### Authorization / Authentication

- Many endpoints raise `401` if no valid session token is found (view-as and legacy impersonation flows explicitly check tokens).
- Role enforcement is applied at router creation via `require_role(4)`.

### Common HTTP Errors

- `404 Not Found`
  - Table not in allowlist
  - User, request, consent record not found (varies by endpoint)

- `400 Bad Request`
  - Invalid request status filter
  - Attempting to view-as or impersonate yourself
  - Attempting to view-as inactive user
  - Ending impersonation/view-as when not active
  - Non-pending request approve/reject
  - Invalid backup type or filename (backup/restore endpoints)

- `409 Conflict`
  - Approving an account request when an account already exists for the email

- `429 Too Many Requests`
  - Not implemented in this file directly (would be applied via dependencies elsewhere)

- `500 Internal Server Error`
  - Database errors from `mysql.connector.Error`
  - Email send failure returns `500` in `/send-reset-email`; in `/account-requests/{id}/approve`, email failure is swallowed and does not rollback.
  - `mysqldump` or `mysql` subprocess failure (backup/restore endpoints)

### Data Exposure Controls

- Sensitive columns (e.g., `PasswordHash`, `TokenHash`) are excluded from schema/data responses via `SENSITIVE_COLUMNS`.
- Impersonation flow sets cookies and does not return the token in the response body.

---

## Database Backup & Restore

Added in `admin.py` (lines ~2137–2448). Provides on-demand database backups, scheduled backup listing, direct file download, and one-click restore with automatic safety snapshot.

### Configuration

| Variable | Default | Purpose |
|----------|---------|---------|
| `BACKUPS_DIR` env var | `/backups` | Root directory for all backup files |
| `_BACKUP_TYPES` | `daily, weekly, monthly, manual` | Allowed sub-directory names |
| `_MANUAL_KEEP` | `10` | Maximum manual backups retained; oldest pruned automatically |

Credentials are sourced from `DATABASE_URL` (parsed via `urlparse`) or individual `MYSQL_HOST` / `MYSQL_USER` / `MYSQL_PASSWORD` / `MYSQL_DATABASE` env vars. Password is passed via `MYSQL_PWD` environment variable to avoid command-line exposure.

### Data Models

- `BackupInfo` — `filename`, `backup_type`, `created_at`, `size_bytes`, `size_human`
- `RestoreResult` — `pre_backup_filename`, `pre_backup_size_human`, `restored_file`, `migrations_run`, `message`

### Endpoints

#### `GET /backups`

List all backup files across all types, sorted newest first. No auth required so admins can check backup status from monitoring tools.

#### `POST /backups/trigger`

Trigger an immediate manual `mysqldump`. Uses `--single-transaction` for a consistent snapshot without table locks. Output is gzip-compressed and saved to `manual/<db>_<timestamp>.sql.gz`. Prunes oldest manual backups if count exceeds `_MANUAL_KEEP`.

**Roles required:** 4

#### `GET /backups/{backup_type}/{filename}/download`

Stream the `.sql.gz` file to the browser as a download. Validates backup_type against allowlist and filename against path traversal (blocks `..`, `/`, `\`). No auth required for download URL so admins can share links.

#### `DELETE /backups/manual/{filename}`

Delete a manual backup file. Only `manual/` backups can be deleted — scheduled backups (`daily`, `weekly`, `monthly`) are managed by cron rotation and cannot be removed via API.

**Roles required:** 4

#### `POST /backups/{backup_type}/{filename}/restore`

Full four-step database restore:

1. **Validate** — backup_type in allowlist; filename blocks `..`/`/`/`\`; file exists.
2. **Pre-restore backup** — a new `mysqldump` is created as `manual/<db>_pre_restore_<ts>.sql.gz` before any change is made to the live database.
3. **Restore** — decompress `.sql.gz` in memory, pipe to `mysql` CLI. The dump contains `CREATE DATABASE` / `USE` so the database is fully replaced.
4. **Run migrations** — all `.sql` files in `/code/app/migrations/` applied in sorted order to bring schema to current version. Already-applied migrations are safe to re-run.

Returns `RestoreResult` with filenames, sizes, and migration count.

**Roles required:** 4

### Security

Path traversal is blocked on all endpoints that accept a filename parameter:

```python
if ".." in filename or "/" in filename or "\\" in filename:
    raise HTTPException(400, "Invalid filename.")
if not filename.endswith(".sql.gz"):
    raise HTTPException(400, "Only .sql.gz files are allowed.")
```

---

## System Settings

Added in `admin.py` (lines ~2450–2551). Single-table key/value configuration store for runtime-adjustable system behaviour. Settings are read by multiple other modules: k-anonymity threshold by Health Tracking researcher endpoints, maintenance mode by the frontend banner middleware, registration_open by the auth module.

### Data Models

- `SystemSettingsResponse` — all current setting values plus a `defaults` dict (seeded defaults for frontend "Reset to default" labels)
- `SystemSettingsUpdate` — validated input for all settings with Pydantic `Field(..., ge=N)` constraints

### Settings Reference

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `k_anonymity_threshold` | int ≥ 1 | 5 | Min distinct participants for research data point to be returned |
| `registration_open` | bool | true | Allow new participant sign-ups |
| `maintenance_mode` | bool | false | Show maintenance banner on all pages |
| `maintenance_message` | str (max 500) | `""` | Banner body text |
| `maintenance_completion` | str (max 200) | `""` | Estimated completion time label |
| `max_login_attempts` | int ≥ 0 | 5 | 0 = unlimited |
| `lockout_duration_minutes` | int ≥ 1 | 30 | Minutes before failed-login lockout clears |
| `consent_required` | bool | true | Require participants to accept consent form |

### Endpoints

#### `GET /settings`

Return current settings. No authentication required so the frontend can read maintenance mode and registration status before the user is logged in.

#### `PUT /settings`

Atomically update all settings. Iterates over key/value pairs and writes each via:

```sql
INSERT INTO SystemSettings (SettingKey, SettingValue, UpdatedBy)
VALUES (%s, %s, %s)
ON DUPLICATE KEY UPDATE
    SettingValue = VALUES(SettingValue),
    UpdatedBy    = VALUES(UpdatedBy)
```

The entire loop is committed in one transaction. On success, `invalidate_cache()` is called immediately so the next request reads the new values.

**Roles required:** 4

### Caching

Settings are cached in-process for 30 seconds by `services/settings.py`. `invalidate_cache()` resets the TTL to zero, forcing a fresh DB read on the next call. Helper functions: `get_int_setting(key)`, `get_bool_setting(key)`, `get_setting(key)`.