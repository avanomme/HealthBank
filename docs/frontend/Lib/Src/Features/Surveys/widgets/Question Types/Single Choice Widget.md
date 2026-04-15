# Survey Question Widgets Documentation

This document describes the survey question widgets used in the Flutter frontend. These components provide reusable UI elements for collecting user responses in surveys. The widgets documented here include:

- **MultiChoiceWidget** – allows selecting multiple answers from a list.
- **SingleChoiceWidget** – allows selecting one answer from a list.
- **NumberQuestionWidget** – accepts numeric input with optional validation.
- **OpenEndedQuestionWidget** – allows users to enter free-form text responses.

All widgets are designed to be reusable survey input components and integrate with parent survey forms through callback functions.

---

# MultiChoiceWidget

## Overview
`MultiChoiceWidget` is a Flutter UI component used to present **multi-selection survey questions**.  
It allows users to select **multiple answers from a predefined list of options** using checkboxes.

The widget maintains an internal selection state and notifies parent components whenever the selected values change. It is implemented as a **StatefulWidget** because it tracks the currently selected options.

---

## Architecture / Design

### Widget Layer
`MultiChoiceWidget` defines the configuration of the question including:

- Question text
- List of selectable options
- Initial selected values
- Required flag
- Callback function

### State Layer
`_MultiChoiceWidgetState` manages:

- Internal list of selected values
- Checkbox toggle interactions
- Synchronization with updated parent values

### Data Flow

1. Parent widget passes initial values.
2. Widget initializes `_selectedValues`.
3. User toggles checkboxes.
4. `_toggleOption()` updates `_selectedValues`.
5. Updated values are returned through `onChanged`.

### State Synchronization

Two lifecycle methods ensure consistent state:

- `initState()` initializes the internal value list.
- `didUpdateWidget()` updates the internal list if the parent widget changes values.

---

## Configuration

### Constructor Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `questionText` | `String` | Yes | Survey question text |
| `options` | `List<String>` | Yes | Available selectable options |
| `onChanged` | `ValueChanged<List<String>>` | Yes | Callback triggered when selections change |
| `values` | `List<String>` | No | Initial selected options |
| `isRequired` | `bool` | No | Indicates whether the question must be answered |

### Default Values

| Parameter | Default |
|---|---|
| `values` | `[]` |
| `isRequired` | `false` |

---

## API Reference

### MultiChoiceWidget

Displays a list of checkboxes allowing the user to select multiple options.

#### Behavior

- Renders a question label and checkbox list
- Allows selecting multiple options
- Returns updated selections to the parent widget

---

### _toggleOption

Handles selection and deselection of options.

#### Parameters

| Parameter | Type | Description |
|---|---|---|
| `option` | `String` | Option being toggled |
| `selected` | `bool?` | Checkbox state |

#### Behavior

- Adds option when checked
- Removes option when unchecked
- Sends updated list through `onChanged`

---

## Error Handling

The widget includes basic defensive logic:

- Prevents duplicate entries in the selection list
- Handles nullable checkbox values safely
- Synchronizes internal state when parent updates occur

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