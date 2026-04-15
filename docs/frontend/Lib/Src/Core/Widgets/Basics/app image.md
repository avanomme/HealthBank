# AppImage

## Overview

`AppImage` is a reusable Flutter image widget that supports responsive sizing without requiring hard-coded dimensions. It accepts any `ImageProvider` (asset, network, memory, etc.) and provides optional helpers for:

- Responsive sizing using `aspectRatio`
- Optional width/height overrides
- Optional border radius clipping
- Accessibility semantics configuration
- Custom error and loading builders

This widget is intended as a basic building block for consistent image rendering across an application.

---

## Architecture / Design

`AppImage` is implemented as a `StatelessWidget` and uses a `LayoutBuilder` to determine how to size itself based on:

- Explicit `width` and/or `height` (if provided)
- Parent layout constraints (bounded width/height)
- Optional `aspectRatio` behavior

### Sizing Strategy

`AppImage` computes `boxWidth` and `boxHeight` used to wrap the image in a `SizedBox` when it can infer a meaningful size.

#### When `aspectRatio` is provided

- If **both** `width` and `height` are explicitly set:
  - `aspectRatio` is ignored for layout.
  - The widget uses the provided `width` and `height`.
- Otherwise:
  - If one dimension is explicit (`width` or `height`), it is used.
  - If neither is explicit:
    - If the parent provides a bounded width, `boxWidth = constraints.maxWidth`.
    - Else if the parent provides a bounded height, `boxHeight = constraints.maxHeight`.
  - The image is wrapped in an `AspectRatio` to compute the missing dimension.

This design prioritizes leaving one axis unconstrained so `AspectRatio` can compute the other axis responsively, while still respecting parent bounds when available.

#### When `aspectRatio` is not provided

- If `width` is provided, it is used.
- Otherwise, if the parent has bounded width, the widget uses `constraints.maxWidth`.
- Similarly for height:
  - Uses explicit `height` if provided
  - Else uses `constraints.maxHeight` if bounded
- If neither axis is bounded and no explicit dimensions are provided, the underlying `Image` is returned without a sizing wrapper.

### Rendering Pipeline

1. Build an `Image` widget configured with:
   - `image`, `fit`, `alignment`
   - Optional explicit `width` and `height` (only if provided)
   - Accessibility and builders (`semanticLabel`, `excludeFromSemantics`, `errorBuilder`, `loadingBuilder`)

2. If `aspectRatio` is provided and both `width` and `height` are not explicitly set:
   - Wrap in `AspectRatio(aspectRatio: ...)`

3. If `borderRadius` is provided:
   - Wrap in `ClipRRect(borderRadius: ...)`

4. If `boxWidth` or `boxHeight` were resolved:
   - Wrap in `SizedBox(width: boxWidth, height: boxHeight)`

---

## Configuration

No external configuration is required.

`AppImage` depends only on Flutter’s `material` library and standard layout constraints. It is designed to work cleanly with common parent widgets such as `Row`, `Column`, `Expanded`, `SizedBox`, `Container`, and `AspectRatio`.

---

## API Reference

### Constructor

```dart
const AppImage({
  Key? key,
  required ImageProvider image,
  BoxFit fit = BoxFit.cover,
  Alignment alignment = Alignment.center,
  double? aspectRatio,
  double? width,
  double? height,
  BorderRadius? borderRadius,
  String? semanticLabel,
  bool excludeFromSemantics = false,
  ImageErrorWidgetBuilder? errorBuilder,
  ImageLoadingBuilder? loadingBuilder,
})