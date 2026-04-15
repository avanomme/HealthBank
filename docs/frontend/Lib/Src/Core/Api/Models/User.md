# User API Models (`user.dart`)

## Overview
This module defines user-related data models matching backend Pydantic schemas. It supports:

- User creation and updates
- User retrieval
- User listing
- Role enumeration and display helpers
- Convenience extensions for derived properties

All models use:
- `freezed` for immutable value types
- `json_serializable` for JSON (de)serialization

File: `frontend/lib/core/api/models/user.dart`

---

## Architecture / Design

### Design Principles
- **Immutable models** using `@freezed`
- **Explicit JSON key mapping** via `@JsonKey(name: ...)`
- **Enum-backed role support** with string mapping
- **Optional fields for partial updates**
- **Extension helpers** for display logic and enum conversion
- **Date handling** using `DateTime?` for temporal fields

### Role Handling Strategy
- `UserRole` enum is used for request payloads (`UserCreate`, `UserUpdate`).
- `User` response model stores `role` as a `String?` (mirroring backend flexibility).
- `UserExtension.roleEnum` attempts to map the string role into a `UserRole` safely.

### Code Generation
Generated files required:
- `user.freezed.dart`
- `user.g.dart`

Run:
```bash
dart run build_runner build