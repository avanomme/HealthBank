# Data Display Barrel File

## Overview

`data_display.dart` is a barrel file that aggregates and re-exports all reusable data display widgets within the `data_display` directory. It provides a single import entry point for charts, cards, tables, and other visualization components.

This file improves code organization, reduces import verbosity, and supports scalable UI architecture.

---

## Architecture / Design

### Design Goals

- Provide a centralized export point for all data display widgets.
- Reduce repetitive and granular import statements.
- Improve maintainability and scalability of the UI layer.
- Decouple external consumers from internal file structure changes.

### Barrel Pattern

This file follows the barrel file pattern:

- Defines no new classes or logic.
- Re-exports existing widget implementations.
- Serves purely as an aggregation layer.

### Exported Widgets

The following components are re-exported:

- `app_bar_chart.dart`
- `app_card_task.dart`
- `app_graph_renderer.dart`
- `app_pie_chart.dart`
- `app_progress_bar.dart`
- `app_stat_card.dart`
- `data_table_cell.dart`
- `data_table.dart`

---

## Configuration

No configuration is required.

To use all data display widgets via a single import:

```dart
import 'package:frontend/src/core/widgets/data_display/data_display.dart';