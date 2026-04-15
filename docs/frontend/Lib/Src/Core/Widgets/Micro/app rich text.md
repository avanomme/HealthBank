# AppRichText

## Overview

`AppRichText` is a theme-aware rich text micro-widget for inline formatting such as bold, italics, and link-like spans. It builds on Flutter’s `RichText`/`TextSpan` model while integrating with the app’s breakpoint-aware typography system.

Key behaviors:

- Uses a base style derived from `AppTheme.textThemeForBreakpoint(...)` and a selected `AppTextVariant`.
- Scales child `TextSpan` font sizes to remain consistent across breakpoints.
- Supports common text layout options (`textAlign`, `maxLines`, `overflow`, `softWrap`).
- Respects system text scaling via `MediaQuery.textScalerOf(context)`.

---

## Architecture / Design

### Design Goals

- Provide a consistent, breakpoint-aware rich text component.
- Use `AppTheme` typography as the base style.
- Avoid span styles becoming mismatched when breakpoints change.
- Encourage span styling that modifies weight/decoration rather than locking fixed sizes, unless explicitly desired.

### Typography and Breakpoint Flow

1. Measure screen width via `MediaQuery.of(context).size.width`.
2. Resolve breakpoint using `breakpointForWidth(width)`.
3. Retrieve breakpoint-specific `TextTheme` using `AppTheme.textThemeForBreakpoint(bp)`.
4. Choose a base style based on `variant` (see Variant Mapping below).
5. Compute a scaling factor to adjust child span font sizes.

### Child Span Scaling

Scaling exists to keep child spans that specify explicit `fontSize` aligned with the active breakpoint typography.

- `baseStyle`: typography style for the selected `variant`.
- `referenceStyle`: `textTheme.bodyMedium` (fallback `AppTheme.body`) used as a stable baseline.
- Scale factor:

```dart
scale = baseStyle.fontSize / referenceStyle.fontSize
```

The widget then recursively traverses the provided `TextSpan` tree and scales any child `TextStyle.fontSize` values:

- If a span’s `style.fontSize` is non-null, it becomes `fontSize * scale`.
- If `fontSize` is null, it is left unchanged (preferred pattern).

### Style Merging

After scaling, the widget merges styles to ensure:

- Base theme typography is always applied.
- Any user-provided span styles override as expected.

The merge is:

```dart
mergedStyle = baseStyle.merge(scaledText.style)
```

### Span Metadata Preservation

When reconstructing spans for scaling, the widget preserves important metadata:

- `recognizer` (for tappable links)
- `mouseCursor`
- hover callbacks (`onEnter`, `onExit`)
- semantics (`semanticsLabel`)
- `locale`
- `spellOut`

This ensures interactive spans remain functional.

---

## Configuration

### Dependencies

- `package:flutter/material.dart`
- `AppTheme` (including `textThemeForBreakpoint`)
- `breakpointForWidth(...)`
- `AppTextVariant` (from `app_text.dart`)

No additional configuration is required beyond the project’s theme/breakpoint setup.

---

## API Reference

### Constructor

```dart
const AppRichText({
  Key? key,
  required TextSpan text,
  AppTextVariant variant = AppTextVariant.bodyMedium,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
  bool? softWrap,
})
```

---

### Parameters

#### `text` (TextSpan, required)

The rich text content.

- Can contain nested `TextSpan` children.
- Link behavior can be implemented via `recognizer`.

---

#### `variant` (AppTextVariant, optional)

Selects the base typography variant from the active breakpoint `TextTheme`.

Default:

```dart
AppTextVariant.bodyMedium
```

Variant mapping is performed by `_styleForVariant(TextTheme)`.

---

#### `textAlign` (TextAlign?, optional)

Text alignment for the `RichText`.

Default:

```dart
TextAlign.start
```

---

#### `maxLines` (int?, optional)

Maximum number of lines to display.

- If null, text can expand vertically as needed.

---

#### `overflow` (TextOverflow?, optional)

How visual overflow is handled.

Default:

```dart
TextOverflow.clip
```

---

#### `softWrap` (bool?, optional)

Whether the text should break at soft line breaks.

Default:

```dart
true
```

---

## Variant Mapping

`variant` is mapped to a `TextStyle?` from the breakpoint `TextTheme`:

- `displayLarge` → `theme.displayLarge`
- `displayMedium` → `theme.displayMedium`
- `displaySmall` → `theme.displaySmall`
- `headlineMedium` → `theme.headlineMedium`
- `headlineSmall` → `theme.headlineSmall`
- `bodyLarge` → `theme.bodyLarge`
- `bodyMedium` → `theme.bodyMedium`
- `bodySmall` → `theme.bodySmall`

If the selected style is null, the widget falls back to:

```dart
AppTheme.body
```

---

## Return Type

`build(BuildContext context)` returns:

```dart
RichText
```

With:

- `text` set to the reconstructed, scaled `TextSpan`
- `textScaler` set to `MediaQuery.textScalerOf(context)`

---

## Error Handling

This widget does not throw explicit exceptions.

### Safeguards

- Uses `AppTheme.body` as a fallback when theme styles are missing.
- Scale factor calculation guards against invalid reference sizes:
  - If the reference font size is `<= 0`, scale defaults to `1`.

### Behavioral Considerations

- Only spans with explicit `style.fontSize` are scaled. Spans that rely on inherited font size (recommended) will automatically track the base style without scaling.
- Because span scaling reconstructs only `TextSpan` children (using `whereType<TextSpan>()`), non-`TextSpan` inline spans (such as `WidgetSpan`) are not preserved by the scaling logic. If `WidgetSpan` support is required, the scaling traversal would need to be extended.

---

## Usage Examples

### Simple Emphasis

```dart
AppRichText(
  text: const TextSpan(
    text: 'By continuing, you agree to the ',
    children: [
      TextSpan(
        text: 'Terms of Service',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      TextSpan(text: '.'),
    ],
  ),
);
```

### Link-Like Span (Recognizer)

```dart
final recognizer = TapGestureRecognizer()..onTap = () {
  // Handle navigation
};

AppRichText(
  text: TextSpan(
    text: 'Read our ',
    children: [
      TextSpan(
        text: 'Privacy Policy',
        style: const TextStyle(decoration: TextDecoration.underline),
        recognizer: recognizer,
      ),
    ],
  ),
);
```

### Different Base Variant

```dart
AppRichText(
  variant: AppTextVariant.bodySmall,
  text: const TextSpan(
    text: 'Small helper text with ',
    children: [
      TextSpan(text: 'emphasis', style: TextStyle(fontWeight: FontWeight.w600)),
      TextSpan(text: '.'),
    ],
  ),
);
```

---

## Related Files

- `theme.dart`
- `AppTheme`
- `breakpoints.dart`
- `app_text.dart` (defines `AppTextVariant`)