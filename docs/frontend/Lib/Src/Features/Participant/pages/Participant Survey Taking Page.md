# Participant Survey Taking Page Documentation

**File:** `frontend/lib/src/features/participant/pages/participant_survey_taking_page.dart`

## Overview

`ParticipantSurveyTakingPage` is a Flutter (Riverpod) page that handles participant survey completion on a dedicated route instead of a modal workflow.

It provides:

- A route-scoped survey-taking experience at `/participant/surveys/:surveyId`.
- Server-backed draft loading and best-effort draft saving.
- Required-question validation with inline field errors and a top-level toast.
- Submission confirmation before sending responses.
- Mapped submission error handling for common backend failure cases.
- A participant layout shell through `ParticipantScaffold`.

This page is built as a `ConsumerStatefulWidget` because it combines provider-backed data with local mutable UI state such as current responses, validation errors, submission status, and auto-save lifecycle handling.

## Architecture / Design Explanation

### Widget Structure

- **`ParticipantSurveyTakingPage`**
  - Requires a `surveyId` to identify the assigned survey to load.
  - Creates `_ParticipantSurveyTakingPageState`.

- **`_ParticipantSurveyTakingPageState`**
  - Wraps the page with `ParticipantSurveyBeforeUnload` to trigger a best-effort draft save on browser unload.
  - Wraps content in `PopScope` to save drafts when navigating back.
  - Uses `ParticipantScaffold` with:
    - `currentRoute: '/participant/surveys'`
    - `showFooter: true`
  - Renders one of three main states from `participantSurveyQuestionsProvider(surveyId)`:
    - Loaded content via `_buildLoadedState(...)`
    - Loading state via `_buildLoadingState(...)`
    - Error state via `_buildErrorState(...)`

### State Management

- **Riverpod Providers**
  - `participantSurveysProvider`
    - Supplies the survey list so the page can derive assignment metadata such as due date, status, and `hasDraft`.
  - `participantSurveyQuestionsProvider(widget.surveyId)`
    - Loads survey title and question definitions for the active survey.
  - `participantApiProvider`
    - Provides API access for draft retrieval, draft saving, and final submission.

- **Local Stateful UI**
  - `_responses` (`Map<int, String>`)
    - Stores current answers keyed by `questionId`.
  - `_validationErrors` (`Map<int, String>`)
    - Stores per-question validation messages for required fields.
  - `_autoSaveTimer` (`Timer?`)
    - Runs periodic draft persistence every 2 minutes.
  - `_isSubmitting`
    - Disables repeat submission and changes the submit button label.
  - `_isSubmitted`
    - Prevents additional draft saves after successful submission.
  - `_isSavingDraft`
    - Prevents overlapping draft-save requests.
  - `_draftLoaded`
    - Tracks whether the initial draft fetch has completed.
  - `_submitError`
    - Stores the latest submission error message for inline display.

### Draft Save and Resume Flow

Draft persistence is server-backed and intentionally best-effort so survey taking is not blocked by transient save failures.

- Draft load:
  - `getDraft(widget.surveyId)` is called in `initState()`.
  - Returned draft entries are copied into `_responses`.
  - If loading fails, the page still marks `_draftLoaded = true` so the UI can continue.

- Draft save:
  - Triggered on a 2-minute interval via `_autoSaveTimer`.
  - Triggered during `dispose()`.
  - Triggered on lifecycle transitions to `inactive`, `hidden`, or `paused`.
  - Triggered on browser unload through `ParticipantSurveyBeforeUnload`.
  - Triggered on route pop and on explicit back navigation.

- Save payload format:
  - `question_responses`
    - `question_id`
    - `response_value`

- After a successful draft save:
  - `participantSurveysProvider` is invalidated so the survey list can refresh `hasDraft` state.

### Validation and Submission

- `_validate(...)`
  - Iterates all survey questions.
  - Applies required-field validation only to questions where `isRequired == true`.
  - Stores localized field errors in `_validationErrors`.

- `_submit(...)`
  - Blocks submission if validation fails and shows `AppToast.showError(...)`.
  - Uses `AppConfirmDialog.show(...)` to require explicit confirmation before submission.
  - Calls `submitSurvey(...)` with the current response payload.
  - On success:
    - Sets `_isSubmitted = true`
    - Invalidates `participantSurveysProvider`
    - Invalidates `participantSurveyQuestionsProvider(widget.surveyId)`
    - Shows a success toast
    - Navigates back to `/participant/surveys`

### Layout and Rendering

- Page content is centered inside a `ConstrainedBox(maxWidth: 770)`.
- `_buildTopBar(...)` renders:
  - A back button that saves the draft and navigates to `/participant/surveys`
  - A localized survey-taking page title
- `_buildTitleCard(...)` renders survey metadata:
  - Survey title
  - Question count chip
  - Due-date chip when available
  - Incomplete/draft chip when `_draftLoaded` is true and a draft exists
- `_buildLoadedState(...)` renders:
  - `AppEmptyState` when the survey has no questions
  - Otherwise, a `Card` containing `ParticipantSurveyQuestionField` widgets for each question
- `_buildSubmitArea(...)` renders:
  - An inline submit error banner when `_submitError` is present
  - A primary submit button using `AppFilledButton`

## Configuration

No direct configuration is defined in this file.

This page relies on:

- Localization via `context.l10n`
- Theme primitives via `AppTheme`
- Routing via `go_router`
- Participant API methods exposed by `participantApiProvider`
- Survey/question data exposed by participant Riverpod providers

## API Reference

This section documents the public and internal methods in this page file and how they behave.

### `ParticipantSurveyTakingPage`

#### Constructor

- `ParticipantSurveyTakingPage({Key? key, required int surveyId})`

**Parameters**
- `key` (`Key?`): Flutter widget key.
- `surveyId` (`int`): Identifier of the survey assignment to open.

**Returns**
- A `ParticipantSurveyTakingPage` widget.

### `_ParticipantSurveyTakingPageState`

#### Fields

- `_autoSaveInterval` (`Duration`)
  - Constant interval of 2 minutes for periodic draft saving.
- `_responses` (`Map<int, String>`)
  - Current survey answers keyed by question id.
- `_validationErrors` (`Map<int, String>`)
  - Current inline validation errors keyed by question id.
- `_autoSaveTimer` (`Timer?`)
  - Periodic timer used for background draft saves.
- `_isSubmitting` (`bool`)
  - Tracks active survey submission.
- `_isSubmitted` (`bool`)
  - Prevents post-submit draft saves.
- `_isSavingDraft` (`bool`)
  - Guards against concurrent draft save requests.
- `_draftLoaded` (`bool`)
  - Indicates whether initial draft retrieval has finished.
- `_submitError` (`String?`)
  - Localized inline submission error, if any.

#### Methods

##### `initState() -> void`

Initializes lifecycle observation, starts draft loading, and starts the periodic auto-save timer.

##### `dispose() -> void`

Removes lifecycle observation, cancels the timer, and triggers a final best-effort draft save.

##### `didChangeAppLifecycleState(AppLifecycleState state) -> void`

Saves a draft when the app becomes inactive, hidden, or paused.

##### `_loadDraft() -> Future<void>`

Loads a saved draft from the participant API and copies values into `_responses`.

**Failure Behavior**
- If loading fails, the page still marks draft loading complete and continues without blocking the survey UI.

##### `_saveDraft() -> Future<void>`

Persists current responses to the draft endpoint unless the survey is already submitted or a save is already in progress.

**Side Effects**
- Calls `participantApiProvider.saveDraft(...)`
- Invalidates `participantSurveysProvider` after a successful save

**Failure Behavior**
- Exceptions are intentionally swallowed to keep draft saving best-effort.

##### `_validate(List<ParticipantSurveyQuestion> questions, AppLocalizations l10n) -> bool`

Validates required questions and updates `_validationErrors`.

**Parameters**
- `questions` (`List<ParticipantSurveyQuestion>`): Survey questions to validate.
- `l10n` (`AppLocalizations`): Localization access for error strings.

**Returns**
- `true` if validation passes; otherwise `false`.

##### `_submit(List<ParticipantSurveyQuestion> questions, AppLocalizations l10n) -> Future<void>`

Performs validation, asks for confirmation, submits the survey, and handles success/error outcomes.

**Parameters**
- `questions` (`List<ParticipantSurveyQuestion>`): Survey questions being submitted.
- `l10n` (`AppLocalizations`): Localization access for labels and messages.

**Success Behavior**
- Marks the survey submitted
- Invalidates relevant providers
- Shows success toast
- Navigates to `/participant/surveys`

##### `_updateResponse(int questionId, String value) -> void`

Updates a question response and clears any existing validation error for that question.

##### `_formatDate(DateTime date) -> String`

Formats a date as `YYYY-MM-DD` for due date and completion display.

##### `build(BuildContext context) -> Widget`

Builds the unload wrapper, navigation pop handler, scaffold, and current async page state.

**Provider Reads**
- `participantSurveysProvider`
- `participantSurveyQuestionsProvider(widget.surveyId)`

##### `_buildLoadedState(BuildContext context, { required ParticipantSurveyQuestionsResponse survey, required ParticipantSurveyListItem? surveyListItem, required AppLocalizations l10n }) -> Widget`

Builds the main survey-taking UI once questions have loaded.

##### `_buildTopBar(AppLocalizations l10n) -> Widget`

Builds the back-navigation row and page title.

##### `_buildTitleCard({ required String title, required DateTime? dueDate, required int questionCount, required bool hasDraft, required AppLocalizations l10n }) -> Widget`

Builds the read-only survey metadata card shown above the question list.

##### `_buildSubmitArea({ required AppLocalizations l10n, required List<ParticipantSurveyQuestion> questions }) -> Widget`

Builds the inline error banner and submit action area.

##### `_buildLoadingState(AppLocalizations l10n) -> Widget`

Builds the loading indicator shown while survey questions are being fetched.

##### `_buildErrorState(AppLocalizations l10n, ParticipantSurveyListItem? surveyListItem) -> Widget`

Builds the error/closed/expired empty state and a retry action.

### `_MetaChip`

Small internal stateless widget used by `_buildTitleCard(...)` to render metadata pills with an icon and label.

## Error Handling

### Draft Loading and Saving

- `_loadDraft()`:
  - Any exception results in a silent fallback to an empty survey state.
- `_saveDraft()`:
  - Any exception is swallowed intentionally so save problems do not interrupt survey completion.

### Validation Errors

- Required-field validation is surfaced in two places:
  - Inline field messages through `_validationErrors`
  - A top-level error toast using `l10n.surveyTakingValidationError`

### Submission Errors

- `DioException` responses are mapped to localized messages based on status code and backend error detail:
  - `400` with "already" -> already submitted
  - `400` with "expir" -> expired
  - `400` with "publish" -> not published
  - `403` -> not assigned
  - `404` -> not found
  - `5xx` -> server error
  - Other cases -> generic submission error
- Non-Dio failures fall back to `l10n.surveyTakingNetworkError`.
- The resolved message is displayed inline in `_buildSubmitArea(...)`.

### Survey Load Errors

- If question loading fails, `_buildErrorState(...)` derives the most specific empty state it can:
  - Expired survey
  - Closed survey
  - General network/load failure
- A retry button invalidates `participantSurveyQuestionsProvider(widget.surveyId)`.

## Usage Examples

### Routing to the Survey-Taking Page

In `go_router`, this page should be registered with a parameterized participant survey route:

- Route path: `/participant/surveys/:surveyId`
- Builder: `(_) => ParticipantSurveyTakingPage(surveyId: parsedSurveyId)`

### Navigation to the Surveys List

The page returns to the participant surveys list after:

- Tapping the back button in `_buildTopBar(...)`
- Successful survey submission

Both flows navigate to:

- `context.go('/participant/surveys')`

## Related Files

- `frontend/lib/src/features/participant/pages/participant_surveys_page.dart`
  - Survey list page that links into this route.
- `frontend/lib/src/features/participant/state/participant_providers.dart`
  - Defines `participantApiProvider`, `participantSurveysProvider`, and `participantSurveyQuestionsProvider(...)`.
- `frontend/lib/src/features/participant/widgets/participant_scaffold.dart`
  - Shared participant page shell.
- `frontend/lib/src/features/participant/widgets/participant_survey_before_unload.dart`
  - Handles browser unload hooks for best-effort draft saving.
- `frontend/lib/src/features/participant/widgets/participant_survey_question_fields.dart`
  - Renders participant-facing input widgets for individual survey questions.
- `frontend/lib/src/core/widgets/feedback/feedback.dart`
  - Provides `AppToast`, `AppEmptyState`, and `AppLoadingIndicator`.
- `frontend/lib/src/core/widgets/buttons/buttons.dart`
  - Provides `AppFilledButton` and `AppOutlinedButton`.
- `frontend/lib/src/core/api/api.dart`
  - Exposes participant survey draft and submission API methods.
