# AppGraphRenderer

## Overview

`AppGraphRenderer` is a reusable, theme-aware card container designed for rendering graphs, charts, or diagram placeholders within dashboards and analytics screens.

It provides a standardized card layout with a title, a configurable graph area, and optional placeholder content when no child widget is supplied. The component integrates with `AppTheme`, `Breakpoints`, and `AppText` to ensure consistent styling and responsive spacing.

---

## Architecture / Design

### Design Goals

- Provide a consistent container for data visualizations.
- Separate layout and styling concerns from chart implementations.
- Support optional graph injection via composition.
- Handle empty or loading states gracefully.
- Maintain responsive spacing across breakpoints.

### Composition Strategy

`AppGraphRenderer` composes:

- `AppText` for title and placeholder text.
- Responsive spacing via `Breakpoints.responsivePadding(...)`.
- A nested container to render either:
  - A supplied `child` widget (e.g., chart)
  - A styled placeholder panel

### Layout Structure

Outer container:
- Background color
- Border
- Rounded corners

Internal structure:
- Title
- Vertical spacing
- Graph area container

Graph area:
- Fixed height (configurable or responsive default)
- Rounded corners
- Background placeholder color
- Either injected child or centered placeholder text

### Styling Resolution Strategy

Each visual property follows this precedence:

1. Explicit constructor override (if provided)
2. Theme-derived value
3. Internal fallback

Examples:

- `backgroundColor` → provided value or `AppTheme.white`
- `borderColor` → provided value or `AppTheme.gray`
- `placeholderColor` → provided value or semi-transparent `AppTheme.placeholder`
- `padding` → provided value or responsive padding calculation
- `height` → provided value or responsive height calculation

---

## Configuration

No direct configuration is required.

Correct behavior depends on:

- Properly configured `AppTheme`
- Functional `Breakpoints` utilities
- A valid `MaterialApp` context
- Availability of `AppText`

---

## API Reference

### Constructor

```dart
const AppGraphRenderer({
  Key? key,
  required String title,
  Widget? child,
  String? placeholderText,
  double? height,
  EdgeInsets? padding,
  Color? backgroundColor,
  Color? borderColor,
  Color? placeholderColor,
})