# Admin Password Reset Tests (`backend/tests/test_admin_password_reset.py`)

Unit tests for the admin password reset functionality exposed by the admin API.

This module validates:

- Resetting a user password via an admin endpoint
- Sending a reset/temporary-password email via an admin endpoint
- Basic input validation behavior (Pydantic 422 responses)
- Failure modes for missing users and email-service errors
- Password hashing utility expectations (salted hashes, expected encoding format)

## Overview

The tests focus on two admin endpoints:

1. `POST /api/v1/admin/users/{user_id}/reset-password`
2. `POST /api/v1/admin/users/{user_id}/send-reset-email`

Additionally, the module includes unit tests for the password hashing helper in `app.api.v1.auth.hash_password`.

The tests use FastAPI’s `TestClient` with patched dependencies for database and email behavior.

## Mocking Strategy

### Database

Database calls are isolated by patching:

- `app.api.v1.admin.get_db_connection`

The mocked cursor simulates:

- `cursor.fetchone()` returning tuples for `SELECT AuthID ...`
- `cursor.fetchone()` returning `(FirstName, Email)` tuples for email sending
- `cursor.rowcount` being used to confirm `UPDATE` success

### Email Service

Email sending is isolated by patching:

- `app.api.v1.admin.get_email_service`

The returned service object is expected to expose:

- `send_email(...)` as an async method

The tests simulate both success and failure by controlling the return object:

- `result.success == True` for success
- `result.success == False` for failure with `result.message`

### Server exception handling

One test (`test_send_email_service_not_configured`) intentionally creates:

```python
client = TestClient(app, raise_server_exceptions=False)