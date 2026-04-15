# Navigation Configuration by Role

This document describes the role-based navigation configuration in
`frontend/lib/src/config/navigation.dart`, including role parsing, dashboard
routes, and header navigation items for each role.

---

## User roles

The app defines four roles:

- `participant`
- `researcher`
- `hcp`
- `admin`

These are represented by the `UserRole` enum:

```dart
enum UserRole {
  participant,
  researcher,
  hcp,
  admin,
}