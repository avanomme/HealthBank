# Two-Factor Authentication (2FA) API Models (`two_factor.dart`)

## Overview
This module defines the data models used for two-factor authentication (2FA) flows in the frontend application.

It supports:

- Enrolling in 2FA (generating a provisioning URI)
- Confirming 2FA setup with a TOTP code
- Disabling 2FA
- Sending confirmation codes to the backend

All models use:
- `freezed` for immutable value types
- `json_serializable` for JSON (de)serialization

File: `frontend/lib/core/api/models/two_factor.dart`

---

## Architecture / Design

### Design Principles
- **Immutable models** using `@freezed`
- **Explicit JSON key mapping** via `@JsonKey(name: ...)`
- **Minimal response contracts** reflecting backend payload structure
- **Clear separation of request and response models**

### Endpoint Mapping

| Endpoint | Model |
|-----------|--------|
| `POST /2fa/enroll` | `TwoFactorEnrollResponse` |
| `POST /2fa/confirm` | `TwoFactorConfirmRequest`, `TwoFactorConfirmResponse` |
| `POST /2fa/disable` | `TwoFactorDisableResponse` |

### Code Generation
Generated files required:

- `two_factor.freezed.dart`
- `two_factor.g.dart`

Run:

```bash
dart run build_runner build