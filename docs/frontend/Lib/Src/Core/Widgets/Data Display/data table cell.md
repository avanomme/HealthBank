# DataTableCell

## Overview

`DataTableCell` is a reusable table cell widget that standardizes styling and layout for data tables across the application. It provides a base `StatelessWidget` wrapper plus a set of factory constructors for common cell patterns (text, badge, status, date, actions, avatar, and custom content).

This component is intended to be used by higher-level table widgets to ensure consistent padding, alignment, and typography.

---

## Architecture / Design

### Design Goals

- Standardize table cell padding and alignment.
- Provide consistent typography and color usage via `AppTheme`.
- Minimize repetitive UI code by offering common cell factory constructors.
- Support flexible content (custom widgets) while keeping layout predictable.
- Handle common display cases (relative dates, status indicators, badges).

### Core Structure

`DataTableCell` wraps a child widget in:

- `Padding` (default table cell insets)
- `Row` (for horizontal alignment control)
- `Flexible` (to prevent overflow and allow ellipsis)

Default padding intentionally adds extra left spacing to prevent the first column from hugging the table border:

```dart
EdgeInsets.fromLTRB(16, 6, 8, 6)