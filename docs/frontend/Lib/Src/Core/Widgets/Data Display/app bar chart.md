# AppBarChart

## Overview

`AppBarChart` is a reusable bar chart widget that wraps `fl_chart`’s `BarChart` to provide a theme-aligned, consistent charting component across the application.

It supports labeled categorical data, configurable bar color, adjustable height, optional value tooltips, and integrates with `AppTheme` for typography and color tokens.

This widget is intended for dashboards, analytics screens, and data summaries.

---

## Architecture / Design

### Design Goals

- Provide a consistent chart abstraction over `fl_chart`.
- Centralize chart styling using `AppTheme`.
- Handle empty datasets gracefully.
- Support categorical label → numeric value visualization.
- Keep configuration surface minimal but flexible.

### Composition Strategy

`AppBarChart`:

- Wraps `fl_chart`’s `BarChart`.
- Uses `BarChartData` to configure:
  - Alignment
  - Axis titles
  - Grid lines
  - Tooltips
  - Bar groups
- Applies consistent typography and color tokens from `AppTheme`.

### Data Model

The widget expects data in the form:

```dart
Map<String, double>