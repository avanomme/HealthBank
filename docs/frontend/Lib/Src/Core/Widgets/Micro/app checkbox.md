# AppCheckbox

## Overview

`AppCheckbox` is a theme-aware checkbox micro-widget designed for reuse across the application. It supports both controlled and uncontrolled usage patterns while integrating with `AppTheme` for consistent styling.

This component wraps Flutter’s `Checkbox` and adds:

- Controlled and uncontrolled state handling
- Theme-aware color defaults
- Optional tristate support
- Enable/disable control
- Layout density customization

---

## Architecture / Design

### Design Goals

- Provide a reusable checkbox component aligned with application theme tokens.
- Support both controlled and uncontrolled usage.
- Minimize boilerplate when managing checkbox state.
- Maintain compatibility with Flutter’s native `Checkbox` API.

### Controlled vs Uncontrolled Behavior

`AppCheckbox` supports two usage modes:

#### Controlled Mode

- Provide `value`
- Provide `onChanged`
- Parent widget owns state

Internal state mirrors `value` via `didUpdateWidget`.

#### Uncontrolled Mode

- Omit `value`
- Optionally provide `initialValue`
- Internal state `_value` is managed via `setState`

### State Management

Internally:

```dart
bool? _value;
```

Initialization:

```dart
_value = widget.value ?? widget.initialValue;
```

When controlled:

- Internal state updates only when `widget.value` changes.

When uncontrolled:

- Internal state updates via `setState` inside `onChanged`.

---

## Configuration

### Dependencies

- `package:flutter/material.dart`
- `AppTheme`

Ensure `AppTheme` is configured in the application theme tree.

---

## API Reference

### Constructor

```dart
const AppCheckbox({
  Key? key,
  bool? value,
  bool initialValue = false,
  ValueChanged<bool?>? onChanged,
  bool tristate = false,
  bool enabled = true,
  Color? activeColor,
  Color? checkColor,
  VisualDensity? visualDensity,
  MaterialTapTargetSize? materialTapTargetSize,
})
```

---

### Parameters

#### `value` (bool?, optional)

When provided, the widget operates in controlled mode.

- Parent controls state.
- Internal state mirrors this value.

---

#### `initialValue` (bool, optional)

Initial value for uncontrolled usage.

Default:

```dart
false
```

Ignored when `value` is provided.

---

#### `onChanged` (ValueChanged<bool?>?, optional)

Callback triggered when the checkbox value changes.

Receives:

```dart
bool?
```

Even in non-tristate mode, the callback type supports nullable values.

---

#### `tristate` (bool, optional)

Whether the checkbox supports `null` as a third state.

Default:

```dart
false
```

When `true`, valid states are:

- `true`
- `false`
- `null`

---

#### `enabled` (bool, optional)

Whether the checkbox is interactive.

Default:

```dart
true
```

When `false`, `onChanged` is set to `null` and the checkbox becomes disabled.

---

#### `activeColor` (Color?, optional)

Overrides the active fill color when checked.

Default:

```dart
AppTheme.primary
```

---

#### `checkColor` (Color?, optional)

Overrides the checkmark color.

Default:

```dart
AppTheme.textContrast
```

---

#### `visualDensity` (VisualDensity?, optional)

Overrides layout density.

Passed directly to Flutter’s `Checkbox`.

---

#### `materialTapTargetSize` (MaterialTapTargetSize?, optional)

Overrides tap target sizing behavior.

Passed directly to Flutter’s `Checkbox`.

---

## Return Type

`build(BuildContext context)` returns:

```dart
Checkbox
```

Wrapped with state handling logic.

---

## Error Handling

This widget does not throw explicit exceptions.

### Safeguards

- Defaults to `false` if both `value` and `_value` are null.
- Properly synchronizes controlled values in `didUpdateWidget`.
- Disables interaction when `enabled == false`.

### Behavioral Considerations

- If both `value` and `initialValue` are provided, `value` takes precedence.
- In controlled mode, failure to update `value` in the parent will prevent visible state changes.
- When `tristate == true`, ensure parent logic properly handles `null`.

---

## Usage Examples

### Controlled Checkbox

```dart
bool isChecked = true;

AppCheckbox(
  value: isChecked,
  onChanged: (value) {
    setState(() {
      isChecked = value ?? false;
    });
  },
);
```

---

### Uncontrolled Checkbox

```dart
AppCheckbox(
  initialValue: true,
  onChanged: (value) {
    debugPrint('New value: $value');
  },
);
```

---

### Disabled Checkbox

```dart
const AppCheckbox(
  value: true,
  enabled: false,
);
```

---

### Tristate Checkbox

```dart
AppCheckbox(
  tristate: true,
  initialValue: null,
  onChanged: (value) {
    debugPrint('Tristate value: $value');
  },
);
```

---

## Related Files

- `theme.dart`
- `AppTheme`
- Other form input micro-widgets
```