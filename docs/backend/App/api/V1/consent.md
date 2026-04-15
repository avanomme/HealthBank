# `markdown/consent.md` — Consent API (`backend/app/api/v1/consent.py`)

## Overview

`backend/app/api/v1/consent.py` implements consent tracking for end users.

It provides:

- A status endpoint to determine whether the authenticated user has signed the **current** consent version.
- A submit endpoint to record a signed consent form, storing the signed document content and updating the user’s account record.

**System Admin users (RoleID = 4) are exempt** from consent requirements and cannot submit consent via this API.

---

## Architecture / Design Explanation

### Consent Versioning

- The current consent version is defined by:
  - `CURRENT_CONSENT_VERSION = os.getenv("CURRENT_CONSENT_VERSION", "1.0")`

Users are considered compliant when their stored consent version matches the current version.

### Data Storage Strategy

Consent signing is stored in two places:

1. **ConsentRecord** (append-only history)
   - Stores the consent document text, language, signature name, timestamp, IP, and user agent.
2. **AccountData** (current status)
   - Stores `ConsentSignedAt` and `ConsentVersion` for quick checks.

The submit endpoint performs:

- `INSERT` into `ConsentRecord`
- `UPDATE` of `AccountData`

in a single transaction to keep the account status consistent with the recorded consent record.

### IP Address Handling

- The submit endpoint extracts IP using:
  - `X-Forwarded-For` (first value) if present, otherwise `request.client.host`.
- IP is stored as packed binary bytes for VARBINARY fields using `ipaddress.ip_address(ip).packed`.
- Invalid IP strings are stored as `NULL`.

### Authorization Model

- Both endpoints require an authenticated user via `Depends(get_current_user)`.
- RoleID 4 (system admin) receives:
  - Status: always treated as compliant (`needs_consent = False`)
  - Submit: rejected with `400` ("Admin users do not need to sign consent")

---

## Configuration (if applicable)

### Environment Variables

#### `CURRENT_CONSENT_VERSION`

- Controls which consent version is considered “current”.
- Default if unset: `"1.0"`.

Changing this value causes users with older `AccountData.ConsentVersion` values to be marked as needing consent again.

---

## API Reference

All endpoints are mounted under `/api/v1/consent`.

### `GET /api/v1/consent/status`

Checks whether the authenticated user has signed the current consent version.

**Auth**
- Requires a valid authenticated session (via `get_current_user`).

**Role behavior**
- If `user.role_id == 4`: always returns compliant.

**Response model:** `ConsentStatusResponse`

**Response fields**
- `has_signed_consent: bool`
- `consent_version: str | None`
- `consent_signed_at: str | None` (ISO timestamp)
- `current_version: str`
- `needs_consent: bool`

---

### `POST /api/v1/consent/submit`

Records a signed consent form.

- Inserts a row into `ConsentRecord`.
- Updates `AccountData.ConsentSignedAt` and `AccountData.ConsentVersion`.
- Stores IP address (packed binary) and user agent.

**Auth**
- Requires a valid authenticated session (via `get_current_user`).

**Role behavior**
- If `user.role_id == 4`: rejected with `400`.

**Request model:** `ConsentSubmitRequest`

**Request fields**
- `document_text: str` (min length 10)
- `document_language: "en" | "fr"` (validated by regex `^(en|fr)$`)
- `signature_name: str` (1–128), sanitized via `sanitized_string`

**Response model:** `ConsentSubmitResponse`

**Response fields**
- `accepted: bool`
- `version: str`
- `consent_record_id: int`

**Status code**
- `201 Created`

---

## Parameters and Return Types

### Helper: `ip_to_varbinary(ip: str | None) -> bytes | None`

- **Parameters**
  - `ip: str | None`
- **Returns**
  - `bytes | None`
  - Returns `None` for missing or invalid IP strings.

### `ConsentStatusResponse`

- `has_signed_consent: bool`
- `consent_version: Optional[str]`
- `consent_signed_at: Optional[str]`
- `current_version: str`
- `needs_consent: bool`

### `ConsentSubmitRequest`

- `document_text: str`
- `document_language: str` (must match `en` or `fr`)
- `signature_name: str` (sanitized)

### `ConsentSubmitResponse`

- `accepted: bool`
- `version: str`
- `consent_record_id: int`

---

## Error Handling

### `GET /status`

- Does not explicitly catch DB errors; unexpected database failures will typically propagate as `500` responses via FastAPI defaults or global handlers.

### `POST /submit`

- `400 Bad Request`
  - When the authenticated user has `role_id == 4` (admins do not sign consent).

- `422 Unprocessable Entity`
  - When request validation fails (e.g., language not `en|fr`, too-short document text, missing fields).

- `500 Internal Server Error`
  - On `mysql.connector.Error`, transaction is rolled back and the response detail is:
    - `"Failed to record consent"`

---

## Usage Examples (only where helpful)

### Check consent status

```bash
curl -s -H "Authorization: Bearer <token>" \
  http://localhost:8000/api/v1/consent/status