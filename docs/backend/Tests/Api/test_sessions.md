# Session API Tests (`test_sessions.py`)

TDD-style test suite for session management endpoints implemented under `app/api/v1/sessions`.

Endpoints covered:

- `POST   /api/v1/sessions/validate` — validate a session token provided in the request body
- `DELETE /api/v1/sessions/logout` — logout using a cookie-based session token
- `GET    /api/v1/sessions/me` — fetch the current user/session info
- `POST   /api/v1/sessions/create` — explicitly verified as removed (should return `404` or `405`)

## Overview

The Session API supports:

- Stateless token validation (client submits token; server checks if session exists and is not expired)
- Cookie-based logout (client provides session cookie; server deletes session)
- A “me” endpoint that returns current user information, relying on authentication logic (not fully exercised here, as the test expects a `conftest` auth mock)

The tests focus on HTTP status codes and basic response shapes, while mocking database interactions and token hashing.

## Architecture / Design

### Test Structure

The module is organized into four test classes:

- `TestValidateSession`
  - Positive and negative validation of a provided token

- `TestLogoutSession`
  - Logout via cookie, including missing cookie and nonexistent session cases

- `TestSessionsCreateRemoved`
  - Ensures a legacy endpoint does not exist

- `TestGetSessionMe`
  - Verifies `/sessions/me` returns user info, with a note that `get_current_user` is mocked by `conftest`

### Mocking Strategy

The test suite patches functions from `app.api.v1.sessions`:

- `get_db_connection`
  - Used by all session endpoints to query/update the Sessions store

- `hash_token`
  - Patched in validate/logout tests to return a deterministic `"hashed"` value
  - Implies that production code hashes the provided raw token before querying/deleting sessions

Database mocking uses a DB-API style connection/cursor pattern:

- `conn.cursor()` returns `cursor`
- `cursor.fetchone()` returns dict-like rows in tests
- `cursor.rowcount` is used to determine whether a delete actually removed a session
- The tests do not assert commit behavior, but a real implementation would typically commit for deletes

### Time Handling

These tests use:

- `datetime.utcnow()` and `timedelta(hours=1)` to simulate an unexpired session

This implies the validate endpoint checks `ExpiresAt` against the current time.

## Configuration

Run all tests:

```bash
pytest -q