# Survey Question Widgets and Template System Documentation

This document describes the survey question widgets and the template system (pages, widgets, and Riverpod state) used in the Flutter frontend.

## Contents

### Survey Question Widgets
- **MultiChoiceWidget** – select multiple answers from a list (checkboxes).
- **SingleChoiceWidget** – select one answer from a list (radio buttons).
- **YesNoQuestionWidget** – boolean yes/no responses (two buttons).
- **NumberQuestionWidget** – numeric input with optional min/max validation.
- **OpenEndedQuestionWidget** – free-form text responses (multi-line text field).

### Template System
- **TemplateListPage** – browse/search/filter templates; selection mode supported.
- **TemplateBuilderPage** – create/edit templates; add/reorder/remove questions; save to API.
- **TemplateCard** – template list item UI with normal + selection modes and actions menu.
- **TemplatePreviewDialog** – modal preview of a template rendered as a survey (responses stored locally).
- **template_providers.dart** – Riverpod providers and state for template API, filters, selection, template builder workflows.

## Key Dependencies
- `AppTheme` for UI styling
- `context.l10n` for localization
- Riverpod (`flutter_riverpod`) for state management
- API layer (`frontend/src/core/api/api.dart`) for `TemplateApi`, domain models (`Template`, `Question`, etc.), and request DTOs (`TemplateCreate`, `TemplateUpdate`)
- Survey question type widgets from `frontend/src/features/surveys/widgets/question_types/question_types.dart`
- `HealthBankLogoHeader` from `frontend/src/core/widgets/basics/healthbank_logo.dart`

---

# Survey Question Widgets

## MultiChoiceWidget

### Overview
`MultiChoiceWidget` presents a **multi-selection** survey question using `CheckboxListTile` items. It maintains an internal list of selected options and reports changes through `onChanged`.

### Architecture / Design
- **Type:** `StatefulWidget`
- **Internal state:** `_selectedValues` (`List<String>`)
- **State synchronization:** `didUpdateWidget` refreshes `_selectedValues` when parent-supplied `values` changes.

### Configuration
| Parameter | Type | Required | Description |
|---|---|---|---|
| `questionText` | `String` | Yes | Question label shown above the options |
| `options` | `List<String>` | Yes | Available selectable options |
| `onChanged` | `ValueChanged<List<String>>` | Yes | Emits updated selected values |
| `values` | `List<String>` | No | Pre-selected / externally-controlled values |
| `isRequired` | `bool` | No | Shows required indicator (`*`) if true |

### Behavior
- Displays the question label with an optional required asterisk.
- Renders one checkbox tile per option.
- Emits a **copy** of selections after each toggle.

### Error Handling
- Prevents duplicate additions.
- Handles nullable checkbox values (`bool?`) safely.

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