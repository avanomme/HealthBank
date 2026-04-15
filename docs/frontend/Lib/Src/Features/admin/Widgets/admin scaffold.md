# AdminScaffold

A Flutter `ConsumerStatefulWidget` that provides a consistent layout for admin-facing pages, including a top header, a "View As" role switcher toolbar, a collapsible left sidebar, and a configurable main content region.

File: `frontend/lib/features/admin/widgets/admin_scaffold.dart`

## Overview

`AdminScaffold` standardizes the admin dashboard layout and behavior:

- Renders the shared top `Header` used across roles.
- Displays an admin toolbar row below the header that includes:
  - A localized dashboard title.
  - A "View As" menu to navigate to other role dashboards.
- Provides a collapsible left sidebar navigation (`AdminSidebar`) with route highlighting.
- Hosts page content on the right, optionally wrapping it in a `SingleChildScrollView`.
- Integrates unread/pending indicators (notifications and account request count) into header and sidebar badges.
- Automatically hides the sidebar on mobile breakpoints and shows it on larger screens; preserves manual toggle via hamburger menu.

## Architecture / Design

### Component responsibilities

- **Layout composition**
  - Uses `Scaffold` with a `Column`:
    1. `Header`
    2. "View As" toolbar (`Container` height 48)
    3. Main area (`Expanded`) containing a `Row`:
       - Sidebar (`AnimatedContainer`) left
       - Content (`Expanded`) right

- **Responsive behavior**
  - Uses `LayoutBuilder` and `Breakpoints.isMobile(maxWidth)` to determine `isMobile`.
  - Tracks `_wasMobile` to detect breakpoint transitions.
  - When crossing breakpoints, schedules a post-frame state update to set:
    - `_sidebarVisible = !isMobile`
    - `_wasMobile = isMobile`

- **Sidebar collapse**
  - Maintains `_sidebarVisible` boolean state.
  - Toggles on hamburger menu (`Header.onMenuTap`).
  - Animates width between `240` and `0` via `AnimatedContainer`.

- **Role switching ("View As")**
  - Uses `PopupMenuButton<String>` with localized role labels.
  - On selection:
    - Updates `adminViewAsRoleProvider.notifier.state` to selected role string.
    - Navigates to the corresponding dashboard route via `GoRouter` (`context.go(...)`).

- **Pending account requests integration**
  - Watches `accountRequestCountProvider` (Riverpod).
  - Uses the value to:
    - Set `Header.hasNotifications` (combined with `widget.hasNotifications`)
    - Add a sidebar badge to the "Messages" item (if `pendingCount > 0`)

### State and providers

- Riverpod access:
  - Reads `authProvider` to resolve a display name.
  - Watches `accountRequestCountProvider` to show pending counts.
  - Writes to `adminViewAsRoleProvider` when switching roles.

- Internal state:
  - `_sidebarVisible`: whether the sidebar is shown.
  - `_wasMobile`: previous breakpoint state to detect transitions.

### Navigation

- Uses `go_router`:
  - Header logo tap: `context.go(AppRoutes.admin)`
  - Sidebar navigation: `context.go(route)`
  - Role switch navigation: `context.go(AppRoutes.<roleDashboard>)`

## Configuration

No external configuration is required.

The widget supports behavioral configuration through constructor parameters, including optional callbacks and scroll behavior. Localization strings are pulled from `context.l10n`.

## API Reference

### `AdminScaffold`

#### Constructor

```dart
AdminScaffold({
  Key? key,
  required String currentRoute,
  required Widget child,
  String userName = 'Admin',
  int messageCount = 0,
  bool hasNotifications = false,
  VoidCallback? onNotificationsTap,
  VoidCallback? onProfileTap,
  bool scrollable = true,
})