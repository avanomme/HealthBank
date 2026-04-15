# User API Tests (`users.py`)

Tests for User API endpoints implemented in `app/api/v1/users.py`.

This module currently focuses on the **update user** behavior (`PUT /api/v1/users/{id}`), but the header comment indicates the broader API surface expected for the Users feature:

- `POST   /api/v1/users` — Create user
- `PUT    /api/v1/users/{id}` — Update user
- `GET    /api/v1/users` — List users
- `GET    /api/v1/users/{id}` — Get single user
- `PATCH  /api/v1/users/{id}/status` — Toggle user active status
- `DELETE /api/v1/users/{id}` — Delete user

## Overview

The Users API supports CRUD-style management of accounts and includes:

- Creating users with identity fields, credentials, and role assignment
- Updating existing users (including role changes and email changes)
- Enforcing uniqueness constraints such as email uniqueness
- Handling not-found updates appropriately

This test file uses an **in-memory fake DB** (via `FakeCursor`) for at least some tests. It asserts both successful update paths and failure paths such as updating nonexistent users and attempting to reuse an email already taken by another user.

## Architecture / Design

### Test Client

Tests use FastAPI’s `TestClient` against the real application instance:

- `from app.main import app`
- `TestClient(app)`

The class defines a `client` fixture, but the test methods also receive `client` as an argument, implying that a `client` fixture may be defined at a higher level (e.g., `conftest.py`) and/or the class fixture is intended to provide it.

### In-Memory Mock DB

The test module imports:

- `from ..mocks.db import FakeCursor`

`FakeCursor.accounts` appears to store account records in-memory and is used for debugging prints:

- `print('All accounts before update:', dict(FakeCursor.accounts))`

A successful update test references additional fixtures:

- `mock_db`
- `reset_fake_db_state`

These are not defined in this module, so they are expected to come from a shared test configuration (typically `conftest.py`). Their intended roles (inferred):

- `mock_db`: patch the application’s DB connection to use `FakeCursor` and in-memory structures
- `reset_fake_db_state`: clear `FakeCursor.accounts` and other state between tests

### Behavior Under Test

The update tests imply the API:

- Allows partial updates (only fields included in the request are updated)
- Returns the updated user object in the response body
- Supports updating a user’s role (e.g., participant → researcher)
- Enforces email uniqueness across users
- Returns proper error codes for not-found and validation errors

## Configuration

Run all tests:

```bash
pytest -q