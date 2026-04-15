# Frontend App Structure

Overview of the HealthBank Flutter frontend application structure.

## Entry Point

`frontend/lib/main.dart`

```dart
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

The app is wrapped in `ProviderScope` for Riverpod state management.

## App Shell

The `MyApp` widget configures:

1. **Theme** - `AppTheme.defaultTheme` from `src/core/theme/theme.dart`
2. **Router** - `appRouter` from `src/config/go_router.dart`
3. **Localization** - `AppLocalizations` for i18n support
4. **App Shell** - `_AppShell` wrapper via MaterialApp builder

### App Shell Structure

The `_AppShell` widget wraps all pages with global components:

```dart
class _AppShell extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Impersonation banner (shows when admin is viewing as user)
        AnimatedContainer(
          height: isImpersonating ? kImpersonationBannerHeight : 0,
          child: isImpersonating ? ImpersonationBanner() : SizedBox.shrink(),
        ),

        // Main content (all pages)
        Expanded(child: child),
      ],
    );
  }
}
```

This ensures the impersonation banner appears on ALL pages when active.

## Routing

Routes are defined in `src/config/go_router.dart`:

### Route Groups

| Group | Path Prefix | Description |
|-------|-------------|-------------|
| Auth | `/login`, `/logout` | Authentication pages |
| Participant | `/participant/*` | Participant dashboard and surveys |
| Researcher | `/researcher/*`, `/surveys/*` | Survey creation and management |
| HCP | `/hcp/*` | Healthcare professional views |
| Admin | `/admin/*` | Admin dashboard and management |

### Key Routes

```dart
class AppRoutes {
  static const login = '/login';
  static const participantDashboard = '/participant/dashboard';
  static const surveys = '/surveys';
  static const admin = '/admin';
  static const adminUsers = '/admin/users';
  // ... etc
}
```

## Feature Organization

```
frontend/lib/src/
├── config/
│   └── go_router.dart       # Route definitions
├── core/
│   ├── api/                  # API client and models
│   ├── l10n/                 # Localization
│   ├── state/                # Global state providers
│   ├── theme/                # Theme configuration
│   └── widgets/              # Shared widgets
└── features/
    ├── admin/                # Admin dashboard feature
    │   ├── pages/
    │   ├── state/
    │   └── widgets/
    ├── auth/                 # Authentication feature
    │   ├── pages/
    │   ├── state/
    │   └── widgets/
    ├── participant/          # Participant feature
    ├── researcher/           # Researcher feature
    ├── hcp_clients/          # HCP feature
    ├── surveys/              # Survey management
    ├── templates/            # Template management
    └── question_bank/        # Question bank
```

## Global Components

### Impersonation Banner

The impersonation banner is integrated at the app shell level, ensuring it appears on all pages when an admin is impersonating a user.

**Location**: Defined in `_AppShell` in `main.dart`

**Behavior**:
- Automatically shows when `impersonationProvider.isImpersonating` is true
- Animates in/out with 200ms slide animation
- Height: 48 pixels
- Positioned above all page content

**How it works**:
1. `_AppShell` watches `impersonationProvider`
2. When impersonation starts, banner animates in
3. When impersonation ends, banner animates out
4. No layout shift - uses `AnimatedContainer` for smooth transitions

## Theme

Defined in `src/core/theme/theme.dart`:

- **Primary**: #172B46 (dark blue)
- **Secondary**: #145B2C (green)
- **Error**: #A6192E (red)
- **Caution**: #FF9900 (orange/yellow)
- **Success**: #04B34F (green)

## State Management

Uses **Riverpod** for state management:

- `ProviderScope` wraps entire app in `main.dart`
- Feature-specific providers in `features/*/state/`
- Global providers in `core/state/`

Key providers:
- `authProvider` - Authentication state
- `impersonationProvider` - Impersonation state
- `localeProvider` - Language/locale selection
