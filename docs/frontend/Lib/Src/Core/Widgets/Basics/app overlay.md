# AppOverlay

## Overview

`AppOverlay` is a reusable full-screen overlay widget designed to block user interaction with underlying UI elements. It renders a non-dismissible modal barrier and can optionally display child content above the barrier.

This widget is commonly used as a foundational building block for modals, dialogs, and other elevated UI layers.

---

## Architecture / Design

`AppOverlay` is implemented as a `StatelessWidget` and uses a `Stack` to layer:

1. A full-screen `ModalBarrier`
2. Optional foreground content (`child`)

### Layout Structure

- `SizedBox.expand`
  - Ensures the overlay fills the entire available screen space.
- `Stack`
  - Bottom layer: `ModalBarrier`
  - Top layer: optional `child`

### Barrier Behavior

- Uses Flutter’s `ModalBarrier`
- `dismissible: false`
  - Prevents user interaction with content behind the overlay
  - Does not allow tapping the barrier to dismiss
- Color:
  - Defaults to `AppTheme.black`
  - Opacity applied via `barrierOpacity`
  - Can be overridden via `barrierColor`

### Color Resolution

The barrier color is resolved as:
