# LoginPage

The main login screen for the application. Presents a centered `LoginCard`, handles authentication flow branching (MFA, forced password change, profile completion, consent), and provides links to forgot-password and account request flows.

File: `frontend/lib/src/features/auth/pages/login_page.dart`

## Overview

`LoginPage` is a `ConsumerWidget` that:

- Renders a header-only layout (no nav items) using `BaseScaffold` + `Header`.
- Shows a centered `LoginCard` that:
  - Collects user credentials
  - Triggers login via the auth provider
  - Exposes actions for:
    - Forgot password
    - Request account
- Listens for auth errors and displays them via a `SnackBar`.
- Routes users after login based on auth state:
  - MFA required → `/two-factor`
  - Must change password → `/change-password`
  - Profile completion required → `AppRoutes.completeProfile`
  - Consent not signed → `AppRoutes.consent`
  - Otherwise → role dashboard route via `getDashboardRouteForRole(role)`
- Displays a bottom-right language selector placeholder (currently a TODO).

## Architecture / Design

### Widget responsibilities

- `LoginPage`
  - Top-level auth entry screen.
  - Manages:
    - Auth error feedback via `ref.listen`
    - Login submission via `_handleLogin`
    - Navigation to supporting flows (forgot password, request account)
  - Provides responsive scrolling to keep the login card usable on small screens.

### Layout structure

`BaseScaffold` configuration:

- `header: const Header(navItems: [])`
- `padding: EdgeInsets.zero`
- `scrollable: false`
- `showFooter: false`

Body:

- `Column`
  - `Expanded`:
    - `LayoutBuilder` → `SingleChildScrollView` + `ConstrainedBox(minHeight: maxHeight)`
    - Centers `LoginCard` with vertical padding
  - Bottom language selector (`_buildLanguageSelector()`), always visible

### Auth state integration and error feedback

- Watches `authProvider` to get:
  - `authState.isLoading` (passed into `LoginCard`)
- Listens to `authProvider` changes:
  - If `next.error` changes to a non-null value, shows a `SnackBar` with `AppTheme.error` background.

### Login and post-login routing

`_handleLogin`:

1. Calls:
   - `await ref.read(authProvider.notifier).login(email, password)`
   - Expects a returned `role` (nullable).
2. If context is unmounted, aborts.
3. Checks auth state conditions in order:
   - `authState.mfaRequired` → `context.go('/two-factor')`
   - If `role != null`:
     - `authState.mustChangePassword` → `context.go('/change-password')`
     - `authState.needsProfileCompletion` → `context.go(AppRoutes.completeProfile)`
     - `!authState.hasSignedConsent` → `context.go(AppRoutes.consent)`
     - Else → `context.go(getDashboardRouteForRole(role))`

Supporting navigation actions:

- Forgot password: `context.push('/forgot-password')`
- Request account: `context.push('/request-account')`

### Language selector

- `_buildLanguageSelector` renders a bottom-right UI control currently hardcoded to `EN`.
- Tap handler contains a TODO comment to implement language change.

## Configuration

No external configuration is required, but this page assumes:

- Riverpod provider:
  - `authProvider` (state + notifier with `login`)
- Auth state type:
  - `AuthState` (used in `ref.listen<AuthState>`)
- Routing helpers/constants:
  - `AppRoutes.completeProfile`
  - `AppRoutes.consent`
  - `getDashboardRouteForRole(role)`
- Supporting routes exist:
  - `/two-factor`
  - `/change-password`
  - `/forgot-password`
  - `/request-account`
- UI components:
  - `LoginCard`
  - `BaseScaffold`
  - `Header`
- Theme:
  - `AppTheme`

## API Reference

## `LoginPage`

### Constructor

```dart
const LoginPage({Key? key});