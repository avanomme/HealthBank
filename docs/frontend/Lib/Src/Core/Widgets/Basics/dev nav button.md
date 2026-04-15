# DevNavButton

**File:** `frontend/lib/src/core/widgets/basics/dev_nav_button.dart`  
**Environment:** Development Only  
**Status:** Must be removed before production release

---

## Overview

`DevNavButton` is a development-only widget that provides quick access to a navigation dialog listing all application routes. It is intended to speed up navigation during UI development and testing.

When tapped, the button opens a modal dialog (`_DevNavDialog`) that:

- Shows grouped route links by category (Auth, Participant, Researcher, HCP, Admin)
- Allows direct navigation to any route via GoRouter (`context.go`)
- Includes a shortcut to open the full-page `DevHubPage`

This widget should not ship in production builds.

---

## Architecture / Design

### Key Components

- **`DevNavButton` (StatelessWidget)**
  - Renders an `IconButton` with a developer-mode icon.
  - Opens `_DevNavDialog` via `showDialog`.

- **`_DevNavDialog` (private StatelessWidget)**
  - Renders a `Dialog` containing:
    - Orange header with title and close button
    - “Open Dev Hub” button to navigate to the full-page Dev Hub
    - Scrollable route list grouped into sections
    - Red warning footer indicating dev-only usage

- **`_DevRoute` (private model)**
  - Stores:
    - `label` (display name)
    - `path` (GoRouter route path)
    - `icon` (icon used in the list)

### Navigation Flow

- Button press:
  - Calls `_showDevNavDialog(context)`
  - Displays `_DevNavDialog` with `showDialog`

- Route selection:
  - Pops the dialog (`Navigator.of(context).pop()`)
  - Navigates using `context.go(route.path)`

- Dev Hub shortcut:
  - Pops the dialog
  - Navigates to `AppRoutes.devHub`

### UI Layout

Dialog content uses a vertical `Column` with:

1. **Header**
   - Orange background for emphasis
   - Developer mode icon + title text
   - Close button

2. **Dev Hub Shortcut**
   - Full-width `ElevatedButton.icon`
   - Styled orange to match header

3. **Route List**
   - `Flexible` + `ListView` for scrollable route list
   - Each section is rendered by `_buildSection`

4. **Warning Footer**
   - Red-tinted footer with warning icon and message

### Section Rendering

- `_buildSection(title, routes)`
  - Section heading styled with muted theme text
  - Renders a list of route items
  - Adds a divider after each section

- `_buildRouteItem(route)`
  - Renders a `ListTile` with:
    - Icon
    - Label
    - Path (subtitle)
  - Navigates on tap

---

## Configuration

### Dependencies

- `go_router`
  - Uses `context.go(...)` to navigate
- `AppRoutes`
  - Route constants imported from:
    - `frontend/src/config/go_router.dart`
- `AppTheme`
  - Used for muted text styling (`AppTheme.textMuted`)
- Flutter Material
  - Dialogs, buttons, list tiles, etc.

### Production Safety Requirement

This file includes explicit “DEV ONLY” and “TODO: Remove before production release” warnings.

Recommended approaches:
- Remove the file and all usages prior to release
- Or gate it behind a build flag (e.g., `kDebugMode`) at the usage site

---

## API Reference

## `DevNavButton`

### Constructor

```dart
const DevNavButton({Key? key})