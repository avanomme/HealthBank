# AppDivider

## Overview

`AppDivider` is a theme-aware visual separator designed as a reusable micro-widget. It provides a consistent horizontal divider line with configurable thickness, spacing, color, and horizontal insets.

The divider adapts its vertical spacing responsively when explicit spacing is not provided, ensuring consistent layout rhythm across breakpoints.

---

## Architecture / Design

### Design Goals

- Provide a reusable, consistent divider component.
- Integrate with `AppTheme` for color defaults.
- Support configurable thickness and spacing.
- Provide responsive default spacing based on breakpoints.
- Allow horizontal indentation control.

### Layout Structure

```
SizedBox (height = resolvedSpacing)
 └── Center
      └── Padding (left/right indent)
           └── Container (height = resolvedThickness, color)
```

### Spacing Logic

Spacing is resolved as:

```dart
max(resolvedThickness, spacing ?? _spacingForBreakpoint(bp))
```

This ensures:

- The total reserved vertical space is never smaller than the line thickness.
- If `spacing` is not provided, spacing adapts based on breakpoint.

### Breakpoint-Based Spacing

If `spacing` is null, vertical spacing defaults to:

- `Breakpoint.compact` → `12`
- `Breakpoint.medium` → `16`
- `Breakpoint.expanded` → `20`

---

## Configuration

### Dependencies

- `package:flutter/material.dart`
- `AppTheme`
- `breakpointForWidth`
- `Breakpoint` enum

Ensure breakpoints and theme are configured correctly in the application.

---

## API Reference

### Constructor

```dart
const AppDivider({
  Key? key,
  double? thickness,
  double? spacing,
  Color? color,
  double indent = 0,
  double endIndent = 0,
})
```

---

### Parameters

#### `thickness` (double?, optional)

Height of the divider line.

Default:

```dart
1
```

---

#### `spacing` (double?, optional)

Total vertical space reserved for the divider.

If null, spacing is determined by breakpoint.

Spacing is always at least as large as `thickness`.

---

#### `color` (Color?, optional)

Overrides divider color.

Default:

```dart
AppTheme.gray
```

---

#### `indent` (double, optional)

Left horizontal inset.

Default:

```dart
0
```

---

#### `endIndent` (double, optional)

Right horizontal inset.

Default:

```dart
0
```

---

## Return Type

`build(BuildContext context)` returns:

```dart
SizedBox
```

Containing a centered horizontal divider line.

---

## Error Handling

This widget does not throw explicit exceptions.

### Safeguards

- Ensures spacing is never smaller than thickness.
- Uses responsive fallback spacing when `spacing` is not provided.
- Defaults to theme divider color when no override is specified.

### Considerations

- Extremely large `spacing` values may create unintended layout gaps.
- If used inside constrained vertical layouts, ensure sufficient height is available.

---

## Usage Examples

### Basic Divider

```dart
const AppDivider();
```

---

### Custom Thickness and Spacing

```dart
const AppDivider(
  thickness: 1,
  spacing: 20,
);
```

---

### Indented Divider

```dart
const AppDivider(
  indent: 16,
  endIndent: 16,
);
```

---

### Custom Color

```dart
AppDivider(
  color: AppTheme.primary,
  thickness: 2,
);
```

---

## Related Files

- `theme.dart`
- `AppTheme`
- `breakpoints.dart`
```