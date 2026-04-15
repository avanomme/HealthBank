# AppText

## Overview

`AppText` is a non-interactive, theme-aware typography micro-widget designed to enforce consistent text styling across the application.

It integrates with:

- `AppTheme`
- Breakpoint-based responsive typography
- A predefined `AppTextVariant` enum

`AppText` should be used anywhere standard text is needed (labels, headings, body copy) to ensure visual consistency and centralized typographic control.

---

## Architecture / Design

### Design Goals

- Centralize typography usage across the app.
- Automatically adapt typography to screen size via breakpoints.
- Provide lightweight style overrides without bypassing theme consistency.
- Encourage variant-based styling rather than raw `TextStyle` definitions.

---

### Breakpoint-Aware Typography Flow

At build time:

1. Screen width is read using:
   ```dart
   MediaQuery.of(context).size.width
   ```

2. The breakpoint is resolved:
   ```dart
   breakpointForWidth(width)
   ```

3. A breakpoint-specific `TextTheme` is retrieved:
   ```dart
   AppTheme.textThemeForBreakpoint(bp)
   ```

4. The selected `AppTextVariant` is mapped to a `TextStyle` from the resolved `TextTheme`.

5. Optional overrides (`color`, `fontWeight`, `fontStyle`) are applied via `copyWith`.

This ensures:

- Typography scales correctly per breakpoint.
- Overrides do not detach the text from the theme system.

---

## Configuration

### Dependencies

- `package:flutter/material.dart`
- `AppTheme`
- `breakpointForWidth(...)`
- `AppTheme.textThemeForBreakpoint(...)`

No additional setup is required beyond the global theme and breakpoint system.

---

## API Reference

### Constructor

```dart
const AppText(
  String text, {
  Key? key,
  AppTextVariant variant = AppTextVariant.bodyMedium,
  Color? color,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
  bool? softWrap,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
})
```

---

## Parameters

### `text` (String, required)

The string content to display.

---

### `variant` (AppTextVariant, optional)

Determines which typography style from the active breakpoint `TextTheme` to use.

Default:

```dart
AppTextVariant.bodyMedium
```

---

### `color` (Color?, optional)

Overrides the text color.

If null, inherits color from the resolved theme style.

---

### `fontWeight` (FontWeight?, optional)

Overrides the font weight while preserving other properties of the base style.

---

### `fontStyle` (FontStyle?, optional)

Overrides italic/normal style while preserving other properties.

---

### `textAlign` (TextAlign?, optional)

Text alignment inside its parent.

---

### `maxLines` (int?, optional)

Maximum number of visible lines.

---

### `overflow` (TextOverflow?, optional)

Specifies overflow behavior (e.g., ellipsis).

---

### `softWrap` (bool?, optional)

Whether text wraps at soft line breaks.

---

## AppTextVariant Enum

```dart
enum AppTextVariant {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineMedium,
  headlineSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
}
```

Each variant maps directly to a style from the breakpoint-resolved `TextTheme`.

### Variant Mapping

| Variant            | TextTheme Mapping       |
|--------------------|------------------------|
| displayLarge       | theme.displayLarge     |
| displayMedium      | theme.displayMedium    |
| displaySmall       | theme.displaySmall     |
| headlineMedium     | theme.headlineMedium   |
| headlineSmall      | theme.headlineSmall    |
| bodyLarge          | theme.bodyLarge        |
| bodyMedium         | theme.bodyMedium       |
| bodySmall          | theme.bodySmall        |

If a mapped style is null, fallback:

```dart
AppTheme.body
```

---

## Return Type

`build(BuildContext context)` returns:

```dart
Text
```

With:

- `style` resolved from breakpoint-aware theme
- Optional overrides applied via `copyWith`

---

## Error Handling

This widget does not throw explicit exceptions.

### Safeguards

- If a mapped `TextTheme` style is null, it falls back to `AppTheme.body`.
- Style overrides are applied safely via `copyWith`, preserving theme defaults.

---

## Usage Examples

### Default Body Text

```dart
const AppText('Hello world');
```

---

### Headline Variant

```dart
const AppText(
  'Welcome back',
  variant: AppTextVariant.headlineSmall,
);
```

---

### Custom Weight and Color

```dart
const AppText(
  'Important notice',
  variant: AppTextVariant.bodyLarge,
  fontWeight: FontWeight.w600,
  color: AppTheme.error,
);
```

---

### Truncated Text

```dart
const AppText(
  'This is a very long string that should truncate.',
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
);
```

---

## Best Practices

- Prefer selecting the correct `variant` rather than overriding font size manually.
- Use `fontWeight` and `fontStyle` for emphasis.
- Avoid embedding raw `TextStyle(fontSize: ...)` unless intentionally diverging from the system.
- Use `AppRichText` when inline formatting is required.

---

## Related Files

- `theme.dart`
- `AppTheme`
- `breakpoints.dart`
- `app_rich_text.dart`