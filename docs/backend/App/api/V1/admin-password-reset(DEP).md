# Admin Password Reset API

API endpoints for administrators to reset user passwords.

## Endpoints

### POST /api/v1/admin/users/{user_id}/reset-password

Reset a user's password. This is an admin-only endpoint.

#### Path Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `user_id` | integer | The AccountID of the user whose password to reset |

#### Request Body

```json
{
  "new_password": "string (min 8 characters)"
}
```

#### Response

**Success (200 OK)**

```json
{
  "message": "Password reset successfully",
  "user_id": 123
}
```

**Error Responses**

| Status | Description |
|--------|-------------|
| 400 | Invalid password (less than 8 characters) |
| 404 | User not found |
| 500 | Database error |

#### Example

**Request:**
```bash
curl -X POST "http://localhost:8000/api/v1/admin/users/5/reset-password" \
  -H "Content-Type: application/json" \
  -d '{"new_password": "newSecurePassword123"}'
```

**Response:**
```json
{
  "message": "Password reset successfully",
  "user_id": 5
}
```

## Security Considerations

1. **Password Hashing**: Passwords are hashed using PBKDF2-SHA256 with 210,000 iterations before storage
2. **Minimum Length**: Passwords must be at least 8 characters
3. **Admin Only**: This endpoint should only be accessible to administrators (auth middleware to be added)
4. **Audit Trail**: Consider logging password reset actions for security auditing

## Implementation Notes

- The endpoint looks up the user's `AuthID` from `AccountData` table
- Updates the `PasswordHash` in the `Auth` table
- Uses parameterized queries to prevent SQL injection
- Password is hashed using the same `hash_password` function used during account creation

---

### POST /api/v1/admin/users/{user_id}/send-reset-email

Send a password reset notification email to a user.

#### Path Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `user_id` | integer | The AccountID of the user |

#### Request Body

```json
{
  "temporary_password": "string (required)",
  "email_override": "string (optional)"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `temporary_password` | string | Yes | The temporary password to include in email |
| `email_override` | string | No | Alternate email address (defaults to user's email) |

#### Response

**Success (200 OK)**

```json
{
  "message": "Password reset email sent successfully",
  "sent_to": "user@example.com",
  "user_id": 123
}
```

**Error Responses**

| Status | Description |
|--------|-------------|
| 404 | User not found |
| 500 | Email send failed or database error |

#### Example

**Request:**
```bash
curl -X POST "http://localhost:8000/api/v1/admin/users/5/send-reset-email" \
  -H "Content-Type: application/json" \
  -d '{"temporary_password": "TempPass123"}'
```

**Response:**
```json
{
  "message": "Password reset email sent successfully",
  "sent_to": "john.smith@email.com",
  "user_id": 5
}
```

**With alternate email:**
```bash
curl -X POST "http://localhost:8000/api/v1/admin/users/5/send-reset-email" \
  -H "Content-Type: application/json" \
  -d '{"temporary_password": "TempPass123", "email_override": "alternate@example.com"}'
```

---

## Typical Workflow

1. Admin opens reset password modal for a user
2. Admin enters or generates a temporary password
3. Frontend calls `POST /users/{id}/reset-password` to update password
4. If "Send Email" is checked, frontend calls `POST /users/{id}/send-reset-email`
5. User receives email with temporary password and instructions

## Future Enhancements

- [ ] Add admin authentication middleware
- [ ] Add audit logging for password resets
