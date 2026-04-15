# Pytest Shared Fixtures (`backend/tests/conftest.py`)

Shared `pytest` fixtures for backend API tests.

This `conftest.py` centralizes common setup logic used across test modules to:

- Prevent tests from connecting to a real MySQL instance
- Provide a default authenticated admin user for most API tests
- Reset in-memory mock database state between tests
- Reset rate-limit buckets between tests
- Provide common data fixtures (questions, surveys, templates, assignments)
- Provide a standard FastAPI `TestClient` fixture

## Overview

This file primarily provides three global testing behaviors (enabled via `autouse=True` fixtures):

1. **DB patching at all import sites** (`mock_db`)
2. **Default authentication override** (`mock_auth`)
3. **Global in-memory state resets** (`reset_rate_limit`, `reset_fake_db_state`)

Tests that specifically validate authentication behavior can opt out of the default auth override by removing the dependency override within their own autouse fixture.

## Architecture / Design

### 1) DB patching across import sites

#### Problem addressed

Python’s `from X import Y` creates a module-local binding. If a module imports `get_db_connection` directly, patching only the original definition does not affect the already-imported local reference.

#### Solution used here

`mock_db` patches `get_db_connection` at every known import site listed in `_DB_IMPORT_SITES`.

- Each target is patched with `return_value=FakeConnection()`
- Patch attempts that fail (module not present yet) are ignored
- Patches are started before each test and stopped after each test

This ensures no test accidentally hits the real database, even when different modules import the DB factory independently.

#### Covered import sites

The list includes:

- Utility layer: `app.utils.utils.get_db_connection`
- API routers: `app.api.v1.*.get_db_connection`
- Dependency module: `app.api.deps.get_db_connection`
- Services/middleware/audit utilities: `app.services.aggregation.get_db_connection`, etc.

### 2) Default authentication override

#### Purpose

Most API endpoints are protected by role-based dependencies such as `require_role()`. To avoid repeating authentication setup in every test, this file overrides authentication globally by default.

#### How it works

`mock_auth` overrides:

- `app.api.deps.get_current_user`

to always return `MOCK_ADMIN_USER`.

Because `MOCK_ADMIN_USER` has `role_id = 4` (admin), it passes most `require_role(...)` checks.

#### Opting out for auth tests

Some test modules validate real auth behavior and must remove this override. The docstring includes a canonical pattern:

```python
@pytest.fixture(autouse=True)
def clear_auth_override():
    from app.main import app
    from app.api.deps import get_current_user
    app.dependency_overrides.pop(get_current_user, None)
    yield