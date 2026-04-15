# Participant Feature Documentation

This document consolidates documentation for the participant-facing pages and Riverpod providers shown in the provided Dart files/snippets.

---

## Contents

- [ParticipantDashboardPage](#participantdashboardpage)
- [ParticipantSurveysPage](#participantsurveyspage)
- [ParticipantTasksPage](#participanttaskspage)
- [Participant Dashboard Providers](#participant-dashboard-providers)
- [Participant Data Providers](#participant-data-providers)
- [Cross-Cutting Notes](#cross-cutting-notes)
- [Related Files](#related-files)

---

## ParticipantDashboardPage

**File:** `frontend/lib/src/features/participant/pages/participant_dashboard_page.dart`

### Overview

`ParticipantDashboardPage` is a participant home/dashboard page built with Flutter and Riverpod. It provides a personalized overview including:

- A welcome greeting derived from the participant profile.
- A notification/messages banner (currently backed by a placeholder count provider).
- Two placeholder graph cards intended for future analytics.
- A task progress bar and task list based on assignments.
- Navigation to the full tasks page.

### Architecture / Design Explanation

#### Widget Composition

- `ParticipantDashboardPage` is a `ConsumerStatefulWidget` to support:
  - Reactive provider reads (profile/assignments/notification count).
  - Local UI state for dropdown selection (`_selectedAssignmentId`).

- The page is wrapped in `ParticipantScaffold`:
  - Supplies route context (`currentRoute`)
  - Displays notification indicator (`hasNotifications`)
  - Emits notifications tap callback (`onNotificationsTap`)
  - Displays user name (`userName`)

#### Providers Used

- `participantProfileProvider` (`AsyncValue<ParticipantProfile>`)
- `participantAssignmentsProvider` (`AsyncValue<List<MyAssignment>>`)
- `participantNotificationCountProvider` (`int`, currently a stub)

#### Responsive Layout

- Uses `LayoutBuilder` and `Breakpoints` utilities:
  - `Breakpoints.responsivePadding(width)` controls spacing.
  - Content width is constrained to `min(width, Breakpoints.maxContent * 0.6)`.

- Graph placeholders are responsive:
  - Desktop: `Row` (side-by-side).
  - Narrow layouts: `Column` (stacked).

#### Task Section Logic

Assignments are transformed into UI signals:

- `totalTasks`: `assignments.length`
- `completedTasks`: count where `status == 'completed'`
- `progress`: `completedTasks / totalTasks` (0.0 if `totalTasks == 0`)
- `pendingTasks`: tasks where `status != 'completed'`
- `remainingToday`: pending tasks whose `dueDate` is today (date-only compare)

Dropdown task list is:
- `remainingToday` if non-empty, else `pendingTasks`

Task cards:
- Render all pending tasks sorted by `dueDate` ascending
- Null due dates are treated as far future (year 3000 sentinel) to sort last

#### Navigation

- “View all tasks” triggers:
  - `context.go('/participant/tasks')`

#### Planned/Stubbed Areas

- Notification navigation: `_handleNotificationTap` TODO
- Task/survey detail navigation: `_handleDoTask` TODO
- Graph data: TODO to replace placeholders with analytics endpoint results
- Survey title enrichment: TODO to use `SurveyApi` when `surveyTitle` is null
- Repeat schedule: TODO to use survey/assignment metadata once available

### Configuration

No explicit configuration in the page. It relies on:

- Localization: `context.l10n`
- Theme: `AppTheme`
- Breakpoints: `Breakpoints`
- Provider layer: participant dashboard providers

### API Reference

#### `ParticipantDashboardPage`

**Constructor**
- `ParticipantDashboardPage({Key? key})`

**Parameters**
- `key` (`Key?`)

**Returns**
- `ParticipantDashboardPage`

#### `_ParticipantDashboardPageState`

**State**
- `_selectedAssignmentId` (`int?`): dropdown selection

**Callbacks**
- `_handleNotificationTap() -> void`: placeholder
- `_handleDoTask(MyAssignment assignment) -> void`: placeholder
- `_handleViewAllTasks() -> void`: navigates to `/participant/tasks`

**Rendering**
- `build(BuildContext context) -> Widget`
- `_buildContent(...) -> Widget`
- `_buildWelcome(...) -> Widget`
- `_buildNotificationBanner(int count, ...) -> Widget`
- `_buildGraphs(...) -> Widget`
- `_buildTasksSection(...) -> Widget`

**Formatting Helpers**
- `_formatDueText(DateTime? dueDate, AppLocalizations l10n) -> String`
  - Today: localized “Due today at {time}”
  - Otherwise: localized “Due on {date}”
  - Null dueDate: placeholder
- `_formatRepeatText(MyAssignment _) -> String?`
  - Always `null` (placeholder)

### Error Handling

- Provider error states render localized generic error text via `AppText` with `AppTheme.error`.
- Provider loading states render localized loading text via `AppText` with muted styling.
- Null due dates and null survey titles are handled with placeholder strings.

### Usage Examples

- Route should exist for `/participant/dashboard` mapping to `ParticipantDashboardPage`.
- Ensure `/participant/tasks` exists since the dashboard navigates there via “View all tasks”.

---

## ParticipantSurveysPage

**File:** `frontend/lib/features/participant/pages/participant_surveys_page.dart`

### Overview

`ParticipantSurveysPage` is currently a placeholder participant surveys page. It wraps a centered placeholder message in `ParticipantScaffold`.

Intended features (per inline comment):

- List of available surveys
- Survey status (completed, in progress, new)
- Survey taking functionality

### Architecture / Design Explanation

- Implemented as `StatelessWidget` (no state/provider integration yet).
- Uses `ParticipantScaffold(currentRoute: '/participant/surveys')`.
- Renders placeholder `Text` centered.

### Configuration

None in this file.

### API Reference

#### `ParticipantSurveysPage`

**Constructor**
- `ParticipantSurveysPage({Key? key})`

**build**
- `build(BuildContext context) -> Widget`
  - Returns `ParticipantScaffold` with placeholder content.

### Error Handling

None (no async work).

### Usage Examples

- Register route `/participant/surveys` to `ParticipantSurveysPage`.

---

## ParticipantTasksPage

**File:** `frontend/lib/features/participant/pages/participant_tasks_page.dart`

### Overview

`ParticipantTasksPage` is currently a placeholder participant tasks page. It wraps a centered placeholder message in `ParticipantScaffold`.

Intended features (per inline comment):

- To-do list of pending surveys/tasks
- Task completion tracking
- Due date reminders

### Architecture / Design Explanation

- Implemented as `StatelessWidget` (no state/provider integration yet).
- Uses `ParticipantScaffold(currentRoute: '/participant/tasks')`.
- Renders placeholder `Text` centered.

### Configuration

None in this file.

### API Reference

#### `ParticipantTasksPage`

**Constructor**
- `ParticipantTasksPage({Key? key})`

**build**
- `build(BuildContext context) -> Widget`
  - Returns `ParticipantScaffold` with placeholder content.

### Error Handling

None (no async work).

### Usage Examples

- Register route `/participant/tasks` to `ParticipantTasksPage`.
- This route is referenced by the dashboard page.

---

## Participant Dashboard Providers

**File:** (snippet) “Riverpod providers for the participant dashboard data layer.”

### Overview

This provider module supports the participant dashboard page by exposing:

- API service providers for auth/assignment/user/survey APIs.
- A session provider.
- A profile provider that composes a lightweight `ParticipantProfile` with fallbacks.
- An assignments provider used to compute task progress and list.
- A placeholder notification count provider.

### Architecture / Design Explanation

#### Dependency Chain

- Root:
  - `apiClientProvider` (imported from `question_providers.dart`)

- API services:
  - `participantAuthApiProvider` → `AuthApi`
  - `participantAssignmentApiProvider` → `AssignmentApi`
  - `participantUserApiProvider` → `UserApi`
  - `participantSurveyApiProvider` → `SurveyApi` (optional for enrichment)

- Async data:
  - `participantSessionProvider` → `AuthApi.getSessionInfo()`
  - `participantProfileProvider` → composed profile with optional `UserApi.getUser(accountId)` fallback
  - `participantAssignmentsProvider` → `AssignmentApi.getMyAssignments()`

- Sync placeholder:
  - `participantNotificationCountProvider` returns `0`

#### `ParticipantProfile` Model

Fields:
- `accountId` (`int`)
- `email` (`String`)
- `firstName` (`String?`)
- `lastName` (`String?`)

Derived:
- `displayName` (`String`)
  - Joins non-empty trimmed first/last names when present
  - Falls back to email

#### Profile Fallback Behavior

- Reads session (`SessionMeResponse`).
- Uses `session.viewingAs` when present to determine the participant identity.
- If first/last name missing and `accountId > 0`, fetches user via `UserApi.getUser(accountId)`.

### Configuration

No config in this file; depends on:

- `apiClientProvider` supplying a valid configured client.
- Backend endpoints supporting:
  - Session info
  - User lookup
  - Assignments list

### API Reference

#### `participantAuthApiProvider`
- Type: `Provider<AuthApi>`
- Returns: `AuthApi(client.dio)`

#### `participantAssignmentApiProvider`
- Type: `Provider<AssignmentApi>`
- Returns: `AssignmentApi(client.dio)`

#### `participantUserApiProvider`
- Type: `Provider<UserApi>`
- Returns: `UserApi(client.dio)`

#### `participantSurveyApiProvider`
- Type: `Provider<SurveyApi>`
- Returns: `SurveyApi(client.dio)`
- Note: defined for future enrichment; may be unused currently.

#### `participantSessionProvider`
- Type: `FutureProvider<SessionMeResponse>`
- Calls: `AuthApi.getSessionInfo()`

#### `participantProfileProvider`
- Type: `FutureProvider<ParticipantProfile>`
- Depends on:
  - `participantSessionProvider`
  - `participantUserApiProvider` conditionally
- Returns: composed `ParticipantProfile`

#### `participantAssignmentsProvider`
- Type: `FutureProvider<List<MyAssignment>>`
- Calls: `AssignmentApi.getMyAssignments()`

#### `participantNotificationCountProvider`
- Type: `Provider<int>`
- Returns: `0` (placeholder)

### Error Handling

- Exceptions thrown by API calls are surfaced as `AsyncValue.error` to UI consumers.
- This module does not implement retries, mapping, or logging.

### Usage Examples

- Dashboard UI should `watch`:
  - `participantProfileProvider` for greeting/header name.
  - `participantAssignmentsProvider` for task list and progress.
  - `participantNotificationCountProvider` for notification badge/banner.

---

## Participant Data Providers

**File:** `frontend/lib/src/features/participant/state/participant_providers.dart`

### Overview

This provider module exposes participant survey and analytics data through `ParticipantApi`:

- Assigned surveys list
- Completed surveys with participant responses
- Participant-vs-aggregate comparison data by survey ID

Provider chain:
`apiClientProvider → participantApiProvider → participantSurveysProvider / participantSurveyDataProvider / participantCompareProvider`

### Architecture / Design Explanation

- `participantApiProvider` constructs `ParticipantApi` from shared `dio`.
- Data providers are `FutureProvider`s:
  - Load once per scope and cache per Riverpod semantics.
- `participantCompareProvider` uses `FutureProvider.family` keyed by `surveyId`, enabling independent caching per survey.

### Configuration

No explicit config here. Depends on:

- `apiClientProvider` and its `dio` configuration.
- Participant API endpoints:
  - `getSurveys()`
  - `getSurveyData()`
  - `compareSurvey(surveyId)`

### API Reference

#### `participantApiProvider`
- Type: `Provider<ParticipantApi>`
- Returns: `ParticipantApi(client.dio)`

#### `participantSurveysProvider`
- Type: `FutureProvider<List<ParticipantSurveyListItem>>`
- Calls: `ParticipantApi.getSurveys()`

#### `participantSurveyDataProvider`
- Type: `FutureProvider<List<ParticipantSurveyWithResponses>>`
- Calls: `ParticipantApi.getSurveyData()`

#### `participantCompareProvider`
- Type: `FutureProvider.family<ParticipantSurveyCompareResponse, int>`
- Parameter: `surveyId` (`int`)
- Calls: `ParticipantApi.compareSurvey(surveyId)`

### Error Handling

- Errors propagate through Riverpod as `AsyncValue.error`.
- No inline validation/transformation is performed in these providers.

### Usage Examples

- Surveys list UI watches `participantSurveysProvider`.
- Results UI watches `participantSurveyDataProvider`.
- Comparison UI watches `participantCompareProvider(surveyId)` for a specific survey.

---

## Cross-Cutting Notes

### Route Consistency

The following routes are explicitly referenced:

- `/participant/dashboard`
- `/participant/tasks`
- `/participant/surveys`

Ensure router configuration defines these paths and that `ParticipantScaffold` is compatible with them (e.g., navigation highlighting).

### Placeholder Areas to Implement

- Notifications/messages count endpoint:
  - Replace `participantNotificationCountProvider`.
- Participant dashboard summary endpoint:
  - Provide overall metrics/highlights for the dashboard.
- Participant results/analytics endpoint:
  - Populate graph renderers with real data.
- Task/survey detail routes:
  - Implement `_handleDoTask` navigation from dashboard task cards.
- Survey title enrichment / repeat schedule:
  - Use `SurveyApi` or assignment metadata.

---

## Related Files

- `frontend/src/features/participant/widgets/participant_scaffold.dart`
  - Shared participant layout shell used by all participant pages.

- `frontend/lib/src/features/participant/pages/participant_dashboard_page.dart`
  - Main participant dashboard page consuming the dashboard providers.

- `frontend/lib/features/participant/pages/participant_tasks_page.dart`
  - Placeholder tasks page; target of dashboard navigation.

- `frontend/lib/features/participant/pages/participant_surveys_page.dart`
  - Placeholder surveys page.

- `frontend/src/features/participant/state/participant_dashboard_providers.dart`
  - Dashboard-focused provider chain: session/profile/assignments/notification count.

- `frontend/lib/src/features/participant/state/participant_providers.dart`
  - Participant API providers for surveys, survey data, and comparisons.

- `frontend/src/features/question_bank/state/question_providers.dart`
  - Exports `apiClientProvider` used as the root dependency for API services.

- `frontend/src/core/api/api.dart`
  - Contains API wrappers/types used by dashboard provider snippet (`AuthApi`, `AssignmentApi`, `UserApi`, `SurveyApi`, models).

- `frontend/src/core/api/services/participant_api.dart`
  - Retrofit service used by participant survey providers.

- `frontend/src/core/api/models/participant.dart`
  - Participant survey model types:
    - `ParticipantSurveyListItem`
    - `ParticipantSurveyWithResponses`
    - `ParticipantSurveyCompareResponse`

- `frontend/src/core/api/models/assignment.dart`
  - Assignment model type used by dashboard (`MyAssignment`).