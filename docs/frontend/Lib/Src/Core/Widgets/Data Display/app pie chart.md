# AppPieChart

## Overview

`AppPieChart` is a reusable, theme-aligned pie chart widget built on top of `fl_chart`’s `PieChart`. It visualizes categorical data as proportional segments and optionally displays a legend beside the chart.

The widget supports interactive highlighting on touch, configurable segment colors, adjustable height, and automatic percentage calculation.

It is intended for dashboards, analytics views, and summary panels.

---

## Architecture / Design

### Design Goals

- Provide a consistent abstraction over `fl_chart`’s pie chart.
- Integrate with `AppTheme` for typography and color tokens.
- Support interactive segment highlighting.
- Automatically compute and display percentage values.
- Gracefully handle empty datasets.

### Widget Type

`AppPieChart` is a `StatefulWidget` because it tracks user interaction state:

- `_touchedIndex` — identifies the currently highlighted pie section.

### Data Model

The widget expects:

```dart
Map<String, double>