# AppFilledButton

## Overview

`AppFilledButton` is a reusable, theme-aware Flutter button widget designed for primary actions within the application. It provides a filled background style, integrates with the application's custom theme system, and adapts its padding and typography responsively based on screen width breakpoints.

This widget wraps Flutter’s `ElevatedButton` and standardizes styling across the project while still allowing controlled overrides for colors, padding, and text style.

---

## Architecture / Design

### Design Goals

- Centralize primary button styling.
- Enforce consistency with `AppTheme`.
- Support responsive layout via global breakpoints.
- Allow targeted visual overrides without breaking theme cohesion.

### Theming Integration

`AppFilledButton` integrates with:

- `AppTheme`
  - `primary`
  - `muted`
  - `textContrast`
  - `body`
  - `textThemeForBreakpoint(...)`
- Breakpoint utilities:
  - `breakpointForWidth(...)`
  - `Breakpoints.responsivePadding(...)`

### Responsive Behavior

1. Retrieves screen width using `MediaQuery`.
2. Resolves breakpoint via `breakpointForWidth(width)`.
3. Selects breakpoint-specific text theme using `AppTheme.textThemeForBreakpoint(bp)`.
4. Computes base padding using `Breakpoints.responsivePadding(width)`.
5. Scales horizontal and vertical padding proportionally.

### Styling Resolution Strategy

Each visual property follows this precedence order:

1. Explicit constructor override (if provided)
2. Theme-derived value
3. Internal fallback

Examples:

- `textStyle` → provided `textStyle` or theme `bodyMedium` or `AppTheme.body`
- `backgroundColor` → provided `backgroundColor` or `AppTheme.primary`
- `padding` → provided `padding` or responsive padding calculation

---

## Configuration

No direct configuration is required within this widget.

Proper behavior depends on:

- A correctly configured `AppTheme`
- Functional breakpoint utilities
- Material theme support via `MaterialApp`

Ensure `AppTheme` and breakpoint helpers are initialized and accessible within the application.

---

## API Reference

### Constructor

```dart
const AppFilledButton({
  Key? key,
  required String label,
  VoidCallback? onPressed,
  Color? backgroundColor,
  Color? textColor,
  EdgeInsets? padding,
  TextStyle? textStyle,
})