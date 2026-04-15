# QuestionBankPage

## Overview

`QuestionBankPage` is a researcher-facing page for browsing the question bank. It displays a searchable, filterable list of questions loaded from the API via Riverpod providers. The page supports two modes:

* **Browse/Edit mode (default):** Uses `ResearcherScaffold` and provides a FAB to create new questions. Tapping a question opens it in the form dialog for editing.
* **Selection mode:** Uses a plain `Scaffold` with a back button and a confirm action to return selected questions (used when adding questions to surveys).

File: `frontend/lib/src/features/question_bank/pages/question_bank_page.dart`

## Architecture / Design

* **State management:** `ConsumerStatefulWidget` + Riverpod providers:

  * `questionsProvider` for the question list (`AsyncValue<List<Question>>`)
  * `questionFiltersProvider` for search/filter state (`QuestionFilters`)
  * `questionCategoriesProvider` for category dropdown values (API-driven)
  * `selectionModeProvider` to control selection behavior
  * `selectedQuestionIdsProvider` to track selected question IDs (`Set<int>`)
  * `questionApiProvider` for create/delete calls
* **Search/filter UI:** A top container with:

  * Search `TextField` bound to `_searchController` -> updates `questionFiltersProvider`
  * Response type dropdown (static list from `responseTypes` / `responseTypeLabels`)
  * Category dropdown populated from `questionCategoriesProvider`
* **List UI:** `RefreshIndicator` + `ListView.builder`, rendering `QuestionBankCard` per question.
* **Dialogs:** `QuestionBankFormDialog.show(...)` used to create/edit questions and (in browse mode) also when tapping a card.
* **Selection flow:** In selection mode, user selects items and confirms; the page maps selected IDs to `Question` objects and calls `onQuestionsSelected`.

## Configuration

Constructor:

```
const QuestionBankPage({
  Key? key,
  bool selectionMode = false,
  void Function(List<Question>)? onQuestionsSelected,
})
```

Parameters:

* **selectionMode** — When `true`, the page presents a selection UI and confirm action instead of the full researcher scaffold + FAB.
* **onQuestionsSelected** — Callback invoked in selection mode when the user confirms; receives the list of selected `Question` objects.

## API Reference

### Class: `QuestionBankPage extends ConsumerStatefulWidget`

Public fields:

* `selectionMode : bool`
* `onQuestionsSelected : void Function(List<Question>)?`

### State: `_QuestionBankPageState extends ConsumerState<QuestionBankPage>`

Key responsibilities and methods:

* `initState()`

  * After first frame, writes `widget.selectionMode` into `selectionModeProvider`.

* `dispose()`

  * Disposes `_searchController`.

* `_onSearchChanged(String query)`

  * `questionFiltersProvider.notifier.setSearchQuery(query)`

* `_onFilterChanged(String filterType, String? value)`

  * For `"responseType"` -> `setResponseType(value)`
  * For `"category"` -> `setCategory(value)`

* `_clearFilters()`

  * `questionFiltersProvider.notifier.clearAll()`
  * clears `_searchController`

* `_onConfirmSelection()`

  * Reads `selectedQuestionIdsProvider` and `questionsProvider`
  * When questions are available, filters the in-memory list by selected IDs and calls `widget.onQuestionsSelected`

* `_buildSearchAndFilters(QuestionFilters filters) -> Widget`

  * Renders search field and two filter dropdowns (response type + category).

* `_buildCategoryDropdown(BuildContext context, QuestionFilters filters) -> Widget`

  * Uses `questionCategoriesProvider` to build dropdown items.
  * Disabled dropdown variants are shown during loading/error.

* `_getCategoryLabel(BuildContext context, String categoryKey) -> String`

  * Maps known keys (`demographics`, `mental_health`, `physical_health`, `lifestyle`, `symptoms`) to localized labels.
  * Fallback: converts underscore-separated keys into Title Case.

* `_hasActiveFilters(QuestionFilters filters) -> bool`

  * True if any of: responseType, category, or non-empty search query.

* `_buildActiveFiltersChips(QuestionFilters filters) -> Widget`

  * Shows chips for active filters with delete actions and a “Clear all” button.

* `_buildQuestionsList(List<Question> questions, Set<int> selectedIds) -> Widget`

  * Empty state if no questions.
  * Otherwise: `RefreshIndicator` invalidating `questionsProvider`, with list of question cards.

* `_buildQuestionCard(Question question, bool isSelected) -> Widget`

  * Renders `QuestionBankCard` with:

    * `onTap`: opens `QuestionBankFormDialog` (edit)
    * `onSelectionChanged`: toggles ID in `selectedQuestionIdsProvider`
    * `onEdit`: opens form dialog
    * `onDuplicate`: creates new question via API
    * `onDelete`: opens delete confirm flow

* `_confirmDelete(Question question) -> Future<void>`

  * Shows an `AlertDialog`; on confirm calls `api.deleteQuestion(...)`, invalidates list, and displays snackbars.

* `_buildEmptyState() -> Widget`

  * If filters active: shows “no match” UI + Clear Filters
  * Else: shows “no questions yet” UI + Add Question button

* `_buildErrorState(Object error) -> Widget`

  * Displays error + retry button (invalidates `questionsProvider`)

## Error Handling

* **Loading/error states:** All API-backed `AsyncValue`s (`questionsProvider`, `questionCategoriesProvider`) render appropriate loading/error UI.
* **Duplicate failures:** `onDuplicate` is wrapped in `try/catch`:

  * Success: invalidates `questionsProvider` + snackbar
  * Failure: snackbar with localized failure message including error text
* **Delete failures:** `try/catch` around `deleteQuestion`:

  * Success: invalidates `questionsProvider` + snackbar
  * Failure: snackbar with error string
* **Division of responsibilities:** This page relies on providers/APIs for data integrity; UI guards include:

  * disable category dropdown on loading/error
  * avoid selection confirm action when no selected IDs

## Usage Examples

### Standard researcher browsing page

```
const QuestionBankPage()
```

### Selection mode (e.g., add questions to a survey)

```
QuestionBankPage(
  selectionMode: true,
  onQuestionsSelected: (questions) {
    // attach selected questions to survey builder state
  },
)
```

## Related Files

* `frontend/lib/src/features/question_bank/state/question_providers.dart` — Riverpod providers: questions, categories, filters, selection state, selected IDs, API provider.
* `frontend/lib/src/features/question_bank/widgets/question_bank_card.dart` — Renders each question row/card (supports selection + actions).
* `frontend/lib/src/features/question_bank/widgets/question_bank_form_dialog.dart` — Create/edit dialog used for viewing and editing questions.
* `frontend/lib/src/features/researcher/widgets/researcher_scaffold.dart` — Base scaffold used in non-selection mode.
* `frontend/src/core/api/api.dart` — `Question`, `QuestionCreate`, `QuestionOptionCreate`, API interfaces used for create/delete.
* `frontend/src/core/l10n/l10n.dart` — Localized strings for labels, placeholders, and snackbars.
* `frontend/src/core/theme/theme.dart` — `AppTheme` colors and text styles.
