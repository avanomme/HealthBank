# AppIcon

## Overview

`AppIcon` is a small, theme-aware icon wrapper designed to ensure consistent icon rendering across the application. It standardizes icon sizing and color resolution while remaining flexible and lightweight.

This micro-widget integrates with:

- `IconTheme`
- `AppTheme`
- Responsive breakpoints

It automatically adapts its size based on screen width when no explicit size is provided.

---

## Architecture / Design

### Design Goals

- Provide consistent icon behavior across the app.
- Respect the active `IconTheme`.
- Support optional overrides for size and color.
- Provide responsive sizing when `size` is not specified.
- Support accessibility via semantic labeling.

### Size Resolution Strategy

The icon size is resolved using the following priority:

1. Explicit `size` parameter
2. Breakpoint-based default size
3. Current `IconTheme.size`
4. Fallback value `20`

Breakpoint-based sizing:

| Breakpoint          | Size |
|---------------------|------|
| `compact`           | 16   |
| `medium`            | 18   |
| `expanded`          | 20   |

### Color Resolution Strategy

The icon color is resolved using the following priority:

1. Explicit `color` parameter
2. Current `IconTheme.color`
3. `AppTheme.textPrimary`

---

## Configuration

### Dependencies

- `package:flutter/material.dart`
- `AppTheme`
- `breakpointForWidth`
- `Breakpoint` enum

Ensure that:

- Breakpoints are correctly configured in the theme system.
- `AppTheme` is properly initialized in the app theme tree.

No additional configuration is required.

---

## API Reference

### Constructor

```dart
const AppIcon(
  IconData icon, {
  Key? key,
  double? size,
  Color? color,
  String? semanticLabel,
  TextDirection? textDirection,
})
```

---

### Parameters

#### `icon` (IconData, required)

The icon to render.

---

#### `size` (double?, optional)

Overrides icon size.

If null, size is resolved via:

- Breakpoint-based default
- `IconTheme`
- Fallback to `20`

---

#### `color` (Color?, optional)

Overrides icon color.

If null, color is resolved via:

- `IconTheme`
- `AppTheme.textPrimary`

---

#### `semanticLabel` (String?, optional)

Accessibility label for screen readers.

Pass descriptive text when the icon conveys meaning without adjacent text.

---

#### `textDirection` (TextDirection?, optional)

Overrides text direction.

Useful when rendering directional icons that depend on layout direction.

---

## Return Type

`build(BuildContext context)` returns:

```dart
Icon
```

Wrapped with responsive size and color resolution logic.

---

## Error Handling

This widget does not throw explicit exceptions.

### Safeguards

- Always resolves a size (never null).
- Always resolves a color (never null).
- Falls back safely to theme defaults when overrides are absent.

### Considerations

- If both `IconTheme` and `AppTheme` are misconfigured, default color may not match design intent.
- For decorative-only icons, omit `semanticLabel` or wrap in `ExcludeSemantics`.

---

## Usage Examples

### Basic Usage

```dart
const AppIcon(Icons.security);
```

---

### With Custom Color

```dart
const AppIcon(
  Icons.security,
  color: AppTheme.primary,
);
```

---

### With Custom Size

```dart
const AppIcon(
  Icons.settings,
  size: 24,
);
```

---

### With Accessibility Label

```dart
const AppIcon(
  Icons.warning,
  semanticLabel: 'Warning',
);
```

---

## Related Files

- `theme.dart`
- `AppTheme`
- `breakpoints.dart`
- Other micro-widgets in the core widgets directory