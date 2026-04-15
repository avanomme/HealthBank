# Authentication API Models (`auth.dart`)

## Overview
This module defines the strongly-typed request/response models used by the authentication-related API surface in the Flutter frontend. Models are implemented using `freezed` for immutable value types and `json_serializable` for JSON encoding/decoding.

It covers:
- Login request/response
- Password reset (email + confirm)
- Change password
- Profile completion
- Generic backend message responses
- 2FA verification during login

File: `frontend/lib/core/api/models/auth.dart`

## Architecture / Design
### Approach
- **Immutable data models**: All models are `@freezed` classes, intended to be created via factories and treated as immutable.
- **JSON mapping**: Each model exposes `fromJson(Map<String, dynamic>)`, relying on generated `*.g.dart` code.
- **Backend compatibility**: Several fields use `@JsonKey(name: ...)` to match backend snake_case keys while exposing idiomatic Dart property names.
- **Default values**: Some response fields use `@Default(...)` to ensure safe values when the backend omits optional flags.

### Code generation
This file depends on generated parts:
- `auth.freezed.dart`
- `auth.g.dart`

These must be generated whenever models change.

### Convenience helpers
- `LoginResponseExtension.fullName` computes a user-facing display string from optional `firstName` and `lastName`.

## Configuration (if applicable)
### Build runner generation
Run code generation after changing any `@freezed` model:

- Generate once:
  - `dart run build_runner build`

- Regenerate and resolve conflicts (common in CI/dev when outputs drift):
  - `dart run build_runner build --delete-conflicting-outputs`

## API Reference
> The following describes the model structures and their JSON mapping expectations. These are data models only; transport and endpoint wiring live elsewhere.

### `LoginRequest`
Represents the payload for initiating a login.

**Factory**
- `LoginRequest({ required String email, required String password })`

**JSON**
- `LoginRequest.fromJson(Map<String, dynamic> json)`

**Fields**
| Name | Type | Required | JSON key | Description |
|------|------|----------|---------|-------------|
| `email` | `String` | Yes | `email` | User email address |
| `password` | `String` | Yes | `password` | User password |

---

### `LoginResponse`
Represents the backend response for login in a **cookie-only auth** setup.

**Factory**
- `LoginResponse({ required String expiresAt, required int accountId, String? firstName, String? lastName, String? email, String? role, bool mustChangePassword = false, bool hasSignedConsent = true, bool needsProfileCompletion = false })`

**JSON**
- `LoginResponse.fromJson(Map<String, dynamic> json)`

**Fields**
| Name | Type | Required | JSON key | Default | Description |
|------|------|----------|---------|---------|-------------|
| `expiresAt` | `String` | Yes | `expires_at` | - | Expiration timestamp returned by backend |
| `accountId` | `int` | Yes | `account_id` | - | Account identifier |
| `firstName` | `String?` | No | `first_name` | `null` | User given name |
| `lastName` | `String?` | No | `last_name` | `null` | User family name |
| `email` | `String?` | No | `email` | `null` | Email (may be echoed by backend) |
| `role` | `String?` | No | `role` | `null` | Role identifier/name |
| `mustChangePassword` | `bool` | No | `must_change_password` | `false` | Indicates the user must set a new password |
| `hasSignedConsent` | `bool` | No | `has_signed_consent` | `true` | Consent status flag |
| `needsProfileCompletion` | `bool` | No | `needs_profile_completion` | `false` | Indicates profile completion is required |

**Extension**
- `LoginResponseExtension.fullName -> String`
  - Concatenates `firstName` and `lastName`, trims whitespace, returns an empty string if both are null/blank.

---

### `PasswordResetEmailRequest`
Request payload for password reset step 1 (send reset email).

**Factory**
- `PasswordResetEmailRequest({ required String email })`

**JSON**
- `PasswordResetEmailRequest.fromJson(Map<String, dynamic> json)`

**Fields**
| Name | Type | Required | JSON key | Description |
|------|------|----------|---------|-------------|
| `email` | `String` | Yes | `email` | Email address to receive reset instructions |

---

### `PasswordResetConfirmRequest`
Request payload for password reset step 2 (confirm reset using token + new password).

**Factory**
- `PasswordResetConfirmRequest({ required String token, required String newPassword })`

**JSON**
- `PasswordResetConfirmRequest.fromJson(Map<String, dynamic> json)`

**Fields**
| Name | Type | Required | JSON key | Description |
|------|------|----------|---------|-------------|
| `token` | `String` | Yes | `token` | Password reset token |
| `newPassword` | `String` | Yes | `new_password` | New password to set |

---

### `ChangePasswordRequest`
Request payload for changing a password while authenticated.

**Factory**
- `ChangePasswordRequest({ required String currentPassword, required String newPassword })`

**JSON**
- `ChangePasswordRequest.fromJson(Map<String, dynamic> json)`

**Fields**
| Name | Type | Required | JSON key | Description |
|------|------|----------|---------|-------------|
| `currentPassword` | `String` | Yes | `old_password` | Current password (backend expects `old_password`) |
| `newPassword` | `String` | Yes | `new_password` | New password to set |

---

### `ProfileCompleteRequest`
Request payload for profile completion (participant birthdate + gender).

**Factory**
- `ProfileCompleteRequest({ required String birthdate, required String gender })`

**JSON**
- `ProfileCompleteRequest.fromJson(Map<String, dynamic> json)`

**Fields**
| Name | Type | Required | JSON key | Description |
|------|------|----------|---------|-------------|
| `birthdate` | `String` | Yes | `birthdate` | Birthdate string (format enforced by backend/API contract) |
| `gender` | `String` | Yes | `gender` | Gender value (format/enumeration enforced by backend/API contract) |

---

### `MessageResponse`
Generic backend response containing a human-readable message.

**Factory**
- `MessageResponse({ required String message })`

**JSON**
- `MessageResponse.fromJson(Map<String, dynamic> json)`

**Fields**
| Name | Type | Required | JSON key | Description |
|------|------|----------|---------|-------------|
| `message` | `String` | Yes | `message` | Informational/success/error message |

---

### `Verify2FARequest`
Request payload for verifying 2FA during login using a challenge token plus a TOTP code.

**Factory**
- `Verify2FARequest({ required String challengeToken, required String code })`

**JSON**
- `Verify2FARequest.fromJson(Map<String, dynamic> json)`

**Fields**
| Name | Type | Required | JSON key | Description |
|------|------|----------|---------|-------------|
| `challengeToken` | `String` | Yes | `challenge_token` | Token issued by backend during login challenge |
| `code` | `String` | Yes | `code` | TOTP / 2FA verification code |

## Error Handling
### JSON decoding and schema mismatch
These models rely on generated `fromJson` implementations. Typical failure modes:
- **Missing required keys**: Decoding can fail if required fields (e.g., `expires_at`, `account_id`) are absent or null.
- **Type mismatches**: Decoding can fail if backend types differ from the expected Dart types (e.g., `account_id` not an integer).
- **Unexpected formats**: Fields like `expiresAt` and `birthdate` are `String`-typed; if consumers require parsing into `DateTime`, parsing errors should be handled at the call site.

### Recommended handling pattern
- Treat all `fromJson` calls as potentially fallible when data originates from the network.
- Convert transport-layer parsing errors into your app’s standardized API error type (where your networking/client layer is implemented).

## Usage Examples (only where helpful)
### Constructing a login request
```dart
final req = LoginRequest(
  email: 'user@example.com',
  password: 'correct horse battery staple',
);