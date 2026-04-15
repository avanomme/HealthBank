# Health Tracking API Documentation

All endpoints require a valid session cookie (`session_token`).
Role IDs: 1 = participant, 2 = researcher, 3 = HCP, 4 = admin.

Router prefix: `/api/v1/health-tracking`
File: `backend/app/api/v1/health_tracking.py`

---

## Participant Endpoints — `/api/v1/health-tracking`

### GET `/api/v1/health-tracking/metrics`

**Roles allowed:** 1, 2, 4

Return all active tracking categories with their active metrics nested inside. Categories and metrics are ordered by `DisplayOrder`. Pass `?lang=fr` to receive French translations where available.

**Query params:**
- `lang: str` (optional, default `"en"`) — language code for metric/category translations

**Response (200):**
```json
[
  {
    "category_id": 1,
    "category_key": "physical_health",
    "display_name": "Physical Health",
    "description": "Physical wellbeing metrics",
    "icon": "health_and_safety",
    "display_order": 1,
    "is_active": true,
    "is_deleted": false,
    "metrics": [
      {
        "metric_id": 1,
        "category_id": 1,
        "metric_key": "sleep_hours",
        "display_name": "Hours of Sleep",
        "description": "Hours slept last night",
        "metric_type": "number",
        "unit": "hours",
        "scale_min": null,
        "scale_max": null,
        "choice_options": null,
        "frequency": "daily",
        "display_order": 1,
        "is_active": true,
        "is_baseline": false,
        "is_deleted": false
      }
    ]
  }
]
```

---

### POST `/api/v1/health-tracking/entries`

**Roles allowed:** 1, 4

Submit a batch of health metric entries. Uses `INSERT … ON DUPLICATE KEY UPDATE` so resending the same `(participant, metric, date)` overwrites the existing value without creating a duplicate. All string values are sanitized server-side.

If `is_baseline` is `true`, all entries in the batch are marked as baseline snapshot entries (used for before-vs-after housing comparison).

**Request body:**
```json
{
  "entries": [
    {
      "metric_id": 1,
      "value": "7.5",
      "notes": "Slept well",
      "entry_date": "2026-04-11"
    },
    {
      "metric_id": 5,
      "value": "yes",
      "notes": null,
      "entry_date": "2026-04-11"
    }
  ],
  "is_baseline": false
}
```

`entry_date` defaults to today (server time) if omitted.

**Value formats by metric type:**
| `metric_type` | Expected format |
|---------------|-----------------|
| `number` | Numeric string, e.g. `"7.5"` |
| `scale` | Integer string within `[scale_min, scale_max]`, e.g. `"8"` |
| `yesno` | `"yes"`, `"no"`, `"true"`, `"false"`, `"1"`, or `"0"` |
| `single_choice` | One of the strings in `choice_options` |
| `text` | Any sanitized string |

**Response (201):**
```json
{ "entries_saved": 3 }
```

**Errors:** 400 (inactive metric), 404 (metric not found), 422 (value fails type validation)

---

### GET `/api/v1/health-tracking/entries`

**Roles allowed:** 1, 4

Return health entries for the current participant, scoped to their account ID. Supports optional filtering.

**Query params:**
- `start_date: date` (optional) — ISO date string, e.g. `2026-01-01`
- `end_date: date` (optional)
- `metric_id: int` (optional)
- `category_key: str` (optional) — e.g. `physical_health`

**Response (200):**
```json
[
  {
    "entry_id": 42,
    "participant_id": 7,
    "metric_id": 1,
    "value": "7.5",
    "notes": "Slept well",
    "entry_date": "2026-04-11",
    "is_baseline": false,
    "created_at": "2026-04-11T09:00:00"
  }
]
```

---

### GET `/api/v1/health-tracking/history/{metric_id}`

**Roles allowed:** 1, 4

Return the full time-series history for a single metric for the current participant. Used to populate the History chart view.

**Response (200):** Same array shape as `/entries`.

---

### GET `/api/v1/health-tracking/baseline`

**Roles allowed:** 1, 4

Return all entries with `IsBaseline = 1` for the current participant. Used to determine whether the participant has recorded their initial baseline snapshot.

**Response (200):** Same array shape as `/entries`, all with `"is_baseline": true`.

---

### GET `/api/v1/health-tracking/status/today`

**Roles allowed:** 1, 4

Return today's check-in completion status — whether the participant has logged all metrics due today.

**Response (200):**
```json
{
  "is_complete": false,
  "total_due": 8,
  "completed_count": 3,
  "has_any_due": true
}
```

---

### GET `/api/v1/health-tracking/participant/aggregate`

**Roles allowed:** 1, 4

Return k-anonymity-filtered daily aggregates for a single metric, allowing participants to see their trend compared to the anonymised population. Uses the same k-anonymity suppression as the researcher endpoint.

**Query params:**
- `metric_id: int` (required)
- `start_date: date` (optional)
- `end_date: date` (optional)

**Response (200):**
```json
[
  {
    "entry_date": "2026-04-10",
    "avg_value": 7.2,
    "min_value": 5.0,
    "max_value": 9.0,
    "participant_count": 12
  }
]
```

---

### GET `/api/v1/health-tracking/participant/export`

**Roles allowed:** 1, 4

Stream a CSV of the participant's own entries. Filename: `health_tracking_export.csv`.

**Query params:**
- `start_date: date` (optional)
- `end_date: date` (optional)
- `metric_ids: str` (optional) — comma-separated metric IDs

**Response:** `text/csv` stream with `Content-Disposition: attachment`.

---

## Admin Endpoints — `/api/v1/health-tracking/admin`

All admin endpoints require RoleID = 4.

### GET `/api/v1/health-tracking/admin/categories`

Return all categories (active, inactive, and soft-deleted) with per-category metric counts.

### POST `/api/v1/health-tracking/admin/categories`

Create a new category. `category_key` must be unique.

**Request body:**
```json
{
  "category_key": "financial_stability",
  "display_name": "Financial Stability",
  "description": "Income and affordability metrics",
  "icon": "account_balance_wallet",
  "display_order": 6
}
```

### PUT `/api/v1/health-tracking/admin/categories/{id}`

Update an existing category's display name, description, icon, display order, or active state.

### PATCH `/api/v1/health-tracking/admin/categories/{id}/toggle`

Toggle `IsActive` for a category. Inactive categories are hidden from participants but their entries are preserved.

### DELETE `/api/v1/health-tracking/admin/categories/{id}`

Soft-delete a category (sets `IsDeleted = 1`). Entries and metrics are not removed.

### PATCH `/api/v1/health-tracking/admin/categories/{id}/restore`

Restore a soft-deleted category.

### PUT `/api/v1/health-tracking/admin/categories/reorder`

Bulk-reorder categories. Accepts an ordered list of `{id, display_order}` objects.

**Request body:**
```json
[
  {"id": 1, "display_order": 0},
  {"id": 3, "display_order": 1},
  {"id": 2, "display_order": 2}
]
```

### GET `/api/v1/health-tracking/admin/metrics`

Return all metrics (active, inactive, and soft-deleted) with their parent category info.

### POST `/api/v1/health-tracking/admin/metrics`

Create a new metric.

**Request body:**
```json
{
  "category_id": 1,
  "metric_key": "exercise_minutes",
  "display_name": "Minutes of Exercise",
  "description": "Total minutes of physical activity",
  "metric_type": "number",
  "unit": "minutes",
  "scale_min": 1,
  "scale_max": 10,
  "choice_options": null,
  "frequency": "daily",
  "display_order": 5
}
```

### PUT `/api/v1/health-tracking/admin/metrics/{id}`

Update a metric's fields.

### PATCH `/api/v1/health-tracking/admin/metrics/{id}/toggle`

Toggle `IsActive` for a metric.

### DELETE `/api/v1/health-tracking/admin/metrics/{id}`

Soft-delete a metric (sets `IsDeleted = 1`). Existing entries for this metric are preserved.

### PATCH `/api/v1/health-tracking/admin/metrics/{id}/restore`

Restore a soft-deleted metric.

### PUT `/api/v1/health-tracking/admin/metrics/reorder`

Bulk-reorder metrics within a category.

---

## Researcher Endpoints — `/api/v1/health-tracking/research`

**Roles allowed:** 2, 4

### GET `/api/v1/health-tracking/research/aggregate`

Return daily aggregate stats for a single metric, filtered to rows where `COUNT(DISTINCT ParticipantID) >= k_anonymity_threshold`. Data points with fewer than the threshold number of participants are suppressed entirely.

**Query params:**
- `metric_id: int` (required)
- `start_date: date` (optional)
- `end_date: date` (optional)

**Response (200):**
```json
[
  {
    "entry_date": "2026-04-10",
    "avg_value": 7.2,
    "min_value": 5.0,
    "max_value": 9.0,
    "participant_count": 12
  }
]
```

---

### GET `/api/v1/health-tracking/research/aggregate-multi`

Return aggregates for multiple metrics in a single request.

**Query params:**
- `metric_ids: str` (required) — comma-separated list of metric IDs, e.g. `1,2,5`
- `start_date: date` (optional)
- `end_date: date` (optional)

**Response (200):** Array of `{metric_id, metric_key, display_name, data_points: [...]}`.

---

### GET `/api/v1/health-tracking/research/categories`

Return per-category summary stats (entry count, distinct participants, date range). Only includes categories where distinct participant count passes the k-anonymity threshold.

---

### GET `/api/v1/health-tracking/research/export`

Stream a CSV of anonymised entries. Participant IDs are replaced with the first 16 hex characters of their SHA-256 hash.

**Query params:**
- `metric_ids: str` (required) — comma-separated IDs
- `start_date: date` (optional)
- `end_date: date` (optional)

**Response:** `text/csv` stream. Columns: `participant_hash, metric_key, entry_date, value, is_baseline`.

---

### GET `/api/v1/health-tracking/research/entry-date-range`

Return the earliest and latest entry dates across all metrics, used to set default date range pickers.

**Response (200):**
```json
{ "min_date": "2026-01-01", "max_date": "2026-04-11" }
```

---

## Database Schema

```sql
-- Admin-configurable tracking categories
CREATE TABLE TrackingCategory (
    CategoryID   INT AUTO_INCREMENT PRIMARY KEY,
    CategoryKey  VARCHAR(64) UNIQUE NOT NULL,
    DisplayName  VARCHAR(128) NOT NULL,
    Description  TEXT,
    Icon         VARCHAR(64),
    DisplayOrder INT DEFAULT 0,
    IsActive     TINYINT(1) DEFAULT 1,
    IsDeleted    TINYINT(1) DEFAULT 0,
    CreatedAt    DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt    DATETIME ON UPDATE CURRENT_TIMESTAMP
);

-- Metrics linked to categories
CREATE TABLE TrackingMetric (
    MetricID     INT AUTO_INCREMENT PRIMARY KEY,
    CategoryID   INT NOT NULL REFERENCES TrackingCategory(CategoryID),
    MetricKey    VARCHAR(64) UNIQUE NOT NULL,
    DisplayName  VARCHAR(128) NOT NULL,
    Description  TEXT,
    MetricType   ENUM('number','scale','yesno','single_choice','text') NOT NULL,
    Unit         VARCHAR(32),
    ScaleMin     INT DEFAULT 1,
    ScaleMax     INT DEFAULT 10,
    ChoiceOptions JSON,
    Frequency    ENUM('daily','weekly','monthly','any') DEFAULT 'daily',
    DisplayOrder INT DEFAULT 0,
    IsActive     TINYINT(1) DEFAULT 1,
    IsBaseline   TINYINT(1) DEFAULT 0,
    IsDeleted    TINYINT(1) DEFAULT 0,
    CreatedAt    DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Participant entries — one row per participant per metric per date
CREATE TABLE TrackingEntry (
    EntryID       INT AUTO_INCREMENT PRIMARY KEY,
    ParticipantID INT NOT NULL REFERENCES AccountData(AccountID),
    MetricID      INT NOT NULL REFERENCES TrackingMetric(MetricID),
    Value         TEXT NOT NULL,
    Notes         TEXT,
    EntryDate     DATE NOT NULL,
    IsBaseline    TINYINT(1) DEFAULT 0,
    CreatedAt     DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_entry (ParticipantID, MetricID, EntryDate)
);

-- Optional: translated display names per language
CREATE TABLE TrackingCategoryTranslation (
    CategoryID   INT NOT NULL REFERENCES TrackingCategory(CategoryID),
    LanguageCode VARCHAR(8) NOT NULL,
    DisplayName  VARCHAR(128),
    Description  TEXT,
    PRIMARY KEY (CategoryID, LanguageCode)
);

CREATE TABLE TrackingMetricTranslation (
    MetricID     INT NOT NULL REFERENCES TrackingMetric(MetricID),
    LanguageCode VARCHAR(8) NOT NULL,
    DisplayName  VARCHAR(128),
    Description  TEXT,
    PRIMARY KEY (MetricID, LanguageCode)
);
```

The `UNIQUE KEY uq_entry (ParticipantID, MetricID, EntryDate)` constraint enforces one entry per participant per metric per day and enables the upsert pattern on `POST /entries`.
