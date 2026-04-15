# Terms of Service API Tests (`tos_accept`)

Unit test suite for the Terms of Service acceptance endpoint:

- `POST /api/v1/tos/accept`

These tests validate authentication enforcement, correct database updates (version, timestamp, accepted IP), IP extraction logic (including IPv4/IPv6 and invalid inputs), and transaction handling.

## Overview

The TOS acceptance endpoint records that an authenticated user accepted the current Terms of Service version. The endpoint is expected to:

- Require authentication (`get_current_user`)
- Update the user’s account record with:
  - acceptance timestamp
  - accepted TOS version (`CURRENT_TOS_VERSION`)
  - accepted IP address (stored in binary form, or `NULL` if unavailable/invalid)
- Commit the transaction and close DB resources
- Return a JSON response indicating acceptance and the version that was accepted

The test suite uses dependency overrides to simulate authentication outcomes and patches DB access within the TOS module.

## Architecture / Design

### Dependency Override Pattern

Most tests override `get_current_user` on the test client’s app:

- Successful auth: `lambda: mock_user`
- Unauthenticated: override to a function raising `HTTPException(401)`

Overrides are always cleared in a `finally:` block to prevent cross-test contamination:

- `client.app.dependency_overrides.clear()`

### Database Mocking

Database access is patched at:

- `app.api.v1.tos.get_db_connection`

The tests assume the endpoint uses a DB-API style connection:

- `conn.cursor() -> cursor`
- `cursor.execute(sql, params)`
- `conn.commit()`
- `cursor.close()`, `conn.close()`

The tests inspect the SQL string and parameters passed to `execute(...)` to ensure:

- Correct table/columns are updated
- Correct parameter ordering is used (version, ip_binary, account_id)

### IP Handling

The endpoint is expected to accept IP addresses via:

- `x-forwarded-for` header (comma-separated list; use the first IP)
- Fallback to `request.client.host` when header is absent

IP conversion is performed using `ipaddress.ip_address(...).packed`, yielding:

- 4 bytes for IPv4
- 16 bytes for IPv6

If the IP is invalid, the endpoint should store `None` for the IP column (rather than failing the request).

## Configuration

Run all tests:

```bash
pytest -q