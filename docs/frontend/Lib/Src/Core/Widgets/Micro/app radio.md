# AppRadio

## Overview

`AppRadio<T>` is a theme-aware radio input micro-widget designed for reuse across the application. It supports both controlled and uncontrolled usage patterns while integrating with `AppTheme` for consistent active-state styling.

This component wraps Flutter’s radio selection behavior using a `RadioGroup<T>` container and a `Radio<T>` child, and adds:

- Controlled and uncontrolled state handling
- Theme-aware active color defaults
- Enable/disable behavior
- Optional toggleable support
- Layout density customization

---

## Architecture / Design

### Design Goals

- Provide a reusable radio input aligned with application theme tokens.
- Support controlled and uncontrolled state patterns.
- Reduce boilerplate for common radio usage.
- Maintain compatibility with Flutter’s native radio widget behavior.

### Controlled vs Uncontrolled Behavior

`AppRadio<T>` supports two usage modes:

#### Controlled Mode

- Provide `groupValue`
- Provide `onChanged`
- Parent owns selection state

Internal state mirrors `groupValue` via `didUpdateWidget`.

#### Uncontrolled Mode

- Omit `groupValue`
- Optionally provide `initialGroupValue`
- Internal state `_groupValue` is managed via `setState`

### State Management

Internal field:

```dart
T? _groupValue;
```

Initialization:

```dart
_groupValue = widget.groupValue ?? widget.initialGroupValue;
```

Update synchronization:

- If `widget.groupValue != null` and it changes, `_groupValue` is updated to match.

Selection resolution:

- Effective group value is `widget.groupValue ?? _groupValue`.

### Enable / Disable Behavior

When `enabled == true`:

- `RadioGroup.onChanged` updates internal state (if uncontrolled) and forwards to `widget.onChanged`.

When `enabled == false`:

- `RadioGroup.onChanged` is set to a no-op function (`(_) {}`).
- The `Radio<T>` itself is still built, but selection changes should not propagate.

### Theming

Active color resolution:

1. Explicit `activeColor`
2. `AppTheme.primary`

---

## Configuration

### Dependencies

- `package:flutter/material.dart`
- `AppTheme`

This widget uses `RadioGroup<T>` and `Radio<T>`. Ensure the Flutter version / component library in use provides `RadioGroup<T>` as expected.

---

## API Reference

### Constructor

```dart
const AppRadio({
  Key? key,
  required T value,
  T? groupValue,
  T? initialGroupValue,
  ValueChanged<T?>? onChanged,
  bool toggleable = false,
  bool enabled = true,
  Color? activeColor,
  VisualDensity? visualDensity,
  MaterialTapTargetSize? materialTapTargetSize,
})
```

---

### Parameters

#### `value` (T, required)

The value represented by this specific radio option.

---

#### `groupValue` (T?, optional)

When provided, the widget operates in controlled mode.

- Parent controls selection state.
- Internal `_groupValue` mirrors this value.

---

#### `initialGroupValue` (T?, optional)

Initial group value for uncontrolled usage.

Ignored when `groupValue` is provided.

---

#### `onChanged` (ValueChanged<T?>?, optional)

Callback invoked when the group selection changes.

Receives the newly selected value (or `null` when toggleable behavior deselects).

---

#### `toggleable` (bool, optional)

Whether the radio can be toggled off (deselected).

Default:

```dart
false
```

---

#### `enabled` (bool, optional)

Whether the radio selection is interactive.

Default:

```dart
true
```

When `false`, the group change handler becomes a no-op.

---

#### `activeColor` (Color?, optional)

Overrides the active state color.

Default:

```dart
AppTheme.primary
```

---

#### `visualDensity` (VisualDensity?, optional)

Overrides layout density. Passed through to `Radio<T>`.

---

#### `materialTapTargetSize` (MaterialTapTargetSize?, optional)

Overrides tap target sizing behavior. Passed through to `Radio<T>`.

---

## Return Type

`build(BuildContext context)` returns:

```dart
Widget
```

Specifically a `RadioGroup<T>` containing a `Radio<T>`.

---

## Error Handling

This widget does not throw explicit exceptions.

### Safeguards

- Initializes internal group value from either controlled or initial uncontrolled values.
- Synchronizes internal state when switching controlled values.
- Prevents interactive changes from triggering selection updates when disabled.

### Behavioral Considerations

- If both `groupValue` and `initialGroupValue` are provided, `groupValue` takes precedence.
- In controlled mode, failure to update `groupValue` in the parent will prevent visible selection changes.
- When `enabled == false`, `onChanged` will not be called, and state updates should not occur.

---

## Usage Examples

### Controlled Radio Group

```dart
String? selectedValue = 'yes';

AppRadio<String>(
  value: 'yes',
  groupValue: selectedValue,
  onChanged: (value) {
    setState(() => selectedValue = value);
  },
);

AppRadio<String>(
  value: 'no',
  groupValue: selectedValue,
  onChanged: (value) {
    setState(() => selectedValue = value);
  },
);
```

---

### Uncontrolled Radio Group

```dart
AppRadio<String>(
  value: 'yes',
  initialGroupValue: 'yes',
  onChanged: (value) {
    debugPrint('Selected: $value');
  },
);

AppRadio<String>(
  value: 'no',
  initialGroupValue: 'yes',
  onChanged: (value) {
    debugPrint('Selected: $value');
  },
);
```

---

### Toggleable Radio

```dart
AppRadio<String>(
  value: 'option',
  groupValue: selectedValue,
  toggleable: true,
  onChanged: (value) {
    setState(() => selectedValue = value);
  },
);
```

---

### Disabled Radio

```dart
AppRadio<String>(
  value: 'yes',
  groupValue: 'yes',
  enabled: false,
  onChanged: (_) {},
);
```

---

## Related Files

- `theme.dart`
- `AppTheme`
- Other form input micro-widgets (checkboxes, switches, selects)