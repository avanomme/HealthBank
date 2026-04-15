# Survey Question Widgets Documentation

This document describes the survey question widgets used in the Flutter frontend. These components provide reusable UI elements for collecting user responses in surveys.

The widgets included in this module are:

- **MultiChoiceWidget** – select multiple answers from a list.
- **SingleChoiceWidget** – select one answer from a list.
- **YesNoQuestionWidget** – boolean yes/no responses.
- **NumberQuestionWidget** – numeric input with optional validation.
- **OpenEndedQuestionWidget** – free-form text responses.

All widgets are designed to integrate into larger survey forms and communicate responses back to parent widgets through callback functions.

---

# MultiChoiceWidget

## Overview
`MultiChoiceWidget` provides a survey question interface that allows users to **select multiple answers** from a predefined list of options using checkboxes.

The widget maintains an internal selection state and notifies parent components whenever the selected values change.

---

## Architecture / Design

### Widget Layer
The widget receives configuration from the parent:

- Question text
- List of available options
- Initial selected values
- Required indicator
- Callback for value updates

### State Layer
`_MultiChoiceWidgetState` manages:

- Internal list of selected values
- Checkbox toggle interactions
- Synchronization with updated parent values

### Data Flow

1. Parent widget passes initial selections.
2. Widget initializes `_selectedValues`.
3. User toggles checkboxes.
4. `_toggleOption()` updates the internal list.
5. Updated selections are sent to the parent through `onChanged`.

---

## Configuration

| Parameter | Type | Required | Description |
|---|---|---|---|
| `questionText` | `String` | Yes | Question text displayed above the options |
| `options` | `List<String>` | Yes | List of selectable options |
| `onChanged` | `ValueChanged<List<String>>` | Yes | Callback when selections change |
| `values` | `List<String>` | No | Initial selected options |
| `isRequired` | `bool` | No | Indicates if the question is required |

---

## Usage Example

```dart
MultiChoiceWidget(
  questionText: "Which programming languages do you use?",
  options: ["Dart", "Python", "Java", "C++"],
  values: selectedLanguages,
  isRequired: true,
  onChanged: (values) {
    setState(() {
      selectedLanguages = values;
    });
  },
)