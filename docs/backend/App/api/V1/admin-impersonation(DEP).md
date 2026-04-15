# Admin Impersonation API

API endpoints for system administrators to impersonate users. This feature allows system admins to view the application as a specific user for support and debugging purposes.

## Security

**IMPORTANT**: Impersonation is restricted to System Administrators (RoleID = 4) only.

- Impersonation sessions are tracked via the `ImpersonatedBy` column in Sessions table
- All impersonated sessions can be audited
- Admins cannot impersonate themselves
- Inactive users cannot be impersonated

## Endpoints

### Start Impersonation

```
POST /api/v1/admin/users/{user_id}/impersonate
```

Start an impersonation session for a specific user.

**Authorization**: System Administrator (RoleID = 4) required

**Path Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `user_id` | int | AccountID of the user to impersonate |

**Request Headers**:
- `Cookie: session_token=<admin_token>` or
- `Authorization: Bearer <admin_token>`

**Response** (200 OK):
```json
{
  "message": "Impersonation session started",
  "session_token": "abc123...",
  "expires_at": "2024-01-29T12:00:00",
  "is_impersonating": true,
  "impersonated_user": {
    "account_id": 42,
    "first_name": "John",
    "last_name": "Doe",
    "email": "john@example.com",
    "role": "participant"
  },
  "admin_account_id": 1
}
```

**Error Responses**:
| Code | Description |
|------|-------------|
| 400 | Cannot impersonate yourself or inactive user |
| 401 | Not authenticated or invalid session |
| 403 | Not a system administrator |
| 404 | Target user not found |
| 500 | Database error |

---

### End Impersonation

```
POST /api/v1/admin/impersonate/end
```

End the current impersonation session and return to admin mode.

**Authorization**: Valid impersonation session required

**Request Headers**:
- `Cookie: session_token=<impersonation_token>` or
- `Authorization: Bearer <impersonation_token>`

**Response** (200 OK):
```json
{
  "message": "Impersonation session ended",
  "admin_account_id": 1
}
```

**Error Responses**:
| Code | Description |
|------|-------------|
| 400 | Not currently impersonating |
| 401 | Not authenticated or invalid session |
| 500 | Database error |

## Database Schema

The Sessions table includes an `ImpersonatedBy` column:

```sql
CREATE TABLE Sessions(
  SessionID INT PRIMARY KEY AUTO_INCREMENT,
  AccountID INT,
  TokenHash TEXT,
  CreatedAt DATETIME,
  ExpiresAt DATETIME,
  IpAddress VARCHAR(50),
  UserAgent VARCHAR(512),
  ImpersonatedBy INT NULL,
  FOREIGN KEY (AccountID) REFERENCES AccountData(AccountID),
  FOREIGN KEY (ImpersonatedBy) REFERENCES AccountData(AccountID)
);
```

- `ImpersonatedBy` is NULL for normal sessions
- `ImpersonatedBy` contains the admin's AccountID for impersonation sessions

## Migration

For existing databases, run:

```sql
ALTER TABLE Sessions ADD COLUMN ImpersonatedBy INT NULL;
ALTER TABLE Sessions ADD CONSTRAINT FK_Sessions_ImpersonatedBy
  FOREIGN KEY (ImpersonatedBy) REFERENCES AccountData(AccountID);
```

Or use the migration file: `database/migrations/001_add_impersonation_column.sql`

## Frontend Integration

1. Call `POST /admin/users/{id}/impersonate` to start impersonation
2. Store the returned `session_token` (replaces current session)
3. Redirect to appropriate dashboard based on `impersonated_user.role`
4. Show impersonation banner on all pages when `is_impersonating` is true
5. Call `POST /admin/impersonate/end` to end impersonation
6. Redirect back to admin dashboard using `admin_account_id`
