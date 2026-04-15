# Created with the Assistance of Claude Code
# backend/app/api/v1/hcp_links.py
"""HCP-Patient linking endpoints.

Allows HCPs and participants to create, manage, and remove tracking links.
All queries use parameterized %s placeholders (no string interpolation).
Auth: require_role(1, 3, 4) — Participant, HCP, Admin.
"""
from datetime import datetime
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel, field_validator

from ...utils.utils import get_db_connection
from ..deps import require_role, sanitized_string

router = APIRouter(tags=["hcp-links"])


# ── Models ────────────────────────────────────────────────────────────────────

_LINK_SILENT_RESPONSE = {"detail": "Link request sent."}


class HcpLinkRequest(BaseModel):
    query: str  # email address

    @field_validator("query", mode="before")
    @classmethod
    def sanitize(cls, v):
        return sanitized_string(v)


class HcpLinkRespondRequest(BaseModel):
    action: str  # 'accept' or 'reject'


class HcpLinkOut(BaseModel):
    link_id: int
    hcp_id: int
    patient_id: int
    hcp_name: Optional[str]
    patient_name: Optional[str]
    status: str
    requested_by: str
    requested_at: datetime
    updated_at: datetime
    consent_revoked: bool = False


# ── Endpoints ─────────────────────────────────────────────────────────────────

@router.post("/request", status_code=202)
def request_link(
    body: HcpLinkRequest,
    current_user: dict = Depends(require_role(1, 3, 4)),
):
    """Initiate an HCP-patient link request by email address.

    The query field accepts an email address (exact match). The caller and
    target must be opposite roles (HCP looks for participants, participants
    look for HCPs).

    Always returns 202 with the same response regardless of whether the target
    was found — this protects participant privacy.
    """
    caller_id = current_user["effective_account_id"]
    caller_role = current_user["effective_role_id"]
    query = body.query.strip()

    # Admin acts as participant side for linking purposes
    if caller_role == 4:
        caller_role = 1

    # HCP looks for participants; participants look for HCPs
    target_role = 1 if caller_role == 3 else 3

    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        # Look up target by email (exact match), restricted to opposite role
        cursor.execute(
            "SELECT AccountID FROM AccountData WHERE Email = %s AND IsActive = 1 AND RoleID = %s",
            (query, target_role),
        )
        results = cursor.fetchall()

        # Silently return if no match or ambiguous (multiple matches by name)
        if len(results) != 1:
            return _LINK_SILENT_RESPONSE

        target_id = results[0][0]

        # Determine hcp_id / patient_id from caller role
        if caller_role == 1:
            hcp_id, patient_id = target_id, caller_id
            requested_by = "patient"
        else:
            hcp_id, patient_id = caller_id, target_id
            requested_by = "hcp"

        # Check for existing link — silently succeed if already pending/active
        cursor.execute(
            "SELECT LinkID, Status FROM HcpPatientLink WHERE HcpID = %s AND PatientID = %s",
            (hcp_id, patient_id),
        )
        existing = cursor.fetchone()
        if existing:
            if existing[1] in ("pending", "active"):
                return _LINK_SILENT_RESPONSE
            cursor.execute(
                "UPDATE HcpPatientLink SET Status='pending', RequestedBy=%s, UpdatedAt=NOW() "
                "WHERE LinkID = %s",
                (requested_by, existing[0]),
            )
        else:
            cursor.execute(
                "INSERT INTO HcpPatientLink (HcpID, PatientID, Status, RequestedBy) "
                "VALUES (%s, %s, 'pending', %s)",
                (hcp_id, patient_id, requested_by),
            )

        conn.commit()
        return _LINK_SILENT_RESPONSE
    finally:
        cursor.close()
        conn.close()


@router.get("/", response_model=list[HcpLinkOut])
def list_my_links(
    status: Optional[str] = None,
    current_user: dict = Depends(require_role(1, 3, 4)),
):
    """List HCP-patient links for the current user.

    HCPs see links where they are the HCP.
    Participants see links where they are the patient.
    Optionally filter by status (pending, active, rejected, removed).
    """
    caller_id = current_user["effective_account_id"]
    caller_role = current_user["effective_role_id"]

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        if caller_role == 3:  # HCP
            where_col = "l.HcpID"
        else:  # Participant or Admin (participant perspective)
            where_col = "l.PatientID"

        params = [caller_id]
        status_clause = ""
        if status:
            status_clause = " AND l.Status = %s"
            params.append(status)

        cursor.execute(
            f"""
            SELECT
                l.LinkID AS link_id,
                l.HcpID AS hcp_id,
                l.PatientID AS patient_id,
                CONCAT(COALESCE(h.FirstName,''), ' ', COALESCE(h.LastName,'')) AS hcp_name,
                CONCAT(COALESCE(p.FirstName,''), ' ', COALESCE(p.LastName,'')) AS patient_name,
                l.Status AS status,
                l.RequestedBy AS requested_by,
                l.RequestedAt AS requested_at,
                l.UpdatedAt AS updated_at,
                l.ConsentRevoked AS consent_revoked
            FROM HcpPatientLink l
            JOIN AccountData h ON h.AccountID = l.HcpID
            JOIN AccountData p ON p.AccountID = l.PatientID
            WHERE {where_col} = %s{status_clause}
            ORDER BY l.RequestedAt DESC
            """,
            params,
        )
        rows = cursor.fetchall()
        return rows
    finally:
        cursor.close()
        conn.close()


@router.put("/{link_id}/respond", status_code=200)
def respond_to_link(
    link_id: int,
    body: HcpLinkRespondRequest,
    current_user: dict = Depends(require_role(1, 3, 4)),
):
    """Accept or reject a pending link request.

    Only the party who did NOT initiate the request can respond.
    """
    if body.action not in ("accept", "reject"):
        raise HTTPException(status_code=400, detail="action must be 'accept' or 'reject'")

    caller_id = current_user["effective_account_id"]
    caller_role = current_user["effective_role_id"]

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(
            "SELECT LinkID, HcpID, PatientID, Status, RequestedBy FROM HcpPatientLink WHERE LinkID = %s",
            (link_id,),
        )
        link = cursor.fetchone()
        if not link:
            raise HTTPException(status_code=404, detail="Link not found")
        if link["Status"] != "pending":
            raise HTTPException(status_code=400, detail="Link is not in pending status")

        # Only the non-requester can respond
        is_hcp = caller_role == 3 or (caller_role == 4 and caller_id == link["HcpID"])
        is_patient = caller_role == 1 or (caller_role == 4 and caller_id == link["PatientID"])

        requester_is_hcp = link["RequestedBy"] == "hcp"
        if requester_is_hcp and not is_patient:
            raise HTTPException(status_code=403, detail="Only the patient can respond to this request")
        if not requester_is_hcp and not is_hcp:
            raise HTTPException(status_code=403, detail="Only the HCP can respond to this request")

        new_status = "active" if body.action == "accept" else "rejected"
        cursor.execute(
            "UPDATE HcpPatientLink SET Status=%s, UpdatedAt=NOW() WHERE LinkID=%s",
            (new_status, link_id),
        )

        # Auto-create a conversation between HCP and patient when link is accepted
        if new_status == "active":
            hcp_id = link["HcpID"]
            patient_id = link["PatientID"]
            # Check if a direct conversation already exists between them
            cursor.execute(
                """
                SELECT cp1.ConvID
                FROM ConversationParticipants cp1
                JOIN ConversationParticipants cp2
                  ON cp1.ConvID = cp2.ConvID
                JOIN Conversations c ON c.ConvID = cp1.ConvID
                WHERE cp1.AccountID = %s
                  AND cp2.AccountID = %s
                  AND c.ConvType = 'direct'
                """,
                (hcp_id, patient_id),
            )
            if not cursor.fetchone():
                cursor.execute(
                    "INSERT INTO Conversations (ConvType) VALUES ('direct')",
                )
                conv_id = cursor.lastrowid
                cursor.execute(
                    "INSERT INTO ConversationParticipants (ConvID, AccountID) VALUES (%s, %s)",
                    (conv_id, hcp_id),
                )
                cursor.execute(
                    "INSERT INTO ConversationParticipants (ConvID, AccountID) VALUES (%s, %s)",
                    (conv_id, patient_id),
                )

        # Auto-create accepted FriendRequest so both parties appear in each other's contacts
        if new_status == "active":
            cursor.execute(
                "SELECT Email FROM AccountData WHERE AccountID = %s",
                (link["PatientID"],),
            )
            patient_row = cursor.fetchone()
            cursor.execute(
                "SELECT Email FROM AccountData WHERE AccountID = %s",
                (link["HcpID"],),
            )
            hcp_row = cursor.fetchone()
            if patient_row and hcp_row:
                cursor.execute(
                    """
                    INSERT IGNORE INTO FriendRequests
                        (RequesterID, TargetEmail, TargetAccountID, Status)
                    VALUES (%s, %s, %s, 'accepted')
                    """,
                    (link["HcpID"], patient_row["Email"], link["PatientID"]),
                )

        conn.commit()
        return {"link_id": link_id, "status": new_status}
    finally:
        cursor.close()
        conn.close()


@router.post("/{link_id}/revoke-consent", status_code=200)
def revoke_consent(
    link_id: int,
    current_user: dict = Depends(require_role(1, 4)),
):
    """Revoke patient consent for an HCP-patient link.

    Only the patient (PatientID) or an admin can revoke consent.
    Sets ConsentRevoked=1. The link remains in place but the HCP
    loses data access.
    """
    caller_id = current_user["effective_account_id"]
    caller_role = current_user["effective_role_id"]

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(
            "SELECT LinkID, PatientID FROM HcpPatientLink WHERE LinkID = %s",
            (link_id,),
        )
        link = cursor.fetchone()
        if not link:
            raise HTTPException(status_code=404, detail="Link not found")

        # Only the patient or an admin may revoke consent
        if caller_role != 4 and caller_id != link["PatientID"]:
            raise HTTPException(status_code=403, detail="Only the patient can revoke consent")

        cursor.execute(
            "UPDATE HcpPatientLink SET ConsentRevoked=1, UpdatedAt=NOW() WHERE LinkID=%s",
            (link_id,),
        )
        conn.commit()
        return {"link_id": link_id, "consent_revoked": True}
    finally:
        cursor.close()
        conn.close()


@router.post("/{link_id}/restore-consent", status_code=200)
def restore_consent(
    link_id: int,
    current_user: dict = Depends(require_role(1, 4)),
):
    """Restore patient consent for an HCP-patient link.

    Only the patient (PatientID) or an admin can restore consent.
    Sets ConsentRevoked=0.
    """
    caller_id = current_user["effective_account_id"]
    caller_role = current_user["effective_role_id"]

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(
            "SELECT LinkID, PatientID FROM HcpPatientLink WHERE LinkID = %s",
            (link_id,),
        )
        link = cursor.fetchone()
        if not link:
            raise HTTPException(status_code=404, detail="Link not found")

        # Only the patient or an admin may restore consent
        if caller_role != 4 and caller_id != link["PatientID"]:
            raise HTTPException(status_code=403, detail="Only the patient can restore consent")

        cursor.execute(
            "UPDATE HcpPatientLink SET ConsentRevoked=0, UpdatedAt=NOW() WHERE LinkID=%s",
            (link_id,),
        )
        conn.commit()
        return {"link_id": link_id, "consent_revoked": False}
    finally:
        cursor.close()
        conn.close()


@router.delete("/{link_id}", status_code=204)
def remove_link(
    link_id: int,
    current_user: dict = Depends(require_role(1, 3, 4)),
):
    """Remove an HCP-patient link (either party can remove)."""
    caller_id = current_user["effective_account_id"]
    caller_role = current_user["effective_role_id"]

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(
            "SELECT LinkID, HcpID, PatientID FROM HcpPatientLink WHERE LinkID = %s",
            (link_id,),
        )
        link = cursor.fetchone()
        if not link:
            raise HTTPException(status_code=404, detail="Link not found")

        # Must be one of the parties (or admin)
        if caller_role != 4 and caller_id not in (link["HcpID"], link["PatientID"]):
            raise HTTPException(status_code=403, detail="Not authorized to remove this link")

        cursor.execute(
            "UPDATE HcpPatientLink SET Status='removed', UpdatedAt=NOW() WHERE LinkID=%s",
            (link_id,),
        )
        conn.commit()
    finally:
        cursor.close()
        conn.close()
