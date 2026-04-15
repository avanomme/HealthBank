# Admin Components

Frontend components for the admin dashboard.

## Reset Password Modal

A modal dialog for resetting user passwords, displayed from the user management table.

### Location

`frontend/lib/src/features/admin/widgets/reset_password_modal.dart`

### Usage

```dart
import 'package:frontend/src/features/admin/widgets/widgets.dart';

// Show the modal
final result = await showResetPasswordModal(context, user);
if (result == true) {
  // Password was reset successfully
}
```

### Features

1. **User Info Display** - Shows user's name and email at the top
2. **Password Field** - Text field with:
   - Visibility toggle (show/hide password)
   - Minimum 8 character validation
3. **Generate Password Button** - Creates random 12-character alphanumeric password
4. **Copy to Clipboard** - Copy generated password
5. **Send Email Checkbox** - Option to email the temporary password
6. **Alternate Email** - When email is enabled, option to send to different address
7. **Loading State** - Shows spinner during API calls
8. **Error Display** - Shows error messages in red banner

### Props

| Prop | Type | Required | Description |
|------|------|----------|-------------|
| `user` | `User` | Yes | The user whose password is being reset |

### API Calls

The modal makes two API calls when submitted:

1. `POST /api/v1/admin/users/{userId}/reset-password` - Reset the password
2. `POST /api/v1/admin/users/{userId}/send-reset-email` - Send email (if enabled)

### Password Generation

Generated passwords are 12 characters using:
- Uppercase letters (excluding I, O)
- Lowercase letters (excluding i, l, o)
- Numbers (excluding 0, 1)

This avoids ambiguous characters.

### Integration

The modal is opened from the User Management table via the key icon button:

```dart
// In user_management_page.dart
IconButton(
  icon: const Icon(Icons.lock_reset, size: 20),
  onPressed: () => _showResetPasswordDialog(user),
  tooltip: 'Reset Password',
  color: AppTheme.caution,
),
```

## Impersonation Banner

A warning banner displayed when an admin is impersonating a user. Shows on all pages.

### Location

`frontend/lib/src/features/admin/widgets/impersonation_banner.dart`

### Usage

```dart
import 'package:frontend/src/features/admin/widgets/widgets.dart';

// Simple banner (auto-hides when not impersonating)
const ImpersonationBanner()

// Animated version with slide animation
const AnimatedImpersonationBanner()

// Wrapper that adds banner above child content
ImpersonationBannerWrapper(
  child: YourPageContent(),
)
```

### Features

1. **Automatic Visibility** - Only shows when `isImpersonating` is true
2. **User Info Display** - Shows "Viewing as [Name] ([Email])"
3. **Warning Styling** - Yellow/caution color to indicate impersonation mode
4. **Back to Admin Button** - Returns to admin dashboard
5. **Loading State** - Shows spinner during end impersonation
6. **Success/Error Messages** - Snackbar notifications

### Components

| Component | Description |
|-----------|-------------|
| `ImpersonationBanner` | Basic banner (48px height) |
| `AnimatedImpersonationBanner` | Banner with slide in/out animation |
| `ImpersonationBannerWrapper` | Wrapper widget that adds banner above child |

### Constants

```dart
const double kImpersonationBannerHeight = 48.0;
```

### Styling

- **Background**: `AppTheme.caution` (yellow/orange)
- **Text**: `AppTheme.textPrimary` (black)
- **Button**: `AppTheme.primary` background with white text
- **Height**: 48 pixels
- **Shadow**: Subtle drop shadow for depth

### State Integration

The banner watches `impersonationProvider` for state:

```dart
final impersonationState = ref.watch(impersonationProvider);

if (impersonationState.isImpersonating) {
  // Show banner
}
```

### End Impersonation Flow

1. User clicks "Back to Admin" button
2. Calls `impersonationProvider.notifier.endImpersonation()`
3. On success: redirects to `/admin`, shows success snackbar
4. On failure: shows error snackbar with message

---

## User Management Table Actions

The user table includes these action buttons:

| Icon | Action | Description |
|------|--------|-------------|
| `lock_reset` | Reset Password | Opens password reset modal |
| `visibility` | View As User | Start impersonation (System Admin only) |
| `edit_outlined` | Edit User | Opens user edit dialog |
| `block_outlined` / `check_circle_outline` | Toggle Status | Activate/deactivate user |
