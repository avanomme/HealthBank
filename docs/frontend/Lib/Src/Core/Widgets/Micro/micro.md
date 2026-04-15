# Micro Widgets Barrel File

## Overview

This barrel file consolidates all reusable **micro-widgets** into a single import entry point.

Micro-widgets are small, theme-aware UI primitives designed to:

- Enforce consistent styling across the app
- Reduce duplication
- Centralize typography, iconography, and control behavior
- Integrate with `AppTheme` and breakpoint-aware layout

By importing this barrel file, consumers gain access to all core micro components.

---

## File Location

```
frontend/lib/src/core/widgets/micro/micro.dart
```

---

## Source

```dart
/// Barrel file for micro widgets (Icon, Badge, Checkbox, etc.)

library;

export 'app_icon.dart';
export 'app_badge.dart';
export 'app_checkbox.dart';
export 'app_radio.dart';
export 'app_text.dart';
export 'app_rich_text.dart';
export 'app_status_dot.dart';
export 'app_divider.dart';
export 'app_text_box.dart';
```

---

## Exported Widgets

### Typography

- `AppText`
- `AppRichText`

### Indicators & Status

- `AppBadge`
- `AppStatusDot`

### Inputs

- `AppCheckbox`
- `AppRadio`

### Visual Elements

- `AppIcon`
- `AppDivider`

### Inputs / Forms

- `AppTextBox`

---

## Usage

Instead of importing each widget individually:

```dart
import 'package:frontend/src/core/widgets/micro/app_text.dart';
import 'package:frontend/src/core/widgets/micro/app_icon.dart';
```

You can import everything at once:

```dart
import 'package:frontend/src/core/widgets/micro/micro.dart';
```

This simplifies dependency management and improves readability across feature modules.

---

## Design Rationale

Using a barrel file:

- Promotes a clean public surface for UI primitives
- Prevents deep import paths throughout the codebase
- Makes it easy to refactor internal widget organization without breaking consumers
- Encourages consistent usage of standardized UI components

---

## Related Files

- `theme.dart`
- `breakpoints.dart`
- `data_display.dart`
- `feedback.dart`
- `layout.dart`