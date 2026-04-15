# Participant Dashboard Page Documentation

**File:** `frontend/lib/src/features/participant/pages/participant_dashboard_page.dart`

## Overview

`ParticipantDashboardPage` is a Flutter (Riverpod) page that serves as the participant’s home dashboard. It provides:

- A personalized greeting (based on the participant profile).
- A notification/messages banner (currently backed by a placeholder provider).
- Analytics/graph placeholders for future participant metrics.
- A task progress indicator and a list of pending tasks with calls to action.
- Navigation to a “View all tasks” route.

This page is built as a `ConsumerStatefulWidget` to support both reactive provider data and local UI state (e.g., dropdown selection).

## Architecture / Design Explanation

### Widget Structure

- **`ParticipantDashboardPage`**
  - Wraps the page in `ParticipantScaffold`, which provides:
    - Route awareness (`currentRoute`)
    - Notification affordance (`hasNotifications`, `onNotificationsTap`)
    - User name display (`userName`)
  - The scaffold’s `child` is the dashboard content produced by `_buildContent(...)`.

### State Management

- **Riverpod Providers**
  - `participantProfileProvider` (async): participant identity for greeting/header.
  - `participantAssignmentsProvider` (async): list of `MyAssignment` used to derive progress and task cards.
  - `participantNotificationCountProvider` (int): currently a placeholder provider, used to control the banner and scaffold indicator.

- **Local Stateful UI**
  - `_selectedAssignmentId` stores the selected dropdown assignment id.
  - The dropdown selection does not currently drive navigation; it is used only to preserve UI selection.

### Layout & Responsiveness

- Content is wrapped in a `LayoutBuilder` to compute:
  - `basePadding` via `Breakpoints.responsivePadding(width)`
  - `contentMaxWidth` using `Breakpoints.maxContent * 0.6`, capped by screen width
- Graph cards are responsive:
  - Desktop: displayed side-by-side in a `Row`
  - Mobile/tablet: displayed stacked in a `Column`

### Task Rendering Logic

Assignments are processed to compute:

- `totalTasks`: total assignments.
- `completedTasks`: assignments where `status == 'completed'`.
- `progress`: `completedTasks / totalTasks` (0.0 if none).
- `pendingTasks`: assignments where `status != 'completed'`.
- `remainingToday`: pending tasks with `dueDate` matching “today” (date-only compare).

Tasks shown as cards are:
- All pending tasks, sorted by `dueDate` (null dates pushed to the end via year 3000 sentinel).

The dropdown options prioritize tasks due today if any exist, otherwise all pending tasks.

### Navigation

- “View all tasks” uses `go_router` to navigate:
  - `context.go('/participant/tasks')`

### Planned/Stubbed Integrations

The file includes TODOs indicating future work:
- Notifications/messages route navigation.
- Task/survey detail navigation.
- Replacing graph placeholders with real analytics endpoint data.
- Enriching survey titles and repeat schedules via `SurveyApi` / assignment metadata.

## Configuration

No direct configuration is defined in this file.

This widget relies on:
- Localization via `context.l10n`
- Theme primitives via `AppTheme`
- Breakpoint utilities via `Breakpoints`
- Providers defined elsewhere (see Related Files)

## API Reference

This section documents the public and internal methods in this page file and how they behave.

### `ParticipantDashboardPage`

#### Constructor

- `ParticipantDashboardPage({Key? key})`

**Parameters**
- `key` (`Key?`): Flutter widget key.

**Returns**
- A `ParticipantDashboardPage` widget.

### `_ParticipantDashboardPageState`

#### Fields

- `_selectedAssignmentId` (`int?`)
  - Stores current selection in the remaining tasks dropdown.

#### Methods

##### `_handleNotificationTap() -> void`

Placeholder for navigating to notifications/messages.

**Parameters**
- None

**Returns**
- `void`

**Notes**
- Currently does nothing besides a TODO comment.

##### `_handleDoTask(MyAssignment assignment) -> void`

Placeholder for navigating to a task or survey detail screen.

**Parameters**
- `assignment` (`MyAssignment`): The task to act on.

**Returns**
- `void`

**Notes**
- Currently does nothing besides a TODO comment.

##### `_handleViewAllTasks() -> void`

Navigates to the participant tasks list route.

**Parameters**
- None

**Returns**
- `void`

**Side Effects**
- Calls `context.go('/participant/tasks')`.

##### `build(BuildContext context) -> Widget`

Builds the scaffold and subscribes to providers.

**Parameters**
- `context` (`BuildContext`): Flutter build context.

**Returns**
- `Widget`: `ParticipantScaffold` wrapping the dashboard content.

**Provider Reads**
- `participantProfileProvider` (`AsyncValue<ParticipantProfile>`)
- `participantAssignmentsProvider` (`AsyncValue<List<MyAssignment>>`)
- `participantNotificationCountProvider` (`int`)

##### `_buildContent(BuildContext context, AppLocalizations l10n, { ... }) -> Widget`

Builds the main dashboard content body.

**Parameters**
- `context` (`BuildContext`)
- `l10n` (`AppLocalizations`)
- `profileAsync` (`AsyncValue<ParticipantProfile>`) *(required)*
- `assignmentsAsync` (`AsyncValue<List<MyAssignment>>`) *(required)*
- `notificationCount` (`int`) *(required)*

**Returns**
- `Widget`: A constrained column of dashboard sections.

**Behavior**
- Shows:
  - Welcome header (async)
  - Notification banner (if count > 0)
  - Description text
  - Graph placeholders
  - Tasks section (async list), with loading/error states

##### `_buildWelcome(AsyncValue<ParticipantProfile> profileAsync, AppLocalizations l10n) -> Widget`

Builds the welcome greeting with participant name.

**Parameters**
- `profileAsync` (`AsyncValue<ParticipantProfile>`)
- `l10n` (`AppLocalizations`)

**Returns**
- `Widget`: `AppText` greeting or loading/error text.

**Name Selection**
- Uses `profile.firstName ?? profile.displayName`.

##### `_buildNotificationBanner(int count, AppLocalizations l10n) -> Widget`

Shows an announcement banner if there are new messages.

**Parameters**
- `count` (`int`)
- `l10n` (`AppLocalizations`)

**Returns**
- `Widget`: `AppAnnouncement` or `SizedBox.shrink()`.

**Behavior**
- If `count <= 0`, returns an empty widget.
- Otherwise, banner is tappable and triggers `_handleNotificationTap()`.

##### `_buildGraphs(AppLocalizations l10n, double basePadding) -> Widget`

Renders placeholder graph cards.

**Parameters**
- `l10n` (`AppLocalizations`)
- `basePadding` (`double`)

**Returns**
- `Widget`: A `Row` or `Column` with two `AppGraphRenderer` widgets depending on screen width.

##### `_buildTasksSection(AppLocalizations l10n, List<MyAssignment> assignments, double basePadding) -> Widget`

Builds progress display, dropdown, task cards, and the “View all tasks” button.

**Parameters**
- `l10n` (`AppLocalizations`)
- `assignments` (`List<MyAssignment>`)
- `basePadding` (`double`)

**Returns**
- `Widget`: A column of task progress UI and task cards.

**Computed Values**
- Progress derived from completed vs total.
- Tasks sorted by `dueDate` (null dates last).
- Dropdown options prefer tasks due today.

**UI Components Used**
- `AppProgressBar`
- `AppDropdownMenu<int>`
- `AppCardTask` (per task)
- `AppLongButton` (View all tasks)

##### `_formatDueText(DateTime? dueDate, AppLocalizations l10n) -> String`

Formats the due date string for display.

**Parameters**
- `dueDate` (`DateTime?`)
- `l10n` (`AppLocalizations`)

**Returns**
- `String`: Localized due text.

**Behavior**
- If `dueDate == null`: returns placeholder text.
- If due date is today (date-only): formats time using `DateFormat.jm(locale)` and returns “Due today at …”.
- Otherwise: formats date using `DateFormat.yMMMd(locale)` and returns “Due on …”.

##### `_formatRepeatText(MyAssignment _) -> String?`

Placeholder for repeat schedule text.

**Parameters**
- `_` (`MyAssignment`): currently unused.

**Returns**
- `String?`: currently always `null`.

## Error Handling

### Provider Errors

- `participantProfileProvider`:
  - If error: displays localized generic error text in `AppText` using `AppTheme.error`.
- `participantAssignmentsProvider`:
  - If error: displays localized generic error text in `AppText` using `AppTheme.error`.

No retries, toasts, or detailed error messages are implemented in this file; errors are surfaced as inline text.

### Null/Missing Data

- If `MyAssignment.dueDate` is null:
  - `_formatDueText` returns a placeholder string and includes a TODO to confirm whether null due dates can occur.
- If `MyAssignment.surveyTitle` is null:
  - Task titles fall back to `l10n.participantPlaceholder`, with a TODO to resolve via `SurveyApi`.
- If total tasks is 0:
  - Progress is set to `0.0` to avoid division by zero.

## Usage Examples

### Routing to the Dashboard Page

In a `go_router` route configuration, you would typically register the page like:

- Route path: `/participant/dashboard`
- Builder: `(_) => const ParticipantDashboardPage()`

### Navigation From the Dashboard

The “View all tasks” CTA triggers:

- `context.go('/participant/tasks')`

To ensure this works, the router must define a corresponding `/participant/tasks` route.

## Related Files

- `frontend/src/features/participant/widgets/participant_scaffold.dart`
  - Provides dashboard page shell (header/navigation/notification affordance).
- `frontend/src/features/participant/state/participant_dashboard_providers.dart`
  - Defines:
    - `participantProfileProvider`
    - `participantAssignmentsProvider`
    - `participantNotificationCountProvider`
- `frontend/src/core/api/models/assignment.dart`
  - Defines `MyAssignment` (fields used include `assignmentId`, `surveyTitle`, `dueDate`, `status`).
- `frontend/src/core/widgets/data_display/app_card_task.dart`
  - Task card UI used to render each pending assignment.
- `frontend/src/core/widgets/data_display/app_progress_bar.dart`
  - Progress bar UI.
- `frontend/src/core/widgets/data_display/app_graph_renderer.dart`
  - Placeholder analytics card widget.
- `frontend/src/core/widgets/feedback/app_announcement.dart`
  - Notification banner widget.
- `frontend/src/core/widgets/basics/app_dropdown_menu.dart`
  - Dropdown used for remaining tasks selection.
- `frontend/src/core/widgets/buttons/app_long_button.dart`
  - “View all tasks” CTA button.
- `frontend/src/core/l10n/l10n.dart`
  - Localization strings accessed via `context.l10n`.
- `frontend/src/core/theme/theme.dart`
  - Theme constants (colors, typography helpers).