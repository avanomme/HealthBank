# Created with the Assistance of Claude Code
# backend/app/api/v1/hcp_patients.py
"""HCP patient data access endpoints.

Allows HCPs to view their linked patients' surveys and responses.
All queries use parameterized %s placeholders (no string interpolation).
Auth: require_role() from app.api.deps.
Access is gated on an active HcpPatientLink where ConsentRevoked=0.
"""
import csv
import io
import json
import logging
from datetime import date
from typing import Any, List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from fastapi.responses import StreamingResponse

from ...utils.utils import get_db_connection
from ..deps import require_role

logger = logging.getLogger(__name__)

router = APIRouter(tags=["hcp-patients"])


def _parse_choice_options(raw: Optional[str]) -> Optional[List[str]]:
    if raw is None:
        return None
    try:
        parsed = json.loads(raw)
        if isinstance(parsed, list):
            return [str(s) for s in parsed]
    except (json.JSONDecodeError, TypeError, ValueError):
        pass
    return None


# ── Helpers ───────────────────────────────────────────────────────────────────

def _verify_hcp_access(hcp_id: int, patient_id: int, cursor) -> None:
    """Raise 403 if no active, non-revoked link exists between hcp_id and patient_id."""
    cursor.execute(
        """
        SELECT LinkID
        FROM HcpPatientLink
        WHERE HcpID = %s
          AND PatientID = %s
          AND Status = 'active'
          AND ConsentRevoked = 0
        """,
        (hcp_id, patient_id),
    )
    if not cursor.fetchone():
        raise HTTPException(
            status_code=403,
            detail="No active consented link between this HCP and patient",
        )


# ── Endpoints ─────────────────────────────────────────────────────────────────

@router.get("/hcp/patients")
def list_hcp_patients(
    hcp_id: Optional[int] = Query(None, description="Admin only: filter by HCP account ID"),
    current_user: dict = Depends(require_role(3, 4)),
):
    """List patients linked to the calling HCP (or a specified HCP for admins).

    Returns patients where the link is active and consent has not been revoked.
    Admins may supply ?hcp_id= to query on behalf of any HCP.
    """
    caller_id = current_user["effective_account_id"]
    caller_role = current_user["effective_role_id"]

    # Determine which HCP's patients to list
    if caller_role == 4:
        # Admin: use supplied hcp_id param if given, otherwise return all patients for all HCPs
        target_hcp_id = hcp_id  # may be None (admin sees all)
    else:
        # HCP: always query their own patients
        target_hcp_id = caller_id

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        if target_hcp_id is not None:
            cursor.execute(
                """
                SELECT
                    l.LinkID AS link_id,
                    l.PatientID AS patient_id,
                    CONCAT(
                        COALESCE(p.FirstName, ''), ' ', COALESCE(p.LastName, '')
                    ) AS patient_name,
                    l.RequestedAt AS linked_since
                FROM HcpPatientLink l
                JOIN AccountData p ON p.AccountID = l.PatientID
                WHERE l.HcpID = %s
                  AND l.Status = 'active'
                  AND l.ConsentRevoked = 0
                ORDER BY l.RequestedAt DESC
                """,
                (target_hcp_id,),
            )
        else:
            # Admin with no hcp_id filter — return all active, consented links
            cursor.execute(
                """
                SELECT
                    l.LinkID AS link_id,
                    l.PatientID AS patient_id,
                    CONCAT(
                        COALESCE(p.FirstName, ''), ' ', COALESCE(p.LastName, '')
                    ) AS patient_name,
                    l.RequestedAt AS linked_since
                FROM HcpPatientLink l
                JOIN AccountData p ON p.AccountID = l.PatientID
                WHERE l.Status = 'active'
                  AND l.ConsentRevoked = 0
                ORDER BY l.RequestedAt DESC
                """,
            )
        rows = cursor.fetchall()
        return rows
    finally:
        cursor.close()
        conn.close()


@router.get("/hcp/patients/{patient_id}/surveys")
def get_patient_surveys(
    patient_id: int,
    current_user: dict = Depends(require_role(3, 4)),
):
    """Return completed surveys for a linked patient.

    Verifies that the calling HCP has an active, consented link to the patient.
    Admins bypass the link check.
    """
    caller_id = current_user["effective_account_id"]
    caller_role = current_user["effective_role_id"]

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        if caller_role != 4:
            _verify_hcp_access(caller_id, patient_id, cursor)

        cursor.execute(
            """
            SELECT
                sa.AssignmentID AS assignment_id,
                sa.SurveyID AS survey_id,
                s.Title AS survey_title,
                sa.CompletedAt AS completed_at
            FROM SurveyAssignment sa
            JOIN Survey s ON s.SurveyID = sa.SurveyID
            WHERE sa.AccountID = %s
              AND sa.Status = 'completed'
            ORDER BY sa.CompletedAt DESC
            """,
            (patient_id,),
        )
        rows = cursor.fetchall()
        return rows
    finally:
        cursor.close()
        conn.close()


@router.get("/hcp/patients/{patient_id}/responses/{survey_id}")
def get_patient_responses(
    patient_id: int,
    survey_id: int,
    current_user: dict = Depends(require_role(3, 4)),
):
    """Return a patient's responses for a specific survey.

    Verifies that the calling HCP has an active, consented link to the patient.
    Admins bypass the link check.
    Returns 404 if the survey does not exist or the patient has no responses.
    """
    caller_id = current_user["effective_account_id"]
    caller_role = current_user["effective_role_id"]

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        if caller_role != 4:
            _verify_hcp_access(caller_id, patient_id, cursor)

        cursor.execute(
            """
            SELECT
                r.QuestionID AS question_id,
                qb.QuestionContent AS question_content,
                qb.ResponseType AS response_type,
                r.ResponseValue AS response_value
            FROM Responses r
            JOIN QuestionBank qb ON qb.QuestionID = r.QuestionID
            WHERE r.SurveyID = %s
              AND r.ParticipantID = %s
            ORDER BY r.QuestionID
            """,
            (survey_id, patient_id),
        )
        rows = cursor.fetchall()
        if not rows:
            raise HTTPException(
                status_code=404,
                detail="No responses found for this patient and survey",
            )
        return rows
    finally:
        cursor.close()
        conn.close()


# ── Health Tracking endpoints ─────────────────────────────────────────────────

@router.get("/hcp/patients/{patient_id}/health-tracking/metrics")
def get_patient_health_metrics(
    patient_id: int,
    current_user: dict = Depends(require_role(3, 4)),
):
    """Return active tracking categories and metrics for a linked patient.

    Verifies that the calling HCP has an active, consented link to the patient.
    Admins bypass the link check. Returns the same category/metric structure
    that participants see so HCPs can build a metric picker.
    """
    caller_id = current_user["effective_account_id"]
    caller_role = current_user["effective_role_id"]

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        if caller_role != 4:
            _verify_hcp_access(caller_id, patient_id, cursor)

        cursor.execute(
            """
            SELECT CategoryID, CategoryKey, DisplayName, Description, Icon, DisplayOrder
            FROM TrackingCategory
            WHERE IsActive = 1 AND IsDeleted = 0
            ORDER BY DisplayOrder ASC
            """
        )
        cat_rows = cursor.fetchall()

        results = []
        for cat in cat_rows:
            cursor.execute(
                """
                SELECT MetricID, CategoryID, MetricKey, DisplayName, Description,
                       MetricType, Unit, ScaleMin, ScaleMax, ChoiceOptions,
                       Frequency, DisplayOrder, IsActive, IsBaseline
                FROM TrackingMetric
                WHERE CategoryID = %s AND IsActive = 1 AND IsDeleted = 0
                ORDER BY DisplayOrder ASC
                """,
                (cat["CategoryID"],),
            )
            metrics = []
            for m in cursor.fetchall():
                metrics.append({
                    "metric_id": m["MetricID"],
                    "category_id": m["CategoryID"],
                    "metric_key": m["MetricKey"],
                    "display_name": m["DisplayName"],
                    "description": m["Description"],
                    "metric_type": m["MetricType"],
                    "unit": m["Unit"],
                    "scale_min": m["ScaleMin"],
                    "scale_max": m["ScaleMax"],
                    "choice_options": _parse_choice_options(m["ChoiceOptions"]),
                    "frequency": m["Frequency"],
                    "display_order": m["DisplayOrder"],
                    "is_active": bool(m["IsActive"]),
                    "is_baseline": bool(m["IsBaseline"]),
                    "is_deleted": False,
                })
            results.append({
                "category_id": cat["CategoryID"],
                "category_key": cat["CategoryKey"],
                "display_name": cat["DisplayName"],
                "description": cat["Description"],
                "icon": cat["Icon"],
                "display_order": cat["DisplayOrder"],
                "is_active": True,
                "is_deleted": False,
                "metrics": metrics,
            })
        return results
    finally:
        cursor.close()
        conn.close()


@router.get("/hcp/patients/{patient_id}/health-tracking/entries")
def get_patient_health_entries(
    patient_id: int,
    start_date: Optional[date] = Query(None),
    end_date: Optional[date] = Query(None),
    metric_id: Optional[int] = Query(None),
    current_user: dict = Depends(require_role(3, 4)),
):
    """Return a linked patient's health tracking entries.

    Verifies that the calling HCP has an active, consented link to the patient.
    Admins bypass the link check. Supports optional date range and metric filters.
    """
    caller_id = current_user["effective_account_id"]
    caller_role = current_user["effective_role_id"]

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        if caller_role != 4:
            _verify_hcp_access(caller_id, patient_id, cursor)

        query = """
            SELECT te.EntryID, te.ParticipantID, te.MetricID, te.Value,
                   te.Notes, te.EntryDate, te.IsBaseline, te.CreatedAt
            FROM TrackingEntry te
            JOIN TrackingMetric tm ON tm.MetricID = te.MetricID
            WHERE te.ParticipantID = %s
        """
        params: List[Any] = [patient_id]

        if start_date is not None:
            query += " AND te.EntryDate >= %s"
            params.append(start_date)
        if end_date is not None:
            query += " AND te.EntryDate <= %s"
            params.append(end_date)
        if metric_id is not None:
            query += " AND te.MetricID = %s"
            params.append(metric_id)

        query += " ORDER BY te.EntryDate ASC, te.EntryID ASC"

        cursor.execute(query, tuple(params))
        rows = cursor.fetchall()
        return [
            {
                "entry_id": r["EntryID"],
                "participant_id": r["ParticipantID"],
                "metric_id": r["MetricID"],
                "value": r["Value"],
                "notes": r["Notes"],
                "entry_date": r["EntryDate"].isoformat() if r["EntryDate"] else None,
                "is_baseline": bool(r["IsBaseline"]),
                "created_at": r["CreatedAt"].isoformat() if r["CreatedAt"] else None,
            }
            for r in rows
        ]
    finally:
        cursor.close()
        conn.close()


@router.get("/hcp/patients/{patient_id}/health-tracking/aggregate")
def get_patient_health_aggregate(
    patient_id: int,
    metric_id: int = Query(...),
    start_date: Optional[date] = Query(None),
    end_date: Optional[date] = Query(None),
    current_user: dict = Depends(require_role(3, 4)),
):
    """Return daily aggregate (all-participant average) for a metric for comparison.

    Verifies HCP access, then returns k-anonymity-filtered aggregate data so the
    HCP can compare their patient against the broader participant population.
    The patient_id path param is used only for the access check — the aggregate
    itself covers all participants.
    """
    from ...services.settings import get_int_setting

    caller_id = current_user["effective_account_id"]
    caller_role = current_user["effective_role_id"]

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        if caller_role != 4:
            _verify_hcp_access(caller_id, patient_id, cursor)

        k = get_int_setting("k_anonymity_threshold") or 5

        params: List[Any] = [metric_id]
        date_filter = ""
        if start_date is not None:
            date_filter += " AND te.EntryDate >= %s"
            params.append(start_date)
        if end_date is not None:
            date_filter += " AND te.EntryDate <= %s"
            params.append(end_date)
        params.append(k)

        cursor.execute(
            f"""
            SELECT te.EntryDate AS entry_date,
                   AVG(CAST(te.Value AS DECIMAL(10,4))) AS avg_value,
                   COUNT(DISTINCT te.ParticipantID) AS participant_count
            FROM TrackingEntry te
            WHERE te.MetricID = %s
              {date_filter}
            GROUP BY te.EntryDate
            HAVING COUNT(DISTINCT te.ParticipantID) >= %s
            ORDER BY te.EntryDate ASC
            """,
            tuple(params),
        )
        return [
            {
                "entry_date": r["entry_date"].isoformat(),
                "avg_value": float(r["avg_value"]),
                "participant_count": r["participant_count"],
            }
            for r in cursor.fetchall()
        ]
    except HTTPException:
        raise
    except Exception as e:
        logger.error("Failed to fetch HCP aggregate: %s", e, exc_info=True)
        raise HTTPException(status_code=500, detail="Failed to fetch aggregate data")
    finally:
        cursor.close()
        conn.close()


@router.get("/hcp/patients/{patient_id}/surveys/{survey_id}/aggregate")
def get_survey_question_aggregate(
    patient_id: int,
    survey_id: int,
    current_user: dict = Depends(require_role(3, 4)),
):
    """Return average response values per numeric/scale question for a survey.

    Verifies HCP has access to the patient, then returns per-question aggregate
    data (average value across all participants who completed this survey),
    filtered to k-anonymity threshold. Only numeric and scale questions are
    included — other types cannot be meaningfully averaged.
    """
    from ...services.settings import get_int_setting

    caller_id = current_user["effective_account_id"]
    caller_role = current_user["effective_role_id"]

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        if caller_role != 4:
            _verify_hcp_access(caller_id, patient_id, cursor)

        k = get_int_setting("k_anonymity_threshold") or 5

        cursor.execute(
            """
            SELECT
                qb.QuestionID AS question_id,
                qb.QuestionContent AS question_content,
                qb.ResponseType AS response_type,
                AVG(CAST(r.ResponseValue AS DECIMAL(10,4))) AS avg_value,
                COUNT(DISTINCT r.ParticipantID) AS participant_count
            FROM Responses r
            JOIN QuestionBank qb ON qb.QuestionID = r.QuestionID
            WHERE r.SurveyID = %s
              AND qb.ResponseType IN ('number', 'scale')
              AND r.ResponseValue REGEXP '^-?[0-9]+(\\.[0-9]+)?$'
            GROUP BY qb.QuestionID, qb.QuestionContent, qb.ResponseType
            HAVING COUNT(DISTINCT r.ParticipantID) >= %s
            ORDER BY qb.QuestionID ASC
            """,
            (survey_id, k),
        )
        return [
            {
                "question_id": r["question_id"],
                "question_content": r["question_content"],
                "response_type": r["response_type"],
                "avg_value": float(r["avg_value"]),
                "participant_count": r["participant_count"],
            }
            for r in cursor.fetchall()
        ]
    except HTTPException:
        raise
    except Exception as e:
        logger.error("Failed to fetch survey question aggregate: %s", e, exc_info=True)
        raise HTTPException(status_code=500, detail="Failed to fetch aggregate data")
    finally:
        cursor.close()
        conn.close()


@router.get("/hcp/patients/{patient_id}/health-tracking/export")
def export_patient_health_entries(
    patient_id: int,
    start_date: Optional[date] = Query(None),
    end_date: Optional[date] = Query(None),
    metric_ids: Optional[str] = Query(None),
    current_user: dict = Depends(require_role(3, 4)),
):
    """CSV export of a patient's health tracking entries for the HCP.

    Verifies HCP access to the patient, then returns their entries as a CSV.
    Columns: category_key, metric_key, entry_date, value, notes
    metric_ids: optional comma-separated metric IDs to filter.
    """
    caller_id = current_user["effective_account_id"]
    caller_role = current_user["effective_role_id"]

    ids_filter: Optional[List[int]] = None
    if metric_ids:
        try:
            ids_filter = [int(x.strip()) for x in metric_ids.split(",") if x.strip()]
        except ValueError:
            raise HTTPException(status_code=400, detail="metric_ids must be comma-separated integers")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        if caller_role != 4:
            _verify_hcp_access(caller_id, patient_id, cursor)

        query = """
            SELECT tc.CategoryKey, tm.MetricKey, te.EntryDate, te.Value, te.Notes
            FROM TrackingEntry te
            JOIN TrackingMetric tm ON tm.MetricID = te.MetricID
            JOIN TrackingCategory tc ON tc.CategoryID = tm.CategoryID
            WHERE te.ParticipantID = %s
        """
        params: List[Any] = [patient_id]

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

        cursor.execute(query, tuple(params))
        rows = cursor.fetchall()

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
            headers={"Content-Disposition": f"attachment; filename=patient_{patient_id}_health_tracking.csv"},
        )
    except HTTPException:
        raise
    except Exception as e:
        logger.error("Failed to export patient health entries: %s", e, exc_info=True)
        raise HTTPException(status_code=500, detail="Failed to export data")
    finally:
        cursor.close()
        conn.close()
