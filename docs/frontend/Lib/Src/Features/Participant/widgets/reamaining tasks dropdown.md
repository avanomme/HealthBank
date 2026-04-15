# RemainingTasksDropdown

## Overview
`RemainingTasksDropdown` is a Flutter UI component that displays the number of tasks a participant has remaining for the current day. The widget visually resembles a dropdown selector and follows the design specification displaying the message:

Remaining tasks for today: X

with a dropdown arrow icon. While styled like a dropdown, the widget itself does not implement dropdown functionality. Instead, it exposes a tap callback so that the parent widget can determine what action should occur when the component is pressed (for example, opening a menu, navigating to a task list, or showing a modal).

File location:  
frontend/lib/src/features/participant/widgets/remaining_tasks_dropdown.dart

---

## Architecture / Design
`RemainingTasksDropdown` is implemented as a `StatelessWidget`. Its role is purely presentational, meaning it only renders UI and forwards user interaction events. It does not maintain state or contain business logic.

The widget uses Flutter's `InkWell` widget to provide a material tap interaction. This allows the widget to respond visually to user taps and execute an optional callback function.

Layout structure:

InkWell  
└── Container  
  └── Row  
    ├── Text (Remaining tasks message)  
    └── Icon (dropdown arrow)

Styling is handled using the application's centralized theme (`AppTheme`), ensuring consistent colors and typography across the application.

Key design characteristics:

- Stateless and presentation-focused
- Uses theme-driven styling via `AppTheme`
- Provides a tap callback instead of managing dropdown logic
- Compact horizontal layout suitable for headers or dashboard sections

---

## Configuration

Constructor:

    const RemainingTasksDropdown({
      Key? key,
      required int remainingCount,
      VoidCallback? onTap,
    })

Configuration properties:

**remainingCount**  
Required integer representing the number of tasks remaining for the current day. This value is interpolated into the displayed text.

**onTap**  
Optional callback triggered when the widget is tapped. This allows the parent widget to define custom behavior such as opening a dropdown menu or navigating to another screen.

---

## API Reference

### Class
`RemainingTasksDropdown extends StatelessWidget`

### Properties

**remainingCount : int**  
The number of tasks remaining for the day. Displayed directly in the text label.

**onTap : VoidCallback?**  
Optional callback executed when the widget is tapped.

---

## Build Behavior
During build, the widget creates an `InkWell` wrapping a styled `Container`.

Container styling:

- Background color: `AppTheme.white`
- Border: `AppTheme.gray` with width `1`
- Border radius: `4`
- Padding: horizontal `12`, vertical `8`

Inside the container is a `Row` containing:

1. A text label displaying the remaining tasks.
2. A dropdown arrow icon.

Displayed text:

Remaining tasks for today: <remainingCount>

Text styling:

- Base style: `AppTheme.captions`
- Color override: `AppTheme.textPrimary`

Icon details:

- Icon: `Icons.arrow_drop_down`
- Size: `20`
- Color: `AppTheme.textPrimary`

Spacing between the text and icon is created using a `SizedBox` with width `8`.

---

## Error Handling
This widget does not implement explicit error handling because it only performs UI rendering.

Possible configuration issues include:

**Negative task values**  
If `remainingCount` is negative, the widget will still display the value as provided.

**Null tap handler**  
If `onTap` is not supplied, the widget will appear interactive but will not perform any action when tapped.

**Theme dependency**  
The widget assumes `AppTheme` provides the required color and typography definitions.

---

## Usage Examples

Basic usage:

    RemainingTasksDropdown(
      remainingCount: 5,
    )

Interactive usage:

    RemainingTasksDropdown(
      remainingCount: 3,
      onTap: () {
        // open dropdown menu or task list
      },
    )

Usage within a dashboard toolbar:

    Row(
      children: [
        RemainingTasksDropdown(
          remainingCount: 4,
          onTap: () {
            // navigate to tasks page
          },
        ),
      ],
    )

---

## Related Files

**frontend/src/core/theme/theme.dart**  
Defines the `AppTheme` class providing colors and typography used by the widget.

**Participant task UI components**  
This widget is typically used within participant dashboards or task-related UI components to display daily progress.