# Admin Impersonation Tests (`backend/tests/test_admin_impersonation.py`)

Unit tests for admin impersonation behavior in the backend API.

These tests validate:

- Starting an impersonation session (system admin only)
- Ending an impersonation session
- `/api/v1/sessions/me` response behavior when impersonating or viewing-as another user
- Authentication and authorization enforcement (401/403/400/404 cases)

## Overview

This module tests three areas:

1. **Start impersonation**: `POST /api/v1/admin/users/{user_id}/impersonate`
2. **End impersonation**: `POST /api/v1/admin/impersonate/end`
3. **Session info**: `GET /api/v1/sessions/me` includes impersonation status

The test file uses a dedicated `TestClient` fixture (`test_client`) rather than the shared `client` fixture in `backend/tests/conftest.py`.

## Architecture / Design

### Dependencies and mocking approach

The tests rely heavily on patching:

- `app.api.v1.admin.get_admin_account_from_token` to simulate cookie-based admin authentication for admin endpoints
- `app.api.v1.admin.get_db_connection` and `app.api.v1.sessions.get_db_connection` to isolate database behavior
- `app.api.v1.admin.hash_token` for token hashing during impersonation end flow

For `/api/v1/sessions/me`, note:

- In the broader test suite, `conftest.py` autouse fixture overrides `get_current_user` to return a default admin user (RoleID 4).
- The tests in `TestSessionInfo` assume auth is handled via that override unless explicitly replaced.

### Role model assumptions

These tests enforce a “system admin” requirement:

- **RoleID 4** (`admin`) is treated as system administrator and allowed to impersonate.
- Non-system roles (example: **RoleID 3**, `hcp`) are forbidden from impersonating.

### Impersonation models under test

The tests cover two related concepts:

- **Session-level impersonation** stored in the `Sessions` table as `ImpersonatedBy`.
- **Viewing-as** mode stored as `viewing_as_user_id` in the `get_current_user()` payload (used by `require_role` and `/sessions/me` behavior).

The file expects that:

- Starting impersonation sets the active session to represent the impersonated user and records who initiated it.
- Ending impersonation restores the admin session context.

## Configuration

No special configuration is required beyond standard pytest execution.

Run this module:

```bash
pytest -q backend/tests/test_admin_impersonation.py