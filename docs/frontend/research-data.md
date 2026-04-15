# Research Data View Pages

> This document covers **two** researcher pages: the Survey Aggregates view (`/researcher/data`) and the Health Tracking view (`/researcher/health-tracking`). Both enforce k-anonymity — the backend performs all aggregation and the frontend only receives counts, averages, and distributions.

---

# Survey Aggregates Page

The survey aggregates page allows researchers and admins to browse aggregate survey analytics, apply filters, and export CSV reports.

**Route:** `/researcher/data`
**File:** `frontend/lib/src/features/researcher/pages/researcher_pull_data_page.dart`

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│  ResearcherPullDataPage (ConsumerStatefulWidget)            │
│  ┌───────────────────────────────────────────────────────┐  │
│  │ Controls: Survey dropdown │ Filters │ Export CSV      │  │
│  ├───────────────────────────────────────────────────────┤  │
│  │ Overview: AppStatCard × 3 (respondents, rate, Qs)     │  │
│  ├───────────────────────────────────────────────────────┤  │
│  │ Aggregates: per-question cards with charts            │  │
│  │   yesno        → AppPieChart                          │  │
│  │   single_choice→ AppBarChart                          │  │
│  │   multi_choice → AppBarChart                          │  │
│  │   number/scale → stats row + AppBarChart histogram    │  │
│  │   openended    → privacy notice (no content exposed)  │  │
│  │   suppressed   → k-anonymity warning                  │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## State Management (Riverpod)

All providers are in `frontend/lib/src/features/researcher/state/research_providers.dart`, exported via `researcher_state.dart` barrel.

### Provider Chain

```
apiClientProvider (singleton Dio)
  └→ researchApiProvider (ResearchApi Retrofit service)
      ├→ researchSurveysProvider (FutureProvider<List<ResearchSurvey>>)
      ├→ surveyOverviewProvider.family (FutureProvider.family<SurveyOverview, int>)
      ├→ surveyAggregatesProvider.family (watches researchFiltersProvider)
      └→ csvExportProvider.family (watches researchFiltersProvider)

researchFiltersProvider (StateNotifierProvider<ResearchFiltersNotifier, ResearchFilters>)
```

### Provider Details

| Provider | Type | Description |
|----------|------|-------------|
| `researchApiProvider` | `Provider<ResearchApi>` | Retrofit service instance |
| `researchSurveysProvider` | `FutureProvider<List<ResearchSurvey>>` | All surveys with response counts |
| `surveyOverviewProvider` | `FutureProvider.family<SurveyOverview, int>` | Survey stats by ID |
| `surveyAggregatesProvider` | `FutureProvider.family<AggregateResponse, int>` | Filtered aggregates by survey ID |
| `csvExportProvider` | `FutureProvider.family<String, int>` | CSV string by survey ID |
| `researchFiltersProvider` | `StateNotifierProvider` | Category + responseType filter state |

### Filter State

```dart
class ResearchFilters {
  final String? category;       // e.g., "demographics", "health"
  final String? responseType;   // e.g., "yesno", "number"
}
```

When filters change, `surveyAggregatesProvider` and `csvExportProvider` automatically re-fetch because they `ref.watch(researchFiltersProvider)`.

---

## Freezed Data Models

All models in `frontend/lib/src/core/api/models/research.dart`. Generated files: `research.freezed.dart`, `research.g.dart`.

| Model | Key Fields | Backend Source |
|-------|-----------|---------------|
| `ResearchSurvey` | surveyId, title, publicationStatus, responseCount, questionCount | `GET /research/surveys` |
| `SurveyOverview` | surveyId, title, respondentCount, completionRate, questionCount, suppressed | `GET /research/surveys/{id}/overview` |
| `QuestionAggregate` | questionId, questionContent, responseType, category?, responseCount, suppressed, data? | `GET /research/surveys/{id}/aggregates` |
| `AggregateResponse` | surveyId, title, totalRespondents, aggregates (list) | `GET /research/surveys/{id}/aggregates` |

All use `@JsonKey(name: 'snake_case')` to map from backend JSON.

The `data` field on `QuestionAggregate` is `Map<String, dynamic>?` because its structure varies by response type:

- **yesno:** `{yes_count, no_count, yes_pct, no_pct}`
- **single_choice / multi_choice:** `{options: [{option_text, count, pct}]}`
- **number / scale:** `{min, max, mean, median, std_dev, histogram: {bucket: count}}`
- **openended:** `null` or empty (no text content exposed for privacy)

---

## Retrofit API Service

File: `frontend/lib/src/core/api/services/research_api.dart`

| Method | HTTP | Path | Returns |
|--------|------|------|---------|
| `listResearchSurveys()` | GET | `/research/surveys` | `List<ResearchSurvey>` |
| `getSurveyOverview(id)` | GET | `/research/surveys/{id}/overview` | `SurveyOverview` |
| `getSurveyAggregates(id, ?category, ?responseType)` | GET | `/research/surveys/{id}/aggregates` | `AggregateResponse` |
| `getQuestionAggregate(id, questionId)` | GET | `/research/surveys/{id}/aggregates/{questionId}` | `QuestionAggregate` |
| `exportCsv(id, ?category, ?responseType)` | GET | `/research/surveys/{id}/export/csv` | `String` (raw CSV) |

CSV export uses `@DioResponseType(ResponseType.plain)` to get raw text instead of JSON.

---

## Navigation & Routing

### Route Configuration

In `go_router.dart`:
```dart
static const researcherData = '/researcher/data';

GoRoute(
  path: AppRoutes.researcherData,
  pageBuilder: (context, state) =>
      _noTransitionPage(const ResearcherPullDataPage(), state),
),
```

### Header Navigation

In `researcher_header.dart`, the "Data" nav item is added to `_getNavItems()`:
```dart
NavItem(label: context.l10n.navData, route: '/researcher/data'),
```

---

## CSV Export (Web)

The CSV download uses `package:web` (dart:js_interop) for browser file download:

```dart
final bytes = utf8.encode(csv);
final blob = web.Blob([bytes.toJS].toJS,
    web.BlobPropertyBag(type: 'text/csv'));
final url = web.URL.createObjectURL(blob);
final anchor = web.document.createElement('a') as web.HTMLAnchorElement
  ..href = url
  ..download = 'survey_${surveyId}_export.csv';
anchor.click();
web.URL.revokeObjectURL(url);
```

---

## Localization Strings

All strings in `frontend/lib/src/core/l10n/arb/app_en.arb` under the `@@_RESEARCH_DATA` section:

| Key | Value | Usage |
|-----|-------|-------|
| `navData` | "Data" | Header nav item |
| `researchDataTitle` | "Research Data" | Page title |
| `researchSelectSurvey` | "Select a survey" | Dropdown label / empty state |
| `researchNoSurveys` | "No surveys available" | Error state |
| `researchRespondents` | "Respondents" | Stat card label |
| `researchCompletionRate` | "Completion Rate" | Stat card label |
| `researchQuestions` | "Questions" | Stat card label |
| `researchExportCsv` | "Export CSV" | Button label |
| `researchFilterCategory` | "Category" | Dropdown label |
| `researchFilterResponseType` | "Response Type" | Dropdown label |
| `researchAllCategories` | "All Categories" | Default filter option |
| `researchAllTypes` | "All Types" | Default filter option |
| `researchSuppressed` | "Insufficient responses (minimum {count} required)" | K-anonymity warning |
| `researchNoData` | "No response data available for this survey" | Empty aggregates |
| `researchResponses` | "{count} responses" (plural) | Response count label |
| `researchOpenEndedNote` | "Open-ended responses are not displayed for privacy" | Privacy notice |

---

## How to Extend

### Adding a New Filter

1. Add field to `ResearchFilters` class in `research_providers.dart`
2. Add setter method in `ResearchFiltersNotifier`
3. Pass filter value in `surveyAggregatesProvider` → `api.getSurveyAggregates()`
4. Add dropdown widget in `_buildControlsRow()` on the page
5. Add localization strings to `app_en.arb` and run `flutter gen-l10n`

### Adding a New Response Type Visualization

1. Add a new case in `_buildAggregateVisualization()` switch statement
2. Create a `_buildNewTypeChart()` method
3. Parse the `data` map according to the backend's aggregation format
4. Use existing chart widgets (AppBarChart, AppPieChart) or create new ones

### Adding a New Stat Card

1. Add the stat to `_buildOverviewCards()` method
2. The backend must include the data in `SurveyOverview`
3. Add corresponding field to the `SurveyOverview` Freezed model
4. Run `dart run build_runner build --delete-conflicting-outputs` to regenerate

### Modifying the Page Layout

The page uses a simple Column layout:
1. Title text
2. Controls row (Wrap with dropdowns + buttons)
3. Expanded content area (SingleChildScrollView with stat cards + aggregate cards)

Each aggregate card is a Container with BoxDecoration, containing the question header, response count, and visualization widget.

---

# Health Tracking Research Page

Allows researchers and admins to view k-anonymity-filtered population-level health metric trends and export anonymised CSVs.

**Route:** `/researcher/health-tracking`
**File:** `frontend/lib/src/features/researcher/pages/researcher_health_tracking_page.dart`

---

## Architecture Overview

```
┌──────────────────────────────────────────────────────────────────┐
│  ResearcherHealthTrackingPage (ConsumerStatefulWidget)           │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │ Controls bar:                                              │  │
│  │   Category filter dropdown                                 │  │
│  │   Date range pickers (start / end)                         │  │
│  │   [Load Chart] button  [Export CSV] button                 │  │
│  ├────────────────────────────────────────────────────────────┤  │
│  │ Metric selector: list of checkboxes per category           │  │
│  ├────────────────────────────────────────────────────────────┤  │
│  │ Chart area (shown after Load Chart):                       │  │
│  │   One AppLineChart per selected metric                     │  │
│  │   avg_value line + participant_count annotation            │  │
│  │   Suppressed date ranges shown as gap in line              │  │
│  └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

---

## State Management (Riverpod)

Providers are in `frontend/lib/src/features/researcher/state/health_tracking_research_providers.dart`.

| Provider | Type | Description |
|----------|------|-------------|
| `researchHtMetricsProvider` | `FutureProvider<List<TrackingCategory>>` | All categories + metrics (reuses participant getMetrics endpoint) |
| `researchHtDateRangeProvider` | `FutureProvider<EntryDateRange>` | Min/max entry dates for date picker defaults |
| `researchHtFiltersProvider` | `StateProvider<HtResearchFilters>` | Selected metric IDs, start/end dates |
| `researchHtAggregateProvider` | `FutureProvider.family<List<MultiAggregateResult>, HtResearchFilters>` | Multi-metric aggregate data |
| `researchHtCategoryStatsProvider` | `FutureProvider<List<TrackingCategoryStats>>` | Category-level summary |

---

## Freezed Data Models

| Model | Key Fields | Backend Source |
|-------|-----------|----------------|
| `MultiAggregateResult` | metricId, metricKey, displayName, dataPoints | `GET /research/aggregate-multi` |
| `TrackingCategoryStats` | categoryKey, displayName, entryCount, participantCount, minDate, maxDate | `GET /research/categories` |
| `EntryDateRange` | minDate, maxDate | `GET /research/entry-date-range` |

---

## K-Anonymity Display

The page does not receive suppressed data points — the backend's `HAVING participant_count >= k` clause omits them. When a time range has no data points, the chart line simply has a gap. A banner at the top of the chart area notes: "Data points with fewer than {k} participants are not shown."

---

## CSV Export (Web)

Uses the same web download pattern as the survey CSV export:

```dart
final bytes = utf8.encode(csvString);
final blob = web.Blob([bytes.toJS].toJS, web.BlobPropertyBag(type: 'text/csv'));
final url  = web.URL.createObjectURL(blob);
final a    = web.document.createElement('a') as web.HTMLAnchorElement
  ..href = url
  ..download = 'health_tracking_export.csv';
a.click();
web.URL.revokeObjectURL(url);
```

The downloaded CSV columns: `participant_hash, metric_key, entry_date, value, is_baseline`. Participant IDs are SHA-256 hashed server-side before the response is sent.

---

## Localization Strings

| Key | English value |
|-----|--------------|
| `researchHtTitle` | "Health Tracking Research" |
| `researchHtLoadChart` | "Load Chart" |
| `researchHtExportCsv` | "Export CSV" |
| `researchHtSelectMetrics` | "Select metrics to display" |
| `researchHtDateRange` | "Date Range" |
| `researchHtSuppressedNote` | "Data points below the k-anonymity threshold are not shown" |
| `researchHtNoData` | "No data available for the selected metrics and date range" |
