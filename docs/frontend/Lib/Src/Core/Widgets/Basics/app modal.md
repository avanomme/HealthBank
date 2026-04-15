# AppModal

## Overview

`AppModal` is a reusable, centered modal dialog widget intended to display focused content above the rest of the UI. It renders an `AppOverlay` behind the modal to visually separate modal content from the underlying screen.

The default modal layout is:

- Heading 3 title
- Body text
- Primary action button aligned to the bottom-right

---

## Architecture / Design

`AppModal` is implemented as a `StatelessWidget` and composes several app-level building blocks to achieve a consistent modal presentation.

### Component Composition

- **`AppOverlay`**
  - Provides the dimmed/overlay backdrop behind the modal.
  - `AppModal` renders its content as the `child` of `AppOverlay`.

- **Layout**
  - `Center` ensures the modal is centered on screen.
  - `Padding` applies responsive outer spacing using horizontal margins.
  - `ConstrainedBox` limits the modal width to a maximum content width and screen bounds.
  - `Material` provides surface color, rounded corners, and elevation.

- **Content**
  - Uses a `Column(mainAxisSize: MainAxisSize.min)` so the modal wraps content height.
  - Title and body text use theme-aware typography.
  - Primary action is right-aligned and triggers `onClose`.

### Sizing and Responsiveness

`AppModal` determines its layout based on current screen width:

- Breakpoint and typography:
  - `bp = breakpointForWidth(width)`
  - `headingStyle = textTheme.displaySmall ?? AppTheme.heading3`
  - `bodyStyle = textTheme.bodyMedium ?? AppTheme.body`

- Spacing:
  - `padding = Breakpoints.responsivePadding(width)`
  - `horizontalMargin = Breakpoints.responsiveHorizontalMargin(width)`

- Width constraints:
  - `maxWidth = min(Breakpoints.maxContent, width - horizontalMargin * 2)`
  - Ensures the modal remains readable on large screens and fits on small screens.
  - Uses `math.max(0, maxWidth)` defensively to avoid negative constraints.

- Shape:
  - `cardRadius = BorderRadius.circular(padding * 0.6)`

---

## Configuration

`AppModal` relies on application theme and layout utilities:

- `AppTheme`
  - Typography fallbacks (`heading3`, `body`)
- `Breakpoints`
  - `responsivePadding(width)`
  - `responsiveHorizontalMargin(width)`
  - `maxContent`
- `AppOverlay`
  - Backdrop layer behind the modal
- `AppFilledButton`
  - Primary action button implementation

No additional configuration is required, but the widget assumes these dependencies exist and are correctly styled for consistent UI.

---

## API Reference

### Constructor

```dart
const AppModal({
  Key? key,
  required String title,
  required String body,
  required String actionLabel,
  required VoidCallback onClose,
})