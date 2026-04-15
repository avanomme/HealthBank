# ResearcherPullDataPage

## Overview
`ResearcherPullDataPage` is a researcher-facing data exploration page that displays anonymized survey responses and aggregate analysis with charts. It supports two modes:

1. **By Survey (single-survey mode):** Select one survey to view overview stats, a response data table, analysis charts, and export CSV.
2. **Data Bank (cross-survey mode):** Select multiple surveys and specific “fields” (questions), optionally filter by date/category/response type, view a merged table and analysis, and export CSV.

CSV download is implemented via a conditional import so web builds use browser APIs while other platforms use a stub.

File: `frontend/lib/src/features/researcher/pages/researcher_pull_data_page.dart`

## Architecture / Design
- **Widget type:** `ConsumerStatefulWidget` with `SingleTickerProviderStateMixin`
- **Layout:** Wrapped in `ResearcherScaffold` (`currentRoute: '/researcher/data'`) and padded content.
- **Mode toggle:** `SegmentedButton<bool>` toggles `_crossSurveyMode`.
- **Tabs:**
  - Single-survey mode uses `_tabController` with two tabs: Data Table / Analysis
  - Data bank mode uses `_dataBankTabController` with two tabs: Data Table / Analysis
- **Providers (from `research_providers.dart`):**
  - `researchSurveysProvider` (survey list)
  - Single-survey: `surveyOverviewProvider(surveyId)`, `individualResponsesProvider(surveyId)`, `surveyAggregatesProvider(surveyId)`, `csvExportProvider(surveyId)`
  - Cross-survey: `crossSurveyFiltersProvider`, `crossSurveyOverviewProvider`, `crossSurveyResponsesProvider`, `crossSurveyAggregatesProvider`, `crossSurveyCsvExportProvider`, `availableQuestionsProvider`
- **Anonymity enforcement:** The UI expects the backend to enforce k-anonymity (notably suppression when respondent count is below threshold); suppressed results show a warning UI instead of data.

## Configuration
No constructor parameters.

State managed internally:
- `_selectedSurveyId : int?`
- `_crossSurveyMode : bool`
- `_exporting : bool`
- Tab controllers: `_tabController`, `_dataBankTabController`

## Key UI Flows

### Single-survey mode
- Survey dropdown selects `_selectedSurveyId`
- Optional filters shown only once a survey is selected:
  - Category filter (derived from loaded questions in `IndividualResponseData`)
  - Response type filter (static list)
- “Export CSV” triggers `_exportCsv()` which reads `csvExportProvider(surveyId)` and calls `downloadCsvFile(...)`
- Content:
  - Overview cards from `SurveyOverview` (suppressed shows warning)
  - Tabs:
    - Data table: `IndividualResponseData` rendered via `DataTable`
    - Analysis: `SurveyAggregates` rendered by response type:
      - number/scale → stat cards + histogram bar chart
      - yesno → pie chart
      - single/multi choice → bar chart of option counts
      - openended → informational note (no analysis)

### Data bank (cross-survey) mode
- Survey selection via `FilterChip`s
- Field selection via “+ Add Fields” dialog (`_FieldPickerDialog`) which lists available questions grouped by survey, with search and select-all/clear options
- Optional filters: date-from, date-to, category, response type
- Export triggers `_exportCrossSurveyCsv()` which reads `crossSurveyCsvExportProvider` and calls `downloadCsvFile(...)`
- Content:
  - Overview cards from `crossSurveyOverviewProvider` (suppressed shows warning)
  - Tabs:
    - Data table: `CrossSurveyResponseData` rendered via `DataTable` (includes Survey column; only fills cells for questions belonging to that row’s survey)
    - Analysis: reuses the same per-question analysis rendering as single-survey mode

## API Reference

### Top-level widget
- `class ResearcherPullDataPage extends ConsumerStatefulWidget`

### Notable methods (single-survey)
- `_buildControlsRow(l10n, surveysAsync)`
- `_buildSurveyContent(l10n)`
- `_buildDataTableTab(l10n)` / `_buildDataTable(l10n, data)`
- `_buildAnalysisTab(l10n)` / `_buildQuestionAnalysis(l10n, q)` / `_buildAnalysisByType(l10n, q)`
- `_exportCsv()` — downloads `survey_<id>_responses.csv`

### Notable methods (cross-survey)
- `_buildCrossSurveyControlsRow(l10n, surveysAsync)`
- `_showFieldPickerDialog(l10n)` — opens `_FieldPickerDialog`
- `_buildSelectedFieldChips(l10n, filters)`
- `_buildCrossSurveyContent(l10n)`
- `_buildCrossSurveyDataTable(l10n)` / `_buildCrossSurveyTable(l10n, data)`
- `_buildDataBankAnalysisTab(l10n)`
- `_exportCrossSurveyCsv()` — downloads `data_bank_export.csv`

### Field picker dialog
- `_FieldPickerDialog` (consumer widget)
  - Searchable list of `CrossSurveyQuestion` from `availableQuestionsProvider`
  - Groups entries by `surveyTitle` using `ExpansionTile`
  - Uses `crossSurveyFiltersProvider.notifier` to:
    - `toggleQuestion(id)`
    - `setQuestions(allIds)`
    - `clearQuestions()`

## Error Handling
- Provider errors (`AsyncValue.error`) render inline error text (e.g., `Text('Error: $e')`) and/or fallback UI.
- Export errors are caught and shown via `SnackBar('Export failed: $e')`; `_exporting` is reset in `finally`.
- Suppressed datasets (k-anonymity) are handled via `suppressed` flags on overview/response/aggregate models:
  - Replaces data displays with a warning message indicating suppression.

## Usage Notes
- The CSV download function is imported conditionally:
  - Web builds use `csv_download_web.dart` (Blob + anchor click)
  - Non-web builds use `csv_download_stub.dart` (expected to be a safe no-op or platform implementation)

## Related Files
- `frontend/src/features/researcher/state/research_providers.dart` (all data + filter providers consumed here)
- `frontend/lib/src/features/researcher/widgets/researcher_scaffold.dart` (layout wrapper)
- `frontend/lib/src/features/researcher/pages/csv_download_web.dart` and `csv_download_stub.dart` (platform-specific CSV export)
- `frontend/src/core/widgets/data_display/app_stat_card.dart` (overview cards)
- `frontend/src/core/widgets/data_display/app_bar_chart.dart` (histograms / option counts)
- `frontend/src/core/widgets/data_display/app_pie_chart.dart` (yes/no distribution)
- `frontend/src/core/widgets/buttons/app_filled_button.dart` (export/done actions)
- `frontend/src/core/api/models/research.dart` (SurveyOverview, IndividualResponseData, CrossSurveyResponseData, QuestionAggregate, etc.)