# Impersonation Banner Widgets

A set of Flutter widgets that display a warning banner when a system administrator is impersonating another user, with controls to end impersonation and return to the admin area.

File: `frontend/lib/src/features/admin/widgets/impersonation_banner.dart`

## Overview

This file defines multiple widgets for presenting impersonation state to the user:

- `ImpersonationBanner`: A fixed-height caution banner that appears only while impersonation is active.
- `_BackToAdminButton`: A button used within the banner that supports loading/disabled states.
- `AnimatedImpersonationBanner`: A banner with slide + fade animation (visibility driven by impersonation state).
- `ImpersonationBannerWrapper`: A convenience wrapper that inserts the banner above arbitrary page content.

The banner:

- Displays a warning-style UI (caution background + shadow).
- Shows a localized message: "Viewing as [User Name] ([Email])".
- Provides a button to end impersonation and return to the admin area.
- Automatically hides when not impersonating.

## Architecture / Design

### State source

All widgets derive visibility and content from Riverpod:

- `impersonationProvider` (watched in each `ConsumerWidget`)

The provider is expected to expose, at minimum:

- `isImpersonating` (`bool`)
- `isLoading` (`bool`)
- `currentUserName` (`String`)
- `currentUser` (object with `email`, nullable)
- `error` (`String?`)

The notifier is expected to provide:

- `Future<bool> endImpersonation()`
- `void clearImpersonationState()`

### `ImpersonationBanner`

- Renders `SizedBox.shrink()` if `!impersonationState.isImpersonating`.
- Otherwise renders a `Container`:
  - Height: `kImpersonationBannerHeight`
  - Background: `AppTheme.caution`
  - Shadow: slight drop shadow
- Contents:
  - Visibility icon
  - Localized message via `context.l10n.adminViewingAsUser(userName, userEmail)`
  - `_BackToAdminButton`:
    - Disabled while `isLoading` is true
    - Calls `_handleEndImpersonation(...)`

### Ending impersonation flow (`_handleEndImpersonation`)

1. Calls `await notifier.endImpersonation()`
2. If successful:
   - Calls `notifier.clearImpersonationState()`
   - Navigates using `appRouter.go(AppRoutes.adminUsers)`
   - If `context.mounted`, shows a success `SnackBar` using:
     - `context.l10n.adminReturnedToDashboard`
     - `AppTheme.success`
3. If unsuccessful and `context.mounted`:
   - Reads `error` from the provider state
   - Shows an error `SnackBar` using:
     - `error ?? context.l10n.adminEndViewAsError`
     - `AppTheme.error`
4. If the context is not mounted after the async call:
   - Only logs to `debugPrint`; no UI attempt is made.

### `_BackToAdminButton`

- A `TextButton.icon` that:
  - Disables interaction when `isLoading` is true
  - Shows a spinner icon when loading
  - Otherwise shows `Icons.admin_panel_settings`
- Label text is localized:
  - Loading: `context.l10n.adminReturning`
  - Normal: `context.l10n.adminBackToAdmin`

### `AnimatedImpersonationBanner`

- Watches `impersonationProvider` and derives `isVisible` from `isImpersonating`.
- Uses:
  - `AnimatedSlide` to slide vertically off-screen when hidden
  - `AnimatedOpacity` to fade in/out
- Always includes `ImpersonationBanner` as the child; visibility is handled by animations and the banner’s own conditional rendering.

### `ImpersonationBannerWrapper`

- Intended for top-level layout composition:
  - Uses a `Column` with:
    1. An `AnimatedContainer` that expands/collapses height based on `isImpersonating`
    2. An `Expanded` child for main content
- When impersonating, renders `ImpersonationBanner` inside the header area.

## Configuration

No external configuration is required.

Integration requirements:

- `impersonationProvider` and its notifier must be available in the widget tree (via Riverpod).
- `appRouter` and `AppRoutes.adminUsers` must be defined and accessible.
- Localization keys used by this file must exist in `context.l10n`.

## API Reference

## Constants

### `kImpersonationBannerHeight`

```dart
const double kImpersonationBannerHeight = 48.0;