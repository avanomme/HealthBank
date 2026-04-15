# Frontend State Management

The HealthBank frontend uses **Riverpod** for state management. This document covers the key providers and patterns used throughout the application.

## Provider Organization

State providers are organized by feature:

```
frontend/lib/src/features/
├── auth/state/
│   ├── auth_providers.dart        # Login/logout state
│   └── impersonation_provider.dart # Impersonation state
├── admin/state/
│   ├── database_providers.dart    # Database viewer state
│   └── user_providers.dart        # User management state
├── surveys/state/
│   └── survey_providers.dart      # Survey CRUD state
├── researcher/state/
│   └── research_providers.dart  # Research data analytics state
└── question_bank/state/
    └── question_providers.dart    # Question management state
```

## Core Providers

### API Client Provider

The base API client provider is defined in `question_providers.dart` and shared across features:

```dart
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;

// Use in other providers
final myApiProvider = Provider<MyApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return MyApi(client.dio);
});
```

### Secure Storage Provider

For storing sensitive data like session tokens:

```dart
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});
```

---

## Authentication State

### AuthProvider

Manages login/logout state and session persistence.

```dart
import 'package:frontend/src/features/auth/auth_state.dart';

// Access auth state
final authState = ref.watch(authProvider);

// Perform login
final role = await ref.read(authProvider.notifier).login(email, password);

// Logout
await ref.read(authProvider.notifier).logout();

// Restore session on app start
final role = await ref.read(authProvider.notifier).restoreSession();
```

**State Properties:**
| Property | Type | Description |
|----------|------|-------------|
| `isAuthenticated` | bool | Whether user is logged in |
| `isLoading` | bool | Loading state during login |
| `error` | String? | Error message if login failed |
| `user` | LoginResponse? | User info after login |

---

## Impersonation State

### ImpersonationProvider

Tracks whether the current session is impersonating another user (admin feature).

```dart
import 'package:frontend/src/features/auth/auth_state.dart';

// Watch impersonation state
final impersonationState = ref.watch(impersonationProvider);

// Check if impersonating
if (impersonationState.isImpersonating) {
  // Show impersonation banner
  print('Viewing as: ${impersonationState.currentUserName}');
}

// Fetch session info (call on app startup)
await ref.read(impersonationProvider.notifier).fetchSessionInfo();

// Start impersonation (admin only)
final role = await ref.read(impersonationProvider.notifier).startImpersonation(userId);

// End impersonation
final adminId = await ref.read(impersonationProvider.notifier).endImpersonation();
```

**State Properties:**
| Property | Type | Description |
|----------|------|-------------|
| `isImpersonating` | bool | Whether currently impersonating |
| `isLoading` | bool | Loading state during operations |
| `error` | String? | Error message if operation failed |
| `currentUser` | SessionUserInfo? | Current user info |
| `adminInfo` | ImpersonationInfo? | Admin info (only when impersonating) |
| `sessionExpiresAt` | String? | Session expiration timestamp |

**Computed Properties:**
| Property | Type | Description |
|----------|------|-------------|
| `currentUserName` | String | Full name of current user |
| `adminName` | String | Full name of admin (when impersonating) |

### Helper Providers

```dart
// Check if current user is system admin (can impersonate)
final isAdmin = ref.watch(isSystemAdminProvider);

// Get current user's role
final role = ref.watch(currentUserRoleProvider);
```

---

## Usage Patterns

### Watching State in Widgets

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final impersonationState = ref.watch(impersonationProvider);

    if (authState.isLoading) {
      return const CircularProgressIndicator();
    }

    if (impersonationState.isImpersonating) {
      return ImpersonationBanner();
    }

    return MyContent();
  }
}
```

### Performing Actions

```dart
// In a button callback
onPressed: () async {
  final notifier = ref.read(authProvider.notifier);
  final role = await notifier.login(email, password);

  if (role != null) {
    // Navigate to dashboard
    context.go(getDashboardRouteForRole(role));
  }
}
```

### Initializing State on App Start

```dart
// In main.dart or app initialization
void initializeProviders(WidgetRef ref) async {
  // Restore auth session
  final role = await ref.read(authProvider.notifier).restoreSession();

  if (role != null) {
    // Fetch impersonation status
    await ref.read(impersonationProvider.notifier).fetchSessionInfo();
  }
}
```

---

## Best Practices

1. **Use `ref.watch()` in build methods** to rebuild on state changes
2. **Use `ref.read()` in callbacks** to avoid unnecessary rebuilds
3. **Keep providers focused** - one provider per concern
4. **Export from barrel files** for clean imports
5. **Handle loading/error states** in all async operations
6. **Clear state on logout** to prevent stale data

## Code Generation

After modifying Freezed models used by providers, regenerate:

```bash
cd frontend
dart run build_runner build --delete-conflicting-outputs
```
