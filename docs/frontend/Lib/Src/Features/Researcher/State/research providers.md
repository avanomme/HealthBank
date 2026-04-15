# research_providers.dart

## Overview

This file defines the Riverpod provider layer for the researcher “Pull Data / Research Data” feature. It wires the `ResearchApi` service and exposes providers for:

* Survey list + single-survey overview, responses, aggregates, and CSV export (with optional filters)
* Data bank (cross-survey) filters/selections and the corresponding overview, responses, aggregates, available fields, and CSV export

File: `frontend/lib/src/features/researcher/state/research_providers.dart`

## Architecture / Design

### Provider chain

* `apiClientProvider` (imported from question bank) → `researchApiProvider` → feature providers

### Two filter domains

1. **Single-survey filters** (`ResearchFilters`)

   * Simple category/responseType filters shared by overview/responses/aggregates/export providers.
2. **Cross-survey (data bank) filters** (`CrossSurveyFilters`)

   * Survey selection, field selection (question IDs), optional date range, plus category/responseType filters.

### API coupling

All data providers call methods on `ResearchApi` and pass `null` for optional query params when the corresponding selections are empty (e.g., no selected surveys/questions).

## Configuration

No runtime configuration. Consumers typically:

* Watch the async providers for data (`ref.watch(...)`)
* Mutate filter state using the corresponding notifier providers (`ref.read(...notifier)`)

## API Reference

## Research API provider

### `researchApiProvider : Provider<ResearchApi>`

Creates a `ResearchApi` using the shared Dio client from `apiClientProvider`.

## Survey list and single-survey providers

### `researchSurveysProvider : FutureProvider<List<ResearchSurvey>>`

Calls `api.listResearchSurveys()` to fetch surveys with response counts.

### `surveyOverviewProvider : FutureProvider.family<SurveyOverview, int>`

`api.getSurveyOverview(surveyId)`

### Filters: `ResearchFilters`

Fields:

* `category : String?`
* `responseType : String?`

Methods:

* `copyWith({String? category, String? responseType}) -> ResearchFilters`
* `clearCategory() -> ResearchFilters`
* `clearResponseType() -> ResearchFilters`
* `clearAll() -> ResearchFilters`

### `ResearchFiltersNotifier extends StateNotifier<ResearchFilters>`

Methods:

* `setCategory(String? category)`
* `setResponseType(String? responseType)`
* `clearAll()`

### `researchFiltersProvider : StateNotifierProvider<ResearchFiltersNotifier, ResearchFilters>`

Holds current single-survey filter state.

### `individualResponsesProvider : FutureProvider.family<IndividualResponseData, int>`

Calls:

* `api.getIndividualResponses(surveyId, category: filters.category, responseType: filters.responseType)`

### `surveyAggregatesProvider : FutureProvider.family<AggregateResponse, int>`

Calls:

* `api.getSurveyAggregates(surveyId, category: filters.category, responseType: filters.responseType)`

### `csvExportProvider : FutureProvider.family<String, int>`

Calls:

* `api.exportCsv(surveyId, category: filters.category, responseType: filters.responseType)`

## Data bank (cross-survey) providers

### Filters: `CrossSurveyFilters`

Fields:

* `selectedSurveyIds : List<int>` (default `[]`)
* `selectedQuestionIds : List<int>` (default `[]`)
* `dateFrom : String?` (expected format `YYYY-MM-DD`)
* `dateTo : String?` (expected format `YYYY-MM-DD`)
* `category : String?`
* `responseType : String?`

Method:

* `copyWith(...) -> CrossSurveyFilters`

### `CrossSurveyFiltersNotifier extends StateNotifier<CrossSurveyFilters>`

Selection methods:

* `toggleSurvey(int id)`
* `toggleQuestion(int id)`
* `setQuestions(List<int> ids)` (sets selected question IDs)
* `clearQuestions()` (empties selected question IDs)

Date/category/type methods:

* `setDateFrom(String? dateFrom)`
* `setDateTo(String? dateTo)`
* `setCategory(String? category)`
* `setResponseType(String? responseType)`

Reset:

* `clearAll()` (restores defaults)

### `crossSurveyFiltersProvider : StateNotifierProvider<CrossSurveyFiltersNotifier, CrossSurveyFilters>`

Holds current data bank filter/selection state.

### `availableQuestionsProvider : FutureProvider<List<CrossSurveyQuestion>>`

Calls `api.getAvailableQuestions(...)` with:

* `surveyIds`: `null` if no selected surveys, else selected list
* `category`, `responseType` from filters

### `crossSurveyOverviewProvider : FutureProvider<CrossSurveyOverview>`

Calls `api.getCrossSurveyOverview(...)` with:

* `surveyIds`: `null` if no selected surveys, else selected list
* `dateFrom`, `dateTo`

### `crossSurveyResponsesProvider : FutureProvider<CrossSurveyResponseData>`

Calls `api.getCrossSurveyResponses(...)` with:

* `surveyIds`: `null` if empty
* `questionIds`: `null` if empty
* `category`, `responseType`, `dateFrom`, `dateTo`

### `crossSurveyAggregatesProvider : FutureProvider<AggregateResponse>`

Calls `api.getCrossSurveyAggregates(...)` with the same filter/selection params as responses.

### `crossSurveyCsvExportProvider : FutureProvider<String>`

Calls `api.exportCrossSurveyCsv(...)` with the same filter/selection params as responses.

## Error Handling

* No explicit try/catch is used in this layer; API exceptions propagate to consumers as `AsyncValue.error`.
* The providers deliberately pass `null` for `surveyIds`/`questionIds` when selections are empty to indicate “no restriction” to the backend.

## Usage Examples

### Single-survey: set filters and fetch responses

```
ref.read(researchFiltersProvider.notifier).setCategory('mental_health');
ref.read(researchFiltersProvider.notifier).setResponseType('scale');
final responsesAsync = ref.watch(individualResponsesProvider(surveyId));
```

### Data bank: select surveys and fields, then fetch table

```
ref.read(crossSurveyFiltersProvider.notifier).toggleSurvey(1);
ref.read(crossSurveyFiltersProvider.notifier).toggleSurvey(2);
ref.read(crossSurveyFiltersProvider.notifier).setQuestions([10, 12, 15]);
final dataAsync = ref.watch(crossSurveyResponsesProvider);
```

## Related Files

* `frontend/src/core/api/services/research_api.dart` — Retrofit API surface used by all providers here.
* `frontend/src/core/api/models/research.dart` — Data models returned by the research endpoints.
* `frontend/lib/src/features/researcher/pages/researcher_pull_data_page.dart` — Primary UI consumer of these providers.
* `frontend/lib/features/question_bank/state/question_providers.dart` — Source of `apiClientProvider` used to construct `ResearchApi`.
