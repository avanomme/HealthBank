# AppStatusDot

## Overview

`AppStatusDot` is a theme-aware notification indicator micro-widget that overlays either:

- a small dot (boolean notification state), or
- a compact count badge (when `notificationCount > 0`)

on top of a provided base icon widget.

This component is designed to be reused anywhere an icon needs a lightweight notification affordance (e.g., mail, alerts, messages, tasks).

---

## Architecture / Design

### Design Goals

- Provide a reusable notification indicator overlay for icons.
- Support two display modes:
  - dot indicator (presence)
  - badge indicator (count)
- Integrate with breakpoints for responsive sizing.
- Maintain visual separation from the underlying icon using a border that matches the scaffold background.

### Rendering Logic

At build time, the widget computes:

- Breakpoint from screen width (`breakpointForWidth(width)`)
- Indicator size (breakpoint-based by default)
- Indicator color (theme default or override)
- Whether to show:
  - `hasNotification == true`, or
  - `(notificationCount ?? 0) > 0`

If neither is true, the widget returns the base `icon` directly (no extra layout or stack).

### Overlay Layout

When active, the widget uses:

- `Stack` with `clipBehavior: Clip.none`
- The indicator is placed via `Positioned` in the top-right corner with a negative offset so it visually sits outside the icon bounds.

Structure:

```
Stack
 ├── icon
 └── Positioned (top/right negative offset)
      ├── _NotificationDot   (if no count)
      └── _NotificationBadge (if count > 0)
```

### Border Strategy

To keep the indicator readable on varied icon shapes/backgrounds, a border is drawn around the dot/badge:

- Border color: `Theme.of(context).scaffoldBackgroundColor`
- Border width: `max(1.0, resolvedSize * 0.2)`

This creates a subtle “cutout” effect where the indicator meets the surrounding UI.

### Dot vs Badge

#### Dot Mode

- Used when:
  - `hasNotification == true` and `notificationCount` is null/0
- Rendered as a circle `DecoratedBox`.

#### Badge Mode

- Used when:
  - `notificationCount > 0` (takes precedence)
- Displays count text:
  - `99+` when `count > 99`
  - otherwise the count as a string
- Badge uses a pill `BorderRadius.circular(999)` with internal padding.

---

## Configuration

### Dependencies

- `package:flutter/material.dart`
- `AppTheme`
- `breakpointForWidth(...)`
- `Breakpoint` enum

No additional configuration is required beyond the project’s theme/breakpoint setup.

---

## API Reference

### Constructor

```dart
const AppStatusDot({
  Key? key,
  required Widget icon,
  bool hasNotification = false,
  Color? indicatorColor,
  double? indicatorSize,
  int? notificationCount,
})
```

### Parameters

#### `icon` (Widget, required)

The base icon widget the indicator will overlay.

This can be any widget (e.g., `Icon`, `AppIcon`, SVG widget), but is typically an icon-sized widget.

---

#### `hasNotification` (bool, optional)

Whether to show the indicator dot.

Default:

```dart
false
```

If `notificationCount > 0`, the badge is shown regardless of `hasNotification`.

---

#### `indicatorColor` (Color?, optional)

Overrides the indicator color (dot/badge fill).

Default:

```dart
AppTheme.caution
```

---

#### `indicatorSize` (double?, optional)

Overrides the indicator size. Also influences border width and positioning offsets.

If null, size is determined by breakpoint.

Default sizes:

- `Breakpoint.compact` → `8`
- `Breakpoint.medium` → `10`
- `Breakpoint.expanded` → `12`

---

#### `notificationCount` (int?, optional)

Optional notification count.

When `(notificationCount ?? 0) > 0`, a badge is rendered instead of a dot.

Badge display rules:

- `count > 99` → `"99+"`
- else → `"$count"`

---

## Return Type

`build(BuildContext context)` returns:

- `icon` directly when nothing should be shown, or
- a `Stack` containing `icon` and an overlay indicator.

---

## Error Handling

This widget does not throw explicit exceptions.

### Safeguards

- Avoids unnecessary `Stack` layout when no indicator should be shown.
- Clamps border width to at least `1.0`.
- Badge text clamps display to `"99+"` for large counts.
- Badge font size is clamped to at least `9` using:

```dart
max(9, size * 0.7)
```

### Considerations

- The indicator is positioned with negative offsets; if used inside tightly clipped parents, it may be clipped. Ensure surrounding layout allows overflow (or wrap with padding).
- Badge sizing assumes icon-level scale; extremely small icons may require explicit `indicatorSize`.

---

## Usage Examples

### Dot Indicator (Boolean)

```dart
AppStatusDot(
  icon: const AppIcon(Icons.mail),
  hasNotification: true,
);
```

### Count Badge

```dart
AppStatusDot(
  icon: const AppIcon(Icons.notifications),
  notificationCount: 3,
);
```

### Custom Indicator Color and Size

```dart
AppStatusDot(
  icon: const Icon(Icons.chat_bubble_outline),
  hasNotification: true,
  indicatorColor: AppTheme.error,
  indicatorSize: 12,
);
```

### No Indicator

```dart
AppStatusDot(
  icon: const AppIcon(Icons.mail),
  hasNotification: false,
  notificationCount: 0,
);
```

---

## Related Files

- `theme.dart`
- `AppTheme`
- `breakpoints.dart`
- `app_icon.dart` (commonly used as the `icon` input)