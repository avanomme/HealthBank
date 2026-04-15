# Impersonation & Session API Models (`impersonation.dart`)

## Overview
This module defines the data models used for:

- Admin impersonation flows
- Ending impersonation
- Session introspection (`/sessions/me`)
- View-as mode (non-token-switching approach)

All models are implemented using `freezed` for immutable value types and `json_serializable` for JSON serialization/deserialization.

File: `frontend/lib/src/core/api/models/impersonation.dart`

These models support both:
- **Full impersonation** (session/token-level switching)
- **View-as mode** (context-level switching without token replacement)

---

## Architecture / Design

### Design Principles
- **Immutable data structures** using `@freezed`
- **Explicit backend mapping** via `@JsonKey(name: ...)`
- **Nested composition** for structured responses (e.g., `ImpersonateResponse` → `ImpersonatedUserInfo`)
- **Generated JSON support** via `*.g.dart`
- **Sealed classes** to enforce controlled model definitions

### Model Groupings

#### 1. Impersonation Models
Used when an admin fully impersonates another user.

#### 2. Session Models
Used by `/sessions/me` to determine:
- Current authenticated user
- Whether impersonation is active
- Whether view-as mode is active
- Consent/profile flags

#### 3. View-As Models
Used for a newer approach where the admin views the system as another user without switching tokens.

---

## Configuration (if applicable)

### Code Generation
Run after modifying any model:

- Standard:
  - `dart run build_runner build`

- Clean conflicts:
  - `dart run build_runner build --delete-conflicting-outputs`

Generated files:
- `impersonation.freezed.dart`
- `impersonation.g.dart`

No runtime configuration is required.

---

# API Reference

---

## Impersonation Models

### `ImpersonatedUserInfo`
Basic user information returned when impersonation begins.

**Factory**
- `ImpersonatedUserInfo({ required int accountId, String? firstName, String? lastName, required String email, required String role })`

**JSON**
- `ImpersonatedUserInfo.fromJson(Map<String, dynamic> json)`

**Fields**

| Name | Type | Required | JSON key | Description |
|------|------|----------|----------|-------------|
| `accountId` | `int` | Yes | `account_id` | Target user account ID |
| `firstName` | `String?` | No | `first_name` | Target user first name |
| `lastName` | `String?` | No | `last_name` | Target user last name |
| `email` | `String` | Yes | `email` | Target user email |
| `role` | `String` | Yes | `role` | Target user role |

---

### `ImpersonateResponse`
Response returned after successful impersonation.

**Factory**
- `ImpersonateResponse({ required String message, required String sessionToken, required String expiresAt, required bool isImpersonating, required ImpersonatedUserInfo impersonatedUser, required int adminAccountId })`

**JSON**
- `ImpersonateResponse.fromJson(Map<String, dynamic> json)`

**Fields**

| Name | Type | Required | JSON key | Description |
|------|------|----------|----------|-------------|
| `message` | `String` | Yes | `message` | Informational message |
| `sessionToken` | `String` | Yes | `session_token` | New session token for impersonation |
| `expiresAt` | `String` | Yes | `expires_at` | Session expiration timestamp |
| `isImpersonating` | `bool` | Yes | `is_impersonating` | Indicates impersonation is active |
| `impersonatedUser` | `ImpersonatedUserInfo` | Yes | `impersonated_user` | Target user info |
| `adminAccountId` | `int` | Yes | `admin_account_id` | Admin initiating impersonation |

---

### `EndImpersonationResponse`
Response returned when impersonation ends.

**Factory**
- `EndImpersonationResponse({ required String message, required int adminAccountId })`

**JSON**
- `EndImpersonationResponse.fromJson(Map<String, dynamic> json)`

**Fields**

| Name | Type | Required | JSON key | Description |
|------|------|----------|----------|-------------|
| `message` | `String` | Yes | `message` | Informational message |
| `adminAccountId` | `int` | Yes | `admin_account_id` | Restored admin account ID |

---

## Session Info Models (`/sessions/me`)

### `SessionUserInfo`
Represents the authenticated user in the current session.

**Factory**
- `SessionUserInfo({ required int accountId, String? firstName, String? lastName, required String email, required String role, required int roleId })`

**JSON**
- `SessionUserInfo.fromJson(Map<String, dynamic> json)`

**Fields**

| Name | Type | Required | JSON key | Description |
|------|------|----------|----------|-------------|
| `accountId` | `int` | Yes | `account_id` | Current account ID |
| `firstName` | `String?` | No | `first_name` | First name |
| `lastName` | `String?` | No | `last_name` | Last name |
| `email` | `String` | Yes | `email` | Email address |
| `role` | `String` | Yes | `role` | Role name |
| `roleId` | `int` | Yes | `role_id` | Role identifier |

---

### `ImpersonationInfo`
Information about the admin who initiated impersonation.

**Factory**
- `ImpersonationInfo({ required int adminAccountId, String? adminFirstName, String? adminLastName, required String adminEmail })`

**JSON**
- `ImpersonationInfo.fromJson(Map<String, dynamic> json)`

**Fields**

| Name | Type | Required | JSON key | Description |
|------|------|----------|----------|-------------|
| `adminAccountId` | `int` | Yes | `admin_account_id` | Admin account ID |
| `adminFirstName` | `String?` | No | `admin_first_name` | Admin first name |
| `adminLastName` | `String?` | No | `admin_last_name` | Admin last name |
| `adminEmail` | `String` | Yes | `admin_email` | Admin email |

---

### `SessionMeResponse`
Response from `GET /sessions/me`.

**Factory**
- `SessionMeResponse({ required SessionUserInfo user, required bool isImpersonating, ImpersonationInfo? impersonationInfo, ViewingAsUserInfo? viewingAs, required String sessionExpiresAt, bool hasSignedConsent = true, bool needsProfileCompletion = false })`

**JSON**
- `SessionMeResponse.fromJson(Map<String, dynamic> json)`

**Fields**

| Name | Type | Required | JSON key | Default | Description |
|------|------|----------|----------|---------|-------------|
| `user` | `SessionUserInfo` | Yes | `user` | Authenticated user |
| `isImpersonating` | `bool` | Yes | `is_impersonating` | Whether impersonation is active |
| `impersonationInfo` | `ImpersonationInfo?` | No | `impersonation_info` | Admin info (if impersonating) |
| `viewingAs` | `ViewingAsUserInfo?` | No | `viewing_as` | View-as user context |
| `sessionExpiresAt` | `String` | Yes | `session_expires_at` | Session expiration timestamp |
| `hasSignedConsent` | `bool` | No | `has_signed_consent` | `true` | Consent flag |
| `needsProfileCompletion` | `bool` | No | `needs_profile_completion` | `false` | Profile completion flag |

---

## View-As Models (No Token Switching)

### `ViewingAsUserInfo`
Information about the user being viewed in view-as mode.

**Factory**
- `ViewingAsUserInfo({ required int userId, String? firstName, String? lastName, required String email, required String role, required int roleId })`

**JSON**
- `ViewingAsUserInfo.fromJson(Map<String, dynamic> json)`

**Fields**

| Name | Type | Required | JSON key | Description |
|------|------|----------|----------|-------------|
| `userId` | `int` | Yes | `user_id` | Viewed user ID |
| `firstName` | `String?` | No | `first_name` | First name |
| `lastName` | `String?` | No | `last_name` | Last name |
| `email` | `String` | Yes | `email` | Email |
| `role` | `String` | Yes | `role` | Role name |
| `roleId` | `int` | Yes | `role_id` | Role identifier |

---

### `ViewAsResponse`
Response when starting view-as mode.

**Factory**
- `ViewAsResponse({ required String message, required bool isViewingAs, required ViewingAsUserInfo viewedUser })`

**JSON**
- `ViewAsResponse.fromJson(Map<String, dynamic> json)`

**Fields**

| Name | Type | Required | JSON key | Description |
|------|------|----------|----------|-------------|
| `message` | `String` | Yes | `message` | Informational message |
| `isViewingAs` | `bool` | Yes | `is_viewing_as` | Whether view-as mode is active |
| `viewedUser` | `ViewingAsUserInfo` | Yes | `viewed_user` | User being viewed |

---

### `EndViewAsResponse`
Response when ending view-as mode.

**Factory**
- `EndViewAsResponse({ required String message })`

**JSON**
- `EndViewAsResponse.fromJson(Map<String, dynamic> json)`

**Fields**

| Name | Type | Required | JSON key | Description |
|------|------|----------|----------|-------------|
| `message` | `String` | Yes | `message` | Informational message |

---

## Error Handling

### JSON Deserialization Failures
Potential failure cases:
- Missing required keys (e.g., `session_token`, `session_expires_at`)
- Incorrect types (e.g., `account_id` returned as string instead of int)
- Null values for required fields

All `fromJson` calls should be treated as fallible and wrapped in the API/client layer’s standardized error handling.

### Timestamp Fields
The following are represented as `String`:
- `expiresAt`
- `sessionExpiresAt`

If converted to `DateTime`, parsing and timezone handling must be performed safely by the caller.

### Nested Object Integrity
Responses such as `ImpersonateResponse` and `SessionMeResponse` contain nested models. If nested decoding fails, the entire response deserialization will fail.

---

## Usage Examples

### Decoding session state
```dart
final session = SessionMeResponse.fromJson(jsonMap);

if (session.isImpersonating) {
  final admin = session.impersonationInfo;
}