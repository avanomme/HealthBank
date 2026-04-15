# survey_providers.dart

## Overview
This file defines Riverpod providers and state models for:
- The **Survey list page** (fetching surveys + local filtering).
- The **Survey builder** (create/edit survey state, question selection/reordering).
- **Auto-save** behavior for the survey builder with debounced background saves.

File: `frontend/lib/features/surveys/state/survey_providers.dart`

## Architecture / Design

### Provider graph
- `apiClientProvider` (from question bank) → `surveyApiProvider` → data providers:
  - `surveysProvider`
  - `surveyByIdProvider`

### UI feature mapping
- **SurveyListPage**
  - Uses `surveysProvider` for list data.
  - Uses `surveyFiltersProvider` for publication-status + search filtering.
- **SurveyBuilderPage**
  - Uses `surveyBuilderProvider` (notifier + state).
  - Auto-saves changes (debounced) via internal timer.
  - Supports loading an existing survey or loading questions from a template.
  - Saves as draft and optionally publishes.

### External dependencies
- `frontend/src/core/api/api.dart`
  - `SurveyApi`, `Survey`, `SurveyCreate`, `SurveyUpdate`, `PublicationStatus`
  - `Question`, `QuestionInSurvey`, `QuestionOptionResponse`, etc.
- `apiClientProvider` from `question_providers.dart` (shared ApiClient singleton).
- `templateApiProvider` from templates feature (for “Use Template” flow).

## Public API (Riverpod)

### surveyApiProvider
Provider for `SurveyApi` built from the shared API client.
- Type: `Provider<SurveyApi>`

### surveyFiltersProvider
Filter state for survey list UI.
- Type: `StateNotifierProvider<SurveyFiltersNotifier, SurveyFilters>`

### surveysProvider
Fetches surveys from the backend, applying:
- server-side filter: `publicationStatus`
- client-side filter: `searchQuery` (title/description substring match)
- Type: `FutureProvider<List<Survey>>`

### surveyByIdProvider
Fetches a single survey by ID.
- Type: `FutureProvider.family<Survey, int>`

### surveyBuilderProvider
State + actions for building/editing surveys.
- Type: `StateNotifierProvider<SurveyBuilderNotifier, SurveyBuilderState>`

## Models

### AutoSaveStatus (enum)
Represents the survey builder’s auto-save indicator state:
- `idle` — no pending changes
- `pending` — changes detected, waiting for debounce
- `saving` — in-flight auto-save request
- `saved` — last auto-save succeeded (briefly shown)
- `error` — last auto-save failed

### SurveyFilters
Filter state used by the survey list.
Fields:
- `publicationStatus : String?`
- `searchQuery : String` (default `''`)

Key methods:
- `copyWith({publicationStatus, searchQuery})`
- `clearFilter(filterName)` — supports:
  - `'publicationStatus'`
  - `'searchQuery'`
- `clearAll()`

### SurveyQuestionItem
Local representation of a question in the builder.
Fields:
- `questionId : int`
- `title : String?`
- `questionContent : String`
- `responseType : String`
- `isRequired : bool`
- `category : String?`
- `options : List<QuestionOptionResponse>?`

Factories:
- `fromQuestion(Question)`
- `fromQuestionInSurvey(QuestionInSurvey)` (maps options into `QuestionOptionResponse`)

### SurveyBuilderState
State backing the survey builder UI.
Fields:
- `title : String`
- `description : String`
- `startDate : DateTime?`
- `endDate : DateTime?`
- `questions : List<SurveyQuestionItem>`
- `isLoading : bool`
- `errorMessage : String?`
- `surveyId : int?` (null when creating)
- `autoSaveStatus : AutoSaveStatus`
- `lastSavedAt : DateTime?`

Computed helpers:
- `isValid` — title is non-empty
- `isEditMode` — surveyId != null
- `hasQuestions` — questions non-empty

## Notifiers / Behavior

## SurveyFiltersNotifier
Controls `SurveyFilters`.
Methods:
- `setPublicationStatus(String? status)`
- `setSearchQuery(String query)`
- `clearFilter(String filterName)`
- `clearAll()`

## SurveyBuilderNotifier
Controls `SurveyBuilderState` and all survey builder operations.

### Auto-save (debounced)
- Internal timer `_autoSaveTimer` with `_autoSaveDelay = 2s`.
- Triggered by:
  - `setTitle`, `setDescription`, `setStartDate`, `setEndDate`
  - `addQuestions`, `removeQuestion`, `reorderQuestions`
- Rules:
  - If title is empty (`!state.isValid`), auto-save is not scheduled and status becomes `idle`.
  - On scheduled save:
    - state → `pending` immediately
    - after debounce: `_performAutoSave()` sets state → `saving`
  - On success:
    - updates `surveyId` (important when the first auto-save creates a new survey)
    - sets status → `saved`, `lastSavedAt = now`
    - invalidates `surveysProvider` to refresh the list page
    - after 3s, status resets to `idle` (if still `saved`)
  - On failure:
    - sets status → `error` (silent; no errorMessage is set here)

### Lifecycle
- `dispose()` cancels the auto-save timer.

### Reset / Load
- `reset()` clears state and cancels pending auto-save.
- `loadSurvey(int surveyId)`
  - Sets `isLoading`
  - Fetches `api.getSurvey(surveyId)`
  - Populates builder state including `questions` from `survey.questions`
  - On error sets `errorMessage`

### Load from template
- `loadFromTemplate(int templateId)`
  - Fetches template via `templateApiProvider`
  - Populates a **new** builder state:
    - `surveyId` remains null (still a new survey)
    - title/description from template
    - questions mapped from template questions
  - On error sets `errorMessage`

### Editing state setters (all schedule auto-save)
- `setTitle(String)`
- `setDescription(String)`
- `setStartDate(DateTime?)`
- `setEndDate(DateTime?)`

### Question management (all schedule auto-save)
- `addQuestions(List<Question>)`
  - Converts to `SurveyQuestionItem`
  - Dedupes by `questionId`
- `removeQuestion(int questionId)`
- `reorderQuestions(int oldIndex, int newIndex)`
  - Uses standard ReorderableListView index semantics (`if (newIndex > oldIndex) newIndex--;`)

### Manual save / publish
#### saveDraft()
Creates or updates the survey with `PublicationStatus.draft` when creating.
- Validates title required; if missing, sets `errorMessage` and returns null.
- Sets `isLoading`.
- Calls:
  - `updateSurvey(id, SurveyUpdate(...))` if edit mode
  - `createSurvey(SurveyCreate(... publicationStatus: draft ...))` if new
- Updates state with `surveyId` (when created), clears loading.
- Invalidates `surveysProvider`.
- Returns the saved `Survey` or null on failure (sets `errorMessage`).

#### saveAndPublish()
- Calls `saveDraft()` first (ensures survey exists + up to date)
- Then calls `api.publishSurvey(saved.surveyId)`
- Invalidates `surveysProvider`
- Returns the published `Survey` (or whatever your API method returns), null on failure (sets `errorMessage`)

### Error management
- `clearError()` sets `errorMessage` to null.

## Error Handling Notes
- Auto-save failures only change `autoSaveStatus` to `error`; they do not populate `errorMessage`.
  - The UI is expected to show an auto-save indicator and optionally allow manual retry via `saveDraft()`.
- Manual save/publish paths set `errorMessage` with a descriptive string.

## Usage Examples

### Survey list (filters + list)
- Watch `surveysProvider` in the list page.
- Update filters by calling `surveyFiltersProvider.notifier.setSearchQuery(...)`
  and `setPublicationStatus(...)`.
- Refresh by `ref.invalidate(surveysProvider)`.

### Survey builder
- Watch `surveyBuilderProvider` for `SurveyBuilderState`.
- Mutate via `surveyBuilderProvider.notifier`:
  - `loadSurvey(id)` for edit
  - `reset()` for new
  - `loadFromTemplate(templateId)` for “Use Template”
  - `addQuestions([...])`, `reorderQuestions(...)`, etc.
- Manual actions:
  - `saveDraft()`
  - `saveAndPublish()`

## Related Files
- `frontend/lib/src/features/surveys/pages/survey_list_page.dart` — consumes `surveysProvider` and `surveyFiltersProvider`.
- `frontend/lib/src/features/surveys/pages/survey_builder_page.dart` — consumes `surveyBuilderProvider`.
- `frontend/lib/features/question_bank/state/question_providers.dart` — defines `apiClientProvider`.
- `frontend/lib/src/features/templates/state/template_providers.dart` — defines `templateApiProvider` used by `loadFromTemplate`.
- `frontend/src/core/api/api.dart` — core API models/services used throughout.