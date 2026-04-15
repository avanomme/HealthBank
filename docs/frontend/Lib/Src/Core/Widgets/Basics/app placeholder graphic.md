# AppPlaceholderGraphic

## Overview

`AppPlaceholderGraphic` is a reusable, theme-consistent placeholder image widget intended for use when content is empty, loading, or unavailable.

It wraps `AppImage` and provides a shared default placeholder asset to ensure consistent visuals across the application. The widget supports responsive scaling through a configurable `aspectRatio` and allows optional overrides for image behavior and accessibility.

---

## Architecture / Design

`AppPlaceholderGraphic` is implemented as a `StatelessWidget` and acts as a thin abstraction over `AppImage`.

### Composition

- Internally renders:
  - `AppImage`
- Uses:
  - `AssetImage(assetPath)` as the image source

This ensures:

- Consistent behavior with all other images rendered via `AppImage`
- Centralized control of placeholder styling
- Responsive layout without hard-coded dimensions

### Default Behavior

- Default asset path: