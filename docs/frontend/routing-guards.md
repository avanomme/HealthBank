<!-- Created with the Assistance of Claude Code -->
# GoRouter Auth Redirect Guards

## Overview

The app uses GoRouter's `redirect` callback with `refreshListenable` to enforce authentication on protected routes. When auth state changes, GoRouter automatically re-evaluates the redirect and navigates accordingly.

## Architecture

```
Riverpod AuthState ──ref.listen──> AuthChangeNotifier ──notifyListeners──> GoRouter redirect
```

### AuthChangeNotifier

A `ChangeNotifier` that bridges Riverpod auth state to GoRouter's listenable-based refresh system. Defined in `go_router.dart`:

```dart
class AuthChangeNotifier extends ChangeNotifier {
  bool isAuthenticated;
  bool sessionReady;

  void update({required bool isAuthenticated, required bool sessionReady});
}
```

### Bridge in main.dart

`_MyAppState.build()` watches auth state and session initialization, then syncs to the notifier:

```dart
ref.listen(authProvider, (_, auth) {
  authChangeNotifier.update(
    isAuthenticated: auth.isAuthenticated,
    sessionReady: ref.read(sessionInitializedProvider),
  );
});
```

### Redirect Logic

```dart
redirect: (context, state) {
  // During session init, allow all navigation
  if (!authChangeNotifier.sessionReady) return null;

  // Public routes: always accessible
  if (_publicRoutes.contains(path)) return null;

  // Protected routes: require authentication
  if (!authChangeNotifier.isAuthenticated) return AppRoutes.login;

  return null; // Authenticated — allow
}
```

## Public Routes

These routes are accessible without authentication:

| Route | Page |
|-------|------|
| `/` | Home (Login) |
| `/login` | Login Page |
| `/logout` | Logout Page |
| `/forgot-password` | Forgot Password |
| `/request-account` | Request Account |
| `/dev` | Dev Hub (development only) |

## Protected Routes

All other routes require an active session. Unauthenticated access redirects to `/login`.

## Role-Based Route Guards

After authentication, GoRouter enforces role-based access using `_roleAllowedPrefixes`:

| Role | Allowed Prefixes | Blocked Example |
|------|-----------------|-----------------|
| participant | `/participant` | `/admin` → redirected to `/participant/dashboard` |
| researcher | `/researcher`, `/surveys`, `/templates`, `/questions` | `/admin` → redirected to `/surveys` |
| hcp | `/hcp` | `/surveys` → redirected to `/hcp/dashboard` |
| admin | (all routes) | No restrictions |

### How It Works

1. `AuthChangeNotifier` now tracks `String? role` alongside `isAuthenticated` and `sessionReady`
2. Role is passed from `authProvider` state via `auth.user?.role` in `ref.listen` callbacks
3. On session restore, role is read from secure storage and passed immediately
4. In the redirect callback, if `role != null && role != 'admin'`, the path is checked against allowed prefixes
5. If no prefix matches, user is redirected to their role's dashboard via `getDashboardRouteForRole(role)`

### Bridge in main.dart

```dart
ref.listen(authProvider, (_, auth) {
  authChangeNotifier.update(
    isAuthenticated: auth.isAuthenticated,
    sessionReady: ref.read(sessionInitializedProvider),
    role: auth.user?.role,
  );
});
```

Session restore also passes role immediately to prevent a flash of the wrong page on startup.

## 401 Session Expiry Flow

1. API call returns 401
2. `_ErrorInterceptor` clears auth token and calls `ApiClient.onSessionExpired`
3. Handler in `main.dart` resets `authProvider` state
4. `AuthChangeNotifier` fires `notifyListeners()`
5. GoRouter re-evaluates redirect, sees `isAuthenticated = false`
6. User redirected to `/login`
