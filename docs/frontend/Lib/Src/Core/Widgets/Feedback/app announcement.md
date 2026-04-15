# AppAnnouncement

## Overview

`AppAnnouncement` is a reusable inline banner widget for displaying important announcements or feedback messages. It supports an optional leading icon, theme-aware colors and typography via `AppTheme`, responsive padding via global breakpoints, and can optionally be made clickable with an `onTap` handler.

This widget is intended for in-page alerts such as maintenance notices, informational prompts, and lightweight callouts.

---

## Architecture / Design

### Design Goals

- Provide a consistent, theme-aligned announcement/banner component.
- Support optional iconography to improve message scanning.
- Allow optional click/tap behavior without requiring a separate wrapper.
- Ensure responsive spacing and sizing across device widths.

### Responsive Behavior

`AppAnnouncement` computes responsive layout values based on screen width:

1. Reads the current width with `MediaQuery`.
2. Resolves a breakpoint via `breakpointForWidth(width)`.
3. Selects breakpoint-specific typography using `AppTheme.textThemeForBreakpoint(bp)`.
4. Computes base padding from `Breakpoints.responsivePadding(width)`.
5. Derives:
   - Padding (horizontal/vertical scaling)
   - Border width (min 1.0)
   - Corner radius
   - Icon size (based on resolved text size)
   - Icon/text gap

### Styling Resolution Strategy

Each visual property follows this precedence:

1. Explicit constructor override (if provided)
2. Theme-derived value
3. Internal fallback

Resolved defaults:

- Background: `AppTheme.info`
- Text color: `AppTheme.textContrast`
- Text style: `(textTheme.bodyMedium ?? AppTheme.body)` with `FontWeight.w600`
- Border: only rendered when `borderColor` is provided

### Clickable vs Non-Clickable Rendering

- If `onTap == null`:
  - Renders a `DecoratedBox` containing the padded row content.
- If `onTap != null`:
  - Wraps the banner in a transparent `Material` and `InkWell` to provide tap handling and ripple feedback.
  - Uses the computed border radius for consistent ink clipping.

### Layout Structure

The banner content is a `Row` containing:

- Optional `IconTheme` wrapper for the leading icon
- Spacing gap (only when icon present)
- `Flexible` text for message content

This keeps the banner compact while allowing the message to wrap as needed.

---

## Configuration

No direct configuration is required.

Correct behavior depends on:

- A properly configured `AppTheme`
- Functional breakpoint utilities (`breakpointForWidth`, `Breakpoints.responsivePadding`)
- Usage within a `MaterialApp` context (especially when `onTap` is used, since `InkWell` requires `Material`)

---

## API Reference

### Constructor

```dart
const AppAnnouncement({
  Key? key,
  required String message,
  Widget? icon,
  VoidCallback? onTap,
  Color? backgroundColor,
  Color? textColor,
  Color? borderColor,
  EdgeInsets? padding,
})