<!-- Created with the Assistance of Claude Code -->
# Survey Question Type Widgets

The HealthBank survey system supports 6 question types, each with a dedicated Flutter widget.

## Architecture

```
frontend/lib/features/surveys/widgets/question_types/
├── question_types.dart            # Barrel file (import this)
├── number_question_widget.dart    # Numeric input
├── yesno_question_widget.dart     # Boolean toggle (Yes/No)
├── openended_question_widget.dart # Free text input
├── single_choice_widget.dart      # Radio buttons (single select)
├── multi_choice_widget.dart       # Checkboxes (multi select)
└── scale_question_widget.dart     # Slider/rating scale
```

## Quick Start

```dart
import 'package:frontend/features/surveys/widgets/question_types/question_types.dart';

// All 6 widgets are available:
NumberQuestionWidget(...)
YesNoQuestionWidget(...)
OpenEndedQuestionWidget(...)
SingleChoiceWidget(...)
MultiChoiceWidget(...)
ScaleQuestionWidget(...)
```

---

## Widget Specifications

### Common Properties

All question widgets share these base properties:

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `questionText` | `String` | Yes | The question to display |
| `isRequired` | `bool` | No | Shows asterisk (*) when true |
| `onChanged` | `Function` | Yes | Callback when value changes |

---

### NumberQuestionWidget

Numeric input field with optional validation.

```dart
NumberQuestionWidget(
  questionText: 'What is your age?',
  isRequired: true,
  min: 0,
  max: 120,
  onChanged: (int? value) => print(value),
)
```

| Property | Type | Description |
|----------|------|-------------|
| `min` | `int?` | Minimum allowed value |
| `max` | `int?` | Maximum allowed value |
| `value` | `int?` | Initial value |

**Validation:**
- Non-numeric input is blocked via input filter (only digits and `-` allowed)
- Out-of-range values show "Value must be between {min} and {max}"

---

### YesNoQuestionWidget

Binary choice with visual toggle buttons.

```dart
YesNoQuestionWidget(
  questionText: 'Do you exercise regularly?',
  isRequired: true,
  initialValue:  true,
  onChanged: (bool? value) => print(value),
)
```

| Property | Type | Description |
|----------|------|-------------|
| `value` | `bool?` | Initial selection (true=Yes, false=No) |

**UI:** Two side-by-side buttons styled with AppTheme.primary for selected state.

---

### OpenEndedQuestionWidget

Multi-line text area for free-form responses.

```dart
OpenEndedQuestionWidget(
  questionText: 'Please describe your symptoms',
  isRequired: true,
  maxLines: 5,
  maxLength: 500,
  onChanged: (String? value) => print(value),
)
```

| Property | Type | Description |
|----------|------|-------------|
| `value` | `String?` | Initial text |
| `maxLines` | `int` | Number of visible lines (default: 4) |
| `maxLength` | `int?` | Character limit with counter |

---

### SingleChoiceWidget

Radio button list for single selection.

```dart
SingleChoiceWidget(
  questionText: 'How often do you exercise?',
  options: ['Never', 'Sometimes', 'Often', 'Always'],
  isRequired: true,
  initialValue:  'Sometimes',
  onChanged: (String? value) => print(value),
)
```

| Property | Type | Description |
|----------|------|-------------|
| `options` | `List<String>` | Available choices |
| `value` | `String?` | Currently selected option |

**UI:** Uses `RadioGroup` with `RadioListTile` for each option (Flutter 3.32+ API).

---

### MultiChoiceWidget

Checkbox list for multiple selections.

```dart
MultiChoiceWidget(
  questionText: 'Select all symptoms you experience:',
  options: ['Headache', 'Fatigue', 'Nausea', 'Dizziness'],
  isRequired: true,
  values: ['Headache', 'Fatigue'],
  onChanged: (List<String> values) => print(values),
)
```

| Property | Type | Description |
|----------|------|-------------|
| `options` | `List<String>` | Available choices |
| `values` | `List<String>` | Currently selected options |

**UI:** Uses `CheckboxListTile` for each option.

---

### ScaleQuestionWidget

Slider for numeric rating scales.

```dart
ScaleQuestionWidget(
  questionText: 'Rate your pain level',
  min: 0,
  max: 10,
  divisions: 10,
  minLabel: 'No pain',
  maxLabel: 'Severe pain',
  initialValue:  5,
  onChanged: (double value) => print(value),
)
```

| Property | Type | Description |
|----------|------|-------------|
| `min` | `double` | Minimum scale value |
| `max` | `double` | Maximum scale value |
| `value` | `double?` | Current slider position |
| `divisions` | `int?` | Number of discrete steps |
| `minLabel` | `String?` | Label at minimum end |
| `maxLabel` | `String?` | Label at maximum end |

**UI:** Displays current value, min/max labels, and uses `Slider` widget.

---

## Styling

All widgets use `AppTheme` from `lib/core/theme/theme.dart`:

- **Primary color:** `#172B46` - Selected states, focus
- **Error color:** `#A6192E` - Validation errors
- **Text styles:** Roboto font family
- **Required indicator:** Red asterisk (*) after question text

---

## Accessibility

All widgets implement:
- Semantic labels for screen readers
- Proper focus handling
- Touch-friendly tap targets (48dp minimum)
- High contrast text

---

## Testing

Tests are in `frontend/test/widgets/question_types_test.dart`.

Run tests:
```bash
cd frontend
flutter test test/widgets/question_types_test.dart
```

Test coverage per widget:
- Display question text
- Required indicator visibility
- Value change callbacks
- Input validation
- Initial value handling
- Accessibility semantics

---

## Usage in Survey Builder

The survey builder uses a factory pattern to render the appropriate widget:

```dart
Widget buildQuestionWidget(Question question, Function onChanged) {
  switch (question.responseType) {
    case 'number':
      return NumberQuestionWidget(
        questionText: question.questionContent,
        isRequired: question.isRequired,
        onChanged: onChanged,
      );
    case 'yesno':
      return YesNoQuestionWidget(
        questionText: question.questionContent,
        isRequired: question.isRequired,
        onChanged: onChanged,
      );
    case 'openended':
      return OpenEndedQuestionWidget(
        questionText: question.questionContent,
        isRequired: question.isRequired,
        onChanged: onChanged,
      );
    case 'single_choice':
      return SingleChoiceWidget(
        questionText: question.questionContent,
        options: question.options?.map((o) => o.optionText).toList() ?? [],
        isRequired: question.isRequired,
        onChanged: onChanged,
      );
    case 'multi_choice':
      return MultiChoiceWidget(
        questionText: question.questionContent,
        options: question.options?.map((o) => o.optionText).toList() ?? [],
        isRequired: question.isRequired,
        onChanged: onChanged,
      );
    case 'scale':
      return ScaleQuestionWidget(
        questionText: question.questionContent,
        min: 0,
        max: 10,
        isRequired: question.isRequired,
        onChanged: onChanged,
      );
    default:
      throw Exception('Unknown question type: ${question.responseType}');
  }
}
```

---

## Implementation Status

- [x] NumberQuestionWidget
- [x] YesNoQuestionWidget
- [x] OpenEndedQuestionWidget
- [x] SingleChoiceWidget
- [x] MultiChoiceWidget
- [x] ScaleQuestionWidget

All 39 tests passing: `test/widgets/question_types_test.dart`
