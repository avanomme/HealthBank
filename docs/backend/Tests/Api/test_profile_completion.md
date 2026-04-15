# Profile Completion API Tests (`test_profile_completion.py`)

Tests for the profile completion workflow in the FastAPI backend, covering:

- `POST /api/v1/auth/complete_profile` (participants completing required profile fields)
- `POST /api/v1/auth/login` response containing `needs_profile_completion`

This test suite validates role-based access control for profile completion and verifies the login payload includes a computed `needs_profile_completion` flag for participants with incomplete profile data.

## Overview

The repository includes an authentication flow where **participants** must provide certain demographic fields (birthdate and gender). The backend exposes:

- An endpoint to complete a participant profile (`/auth/complete_profile`)
- A login endpoint (`/auth/login`) that returns a boolean flag:
  - `needs_profile_completion = True` when the account is a participant and profile fields are missing
  - `needs_profile_completion = False` otherwise

The tests use `fastapi.testclient.TestClient` against `app.main.app` and mock database access using `unittest.mock.patch`.

## Architecture / Design

### Test Structure

The file is organized into two test classes:

- `TestCompleteProfile`
  - Focused on `POST /api/v1/auth/complete_profile`
  - Validates:
    - Participants can submit required fields successfully
    - Non-participants (researcher, HCP) are rejected with `403`
    - Missing/invalid request payloads yield `422` from FastAPI/Pydantic validation

- `TestLoginNeedsProfileCompletion`
  - Focused on `POST /api/v1/auth/login`
  - Validates:
    - Participants with missing `Birthdate` and/or `Gender` get `needs_profile_completion=True`
    - Participants with both fields set get `needs_profile_completion=False`
    - Researchers never receive `needs_profile_completion=True` even if profile fields are null

### Database Mocking Model

The tests patch database connection functions in API modules:

- `app.api.v1.auth.get_db_connection`
  - Used for authentication and profile completion flows
- `app.api.v1.sessions.get_db_connection`
  - Used during session creation (e.g., `create_session_for_account` and user lookup)

Mocks emulate a DB-API style connection and cursor:

- `conn.cursor()` returns `cursor`
- `cursor.fetchone()` is configured to return specific tuples expected by the application code
- `cursor.execute(...)` calls are inspected in some cases to confirm SQL updates were attempted

### Dependency Overrides

`TestLoginNeedsProfileCompletion` includes an `autouse` fixture that removes any dependency override for `get_current_user`, ensuring the login tests exercise the real authentication flow:

- Removes `app.dependency_overrides[get_current_user]` if present

This is important if other tests in the suite globally override authentication.

## Configuration

No additional configuration is required beyond standard pytest execution, assuming:

- The FastAPI application is importable at `app.main:app`
- The API modules expose `get_db_connection` functions at:
  - `app.api.v1.auth.get_db_connection`
  - `app.api.v1.sessions.get_db_connection`

To run this file as part of the test suite:

```bash
pytest -q