# AppToast

## Overview

`AppToast` is a reusable, theme-aware toast notification component for transient messaging. It renders as an overlay entry and supports semantic variants via named constructors and convenience `show*` static methods.

The toast supports:

- Variant styling (success, info, caution, error, custom)
- Optional leading icon
- Optional close button for early dismissal
- Responsive positioning (top-center on mobile, bottom-right on larger screens)
- Slide-in/out animation with timed auto-dismiss

---

## Architecture / Design

### Design Goals

- Provide a standardized toast system for transient feedback.
- Use semantic variants to ensure consistent styling and iconography.
- Ensure responsive placement and sizing across breakpoints.
- Support both auto-dismiss and user-initiated dismissal.
- Keep usage ergonomic via `AppToast.showSuccess(...)` style helpers.

### Key Components

This implementation is composed of three main layers:

1. **`AppToast` (public widget)**
   - Exposes named constructors for variants:
     - `AppToast.success`, `AppToast.info`, `AppToast.caution`, `AppToast.error`, `AppToast.custom`
   - Renders the underlying `_ToastCard`.

2. **`_ToastOverlay` (overlay entry manager)**
   - Inserts an `OverlayEntry` into `Overlay.of(context)` and removes it when dismissed.
   - Delegates presentation timing/animation to `_ToastPresenter`.

3. **`_ToastPresenter` (animated presenter + auto-dismiss)**
   - Stateful, uses an `AnimationController` and `SlideTransition` to animate the toast in and out.
   - Schedules a `Timer` to auto-dismiss after `duration`.
   - Chooses slide direction based on breakpoint:
     - Mobile: slides in from top (`Offset(0, -1)`)
     - Non-mobile: slides in from right (`Offset(1, 0)`)

4. **`_ToastCard` (visual UI)**
   - Implements the toast container UI:
     - background, optional border, rounded corners
     - optional icon
     - message text
     - optional close button

### Responsive Behavior

Responsive decisions are based on screen width:

- Presenter placement:
  - Mobile (`Breakpoints.isMobile(width)`): `Alignment.topCenter`
  - Non-mobile: `Alignment.bottomRight`

- Presenter padding uses:
  - `Breakpoints.responsiveHorizontalMargin(width)`
  - `Breakpoints.responsivePadding(width)`

- Card max width:
  - Mobile: `double.infinity`
  - Non-mobile: `Breakpoints.maxContent`

### Dismissal Model

Dismissal can occur via:

- Auto-dismiss timer (`Timer(widget.duration, _dismiss)`)
- Close button (calls `onClose`, wired to presenter `_dismiss`)
- Programmatic dismissal by calling the provided `close` callback

The presenter ensures idempotency via `_isDismissing` to prevent double dismiss attempts.

---

## Configuration

### Required Dependencies

- Flutter `material`
- `AppTheme`
- Breakpoint utilities:
  - `breakpointForWidth(...)`
  - `Breakpoints.isMobile(...)`
  - `Breakpoints.responsivePadding(...)`
  - `Breakpoints.responsiveHorizontalMargin(...)`
  - `Breakpoints.maxContent`

### Usage Requirements

- `Overlay.of(context)` must be available. Typically this means usage under a `MaterialApp` / `Navigator` that provides an overlay.
- Prefer calling the `show*` helpers from a context that is mounted and has access to an overlay.

---

## API Reference

## Public API: AppToast

### Named Constructors (Variants)

#### `AppToast.success(...)`

```dart
factory AppToast.success({
  Key? key,
  required String message,
  Widget? icon,
  bool showClose = true,
  VoidCallback? onClose,
})