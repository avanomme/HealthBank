# Health Tracking Feature

The health tracking feature lets participants log structured health and life metrics over time, view their personal history as charts, and record a baseline snapshot during onboarding. Researchers see k-anonymised population aggregates. Admins configure the metric catalogue dynamically — nothing is hardcoded.

**Participant route:** `/participant/health-tracking`
**Researcher route:** `/researcher/health-tracking`
**Admin route:** `/admin/health-tracking`

---

## Architecture Overview

```
┌────────────────────────────────────────────────────────────────┐
│  ParticipantHealthTrackingPage (ConsumerStatefulWidget)        │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ SegmentedButton: [Log Today] / [History]                 │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │ Log Today view:                                          │  │
│  │   Baseline prompt banner (if no baseline recorded)       │  │
│  │   Two-column layout:                                     │  │
│  │     Left: category sidebar (jump nav)                    │  │
│  │     Right: HealthMetricEntryCard list (all categories)   │  │
│  │   Sticky header row: [← Back] [Save] [Next →]           │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │ History view:                                            │  │
│  │   Category → metric dropdowns                            │  │
│  │   Date range picker                                      │  │
│  │   HealthTrackingChart (AppLineChart wrapper)             │  │
│  │   Population comparison toggle (participant aggregate)   │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────┘
```

---

## State Management (Riverpod)

All participant providers are in `frontend/lib/src/features/participant/state/health_tracking_providers.dart`.

### Provider Chain

```
apiClientProvider (singleton Dio)
  └→ healthTrackingApiProvider (HealthTrackingApi Retrofit service)
      ├→ trackingMetricsByCategoryProvider (FutureProvider<List<TrackingCategory>>)
      │     re-fetches on session or locale change
      ├→ trackingEntriesProvider.family (FutureProvider.family<List<TrackingEntry>, _DateRange>)
      ├→ trackingEntriesFilteredProvider.family (supports date+metric+category filters)
      ├→ trackingHistoryProvider.family (FutureProvider.family<List<TrackingEntry>, int>)
      ├→ baselineProvider (FutureProvider<List<TrackingEntry>>)
      ├→ checkInStatusProvider (FutureProvider<HealthCheckInStatus>)
      └→ participantAggregateProvider.family

trackingDraftProvider (StateNotifierProvider<TrackingDraftNotifier, Map<int,String>>)
  Holds in-progress metric values before Save is tapped.
```

### Provider Details

| Provider | Type | Description |
|----------|------|-------------|
| `healthTrackingApiProvider` | `Provider<HealthTrackingApi>` | Retrofit service instance |
| `trackingMetricsByCategoryProvider` | `FutureProvider<List<TrackingCategory>>` | Active categories + metrics; passes `?lang=` for locale |
| `trackingEntriesProvider` | `FutureProvider.family<List<TrackingEntry>, _DateRange>` | Entries by date range |
| `trackingEntriesFilteredProvider` | `FutureProvider.family<List<TrackingEntry>, _EntriesFilter>` | Full filter support |
| `trackingHistoryProvider` | `FutureProvider.family<List<TrackingEntry>, int>` | Full history by metric ID |
| `baselineProvider` | `FutureProvider<List<TrackingEntry>>` | Baseline snapshot entries |
| `checkInStatusProvider` | `FutureProvider<HealthCheckInStatus>` | Today's completion status |
| `trackingDraftProvider` | `StateNotifierProvider<TrackingDraftNotifier, Map<int,String>>` | Draft values keyed by metric ID |

---

## Freezed Data Models

All models in `frontend/lib/src/core/api/models/health_tracking.dart`.
Generated files: `health_tracking.freezed.dart`, `health_tracking.g.dart`.

| Model | Key Fields | Backend Source |
|-------|-----------|----------------|
| `TrackingCategory` | categoryId, categoryKey, displayName, description, icon, displayOrder, isActive, isDeleted, metrics | `GET /metrics` |
| `TrackingMetric` | metricId, categoryId, metricKey, displayName, metricType, unit, scaleMin, scaleMax, choiceOptions, frequency, isActive, isBaseline | nested in `TrackingCategory` |
| `TrackingEntry` | entryId, participantId, metricId, value, notes, entryDate, isBaseline, createdAt | `GET /entries`, `GET /history/{id}` |
| `TrackingEntrySubmit` | metricId, value, notes, entryDate | `POST /entries` body |
| `BatchEntrySubmit` | entries: List, isBaseline | `POST /entries` body |
| `HealthCheckInStatus` | isComplete, totalDue, completedCount, hasAnyDue | `GET /status/today` |
| `AggregateDataPoint` | entryDate, avgValue, minValue, maxValue, participantCount | Aggregate endpoints |

All use `@JsonKey(name: 'snake_case')` for backend mapping. Date fields use custom `healthTrackingDateFromJson` / `healthTrackingDateToJson` converters (format: `yyyy-MM-dd`).

---

## Widgets

### HealthMetricEntryCard

**File:** `frontend/lib/src/features/participant/widgets/health_metric_entry_card.dart`

Renders the correct input widget based on `metric.metricType`:

| `metricType` | Widget rendered |
|--------------|----------------|
| `scale` | `Slider` with `scaleMin`/`scaleMax` bounds and tick labels |
| `number` | `AppTextInput` (numeric keyboard) with unit suffix |
| `yesno` | `ToggleButtons` (Yes / No) |
| `single_choice` | `AppDropdownInput` from `choiceOptions` list |
| `text` | `AppTextInput` (text keyboard) |

Shows metric `displayName`, `description`, and `unit`. Uses `appFieldSemantics()` for WCAG 2.1 compliance.

### HealthTrackingChart

**File:** `frontend/lib/src/features/participant/widgets/health_tracking_chart.dart`

Wraps `AppLineChart` with date-range controls. Displays a participant's historical values for a single metric over time. Shows a second series for population average when the participant aggregate data is available.

---

## Retrofit API Service

**File:** `frontend/lib/src/core/api/services/health_tracking_api.dart`

| Method | HTTP | Path | Returns |
|--------|------|------|---------|
| `getMetrics({lang})` | GET | `/health-tracking/metrics` | `List<TrackingCategory>` |
| `submitEntries(body)` | POST | `/health-tracking/entries` | `void` |
| `getEntries({...})` | GET | `/health-tracking/entries` | `List<TrackingEntry>` |
| `getHistory(metricId)` | GET | `/health-tracking/history/{id}` | `List<TrackingEntry>` |
| `getBaseline()` | GET | `/health-tracking/baseline` | `List<TrackingEntry>` |
| `getCheckInStatus()` | GET | `/health-tracking/status/today` | `HealthCheckInStatus` |
| `getParticipantAggregate({metricId,...})` | GET | `/health-tracking/participant/aggregate` | `List<AggregateDataPoint>` |
| `exportParticipantCsv({...})` | GET | `/health-tracking/participant/export` | `String` (CSV) |
| `getAdminCategories()` | GET | `/health-tracking/admin/categories` | `List<TrackingCategory>` |
| `createCategory(body)` | POST | `/health-tracking/admin/categories` | `void` |
| `updateCategory(id, body)` | PUT | `/health-tracking/admin/categories/{id}` | `void` |
| `toggleCategory(id)` | PATCH | `/health-tracking/admin/categories/{id}/toggle` | `void` |
| `deleteCategory(id)` | DELETE | `/health-tracking/admin/categories/{id}` | `void` |
| `restoreCategory(id)` | PATCH | `/health-tracking/admin/categories/{id}/restore` | `void` |
| `reorderCategories(body)` | PUT | `/health-tracking/admin/categories/reorder` | `void` |
| `getAdminMetrics()` | GET | `/health-tracking/admin/metrics` | `List<TrackingMetric>` |
| `createMetric(body)` | POST | `/health-tracking/admin/metrics` | `void` |
| `updateMetric(id, body)` | PUT | `/health-tracking/admin/metrics/{id}` | `void` |
| `toggleMetric(id)` | PATCH | `/health-tracking/admin/metrics/{id}/toggle` | `void` |
| `deleteMetric(id)` | DELETE | `/health-tracking/admin/metrics/{id}` | `void` |
| `restoreMetric(id)` | PATCH | `/health-tracking/admin/metrics/{id}/restore` | `void` |
| `reorderMetrics(body)` | PUT | `/health-tracking/admin/metrics/reorder` | `void` |
| `getAggregate({metricId,...})` | GET | `/health-tracking/research/aggregate` | `List<AggregateDataPoint>` |
| `getMultiAggregate({metricIds,...})` | GET | `/health-tracking/research/aggregate-multi` | `List<MultiAggregateResult>` |
| `getResearchCategories()` | GET | `/health-tracking/research/categories` | `List<TrackingCategoryStats>` |
| `exportHealthTrackingCsv({...})` | GET | `/health-tracking/research/export` | `String` (CSV) |
| `getEntryDateRange()` | GET | `/health-tracking/research/entry-date-range` | `EntryDateRange` |

---

## Navigation & Routing

### Route Constants

In `go_router.dart`:
```dart
static const participantHealthTracking = '/participant/health-tracking';
static const researcherHealthTracking   = '/researcher/health-tracking';
static const adminHealthTracking        = '/admin/health-tracking';
```

### Navigation Items

Health Tracking is added to `ParticipantScaffold` nav items as a persistent bottom navigation entry (mobile) and sidebar entry (desktop/tablet).

---

## Localization Strings

All strings in `app_en.arb` and `app_fr.arb`:

| Key | English value |
|-----|--------------|
| `healthTrackingTitle` | "Health Tracking" |
| `healthTrackingLogToday` | "Log Today" |
| `healthTrackingHistory` | "History" |
| `healthTrackingBaselinePrompt` | "Record your baseline" |
| `healthTrackingBaselineDescription` | "Before we track your progress, capture where you are today." |
| `healthTrackingSave` | "Save" |
| `healthTrackingSaved` | "Saved" |
| `healthTrackingNoMetrics` | "No metrics available" |
| `healthTrackingAdminTitle` | "Health Tracking Settings" |
| `healthTrackingAddCategory` | "Add Category" |
| `healthTrackingAddMetric` | "Add Metric" |
| `healthTrackingEditCategory` | "Edit Category" |
| `healthTrackingEditMetric` | "Edit Metric" |

---

## How to Extend

### Adding a New Metric Type

1. Add the new enum value to `MetricType` in `backend/app/api/v1/health_tracking.py`
2. Add a validation case in `_validate_entry_value()`
3. Add a new `case` in `HealthMetricEntryCard` to render the appropriate input widget
4. Update the `metric_type` field comment in `health_tracking.dart` model
5. Add localization strings if the input has UI labels
6. Run `dart run build_runner build --delete-conflicting-outputs`

### Adding a New Admin Field to a Category/Metric

1. Add the DB column in a new migration file
2. Add the field to `CategoryCreate`/`CategoryUpdate` or `MetricCreate` Pydantic model in Python
3. Add the field to `TrackingCategory` or `TrackingMetric` Freezed model in Dart
4. Update `createCategory` / `updateCategory` dialog in `AdminHealthTrackingSettingsPage`
5. Run `dart run build_runner build --delete-conflicting-outputs`
