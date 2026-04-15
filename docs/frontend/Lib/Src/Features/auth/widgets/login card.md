# LoginCard

A reusable authentication UI card that presents a welcome message, embeds the `LoginForm`, and provides a “Request Account” call-to-action. Designed to match the Figma layout and used by the login page as the primary credential entry component.

File: `frontend/lib/features/auth/widgets/login_card.dart`

## Overview

`LoginCard` is a `StatelessWidget` that:

- Renders a centered card with a border and responsive padding.
- Shows:
  - A localized welcome title (“Welcome to …”)
  - A localized subtitle (“Please log in to continue.”)
- Embeds `LoginForm` for email/password entry and forgot password action.
- Provides a divider and a “New Here? Request An Account” button.
- Supports a loading state to disable actions while login is in progress.

## Architecture / Design

### Widget responsibilities

- `LoginCard`
  - Presentation-only container around:
    - Header text (title + subtitle)
    - `LoginForm` for credential entry
    - Request account button

- `LoginForm` (child dependency)
  - Handles actual input fields, submit behavior, and forgot password action UI.
  - `LoginCard` passes through callbacks and loading state.

### Layout and responsiveness

- Constrained to max width 400 via `ConstrainedBox`.
- Uses `Breakpoints.isMobile(screenWidth)` to set:
  - `cardPadding`: 24 (mobile) or 40 (desktop)
  - Horizontal margin: 16 (mobile) or 0 (desktop)
- Uses `SingleChildScrollView` inside the card to avoid overflow on small screens.

### Callbacks and interaction flow

- `onLogin` is forwarded to `LoginForm` via `onSubmit`.
- `onForgotPassword` is forwarded to `LoginForm`.
- `onRequestAccount` is invoked by the “Request Account” button.
- `isLoading` disables:
  - `LoginForm` inputs/actions (via prop)
  - Request account button (`onPressed: isLoading ? null : onRequestAccount`)

### Localization and theming

- Localized strings come from `context.l10n`.
- Styling uses `AppTheme`:
  - Card colors/border (`AppTheme.white`, `AppTheme.gray`)
  - Text styles (`AppTheme.heading4`, `AppTheme.body`)
  - Primary/secondary colors (`AppTheme.primary`, `AppTheme.secondary`)

## Configuration

No external configuration is required.

Expected dependencies:

- `Breakpoints` and `AppTheme` from `frontend/src/core/theme/theme.dart`
- Localization extension from `frontend/src/core/l10n/l10n.dart`
- `LoginForm` from `frontend/src/features/auth/widgets/login_form.dart`

## API Reference

## `LoginCard`

### Constructor

```dart
const LoginCard({
  Key? key,
  void Function(String email, String password)? onLogin,
  VoidCallback? onForgotPassword,
  VoidCallback? onRequestAccount,
  bool isLoading = false,
});