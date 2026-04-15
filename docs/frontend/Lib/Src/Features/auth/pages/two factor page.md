# TwoFactorPage

A dual-purpose 2FA page that supports both:

1. Completing a login-time MFA challenge (user is prompted for a 6-digit authenticator code), and
2. Enrolling and confirming 2FA for an already-authenticated user (retrieve provisioning URI, show QR code, confirm code).

File: `frontend/lib/src/features/auth/pages/two_factor_page.dart`

## Overview

`TwoFactorPage` is a `ConsumerStatefulWidget` that:

- Renders an auth-style centered card inside `BaseScaffold` with a `Header`.
- Detects whether it is being used for:
  - **Login MFA challenge** (auth state indicates `mfaRequired` with a challenge token), or
  - **2FA enrollment** (user is already authenticated and not in challenge mode)
- In enrollment mode:
  - Calls `TwoFactorAPI.twoFactorEnroll()` to retrieve a provisioning URI
  - Displays a QR code using `qr_flutter` (`QrImageView`)
  - Shows the raw provisioning URI in a selectable text box
  - Accepts a 6-digit code and confirms 2FA via `TwoFactorAPI.twoFactorConfirm(...)`
- In challenge mode:
  - Accepts a 6-digit code and verifies via `authProvider.notifier.verifyMfa(code)`
  - Performs the same post-login routing checks used elsewhere:
    - Forced password change
    - Profile completion
    - Consent
    - Role dashboard route

The page includes a bottom language selector placeholder (TODO) and a “Back” button that returns to a provided route.

## Architecture / Design

### Modes and routing logic

The page operates in two mutually exclusive modes:

- **MFA challenge mode**
  - Determined by:
    - `authState.mfaRequired == true`
    - `authState.mfaChallengeToken` is non-empty
  - Primary action: “Verify”
  - Verification: `authProvider.notifier.verifyMfa(code)`
  - On success, performs post-login routing:
    - `/change-password` if `mustChangePassword`
    - `AppRoutes.completeProfile` if `needsProfileCompletion`
    - `AppRoutes.consent` if `!hasSignedConsent`
    - otherwise `getDashboardRouteForRole(role)`

- **Enrollment mode**
  - Determined by:
    - `authState.isAuthenticated == true`
    - not in MFA challenge mode
  - Primary actions:
    - “Enroll (API)” calls `twoFactorEnroll()` and retrieves provisioning URI
    - “Confirm 2FA” calls `twoFactorConfirm(code)`
  - UI becomes progressively enabled:
    - Code confirmation is only enabled after provisioning URI is available

If the user is neither in challenge mode nor authenticated, the page shows an instructional message to log in first.

### State management

Internal state:

- `_isBusy` (`bool`): disables interactions and shows a spinner while API actions are running.
- `_error` (`String?`): local error string used outside provider error.
- `_provisioningUri` (`String?`): set after enrollment; used for QR display and confirmation gating.
- `_confirmMessage` (`String?`): message returned by confirm API (e.g., “2FA enabled”), shown after successful confirm.
- `_codeController` (`TextEditingController`): holds the 6-digit code.

Auth state usage:

- Watches `authProvider` for:
  - `mfaRequired`
  - `mfaChallengeToken`
  - `isAuthenticated`
  - `error`
  - post-login flags (`mustChangePassword`, `needsProfileCompletion`, `hasSignedConsent`)

### Action enablement

`_canConfirm` returns true when:

- Not busy (`_isBusy == false`)
- Code length is exactly 6
- And:
  - In challenge mode: `true`
  - In enrollment mode: provisioning URI exists (`_provisioningUri != null`)

### API interactions

Enrollment:

- Uses `apiClientProvider` to access `dio`
- Instantiates `TwoFactorAPI(client.dio)`
- Calls `twoFactorEnroll()`
- Stores `res.provisioningUri` on success

Confirmation:

- Calls `twoFactorConfirm(TwoFactorConfirmRequest(code: code))`
- Stores `res.message` in `_confirmMessage`

Login-time verification:

- Calls `authProvider.notifier.verifyMfa(code)` which returns a role (nullable)
- Uses returned role to route to the correct dashboard if other gating conditions are satisfied

### UI layout

Top-level layout:

- `BaseScaffold` with:
  - `header: const Header(navItems: [])`
  - `padding: EdgeInsets.zero`
  - `scrollable: false`
  - `showFooter: false`

Body:

- `Column`
  - Centered, scrollable card (`_buildCard`)
  - Bottom language selector placeholder (`_buildLanguageSelector`)

Card:

- Constrained to max width 620
- Contains:
  - Title
  - Mode-specific instructions
  - Busy indicator
  - Error display (prefers provider error in challenge mode)
  - Enrollment block (QR + provisioning URI + enroll button) when applicable
  - Code entry block (for verify/confirm) when applicable
  - Back button

### QR code and provisioning URI

- QR code rendered via `qr_flutter` `QrImageView` with `QrVersions.auto`
- Raw provisioning URI is shown via `_ProvisioningUriBox` using `SelectableText`

### Back behavior

The “Back” button:

- If in MFA challenge mode:
  - Calls `ref.read(authProvider.notifier).clearMfaChallenge()`
- Navigates to:
  - `widget.returnTo` if provided, else `/login`

## Configuration

No external configuration is required, but this page expects:

- Riverpod provider:
  - `authProvider` (auth state and notifier methods: `verifyMfa`, `clearMfaChallenge`)
- API client provider:
  - `apiClientProvider` (exposes configured Dio instance)
- API service/models:
  - `TwoFactorAPI`
  - `TwoFactorConfirmRequest`
- Routing helpers/constants:
  - `AppRoutes.completeProfile`
  - `AppRoutes.consent`
  - `getDashboardRouteForRole(role)`
- Theme:
  - `AppTheme` and `Breakpoints`
- QR rendering dependency:
  - `qr_flutter`

## API Reference

## `TwoFactorPage`

### Constructor

```dart
const TwoFactorPage({
  Key? key,
  String? returnTo,
});