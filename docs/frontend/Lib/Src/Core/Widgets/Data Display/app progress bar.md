# AppProgressBar

## Overview

`AppProgressBar` is a reusable, theme-aware horizontal progress bar widget designed to visually represent completion states. It supports customizable colors, responsive sizing, rounded corners, and built-in accessibility semantics for screen readers.

The widget integrates with `AppTheme` and `Breakpoints` utilities to maintain consistent styling and spacing across the application.

---

## Architecture / Design

### Design Goals

- Provide a consistent progress visualization component.
- Integrate with global theme color tokens.
- Adapt sizing responsively across breakpoints.
- Support accessibility via semantic metadata.
- Safely handle out-of-range progress values.

### Progress Model

The widget expects:

```dart
double progress