# QuestionBankFormDialog

## Overview

`QuestionBankFormDialog` is a modal dialog used to create or edit question bank entries. It supports all configured response types and dynamically renders additional fields for option-based questions and scale configuration. On successful create/update, it invalidates `questionsProvider` so the question list refreshes.

File: `frontend/lib/features/question_bank/widgets/question_bank_form_dialog.dart`

## Architecture / Design

* **Widget type:** `ConsumerStatefulWidget` to allow local form state + Riverpod access.
* **Modes:**

  * **Create mode:** `widget.question == null`
  * **Edit mode:** `widget.question != null` (fields populated from the provided question)
* **State managed locally:**

  * Text controllers: title, content, category, and a dynamic list of option controllers
  * `_selectedType`, `_isRequired`, `_isLoading`, `_errorMessage`
  * Scale range inputs: `_scaleMin`, `_scaleMax` (UI-only in this implementation)
* **Dynamic UI:**

  * Choice chips for selecting question type (`responseTypes` / `responseTypeLabels`)
  * Options section appears only for `single_choice` / `multi_choice`
  * Scale settings appear only for `scale`
* **Submit flow:**

  * Validates form + enforces minimum option count for choice types
  * Calls `QuestionApi.createQuestion(...)` or `QuestionApi.updateQuestion(...)`
  * Invalidates `questionsProvider`
  * Closes dialog with the created/updated `Question` result

## Configuration

### Constructor

```
const QuestionBankFormDialog({
  Key? key,
  Question? question,
})
```

Parameters:

* **question** — Existing question to edit; if `null`, the dialog runs in create mode.

### Static show helper

```
static Future<Question?> show(BuildContext context, { Question? question })
```

Behavior:

* Opens a non-dismissable `AlertDialog` (`barrierDismissible: false`)
* Returns the created/updated `Question` when the dialog closes via successful submit
* Returns `null` if the user cancels/closes without submitting

## API Reference

### Class: `QuestionBankFormDialog extends ConsumerStatefulWidget`

Public fields:

* `question : Question?`

Static:

* `show(BuildContext context, {Question? question}) -> Future<Question?>`

### State: `_QuestionBankFormDialogState extends ConsumerState<QuestionBankFormDialog>`

Key computed flags:

* `_isEditMode` — `widget.question != null`
* `_requiresOptions` — `_selectedType == 'single_choice' || _selectedType == 'multi_choice'`

Key methods:

* `initState()`

  * Edit mode: `_populateFromQuestion(question)`
  * Create mode: adds two default option controllers
* `_populateFromQuestion(Question question)`

  * Sets initial controller values, response type, required flag, and option controllers (or adds defaults if required)
* `dispose()`

  * Disposes all controllers (title/content/category + each option controller)
* `_addOption()`

  * Adds a new empty option controller
* `_removeOption(int index)`

  * Removes an option controller only if more than 2 options remain (enforces minimum UI count)
* `_submit() -> Future<void>`

  * Validates:

    * Form must validate (`questionContent` required)
    * If `_requiresOptions`: at least 2 non-empty options (else sets localized `_errorMessage`)
  * Builds `QuestionOptionCreate` list for non-empty options with `displayOrder` = list index
  * Calls:

    * Edit mode: `api.updateQuestion(questionId, QuestionUpdate(...))`
    * Create mode: `api.createQuestion(QuestionCreate(...))`
  * Invalidates `questionsProvider`
  * On success: `Navigator.pop(result)`
  * On error: sets `_errorMessage` and clears `_isLoading`

UI builders:

* `_buildTypeSelector(BuildContext context)` — ChoiceChip list of response types with icons
* `_buildOptionsSection(BuildContext context)` — Dynamic list of option text fields + add/remove controls
* `_buildScaleSettings(BuildContext context)` — Min/max numeric fields (updates `_scaleMin` / `_scaleMax`)
* `_getIconForType(String responseType)` — Icon mapping for response types

## Error Handling

* **Validation errors (client-side):**

  * Missing required question content shows a localized validation error.
  * Choice types require at least **two non-empty** options; otherwise `_errorMessage` is set to `questionFormProvideOptions`.
* **API errors:**

  * Any exception during create/update is caught; `e.toString()` is shown in an in-dialog error panel and `_isLoading` is reset.
* **Cancel while loading:**

  * Cancel button is disabled while `_isLoading` is true.
* **Provider refresh:**

  * Always invalidates `questionsProvider` after successful submit to refresh lists elsewhere.

## Usage Examples

### Create a new question

```
final created = await QuestionBankFormDialog.show(context);
if (created != null) {
  // use created question if needed
}
```

### Edit an existing question

```
final updated = await QuestionBankFormDialog.show(
  context,
  question: existingQuestion,
);
```

## Related Files

* `frontend/lib/features/question_bank/state/question_providers.dart`

  * `questionApiProvider` used for create/update calls
  * `questionsProvider` invalidated after submit
  * `responseTypes` and `responseTypeLabels` used by the type selector
* `frontend/src/core/api/api.dart` — Models and request DTOs: `Question`, `QuestionCreate`, `QuestionUpdate`, `QuestionOptionCreate`
* `frontend/src/core/l10n/l10n.dart` — All dialog labels, hints, and error strings
* `frontend/src/core/theme/theme.dart` — `AppTheme` styling for inputs, chips, and error panel
