# Sessions API

API endpoints for session management and authentication.

## Endpoints

### Create Session

```
POST /api/v1/sessions/create
```

Create a new session token for an account.

**Request Body**:
```json
{
  "account_id": 42
}
```

**Response** (201 Created):
```json
{
  "session_token": "abc123...",
  "expires_at": "2024-01-29T12:00:00",
  "account_id": 42,
  "first_name": "John",
  "last_name": "Doe",
  "email": "john@example.com",
  "role": "participant"
}
```

**Note**: The session token is also set as an HTTP-only cookie.

---

### Validate Session

```
POST /api/v1/sessions/validate
```

Validate a session token and check if it's still active.

**Request Body** (optional if using cookie):
```json
{
  "token": "abc123..."
}
```

**Response** (200 OK):
```json
{
  "valid": true,
  "account_id": 42
}
```

**Error Responses**:
| Code | Description |
|------|-------------|
| 401 | No token provided, invalid token, or expired session |
| 500 | Database error |

---

### Get Current Session Info

```
GET /api/v1/sessions/me
```

Get information about the current session including user details and impersonation status.

**Request Headers**:
- `Cookie: session_token=<token>` or
- `Authorization: Bearer <token>`

**Response** (200 OK) - Normal Session:
```json
{
  "user": {
    "account_id": 42,
    "first_name": "John",
    "last_name": "Doe",
    "email": "john@example.com",
    "role": "participant",
    "role_id": 1
  },
  "is_impersonating": false,
  "impersonation_info": null,
  "session_expires_at": "2024-01-29T12:00:00"
}
```

**Response** (200 OK) - Impersonation Session:
```json
{
  "user": {
    "account_id": 42,
    "first_name": "John",
    "last_name": "Doe",
    "email": "john@example.com",
    "role": "participant",
    "role_id": 1
  },
  "is_impersonating": true,
  "impersonation_info": {
    "admin_account_id": 1,
    "admin_first_name": "Admin",
    "admin_last_name": "User",
    "admin_email": "admin@healthbank.com"
  },
  "session_expires_at": "2024-01-29T12:00:00"
}
```

**Fields**:
| Field | Type | Description |
|-------|------|-------------|
| `user` | object | Current session's user information |
| `user.account_id` | int | User's account ID |
| `user.first_name` | string | User's first name |
| `user.last_name` | string | User's last name |
| `user.email` | string | User's email address |
| `user.role` | string | User's role name (participant, researcher, hcp, admin) |
| `user.role_id` | int | User's role ID (1-4) |
| `is_impersonating` | bool | True if this is an impersonation session |
| `impersonation_info` | object? | Info about the admin who initiated impersonation (null if not impersonating) |
| `session_expires_at` | string | ISO timestamp when the session expires |

**Error Responses**:
| Code | Description |
|------|-------------|
| 401 | Not authenticated or session expired |
| 500 | Database error |

---

### Logout

```
DELETE /api/v1/sessions/logout
```

Invalidate the current session and log out.

**Request Body** (optional if using cookie):
```json
{
  "token": "abc123..."
}
```

**Response** (200 OK):
```json
{
  "message": "logged out"
}
```

**Note**: This also clears the session cookie.

**Error Responses**:
| Code | Description |
|------|-------------|
| 401 | No token provided |
| 404 | Session not found |
| 500 | Database error |

## Session Configuration

| Setting | Value | Description |
|---------|-------|-------------|
| Expiry | 1 hour | Sessions expire after 1 hour of inactivity |
| Cookie | HTTP-only | Session cookies are HTTP-only for XSS protection |
| SameSite | strict | CSRF protection via SameSite cookie attribute |

## Role IDs

| Role ID | Role Name | Description |
|---------|-----------|-------------|
| 1 | participant | Standard user who takes surveys |
| 2 | researcher | Creates and manages surveys |
| 3 | hcp | Healthcare professional with elevated access |
| 4 | admin | Full system access (system administrator) |

## Impersonation

When a system administrator impersonates a user:

1. A new session is created with `ImpersonatedBy` set to the admin's account ID
2. The `/sessions/me` endpoint returns `is_impersonating: true`
3. The `impersonation_info` object contains the admin's details
4. The frontend should show an impersonation banner
5. Calling `/admin/impersonate/end` terminates the impersonation session
