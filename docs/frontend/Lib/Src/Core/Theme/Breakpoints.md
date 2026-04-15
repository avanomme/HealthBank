# Responsive Breakpoints (`breakpoints.dart`)

## Overview

This module defines consistent responsive breakpoints and helper utilities for adapting layout and spacing across different screen sizes.

It provides:

- A `Breakpoint` enum for layout tiering
- A width-based breakpoint resolver function
- A `Breakpoints` utility class for screen classification
- Responsive spacing helpers

File: `frontend/lib/src/core/theme/breakpoints.dart`

---

## Architecture / Design

### Responsive Strategy

The app uses width-based breakpoints to support:

- Mobile layouts
- Tablet layouts
- Desktop layouts
- Ultrawide content constraints

Two approaches are supported:

1. **Enum-based tiering** using `Breakpoint`
2. **Utility methods** via the `Breakpoints` class

This separation allows:

- Simple branching via enum
- Explicit checks (`isMobile`, `isTablet`, `isDesktop`)
- Centralized breakpoint values for consistency

---

## Breakpoint Definitions

| Tier | Width Range |
|------|-------------|
| Mobile | `< 600px` |
| Tablet | `600px – 899px` |
| Desktop | `>= 900px` |
| Max Content Width | `1200px` |

---

# API Reference

---

## `enum Breakpoint`

```dart
enum Breakpoint { compact, medium, expanded }