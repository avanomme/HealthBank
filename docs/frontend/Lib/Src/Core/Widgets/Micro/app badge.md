# AppBadge

## Overview

`AppBadge` is a small, theme-aware pill-style label used to display short status, role, category, or tag information. It is designed as a reusable micro-widget for compact semantic labeling across the application.

Common use cases include:

- User roles (Admin, Moderator, Member)
- Account status (Active, Suspended)
- Tags and categories
- Environment flags (Dev, Staging, Production)
- Inline status indicators in tables, cards, and lists

The badge is content-hugging and only occupies as much horizontal space as its internal content.

---

## Architecture / Design

### Design Goals

- Provide consistent semantic labeling across the application.
- Integrate tightly with `AppTheme` for color and typography consistency.
- Support semantic variants (primary, success, error, etc.).
- Allow optional leading and trailing icon slots.
- Support multiple size presets without requiring manual styling.
- Remain lightweight and composable.

### Widget Structure

```
DecoratedBox
 └── Padding
      └── Row (mainAxisSize: min)
           ├── Optional leading icon
           ├── Text(label)
           └── Optional trailing icon
```

### Styling Resolution

Styling is determined by:

- `AppBadgeVariant` → background, border, and foreground colors
- `AppBadgeSize` → padding and typography scale
- `Theme.of(context).textTheme` → primary typography source
- `AppTheme` → fallback text styles and color tokens

Each variant maps to a `_BadgeColors` configuration containing:

- `background`
- `border`
- `foreground`

---

## Configuration

### Dependencies

- `package:flutter/material.dart`
- `AppTheme`

Ensure `AppTheme` is properly configured in the app theme tree.

No additional configuration is required.

---

## API Reference

### Enums

#### `AppBadgeVariant`

```dart
enum AppBadgeVariant {
  neutral,
  primary,
  secondary,
  success,
  caution,
  error,
  info,
}
```

Defines semantic color styling.

---

#### `AppBadgeSize`

```dart
enum AppBadgeSize {
  small,
  medium,
  large,
}
```

Controls padding and text sizing.

---

### Constructor

```dart
const AppBadge({
  Key? key,
  required String label,
  AppBadgeVariant variant = AppBadgeVariant.neutral,
  AppBadgeSize size = AppBadgeSize.medium,
  Widget? leading,
  Widget? trailing,
})
```

---

### Parameters

#### `label` (String, required)

Text displayed inside the badge.

---

#### `variant` (AppBadgeVariant, optional)

Semantic styling for background, border, and foreground colors.

Default:

```dart
AppBadgeVariant.neutral
```

---

#### `size` (AppBadgeSize, optional)

Controls internal padding and typography scale.

Default:

```dart
AppBadgeSize.medium
```

Size behavior:

- `small`
  - Padding: `EdgeInsets.symmetric(horizontal: 8, vertical: 4)`
  - Typography: `bodySmall`
- `medium`
  - Padding: `EdgeInsets.symmetric(horizontal: 10, vertical: 6)`
  - Typography: `bodyMedium`
- `large`
  - Padding: `EdgeInsets.symmetric(horizontal: 12, vertical: 8)`
  - Typography: `bodyLarge`

All sizes use `FontWeight.w400`.

---

#### `leading` (Widget?, optional)

Optional widget displayed before the label.

- Wrapped in `IconTheme`
- Default icon size: `16`
- Icon color matches badge foreground

---

#### `trailing` (Widget?, optional)

Optional widget displayed after the label.

- Wrapped in `IconTheme`
- Default icon size: `16`
- Icon color matches badge foreground

---

## Color Variants

Each variant maps to the following color scheme:

| Variant   | Background         | Border             | Foreground            |
|------------|-------------------|-------------------|------------------------|
| neutral    | `AppTheme.white`  | `AppTheme.white`  | `AppTheme.textPrimary` |
| primary    | `AppTheme.primary`| `AppTheme.primary`| `AppTheme.textContrast`|
| secondary  | `AppTheme.secondary`| `AppTheme.secondary`| `AppTheme.textContrast`|
| success    | `AppTheme.success`| `AppTheme.success`| `AppTheme.textContrast`|
| caution    | `AppTheme.caution`| `AppTheme.caution`| `AppTheme.textPrimary` |
| error      | `AppTheme.error`  | `AppTheme.error`  | `AppTheme.textContrast`|
| info       | `AppTheme.info`   | `AppTheme.info`   | `AppTheme.textContrast`|

All badges use a fully rounded pill shape:

```dart
BorderRadius.circular(999)
```

---

## Return Type

`build(BuildContext context)` returns:

```dart
Widget
```

Specifically a `DecoratedBox` containing padded row content.

---

## Error Handling

This widget does not throw explicit exceptions.

### Safeguards

- Always provides a fallback text style using `AppTheme` if `TextTheme` values are null.
- Ensures consistent icon color through `IconTheme`.
- Uses fixed border radius to prevent layout inconsistencies.

### Considerations

- Extremely long labels may cause overflow depending on parent constraints.
- Icons should remain visually small to preserve badge proportions.

---

## Usage Examples

### Basic Badge

```dart
const AppBadge(
  label: 'Member',
);
```

---

### Primary Badge with Icon

```dart
const AppBadge(
  label: 'Admin',
  variant: AppBadgeVariant.primary,
  leading: Icon(Icons.security),
);
```

---

### Success Badge (Small)

```dart
const AppBadge(
  label: 'Active',
  variant: AppBadgeVariant.success,
  size: AppBadgeSize.small,
);
```

---

### Badge with Trailing Icon

```dart
const AppBadge(
  label: 'Beta',
  variant: AppBadgeVariant.info,
  trailing: Icon(Icons.info_outline),
);
```

---

## Related Files

- `theme.dart`
- `AppTheme`
- Other micro-widgets within the core widgets directory
```