# researcher_header.dart

## Overview

`ResearcherHeader` is a specialized navigation header used across researcher-facing pages. It wraps the shared `Header` widget and configures it with navigation items relevant to researcher workflows.

The header provides links to:

* Dashboard
* Surveys
* Templates
* Question Bank
* Data / Research Data view

File: `frontend/lib/src/features/researcher/widgets/researcher_header.dart`

## Architecture / Design

`ResearcherHeader` is a `StatelessWidget` implementing `PreferredSizeWidget`, allowing it to be used as an app bar within scaffold-based layouts.

The widget delegates most functionality to the shared `Header` component but injects:

* Researcher-specific navigation items
* Localized labels
* Routing behavior via `GoRouter`
* Optional notification/profile interactions

Navigation items are generated dynamically using localization (`context.l10n`).

Layout hierarchy:

ResearcherHeader
└── Header (core reusable widget)
  ├── Navigation items
  ├── Notification icon
  ├── Profile dropdown
  └── Logo navigation

## Configuration

Constructor:

```
const ResearcherHeader({
  required String currentRoute,
  VoidCallback? onNotificationsTap,
  VoidCallback? onProfileTap,
  bool hasNotifications = false,
  String? userName,
})
```

Parameters:

| Parameter            | Type            | Description                                                |
| -------------------- | --------------- | ---------------------------------------------------------- |
| `currentRoute`       | `String`        | Current route used to highlight the active navigation item |
| `onNotificationsTap` | `VoidCallback?` | Triggered when notifications icon is clicked               |
| `onProfileTap`       | `VoidCallback?` | Triggered when profile icon is clicked                     |
| `hasNotifications`   | `bool`          | Indicates unread notifications                             |
| `userName`           | `String?`       | Display name for the user profile dropdown                 |

Preferred size:

```
Size.fromHeight(64)
```

## API Reference

### Class

`class ResearcherHeader extends StatelessWidget implements PreferredSizeWidget`

### Internal Methods

#### `_getNavItems(BuildContext context) → List<NavItem>`

Returns researcher navigation configuration:

| Label (localized) | Route                   |
| ----------------- | ----------------------- |
| Dashboard         | `/researcher/dashboard` |
| Surveys           | `/surveys`              |
| Templates         | `/templates`            |
| Question Bank     | `/questions`            |
| Data              | `/researcher/data`      |

### Routing Behavior

Navigation is handled using `GoRouter`:

* Nav item click → `context.go(route)`
* Logo click → `context.go('/researcher/dashboard')`

## Error Handling

No explicit error handling exists in this widget. It relies on:

* `Header` widget behavior
* `GoRouter` route resolution
* Localization availability (`context.l10n`)

If a route is invalid, navigation errors would be handled by the router configuration.

## Usage Examples

Example inside a scaffold layout:

```
BaseScaffold(
  header: ResearcherHeader(
    currentRoute: '/researcher/dashboard',
  ),
  child: DashboardContent(),
)
```

With optional callbacks:

```
ResearcherHeader(
  currentRoute: '/researcher/data',
  hasNotifications: true,
  userName: 'Dr. Smith',
  onNotificationsTap: () {},
  onProfileTap: () {},
)
```

## Related Files

* `frontend/src/core/widgets/basics/header.dart` — Base header implementation
* `frontend/lib/src/features/researcher/widgets/researcher_scaffold.dart` — Layout wrapper using this header
* `frontend/lib/src/features/researcher/pages/researcher_dashboard_page.dart`
* `frontend/lib/src/features/researcher/pages/researcher_pull_data_page.dart`
* `go_router` configuration defining researcher routes
