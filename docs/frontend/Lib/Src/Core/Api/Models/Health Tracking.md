# Health Tracking Models (`health_tracking.dart`)

**File:** `frontend/lib/src/core/api/models/health_tracking.dart`
**Generated files:** `health_tracking.freezed.dart`, `health_tracking.g.dart`

All models use Freezed + `json_serializable`. Run `dart run build_runner build --delete-conflicting-outputs` after any model change.

---

## Date Serialization Helpers

Two top-level functions handle the `yyyy-MM-dd` date format used by the backend for entry dates:

```dart
String healthTrackingDateToJson(DateTime d) => DateFormat('yyyy-MM-dd').format(d);
DateTime healthTrackingDateFromJson(dynamic s) => DateTime.parse(s as String);
```

These are referenced in `@JsonKey(toJson: ..., fromJson: ...)` annotations on `TrackingEntry.entryDate`.

---

## Models

### `TrackingCategory`

Matches `CategoryResponse` from the backend. Contains a nested list of its metrics.

| Field | Type | JSON key | Description |
|-------|------|----------|-------------|
| `categoryId` | `int` | `category_id` | DB primary key |
| `categoryKey` | `String` | `category_key` | Stable programmatic key, e.g. `physical_health` |
| `displayName` | `String` | `display_name` | Localized label |
| `description` | `String?` | `description` | |
| `icon` | `String?` | `icon` | Material icon name |
| `displayOrder` | `int` | `display_order` | Sort order |
| `isActive` | `bool` | `is_active` | |
| `isDeleted` | `bool` | `is_deleted` | Default `false` |
| `metrics` | `List<TrackingMetric>` | `metrics` | Default `[]` |

---

### `TrackingMetric`

Matches `MetricResponse`. Nested inside `TrackingCategory`.

| Field | Type | JSON key | Description |
|-------|------|----------|-------------|
| `metricId` | `int` | `metric_id` | DB primary key |
| `categoryId` | `int` | `category_id` | Parent category |
| `metricKey` | `String` | `metric_key` | Stable key, e.g. `sleep_hours` |
| `displayName` | `String` | `display_name` | Localized label |
| `description` | `String?` | `description` | |
| `metricType` | `String` | `metric_type` | `number`, `scale`, `yesno`, `single_choice`, `text` |
| `unit` | `String?` | `unit` | e.g. `hours`, `glasses` |
| `scaleMin` | `int?` | `scale_min` | For scale type |
| `scaleMax` | `int?` | `scale_max` | For scale type |
| `choiceOptions` | `List<String>?` | `choice_options` | For single_choice type |
| `frequency` | `String` | `frequency` | `daily`, `weekly`, `monthly`, `any` |
| `displayOrder` | `int` | `display_order` | |
| `isActive` | `bool` | `is_active` | |
| `isBaseline` | `bool` | `is_baseline` | Included in baseline snapshot |
| `isDeleted` | `bool` | `is_deleted` | Default `false` |

---

### `TrackingEntry`

Matches `EntryResponse`. Represents one logged value for one metric on one date.

| Field | Type | JSON key | Description |
|-------|------|----------|-------------|
| `entryId` | `int` | `entry_id` | |
| `participantId` | `int` | `participant_id` | |
| `metricId` | `int` | `metric_id` | |
| `value` | `String` | `value` | Stored as string for all metric types |
| `notes` | `String?` | `notes` | |
| `entryDate` | `DateTime` | `entry_date` | Uses `healthTrackingDateFromJson` |
| `isBaseline` | `bool` | `is_baseline` | |
| `createdAt` | `dynamic` | `created_at` | Kept as `dynamic` to avoid date/datetime serialization issues |

---

### `TrackingEntrySubmit`

Request model for individual entries within a `BatchEntrySubmit`.

| Field | Type | JSON key | Description |
|-------|------|----------|-------------|
| `metricId` | `int` | `metric_id` | |
| `value` | `String` | `value` | Must match metric's type |
| `notes` | `String?` | `notes` | |
| `entryDate` | `DateTime?` | `entry_date` | Null = server defaults to today; uses `healthTrackingDateToJson` |

---

### `BatchEntrySubmit`

Outer wrapper for `POST /health-tracking/entries`.

| Field | Type | JSON key | Description |
|-------|------|----------|-------------|
| `entries` | `List<TrackingEntrySubmit>` | `entries` | |
| `isBaseline` | `bool` | `is_baseline` | Default `false` |

---

### `HealthCheckInStatus`

Matches `CheckInStatusResponse`.

| Field | Type | JSON key | Description |
|-------|------|----------|-------------|
| `isComplete` | `bool` | `is_complete` | All due metrics logged today |
| `totalDue` | `int` | `total_due` | Metrics due today |
| `completedCount` | `int` | `completed_count` | Metrics logged today |
| `hasAnyDue` | `bool` | `has_any_due` | Whether any metrics are due today |

---

### `AggregateDataPoint`

Used by both participant and researcher aggregate endpoints.

| Field | Type | JSON key | Description |
|-------|------|----------|-------------|
| `entryDate` | `String` | `entry_date` | Date string |
| `avgValue` | `double?` | `avg_value` | |
| `minValue` | `double?` | `min_value` | |
| `maxValue` | `double?` | `max_value` | |
| `participantCount` | `int` | `participant_count` | Distinct participants contributing to this data point |

---

### `CategoryOrderItem` / `MetricOrderItem`

Used by reorder endpoints.

```dart
@freezed
class CategoryOrderItem with _$CategoryOrderItem {
  const factory CategoryOrderItem({
    required int id,
    @JsonKey(name: 'display_order') required int displayOrder,
  }) = _CategoryOrderItem;
}
```

---

## Notes

- All models use `@JsonSerializable(explicitToJson: true)` so nested objects serialize correctly.
- `TrackingCategory.metrics` has `@Default(<TrackingMetric>[])` so a missing `metrics` key in JSON is treated as an empty list rather than a null error.
- The `is_deleted` field defaults to `false` to maintain compatibility when admin endpoints return this field but participant endpoints do not.
