# Created with the Assistance of Claude Code
# backend/app/api/v1/assignments.py
"""
Survey Assignment API

Endpoints:
- POST   /api/v1/surveys/{id}/assign      - Assign survey to user(s)
- GET    /api/v1/surveys/{id}/assignments - List assignments for a survey
- GET    /api/v1/assignments/me           - Get my assignments (current user)
- PUT    /api/v1/assignments/{id}         - Update assignment (due date, status)
- DELETE /api/v1/assignments/{id}         - Remove assignment

SECURITY: All queries use parameterized statements to prevent SQL injection.
"""

from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel, field_validator
from typing import Optional, List, Union
from enum import Enum
from datetime import datetime
from ...utils.utils import get_db_connection
from ..deps import require_role, sanitized_string

router = APIRouter(dependencies=[Depends(require_role(1, 2, 4))])


# Enums
class AssignmentStatus(str, Enum):
    pending = "pending"
    completed = "completed"
    expired = "expired"


# Pydantic Models
class AssignmentCreate(BaseModel):
    account_id: Optional[int] = None
    account_ids: Optional[List[int]] = None
    assign_all: bool = False
    gender: Optional[str] = None
    age_min: Optional[int] = None
    age_max: Optional[int] = None
    due_date: Optional[datetime] = None

    @field_validator('gender', mode='before')
    @classmethod
    def sanitize_gender(cls, v):
        return sanitized_string(v) if v is not None else v


class BulkAssignmentResult(BaseModel):
    assigned: int
    skipped: int
    total_targeted: int


class AssignmentTargetPreview(BaseModel):
    total_targeted: int
    already_assigned: int
    assignable: int


class AssignmentUpdate(BaseModel):
    due_date: Optional[datetime] = None
    status: Optional[AssignmentStatus] = None


class AssignmentResponse(BaseModel):
    assignment_id: int
    survey_id: int
    account_id: int
    assigned_at: Optional[datetime] = None
    due_date: Optional[datetime] = None
    completed_at: Optional[datetime] = None
    status: str


class MyAssignmentResponse(BaseModel):
    assignment_id: int
    survey_id: int
    survey_title: str
    assigned_at: Optional[datetime] = None
    due_date: Optional[datetime] = None
    completed_at: Optional[datetime] = None
    status: str


# Survey-scoped endpoints (mounted under /surveys)
survey_router = APIRouter(dependencies=[Depends(require_role(2, 4))])


@survey_router.post("/{survey_id}/assign", status_code=201)
async def assign_survey(
    survey_id: int,
    assignment: AssignmentCreate
) -> Union[AssignmentResponse, List[AssignmentResponse], BulkAssignmentResult]:
    """Assign a published survey to one or more users, or bulk-assign by demographic."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Check survey exists and is published
        cursor.execute(
            "SELECT SurveyID, PublicationStatus FROM Survey WHERE SurveyID = %s",
            (survey_id,)
        )
        survey = cursor.fetchone()

        if not survey:
            raise HTTPException(status_code=404, detail="Survey not found")

        if survey[1] != 'published':
            raise HTTPException(
                status_code=400,
                detail=f"Cannot assign survey. Status is '{survey[1]}', must be 'published'"
            )

        # Bulk assignment path: assign_all=True OR any demographic filter is set
        is_bulk = assignment.assign_all or assignment.gender is not None or \
                  assignment.age_min is not None or assignment.age_max is not None

        if is_bulk:
            # Query participants (RoleID=1, IsActive=1) with optional demographic filters
            query = "SELECT AccountID FROM AccountData WHERE RoleID = %s AND IsActive = %s"
            params: list = [1, 1]

            if assignment.gender is not None:
                query += " AND Gender = %s"
                params.append(assignment.gender)

            if assignment.age_min is not None:
                query += " AND Birthdate IS NOT NULL AND (YEAR(CURDATE()) - YEAR(Birthdate)) >= %s"
                params.append(assignment.age_min)

            if assignment.age_max is not None:
                query += " AND Birthdate IS NOT NULL AND (YEAR(CURDATE()) - YEAR(Birthdate)) <= %s"
                params.append(assignment.age_max)

            cursor.execute(query, tuple(params))
            targeted_ids = [row[0] for row in cursor.fetchall()]

            assigned_count = 0
            skipped_count = 0

            for account_id in targeted_ids:
                # Check for duplicate — skip silently in bulk mode
                cursor.execute(
                    "SELECT AssignmentID FROM SurveyAssignment WHERE SurveyID = %s AND AccountID = %s",
                    (survey_id, account_id)
                )
                if cursor.fetchone():
                    skipped_count += 1
                    continue

                cursor.execute(
                    "INSERT INTO SurveyAssignment (SurveyID, AccountID, DueDate, Status) VALUES (%s, %s, %s, %s)",
                    (survey_id, account_id, assignment.due_date, 'pending')
                )
                assigned_count += 1

            conn.commit()
            return BulkAssignmentResult(
                assigned=assigned_count,
                skipped=skipped_count,
                total_targeted=len(targeted_ids)
            )

        # Individual assignment path (legacy: account_id or account_ids)
        account_ids = []
        if assignment.account_ids:
            account_ids = assignment.account_ids
        elif assignment.account_id:
            account_ids = [assignment.account_id]
        else:
            raise HTTPException(status_code=422, detail="Must provide account_id or account_ids")

        assignments = []
        for account_id in account_ids:
            # Check for duplicate assignment
            cursor.execute(
                "SELECT AssignmentID FROM SurveyAssignment WHERE SurveyID = %s AND AccountID = %s",
                (survey_id, account_id)
            )
            if cursor.fetchone():
                raise HTTPException(status_code=409, detail=f"User {account_id} already assigned")

            # Create assignment
            cursor.execute(
                "INSERT INTO SurveyAssignment (SurveyID, AccountID, DueDate, Status) VALUES (%s, %s, %s, %s)",
                (survey_id, account_id, assignment.due_date, 'pending')
            )
            assignment_id = cursor.lastrowid

            cursor.execute(
                "SELECT AssignmentID, SurveyID, AccountID, AssignedAt, DueDate, CompletedAt, Status FROM SurveyAssignment WHERE AssignmentID = %s",
                (assignment_id,)
            )
            row = cursor.fetchone()
            assignments.append(AssignmentResponse(
                assignment_id=row[0], survey_id=row[1], account_id=row[2],
                assigned_at=row[3], due_date=row[4], completed_at=row[5], status=row[6]
            ))

        conn.commit()
        return assignments[0] if len(assignments) == 1 else assignments

    finally:
        cursor.close()
        conn.close()


@survey_router.get("/{survey_id}/assignments")
async def get_survey_assignments(survey_id: int, status: Optional[str] = Query(None)) -> List[AssignmentResponse]:
    """Get all assignments for a specific survey."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("SELECT SurveyID FROM Survey WHERE SurveyID = %s", (survey_id,))
        if not cursor.fetchone():
            raise HTTPException(status_code=404, detail="Survey not found")

        query = "SELECT AssignmentID, SurveyID, AccountID, AssignedAt, DueDate, CompletedAt, Status FROM SurveyAssignment WHERE SurveyID = %s"
        params = [survey_id]
        if status:
            query += " AND Status = %s"
            params.append(status)
        query += " ORDER BY AssignedAt DESC"

        cursor.execute(query, tuple(params))
        return [
            AssignmentResponse(assignment_id=r[0], survey_id=r[1], account_id=r[2],
                             assigned_at=r[3], due_date=r[4], completed_at=r[5], status=r[6])
            for r in cursor.fetchall()
        ]
    finally:
        cursor.close()
        conn.close()


@survey_router.get("/{survey_id}/assignments/preview-target")
async def preview_assignment_target(
    survey_id: int,
    gender: Optional[str] = Query(None),
    age_min: Optional[int] = Query(None),
    age_max: Optional[int] = Query(None),
) -> AssignmentTargetPreview:
    """Preview how many participants would be newly assigned."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("SELECT SurveyID FROM Survey WHERE SurveyID = %s", (survey_id,))
        if not cursor.fetchone():
            raise HTTPException(status_code=404, detail="Survey not found")

        query = "SELECT AccountID FROM AccountData WHERE RoleID = %s AND IsActive = %s"
        params: list = [1, 1]

        if gender is not None:
            query += " AND Gender = %s"
            params.append(gender)

        if age_min is not None:
            query += " AND Birthdate IS NOT NULL AND (YEAR(CURDATE()) - YEAR(Birthdate)) >= %s"
            params.append(age_min)

        if age_max is not None:
            query += " AND Birthdate IS NOT NULL AND (YEAR(CURDATE()) - YEAR(Birthdate)) <= %s"
            params.append(age_max)

        cursor.execute(query, tuple(params))
        targeted_ids = [row[0] for row in cursor.fetchall()]
        total_targeted = len(targeted_ids)

        if total_targeted == 0:
            return AssignmentTargetPreview(
                total_targeted=0,
                already_assigned=0,
                assignable=0,
            )

        placeholders = ", ".join(["%s"] * total_targeted)
        cursor.execute(
            (
                "SELECT COUNT(*) FROM SurveyAssignment "
                f"WHERE SurveyID = %s AND AccountID IN ({placeholders})"
            ),
            tuple([survey_id, *targeted_ids]),
        )
        already_assigned_row = cursor.fetchone()
        already_assigned = already_assigned_row[0] if already_assigned_row else 0

        return AssignmentTargetPreview(
            total_targeted=total_targeted,
            already_assigned=already_assigned,
            assignable=max(0, total_targeted - already_assigned),
        )
    finally:
        cursor.close()
        conn.close()


# Assignment-specific endpoints
@router.get("/me")
async def get_my_assignments(user=Depends(require_role(1, 2, 4)), status: Optional[str] = Query(None)) -> List[MyAssignmentResponse]:
    """Get all assignments for the current user (derived from auth token)."""
    account_id = user["effective_account_id"]
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Hide overdue, non-completed assignments — they can't be completed
        # anymore, so they shouldn't appear in the participant's to-do or
        # surveys list. Completed assignments with a past due date stay
        # (historical record). NULL due dates are treated as never-overdue.
        query = """
            SELECT
                sa.AssignmentID,
                sa.SurveyID,
                s.Title,
                sa.AssignedAt,
                COALESCE(sa.DueDate, s.EndDate) AS DueDate,
                sa.CompletedAt,
                sa.Status
            FROM SurveyAssignment sa
            JOIN Survey s ON sa.SurveyID = s.SurveyID
            WHERE sa.AccountID = %s
              AND (
                sa.Status = 'completed'
                OR COALESCE(sa.DueDate, s.EndDate) IS NULL
                OR COALESCE(sa.DueDate, s.EndDate) >= CURDATE()
              )
        """
        params = [account_id]
        if status:
            query += " AND sa.Status = %s"
            params.append(status)
        query += " ORDER BY sa.AssignedAt DESC"

        cursor.execute(query, tuple(params))
        return [
            MyAssignmentResponse(assignment_id=r[0], survey_id=r[1], survey_title=r[2],
                                assigned_at=r[3], due_date=r[4], completed_at=r[5], status=r[6])
            for r in cursor.fetchall()
        ]
    finally:
        cursor.close()
        conn.close()


@router.put("/{assignment_id}")
async def update_assignment(assignment_id: int, update: AssignmentUpdate) -> AssignmentResponse:
    """Update an assignment (due date or status)."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("SELECT AssignmentID FROM SurveyAssignment WHERE AssignmentID = %s", (assignment_id,))
        if not cursor.fetchone():
            raise HTTPException(status_code=404, detail="Assignment not found")

        updates, params = [], []
        if update.due_date is not None:
            updates.append("DueDate = %s")
            params.append(update.due_date)
        if update.status is not None:
            updates.append("Status = %s")
            params.append(update.status.value)
            if update.status == AssignmentStatus.completed:
                updates.append("CompletedAt = %s")
                params.append(datetime.now())

        if updates:
            cursor.execute(f"UPDATE SurveyAssignment SET {', '.join(updates)} WHERE AssignmentID = %s", tuple(params + [assignment_id]))
            conn.commit()

        cursor.execute(
            "SELECT AssignmentID, SurveyID, AccountID, AssignedAt, DueDate, CompletedAt, Status FROM SurveyAssignment WHERE AssignmentID = %s",
            (assignment_id,)
        )
        r = cursor.fetchone()
        return AssignmentResponse(assignment_id=r[0], survey_id=r[1], account_id=r[2],
                                 assigned_at=r[3], due_date=r[4], completed_at=r[5], status=r[6])
    finally:
        cursor.close()
        conn.close()


@router.delete("/{assignment_id}", status_code=204)
async def delete_assignment(assignment_id: int):
    """Delete an assignment. Cannot delete completed assignments."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("SELECT AssignmentID, Status FROM SurveyAssignment WHERE AssignmentID = %s", (assignment_id,))
        row = cursor.fetchone()
        if not row:
            raise HTTPException(status_code=404, detail="Assignment not found")
        if row[1] == 'completed':
            raise HTTPException(status_code=400, detail="Cannot delete completed assignment")

        cursor.execute("DELETE FROM SurveyAssignment WHERE AssignmentID = %s", (assignment_id,))
        conn.commit()
        return None
    finally:
        cursor.close()
        conn.close()
