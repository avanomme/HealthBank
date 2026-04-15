# Two-Factor Authentication API (TOTP)

API endpoints for enrolling, confirming, verifying, and disabling Time-based One-Time Password (TOTP) two-factor authentication for accounts.

These endpoints are implemented in `app/api/v1/two_factor.py` using FastAPI and `pyotp`.

---

## Overview

This module supports a standard TOTP authentication flow:

1. **Enroll**: Generate (or rotate) a new TOTP secret and return a provisioning URI.
2. **Confirm**: Validate an initial TOTP code and enable 2FA.
3. **Verify**: Validate a TOTP code during login after password verification.
4. **Disable**: Disable 2FA for an account (management endpoint).

---

## Security Notes

- TOTP secrets are stored encrypted in the database.
- Encryption uses a master key loaded from the `2FA_MASTER_KEY` environment variable.
- Re-enrolling in 2FA rotates the secret and resets verification state.
- The disable endpoint is intentionally marked as requiring stronger authorization in the future (password + 2FA or admin token).

---

## Base Path

The router defines relative paths:

- `POST /enroll`
- `POST /confirm`
- `POST /verify`
- `POST /disable`

The full request path depends on where the router is mounted (typically `/api/v1/two_factor/...`).

---

## Data Models

### Enroll2FA

| Field | Type | Required | Description |
|------|------|----------|-------------|
| `account_email` | email | Yes | Email address used to locate the account and shown in the authenticator app |

Example:
```json
{
  "account_email": "user@example.com"
}
```

---

### Confirm2FA

| Field | Type | Required | Constraints | Description |
|------|------|----------|------------|-------------|
| `account_id` | int | Yes | `> 0` | Account identifier |
| `code` | string | Yes | 6 digits (`^\d{6}$`) | TOTP code from authenticator |

Example:
```json
{
  "account_id": 42,
  "code": "123456"
}
```

---

### Verify2FA

Same structure as `Confirm2FA`.

Example:
```json
{
  "account_id": 42,
  "code": "123456"
}
```

---

### Disable

| Field | Type | Required | Description |
|------|------|----------|-------------|
| `account_email` | email | Yes | Email address used to locate the account |

Example:
```json
{
  "account_email": "user@example.com"
}
```

---

## Endpoints

### Enroll 2FA

```
POST /enroll
```

Creates (or rotates) a TOTP secret and returns a provisioning URI. The frontend should render a QR code from the returned URI.

#### Request Body

```json
{
  "account_email": "user@example.com"
}
```

#### Behavior

- Looks up an active account by email
- Generates a new TOTP secret
- Encrypts and stores the secret
- Upserts into `Account2FA`
- Disables 2FA until confirmation
- Returns a provisioning URI compatible with authenticator apps

#### Response (201 Created)

```json
{
  "provisioning_uri": "otpauth://totp/MySimple2FA:user%40example.com?secret=...&issuer=MySimple2FA"
}
```

#### Error Responses

| Status Code | Description |
|------------|-------------|
| 404 | Account not found for that email |
| 500 | Failed to enroll 2FA |

---

### Confirm 2FA

```
POST /confirm
```

Confirms enrollment by validating a TOTP code. Enables 2FA if the code is valid.

#### Request Body

```json
{
  "account_id": 42,
  "code": "123456"
}
```

#### Behavior

- Retrieves the encrypted TOTP secret
- Decrypts the secret using `2FA_MASTER_KEY`
- Verifies the provided code with a small clock-drift tolerance
- Enables 2FA and records verification timestamps

#### Response (200 OK)

```json
{
  "message": "2FA enabled"
}
```

#### Error Responses

| Status Code | Description |
|------------|-------------|
| 404 | 2FA not enrolled |
| 401 | Invalid 2FA code |
| 500 | Failed to confirm 2FA |

---

### Verify 2FA

```
POST /verify
```

Verifies a TOTP code for an account. Intended to be called during login after password verification.

#### Request Body

```json
{
  "account_id": 42,
  "code": "123456"
}
```

#### Behavior

- Loads the TOTP secret and enabled state
- Rejects requests if 2FA is not enrolled or not enabled
- Verifies the provided code
- Updates `LastUsedAt` on success (best-effort)

#### Response (200 OK)

```json
{
  "valid": true
}
```

#### Error Responses

| Status Code | Description |
|------------|-------------|
| 404 | 2FA not enrolled |
| 409 | 2FA not enabled |
| 401 | Invalid 2FA code |
| 500 | Failed to verify 2FA |

---

### Disable 2FA

```
POST /disable
```

Disables two-factor authentication for an account.

#### Authorization Warning

This endpoint is a management endpoint and should be protected by stronger authorization controls.

#### Request Body

```json
{
  "account_email": "user@example.com"
}
```

#### Behavior

- Locates an active account by email
- Sets `IsEnabled = 0` in `Account2FA`
- Returns 404 if the account or 2FA record does not exist

#### Response (200 OK)

```json
{
  "message": "2FA disabled"
}
```

#### Error Responses

| Status Code | Description |
|------------|-------------|
| 404 | Account not found or 2FA not found |
| 500 | Failed to disable 2FA |

---

## Database Expectations

This module assumes the existence of the following tables:

- `AccountData(AccountID, Email, IsActive, ...)`
- `Account2FA(AccountID, TotpSecret, IsEnabled, CreatedAt, VerifiedAt, LastUsedAt, ...)`

### Account2FA State Semantics

- **Enroll**
  - Rotates secret
  - Sets `IsEnabled = 0`
  - Clears `VerifiedAt` and `LastUsedAt`
- **Confirm**
  - Sets `IsEnabled = 1`
  - Sets `VerifiedAt` and `LastUsedAt`
- **Verify**
  - Updates `LastUsedAt` on success

---

## Implementation Notes

- Issuer name used in authenticator apps: `HealthDataBank`
- TOTP verification uses `valid_window = 1` to tolerate small clock drift
- Encryption key is read from the `2FA_MASTER_KEY` environment variable
