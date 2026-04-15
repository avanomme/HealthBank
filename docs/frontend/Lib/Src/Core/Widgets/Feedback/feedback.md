# Feedback Barrel File

## Overview

`feedback.dart` is a barrel file that aggregates and re-exports all reusable feedback-related widgets within the `feedback` directory. It provides a single import entry point for components such as toasts, announcements, and popovers.

This file improves modularity, reduces import verbosity, and centralizes feedback widget access across the application.

---

## Architecture / Design

### Design Goals

- Provide a unified import surface for all feedback widgets.
- Reduce repetitive per-file import statements.
- Improve scalability as new feedback components are added.
- Decouple consumers from internal file structure changes.

### Barrel Pattern

This file follows the barrel file pattern:

- Contains no runtime logic.
- Defines no classes or functions.
- Re-exports specific widget implementations.

### Exported Widgets

The following widgets are re-exported:

- `app_announcement.dart`
- `app_popover.dart`
- `app_toasts.dart`

These typically include:

- `AppAnnouncement`
- `AppPopover`
- `AppToast` (and associated static show helpers)

---

## Configuration

No configuration is required.

To use all feedback widgets via a single import:

```dart
import 'package:frontend/src/core/widgets/feedback/feedback.dart';