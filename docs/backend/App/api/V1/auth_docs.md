# Authentication & Account Management API

API endpoints for account creation, authentication, session handling, and password reset workflows.

These endpoints are implemented in FastAPI and handle core authentication and credential management for the application.

---

## Overview

This module provides functionality for:

- Creating user accounts
- Authenticating users (login)
- Deleting accounts
- Requesting password reset emails
- Validating password reset tokens
- Confirming password resets

Password security is handled using PBKDF2 with per-user cryptographic salts.

---

## Security Notes

- Passwords are never stored in plaintext.
- Password hashing uses `pbkdf2_hmac` with SHA-256.
- Each password hash includes a unique random salt.
- Login attempts are rate-limited by IP address.
- Password reset flows avoid account enumeration.
- Password reset tokens are invalidated after use.

---

## Rate Limiting

The login endpoint is protected by IP-based rate limiting:

- **10 attempts per 60 seconds per IP**

This is enforced using dependency-based rate limiting.

---

## Base Path

The router defines the following relative paths:

- `POST /create_account`
- `DELETE /account/{account_id}`
- `POST /login`
- `POST /password_reset_request`
- `POST /validate_password_reset`
- `POST /confirm_password_reset`

The full request path depends on where the router is mounted (typically `/api/v1/auth/...`).

---

## Data Models

### AccountCreate

| Field | Type | Required | Constraints |
|------|------|----------|-------------|
| `first_name` | string | Yes | 1–100 characters |
| `last_name` | string | Yes | 1–100 characters |
| `email` | email | Yes | Valid email format |
| `password` | string | Yes | Minimum 8 characters |

Example:
```json
{
  "first_name": "Jane",
  "last_name": "Doe",
  "email": "jane@example.com",
  "password": "securepassword123"
}
```

---

### Login

| Field | Type | Required | Constraints |
|------|------|----------|-------------|
| `email` | email | Yes | Valid email format |
| `password` | string | Yes | Minimum 8 characters |

Example:
```json
{
  "email": "jane@example.com",
  "password": "securepassword123"
}
```

---

### PasswordResetRequest

| Field | Type | Required | Description |
|------|------|----------|-------------|
| `email` | email | Yes | Account email |

Example:
```json
{
  "email": "jane@example.com"
}
```

---

### PasswordResetValidate

| Field | Type | Required | Constraints |
|------|------|----------|-------------|
| `token` | string | Yes | 10–200 characters |

Example:
```json
{
  "token": "reset-token-value"
}
```

---

### PasswordResetConfirm

| Field | Type | Required | Constraints |
|------|------|----------|-------------|
| `token` | string | Yes | 10–200 characters |
| `new_password` | string | Yes | Minimum 8 characters |

Example:
```json
{
  "token": "reset-token-value",
  "new_password": "newsecurepassword123"
}
```

---

## Endpoints

### Create Account

```
POST /create_account
```

Creates a new user account.

#### Behavior

- Hashes the provided password
- Inserts credentials into the `Auth` table
- Inserts user metadata into `AccountData`
- Returns the new account ID

#### Response (201 Created)

```json
{
  "message": "account created successfully!",
  "account_id": 123
}
```

#### Error Responses

| Status Code | Description |
|------------|-------------|
| 409 | Email already exists |
| 500 | Account creation failed |

---

### Delete Account

```
DELETE /account/{account_id}
```

Deletes an account by ID.

#### Path Parameters

| Parameter | Type | Description |
|----------|------|-------------|
| `account_id` | int | Account identifier |

#### Behavior

- Deletes the account record
- Returns 404 if the account does not exist

#### Response

- `204 No Content` on success

#### Error Responses

| Status Code | Description |
|------------|-------------|
| 404 | Account not found |
| 500 | Delete failed |

---

### Login

```
POST /login
```

Authenticates a user and creates a session.

#### Rate Limiting

- 10 requests per 60 seconds per IP

#### Behavior

- Validates email and password
- Updates `LastLogin` timestamp
- Creates a session record
- Sets a session cookie
- Returns session metadata

#### Response (200 OK)

```json
{
  "session_token": "abc123...",
  "expires_at": "2024-01-29T12:00:00",
  "account_id": 123
}
```

#### Error Responses

| Status Code | Description |
|------------|-------------|
| 401 | Invalid email or password |
| 500 | Login failed |

---

### Request Password Reset

```
POST /password_reset_request
```

Requests a password reset email.

#### Security Behavior

- Always returns a success response
- Prevents account enumeration
- Sends a reset link if the account exists

#### Response (202 Accepted)

```json
{
  "message": "If an account exists for that email, a reset link has been sent."
}
```

---

### Validate Password Reset Token

```
POST /validate_password_reset
```

Checks whether a password reset token is valid.

#### Request Body

```json
{
  "token": "reset-token-value"
}
```

#### Response (200 OK)

```json
{
  "valid": true
}
```

#### Error Responses

| Status Code | Description |
|------------|-------------|
| 400 | Invalid or expired reset token |

---

### Confirm Password Reset

```
POST /confirm_password_reset
```

Sets a new password using a valid reset token.

#### Behavior

- Validates reset token
- Hashes the new password
- Updates the password
- Invalidates the reset token

#### Response (200 OK)

```json
{
  "message": "Password has been reset successfully."
}
```

#### Error Responses

| Status Code | Description |
|------------|-------------|
| 400 | Invalid or expired reset token |
| 500 | Failed to reset password |

---

## Password Hashing

Passwords are hashed using PBKDF2 with SHA-256.

### Hash Format

```
pbkdf2_sha256$iterations$dklen$salt$hash
```

### Parameters

- Iterations: `210000`
- Key length: `32 bytes`
- Salt: `32 bytes` (generated using `os.urandom`)

### Verification

Password verification uses constant-time comparison to prevent timing attacks.

---

## Database Expectations

This module assumes the following tables exist:

- `Auth(AuthID, PasswordHash)`
- `AccountData(AccountID, FirstName, LastName, Email, AuthID, LastLogin, ...)`

---

## Implementation Notes

- Uses UTC timestamps for all stored times
- Designed to avoid leaking account existence
- Password reset tokens are single-use
- Session creation and cookie handling are delegated to shared session utilities

