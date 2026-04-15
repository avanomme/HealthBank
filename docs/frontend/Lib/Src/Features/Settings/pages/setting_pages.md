# SettingsPage

## Overview

`SettingsPage` is an authenticated account settings screen focused on security actions, specifically managing Two-Factor Authentication (2FA). It provides:

* A navigation entry to a 2FA setup/confirmation flow
* A destructive action to disable 2FA with confirmation
* Basic success/error feedback messaging
* A (currently stubbed) language selector row at the bottom

The page is guarded: unauthenticated users are redirected to `/login`.

File: (not provided in snippet)

## Architecture / Design

* **Widget type:** `ConsumerStatefulWidget` (needs local UI state + Riverpod access)
* **Layout:** Uses `BaseScaffold` with:

  * `header: Header(navItems: [])` (empty header)
  * `padding: EdgeInsets.zero`
  * `scrollable: false`
  * `showFooter: false`
* **Auth guard:** Watches `authProvider` and triggers `context.go('/login')` via a post-frame callback if `!auth.isAuthenticated`.
* **API wiring:** Creates a `TwoFactorAPI` instance using the shared `ApiClient` from `apiClientProvider` (imported from the question bank module).
* **Local UI state:**

  * `_busy` controls loading/disable states and spinners
  * `_error` and `_success` display user feedback

UI structure:

BaseScaffold
└── Column
  ├── Expanded → Center → Card-like container (settings content)
  └── Bottom language selector (currently TODO)

## Configuration

No constructor parameters beyond `key`.

Dependencies:

* `authProvider` for authentication state
* `apiClientProvider` to construct `TwoFactorAPI`
* `go_router` for navigation (`go` and `push`)
* `AppTheme`, `Breakpoints`, and `context.l10n` for styling/localization

## API Reference

## `class SettingsPage extends ConsumerStatefulWidget`

No public fields.

## `_SettingsPageState`

### State fields

* `_busy : bool` — whether an API operation is in progress (disables actions, shows spinners).
* `_error : String?` — error message shown in the UI.
* `_success : String?` — success message shown in the UI.

### `_twoFactorApi() -> TwoFactorAPI`

Builds a `TwoFactorAPI` using:

* `final client = ref.read(apiClientProvider);`
* `TwoFactorAPI(client.dio)`

### `_disable2fa() -> Future<void>`

Disables 2FA and updates UI state.

Flow:

1. Set `_busy = true`, clear `_error`/`_success`
2. Call `api.twoFactorDisable()`
3. On success:

   * `_busy = false`
   * `_success` set to `res.message` if non-empty else `"2FA disabled"`
4. On failure:

   * `_busy = false`
   * `_error = "Failed to disable 2FA. Please try again."`

### Build behavior

* If unauthenticated, schedules redirect to `/login` and returns `SizedBox.shrink()`.
* Otherwise renders:

  * A scrollable card containing:

    * Title (`settingsTitle`) and description text
    * “Security” section
    * 2FA navigation tile (`/two-factor?returnTo=/settings`)
    * “Disable 2FA” tile with confirmation dialog and destructive styling
  * A bottom language selector (hardcoded “EN”, TODO on tap)

## Error Handling

* **Auth:** Redirects unauthenticated users to `/login`.
* **2FA disable:** Catches all exceptions (generic catch) and shows a user-friendly error message; does not expose the raw exception.
* **Mounted checks:** Uses `if (!mounted) return;` before mutating state after async calls.

## Usage Examples

### Routing

```
GoRoute(
  path: '/settings',
  builder: (context, state) => const SettingsPage(),
)
```

### 2FA navigation

From the security list tile:

* `context.push('/two-factor?returnTo=/settings')`

## Related Files

* `frontend/src/features/auth/state/auth_providers.dart` — Provides `authProvider` and authentication state.
* `frontend/src/features/question_bank/state/question_providers.dart` — Source of `apiClientProvider` used to build `TwoFactorAPI`.
* `frontend/src/core/api/api.dart` — Defines `TwoFactorAPI` and response models.
* `frontend/src/core/widgets/layout/base_scaffold.dart` — Base layout wrapper.
* `frontend/src/core/widgets/basics/header.dart` — Header used in the scaffold.
* `frontend/src/core/theme/theme.dart` — `AppTheme` and `Breakpoints`.
* `go_router` routes for `/login`, `/two-factor`, and `/settings`.
* `frontend/src/core/l10n/l10n.dart` — Localization keys like `settingsTitle`.
