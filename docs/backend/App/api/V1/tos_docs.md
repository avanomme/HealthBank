# Terms of Service Acceptance API

API endpoint for recording a user’s acceptance of the current Terms of Service (ToS).  
This endpoint stores the acceptance timestamp, ToS version, and originating IP address.

Implemented in FastAPI.

---

## Overview

This API allows an authenticated user to accept the currently active Terms of Service.  
Acceptance is recorded directly on the user’s account record.

The current ToS version is supplied via an environment variable and stored alongside the acceptance metadata.

---

## Security Notes

- The endpoint requires authentication.
- The authenticated user is resolved via dependency injection.
- Acceptance data is written only for the currently authenticated account.
- IP addresses are stored in binary format for efficient storage and indexing.

---

## Configuration

### Environment Variables

| Variable | Description |
|--------|-------------|
| `CURRENT_TOS_VERSION` | Identifier or version string for the active Terms of Service |

---

## Base Path

The router defines the following relative path:

- `POST /accept`

The full request path depends on where the router is mounted (typically `/api/v1/tos/accept`).

---

## Endpoint

### Accept Terms of Service

```
POST /accept
```

Records acceptance of the current Terms of Service for the authenticated user.

---

### Authentication

This endpoint requires a valid authenticated session.

Authentication is handled via the `get_current_user` dependency.

---

### Request Headers

The client IP address is determined using the following priority:

1. `X-Forwarded-For` header (first IP in the list)
2. `request.client.host` (fallback)

No request body is required.

---

### Behavior

- Resolves the authenticated user account
- Extracts the client IP address
- Converts the IP address to binary form
- Updates the user’s account record:
  - Sets `TosAcceptedAt` to the current UTC timestamp
  - Sets `TosVersion` to `CURRENT_TOS_VERSION`
  - Sets `TosAcceptedIp` to the binary IP address

---

### Response (200 OK)

```json
{
  "accepted": true,
  "version": "2024-01"
}
```

---

## Database Expectations

This endpoint assumes the following columns exist on the `AccountData` table:

| Column | Type | Description |
|------|------|-------------|
| `TosAcceptedAt` | DATETIME | Timestamp of ToS acceptance (UTC) |
| `TosVersion` | VARCHAR / TEXT | Accepted ToS version identifier |
| `TosAcceptedIp` | VARBINARY | Binary representation of the client IP |

---

## IP Address Handling

- IP addresses are converted using standard IPv4/IPv6 parsing
- Stored using `ipaddress.ip_address(ip).packed`
- Invalid or missing IPs result in `NULL` being stored

---

## Error Handling

This endpoint relies on framework-level exception handling:

- Authentication failures are handled by `get_current_user`
- Database errors propagate as internal server errors

No custom error responses are defined in this handler.

---

## Implementation Notes

- Uses UTC timestamps for all stored times
- Designed to be idempotent (re-accepting updates the record)
- Intended to be called once per ToS update, typically during login or onboarding

