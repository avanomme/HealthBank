# AppAccordion

## Overview

`AppAccordion` is a reusable, theme-aware expandable panel widget built with Flutter.

It provides a consistent and responsive way to show and hide sections of content throughout the application. The component integrates with the application's custom theme system (`AppTheme`) and breakpoint utilities to ensure proper typography and spacing across screen sizes.

### Key Features

- Expandable and collapsible content panel
- Smooth expand/collapse animations
- Theme-aware typography
- Optional leading icon with configurable color
- Responsive spacing based on screen width
- Expansion state change callback

---

## Architecture / Design

`AppAccordion` is implemented as a `StatefulWidget` to manage its internal expansion state.

### Component Structure

- **AppAccordion (StatefulWidget)**
  - Public configuration API
  - Delegates state management to `_AppAccordionState`

- **_AppAccordionState**
  - Stores current expansion state (`_expanded`)
  - Handles toggle logic
  - Syncs with `initiallyExpanded` when updated
  - Builds animated UI

### State Management

- Internal state: `_expanded`
- Initialized from `initiallyExpanded`
- Synced in `didUpdateWidget` when parent updates the property
- Toggled via `_toggle()` method
- Notifies parent via `onChanged` callback (if provided)

### Layout Structure

The widget renders:

1. **Header (InkWell)**
   - Optional leading icon
   - Title text (Heading 4 style)
   - Animated expand arrow icon
   - Tap interaction toggles expansion

2. **Body Section**
   - Wrapped in `AnimatedSize` for smooth height transitions
   - Clipped using `ClipRect`
   - Collapsed via `ConstrainedBox(maxHeight: 0)`
   - Expanded with natural constraints

### Theming & Responsiveness

- Typography resolved using:
  - `breakpointForWidth(width)`
  - `AppTheme.textThemeForBreakpoint(bp)`
- Falls back to:
  - `AppTheme.heading4`
  - `AppTheme.body`
- Spacing calculated using:
  - `Breakpoints.responsivePadding(width)`
- Icon color:
  - Uses `iconColor` if provided
  - Falls back to `AppTheme.primary`

---

## Configuration

`AppAccordion` relies on the application's custom theme and breakpoint system:

- `AppTheme`
  - Typography
  - Primary color
- `Breakpoints`
  - Responsive padding
  - Breakpoint resolution

No additional configuration is required within the widget itself.

---

## API Reference

### Constructor

```dart
const AppAccordion({
  Key? key,
  required String title,
  required String body,
  Widget? leadingIcon,
  Color? iconColor,
  bool initiallyExpanded = false,
  ValueChanged<bool>? onChanged,
})