# Admin View-As Provider (`admin_view_as_provider.dart`)

## Overview

`adminViewAsRoleProvider` is a simple Riverpod `StateProvider` used to track which **user role an administrator is currently viewing the interface as**.

This provider is strictly **frontend navigation state**. It does **not** modify backend authentication, impersonation, or session tokens. Instead, it allows the admin UI to temporarily render pages as if the current user had a different role.

Typical use cases include:
- Testing role-specific dashboards
- Previewing participant/researcher/HCP experiences
- Switching between role-based views without changing authentication

## Architecture / Design

### State model

The provider stores a nullable `String` representing the role currently being viewed.

| Value | Meaning |
|------|--------|
| `null` | Normal admin view (default state) |
| `"participant"` | Viewing the interface as a participant |
| `"researcher"` | Viewing the interface as a researcher |
| `"hcp"` | Viewing the interface as a healthcare provider |

The provider only influences **frontend navigation and UI behavior**. Backend API requests continue using the admin’s authentication token.

### Separation from backend impersonation

This provider is intentionally separate from any backend impersonation system.

Differences:

| Feature | Admin View-As | Backend Impersonation |
|-------|---------------|----------------------|
| Changes authentication token | No | Yes |
| Changes backend session identity | No | Yes |
| Affects API permissions | No | Yes |
| Purpose | UI preview/testing | Real user impersonation |

This provider is therefore safe to use for UI previews without security implications.

### Integration points

Common places this provider may be used:

- Admin navigation controls that allow switching between roles
- Role-based routing logic
- Conditional UI rendering depending on role context

Example pattern:

- Admin selects "View as Participant"
- `adminViewAsRoleProvider` is set to `"participant"`
- Navigation/routing logic loads the participant dashboard

## Configuration

No configuration is required.

The provider only depends on `flutter_riverpod`.

## API Reference

## `adminViewAsRoleProvider`

```dart
final adminViewAsRoleProvider = StateProvider<String?>((ref) => null);