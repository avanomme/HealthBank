# AdminViewAsBanner

A banner widget displayed when a system administrator is temporarily viewing the application as another role using the "View As" feature.

File: `frontend/lib/src/features/admin/widgets/admin_view_as_banner.dart`

## Overview

`AdminViewAsBanner` provides a visual indicator that an administrator is currently navigating the application in a role-specific context (e.g., Participant, Researcher, or HCP).  

The banner appears at the top of the interface and communicates that the admin is viewing the system as another role while still using their own authenticated session.

Key behaviors:

- Displays a caution-colored banner indicating the currently viewed role.
- Shows a localized message such as "Viewing as Participant".
- Provides a "Back to Admin" button that clears the "View As" state and navigates back to the admin dashboard.
- Only renders when:
  - A role is selected in `adminViewAsRoleProvider`, and
  - The current user is a system administrator.

This feature is purely client-side and does not modify the authenticated user session or backend state.

## Architecture / Design

### Widget type

- `AdminViewAsBanner` extends `ConsumerWidget` to integrate with Riverpod state management.

### Conditional rendering

The banner renders only when both conditions are met:

1. `adminViewAsRoleProvider` contains a non-null role value.
2. `isSystemAdminProvider` returns `true`.

If either condition fails, the widget returns an empty `SizedBox` to avoid occupying layout space.

### Role resolution

The role identifier stored in the provider (e.g., `participant`, `researcher`, `hcp`) is translated into a localized display name using the `_roleName` helper method and the localization system (`context.l10n`).

### Layout structure

The banner layout is composed as follows:

- Root `Container`
  - Fixed height defined by `kAdminViewAsBannerHeight`
  - Full width
  - Background color: `AppTheme.caution`
  - Drop shadow for elevation

- `Row` layout containing:
  - Visibility icon
  - Localized text message indicating the viewed role
  - "Back to Admin" action button

### Navigation behavior

The "Back to Admin" button performs two actions:

1. Clears the view-as state: