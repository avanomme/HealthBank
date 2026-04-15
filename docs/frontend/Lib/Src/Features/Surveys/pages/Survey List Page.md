# SurveyListPage

## Overview
`SurveyListPage` is a researcher-facing page that lists surveys with search and publication-status filtering. It supports creating new surveys, editing existing ones, and performing common survey actions (publish, close, delete) from a per-survey overflow menu.

File: `frontend/lib/src/features/surveys/pages/survey_list_page.dart`

## Architecture / Design
- **Widget type:** `ConsumerStatefulWidget` (holds a search `TextEditingController`, uses Riverpod state).
- **Layout wrapper:** `ResearcherScaffold(currentRoute: '/surveys')`.
- **Primary state sources:**
  - `surveysProvider` — async list of `Survey` objects (from `../state/survey_providers.dart`).
  - `surveyFiltersProvider` — filter state (search query + publication status).
  - `surveyApiProvider` — API service used for publish/close/delete.
- **UI flow:**
  - Search + filter controls at the top
  - Optional active filter chips row
  - List area renders loading/error/empty/data states
  - FAB to create a new survey

## Configuration
### Constructor
    const SurveyListPage({ Key? key })

No external parameters.

## Provider / State Dependencies
From `../state/survey_providers.dart` (import not shown in detail):
- `surveysProvider` (list fetch)
- `surveyFiltersProvider` (filter state + notifier)
- `surveyApiProvider` (actions: publish, close, delete)

Other key dependencies:
- `AppRoutes.surveyBuilder` (route constant)
- `go_router` navigation (`context.push(...)`)
- `context.l10n` localization keys for all labels/messages
- `AppTheme` for styling

## UI Structure
ResearcherScaffold  
└── Column  
  ├── Search + filters panel (`_buildSearchAndFilters`)  
  ├── Active filter chips (`_buildActiveFiltersChips`, conditional)  
  └── Expanded list area  
    └── `surveysAsync.when(data/loading/error)`

### Floating Action Button
A `FloatingActionButton.extended` launches survey creation:
- Calls `_navigateToBuilder()` which pushes `AppRoutes.surveyBuilder`.

## Key Behaviors

## Searching
- `_searchController` drives the search field UI.
- `onChanged` calls `_onSearchChanged(query)` → `surveyFiltersProvider.notifier.setSearchQuery(query)`.
- Clearing the field also clears the search filter.

## Filtering by publication status
- Dropdown values: `null`, `draft`, `published`, `closed`.
- `onChanged` calls `_onFilterChanged(status)` → `setPublicationStatus(status)`.

## Clearing filters
- `_clearFilters()` calls `clearAll()` on the filter notifier and resets the search box.

## Navigation to the survey builder
- Editing: `context.push('/surveys/$surveyId/edit')`
- New: `context.push(AppRoutes.surveyBuilder)`

## List rendering
- Empty list → `_buildEmptyState()`:
  - Shows “no surveys” or “no matches” depending on whether filters are active.
  - Offers “create survey” (no filters) or “clear filters” (filters active).
- Pull-to-refresh:
  - `RefreshIndicator` invalidates `surveysProvider`.

## Survey card actions
Each survey card:
- Navigates to edit on tap
- Shows title, optional description, status badge, question count, optional date range
- Provides a popup menu with actions:
  - **Edit** (always)
  - **Publish** (only when status is `draft`)
  - **Close** (only when status is `published`)
  - **Delete** (always)

Action handlers:
- `_publishSurvey(survey)` → confirm dialog → `surveyApiProvider.publishSurvey(...)` → invalidate `surveysProvider`
- `_closeSurvey(survey)` → confirm dialog → `surveyApiProvider.closeSurvey(...)` → invalidate `surveysProvider`
- `_confirmDelete(survey)` → confirm dialog → `surveyApiProvider.deleteSurvey(...)` → invalidate `surveysProvider`

All actions show success/failure `SnackBar`s on completion.

## API Reference

### Class: `SurveyListPage extends ConsumerStatefulWidget`
No public fields.

### State: `_SurveyListPageState`
Key members:
- `_searchController : TextEditingController`

Key methods:
- `_onSearchChanged(String query)`
- `_onFilterChanged(String? status)`
- `_clearFilters()`
- `_navigateToBuilder({int? surveyId})`
- `_buildSearchAndFilters(SurveyFilters filters)`
- `_buildSurveysList(List<Survey> surveys)`
- `_buildSurveyCard(Survey survey)`
- `_handleAction(String action, Survey survey)`
- `_publishSurvey(Survey survey)`
- `_closeSurvey(Survey survey)`
- `_confirmDelete(Survey survey)`
- `_buildEmptyState()`
- `_buildErrorState(Object error)`

Formatting helpers:
- `_formatStatus(String status)` (localized label for chips)
- `_buildStatusBadge(String status)`
- `_formatDateRange(DateTime? start, DateTime? end)` (MM/DD/YYYY)

## Error Handling
- Fetch errors from `surveysProvider` render `_buildErrorState(error)` and allow retry via `ref.invalidate(surveysProvider)`.
- Publish/close/delete operations are wrapped in `try/catch` and show localized failure messages with the exception string interpolated.
- Uses `if (mounted)` guards before showing SnackBars after async calls.

## Usage Examples

### Route definition
    GoRoute(
      path: '/surveys',
      builder: (context, state) => const SurveyListPage(),
    );

### Create survey from elsewhere
    context.push(AppRoutes.surveyBuilder);

### Edit survey from elsewhere
    context.push('/surveys/123/edit');

## Related Files
- `frontend/lib/src/features/surveys/state/survey_providers.dart` — `surveysProvider`, `surveyFiltersProvider`, `surveyApiProvider`.
- `frontend/lib/src/features/surveys/pages/survey_builder_page.dart` — Survey create/edit UI target of navigation.
- `frontend/src/features/researcher/widgets/researcher_scaffold.dart` — Page wrapper and navigation header.
- `frontend/src/config/go_router.dart` — `AppRoutes` constants, routing conventions.
- `frontend/src/core/api/api.dart` — `Survey` model used for list rendering.
- `frontend/src/core/l10n/l10n.dart` — Localization strings.
- `frontend/src/core/theme/theme.dart` — `AppTheme` styles.