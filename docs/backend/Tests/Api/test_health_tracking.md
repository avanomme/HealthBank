# `test_health_tracking.md` — Health Tracking Tests (`backend/tests/api/test_health_tracking.py`)

## Overview

`backend/tests/api/test_health_tracking.py` covers the full health tracking API. Tests use the shared `FakeConnection`/`FakeCursor` mock infrastructure from `tests/mocks/db.py` and the `mock_auth` autouse fixture from `conftest.py`.

---

## Test Structure

Tests are organized into four groups:

| Group | Description |
|-------|-------------|
| Participant | GET metrics, POST entries (batch upsert), GET entries/history/baseline |
| Admin | CRUD categories and metrics, toggle, reorder, soft-delete, restore |
| Researcher | Aggregate endpoint, k-anonymity suppression, CSV export, category summary |
| Auth enforcement | Role-gated endpoints return 403 for wrong roles |

---

## Testing Patterns

### Auth Override

The `mock_auth` autouse fixture in `conftest.py` injects an admin account (RoleID=4) by default. Tests that need a different role use the `clear_auth_override` fixture and set `app.dependency_overrides[get_current_user]` directly:

```python
def test_researcher_aggregate(client, clear_auth_override):
    app.dependency_overrides[get_current_user] = lambda: {
        "account_id": 2, "effective_account_id": 2, "role_id": 2
    }
    response = client.get("/api/v1/health-tracking/research/aggregate?metric_id=1")
    assert response.status_code == 200
```

### DB Mock Pattern

```python
@patch("app.api.v1.health_tracking.get_db_connection")
def test_submit_entries(mock_db, client):
    conn = MagicMock()
    cur = MagicMock()
    cur.fetchone.return_value = {
        "MetricID": 1, "MetricType": "scale",
        "ScaleMin": 1, "ScaleMax": 10,
        "ChoiceOptions": None, "IsActive": 1
    }
    conn.cursor.return_value = cur
    mock_db.return_value = conn
    ...
```

### K-Anonymity Suppression Test

Aggregate endpoints must suppress data points when `participant_count < k_threshold`. Tests mock `get_int_setting` to return a threshold and set cursor results with counts below it:

```python
@patch("app.api.v1.health_tracking.get_int_setting", return_value=5)
@patch("app.api.v1.health_tracking.get_db_connection")
def test_aggregate_k_anon_suppression(mock_db, mock_setting, client):
    # Return rows that already passed HAVING in SQL (mocked)
    cur.fetchall.return_value = [
        {"EntryDate": "2026-04-01", "avg_value": 7.0,
         "min_value": 5.0, "max_value": 9.0, "participant_count": 6}
    ]
    response = client.get("/api/v1/health-tracking/research/aggregate?metric_id=1")
    assert response.status_code == 200
    assert len(response.json()) == 1
```

---

## Coverage Areas

### Participant

- `GET /metrics` returns categories with nested metrics
- `GET /metrics?lang=fr` applies French translations when available
- `POST /entries` accepts valid batch (returns 201, `entries_saved` count)
- `POST /entries` validates each `metric_type`:
  - `scale` value out of range → 422
  - `yesno` invalid string → 422
  - `single_choice` not in options → 422
  - `number` non-numeric → 422
- `POST /entries` with inactive metric → 400
- `POST /entries` with unknown metric → 404
- `GET /entries` returns own entries, respects date filters
- `GET /history/{metric_id}` returns time-series
- `GET /baseline` returns only `IsBaseline=1` entries
- `GET /status/today` returns check-in status

### Admin

- `GET /admin/categories` returns all including inactive/deleted
- `POST /admin/categories` creates and returns 201
- `PUT /admin/categories/{id}` updates fields
- `PATCH /admin/categories/{id}/toggle` toggles IsActive
- `DELETE /admin/categories/{id}` soft-deletes
- `PATCH /admin/categories/{id}/restore` restores
- `PUT /admin/categories/reorder` applies bulk display order
- Same CRUD coverage for metrics

### Researcher

- `GET /research/aggregate` returns data points
- `GET /research/aggregate-multi` returns data for multiple metrics
- `GET /research/categories` returns category stats
- `GET /research/export` returns CSV with hashed participant IDs
- `GET /research/entry-date-range` returns min/max dates

### Auth Enforcement

- Participant endpoints reject RoleID=2 with 403
- Researcher endpoints reject RoleID=1 with 403
- Admin endpoints reject RoleID=1 and RoleID=2 with 403

---

## Notes

- The upsert test submits the same `(participant, metric, date)` twice and verifies `entries_saved=1` both times (mock cursor `rowcount=1`).
- CSV export test reads the raw response text, splits on newlines, and validates the header row and that participant IDs are hex strings not integers.
- K-anonymity is enforced in SQL via `HAVING`. Unit tests mock the DB result set (which already reflects suppression) and verify the response body does not include suppressed rows.
