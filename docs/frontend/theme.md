<!-- Created with the assistance of Claude --> 
# AppTheme Usage

## Using Colors

```dart
import '/core/theme/theme.dart';

// Calling Theme Colours Directly
Container(
  color: AppTheme.primary,
)

// Available colors:
// Main: primary, primaryHover, secondary, secondaryHover
// Text: textPrimary, textContrast, textMuted
// Background: backgroundMuted
// Semantics: error, caution, success, info
// Other: black, white, whiteHover, gray, placeholder
```

## Using Text Theme

```dart
import '/core/theme/theme.dart';

Text('Title', style: AppTheme.heading1)
Text('Subtitle', style: AppTheme.heading2)
Text('Content', style: AppTheme.body)

// Available styles:
// logo (40px bold), heading1 (48px), heading2 (40px),
// heading3 (32px), heading4 (26px), body (18px), captions (16px)
```

## Combining Styles with Colours

```dart
Text(
  'Custom styled text',
  style: AppTheme.body.copyWith(color: AppTheme.textMuted),
)
```

## Accessing via Theme Context

```dart
// Colors from ColorScheme
Theme.of(context).colorScheme.primary
Theme.of(context).colorScheme.error

// Text styles from TextTheme
Theme.of(context).textTheme.displayLarge  // heading1
Theme.of(context).textTheme.bodyLarge     // body
```
