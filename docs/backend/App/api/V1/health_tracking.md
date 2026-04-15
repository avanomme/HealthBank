# `health_tracking.md` — Health Tracking API (`backend/app/api/v1/health_tracking.py`)

## Overview

`backend/app/api/v1/health_tracking.py` implements the complete health tracking feature across three role groups:

- **Participant** — log daily/weekly/monthly metric entries, view personal history, record baseline snapshot
- **Admin** — manage the metric catalogue (categories, metrics, display order, active state, soft-delete)
- **Researcher** — view k-anonymity-filtered population aggregates, export anonymised CSV

All routes are mounted under `/api/v1/health-tracking`.

---

## Architecture / Design Explanation

### Dynamic Metric Catalogue

No health metrics are hardcoded. All categories and metrics are stored in `TrackingCategory` and `TrackingMetric` tables and can be modified at runtime by admins. The frontend reads the catalogue on load via `GET /metrics` and builds the UI dynamically based on each metric's `metric_type`, `scale_min`/`scale_max`, `choice_options`, and `frequency`.

### Entry Upsert Pattern

Participant entries use a `UNIQUE KEY (ParticipantID, MetricID, EntryDate)` constraint. All writes use `INSERT … ON DUPLICATE KEY UPDATE Value=%s, Notes=%s`. This means:

- Submitting the same metric on the same date is always safe (no duplicates)
- Corrections are applied in-place without deleting the original record
- Batch submissions with mixed new/updated entries work in a single transaction

### Baseline Snapshot

Each `POST /entries` call carries an `is_baseline: bool` flag. When `true`, all entries in the batch are written with `IsBaseline = 1`. These entries are the "before housing" data point for before-vs-after comparisons. The `GET /baseline` endpoint returns only baseline entries so the frontend can determine whether onboarding capture is needed.

### K-Anonymity Enforcement

The k-anonymity threshold is stored in `SystemSettings` and read via `get_int_setting("k_anonymity_threshold")` (cached for 30 seconds). All researcher aggregate queries include:

```sql
HAVING COUNT(DISTINCT ParticipantID) >= %s
```

with the threshold as the second parameter. Data points with fewer than `k` distinct participants are suppressed entirely — they are not returned to the client. This applies to `GET /research/aggregate`, `GET /research/aggregate-multi`, and `GET /research/categories`.

### Participant ID Hashing (CSV Export)

The researcher CSV export endpoint replaces every `ParticipantID` with `hashlib.sha256(str(id).encode()).hexdigest()[:16]` before writing any row to the response stream. The raw participant ID never leaves the server in the export response.

### Soft Delete

Both categories and metrics support soft delete (`IsDeleted = 1`). Soft-deleted items are hidden from participant and researcher endpoints but remain accessible to admin endpoints. Existing `TrackingEntry` rows that reference a soft-deleted metric are preserved — historical data is never lost.

### Input Sanitization

All user-supplied string fields in Pydantic models (`category_key`, `display_name`, `description`, `icon`, `unit`, `choice_options` items, `value`, `notes`) are passed through `sanitized_string()` via `@field_validator("...", mode="before")` decorators. This strips control characters and trims whitespace before any database write.

---

## Configuration

### Enumerations

| Enum | Values | Purpose |
|------|--------|---------|
| `MetricType` | `number`, `scale`, `yesno`, `single_choice`, `text` | Controls input widget and server-side value validation |
| `Frequency` | `daily`, `weekly`, `monthly`, `any` | Shown to participant; not server-enforced |

### Value Validation (`_validate_entry_value`)

Called for every entry in a `POST /entries` batch before the INSERT:

| Type | Validation rule |
|------|-----------------|
| `number` | `float(value)` must not raise |
| `scale` | Integer within `[ScaleMin, ScaleMax]` |
| `yesno` | Value in `{"yes","no","true","false","1","0"}` (case-insensitive) |
| `single_choice` | Value must be in `ChoiceOptions` JSON list |
| `text` | Any sanitized string |

Returns an error string on failure; `None` on success. The endpoint raises HTTP 422 with the error message.

---

## API Reference

All endpoints are relative to the router prefix: `/api/v1/health-tracking`.

### Participant Endpoints (RoleID 1, 4)

#### `GET /metrics`

Returns all active categories with their active metrics nested. Applies language translations when `?lang=` is not `"en"`. Queries `TrackingCategoryTranslation` and `TrackingMetricTranslation` tables.

**Response model:** `List[CategoryResponse]`

#### `POST /entries`

Batch upsert entries. Each entry is independently validated and written. The entire batch is committed in a single transaction. Returns `{"entries_saved": N}`.

**Request model:** `BatchEntrySubmit`

#### `GET /entries`

Return own entries. Dynamically builds a `WHERE` clause from optional query params (`start_date`, `end_date`, `metric_id`, `category_key`).

**Response model:** `List[EntryResponse]`

#### `GET /history/{metric_id}`

Full time-series for one metric. Used to populate the History tab chart.

**Response model:** `List[EntryResponse]`

#### `GET /baseline`

All `IsBaseline = 1` entries for the current participant.

**Response model:** `List[EntryResponse]`

#### `GET /status/today`

Returns today's check-in completion status: count of metrics due today vs. logged today.

**Response model:** `CheckInStatusResponse`

#### `GET /participant/aggregate`

K-anonymity-filtered daily aggregates for a single metric. Same suppression logic as researcher endpoint. Allows participants to compare personal trend to population trend.

#### `GET /participant/export`

Streaming CSV of own entries. No ID hashing (participant is downloading their own data).

---

### Admin Endpoints (RoleID 4)

#### `GET /admin/categories`

All categories including inactive and soft-deleted, with per-category metric counts.

#### `POST /admin/categories`

Create category. `category_key` must be unique (enforced by `UNIQUE` DB constraint → HTTP 409 on duplicate).

**Request model:** `CategoryCreate`

#### `PUT /admin/categories/{id}`

Update category fields.

**Request model:** `CategoryUpdate`

#### `PATCH /admin/categories/{id}/toggle`

Toggle `IsActive`. Returns updated category.

#### `DELETE /admin/categories/{id}`

Soft-delete (`IsDeleted = 1`). Returns `{"message": "..."}`.

#### `PATCH /admin/categories/{id}/restore`

Restore soft-deleted category.

#### `PUT /admin/categories/reorder`

Bulk reorder. Accepts `List[CategoryOrderItem]` (`{id, display_order}`). Applies each item in a loop within one transaction.

#### `GET /admin/metrics`

All metrics with parent category key.

#### `POST /admin/metrics`

Create metric. `metric_key` must be unique.

**Request model:** `MetricCreate`

#### `PUT /admin/metrics/{id}`

Update metric fields.

#### `PATCH /admin/metrics/{id}/toggle`

Toggle `IsActive`.

#### `DELETE /admin/metrics/{id}`

Soft-delete.

#### `PATCH /admin/metrics/{id}/restore`

Restore soft-deleted metric.

#### `PUT /admin/metrics/reorder`

Bulk reorder metrics.

---

### Researcher Endpoints (RoleID 2, 4)

#### `GET /research/aggregate`

Daily aggregate for one metric with k-anonymity suppression.

**Query params:** `metric_id` (required), `start_date`, `end_date`

#### `GET /research/aggregate-multi`

Aggregates for multiple metrics. `metric_ids` is a comma-separated string of IDs. Validates all IDs exist before querying data.

#### `GET /research/categories`

Per-category summary stats.

#### `GET /research/export`

Streaming CSV with hashed participant IDs. `metric_ids` is required.

#### `GET /research/entry-date-range`

Returns `min_date` / `max_date` across all entries. Used to initialize date pickers.

---

## Parameters and Return Types

### Key Request Models

- `CategoryCreate`
  - `category_key: str` (sanitized)
  - `display_name: str` (sanitized)
  - `description: str | None` (sanitized)
  - `icon: str | None` (sanitized)
  - `display_order: int` (default 0)

- `MetricCreate`
  - `category_id: int`
  - `metric_key: str` (sanitized)
  - `display_name: str` (sanitized)
  - `metric_type: MetricType`
  - `unit: str | None` (sanitized)
  - `scale_min: int` (default 1), `scale_max: int` (default 10)
  - `choice_options: List[str] | None` (each item sanitized)
  - `frequency: Frequency` (default daily)
  - `display_order: int` (default 0)

- `EntrySubmit`
  - `metric_id: int`
  - `value: str` (sanitized)
  - `notes: str | None` (sanitized)
  - `entry_date: date` (defaults to `date.today()` server-side)

- `BatchEntrySubmit`
  - `entries: List[EntrySubmit]`
  - `is_baseline: bool` (default `false`)

### Key Response Models

- `CategoryResponse` — category fields + `metrics: List[MetricResponse]`
- `MetricResponse` — all metric fields including `is_deleted`
- `EntryResponse` — entry fields, `entry_date` and `created_at` as `Any` to avoid date serialization issues
- `CheckInStatusResponse` — `is_complete`, `total_due`, `completed_count`, `has_any_due`

---

## Error Handling

### Common HTTP Errors

- `404 Not Found`
  - Metric ID not found in `POST /entries`
  - Category/metric ID not found in admin CRUD endpoints

- `400 Bad Request`
  - Inactive metric submitted in `POST /entries`
  - Invalid metric_ids string in aggregate-multi
  - Attempting to restore a non-deleted item

- `409 Conflict`
  - Duplicate `category_key` or `metric_key` on create (DB unique constraint violation)

- `422 Unprocessable Entity`
  - Entry value fails `_validate_entry_value()` type check

- `500 Internal Server Error`
  - Database errors from `mysql.connector.Error`; all transactions rolled back on error

### Authorization

All participant endpoints call `require_role(1, 4)`. Admin endpoints call `require_role(4)`. Researcher endpoints call `require_role(2, 4)`. Unauthorized callers receive `403 Forbidden` from `require_role`.
