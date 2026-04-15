# Survey Question Widgets and Template System Documentation

This document describes the survey question widgets and the template system (pages + Riverpod state) used in the Flutter frontend.

Included components:

## Survey Question Widgets
- **MultiChoiceWidget** – select multiple answers from a list (checkboxes).
- **SingleChoiceWidget** – select one answer from a list (radio buttons).
- **YesNoQuestionWidget** – boolean yes/no responses (two buttons).
- **NumberQuestionWidget** – numeric input with optional min/max validation.
- **OpenEndedQuestionWidget** – free-form text responses (multi-line text field).

## Template System
- **TemplateListPage** – browse/search/filter templates; selection mode supported.
- **TemplateBuilderPage** – create/edit templates; add/reorder/remove questions; save to API.
- **template_providers.dart** – Riverpod providers and state for templates list, filters, selection mode, and template builder workflows.

These components integrate with:
- `AppTheme` for UI styling
- `context.l10n` for localization
- Riverpod (`flutter_riverpod`) for state management
- API layer (`frontend/src/core/api/api.dart`) for `TemplateApi`, models, and DTOs

---

# Survey Question Widgets

## MultiChoiceWidget

### Overview
`MultiChoiceWidget` presents a **multi-selection** survey question using `CheckboxListTile` items. It maintains an internal list of selected options and reports updates via `onChanged`.

### Architecture / Design
- **Type:** `StatefulWidget`
- **Internal state:** `_selectedValues` (`List<String>`)
- **State synchronization:** `didUpdateWidget` updates internal state when parent-supplied `values` changes.

### Configuration
| Parameter | Type | Required | Description |
|---|---|---|---|
| `questionText` | `String` | Yes | Question label shown above the options |
| `options` | `List<String>` | Yes | Available selectable options |
| `onChanged` | `ValueChanged<List<String>>` | Yes | Emits updated selected values |
| `values` | `List<String>` | No | Pre-selected / externally-controlled values |
| `isRequired` | `bool` | No | Shows required indicator (`*`) if true |

### Behavior
- Displays question text with an optional required asterisk.
- Renders one checkbox per option.
- Emits a **copied list** of selections via `onChanged` after each interaction.

### Error Handling
- Prevents duplicates when adding.
- Handles nullable checkbox state (`bool?`) safely.

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