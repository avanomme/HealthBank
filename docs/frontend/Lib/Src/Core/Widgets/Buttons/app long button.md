# AppLongButton

## Overview

`AppLongButton` is a reusable full-width button widget designed for prominent actions within the application. It expands to fill the available horizontal space of its parent while maintaining consistent styling by composing `AppFilledButton`.

This widget is ideal for primary call-to-action elements such as form submissions, onboarding steps, and confirmations.

---

## Architecture / Design

### Design Goals

- Provide a full-width button variant without duplicating styling logic.
- Maintain strict visual consistency with `AppFilledButton`.
- Avoid hard-coded sizing.
- Preserve flexibility through optional styling overrides.

### Composition Strategy

`AppLongButton` follows a composition-based design:

- Wraps `AppFilledButton` inside a `SizedBox`.
- Uses `width: double.infinity` to expand horizontally.
- Delegates all visual styling and behavior to `AppFilledButton`.

This ensures:

- Centralized styling control.
- Reduced duplication.
- Predictable behavior across the application.

### Layout Behavior

The widget expands to match the maximum width allowed by its parent container. It does not enforce margins, spacing, or height constraints.

Layout responsibility remains with the parent widget.

---

## Configuration

No direct configuration is required.

Correct behavior depends on:

- Proper implementation of `AppFilledButton`.
- A valid `MaterialApp` context.
- Parent layout constraints that allow horizontal expansion.

---

## API Reference

### Constructor

```dart
const AppLongButton({
  Key? key,
  required String label,
  VoidCallback? onPressed,
  Color? backgroundColor,
  Color? textColor,
  EdgeInsets? padding,
  TextStyle? textStyle,
})