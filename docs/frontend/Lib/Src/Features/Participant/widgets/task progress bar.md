# TaskProgressBar

## Overview

`TaskProgressBar` is a Flutter UI widget that displays a participant’s task completion progress. It shows a label, a green progress bar indicating completion percentage, and text describing how many tasks have been completed out of the total.

File: `frontend/lib/src/features/participant/widgets/task_progress_bar.dart`

## Architecture / Design

`TaskProgressBar` is a `StatelessWidget` that renders progress information based on the number of completed tasks relative to the total number of tasks.

Layout structure:

Column
• Label text ("Your Task Progress")
• Progress bar container
 - Gray background track
 - Green filled portion representing completion
• Completion summary text ("X out of Y tasks completed")

The progress bar uses `FractionallySizedBox` to dynamically size the filled section according to the calculated completion percentage.

Styling is provided through the shared `AppTheme`, and text labels are localized using `context.l10n`.

## Configuration

Constructor:

```
const TaskProgressBar({
  Key? key,
  required int completedTasks,
  required int totalTasks,
})
```

Parameters:

* **completedTasks** — Number of tasks completed by the participant.
* **totalTasks** — Total number of tasks assigned.

## API Reference

Class: `TaskProgressBar extends StatelessWidget`

Properties:

* `completedTasks : int` — Completed task count.
* `totalTasks : int` — Total number of tasks.

Internal calculation:

```
progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0
```

This value is used as the width factor for the progress bar fill.

## Error Handling

The widget prevents division-by-zero errors by checking whether `totalTasks` is greater than zero before calculating progress.

If `totalTasks` is `0`, progress defaults to `0.0`.

## Usage Examples

Basic usage:

```
TaskProgressBar(
  completedTasks: 3,
  totalTasks: 5,
)
```

Example within a dashboard section:

```
Column(
  children: [
    TaskProgressBar(
      completedTasks: 7,
      totalTasks: 10,
    ),
  ],
)
```

## Related Files

* `frontend/src/core/theme/theme.dart` — Provides the `AppTheme` styling used by the widget.
* `frontend/src/core/l10n/l10n.dart` — Provides localized labels used for the progress text.
