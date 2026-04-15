# `require_role()` Dependency Tests (`test_require_role.py`)

Test suite for the `require_role()` dependency factory in `app/api/deps.py`.

This module validates role-based access control, admin impersonation behavior (via `ViewingAsUserID` stored in Sessions), error handling for authentication and database failures, and the shape of the enriched user object returned by the dependency.

## Overview

`require_role(*allowed_roles)` is a FastAPI dependency factory used to protect endpoints based on a user’s role.

This test suite ensures:

- Users with allowed roles can access protected endpoints.
- Users with disallowed roles receive `403 Forbidden`.
- Missing or invalid authentication produces `401 Unauthorized`.
- Admin impersonation (view-as) is supported and affects “effective” identity fields while still permitting access according to the admin’s real role.
- Database failures during impersonation role lookup return `500 Internal Server Error`.
- The dependency returns a user dict enriched with:
  - `effective_account_id`
  - `effective_role_id`

## Architecture / Design

### Test App and Protected Endpoint

A small isolated FastAPI app is created within the test module:

- Route: `GET /protected`
- Dependency: `Depends(require_role(2, 4))`

This endpoint requires either:

- Researcher role (`RoleID = 2`)
- Admin role (`RoleID = 4`)

The endpoint returns a subset of the user fields to make assertions explicit:

- `account_id`
- `effective_account_id`
- `effective_role_id`

This design keeps tests focused on the dependency behavior without relying on the main application router setup.

### Mocking Strategy

All DB interactions are mocked via:

- `@patch("app.api.deps.get_db_connection")`

The helper `_mock_auth_and_role(...)` configures the patched `get_db_connection` to simulate the underlying `get_current_user` and `require_role` flows:

- **Connection 1**: used by `get_current_user` to fetch session/user details, including:
  - `RoleID`
  - `ViewingAsUserID`

- **Connection 2** (conditional): only used when `ViewingAsUserID` is set, to look up the role of the impersonated account via `_get_role_for_account()`.

The mock uses `mock_db.side_effect` to return connections in sequence, matching the production call order.

### Session/User Record Shape (Inferred)

The session lookup returns a dict-like row with at least:

- `AccountID: int`
- `Email: str`
- `TosAcceptedAt: str | datetime-like`
- `TosVersion: str`
- `RoleID: int`
- `ViewingAsUserID: int | None`

When impersonating, the role lookup returns a dict-like row:

- `RoleID: int`

## Configuration

No special configuration beyond pytest is required.

Run all tests:

```bash
pytest -q