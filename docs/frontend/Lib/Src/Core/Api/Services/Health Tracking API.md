# Health Tracking API Service (`health_tracking_api.dart`)

**File:** `frontend/lib/src/core/api/services/health_tracking_api.dart`
**Generated file:** `health_tracking_api.g.dart`

Retrofit `@RestApi()` service that mirrors all `backend/app/api/v1/health_tracking.py` endpoints.

---

## Setup

Registered in `api_client.dart` alongside other services:

```dart
final healthTrackingApiProvider = Provider<HealthTrackingApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return HealthTrackingApi(client.dio);
});
```

---

## Participant Methods

| Method | HTTP | Path | Returns |
|--------|------|------|---------|
| `getMetrics({lang})` | GET | `/health-tracking/metrics` | `List<TrackingCategory>` |
| `submitEntries(body)` | POST | `/health-tracking/entries` | `void` |
| `getEntries({startDate, endDate, metricId, categoryKey})` | GET | `/health-tracking/entries` | `List<TrackingEntry>` |
| `getHistory(metricId)` | GET | `/health-tracking/history/{metricId}` | `List<TrackingEntry>` |
| `getBaseline()` | GET | `/health-tracking/baseline` | `List<TrackingEntry>` |
| `getCheckInStatus()` | GET | `/health-tracking/status/today` | `HealthCheckInStatus` |
| `getParticipantAggregate({metricId, startDate, endDate})` | GET | `/health-tracking/participant/aggregate` | `List<AggregateDataPoint>` |
| `exportParticipantCsv({startDate, endDate, metricIds})` | GET | `/health-tracking/participant/export` | `String` (CSV) |

---

## Admin Methods

| Method | HTTP | Path | Returns |
|--------|------|------|---------|
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

---

## Researcher Methods

| Method | HTTP | Path | Returns |
|--------|------|------|---------|
| `getAggregate({metricId, startDate, endDate})` | GET | `/health-tracking/research/aggregate` | `List<AggregateDataPoint>` |
| `getMultiAggregate({metricIds, startDate, endDate})` | GET | `/health-tracking/research/aggregate-multi` | `List<MultiAggregateResult>` |
| `getResearchCategories()` | GET | `/health-tracking/research/categories` | `List<TrackingCategoryStats>` |
| `exportHealthTrackingCsv({startDate, endDate, metricIds})` | GET | `/health-tracking/research/export` | `String` (CSV) |
| `getEntryDateRange()` | GET | `/health-tracking/research/entry-date-range` | `EntryDateRange` |

---

## Notes

- `exportParticipantCsv` and `exportHealthTrackingCsv` return raw `String` (CSV). Use `@DioResponseType(ResponseType.plain)` in the Retrofit annotation if plain text is required; otherwise the default JSON decoder may fail on non-JSON responses.
- `reorderCategories` and `reorderMetrics` accept `List<CategoryOrderItem>` / `List<MetricOrderItem>` — Freezed models with `id` and `display_order` fields.
- `createCategory` and `createMetric` use `Map<String, dynamic>` bodies because the admin CRUD dialogs build the payload dynamically rather than using a fixed Freezed model.
