# AppPopover

## Overview

`AppPopover` is a reusable, Material-style popover widget for inline, context-anchored feedback. It renders a surfaced container with elevation, rounded corners, and an arrow/caret that visually points to a nearby UI element.

The widget supports an optional leading icon, theme-aware colors and typography via `AppTheme`, responsive padding based on global breakpoints, optional border styling, and accessibility semantics configuration.

---

## Architecture / Design

### Design Goals

- Provide a consistent, theme-aligned popover component for contextual guidance.
- Use Material surface conventions (elevation, shape) for familiar affordances.
- Include an arrow/caret to indicate the popover’s anchor direction.
- Support optional iconography while keeping text content required.
- Offer accessibility support via `Semantics` with optional exclusion.

### Component Structure

`AppPopover` composes three main layers:

1. **Content Row**
   - Padded `Row` containing:
     - optional `IconTheme` wrapping `icon`
     - gap spacing
     - `Flexible` message `Text`

2. **Material Surface**
   - Wraps the padded content in a `Material` widget with:
     - `color` (background)
     - `elevation: 4`
     - `shape: RoundedRectangleBorder(borderRadius: ...)`

3. **Optional Border + Arrow Wrapper**
   - Optional outer `DecoratedBox` border (when border conditions pass)
   - `_PopoverWithArrow` wrapper that paints and positions the triangle caret

### Responsive Behavior

The widget computes responsive values using screen width:

1. Gets width from `MediaQuery`.
2. Resolves breakpoint via `breakpointForWidth(width)`.
3. Selects breakpoint typography via `AppTheme.textThemeForBreakpoint(bp)`.
4. Computes base spacing via `Breakpoints.responsivePadding(width)`.
5. Derives:
   - Padding scaling
   - Border width (min 1.0)
   - Corner radius (default from base padding)
   - Icon size based on text size
   - Icon/text gap spacing

### Theming and Style Resolution

Resolved defaults:

- Background: `AppTheme.backgroundMuted`
- Text color: `AppTheme.textPrimary`
- Border color: `AppTheme.muted`
- Text style: `(textTheme.bodySmall ?? AppTheme.captions)` with resolved text color
- Border width: `max(1.0, basePadding * 0.08)`
- Border radius: `BorderRadius.circular(basePadding * 0.5)` (unless overridden)

### Arrow Rendering

The caret is drawn using `CustomPaint` with `_TrianglePainter`:

- The arrow is a triangle path.
- Orientation is controlled by `arrowOnTop`:
  - `true` → triangle points upward, placed above the surface
  - `false` → triangle points downward, placed below the surface

Positioning:
- `_PopoverWithArrow` uses an `Align` with:

```dart
Alignment((offset ?? 0) / 100, 0)