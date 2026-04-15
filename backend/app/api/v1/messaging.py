# Created with the Assistance of Claude Code
# backend/app/api/v1/messaging.py
"""Messaging system endpoints.

Permission rules (enforced per endpoint):
  Admin (4):       can start conversation with anyone
  HCP (3):         can message their active+consented linked patients only
  Participant (1): can message their HCP or accepted friends only
  Researcher (2):  can message other researchers only

Privacy: Friend requests by email are always silent —
  the response is identical whether the target exists or not.
"""
from datetime import datetime
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel, field_validator

from ...utils.utils import get_db_connection
from ..deps import require_role, sanitized_string

router = APIRouter(tags=["messaging"])


# ── Models ────────────────────────────────────────────────────────────────────

class CreateConversationRequest(BaseModel):
    target_account_id: Optional[int] = None
    target_email: Optional[str] = None

    @field_validator("target_email", mode="before")
    @classmethod
    def sanitize_email(cls, v):
        return sanitized_string(v) if v is not None else v


class SendMessageRequest(BaseModel):
    body: str

    @field_validator("body", mode="before")
    @classmethod
    def sanitize(cls, v):
        return sanitized_string(v)


class FriendRequestBody(BaseModel):
    email: str

    @field_validator("email", mode="before")
    @classmethod
    def sanitize(cls, v):
        return sanitized_string(v)


class FriendRequestRespondBody(BaseModel):
    action: str  # 'accept' or 'reject'


# ── Helpers ───────────────────────────────────────────────────────────────────

def _can_message(caller_id: int, caller_role: int, target_id: int, cursor) -> bool:
    """Return True if caller is allowed to initiate/continue a conversation with target."""
    if caller_role == 4:
        # Admin can always message anyone
        return True

    if caller_role == 3:
        # HCP: must have an active, non-revoked link to target (patient)
        cursor.execute(
            """
            SELECT LinkID FROM HcpPatientLink
            WHERE HcpID = %s
              AND PatientID = %s
              AND Status = 'active'
              AND ConsentRevoked = 0
            """,
            (caller_id, target_id),
        )
        return cursor.fetchone() is not None

    if caller_role == 1:
        # Participant: can message their HCP (active, non-revoked link)
        cursor.execute(
            """
            SELECT LinkID FROM HcpPatientLink
            WHERE PatientID = %s
              AND HcpID = %s
              AND Status = 'active'
              AND ConsentRevoked = 0
            """,
            (caller_id, target_id),
        )
        if cursor.fetchone() is not None:
            return True
        # Or an accepted friend
        cursor.execute(
            """
            SELECT RequestID FROM FriendRequests
            WHERE (
                (RequesterID = %s AND TargetAccountID = %s)
                OR (RequesterID = %s AND TargetAccountID = %s)
            )
              AND Status = 'accepted'
            """,
            (caller_id, target_id, target_id, caller_id),
        )
        return cursor.fetchone() is not None

    if caller_role == 2:
        # Researcher: target must also be a researcher
        cursor.execute(
            "SELECT AccountID FROM AccountData WHERE AccountID = %s AND RoleID = 2 AND IsActive = 1",
            (target_id,),
        )
        return cursor.fetchone() is not None

    return False


def _get_or_create_conversation(caller_id: int, target_id: int, cursor, db) -> tuple[int, bool]:
    """Find existing direct conversation between exactly these two participants,
    or create a new one. Returns (conv_id, created)."""
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
        (caller_id, target_id),
    )
    existing = cursor.fetchone()
    if existing:
        conv_id = existing[0] if isinstance(existing, tuple) else existing["ConvID"]
        return conv_id, False

    # Create new conversation
    cursor.execute(
        "INSERT INTO Conversations (ConvType) VALUES ('direct')",
        (),
    )
    conv_id = cursor.lastrowid
    cursor.execute(
        "INSERT INTO ConversationParticipants (ConvID, AccountID) VALUES (%s, %s)",
        (conv_id, caller_id),
    )
    cursor.execute(
        "INSERT INTO ConversationParticipants (ConvID, AccountID) VALUES (%s, %s)",
        (conv_id, target_id),
    )
    db.commit()
    return conv_id, True


# ── Endpoints ─────────────────────────────────────────────────────────────────

@router.post("/messages/conversations", status_code=201)
def create_conversation(
    body: CreateConversationRequest,
    current_user: dict = Depends(require_role(1, 2, 3, 4)),
):
    """Start or retrieve a direct conversation between caller and target.

    Permission rules apply: HCP↔linked-patient, participant↔HCP or friend,
    researcher↔researcher, admin↔anyone.
    """
    caller_id = current_user["effective_account_id"]
    caller_role = current_user["effective_role_id"]

    if body.target_account_id is None and body.target_email is None:
        raise HTTPException(status_code=400, detail="Provide target_account_id or target_email")

    # Self-check for account_id path (before opening DB connection)
    if body.target_account_id is not None and body.target_account_id == caller_id:
        raise HTTPException(status_code=400, detail="Cannot start a conversation with yourself")

    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        # Resolve email → account ID if needed
        if body.target_email is not None:
            cursor.execute(
                "SELECT AccountID FROM AccountData WHERE Email = %s AND IsActive = 1",
                (body.target_email.strip().lower(),),
            )
            row = cursor.fetchone()
            if not row:
                raise HTTPException(status_code=404, detail="Target account not found")
            target_id = row[0] if isinstance(row, tuple) else row["AccountID"]
            if target_id == caller_id:
                raise HTTPException(status_code=400, detail="Cannot start a conversation with yourself")
        else:
            target_id = body.target_account_id
            # Verify target exists and is active
            cursor.execute(
                "SELECT AccountID FROM AccountData WHERE AccountID = %s AND IsActive = 1",
                (target_id,),
            )
            if not cursor.fetchone():
                raise HTTPException(status_code=404, detail="Target account not found")

        if not _can_message(caller_id, caller_role, target_id, cursor):
            raise HTTPException(
                status_code=403,
                detail="Not authorized to message this user",
            )

        conv_id, created = _get_or_create_conversation(caller_id, target_id, cursor, conn)
        return {"conv_id": conv_id, "created": created}
    finally:
        cursor.close()
        conn.close()


@router.get("/messages/conversations")
def list_conversations(
    current_user: dict = Depends(require_role(1, 2, 3, 4)),
):
    """List all conversations the caller participates in, with last message preview."""
    caller_id = current_user["effective_account_id"]

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(
            """
            SELECT
                c.ConvID AS conv_id,
                other_acct.AccountID AS other_participant_id,
                CONCAT(
                    COALESCE(other_acct.FirstName, ''), ' ',
                    COALESCE(other_acct.LastName, '')
                ) AS other_participant_name,
                last_msg.Body AS last_message,
                last_msg.SentAt AS last_message_at,
                (
                    SELECT COUNT(*)
                    FROM Messages m_unread
                    WHERE m_unread.ConvID = c.ConvID
                      AND m_unread.SenderID != %s
                      AND (cp.LastReadAt IS NULL OR m_unread.SentAt > cp.LastReadAt)
                ) AS unread_count
            FROM ConversationParticipants cp
            JOIN Conversations c ON c.ConvID = cp.ConvID
            JOIN ConversationParticipants cp2
              ON cp2.ConvID = c.ConvID AND cp2.AccountID != %s
            JOIN AccountData other_acct ON other_acct.AccountID = cp2.AccountID
            LEFT JOIN (
                SELECT m1.ConvID, m1.Body, m1.SentAt
                FROM Messages m1
                WHERE m1.MessageID = (
                    SELECT MAX(m2.MessageID) FROM Messages m2 WHERE m2.ConvID = m1.ConvID
                )
            ) last_msg ON last_msg.ConvID = c.ConvID
            WHERE cp.AccountID = %s
            ORDER BY COALESCE(last_msg.SentAt, c.CreatedAt) DESC
            """,
            (caller_id, caller_id, caller_id),
        )
        rows = cursor.fetchall()
        return rows
    finally:
        cursor.close()
        conn.close()


@router.get("/messages/conversations/{conv_id}/messages")
def get_messages(
    conv_id: int,
    current_user: dict = Depends(require_role(1, 2, 3, 4)),
):
    """Return all messages in a conversation, ordered by SentAt ASC.

    403 if the caller is not a participant in this conversation.
    """
    caller_id = current_user["effective_account_id"]

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        # Verify caller is a participant
        cursor.execute(
            "SELECT ConvID FROM ConversationParticipants WHERE ConvID = %s AND AccountID = %s",
            (conv_id, caller_id),
        )
        if not cursor.fetchone():
            raise HTTPException(status_code=403, detail="Not a participant in this conversation")

        cursor.execute(
            """
            SELECT
                m.MessageID AS message_id,
                m.SenderID AS sender_id,
                CONCAT(
                    COALESCE(a.FirstName, ''), ' ', COALESCE(a.LastName, '')
                ) AS sender_name,
                m.Body AS body,
                m.SentAt AS sent_at
            FROM Messages m
            JOIN AccountData a ON a.AccountID = m.SenderID
            WHERE m.ConvID = %s
            ORDER BY m.SentAt ASC
            """,
            (conv_id,),
        )
        rows = cursor.fetchall()

        # Mark conversation as read for this user
        cursor.execute(
            "UPDATE ConversationParticipants SET LastReadAt = NOW() WHERE ConvID = %s AND AccountID = %s",
            (conv_id, caller_id),
        )
        conn.commit()

        return rows
    finally:
        cursor.close()
        conn.close()


@router.post("/messages/conversations/{conv_id}/messages", status_code=201)
def send_message(
    conv_id: int,
    body: SendMessageRequest,
    current_user: dict = Depends(require_role(1, 2, 3, 4)),
):
    """Send a message in a conversation.

    403 if the caller is not a participant in this conversation.
    """
    caller_id = current_user["effective_account_id"]

    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        # Verify caller is a participant
        cursor.execute(
            "SELECT ConvID FROM ConversationParticipants WHERE ConvID = %s AND AccountID = %s",
            (conv_id, caller_id),
        )
        if not cursor.fetchone():
            raise HTTPException(status_code=403, detail="Not a participant in this conversation")

        cursor.execute(
            "INSERT INTO Messages (ConvID, SenderID, Body) VALUES (%s, %s, %s)",
            (conv_id, caller_id, body.body),
        )
        message_id = cursor.lastrowid
        conn.commit()

        # Fetch the SentAt that the DB assigned
        cursor.execute(
            "SELECT SentAt FROM Messages WHERE MessageID = %s",
            (message_id,),
        )
        row = cursor.fetchone()
        sent_at = row[0] if row else datetime.utcnow()

        return {"message_id": message_id, "sent_at": sent_at}
    finally:
        cursor.close()
        conn.close()


@router.delete("/messages/conversations/{conv_id}/messages/{message_id}", status_code=200)
def delete_message(
    conv_id: int,
    message_id: int,
    current_user: dict = Depends(require_role(1, 2, 3, 4)),
):
    """Delete a message. Only the original sender (or admin) may delete."""
    caller_id = current_user["effective_account_id"]
    caller_role = current_user["effective_role_id"]

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(
            "SELECT MessageID, SenderID FROM Messages WHERE MessageID = %s AND ConvID = %s",
            (message_id, conv_id),
        )
        message = cursor.fetchone()
        if not message:
            raise HTTPException(status_code=404, detail="Message not found")

        if caller_role != 4 and message["SenderID"] != caller_id:
            raise HTTPException(status_code=403, detail="Can only delete your own messages")

        cursor2 = conn.cursor()
        cursor2.execute("DELETE FROM Messages WHERE MessageID = %s", (message_id,))
        conn.commit()
        cursor2.close()
        return {"deleted": message_id}
    finally:
        cursor.close()
        conn.close()


@router.post("/messages/friend-request", status_code=202)
def send_friend_request(
    body: FriendRequestBody,
    current_user: dict = Depends(require_role(1, 2, 4)),
):
    """Send a contact request by email.

    Always returns 202 with the same response message, regardless of whether
    the target email exists. This preserves user privacy.
    HCP contacts are created automatically via link approval — HCPs do not
    use this endpoint.
    """
    _SILENT_RESPONSE = {"detail": "If this user exists, a contact request will be sent."}
    caller_id = current_user["effective_account_id"]
    email = body.email

    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        # Look up target by email — any active user
        cursor.execute(
            "SELECT AccountID FROM AccountData WHERE Email = %s AND IsActive = 1",
            (email,),
        )
        target = cursor.fetchone()

        if target is not None:
            target_id = target[0] if isinstance(target, tuple) else target["AccountID"]
            if target_id != caller_id:
                # INSERT IGNORE silently handles duplicates
                cursor.execute(
                    """
                    INSERT IGNORE INTO FriendRequests
                        (RequesterID, TargetEmail, TargetAccountID, Status)
                    VALUES (%s, %s, %s, 'pending')
                    """,
                    (caller_id, email, target_id),
                )
                conn.commit()

        # Always return the same response
        return _SILENT_RESPONSE
    finally:
        cursor.close()
        conn.close()


class DirectFriendRequestBody(BaseModel):
    target_account_id: int

@router.post("/messages/friend-request/direct", status_code=202)
def send_direct_friend_request(
    body: DirectFriendRequestBody,
    current_user: dict = Depends(require_role(2, 4)),
):
    """Send a contact request by account ID (researcher/admin only).
    Used when adding a colleague from the Browse Colleagues list.
    Always returns same response regardless of outcome (privacy).
    """
    _SILENT = {"detail": "If this user exists, a contact request will be sent."}
    caller_id = current_user["effective_account_id"]
    target_id = body.target_account_id
    if target_id == caller_id:
        return _SILENT
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(
            "SELECT Email FROM AccountData WHERE AccountID = %s AND IsActive = 1",
            (target_id,),
        )
        row = cursor.fetchone()
        if row:
            email = row[0] if isinstance(row, tuple) else row["Email"]
            cursor.execute(
                """
                INSERT IGNORE INTO FriendRequests
                    (RequesterID, TargetEmail, TargetAccountID, Status)
                VALUES (%s, %s, %s, 'pending')
                """,
                (caller_id, email, target_id),
            )
            conn.commit()
        return _SILENT
    finally:
        cursor.close()
        conn.close()


@router.get("/messages/friends")
def list_friends(
    current_user: dict = Depends(require_role(1, 2, 3, 4)),
):
    """Return contacts for the caller from accepted contact requests.

    All roles use the FriendRequests table. HCP contacts are created
    automatically when a patient link is approved.
    Response includes display_name, role_name, and email for each contact.
    """
    caller_id = current_user["effective_account_id"]

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(
            """
            SELECT
                CASE
                    WHEN fr.RequesterID = %s THEN fr.TargetAccountID
                    ELSE fr.RequesterID
                END AS account_id,
                CONCAT(
                    COALESCE(a.FirstName, ''), ' ', COALESCE(a.LastName, '')
                ) AS display_name,
                CASE a.RoleID
                    WHEN 1 THEN 'User'
                    WHEN 2 THEN 'Researcher'
                    WHEN 3 THEN 'Healthcare Provider'
                    WHEN 4 THEN 'Admin'
                    ELSE 'Unknown'
                END AS role_name,
                a.Email AS email
            FROM FriendRequests fr
            JOIN AccountData a ON a.AccountID = CASE
                WHEN fr.RequesterID = %s THEN fr.TargetAccountID
                ELSE fr.RequesterID
            END
            WHERE (fr.RequesterID = %s OR fr.TargetAccountID = %s)
              AND fr.Status = 'accepted'
            ORDER BY a.FirstName, a.LastName
            """,
            (caller_id, caller_id, caller_id, caller_id),
        )
        rows = cursor.fetchall()
        return rows
    finally:
        cursor.close()
        conn.close()


@router.delete("/messages/contacts/{contact_id}", status_code=200)
def delete_contact(
    contact_id: int,
    current_user: dict = Depends(require_role(1, 2, 3, 4)),
):
    """Remove a contact (delete the accepted FriendRequest between caller and contact)."""
    caller_id = current_user["effective_account_id"]

    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(
            """
            DELETE FROM FriendRequests
            WHERE ((RequesterID = %s AND TargetAccountID = %s)
                OR (RequesterID = %s AND TargetAccountID = %s))
              AND Status = 'accepted'
            """,
            (caller_id, contact_id, contact_id, caller_id),
        )
        conn.commit()
        return {"deleted": contact_id}
    finally:
        cursor.close()
        conn.close()


@router.get("/messages/researchers")
def list_researchers(
    q: Optional[str] = Query(None, description="Optional name filter"),
    current_user: dict = Depends(require_role(2, 4)),
):
    """List active researchers, optionally filtered by name.
    Excludes the caller. Only researchers and admins may use this endpoint.
    """
    caller_id = current_user["effective_account_id"]
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        if q and len(q.strip()) >= 1:
            like_val = f"%{q.strip()}%"
            cursor.execute(
                """
                SELECT
                    AccountID AS account_id,
                    CONCAT(COALESCE(FirstName,''),' ',COALESCE(LastName,'')) AS display_name
                FROM AccountData
                WHERE RoleID = 2 AND IsActive = 1 AND AccountID != %s
                  AND (FirstName LIKE %s OR LastName LIKE %s)
                ORDER BY FirstName, LastName
                LIMIT 50
                """,
                (caller_id, like_val, like_val),
            )
        else:
            cursor.execute(
                """
                SELECT
                    AccountID AS account_id,
                    CONCAT(COALESCE(FirstName,''),' ',COALESCE(LastName,'')) AS display_name
                FROM AccountData
                WHERE RoleID = 2 AND IsActive = 1 AND AccountID != %s
                ORDER BY FirstName, LastName
                LIMIT 50
                """,
                (caller_id,),
            )
        return cursor.fetchall()
    finally:
        cursor.close()
        conn.close()


@router.get("/messages/researchers/search")
def search_researchers(
    q: str = Query(..., min_length=2, description="Search query (first or last name)"),
    current_user: dict = Depends(require_role(2, 4)),
):
    """Search for researchers by name.

    Returns up to 20 results: account_id and display_name only (no email).
    Only researchers (RoleID=2) and admins may use this endpoint.
    """
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        like_val = f"%{q}%"
        cursor.execute(
            """
            SELECT
                AccountID AS account_id,
                CONCAT(
                    COALESCE(FirstName, ''), ' ', COALESCE(LastName, '')
                ) AS display_name
            FROM AccountData
            WHERE RoleID = 2
              AND IsActive = 1
              AND (FirstName LIKE %s OR LastName LIKE %s)
            LIMIT 20
            """,
            (like_val, like_val),
        )
        rows = cursor.fetchall()
        return rows
    finally:
        cursor.close()
        conn.close()


@router.get("/messages/friend-requests/incoming")
def list_incoming_friend_requests(
    current_user: dict = Depends(require_role(1, 2, 3, 4)),
):
    """Return pending friend requests where the caller is the target.

    HCP (3) and Researcher (2) roles do not use the friend-request system
    so this always returns an empty list for them.
    """
    caller_role = current_user["effective_role_id"]
    if caller_role not in (1, 4):
        return []
    caller_id = current_user["effective_account_id"]

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(
            """
            SELECT
                fr.RequestID AS request_id,
                fr.RequesterID AS requester_id,
                CONCAT(
                    COALESCE(a.FirstName, ''), ' ', COALESCE(a.LastName, '')
                ) AS requester_name,
                fr.RequestedAt AS requested_at
            FROM FriendRequests fr
            JOIN AccountData a ON a.AccountID = fr.RequesterID
            WHERE fr.TargetAccountID = %s
              AND fr.Status = 'pending'
            ORDER BY fr.RequestedAt DESC
            """,
            (caller_id,),
        )
        rows = cursor.fetchall()
        return rows
    finally:
        cursor.close()
        conn.close()


@router.put("/messages/friend-requests/{request_id}/respond", status_code=200)
def respond_to_friend_request(
    request_id: int,
    body: FriendRequestRespondBody,
    current_user: dict = Depends(require_role(1, 4)),
):
    """Accept or reject a friend request.

    Only the TargetAccountID (i.e. the recipient of the request) may respond.
    """
    if body.action not in ("accept", "reject"):
        raise HTTPException(status_code=400, detail="action must be 'accept' or 'reject'")

    caller_id = current_user["effective_account_id"]
    caller_role = current_user["effective_role_id"]

    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(
            "SELECT RequestID, TargetAccountID, Status FROM FriendRequests WHERE RequestID = %s",
            (request_id,),
        )
        row = cursor.fetchone()
        if not row:
            raise HTTPException(status_code=404, detail="Friend request not found")

        target_account_id = row[1] if isinstance(row, tuple) else row["TargetAccountID"]
        current_status = row[2] if isinstance(row, tuple) else row["Status"]

        if current_status != "pending":
            raise HTTPException(status_code=400, detail="Request is not pending")

        # Only the target can respond (admin may respond on behalf of target)
        if caller_role != 4 and caller_id != target_account_id:
            raise HTTPException(
                status_code=403,
                detail="Only the request target can respond",
            )

        new_status = "accepted" if body.action == "accept" else "rejected"
        cursor.execute(
            "UPDATE FriendRequests SET Status = %s WHERE RequestID = %s",
            (new_status, request_id),
        )
        conn.commit()
        return {"request_id": request_id, "status": new_status}
    finally:
        cursor.close()
        conn.close()
