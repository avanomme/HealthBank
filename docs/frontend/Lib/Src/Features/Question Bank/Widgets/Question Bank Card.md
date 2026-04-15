# QuestionBankCard

## Overview

`QuestionBankCard` is a Flutter UI widget that renders a single `Question` from the question bank as a card. It supports two interaction modes:

* **Selection mode:** shows a checkbox; tapping the card toggles selection.
* **Normal mode:** shows an actions menu (edit/duplicate/delete); tapping the card triggers a view/edit action.

File: `frontend/lib/features/question_bank/widgets/question_bank_card.dart`

## Architecture / Design

* **Presentation:** Uses `Card` + `InkWell` with padding and a row layout:

  * Optional checkbox (selection mode)
  * Question type icon (derived from `question.responseType`)
  * Main content (title/content preview + tags)
  * Optional overflow actions menu (normal mode)
* **Selection styling:** When `isSelected`:

  * Card elevation increases
  * Card border becomes `AppTheme.primary` with width `2`
* **Tags:** Rendered via `Wrap`:

  * Response type label from `responseTypeLabels` (fallback to raw type)
  * Optional category tag (if `question.category != null`)
  * Optional “required” tag (if `question.isRequired`)

## Configuration

Constructor:

```
const QuestionBankCard({
  Key? key,
  required Question question,
  bool isSelected = false,
  bool selectionMode = false,
  VoidCallback? onTap,
  ValueChanged<bool>? onSelectionChanged,
  VoidCallback? onEdit,
  VoidCallback? onDuplicate,
  VoidCallback? onDelete,
})
```

Parameters:

* **question** — The `Question` model to display.
* **isSelected** — Selection state (used for checkbox value and selected styling).
* **selectionMode** — Enables checkbox + selection tap behavior; hides actions menu.
* **onTap** — Called when the card is tapped in normal mode.
* **onSelectionChanged** — Called when selection toggles (checkbox change or tap in selection mode).
* **onEdit** — Action callback from the menu.
* **onDuplicate** — Action callback from the menu.
* **onDelete** — Action callback from the menu.

## API Reference

### Class: `QuestionBankCard extends StatelessWidget`

Public fields:

* `question : Question`
* `isSelected : bool`
* `selectionMode : bool`
* `onTap : VoidCallback?`
* `onSelectionChanged : ValueChanged<bool>?`
* `onEdit : VoidCallback?`
* `onDuplicate : VoidCallback?`
* `onDelete : VoidCallback?`

### Behavior

#### Tap handling (`_handleTap`)

* If `selectionMode == true`: calls `onSelectionChanged(!isSelected)`
* Else: calls `onTap()`

#### Actions menu

* Only shown when `selectionMode == false`
* Uses `PopupMenuButton<String>` with values: `edit`, `duplicate`, `delete`
* Selection routed to `_handleAction(String action)`

#### Type icon mapping (`_getIconForType`)

Maps `question.responseType` to an `IconData`:

* `number` → `Icons.numbers`
* `yesno` → `Icons.toggle_on`
* `openended` → `Icons.text_fields`
* `single_choice` → `Icons.radio_button_checked`
* `multi_choice` → `Icons.check_box`
* `scale` → `Icons.linear_scale`
* default → `Icons.help_outline`

## Error Handling

* No explicit error handling; this is a UI component.
* Assumes `question.questionContent` and `question.responseType` are non-null and valid.
* **Important behavior note:** `_handleAction` uses a `switch` without `break`/`return`, which causes fall-through:

  * Selecting `edit` will also call `onDuplicate` and `onDelete`
  * Selecting `duplicate` will also call `onDelete`
  * Selecting `delete` calls only `onDelete`
    If this is unintended, add `break;` or `return;` statements in each case.

## Usage Examples

### Normal mode (view/edit + actions menu)

```
QuestionBankCard(
  question: question,
  onTap: () => openQuestion(question),
  onEdit: () => openEditDialog(question),
  onDuplicate: () => duplicateQuestion(question),
  onDelete: () => confirmDelete(question),
)
```

### Selection mode (multi-select)

```
QuestionBankCard(
  question: question,
  selectionMode: true,
  isSelected: selectedIds.contains(question.questionId),
  onSelectionChanged: (selected) {
    // update selection state in parent/provider
  },
)
```

## Related Files

* `frontend/lib/features/question_bank/state/question_providers.dart` — Provides `responseTypeLabels` used for the response type tag.
* `frontend/src/core/api/api.dart` — Defines the `Question` model.
* `frontend/src/core/theme/theme.dart` — `AppTheme` styles/colors used throughout the card.
* `frontend/src/core/l10n/l10n.dart` — Localized strings for tags and menu labels.
