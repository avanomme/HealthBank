# AppCardTask

## Overview

`AppCardTask` is a reusable, theme-aware task card widget designed to display actionable task items. It presents a task title, due information, optional repeat information, and a single primary action button.

The widget adapts responsively to screen size, stacking content vertically on compact screens and arranging content horizontally on larger layouts. It integrates with `AppTheme`, `Breakpoints`, `AppText`, and `AppFilledButton` to maintain consistent styling across the application.

---

## Architecture / Design

### Design Goals

- Provide a standardized task display component.
- Ensure consistent theme usage via `AppTheme`.
- Support responsive layouts across breakpoints.
- Maintain clear separation between content and action.
- Reuse existing atomic components (`AppText`, `AppFilledButton`).

### Composition Strategy

`AppCardTask` composes:

- `AppText` for all textual content.
- `AppFilledButton` for the action.
- `Breakpoints` utilities for responsive behavior.
- `LayoutBuilder` to determine compact vs. expanded layout.

### Responsive Behavior

Layout is determined by:

```dart
Breakpoints.isMobile(constraints.maxWidth)