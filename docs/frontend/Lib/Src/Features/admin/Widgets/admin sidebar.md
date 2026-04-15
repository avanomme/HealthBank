# AdminSidebar

Admin sidebar navigation for the admin area, including branding, a “logged in as” header, and a scrollable list of navigation items with optional badge counts.

File: `frontend/lib/features/admin/widgets/admin_sidebar.dart`

## Overview

`AdminSidebar` is a `StatelessWidget` that renders a left-side navigation panel matching the intended design:

- Displays the HealthBank brand mark (“Health” + “Bank”) at the top.
- Shows localized “Logged in as” label and the current user’s name.
- Renders a list of navigation items (`SidebarItem`) with:
  - Active route highlighting
  - Hover styling for desktop/web
  - Optional icons
  - Optional badge counts (e.g., pending messages/requests)

Logout is intentionally not included here; it is expected to be handled by the shared header component for consistency across roles.

## Architecture / Design

### Key types

- `SidebarItem`
  - A lightweight immutable model describing a single navigation row.

- `AdminSidebar`
  - Container + column layout:
    - Header area (branding + user info)
    - Divider
    - Scrollable nav list

- `_SidebarItemWidget`
  - Stateful item row that manages hover state (`_isHovered`) using `MouseRegion`.
  - Uses `InkWell` for tap interaction and provides visual states:
    - Active: `AppTheme.primary` background and contrast text
    - Hover: `AppTheme.gray` background
    - Default: transparent background

### Layout behavior

- Sidebar width is configurable via the `width` parameter (default `240`).
- Navigation list is wrapped in `SingleChildScrollView` to accommodate long menus.
- Active route determination is performed by comparing `currentRoute == item.route`.

### Styling and localization

- Colors and typography are driven by `AppTheme`.
- The “Logged in as” label is localized via `context.l10n.adminLoggedInAsLabel`.
- Navigation item labels are currently provided by `SidebarItem.label` (not localized within this file); callers can supply localized strings if desired.

## Configuration

No external configuration is required.

The widget is configured through constructor parameters, including the list of items, current route, and navigation callback.

## API Reference

## `SidebarItem`

### Constructor

```dart
const SidebarItem({
  required String label,
  required String route,
  IconData? icon,
  int? badgeCount,
})