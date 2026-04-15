# Two-Factor Authentication API Service (`two_factor_api.dart`)

## Overview
This module defines the `TwoFactorAPI` Retrofit service interface for managing two-factor authentication (2FA).

It supports:

- Enrolling a user in 2FA
- Confirming 2FA enrollment with a TOTP code
- Disabling 2FA

The service uses:
- `dio` as the HTTP client
- `retrofit` for declarative endpoint definitions
- Typed models exported via `models.dart`

File: `frontend/lib/core/api/services/two_factor_api.dart`

Generated file:
- `two_factor_api.g.dart`

---

## Architecture / Design

### Retrofit Service Pattern
- Annotated with `@RestApi()` for code generation.
- HTTP methods declared using:
  - `@POST`
- Request bodies mapped using `@Body()`.
- All responses are strongly typed.

### Construction

```dart
TwoFactorAPI(Dio dio, {String? baseUrl})