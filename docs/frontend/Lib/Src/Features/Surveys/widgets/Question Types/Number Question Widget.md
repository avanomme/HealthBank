# Survey Question Widgets Documentation

This document describes the survey question widgets used in the Flutter frontend. These components provide reusable UI elements for collecting user responses in surveys. The widgets documented here include:

- **MultiChoiceWidget** – allows selecting multiple answers from a list.
- **NumberQuestionWidget** – accepts numeric input with optional validation.

Both widgets follow Flutter's **StatefulWidget architecture**, maintain internal UI state, and communicate updates to parent components using callback functions.

---

# MultiChoiceWidget

## Overview
`MultiChoiceWidget` is a Flutter UI component used to present **multi-selection survey questions**.  
It allows users to select **multiple answers from a predefined list of options** using checkboxes.

The widget maintains an internal selection state and notifies parent components whenever the selected values change. It is designed for use within survey forms or questionnaires where multiple responses are permitted.

This widget is implemented as a **StatefulWidget** to manage local state updates while maintaining synchronization with external values passed from parent widgets.

---

## Architecture / Design

The implementation follows Flutter's **Stateful Widget pattern**, separating immutable configuration from mutable state.

### Widget Layer
`MultiChoiceWidget` defines the public API and configuration for the question component. It receives:

- Question text
- Available answer options
- Current selected values
- A callback for value updates
- Required field indicator

### State Layer
`_MultiChoiceWidgetState` manages:

- Internal selection state
- UI updates when checkboxes are toggled
- Synchronization with external value changes

### Data Flow

1. Parent widget provides the question text, available options, and initial selected values.
2. The widget copies the provided values into its internal `_selectedValues`.
3. The user selects or deselects checkbox options.
4. `_toggleOption()` updates the internal state.
5. Updated selections are sent to the parent through `onChanged`.
6. The parent widget stores or processes the updated values.

### State Synchronization

Two lifecycle methods maintain state consistency:

- `initState()` initializes selections from the provided values.
- `didUpdateWidget()` updates internal selections if the parent widget provides new values.

---

## Configuration

### Constructor Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `questionText` | `String` | Yes | The survey question displayed above the options |
| `options` | `List<String>` | Yes | List of selectable answer choices |
| `onChanged` | `ValueChanged<List<String>>` | Yes | Callback triggered when selections change |
| `values` | `List<String>` | No | Pre-selected options provided by the parent |
| `isRequired` | `bool` | No | Indicates whether the question is mandatory |

### Default Values

| Parameter | Default |
|---|---|
| `values` | `[]` |
| `isRequired` | `false` |

---

## API Reference

### MultiChoiceWidget

Main widget used to render a multi-select survey question.

#### Parameters

- `questionText` (`String`) – The question displayed above the list of options.
- `options` (`List<String>`) – Available choices presented as checkbox items.
- `onChanged` (`ValueChanged<List<String>>`) – Callback triggered whenever the selected values change.
- `values` (`List<String>`) – Initial selected options provided from external state.
- `isRequired` (`bool`) – Determines whether a required indicator (`*`) appears next to the question.

#### Behavior

- Displays a question label followed by checkbox options.
- Supports selecting multiple answers.
- Notifies the parent widget of changes through `onChanged`.

---

### _toggleOption

Handles selection and deselection of options.

#### Parameters

- `option` (`String`) – The option being toggled.
- `selected` (`bool?`) – Indicates whether the checkbox was checked or unchecked.

#### Description

Updates the internal `_selectedValues` list based on user interaction:

- Adds the option if selected.
- Removes the option if deselected.

After updating state, the widget invokes `onChanged` to notify the parent component of the updated selections.

---

## Error Handling

The widget itself does not throw exceptions but includes defensive state behavior.

### State Synchronization
`didUpdateWidget()` ensures internal state matches external updates when the parent widget modifies selected values.

### Duplicate Prevention
When adding options, the widget verifies the value does not already exist in `_selectedValues`.

### Null Handling
The `selected` parameter is nullable (`bool?`), and logic safely checks for `true` before adding values.

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