# AppBreadcrumbs

## Overview

`AppBreadcrumbs` is a reusable, theme-aware breadcrumb trail widget for representing navigation hierarchy in a Flutter app.

It renders a list of breadcrumb items (e.g., `Home / Settings / Profile`) with support for:
- Active (current page) styling
- Optional tap handlers for non-active items
- Responsive wrapping when horizontal space is limited

The widget integrates with the app’s theme and responsive breakpoint utilities (`AppTheme`, `Breakpoints`) to ensure consistent typography, spacing, and colors.

---

## Architecture / Design

### Key Types

- **`AppBreadcrumbItem`**
  - Simple data model representing a single breadcrumb segment.
  - Supports a label, optional tap callback, and optional `isActive` override.

- **`AppBreadcrumbs` (StatelessWidget)**
  - Renders the breadcrumb trail.
  - Resolves which item is active (defaults the last item to active unless explicitly specified).
  - Uses `Wrap` to allow items to flow onto multiple lines on small screens.

- **`_BreadcrumbLabel` (private StatelessWidget)**
  - Responsible for rendering each breadcrumb label with correct styling.
  - Wraps non-active, tappable labels in an `InkWell`.

### Active Item Resolution

Active state is determined via `_resolveItems()`:

- If an item specifies `isActive`, that value is used.
- If `isActive` is `null`, the widget treats the **last** item as active.

This enables minimal setup for common breadcrumb usage while still allowing explicit control when needed.

### Layout Behavior

- Uses `Wrap` instead of `Row` so breadcrumbs can wrap onto multiple lines.
- Applies consistent spacing between items and lines using responsive padding.
- Inserts the separator text between items (not after the last item).

### Theming & Responsiveness

- Typography:
  - Derived from `AppTheme.textThemeForBreakpoint(bp)`
  - Defaults to `AppTheme.captions` if `bodySmall` is not available
- Spacing:
  - `Breakpoints.responsivePadding(width) * 0.25`
- Colors:
  - Active defaults to `AppTheme.textPrimary`
  - Inactive defaults to `AppTheme.textMuted`
  - Both can be overridden via `activeColor` and `inactiveColor`

---

## Configuration

This widget depends on the application theme and breakpoint utilities:

- `AppTheme`
  - Text styles and color tokens (e.g., `textPrimary`, `textMuted`)
- `Breakpoints`
  - `responsivePadding(width)`
  - `breakpointForWidth(width)`

No additional configuration is required beyond ensuring these utilities are available and correctly configured in the app.

---

## API Reference

## `AppBreadcrumbItem`

### Constructor

```dart
const AppBreadcrumbItem({
  required String label,
  VoidCallback? onTap,
  bool? isActive,
})