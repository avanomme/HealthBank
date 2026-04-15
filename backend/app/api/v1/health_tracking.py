# Created with the Assistance of Claude Code
# backend/app/api/v1/health_tracking.py
"""
Health Tracking API

Endpoints:

Participant (RoleID=1, 4):
- GET  /health-tracking/metrics               - List active categories with nested metrics (supports ?lang=)
- POST /health-tracking/entries               - Submit a batch of metric entries (upsert)
- GET  /health-tracking/entries               - List entries filtered by date range / metric / category
- GET  /health-tracking/history/{metric_id}   - Full history for one metric
- GET  /health-tracking/baseline              - All baseline entries for this participant

Admin (RoleID=4):
- GET    /health-tracking/admin/categories           - All categories with metric counts
- POST   /health-tracking/admin/categories           - Create category
- PUT    /health-tracking/admin/categories/{id}      - Update category
- GET    /health-tracking/admin/metrics              - All metrics with category info
- POST   /health-tracking/admin/metrics              - Create metric
- PUT    /health-tracking/admin/metrics/{id}         - Update metric
- PATCH  /health-tracking/admin/metrics/{id}/toggle  - Toggle IsActive
- PUT    /health-tracking/admin/metrics/reorder      - Bulk reorder metrics

Researcher (RoleID=2, 4):
- GET /health-tracking/research/aggregate    - Aggregated values per day (k-anon filtered)
- GET /health-tracking/research/export       - CSV export with hashed participant IDs
- GET /health-tracking/research/categories   - Category summary stats (k-anon filtered)

SECURITY: All queries use parameterized statements to prevent SQL injection.
"""

import csv
import hashlib
import io
import json
import logging
from datetime import date
from enum import Enum
from typing import Any, Dict, List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from fastapi.responses import StreamingResponse
from pydantic import BaseModel, field_validator

from ...services.settings import get_int_setting
from ...utils.utils import get_db_connection
from ..deps import require_role, sanitized_string

logger = logging.getLogger(__name__)

router = APIRouter()


# ---------------------------------------------------------------------------
# Enums
# ---------------------------------------------------------------------------

class MetricType(str, Enum):
    number = "number"
    scale = "scale"
    yesno = "yesno"
    single_choice = "single_choice"
    text = "text"


class Frequency(str, Enum):
    daily = "daily"
    weekly = "weekly"
    monthly = "monthly"
    any_time = "any"


# ---------------------------------------------------------------------------
# Pydantic models
# ---------------------------------------------------------------------------

class MetricResponse(BaseModel):
    metric_id: int
    category_id: int
    metric_key: str
    display_name: str
    description: Optional[str]
    metric_type: str
    unit: Optional[str]
    scale_min: Optional[int]
    scale_max: Optional[int]
    choice_options: Optional[List[str]]
    frequency: str
    display_order: int
    is_active: bool
    is_baseline: bool
    is_deleted: bool = False


class CategoryResponse(BaseModel):
    category_id: int
    category_key: str
    display_name: str
    description: Optional[str]
    icon: Optional[str]
    display_order: int
    is_active: bool
    is_deleted: bool = False
    metrics: List[MetricResponse]


class EntrySubmit(BaseModel):
    metric_id: int
    value: str
    notes: Optional[str] = None
    entry_date: date = None  # defaults to today in endpoint

    @field_validator("value", mode="before")
    @classmethod
    def sanitize_value(cls, v):
        return sanitized_string(v)

    @field_validator("notes", mode="before")
    @classmethod
    def sanitize_notes(cls, v):
        return sanitized_string(v)


class BatchEntrySubmit(BaseModel):
    entries: List[EntrySubmit]
    is_baseline: bool = False


class EntryResponse(BaseModel):
    entry_id: int
    participant_id: int
    metric_id: int
    value: str
    notes: Optional[str]
    entry_date: Any  # date — kept as Any to avoid serialisation issues with date vs datetime
    is_baseline: bool
    created_at: Any


class CategoryCreate(BaseModel):
    category_key: str
    display_name: str
    description: Optional[str] = None
    icon: Optional[str] = None
    display_order: int = 0

    @field_validator("category_key", mode="before")
    @classmethod
    def sanitize_key(cls, v):
        return sanitized_string(v)

    @field_validator("display_name", mode="before")
    @classmethod
    def sanitize_name(cls, v):
        return sanitized_string(v)

    @field_validator("description", mode="before")
    @classmethod
    def sanitize_desc(cls, v):
        return sanitized_string(v)

    @field_validator("icon", mode="before")
    @classmethod
    def sanitize_icon(cls, v):
        return sanitized_string(v)


class MetricCreate(BaseModel):
    category_id: int
    metric_key: str
    display_name: str
    description: Optional[str] = None
    metric_type: MetricType = MetricType.number
    unit: Optional[str] = None
    scale_min: int = 1
    scale_max: int = 10
    choice_options: Optional[List[str]] = None
    frequency: Frequency = Frequency.daily
    display_order: int = 0

    @field_validator("metric_key", mode="before")
    @classmethod
    def sanitize_key(cls, v):
        return sanitized_string(v)

    @field_validator("display_name", mode="before")
    @classmethod
    def sanitize_name(cls, v):
        return sanitized_string(v)

    @field_validator("description", mode="before")
    @classmethod
    def sanitize_desc(cls, v):
        return sanitized_string(v)

    @field_validator("unit", mode="before")
    @classmethod
    def sanitize_unit(cls, v):
        return sanitized_string(v)

    @field_validator("choice_options", mode="before")
    @classmethod
    def sanitize_choices(cls, v):
        if not v:
            return v
        return [sanitized_string(item) if isinstance(item, str) else item for item in v]


# ---------------------------------------------------------------------------
# Validation helpers
# ---------------------------------------------------------------------------

VALID_YESNO = {"yes", "no", "true", "false", "1", "0"}


def _validate_entry_value(value: str, metric_type: str, scale_min: int, scale_max: int,
                           choice_options: Optional[List[str]]) -> Optional[str]:
    """Return an error message if value does not match metric_type, else None."""
    if metric_type == "number":
        try:
            float(value)
        except (ValueError, TypeError):
            return f"Expected a numeric value, got '{value}'"

    elif metric_type == "scale":
        try:
            n = int(value)
            if not (scale_min <= n <= scale_max):
                return f"Scale value must be between {scale_min} and {scale_max}, got '{value}'"
        except (ValueError, TypeError):
            return f"Expected an integer scale value, got '{value}'"

    elif metric_type == "yesno":
        if value.lower() not in VALID_YESNO:
            return f"Expected yes/no value, got '{value}'"

    elif metric_type == "single_choice":
        if choice_options and value not in choice_options:
            return f"'{value}' is not a valid option. Valid: {choice_options}"

    # text accepts any string
    return None


def _parse_choice_options(raw: Optional[str]) -> Optional[List[str]]:
    """Parse JSON-encoded choice_options stored in DB."""
    if raw is None:
        return None
    try:
        parsed = json.loads(raw)
        if isinstance(parsed, list):
            return [str(s) for s in parsed]
    except (json.JSONDecodeError, TypeError, ValueError):
        pass
    return None


def _row_to_entry_response(row: dict) -> EntryResponse:
    return EntryResponse(
        entry_id=row["EntryID"],
        participant_id=row["ParticipantID"],
        metric_id=row["MetricID"],
        value=row["Value"],
        notes=row.get("Notes"),
        entry_date=row["EntryDate"],
        is_baseline=bool(row["IsBaseline"]),
        created_at=row["CreatedAt"],
    )


# ---------------------------------------------------------------------------
# Participant endpoints
# ---------------------------------------------------------------------------

@router.get("/metrics", response_model=List[CategoryResponse])
def get_metrics(
    lang: str = Query("en"),
    current_user: dict = Depends(require_role(1, 2, 4)),
):
    """Return all active tracking categories with their active metrics nested inside."""
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        # Fetch active categories ordered by DisplayOrder
        cur.execute(
            """
            SELECT CategoryID, CategoryKey, DisplayName, Description, Icon,
                   DisplayOrder, IsActive
            FROM TrackingCategory
            WHERE IsActive = 1 AND IsDeleted = 0
            ORDER BY DisplayOrder ASC
            """
        )
        cat_rows = cur.fetchall()

        categories: List[CategoryResponse] = []
        for cat in cat_rows:
            cat_id = cat["CategoryID"]

            # Apply translation for category if available
            cat_display_name = cat["DisplayName"]
            cat_description = cat["Description"]
            if lang not in ("en", ""):
                cur.execute(
                    """
                    SELECT DisplayName, Description
                    FROM TrackingCategoryTranslation
                    WHERE CategoryID = %s AND LanguageCode = %s
                    """,
                    (cat_id, lang),
                )
                trans = cur.fetchone()
                if trans:
                    cat_display_name = trans["DisplayName"] or cat_display_name
                    cat_description = trans["Description"] or cat_description

            # Fetch active metrics for this category
            cur.execute(
                """
                SELECT MetricID, CategoryID, MetricKey, DisplayName, Description,
                       MetricType, Unit, ScaleMin, ScaleMax, ChoiceOptions,
                       Frequency, DisplayOrder, IsActive, IsBaseline
                FROM TrackingMetric
                WHERE CategoryID = %s AND IsActive = 1 AND IsDeleted = 0
                ORDER BY DisplayOrder ASC
                """,
                (cat_id,),
            )
            metric_rows = cur.fetchall()

            metrics: List[MetricResponse] = []
            for m in metric_rows:
                metric_id = m["MetricID"]
                m_display_name = m["DisplayName"]
                m_description = m["Description"]

                # Apply translation for metric if available
                if lang not in ("en", ""):
                    cur.execute(
                        """
                        SELECT DisplayName, Description
                        FROM TrackingMetricTranslation
                        WHERE MetricID = %s AND LanguageCode = %s
                        """,
                        (metric_id, lang),
                    )
                    mtrans = cur.fetchone()
                    if mtrans:
                        m_display_name = mtrans["DisplayName"] or m_display_name
                        m_description = mtrans["Description"] or m_description

                metrics.append(MetricResponse(
                    metric_id=metric_id,
                    category_id=m["CategoryID"],
                    metric_key=m["MetricKey"],
                    display_name=m_display_name,
                    description=m_description,
                    metric_type=m["MetricType"],
                    unit=m["Unit"],
                    scale_min=m["ScaleMin"],
                    scale_max=m["ScaleMax"],
                    choice_options=_parse_choice_options(m["ChoiceOptions"]),
                    frequency=m["Frequency"],
                    display_order=m["DisplayOrder"],
                    is_active=bool(m["IsActive"]),
                    is_baseline=bool(m["IsBaseline"]),
                ))

            categories.append(CategoryResponse(
                category_id=cat_id,
                category_key=cat["CategoryKey"],
                display_name=cat_display_name,
                description=cat_description,
                icon=cat["Icon"],
                display_order=cat["DisplayOrder"],
                is_active=bool(cat["IsActive"]),
                metrics=metrics,
            ))

        return categories
    finally:
        cur.close()
        conn.close()


@router.post("/entries", status_code=201)
def submit_entries(
    body: BatchEntrySubmit,
    current_user: dict = Depends(require_role(1, 4)),
):
    """Submit a batch of health metric entries for the current participant."""
    participant_id = current_user["effective_account_id"]
    today = date.today()

    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        saved = 0
        for entry in body.entries:
            entry_date = entry.entry_date if entry.entry_date is not None else today

            # Validate metric exists and is active
            cur.execute(
                """
                SELECT MetricID, MetricType, ScaleMin, ScaleMax, ChoiceOptions, IsActive
                FROM TrackingMetric
                WHERE MetricID = %s
                """,
                (entry.metric_id,),
            )
            metric = cur.fetchone()
            if not metric:
                raise HTTPException(status_code=404, detail=f"Metric {entry.metric_id} not found")
            if not metric["IsActive"]:
                raise HTTPException(status_code=400, detail=f"Metric {entry.metric_id} is not active")

            choice_options = _parse_choice_options(metric["ChoiceOptions"])
            error = _validate_entry_value(
                entry.value,
                metric["MetricType"],
                metric["ScaleMin"],
                metric["ScaleMax"],
                choice_options,
            )
            if error:
                raise HTTPException(status_code=422, detail=error)

            # Upsert: INSERT ... ON DUPLICATE KEY UPDATE
            cur.execute(
                """
                INSERT INTO TrackingEntry
                    (ParticipantID, MetricID, Value, Notes, EntryDate, IsBaseline)
                VALUES (%s, %s, %s, %s, %s, %s)
                ON DUPLICATE KEY UPDATE
                    Value = %s,
                    Notes = %s
                """,
                (
                    participant_id, entry.metric_id, entry.value, entry.notes,
                    entry_date, int(body.is_baseline),
                    entry.value, entry.notes,
                ),
            )
            saved += 1

        conn.commit()
        return {"entries_saved": saved}

    except HTTPException:
        raise
    except Exception as e:
        logger.error("Failed to submit health entries: %s", e, exc_info=True)
        conn.rollback()
        raise HTTPException(status_code=500, detail="Failed to submit entries")
    finally:
        cur.close()
        conn.close()


@router.get("/entries", response_model=List[EntryResponse])
def get_entries(
    start_date: Optional[date] = Query(None),
    end_date: Optional[date] = Query(None),
    metric_id: Optional[int] = Query(None),
    category_key: Optional[str] = Query(None),
    current_user: dict = Depends(require_role(1, 4)),
):
    """Return health entries for the current participant filtered by date range."""
    participant_id = current_user["effective_account_id"]

    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        query = """
            SELECT te.EntryID, te.ParticipantID, te.MetricID, te.Value,
                   te.Notes, te.EntryDate, te.IsBaseline, te.CreatedAt
            FROM TrackingEntry te
            JOIN TrackingMetric tm ON tm.MetricID = te.MetricID
            JOIN TrackingCategory tc ON tc.CategoryID = tm.CategoryID
            WHERE te.ParticipantID = %s
        """
        params: List[Any] = [participant_id]

        if start_date is not None:
            query += " AND te.EntryDate >= %s"
            params.append(start_date)
        if end_date is not None:
            query += " AND te.EntryDate <= %s"
            params.append(end_date)
        if metric_id is not None:
            query += " AND te.MetricID = %s"
            params.append(metric_id)
        if category_key is not None:
            query += " AND tc.CategoryKey = %s"
            params.append(category_key)

        query += " ORDER BY te.EntryDate DESC, te.EntryID DESC"

        cur.execute(query, tuple(params))
        rows = cur.fetchall()
        return [_row_to_entry_response(r) for r in rows]
    finally:
        cur.close()
        conn.close()


@router.get("/history/{metric_id}", response_model=List[EntryResponse])
def get_metric_history(
    metric_id: int,
    current_user: dict = Depends(require_role(1, 4)),
):
    """Return all entries for this participant for a specific metric, ordered oldest first."""
    participant_id = current_user["effective_account_id"]

    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(
            """
            SELECT EntryID, ParticipantID, MetricID, Value, Notes,
                   EntryDate, IsBaseline, CreatedAt
            FROM TrackingEntry
            WHERE ParticipantID = %s AND MetricID = %s
            ORDER BY EntryDate ASC, EntryID ASC
            """,
            (participant_id, metric_id),
        )
        rows = cur.fetchall()
        return [_row_to_entry_response(r) for r in rows]
    finally:
        cur.close()
        conn.close()


# ---------------------------------------------------------------------------
# Today's check-in status
# ---------------------------------------------------------------------------

class CheckInStatusResponse(BaseModel):
    is_complete: bool
    total_due: int
    completed_count: int
    has_any_due: bool


@router.get("/status/today", response_model=CheckInStatusResponse)
def get_today_check_in_status(
    current_user: dict = Depends(require_role(1, 4)),
):
    """Return whether today's health check-in is complete.

    A metric counts as 'due' based on its frequency:
      - daily:   not yet submitted for today's date
      - weekly:  not yet submitted in the current ISO week (Mon – Sun)
      - monthly: not yet submitted in the current calendar month
      - any:     never counts toward the required check-in
    Baseline entries are excluded.
    """
    from datetime import timedelta

    participant_id = current_user["effective_account_id"]
    today = date.today()
    week_start = today - timedelta(days=today.weekday())   # Monday
    month_start = today.replace(day=1)

    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(
            """
            SELECT MetricID, Frequency
            FROM TrackingMetric
            WHERE IsActive = 1 AND IsDeleted = 0 AND IsBaseline = 0
              AND Frequency != 'any'
            """,
        )
        metrics = cur.fetchall()

        if not metrics:
            return CheckInStatusResponse(
                is_complete=True,
                total_due=0,
                completed_count=0,
                has_any_due=False,
            )

        # Only count metrics that the Log Today page actually shows:
        #   daily  → always shown
        #   weekly → shown on Sunday (weekday 6 in Python)
        #   monthly→ shown on the 1st of the month
        show_weekly = today.weekday() == 6   # Sunday
        show_monthly = today.day == 1

        total_due = 0
        completed_count = 0

        for m in metrics:
            metric_id = m["MetricID"]
            freq = m["Frequency"]

            if freq == "daily":
                total_due += 1
                cur.execute(
                    """
                    SELECT 1 FROM TrackingEntry
                    WHERE ParticipantID = %s AND MetricID = %s
                      AND EntryDate = %s AND IsBaseline = 0
                    LIMIT 1
                    """,
                    (participant_id, metric_id, today),
                )
            elif freq == "weekly":
                if not show_weekly:
                    continue
                total_due += 1
                cur.execute(
                    """
                    SELECT 1 FROM TrackingEntry
                    WHERE ParticipantID = %s AND MetricID = %s
                      AND EntryDate BETWEEN %s AND %s AND IsBaseline = 0
                    LIMIT 1
                    """,
                    (participant_id, metric_id, week_start, today),
                )
            elif freq == "monthly":
                if not show_monthly:
                    continue
                total_due += 1
                cur.execute(
                    """
                    SELECT 1 FROM TrackingEntry
                    WHERE ParticipantID = %s AND MetricID = %s
                      AND EntryDate BETWEEN %s AND %s AND IsBaseline = 0
                    LIMIT 1
                    """,
                    (participant_id, metric_id, month_start, today),
                )
            else:
                continue

            if cur.fetchone():
                completed_count += 1

        return CheckInStatusResponse(
            is_complete=completed_count >= total_due and total_due > 0,
            total_due=total_due,
            completed_count=completed_count,
            has_any_due=total_due > 0,
        )
    finally:
        cur.close()
        conn.close()


@router.get("/baseline", response_model=List[EntryResponse])
def get_baseline(
    current_user: dict = Depends(require_role(1, 4)),
):
    """Return all baseline entries for the current participant."""
    participant_id = current_user["effective_account_id"]

    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(
            """
            SELECT EntryID, ParticipantID, MetricID, Value, Notes,
                   EntryDate, IsBaseline, CreatedAt
            FROM TrackingEntry
            WHERE ParticipantID = %s AND IsBaseline = 1
            ORDER BY EntryDate ASC, EntryID ASC
            """,
            (participant_id,),
        )
        rows = cur.fetchall()
        return [_row_to_entry_response(r) for r in rows]
    finally:
        cur.close()
        conn.close()


# ---------------------------------------------------------------------------
# Participant self-service endpoints (aggregate comparison + CSV export)
# ---------------------------------------------------------------------------

@router.get("/participant/aggregate")
def participant_aggregate(
    metric_id: int = Query(...),
    start_date: Optional[date] = Query(None),
    end_date: Optional[date] = Query(None),
    current_user: dict = Depends(require_role(1, 4)),
):
    """
    Return k-anonymity-filtered daily aggregate stats for a metric so
    participants can compare their own trends to the population average.
    Identical calculation to /research/aggregate but accessible to role 1.
    """
    k = get_int_setting("k_anonymity_threshold")

    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        query = """
            SELECT EntryDate,
                   COUNT(DISTINCT ParticipantID) AS participant_count,
                   AVG(CAST(Value AS DECIMAL(10,2))) AS avg_value
            FROM TrackingEntry
            WHERE MetricID = %s
        """
        params: List[Any] = [metric_id]

        if start_date is not None:
            query += " AND EntryDate >= %s"
            params.append(start_date)
        if end_date is not None:
            query += " AND EntryDate <= %s"
            params.append(end_date)

        query += " GROUP BY EntryDate HAVING COUNT(DISTINCT ParticipantID) >= %s ORDER BY EntryDate ASC"
        params.append(k)

        cur.execute(query, tuple(params))
        rows = cur.fetchall()
        return [
            {
                "entry_date": r["EntryDate"],
                "avg_value": float(r["avg_value"]) if r["avg_value"] is not None else None,
                "participant_count": r["participant_count"],
            }
            for r in rows
        ]
    finally:
        cur.close()
        conn.close()


@router.get("/participant/export")
def participant_export(
    start_date: Optional[date] = Query(None),
    end_date: Optional[date] = Query(None),
    metric_ids: Optional[str] = Query(None),
    current_user: dict = Depends(require_role(1, 4)),
):
    """
    CSV export of the current participant's own health tracking entries.
    Columns: category_key, metric_key, entry_date, value, notes
    metric_ids: optional comma-separated metric IDs to filter.
    """
    participant_id = current_user["effective_account_id"]

    ids_filter: Optional[List[int]] = None
    if metric_ids:
        try:
            ids_filter = [int(x.strip()) for x in metric_ids.split(",") if x.strip()]
        except ValueError:
            raise HTTPException(status_code=400, detail="metric_ids must be comma-separated integers")

    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        query = """
            SELECT tc.CategoryKey, tm.MetricKey, te.EntryDate, te.Value, te.Notes
            FROM TrackingEntry te
            JOIN TrackingMetric tm ON tm.MetricID = te.MetricID
            JOIN TrackingCategory tc ON tc.CategoryID = tm.CategoryID
            WHERE te.ParticipantID = %s
        """
        params: List[Any] = [participant_id]

        if start_date is not None:
            query += " AND te.EntryDate >= %s"
            params.append(start_date)
        if end_date is not None:
            query += " AND te.EntryDate <= %s"
            params.append(end_date)
        if ids_filter:
            placeholders = ",".join(["%s"] * len(ids_filter))
            query += f" AND te.MetricID IN ({placeholders})"
            params.extend(ids_filter)

        query += " ORDER BY te.EntryDate ASC, tc.CategoryKey ASC, tm.MetricKey ASC"

        cur.execute(query, tuple(params))
        rows = cur.fetchall()

        output = io.StringIO()
        writer = csv.writer(output)
        writer.writerow(["category_key", "metric_key", "entry_date", "value", "notes"])
        for r in rows:
            writer.writerow([
                r["CategoryKey"],
                r["MetricKey"],
                r["EntryDate"],
                r["Value"],
                r["Notes"] or "",
            ])

        output.seek(0)
        return StreamingResponse(
            iter([output.getvalue()]),
            media_type="text/csv",
            headers={"Content-Disposition": "attachment; filename=my_health_tracking_export.csv"},
        )
    finally:
        cur.close()
        conn.close()


# ---------------------------------------------------------------------------
# Admin endpoints
# ---------------------------------------------------------------------------

@router.get("/admin/categories")
def admin_list_categories(
    current_user: dict = Depends(require_role(4)),
):
    """Return all categories (active and inactive) with metric counts."""
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(
            """
            SELECT c.CategoryID, c.CategoryKey, c.DisplayName, c.Description,
                   c.Icon, c.DisplayOrder, c.IsActive, c.IsDeleted,
                   COUNT(m.MetricID) AS MetricCount
            FROM TrackingCategory c
            LEFT JOIN TrackingMetric m ON m.CategoryID = c.CategoryID
            GROUP BY c.CategoryID, c.CategoryKey, c.DisplayName, c.Description,
                     c.Icon, c.DisplayOrder, c.IsActive, c.IsDeleted
            ORDER BY c.DisplayOrder ASC
            """
        )
        rows = cur.fetchall()
        return [
            {
                "category_id": r["CategoryID"],
                "category_key": r["CategoryKey"],
                "display_name": r["DisplayName"],
                "description": r["Description"],
                "icon": r["Icon"],
                "display_order": r["DisplayOrder"],
                "is_active": bool(r["IsActive"]),
                "is_deleted": bool(r["IsDeleted"]),
                "metric_count": r["MetricCount"],
            }
            for r in rows
        ]
    finally:
        cur.close()
        conn.close()


@router.post("/admin/categories", status_code=201)
def admin_create_category(
    body: CategoryCreate,
    current_user: dict = Depends(require_role(4)),
):
    """Create a new tracking category."""
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        # Enforce unique category_key
        cur.execute(
            "SELECT CategoryID FROM TrackingCategory WHERE CategoryKey = %s",
            (body.category_key,),
        )
        if cur.fetchone():
            raise HTTPException(status_code=409, detail="A category with that key already exists")

        cur.execute(
            """
            INSERT INTO TrackingCategory
                (CategoryKey, DisplayName, Description, Icon, DisplayOrder, IsActive)
            VALUES (%s, %s, %s, %s, %s, 1)
            """,
            (body.category_key, body.display_name, body.description, body.icon, body.display_order),
        )
        conn.commit()
        new_id = cur.lastrowid

        cur.execute(
            """
            SELECT CategoryID, CategoryKey, DisplayName, Description, Icon, DisplayOrder, IsActive
            FROM TrackingCategory WHERE CategoryID = %s
            """,
            (new_id,),
        )
        row = cur.fetchone()
        return {
            "category_id": row["CategoryID"],
            "category_key": row["CategoryKey"],
            "display_name": row["DisplayName"],
            "description": row["Description"],
            "icon": row["Icon"],
            "display_order": row["DisplayOrder"],
            "is_active": bool(row["IsActive"]),
        }
    except HTTPException:
        raise
    except Exception as e:
        logger.error("Failed to create category: %s", e, exc_info=True)
        conn.rollback()
        raise HTTPException(status_code=500, detail="Failed to create category")
    finally:
        cur.close()
        conn.close()


@router.put("/admin/categories/reorder")
def admin_reorder_categories(
    body: List[Dict[str, int]],
    current_user: dict = Depends(require_role(4)),
):
    """Bulk-update DisplayOrder for a list of categories. Body: [{category_id, display_order}, ...]"""
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        for item in body:
            cur.execute(
                "UPDATE TrackingCategory SET DisplayOrder = %s WHERE CategoryID = %s",
                (item["display_order"], item["category_id"]),
            )
        conn.commit()
        return {"updated": len(body)}
    except HTTPException:
        raise
    except Exception as e:
        logger.error("Failed to reorder categories: %s", e, exc_info=True)
        conn.rollback()
        raise HTTPException(status_code=500, detail="Failed to reorder categories")
    finally:
        cur.close()
        conn.close()


@router.put("/admin/categories/{category_id}")
def admin_update_category(
    category_id: int,
    body: CategoryCreate,
    current_user: dict = Depends(require_role(4)),
):
    """Update an existing tracking category."""
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(
            "SELECT CategoryID FROM TrackingCategory WHERE CategoryID = %s",
            (category_id,),
        )
        if not cur.fetchone():
            raise HTTPException(status_code=404, detail="Category not found")

        cur.execute(
            """
            UPDATE TrackingCategory
            SET CategoryKey = %s, DisplayName = %s, Description = %s,
                Icon = %s, DisplayOrder = %s
            WHERE CategoryID = %s
            """,
            (body.category_key, body.display_name, body.description,
             body.icon, body.display_order, category_id),
        )
        conn.commit()

        cur.execute(
            """
            SELECT CategoryID, CategoryKey, DisplayName, Description, Icon, DisplayOrder, IsActive
            FROM TrackingCategory WHERE CategoryID = %s
            """,
            (category_id,),
        )
        row = cur.fetchone()
        return {
            "category_id": row["CategoryID"],
            "category_key": row["CategoryKey"],
            "display_name": row["DisplayName"],
            "description": row["Description"],
            "icon": row["Icon"],
            "display_order": row["DisplayOrder"],
            "is_active": bool(row["IsActive"]),
        }
    except HTTPException:
        raise
    except Exception as e:
        logger.error("Failed to update category: %s", e, exc_info=True)
        conn.rollback()
        raise HTTPException(status_code=500, detail="Failed to update category")
    finally:
        cur.close()
        conn.close()


@router.delete("/admin/categories/{category_id}", status_code=204)
def admin_delete_category(
    category_id: int,
    current_user: dict = Depends(require_role(4)),
):
    """Soft-delete a category (sets IsActive=False). Existing entries are preserved."""
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(
            "SELECT CategoryID FROM TrackingCategory WHERE CategoryID = %s",
            (category_id,),
        )
        if not cur.fetchone():
            raise HTTPException(status_code=404, detail="Category not found")

        cur.execute(
            "UPDATE TrackingCategory SET IsDeleted = 1, IsActive = 0 WHERE CategoryID = %s",
            (category_id,),
        )
        # Also mark all metrics in this category as deleted.
        cur.execute(
            "UPDATE TrackingMetric SET IsDeleted = 1, IsActive = 0 WHERE CategoryID = %s",
            (category_id,),
        )
        conn.commit()
        return None
    except HTTPException:
        raise
    except Exception as e:
        logger.error("Failed to delete category: %s", e, exc_info=True)
        conn.rollback()
        raise HTTPException(status_code=500, detail="Failed to delete category")
    finally:
        cur.close()
        conn.close()


@router.delete("/admin/metrics/{metric_id}", status_code=204)
def admin_delete_metric(
    metric_id: int,
    current_user: dict = Depends(require_role(4)),
):
    """Soft-delete a metric (sets IsActive=False). Existing entries are preserved."""
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(
            "SELECT MetricID FROM TrackingMetric WHERE MetricID = %s",
            (metric_id,),
        )
        if not cur.fetchone():
            raise HTTPException(status_code=404, detail="Metric not found")

        cur.execute(
            "UPDATE TrackingMetric SET IsDeleted = 1, IsActive = 0 WHERE MetricID = %s",
            (metric_id,),
        )
        conn.commit()
        return None
    except HTTPException:
        raise
    except Exception as e:
        logger.error("Failed to delete metric: %s", e, exc_info=True)
        conn.rollback()
        raise HTTPException(status_code=500, detail="Failed to delete metric")
    finally:
        cur.close()
        conn.close()


@router.patch("/admin/categories/{category_id}/restore", status_code=200)
def admin_restore_category(
    category_id: int,
    current_user: dict = Depends(require_role(4)),
):
    """Restore a soft-deleted category (sets IsActive=True)."""
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(
            "SELECT CategoryID FROM TrackingCategory WHERE CategoryID = %s",
            (category_id,),
        )
        if not cur.fetchone():
            raise HTTPException(status_code=404, detail="Category not found")

        cur.execute(
            "UPDATE TrackingCategory SET IsDeleted = 0, IsActive = 1 WHERE CategoryID = %s",
            (category_id,),
        )
        conn.commit()
        return {"category_id": category_id, "is_active": True, "is_deleted": False}
    except HTTPException:
        raise
    except Exception as e:
        logger.error("Failed to restore category: %s", e, exc_info=True)
        conn.rollback()
        raise HTTPException(status_code=500, detail="Failed to restore category")
    finally:
        cur.close()
        conn.close()


@router.patch("/admin/metrics/{metric_id}/restore", status_code=200)
def admin_restore_metric(
    metric_id: int,
    current_user: dict = Depends(require_role(4)),
):
    """Restore a soft-deleted metric (sets IsActive=True)."""
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(
            "SELECT MetricID FROM TrackingMetric WHERE MetricID = %s",
            (metric_id,),
        )
        if not cur.fetchone():
            raise HTTPException(status_code=404, detail="Metric not found")

        cur.execute(
            "UPDATE TrackingMetric SET IsDeleted = 0, IsActive = 1 WHERE MetricID = %s",
            (metric_id,),
        )
        conn.commit()
        return {"metric_id": metric_id, "is_active": True, "is_deleted": False}
    except HTTPException:
        raise
    except Exception as e:
        logger.error("Failed to restore metric: %s", e, exc_info=True)
        conn.rollback()
        raise HTTPException(status_code=500, detail="Failed to restore metric")
    finally:
        cur.close()
        conn.close()


@router.patch("/admin/categories/{category_id}/toggle")
def admin_toggle_category(
    category_id: int,
    current_user: dict = Depends(require_role(4)),
):
    """Toggle IsActive on a category without deleting it."""
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(
            "SELECT CategoryID, IsActive FROM TrackingCategory WHERE CategoryID = %s",
            (category_id,),
        )
        row = cur.fetchone()
        if not row:
            raise HTTPException(status_code=404, detail="Category not found")

        new_active = 0 if row["IsActive"] else 1
        cur.execute(
            "UPDATE TrackingCategory SET IsActive = %s WHERE CategoryID = %s",
            (new_active, category_id),
        )
        conn.commit()
        return {"category_id": category_id, "is_active": bool(new_active)}
    except HTTPException:
        raise
    except Exception as e:
        logger.error("Failed to toggle category: %s", e, exc_info=True)
        conn.rollback()
        raise HTTPException(status_code=500, detail="Failed to toggle category")
    finally:
        cur.close()
        conn.close()


@router.get("/admin/metrics")
def admin_list_metrics(
    current_user: dict = Depends(require_role(4)),
):
    """Return all metrics (active and inactive) with their category key and name."""
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(
            """
            SELECT m.MetricID, m.CategoryID, c.CategoryKey, c.DisplayName AS CategoryName,
                   m.MetricKey, m.DisplayName, m.Description, m.MetricType, m.Unit,
                   m.ScaleMin, m.ScaleMax, m.ChoiceOptions, m.Frequency,
                   m.DisplayOrder, m.IsActive, m.IsBaseline, m.IsDeleted
            FROM TrackingMetric m
            JOIN TrackingCategory c ON c.CategoryID = m.CategoryID
            ORDER BY m.CategoryID ASC, m.DisplayOrder ASC
            """
        )
        rows = cur.fetchall()
        return [
            {
                "metric_id": r["MetricID"],
                "category_id": r["CategoryID"],
                "category_key": r["CategoryKey"],
                "category_name": r["CategoryName"],
                "metric_key": r["MetricKey"],
                "display_name": r["DisplayName"],
                "description": r["Description"],
                "metric_type": r["MetricType"],
                "unit": r["Unit"],
                "scale_min": r["ScaleMin"],
                "scale_max": r["ScaleMax"],
                "choice_options": _parse_choice_options(r["ChoiceOptions"]),
                "frequency": r["Frequency"],
                "display_order": r["DisplayOrder"],
                "is_active": bool(r["IsActive"]),
                "is_baseline": bool(r["IsBaseline"]),
                "is_deleted": bool(r["IsDeleted"]),
            }
            for r in rows
        ]
    finally:
        cur.close()
        conn.close()


@router.post("/admin/metrics", status_code=201)
def admin_create_metric(
    body: MetricCreate,
    current_user: dict = Depends(require_role(4)),
):
    """Create a new tracking metric."""
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        # Validate category exists
        cur.execute(
            "SELECT CategoryID FROM TrackingCategory WHERE CategoryID = %s",
            (body.category_id,),
        )
        if not cur.fetchone():
            raise HTTPException(status_code=404, detail="Category not found")

        choice_options_json = json.dumps(body.choice_options) if body.choice_options is not None else None

        cur.execute(
            """
            INSERT INTO TrackingMetric
                (CategoryID, MetricKey, DisplayName, Description, MetricType, Unit,
                 ScaleMin, ScaleMax, ChoiceOptions, Frequency, DisplayOrder,
                 IsActive, IsBaseline, CreatedBy)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 1, 0, %s)
            """,
            (
                body.category_id, body.metric_key, body.display_name, body.description,
                body.metric_type.value, body.unit, body.scale_min, body.scale_max,
                choice_options_json, body.frequency.value, body.display_order,
                current_user["effective_account_id"],
            ),
        )
        conn.commit()
        new_id = cur.lastrowid

        cur.execute(
            """
            SELECT MetricID, CategoryID, MetricKey, DisplayName, Description, MetricType,
                   Unit, ScaleMin, ScaleMax, ChoiceOptions, Frequency, DisplayOrder,
                   IsActive, IsBaseline
            FROM TrackingMetric WHERE MetricID = %s
            """,
            (new_id,),
        )
        row = cur.fetchone()
        return {
            "metric_id": row["MetricID"],
            "category_id": row["CategoryID"],
            "metric_key": row["MetricKey"],
            "display_name": row["DisplayName"],
            "description": row["Description"],
            "metric_type": row["MetricType"],
            "unit": row["Unit"],
            "scale_min": row["ScaleMin"],
            "scale_max": row["ScaleMax"],
            "choice_options": _parse_choice_options(row["ChoiceOptions"]),
            "frequency": row["Frequency"],
            "display_order": row["DisplayOrder"],
            "is_active": bool(row["IsActive"]),
            "is_baseline": bool(row["IsBaseline"]),
        }
    except HTTPException:
        raise
    except Exception as e:
        logger.error("Failed to create metric: %s", e, exc_info=True)
        conn.rollback()
        raise HTTPException(status_code=500, detail="Failed to create metric")
    finally:
        cur.close()
        conn.close()


@router.put("/admin/metrics/reorder")
def admin_reorder_metrics(
    body: List[Dict[str, int]],
    current_user: dict = Depends(require_role(4)),
):
    """Bulk-update DisplayOrder for a list of metrics. Body: [{metric_id, display_order}, ...]"""
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        for item in body:
            cur.execute(
                "UPDATE TrackingMetric SET DisplayOrder = %s WHERE MetricID = %s",
                (item["display_order"], item["metric_id"]),
            )
        conn.commit()
        return {"updated": len(body)}
    except HTTPException:
        raise
    except Exception as e:
        logger.error("Failed to reorder metrics: %s", e, exc_info=True)
        conn.rollback()
        raise HTTPException(status_code=500, detail="Failed to reorder metrics")
    finally:
        cur.close()
        conn.close()


@router.put("/admin/metrics/{metric_id}")
def admin_update_metric(
    metric_id: int,
    body: MetricCreate,
    current_user: dict = Depends(require_role(4)),
):
    """Update an existing tracking metric."""
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(
            "SELECT MetricID FROM TrackingMetric WHERE MetricID = %s",
            (metric_id,),
        )
        if not cur.fetchone():
            raise HTTPException(status_code=404, detail="Metric not found")

        choice_options_json = json.dumps(body.choice_options) if body.choice_options is not None else None

        cur.execute(
            """
            UPDATE TrackingMetric
            SET CategoryID = %s, MetricKey = %s, DisplayName = %s, Description = %s,
                MetricType = %s, Unit = %s, ScaleMin = %s, ScaleMax = %s,
                ChoiceOptions = %s, Frequency = %s, DisplayOrder = %s
            WHERE MetricID = %s
            """,
            (
                body.category_id, body.metric_key, body.display_name, body.description,
                body.metric_type.value, body.unit, body.scale_min, body.scale_max,
                choice_options_json, body.frequency.value, body.display_order,
                metric_id,
            ),
        )
        conn.commit()

        cur.execute(
            """
            SELECT MetricID, CategoryID, MetricKey, DisplayName, Description, MetricType,
                   Unit, ScaleMin, ScaleMax, ChoiceOptions, Frequency, DisplayOrder,
                   IsActive, IsBaseline
            FROM TrackingMetric WHERE MetricID = %s
            """,
            (metric_id,),
        )
        row = cur.fetchone()
        return {
            "metric_id": row["MetricID"],
            "category_id": row["CategoryID"],
            "metric_key": row["MetricKey"],
            "display_name": row["DisplayName"],
            "description": row["Description"],
            "metric_type": row["MetricType"],
            "unit": row["Unit"],
            "scale_min": row["ScaleMin"],
            "scale_max": row["ScaleMax"],
            "choice_options": _parse_choice_options(row["ChoiceOptions"]),
            "frequency": row["Frequency"],
            "display_order": row["DisplayOrder"],
            "is_active": bool(row["IsActive"]),
            "is_baseline": bool(row["IsBaseline"]),
        }
    except HTTPException:
        raise
    except Exception as e:
        logger.error("Failed to update metric: %s", e, exc_info=True)
        conn.rollback()
        raise HTTPException(status_code=500, detail="Failed to update metric")
    finally:
        cur.close()
        conn.close()


@router.patch("/admin/metrics/{metric_id}/toggle")
def admin_toggle_metric(
    metric_id: int,
    current_user: dict = Depends(require_role(4)),
):
    """Toggle IsActive on a metric (1 → 0 or 0 → 1)."""
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(
            "SELECT MetricID, IsActive FROM TrackingMetric WHERE MetricID = %s",
            (metric_id,),
        )
        row = cur.fetchone()
        if not row:
            raise HTTPException(status_code=404, detail="Metric not found")

        new_active = 0 if row["IsActive"] else 1
        cur.execute(
            "UPDATE TrackingMetric SET IsActive = %s WHERE MetricID = %s",
            (new_active, metric_id),
        )
        conn.commit()
        return {"metric_id": metric_id, "is_active": bool(new_active)}
    except HTTPException:
        raise
    except Exception as e:
        logger.error("Failed to toggle metric: %s", e, exc_info=True)
        conn.rollback()
        raise HTTPException(status_code=500, detail="Failed to toggle metric")
    finally:
        cur.close()
        conn.close()


# ---------------------------------------------------------------------------
# Researcher endpoints
# ---------------------------------------------------------------------------

@router.get("/research/entry-date-range")
def research_entry_date_range(
    current_user: dict = Depends(require_role(2, 4)),
):
    """Return the earliest and latest TrackingEntry dates across all participants."""
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(
            """
            SELECT
                MIN(EntryDate) AS min_date,
                MAX(EntryDate) AS max_date
            FROM TrackingEntry
            """
        )
        row = cur.fetchone()
        return {
            "min_date": row["min_date"].isoformat() if row and row["min_date"] else None,
            "max_date": row["max_date"].isoformat() if row and row["max_date"] else None,
        }
    finally:
        cur.close()
        conn.close()


@router.get("/research/aggregate-multi")
def research_aggregate_multi(
    metric_ids: str = Query(...),
    start_date: Optional[date] = Query(None),
    end_date: Optional[date] = Query(None),
    current_user: dict = Depends(require_role(2, 4)),
):
    """Return daily aggregate stats for multiple metrics simultaneously.

    metric_ids is a comma-separated string of integer metric IDs, e.g. "1,2,3".
    Each item in the response contains the metric_id, metric display name,
    category display name, and a list of k-anonymity-filtered data points.
    """
    try:
        ids = [int(x.strip()) for x in metric_ids.split(",") if x.strip()]
    except ValueError:
        raise HTTPException(status_code=400, detail="metric_ids must be comma-separated integers")
    if not ids:
        raise HTTPException(status_code=400, detail="At least one metric_id is required")
    metric_ids_list = ids

    k = get_int_setting("k_anonymity_threshold") or 5
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        # Validate all requested metric IDs exist
        placeholders = ",".join(["%s"] * len(metric_ids_list))
        cur.execute(
            f"""
            SELECT tm.MetricID, tm.DisplayName AS metric_name,
                   tc.DisplayName AS category_name
            FROM TrackingMetric tm
            JOIN TrackingCategory tc ON tc.CategoryID = tm.CategoryID
            WHERE tm.MetricID IN ({placeholders})
            ORDER BY tc.DisplayOrder ASC, tm.DisplayOrder ASC
            """,
            tuple(metric_ids_list),
        )
        metric_info = {r["MetricID"]: r for r in cur.fetchall()}

        results = []
        for metric_id in metric_ids_list:
            if metric_id not in metric_info:
                continue  # skip unknown IDs silently

            params: list = [metric_id]
            date_filters = ""
            if start_date is not None:
                date_filters += " AND te.EntryDate >= %s"
                params.append(start_date)
            if end_date is not None:
                date_filters += " AND te.EntryDate <= %s"
                params.append(end_date)
            params.append(k)  # HAVING clause — must be last

            cur.execute(
                f"""
                SELECT te.EntryDate AS entry_date,
                       AVG(CAST(te.Value AS DECIMAL(10,4))) AS avg_value,
                       COUNT(DISTINCT te.ParticipantID) AS participant_count
                FROM TrackingEntry te
                WHERE te.MetricID = %s
                  {date_filters}
                GROUP BY te.EntryDate
                HAVING COUNT(DISTINCT te.ParticipantID) >= %s
                ORDER BY te.EntryDate ASC
                """,
                tuple(params),
            )
            data_points = [
                {
                    "entry_date": r["entry_date"].isoformat(),
                    "avg_value": float(r["avg_value"]),
                    "participant_count": r["participant_count"],
                }
                for r in cur.fetchall()
            ]

            info = metric_info[metric_id]
            results.append({
                "metric_id": metric_id,
                "metric_name": info["metric_name"],
                "category_name": info["category_name"],
                "data": data_points,
            })

        return results
    finally:
        cur.close()
        conn.close()


@router.get("/research/aggregate")
def research_aggregate(
    metric_id: int = Query(...),
    start_date: Optional[date] = Query(None),
    end_date: Optional[date] = Query(None),
    current_user: dict = Depends(require_role(2, 4)),
):
    """
    Return daily aggregate stats for a metric.
    Only includes rows where distinct participant count >= k_anonymity_threshold.
    """
    k = get_int_setting("k_anonymity_threshold")

    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        query = """
            SELECT EntryDate,
                   COUNT(DISTINCT ParticipantID) AS participant_count,
                   AVG(CAST(Value AS DECIMAL(10,2))) AS avg_value
            FROM TrackingEntry
            WHERE MetricID = %s
        """
        params: List[Any] = [metric_id]

        if start_date is not None:
            query += " AND EntryDate >= %s"
            params.append(start_date)
        if end_date is not None:
            query += " AND EntryDate <= %s"
            params.append(end_date)

        query += " GROUP BY EntryDate HAVING COUNT(DISTINCT ParticipantID) >= %s ORDER BY EntryDate ASC"
        params.append(k)

        cur.execute(query, tuple(params))
        rows = cur.fetchall()
        return [
            {
                "entry_date": r["EntryDate"],
                "avg_value": float(r["avg_value"]) if r["avg_value"] is not None else None,
                "participant_count": r["participant_count"],
            }
            for r in rows
        ]
    finally:
        cur.close()
        conn.close()


@router.get("/research/export")
def research_export(
    start_date: Optional[date] = Query(None),
    end_date: Optional[date] = Query(None),
    category_key: Optional[str] = Query(None),
    metric_ids: Optional[str] = Query(None),
    current_user: dict = Depends(require_role(2, 4)),
):
    """
    CSV export of health entries with SHA-256 hashed participant IDs.
    Columns: hashed_participant_id, category_key, metric_key, entry_date, value, frequency

    metric_ids: optional comma-separated list of metric IDs to filter the export.
    """
    # Parse optional metric_ids filter
    ids_filter: Optional[List[int]] = None
    if metric_ids:
        try:
            ids_filter = [int(x.strip()) for x in metric_ids.split(",") if x.strip()]
        except ValueError:
            raise HTTPException(status_code=400, detail="metric_ids must be comma-separated integers")

    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        query = """
            SELECT te.ParticipantID, tc.CategoryKey, tm.MetricKey,
                   te.EntryDate, te.Value, tm.Frequency,
                   ad.Gender, ad.Birthdate
            FROM TrackingEntry te
            JOIN TrackingMetric tm ON tm.MetricID = te.MetricID
            JOIN TrackingCategory tc ON tc.CategoryID = tm.CategoryID
            LEFT JOIN AccountData ad ON ad.AccountID = te.ParticipantID
            WHERE 1=1
        """
        params: List[Any] = []

        if start_date is not None:
            query += " AND te.EntryDate >= %s"
            params.append(start_date)
        if end_date is not None:
            query += " AND te.EntryDate <= %s"
            params.append(end_date)
        if category_key is not None:
            query += " AND tc.CategoryKey = %s"
            params.append(category_key)
        if ids_filter:
            placeholders = ",".join(["%s"] * len(ids_filter))
            query += f" AND te.MetricID IN ({placeholders})"
            params.extend(ids_filter)

        query += " ORDER BY te.EntryDate ASC, te.ParticipantID ASC"

        cur.execute(query, tuple(params))
        rows = cur.fetchall()

        output = io.StringIO()
        writer = csv.writer(output)
        writer.writerow(["hashed_participant_id", "category_key", "metric_key",
                         "entry_date", "value", "frequency",
                         "gender", "date_of_birth"])

        for r in rows:
            hashed_id = hashlib.sha256(str(r["ParticipantID"]).encode()).hexdigest()
            writer.writerow([
                hashed_id,
                r["CategoryKey"],
                r["MetricKey"],
                r["EntryDate"],
                r["Value"],
                r["Frequency"],
                r.get("Gender") or "",
                r["Birthdate"].isoformat() if r.get("Birthdate") else "",
            ])

        output.seek(0)
        return StreamingResponse(
            iter([output.getvalue()]),
            media_type="text/csv",
            headers={"Content-Disposition": "attachment; filename=health_tracking_export.csv"},
        )
    finally:
        cur.close()
        conn.close()


@router.get("/research/categories")
def research_categories(
    current_user: dict = Depends(require_role(2, 4)),
):
    """
    Return per-category summary stats.
    Only includes categories where distinct participant count >= k_anonymity_threshold.
    """
    k = get_int_setting("k_anonymity_threshold")

    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(
            """
            SELECT tc.CategoryID, tc.CategoryKey, tc.DisplayName,
                   COUNT(DISTINCT te.ParticipantID) AS participant_count,
                   COUNT(te.EntryID) AS total_entries,
                   MAX(te.EntryDate) AS most_recent_entry
            FROM TrackingCategory tc
            JOIN TrackingMetric tm ON tm.CategoryID = tc.CategoryID
            JOIN TrackingEntry te ON te.MetricID = tm.MetricID
            WHERE tc.IsActive = 1
            GROUP BY tc.CategoryID, tc.CategoryKey, tc.DisplayName
            HAVING COUNT(DISTINCT te.ParticipantID) >= %s
            ORDER BY tc.DisplayOrder ASC
            """,
            (k,),
        )
        rows = cur.fetchall()
        return [
            {
                "category_id": r["CategoryID"],
                "category_key": r["CategoryKey"],
                "display_name": r["DisplayName"],
                "participant_count": r["participant_count"],
                "total_entries": r["total_entries"],
                "most_recent_entry": r["most_recent_entry"],
            }
            for r in rows
        ]
    finally:
        cur.close()
        conn.close()
