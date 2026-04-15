# AppTextButton

## Overview

`AppTextButton` is a reusable, theme-aware Flutter button widget designed for inline or low-emphasis actions. Unlike filled buttons, it does not include a background color and instead relies on typography and foreground color to convey interactivity.

The widget integrates with the global `AppTheme` and breakpoint utilities to ensure consistent styling and responsive spacing across the application.

---

## Architecture / Design

### Design Goals

- Provide a standardized inline button component.
- Maintain alignment with global theme tokens.
- Support responsive padding across breakpoints.
- Allow controlled overrides for typography and color.

### Theming Integration

`AppTextButton` integrates with:

- `AppTheme`
  - `primary`
  - `body`
  - `textThemeForBreakpoint(...)`
- Breakpoint utilities:
  - `breakpointForWidth(...)`
  - `Breakpoints.responsivePadding(...)`

### Responsive Behavior

1. Retrieves screen width using `MediaQuery`.
2. Determines the active breakpoint via `breakpointForWidth(width)`.
3. Selects a breakpoint-aware text theme using `AppTheme.textThemeForBreakpoint(bp)`.
4. Computes base spacing via `Breakpoints.responsivePadding(width)`.
5. Applies proportional horizontal and vertical padding.

### Styling Resolution Strategy

Each style property follows this precedence:

1. Explicit constructor override (if provided)
2. Theme-derived value
3. Internal fallback

Examples:

- `textStyle` → provided `textStyle` or theme `bodyMedium` or `AppTheme.body`
- `textColor` → provided `textColor` or `AppTheme.primary`
- `padding` → provided `padding` or responsive padding calculation

---

## Configuration

No direct configuration is required within this widget.

Correct behavior depends on:

- A properly configured `AppTheme`
- Functional breakpoint utilities
- Usage within a valid `MaterialApp` context

---

## API Reference

### Constructor

```dart
const AppTextButton({
  Key? key,
  required String label,
  VoidCallback? onPressed,
  TextStyle? textStyle,
  Color? textColor,
  EdgeInsets? padding,
})