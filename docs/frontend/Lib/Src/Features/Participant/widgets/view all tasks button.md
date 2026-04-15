# ViewAllTasksButton

## Overview

`ViewAllTasksButton` is a Flutter UI widget that renders a full-width primary button used to navigate to a complete list of participant tasks. It matches the design specification as a prominent action button labeled **"View All Tasks"**.

File: `frontend/lib/src/features/participant/widgets/view_all_tasks_button.dart`

## Architecture / Design

`ViewAllTasksButton` is implemented as a `StatelessWidget`. It provides a reusable button component styled according to the application's theme.

Layout structure:

SizedBox (full width, fixed height)
└── ElevatedButton
  └── Text ("View All Tasks")

The `SizedBox` ensures the button spans the full available width and maintains a consistent height. Styling and colors are provided through `AppTheme` to maintain consistent UI design.

## Configuration

Constructor:

```
const ViewAllTasksButton({
  Key? key,
  VoidCallback? onPressed,
})
```

Parameters:

* **onPressed** — Optional callback executed when the button is pressed.

## API Reference

Class: `ViewAllTasksButton extends StatelessWidget`

Properties:

* `onPressed : VoidCallback?` — Action triggered when the button is tapped. If `null`, the button is disabled.

## Error Handling

This widget does not implement explicit error handling.

Possible cases:

* If `onPressed` is `null`, the `ElevatedButton` becomes disabled.
* The widget assumes `AppTheme` provides the required color and typography styles.

## Usage Examples

Basic usage:

```
ViewAllTasksButton(
  onPressed: () {
    // navigate to full task list
  },
)
```

Example inside a dashboard layout:

```
Column(
  children: [
    ViewAllTasksButton(
      onPressed: () {
        // open tasks page
      },
    ),
  ],
)
```

## Related Files

* `frontend/src/core/theme/theme.dart` — Provides the `AppTheme` styles used for button appearance.
