# Survey Question Widgets and Template Pages Documentation

This document describes the survey question widgets and template-related pages used in the Flutter frontend.

Included components:

- **MultiChoiceWidget** – select multiple answers from a list (checkboxes).
- **SingleChoiceWidget** – select one answer from a list (radio buttons).
- **YesNoQuestionWidget** – boolean yes/no responses (two buttons).
- **NumberQuestionWidget** – numeric input with optional min/max validation.
- **OpenEndedQuestionWidget** – free-form text responses (multi-line text field).
- **TemplateBuilderPage** – create/edit survey templates by setting metadata and assembling/reordering questions.
- **TemplateListPage** – browse, search, filter, preview, duplicate, delete, and select templates.

These components integrate with the app’s theming (`AppTheme`), localization (`context.l10n`), and (for template pages) Riverpod providers for state, filtering, and API interactions.

---

## MultiChoiceWidget

### Overview
`MultiChoiceWidget` presents a **multi-selection** survey question using a list of `CheckboxListTile` items. It maintains an internal list of selected options and reports changes to the parent via a callback.

### Architecture / Design
- **Type:** `StatefulWidget`
- **State:** `_selectedValues` (a `List<String>`)
- **State sync:** `didUpdateWidget` refreshes `_selectedValues` if the parent passes a different `values` list.

### Configuration
| Parameter | Type | Required | Description |
|---|---|---|---|
| `questionText` | `String` | Yes | Question label shown above the options |
| `options` | `List<String>` | Yes | Available selectable options |
| `onChanged` | `ValueChanged<List<String>>` | Yes | Called with updated selected values |
| `values` | `List<String>` | No | Initial / externally-controlled selected values |
| `isRequired` | `bool` | No | Shows required indicator (`*`) if true |

### Behavior
- Renders question text and a required marker when `isRequired` is true.
- Creates one checkbox tile per option.
- Calls `onChanged` after each toggle with a **copy** of the selected values.

### Error Handling
- Prevents duplicate additions.
- Safely handles nullable checkbox state (`bool?`).

### Usage Example
```dart
MultiChoiceWidget(
  questionText: "Which programming languages do you use?",
  options: ["Dart", "Python", "Java", "C++"],
  values: selectedLanguages,
  isRequired: true,
  onChanged: (values) {
    setState(() => selectedLanguages = values);
  },
)