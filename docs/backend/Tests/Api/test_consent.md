# Consent API Unit Tests (`backend/tests/api/test_consent.py`)

## Overview

This module contains unit tests for the Consent API, covering:

- `GET  /api/v1/consent/status` — determine whether the current user has signed the latest consent
- `POST /api/v1/consent/submit` — submit and store a signed consent document

The tests validate role-based behavior (admin vs participant/researcher/HCP), consent versioning, authentication enforcement, and correct persistence behavior (database writes and audit fields such as IP and document text).

---

## Architecture / Design

### Test style

- Uses FastAPI route calls through a `client` fixture (FastAPI `TestClient`), assumed to exist elsewhere.
- Uses `app.dependency_overrides` to control authentication behavior via `get_current_user`.
- Uses `unittest.mock.patch` to isolate persistence and side-effects:
  - `app.api.v1.consent.get_db_connection` is patched to return mocked connections/cursors.
- Asserts behavior via:
  - HTTP status codes
  - response JSON content
  - database cursor call counts and SQL parameter values

### Roles and consent logic modeled by tests

The tests imply the following role semantics:

- `RoleID=4` (admin): does not require consent; status always reports consent as signed.
- `RoleID=1` (participant), `RoleID=2` (researcher), `RoleID=3` (HCP): consent required depending on stored consent record and version.

Consent versioning behavior is implied:

- Latest consent version is expected to be `"1.0"` (asserted in submit success test).
- If stored consent version is older (e.g., `"0.9"`), the user should be required to re-consent.

---

## Configuration

### Authentication control

Tests override `get_current_user`:

- For authenticated behavior: override returns a dict containing:
  - `account_id: int`
  - `email: str`
  - `role_id: int`
  - `viewing_as_user_id: int | None`
  - `tos_accepted_at: datetime | None`
  - `tos_version: str | None`

- For unauthenticated behavior: override raises `HTTPException(status_code=401, ...)`

Overrides are wrapped in `try/finally` blocks to ensure cleanup.

### Database mocking

Database access is patched via:

- `patch("app.api.v1.consent.get_db_connection")`

The patched connection provides:

- `conn.cursor()` returning a `MagicMock` cursor
- cursor `.fetchone()` returning either consent status data or `None` depending on scenario
- cursor `.lastrowid` used to simulate created consent record ID
- cursor `.execute.call_args_list` used to inspect SQL parameters
- `conn.commit()` asserted when writes occur

---

## API Reference

### `GET /api/v1/consent/status`

Returns consent status for the current authenticated user.

**Authentication**
- Requires authentication; unauthenticated requests return `401`.

**Role-specific behavior**
- Admin (`role_id == 4`):
  - `has_signed_consent == True`
  - `needs_consent == False`

- Non-admin roles:
  - Status depends on stored consent record (via DB lookup of consent timestamp/version).

**Response fields asserted**
- `has_signed_consent: bool`
- `needs_consent: bool`
- `consent_version: str | None` (explicitly asserted in some cases)

**Behavior cases tested**
- Participant with no consent record:
  - `has_signed_consent == False`
  - `needs_consent == True`
  - `consent_version == None`

- Participant with current consent version `"1.0"`:
  - `has_signed_consent == True`
  - `needs_consent == False`
  - `consent_version == "1.0"`

- Participant with older consent version `"0.9"`:
  - `has_signed_consent == False`
  - `needs_consent == True`

---

### `POST /api/v1/consent/submit`

Submits consent for the current authenticated user and persists it.

**Authentication**
- Requires authentication; unauthenticated requests return `401`.

**Role restrictions**
- Admin (`role_id == 4`) cannot submit consent:
  - returns `400`
  - response JSON `detail` contains `"Admin"`

**Request JSON fields**
- `document_text: str` (must be long enough; too-short rejected)
- `document_language: str` (allowed values tested: `"en"`, `"fr"`)
- `signature_name: str`

**Success response**
- `201 Created`
- JSON fields asserted:
  - `accepted: bool` (must be `True`)
  - `consent_record_id: int` (from cursor `.lastrowid`)
  - `version: str` (expected `"1.0"`)

**Persistence behavior asserted**
- Two DB operations are expected:
  1) INSERT consent record
  2) UPDATE account data (e.g., consent metadata on the account)
- `cursor.execute.call_count == 2`
- `conn.commit()` called exactly once

**Language validation**
- `"en"` accepted
- `"fr"` accepted
- `"de"` rejected with `422`

**Document text validation**
- Very short document text rejected with `422`

**IP capture**
- When request includes `x-forwarded-for`, the IP should be stored as packed binary bytes.
- The test asserts the INSERT parameter list contains `ipaddress.ip_address(header_value).packed` at index `6`.

**Document storage**
- The full `document_text` should be included verbatim in the INSERT parameters at index `4`.

---

## Parameters and Return Types

### `GET /api/v1/consent/status`

**Returns**
- `dict[str, Any]` including at least:
  - `has_signed_consent: bool`
  - `needs_consent: bool`
  - `consent_version: str | None`

### `POST /api/v1/consent/submit`

**Parameters**
- `document_text: str`
- `document_language: Literal["en","fr"]` (as implied by tests)
- `signature_name: str`

**Returns on success**
- `dict[str, Any]` including:
  - `accepted: bool`
  - `consent_record_id: int`
  - `version: str`

---

## Error Handling

The tests define intended error semantics:

- `401 Unauthorized`
  - when `get_current_user` raises `HTTPException(401, ...)`
- `400 Bad Request`
  - when an admin attempts to submit consent
- `422 Unprocessable Entity`
  - invalid language codes (e.g., `"de"`)
  - document text too short (e.g., `"short"`)
  - other request body validation failures (implied)

---

## Usage Examples

### Run only this file

```bash
pytest backend/tests/api/test_consent.py -q