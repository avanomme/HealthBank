# TaskCard

## Overview

`TaskCard` is a Flutter UI widget used to display a single participant task in a card-style layout. It shows the task title, due time, optional repeat information, and a **"Do Task"** action button. The widget is intended for use in participant dashboards, task lists, or daily task views.

File: `frontend/lib/src/features/participant/widgets/task_card.dart`

## Architecture / Design

`TaskCard` is implemented as a `StatelessWidget`. It is a presentation-only component and does not manage internal state. All data and behavior are provided through constructor parameters.

Layout structure:

Container → Row →
• Expanded (task details) → Column
 - Title
 - Due time
 - Optional repeat info
• ElevatedButton ("Do Task")

Styling is handled through `AppTheme` for consistent colors and typography across the application. The button label uses localization via `context.l10n`.

## Configuration

Constructor:

```
const TaskCard({
  Key? key,
  required String title,
  required String dueTime,
  String? repeatInfo,
  VoidCallback? onDoTask,
})
```

Parameters:

* **title** – Task title displayed at the top of the card.
* **dueTime** – Text describing when the task is due (example: "Due today at 2:30pm").
* **repeatInfo** – Optional text describing repeat behavior (example: "Repeats every 3 days").
* **onDoTask** – Optional callback triggered when the **Do Task** button is pressed.

## API Reference

Class: `TaskCard extends StatelessWidget`

Properties:

* `title : String` — Task title.
* `dueTime : String` — Due time or due date description.
* `repeatInfo : String?` — Optional recurrence information.
* `onDoTask : VoidCallback?` — Action executed when the task button is pressed.

## Error Handling

This widget does not implement explicit error handling.

Possible cases:

* If `repeatInfo` is null, the repeat information section is not displayed.
* If `onDoTask` is null, the button is disabled.

## Usage Examples

Basic usage:

```
TaskCard(
  title: "Take medication",
  dueTime: "Due today at 2:30pm",
)
```

With repeat information and button action:

```
TaskCard(
  title: "Daily check-in survey",
  dueTime: "Due today at 6:00pm",
  repeatInfo: "Repeats every day",
  onDoTask: () {
    // navigate to task workflow
  },
)
```

## Related Files

* `frontend/src/core/theme/theme.dart` — Defines `AppTheme` colors and text styles.
* `frontend/src/core/l10n/l10n.dart` — Provides localized strings used for the button label.
