# researcher_scaffold.dart

## Overview

`ResearcherScaffold` is a convenience layout wrapper used by all researcher-facing pages. It combines the shared `BaseScaffold` layout with a preconfigured `ResearcherHeader` to ensure consistent navigation and page structure across researcher UI screens.

File: `frontend/lib/src/features/researcher/widgets/researcher_scaffold.dart`

## Architecture / Design

`ResearcherScaffold` is a `StatelessWidget` that delegates layout responsibilities to `BaseScaffold` while automatically injecting the researcher navigation header.

Component structure:

ResearcherScaffold
└── BaseScaffold
  ├── ResearcherHeader (navigation)
  ├── Page content
  ├── Optional floating action button
  └── Optional footer

The widget centralizes common configuration used across researcher pages, including:

* Navigation header
* Optional scrolling behavior
* Optional footer
* Layout padding
* Floating action button
* Notification/profile UI hooks

This avoids repeating header configuration in each page implementation.

## Configuration

Constructor:

```
const ResearcherScaffold({
  required String currentRoute,
  required Widget child,
  bool scrollable = false,
  bool showFooter = false,
  EdgeInsets padding = EdgeInsets.zero,
  Widget? floatingActionButton,
  bool hasNotifications = false,
  VoidCallback? onNotificationsTap,
  VoidCallback? onProfileTap,
  String? userName,
})
```

Parameters:

| Parameter              | Type            | Description                                                      |
| ---------------------- | --------------- | ---------------------------------------------------------------- |
| `currentRoute`         | `String`        | Route used to highlight the active navigation item in the header |
| `child`                | `Widget`        | Main page content                                                |
| `scrollable`           | `bool`          | Wraps content in scroll behavior when true                       |
| `showFooter`           | `bool`          | Displays the application footer when true                        |
| `padding`              | `EdgeInsets`    | Padding applied around page content                              |
| `floatingActionButton` | `Widget?`       | Optional floating action button                                  |
| `hasNotifications`     | `bool`          | Indicates unread notifications                                   |
| `onNotificationsTap`   | `VoidCallback?` | Notification icon callback                                       |
| `onProfileTap`         | `VoidCallback?` | Profile icon callback                                            |
| `userName`             | `String?`       | Name displayed in the header profile menu                        |

## API Reference

### Class

`class ResearcherScaffold extends StatelessWidget`

### Build Behavior

The widget constructs a `BaseScaffold` with the following configuration:

```
BaseScaffold(
  header: ResearcherHeader(...),
  scrollable: scrollable,
  showFooter: showFooter,
  padding: padding,
  floatingActionButton: floatingActionButton,
  child: child,
)
```

The `ResearcherHeader` is configured with:

* `currentRoute`
* notification state
* optional notification/profile callbacks
* optional user name

## Error Handling

No internal error handling exists within this widget. It relies on:

* `BaseScaffold` for layout behavior
* `ResearcherHeader` for navigation logic

Errors related to navigation or layout are handled by those underlying components.

## Usage Examples

### Simple page

```
ResearcherScaffold(
  currentRoute: '/surveys',
  child: YourListWidget(),
)
```

### Page with floating action button

```
ResearcherScaffold(
  currentRoute: '/surveys',
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
  ),
  child: YourContent(),
)
```

### Scrollable content page

```
ResearcherScaffold(
  currentRoute: '/templates',
  scrollable: true,
  child: YourScrollableContent(),
)
```

## Related Files

* `frontend/src/core/widgets/layout/base_scaffold.dart` — Base layout container
* `frontend/lib/src/features/researcher/widgets/researcher_header.dart` — Researcher navigation header
* `frontend/lib/src/features/researcher/pages/researcher_dashboard_page.dart`
* `frontend/lib/src/features/researcher/pages/researcher_pull_data_page.dart`
