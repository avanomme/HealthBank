# Participant Surveys Page Documentation

**File:** `frontend/lib/src/features/participant/pages/participant_surveys_page.dart`

## Overview

`ParticipantSurveysPage` is a Flutter (Riverpod) page that displays the participant’s assigned surveys and routes active work to the dedicated survey-taking page.

It provides:

- A participant-scoped surveys list at `/participant/surveys`.
- Async loading of assigned surveys through `participantSurveysProvider`.
- Status rendering for pending, incomplete, completed, and expired survey assignments.
- Start/resume actions for pending surveys.
- Inline empty, loading, and error states.

This page is implemented as a `ConsumerWidget` because it only needs reactive provider state and does not maintain local mutable UI state.

## Architecture / Design Explanation

### Widget Structure

- **`ParticipantSurveysPage`**
  - Wraps content in `ParticipantScaffold` with:
    - `currentRoute: '/participant/surveys'`
    - `showFooter: true`
  - Displays:
    - Page heading (`l10n.navSurveys`)
    - Subtitle/helper text
    - Async survey content from `participantSurveysProvider`

- **Async states in `build(...)`**
  - `data`: renders `_buildSurveyList(...)`
  - `loading`: renders `AppLoadingIndicator`
  - `error`: renders `AppEmptyState.error(...)` with a retry action

- **`_SurveyCard`**
  - Internal stateless widget used to render each survey assignment.
  - Handles status derivation, status styling, due-date display, and action rendering.

### State Management

- **Riverpod Providers**
  - `participantSurveysProvider`
    - Supplies the full list of assigned surveys shown on the page.

- **Stateless Rendering**
  - The page itself holds no local state.
  - All displayed state is derived from the provider payload and localization/theme dependencies.

### Survey List Behavior

- `_buildSurveyList(...)`
  - Returns `AppEmptyState` when there are no assigned surveys.
  - Otherwise renders a non-scrollable `ListView.builder` so the list can live inside the page scaffold’s scroll context.

- Each `_SurveyCard` displays:
  - Survey title
  - Current status badge
  - Due date when available
  - A primary CTA for pending surveys
  - A completed-state summary row for completed surveys

### Status Derivation Logic

The page derives display status using `_statusKey(...)`:

- If `assignmentStatus == 'pending'` and `hasDraft == true`
  - Display status becomes `incomplete`
- Otherwise
  - Display status remains the backend-provided `assignmentStatus`

This allows the UI to show resumed work without introducing a new stored assignment status.

### Navigation

Pending surveys route to the dedicated survey-taking page through:

- `context.go(AppRoutes.participantSurveyPath(survey.surveyId))`

Button labeling depends on draft state:

- `participantStartSurvey` when no draft exists
- `participantResumeSurvey` when `hasDraft == true`

## Configuration

No direct configuration is defined in this file.

This page relies on:

- Localization via `context.l10n`
- Theme primitives via `AppTheme`
- Routing helpers via `AppRoutes`
- Navigation via `go_router`
- Survey list data from `participantSurveysProvider`

## API Reference

This section documents the public and internal methods in this page file and how they behave.

### `ParticipantSurveysPage`

#### Constructor

- `ParticipantSurveysPage({Key? key})`

**Parameters**
- `key` (`Key?`): Flutter widget key.

**Returns**
- A `ParticipantSurveysPage` widget.

#### Methods

##### `build(BuildContext context, WidgetRef ref) -> Widget`

Builds the participant scaffold, static page header, and async survey content.

**Parameters**
- `context` (`BuildContext`): Flutter build context.
- `ref` (`WidgetRef`): Riverpod widget reference.

**Returns**
- `Widget`: A `ParticipantScaffold` containing the surveys page UI.

**Provider Reads**
- `participantSurveysProvider`

##### `_buildSurveyList(BuildContext context, List<ParticipantSurveyListItem> surveys, AppLocalizations l10n) -> Widget`

Builds the survey list area for the loaded data state.

**Parameters**
- `context` (`BuildContext`)
- `surveys` (`List<ParticipantSurveyListItem>`)
- `l10n` (`AppLocalizations`)

**Returns**
- `Widget`: Either `AppEmptyState` or a `ListView.builder` of `_SurveyCard` widgets.

### `_SurveyCard`

Internal stateless widget used to render a single survey entry.

#### Constructor

- `_SurveyCard({required ParticipantSurveyListItem survey})`

**Parameters**
- `survey` (`ParticipantSurveyListItem`): Survey assignment to display.

#### Methods

##### `_formatDate(DateTime date) -> String`

Formats a date as `YYYY-MM-DD`.

##### `_statusKey(ParticipantSurveyListItem survey) -> String`

Derives the UI status key from the backend assignment status and `hasDraft`.

##### `_statusColor(String status) -> Color`

Maps status keys to badge colors:

- `incomplete` -> `AppTheme.caution`
- `pending` -> `AppTheme.caution`
- `completed` -> `AppTheme.success`
- `expired` -> `AppTheme.error`
- fallback -> `AppTheme.textMuted`

##### `_statusLabel(String status, AppLocalizations l10n) -> String`

Maps status keys to localized display labels.

##### `build(BuildContext context) -> Widget`

Builds the survey card, including title, badge, metadata, and action/content based on status.

**Behavior**
- Pending surveys render a full-width `AppFilledButton` that navigates to the survey-taking route.
- Completed surveys render a non-interactive completion summary row.
- Expired surveys show status only and no action button.

## Error Handling

### Survey List Loading

- If `participantSurveysProvider` fails, the page renders `AppEmptyState.error(...)`.
- The retry button calls:
  - `ref.invalidate(participantSurveysProvider)`

### Empty Data

- If the provider succeeds but returns an empty list, `_buildSurveyList(...)` renders `AppEmptyState` with the participant no-surveys messaging.

### Status Fallback

- If an unknown status value is returned:
  - `_statusColor(...)` falls back to `AppTheme.textMuted`
  - `_statusLabel(...)` falls back to the raw status string

## Usage Examples

### Routing to the Surveys Page

In `go_router`, this page would typically be registered as:

- Route path: `/participant/surveys`
- Builder: `(_) => const ParticipantSurveysPage()`

### Starting or Resuming a Survey

For pending assignments, `_SurveyCard.build(...)` navigates to:

- `AppRoutes.participantSurveyPath(survey.surveyId)`

This should resolve to the dedicated survey-taking route:

- `/participant/surveys/:surveyId`

## Related Files

- `frontend/lib/src/features/participant/pages/participant_survey_taking_page.dart`
  - Dedicated route for completing or resuming a survey.
- `frontend/lib/src/features/participant/state/participant_providers.dart`
  - Defines `participantSurveysProvider`.
- `frontend/lib/src/features/participant/widgets/participant_scaffold.dart`
  - Shared participant layout shell.
- `frontend/lib/src/config/go_router.dart`
  - Defines `AppRoutes.participantSurveyPath(...)` and route registration.
- `frontend/lib/src/core/api/models/participant.dart`
  - Defines `ParticipantSurveyListItem`, including fields such as `surveyId`, `title`, `assignmentStatus`, `dueDate`, `completedAt`, and `hasDraft`.
- `frontend/lib/src/core/widgets/feedback/feedback.dart`
  - Provides `AppEmptyState` and `AppLoadingIndicator`.
- `frontend/lib/src/core/widgets/buttons/buttons.dart`
  - Provides `AppFilledButton` and `AppOutlinedButton`.
