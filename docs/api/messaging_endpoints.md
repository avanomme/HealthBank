# Messaging System API

All endpoints require authentication via HttpOnly session cookie.

## Permission Rules

| Role | Can Message |
|------|-------------|
| Admin (4) | Anyone |
| HCP (3) | Linked patients with active, non-revoked consent |
| Participant (1) | Linked HCPs or accepted friends |
| Researcher (2) | Other researchers only |

---

## POST /api/v1/messages/conversations

Start or retrieve a direct conversation between the caller and a target account.

**Auth:** require_role(1, 2, 3, 4)

**Request Body:**
```json
{ "target_account_id": 10 }
```

**Response 201:**
```json
{ "conv_id": 7, "created": true }
```
If a conversation already exists between the two users, `created` is `false` and the existing `conv_id` is returned.

**Errors:**
- `400` — Cannot start a conversation with yourself
- `403` — Not authorized to message this user (permission rules not met)
- `404` — Target account not found or inactive

---

## GET /api/v1/messages/conversations

List all conversations the caller participates in, with last message preview.

**Auth:** require_role(1, 2, 3, 4)

**Response 200:**
```json
[
  {
    "conv_id": 1,
    "other_participant_id": 10,
    "other_participant_name": "Dr. Robert Williams",
    "last_message": "Hello, I have reviewed your latest results.",
    "last_message_at": "2026-01-15T09:00:00"
  }
]
```

---

## GET /api/v1/messages/conversations/{conv_id}/messages

Return all messages in a conversation, ordered by SentAt ASC.

**Auth:** require_role(1, 2, 3, 4)

**Path parameter:** `conv_id` (int)

**Response 200:**
```json
[
  {
    "message_id": 1,
    "sender_id": 10,
    "sender_name": "Dr. Robert Williams",
    "body": "Hello, I have reviewed your latest results.",
    "sent_at": "2026-01-15T09:00:00"
  },
  {
    "message_id": 2,
    "sender_id": 2,
    "sender_name": "Participant User",
    "body": "Thank you, Doctor. I had some questions.",
    "sent_at": "2026-01-15T09:05:00"
  }
]
```

**Errors:**
- `403` — Caller is not a participant in this conversation

---

## POST /api/v1/messages/conversations/{conv_id}/messages

Send a message in a conversation.

**Auth:** require_role(1, 2, 3, 4)

**Path parameter:** `conv_id` (int)

**Request Body:**
```json
{ "body": "Hello Doctor!" }
```

The `body` field is passed through `sanitized_string()` (removes null bytes, control characters; truncates at 10,000 characters).

**Response 201:**
```json
{ "message_id": 99, "sent_at": "2026-02-24T14:30:00" }
```

**Errors:**
- `403` — Caller is not a participant in this conversation

---

## POST /api/v1/messages/friend-request

Send a friend request to another participant by email.

**Auth:** require_role(1, 4) — participants and admin only

**Privacy preserving:** This endpoint ALWAYS returns the same 202 response, regardless of whether the target email exists. This prevents user enumeration.

**Request Body:**
```json
{ "email": "john.smith@email.com" }
```

**Response 202 (always):**
```json
{ "detail": "If this user exists, a friend request will be sent." }
```

**Internal logic (silent):**
1. Look up AccountData WHERE Email = email AND RoleID = 1 (participants only)
2. If found and not self: INSERT IGNORE into FriendRequests with status 'pending'
3. If not found or self: silently do nothing
4. Always return 202 with same message

**Errors:**
- `403` — Researchers (role 2) and HCPs (role 3) cannot send friend requests

---

## GET /api/v1/messages/friends

Return the caller's accepted friends.

**Auth:** require_role(1, 4)

**Response 200:**
```json
[
  { "account_id": 13, "display_name": "John Smith" }
]
```

---

## GET /api/v1/messages/researchers/search

Search for researchers by first or last name.

**Auth:** require_role(2, 4) — researchers and admin only

**Query parameter:** `q` (string, minimum 2 characters, required)

**Response 200:**
```json
[
  { "account_id": 5, "display_name": "Sarah Chen" },
  { "account_id": 6, "display_name": "Michael Rodriguez" }
]
```

**Notes:**
- Returns up to 20 results
- No email or personal data beyond name is exposed
- Only active accounts (IsActive=1) with RoleID=2 are returned

**Errors:**
- `403` — Participants (role 1) and HCPs (role 3) cannot use this endpoint
- `422` — Query string shorter than 2 characters

---

## GET /api/v1/messages/friend-requests/incoming

Return pending friend requests where the caller is the target.

**Auth:** require_role(1, 4)

**Response 200:**
```json
[
  {
    "request_id": 1,
    "requester_id": 13,
    "requester_name": "John Smith",
    "requested_at": "2026-02-01T09:00:00"
  }
]
```

---

## PUT /api/v1/messages/friend-requests/{request_id}/respond

Accept or reject a pending friend request.

**Auth:** require_role(1, 4)

**Path parameter:** `request_id` (int)

**Request Body:**
```json
{ "action": "accept" }
```
or
```json
{ "action": "reject" }
```

Only the `TargetAccountID` (the person who received the request) may respond. Admin may respond on behalf of any target.

**Response 200:**
```json
{ "request_id": 1, "status": "accepted" }
```

**Errors:**
- `400` — action must be 'accept' or 'reject'
- `400` — Request is not pending (already accepted/rejected)
- `403` — Only the request target can respond
- `404` — Friend request not found

---

## Database Tables

| Table | Purpose |
|-------|---------|
| `Conversations` | Conversation header (type: direct) |
| `ConversationParticipants` | Maps accounts to conversations |
| `Messages` | Individual messages within conversations |
| `FriendRequests` | Friend request records with status (pending/accepted/rejected) |

## Security Notes

- All SQL queries use parameterized `%s` placeholders — no string interpolation
- All user text inputs (message body, email) are passed through `sanitized_string()`
- Friend request endpoint is privacy-preserving: identical response whether target exists or not
- Researcher search returns display name only — no email is exposed
- All endpoints require `require_role()` authentication
