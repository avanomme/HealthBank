# Header

**File:** `frontend/lib/src/core/widgets/basics/header.dart`

## Overview

`Header` is a reusable application header (top navigation bar) designed to match the project’s Figma design. It displays:

- A branded “HealthBank” logo (split-color wordmark)
- Navigation items (desktop only)
- A compact hamburger menu with a bottom-sheet drawer (mobile/tablet)
- Action controls (notifications + profile menu)
- Optional development navigation entrypoint (desktop only)

`Header` is implemented as a Riverpod `ConsumerWidget` and also implements `PreferredSizeWidget`, making it suitable for use as a `Scaffold.appBar`.

---

## Architecture / Design

### Key Types

#### `NavItem`

Model representing a navigation entry displayed in the header.

| Field | Type | Description |
|------|------|-------------|
| `label` | `String` | User-facing label |
| `route` | `String` | Route path identifier used by callbacks |
| `icon` | `IconData?` | Optional icon used in the mobile bottom sheet list |

---

### `Header` Component Behavior

`Header` adapts its layout based on screen width using `LayoutBuilder` and the breakpoint helpers in `Breakpoints`.

#### Responsive Layout

- `showCompactHeader = !Breakpoints.isDesktop(constraints.maxWidth)`
- Compact layout (mobile/tablet):
  - Shows hamburger menu
  - Hides inline navigation items
  - Uses a bottom-sheet “drawer” for nav items (unless `onMenuTap` is provided)
  - Uses smaller icon sizing and tighter spacing
- Desktop layout:
  - Hides hamburger menu (unless `onMenuTap` is provided, e.g., admin sidebar toggle)
  - Shows inline navigation items
  - Shows `DevNavButton` (development navigation shortcut)

#### Navigation Handling

- Inline nav item tap:
  - Calls `onNavItemTap?.call(item.route)`
- Mobile bottom sheet nav item tap:
  - Closes bottom sheet
  - Calls `onNavItemTap?.call(item.route)`
- Profile menu navigation:
  - Settings: `context.push('/settings')`
  - Logout: `context.go('/logout')`

#### Localization and Locale Switching

The profile dropdown includes language selection entries derived from `SupportedLocales.all`.

- Current locale from Riverpod:
  - `ref.watch(localeProvider)`
- Selecting a language updates locale:
  - `ref.read(localeProvider.notifier).setLocale(locale)`

---

## Configuration

### Dependencies

- `flutter_riverpod`
  - `ConsumerWidget`, `WidgetRef`
  - `localeProvider` from `frontend/src/core/state/locale_provider.dart`
- `go_router`
  - Navigation via `context.go(...)` and `context.push(...)`
- Localization
  - `context.l10n` via `frontend/src/core/l10n/l10n.dart`
  - `SupportedLocales` used for language options
- Theme tokens
  - `AppTheme` (colors + logo text style)
  - `Breakpoints` for layout responsiveness
- Development-only tooling
  - `DevNavButton` is shown only on desktop (not compact)

### Preferred Size

`Header` sets:

- `preferredSize = Size.fromHeight(64)`

This should match the container height used internally (64).

---

## API Reference

## `NavItem`

### Constructor

```dart
const NavItem({
  required String label,
  required String route,
  IconData? icon,
})