# question_providers.dart

## Overview

This file defines the Riverpod providers and state notifiers used by the Question Bank feature. It centralizes:

* API wiring for `ApiClient` and `QuestionApi`
* Filter state (`QuestionFilters`) and a notifier to mutate it
* Data-fetching providers for question lists, single-question lookup, and categories
* Selection state for multi-select workflows (adding questions to surveys)
* Constants for supported response types and their human-readable labels

File: `frontend/lib/features/question_bank/state/question_providers.dart`

## Architecture / Design

* **API layer providers**

  * `apiClientProvider` creates an `ApiClient` singleton instance for consumers.
  * `questionApiProvider` builds a `QuestionApi` using the `ApiClient`’s Dio instance.
* **Filter state**

  * `QuestionFilters` is an immutable value object holding `responseType`, `category`, and `searchQuery`.
  * `QuestionFiltersNotifier` (`StateNotifier<QuestionFilters>`) mutates filter state via small setters and clear helpers.
* **Query/data providers**

  * `questionsProvider` fetches questions from the backend using API-side filters (responseType/category/isActive) and then applies a local text search filter (`searchQuery`) across `title` and `questionContent`.
  * `questionByIdProvider` fetches a single question by ID.
  * `questionCategoriesProvider` fetches categories from the API.
* **Selection state**

  * `selectedQuestionIdsProvider` stores a `Set<int>` of selected question IDs.
  * `selectionModeProvider` is a simple `StateProvider<bool>` indicating whether selection UI should be active.
* **Constants**

  * `responseTypes` defines supported filter values.
  * `responseTypeLabels` provides display strings for those values.

## Configuration

No runtime configuration is required. Consumers typically interact with this module by:

* Watching providers (e.g., `ref.watch(questionsProvider)`)
* Writing state through notifiers (e.g., `ref.read(questionFiltersProvider.notifier).setSearchQuery(...)`)

## API Reference

### API providers

#### `apiClientProvider : Provider<ApiClient>`

Creates and exposes an `ApiClient` instance.

#### `questionApiProvider : Provider<QuestionApi>`

Builds a `QuestionApi` using the Dio client from `ApiClient`.

### Filter model

#### `class QuestionFilters`

Fields:

* `responseType : String?`
* `category : String?`
* `searchQuery : String` (default `''`)

Methods:

* `copyWith({String? responseType, String? category, String? searchQuery}) -> QuestionFilters`
* `clearFilter(String filterName) -> QuestionFilters`

  * Supported `filterName` values:

    * `"responseType"` sets `responseType` to `null`
    * `"category"` sets `category` to `null`
    * `"searchQuery"` sets `searchQuery` to `''`
  * Unknown names return `this`
* `clearAll() -> QuestionFilters`

  * Returns default `const QuestionFilters()` (all filters cleared)

### Filter state provider

#### `questionFiltersProvider : StateNotifierProvider<QuestionFiltersNotifier, QuestionFilters>`

Provides the current `QuestionFilters` state.

#### `class QuestionFiltersNotifier extends StateNotifier<QuestionFilters>`

Methods:

* `setResponseType(String? type)` — Updates `responseType`
* `setCategory(String? category)` — Updates `category`
* `setSearchQuery(String query)` — Updates `searchQuery`
* `clearFilter(String filterName)` — Clears one filter via `QuestionFilters.clearFilter`
* `clearAll()` — Clears all filters via `QuestionFilters.clearAll`

### Question data providers

#### `questionsProvider : FutureProvider<List<Question>>`

Behavior:

1. Calls `api.listQuestions(...)` with:

   * `responseType: filters.responseType`
   * `category: filters.category`
   * `isActive: true`
2. If `filters.searchQuery` is non-empty, performs a local case-insensitive match against:

   * `q.title` (nullable)
   * `q.questionContent` (non-null)
3. Returns the filtered list.

#### `questionByIdProvider : FutureProvider.family<Question, int>`

Fetches a single question by ID:

* `api.getQuestion(id)`

#### `questionCategoriesProvider : FutureProvider<List<QuestionCategory>>`

Fetches question categories:

* `api.listCategories()`

### Selection providers

#### `selectedQuestionIdsProvider : StateNotifierProvider<SelectedQuestionsNotifier, Set<int>>`

Holds selected question IDs.

#### `class SelectedQuestionsNotifier extends StateNotifier<Set<int>>`

Methods:

* `toggle(int questionId)` — Adds if missing, removes if present
* `select(int questionId)` — Ensures the ID is selected
* `deselect(int questionId)` — Ensures the ID is not selected
* `selectAll(List<int> questionIds)` — Adds all IDs
* `clear()` — Clears selection
* `isSelected(int questionId) -> bool` — Convenience check

#### `selectionModeProvider : StateProvider<bool>`

Tracks whether selection mode is active (default `false`).

### Constants

#### `responseTypes : List<String>`

Supported filter values:

* `number`, `yesno`, `openended`, `single_choice`, `multi_choice`, `scale`

#### `responseTypeLabels : Map<String, String>`

Human-readable labels for UI display.

## Error Handling

* Network/API errors thrown by `QuestionApi` calls (e.g., `listQuestions`, `getQuestion`, `listCategories`) are not caught here; they propagate to consumers as `AsyncValue.error`.
* Local search filtering assumes `questionContent` is non-null and will throw if it is unexpectedly null (based on API model expectations).

## Usage Examples

### Watch questions with current filters

```
final questionsAsync = ref.watch(questionsProvider);
```

### Update search query

```
ref.read(questionFiltersProvider.notifier).setSearchQuery('sleep');
```

### Set response type and category filters

```
final filters = ref.read(questionFiltersProvider.notifier);
filters.setResponseType('scale');
filters.setCategory('mental_health');
```

### Toggle a selected question ID

```
ref.read(selectedQuestionIdsProvider.notifier).toggle(questionId);
```

### Enable selection mode

```
ref.read(selectionModeProvider.notifier).state = true;
```

## Related Files

* `frontend/lib/src/features/question_bank/pages/question_bank_page.dart` — Consumes these providers to implement browse and selection workflows.
* `frontend/src/core/api/api.dart` — Defines `ApiClient`, `QuestionApi`, and the models (`Question`, `QuestionCategory`, etc.).
