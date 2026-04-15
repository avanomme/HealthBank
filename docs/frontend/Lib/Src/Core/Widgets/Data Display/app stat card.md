# AppStatCard

## Overview

`AppStatCard` is a reusable, theme-aligned statistic card widget designed to display a key metric with supporting context. It presents a descriptive label, a prominent value, and optionally an icon and subtitle.

The widget is intended for dashboards, analytics views, and summary panels where high-level metrics need visual emphasis.

---

## Architecture / Design

### Design Goals

- Provide a consistent card layout for key statistics.
- Emphasize numeric or summary values visually.
- Support optional iconography for contextual meaning.
- Maintain alignment with `AppTheme` typography and color tokens.
- Offer lightweight configurability via accent color and subtitle.

### Layout Structure

Outer container:

- Minimum height constraint (`minHeight: 120`)
- White background (`AppTheme.white`)
- Rounded corners (`BorderRadius.circular(12)`)
- Top border accent using provided `color`
- Subtle drop shadow for elevation

Internal layout:

- Horizontal `Row`
  - Optional icon container (left)
  - Expanded text column (right)

### Icon Presentation

If `icon` is provided:

- Rendered inside a fixed 44x44 container
- Background color derived from `color` with reduced opacity
- Icon colored using the same accent `color`
- Rounded corners for visual cohesion

If `icon` is `null`, the icon section is omitted entirely.

### Typography Strategy

All text styling derives from `AppTheme`:

- Label → `AppTheme.captions` with muted color
- Value → `AppTheme.heading4`, bold, primary text color
- Subtitle → `AppTheme.captions`, slightly adjusted font size

---

## Configuration

No direct configuration is required.

Correct behavior depends on:

- Proper configuration of `AppTheme`
- Usage within a `MaterialApp` context

---

## API Reference

### Constructor

```dart
const AppStatCard({
  Key? key,
  required String label,
  required String value,
  IconData? icon,
  Color color = AppTheme.primary,
  String? subtitle,
})