# AppDropdownMenu

## Overview

`AppDropdownMenu<T>` is a reusable, theme-aware dropdown menu widget for selecting a value from a list of options in a Flutter app.

It wraps Flutter’s `DropdownButtonFormField` and integrates with the app’s custom theme (`AppTheme`) and breakpoint utilities to ensure consistent typography, colors, and responsive sizing. Each option can be enabled or disabled, and the currently selected option is styled distinctly.

---

## Architecture / Design

### Key Types

- **`AppDropdownOption<T>`**
  - Lightweight data model representing a selectable option.
  - Stores a user-facing `label`, a typed `value`, and an `enabled` flag.

- **`AppDropdownMenu<T>` (StatelessWidget)**
  - Renders a `DropdownButtonFormField<T>` with:
    - Responsive padding and border radius derived from breakpoints
    - Theme-aware text styles and colors
    - Disabled styling for individual options
    - Selected option emphasis (font weight)

### Theming & Responsiveness

- Breakpoint and responsive padding:
  - `breakpointForWidth(width)`
  - `Breakpoints.responsivePadding(width)`
- Typography:
  - `AppTheme.textThemeForBreakpoint(bp)` with fallback to `AppTheme.body`
- Colors:
  - Dropdown icon colors:
    - Enabled: `AppTheme.primary`
    - Disabled: `AppTheme.muted`
  - Text colors:
    - Normal: `AppTheme.textPrimary`
    - Muted/disabled: `AppTheme.textMuted`
- Input borders:
  - Uses `Theme.of(context).colorScheme.primary` for enabled/focused borders
  - Uses `AppTheme.muted` for disabled border
- Sizing:
  - `contentPadding` and `borderRadius` scale with responsive padding

### Selection Styling

Inside the menu items:
- Disabled options render in muted text color.
- The option whose `value == initialValue` is rendered with `FontWeight.w600` (selected emphasis).

---

## Configuration

This widget depends on application-level theme and breakpoint utilities:

- `AppTheme`
  - Typography and color tokens (e.g., `primary`, `muted`, `textPrimary`, `textMuted`)
- `Breakpoints`
  - Responsive padding and breakpoint resolution
- Flutter `ThemeData`
  - Uses `Theme.of(context).colorScheme.primary` for enabled/focused border color

No additional configuration is required beyond ensuring these are available in the app.

---

## API Reference

## `AppDropdownOption<T>`

### Constructor

```dart
const AppDropdownOption({
  required String label,
  required T value,
  bool enabled = true,
})