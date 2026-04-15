<!-- Created with the Assistance of Claude Code -->
# Users API

The Users API provides CRUD operations for managing user accounts.

## Base URL

```
/api/v1/users
```

## Endpoints

### List Users

**GET** `/api/v1/users`

Get all users with optional filtering.

**Query Parameters:**
- `role` (optional) - Filter by role (not yet implemented)
- `is_active` (optional) - Filter by active status: `true` or `false`
- `search` (optional) - Search by first name, last name, or email
- `limit` (optional) - Max results to return (default: 100, max: 500)
- `offset` (optional) - Number of results to skip (default: 0)

**Examples:**
```
GET /api/v1/users
GET /api/v1/users?is_active=true
GET /api/v1/users?search=john
GET /api/v1/users?limit=10&offset=20
```

**Response:** `200 OK`
```json
{
  "users": [
    {
      "account_id": 1,
      "first_name": "John",
      "last_name": "Doe",
      "email": "john@example.com",
      "role": null,
      "is_active": true,
      "created_at": "2026-01-22T12:00:00Z",
      "last_login": "2026-01-25T10:30:00Z"
    }
  ],
  "total": 1
}
```

---

### Get Single User

**GET** `/api/v1/users/{user_id}`

Get a specific user by ID.

**Response:** `200 OK`
```json
{
  "account_id": 1,
  "first_name": "John",
  "last_name": "Doe",
  "email": "john@example.com",
  "role": null,
  "is_active": true,
  "created_at": "2026-01-22T12:00:00Z",
  "last_login": "2026-01-25T10:30:00Z"
}
```

**Error Response:** `404 Not Found`
```json
{
  "detail": "User not found"
}
```

---

### Create User

**POST** `/api/v1/users`

Create a new user account.

**Request Body:**
```json
{
  "first_name": "Jane",
  "last_name": "Smith",
  "email": "jane@example.com",
  "role": "participant",
  "is_active": true
}
```

**Fields:**
- `first_name` (required) - User's first name (1-64 characters)
- `last_name` (required) - User's last name (1-64 characters)
- `email` (required) - Valid email address (must be unique)
- `role` (optional) - User role: "participant" (default), "researcher", "hcp", "admin"
- `is_active` (optional) - Account status (default: true)

**Response:** `201 Created`
```json
{
  "account_id": 2,
  "first_name": "Jane",
  "last_name": "Smith",
  "email": "jane@example.com",
  "role": null,
  "is_active": true,
  "created_at": "2026-01-27T14:00:00Z",
  "last_login": null
}
```

**Error Responses:**
- `400 Bad Request` - Email already registered
- `422 Unprocessable Entity` - Validation errors

---

### Update User

**PUT** `/api/v1/users/{user_id}`

Update an existing user. Only provided fields are updated.

**Request Body:**
```json
{
  "first_name": "Jane",
  "last_name": "Doe",
  "email": "jane.doe@example.com",
  "is_active": false
}
```

**Fields (all optional):**
- `first_name` - User's first name
- `last_name` - User's last name
- `email` - Email address (must be unique)
- `role` - User role (not yet implemented)
- `is_active` - Account status

**Response:** `200 OK`
```json
{
  "account_id": 2,
  "first_name": "Jane",
  "last_name": "Doe",
  "email": "jane.doe@example.com",
  "role": null,
  "is_active": false,
  "created_at": "2026-01-27T14:00:00Z",
  "last_login": null
}
```

**Error Responses:**
- `400 Bad Request` - Email already in use
- `404 Not Found` - User not found

---

### Toggle User Status

**PATCH** `/api/v1/users/{user_id}/status`

Toggle a user's active/inactive status.

**Query Parameters:**
- `is_active` (required) - New status: `true` or `false`

**Example:**
```
PATCH /api/v1/users/1/status?is_active=false
```

**Response:** `200 OK`
```json
{
  "account_id": 1,
  "first_name": "John",
  "last_name": "Doe",
  "email": "john@example.com",
  "role": null,
  "is_active": false,
  "created_at": "2026-01-22T12:00:00Z",
  "last_login": "2026-01-25T10:30:00Z"
}
```

**Error Response:** `404 Not Found`

---

### Delete User

**DELETE** `/api/v1/users/{user_id}`

Delete a user and all associated data.

**Response:** `204 No Content`

**Error Response:** `404 Not Found`

**Notes:**
- Deletes user's sessions
- Deletes user's survey assignments
- Deletes user's survey responses
- Use with caution - this action is irreversible

---

## User Roles

| Role | Description |
|------|-------------|
| `participant` | Standard user who takes surveys |
| `researcher` | Creates and manages surveys |
| `hcp` | Healthcare professional with elevated access |
| `admin` | Full system access |

**Note:** Role column is not yet implemented in the database. All users currently return `role: null`.

---

## Error Responses

### Validation Error (422)
```json
{
  "detail": [
    {
      "loc": ["body", "email"],
      "msg": "value is not a valid email address",
      "type": "value_error.email"
    }
  ]
}
```

### Not Found (404)
```json
{
  "detail": "User not found"
}
```

### Bad Request (400)
```json
{
  "detail": "Email already registered"
}
```

---

## Database Table

Users are stored in the `AccountData` table:

| Column | Type | Description |
|--------|------|-------------|
| AccountID | INT | Primary key |
| FirstName | VARCHAR(64) | User's first name |
| LastName | VARCHAR(64) | User's last name |
| Email | VARCHAR(255) | Unique email address |
| AuthID | INT | Link to Auth table |
| IsActive | BOOLEAN | Account active status |
| CreatedAt | DATETIME | Account creation time |

See [Database Schema](../database/schema.md) for full table definitions.

---

## Security

**CRITICAL:** All database queries MUST use parameterized queries.

```python
# CORRECT
cursor.execute(
    "SELECT * FROM AccountData WHERE AccountID = %s",
    (user_id,)
)

# WRONG - SQL Injection vulnerable
cursor.execute(f"SELECT * FROM AccountData WHERE AccountID = {user_id}")
```

---

## Implementation Status

- [x] GET /api/v1/users - List users with filtering
- [x] GET /api/v1/users/{id} - Get single user
- [x] POST /api/v1/users - Create user
- [x] PUT /api/v1/users/{id} - Update user
- [x] PATCH /api/v1/users/{id}/status - Toggle active status
- [x] DELETE /api/v1/users/{id} - Delete user
- [ ] Role filtering (pending Role column in database)
