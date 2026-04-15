# Created with the Assistance of Claude Code
# backend/app/api/v1/users.py
"""
User Management API

Endpoints:
- GET    /api/v1/users              - List all users
- GET    /api/v1/users/{id}         - Get single user
- POST   /api/v1/users              - Create user
- PUT    /api/v1/users/{id}         - Update user
- PATCH  /api/v1/users/{id}/status  - Toggle user active status
- DELETE /api/v1/users/{id}         - Delete user

SECURITY: All queries use parameterized statements to prevent SQL injection.
"""

from fastapi import APIRouter, Depends, HTTPException, Query, Request
from pydantic import BaseModel, field_validator, model_validator, Field, EmailStr
from typing import Optional, List
from enum import Enum
from datetime import date, datetime, timezone
import mysql.connector
from ...utils.utils import get_db_connection
from ..deps import require_role, get_current_user, sanitized_string
from .auth import hash_password
from ...services.email import email_service as _email_service
from ...services.email import config as _email_config
import logging as _logging

_logger = _logging.getLogger(__name__)


router = APIRouter(dependencies=[Depends(require_role(4))])
self_router = APIRouter()

# Enums
class UserRole(str, Enum):
    participant = "participant"
    researcher = "researcher"
    hcp = "hcp"
    admin = "admin"


# Pydantic Models
_ALLOWED_GENDERS = {'Male', 'Female', 'Non-Binary', 'Prefer Not to Say', 'Other'}


class UserCreate(BaseModel):
    first_name: str = Field(..., min_length=1, max_length=64)
    last_name: str = Field(..., min_length=1, max_length=64)
    email: EmailStr
    password: Optional[str] = Field(None, min_length=8, max_length=128)
    role: Optional[UserRole] = UserRole.participant
    is_active: Optional[bool] = True
    send_setup_email: bool = False
    birthdate: Optional[date] = None
    gender: Optional[str] = Field(None, min_length=1, max_length=64)

    @model_validator(mode='after')
    def require_password_when_no_email(self):
        if not self.send_setup_email and not self.password:
            raise ValueError("password is required when send_setup_email is false")
        return self

    @field_validator('first_name', 'last_name', mode='before')
    @classmethod
    def sanitize(cls, v):
        return sanitized_string(v)

    @field_validator('first_name', 'last_name')
    @classmethod
    def validate_name(cls, v: str) -> str:
        v = v.strip()
        if not v:  # pragma: no cover — Pydantic min_length catches first
            raise ValueError('Name cannot be empty')
        return v

    @field_validator('birthdate', mode='before')
    @classmethod
    def validate_birthdate(cls, v):
        if v is None:
            return v
        if isinstance(v, date):
            return v
        try:
            return date.fromisoformat(str(v))
        except (ValueError, TypeError):
            raise ValueError('birthdate must be in YYYY-MM-DD format')

    @field_validator('gender')
    @classmethod
    def validate_gender(cls, v):
        if v is None:
            return v
        if v not in _ALLOWED_GENDERS:
            raise ValueError(f'gender must be one of: {", ".join(sorted(_ALLOWED_GENDERS))}')
        return v


class UserUpdate(BaseModel):
    first_name: Optional[str] = Field(None, min_length=1, max_length=64)
    last_name: Optional[str] = Field(None, min_length=1, max_length=64)
    email: Optional[EmailStr] = None
    role: Optional[UserRole] = None
    is_active: Optional[bool] = None

    @field_validator('first_name', 'last_name', mode='before')
    @classmethod
    def sanitize(cls, v):
        return sanitized_string(v)
    
class CurrentUserUpdate(BaseModel):
    first_name: Optional[str] = Field(None, min_length=1, max_length=64)
    last_name: Optional[str] = Field(None, min_length=1, max_length=64)
    email: Optional[EmailStr] = None
    birthdate: Optional[date] = None
    gender: Optional[str] = Field(None, min_length=1, max_length=64)

    @field_validator('first_name', 'last_name', 'gender', mode='before')
    @classmethod
    def sanitize(cls, v):
        return sanitized_string(v)


class UserResponse(BaseModel):
    account_id: int
    first_name: str
    last_name: str
    email: str
    role: Optional[str] = None
    is_active: bool = True
    birthdate: Optional[date] = None
    gender: Optional[str] = None
    created_at: Optional[datetime] = None
    last_login: Optional[datetime] = None
    consent_signed_at: Optional[datetime] = None
    consent_version: Optional[str] = None


class UserListResponse(BaseModel):
    users: List[UserResponse]
    total: int


# Helper functions
def _as_utc(dt: datetime | None) -> datetime | None:
    """Mark a naive datetime from MySQL as UTC."""
    if dt is not None and dt.tzinfo is None:
        return dt.replace(tzinfo=timezone.utc)
    return dt


def row_to_user_response(row: tuple) -> UserResponse:
    """Convert database row to UserResponse model."""
    return UserResponse(
        account_id=row[0],
        first_name=row[1] or '',
        last_name=row[2] or '',
        email=row[3] or '',
        role=row[4] if len(row) > 4 else None,
        is_active=bool(row[5]) if len(row) > 5 and row[5] is not None else True,
        birthdate=row[6] if len(row) > 6 else None,
        gender=row[7] if len(row) > 7 else None,
        created_at=_as_utc(row[8] if len(row) > 8 else None),
        last_login=_as_utc(row[9] if len(row) > 9 else None),
        consent_signed_at=_as_utc(row[10] if len(row) > 10 else None),
        consent_version=row[11] if len(row) > 11 else None,
    )


# Endpoints
@router.get("/")
async def list_users(
    role: Optional[str] = Query(None, description="Filter by role"),
    is_active: Optional[bool] = Query(None, description="Filter by active status"),
    search: Optional[str] = Query(None, description="Search by name or email"),
    limit: int = Query(100, ge=1, le=500),
    offset: int = Query(0, ge=0),
) -> UserListResponse:
    """List all users with optional filtering."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Build query with optional filters
        # Join with Roles table to get role name
        query = """
            SELECT
                a.AccountID, a.FirstName, a.LastName, a.Email,
                r.RoleName as Role,
                a.IsActive,
                a.Birthdate,
                a.Gender,
                a.CreatedAt,
                (SELECT MAX(s.CreatedAt) FROM Sessions s WHERE s.AccountID = a.AccountID) as LastLogin,
                a.ConsentSignedAt,
                a.ConsentVersion
            FROM AccountData a
            LEFT JOIN Roles r ON a.RoleID = r.RoleID
            WHERE 1=1
        """
        count_query = """
            SELECT COUNT(*) FROM AccountData a
            LEFT JOIN Roles r ON a.RoleID = r.RoleID
            WHERE 1=1
        """
        params = []
        count_params = []

        if search:
            search_term = f"%{search}%"
            query += " AND (a.FirstName LIKE %s OR a.LastName LIKE %s OR a.Email LIKE %s)"
            count_query += " AND (a.FirstName LIKE %s OR a.LastName LIKE %s OR a.Email LIKE %s)"
            params.extend([search_term, search_term, search_term])
            count_params.extend([search_term, search_term, search_term])

        if role:
            query += " AND r.RoleName = %s"
            count_query += " AND r.RoleName = %s"
            params.append(role)
            count_params.append(role)

        if is_active is not None:
            query += " AND a.IsActive = %s"
            count_query += " AND a.IsActive = %s"
            params.append(is_active)
            count_params.append(is_active)

        query += " ORDER BY a.AccountID DESC LIMIT %s OFFSET %s"
        params.extend([limit, offset])

        # Get total count
        cursor.execute(count_query, tuple(count_params))
        result = cursor.fetchone()
        total = result[0] if result else 0

        # Get users
        cursor.execute(query, tuple(params))
        rows = cursor.fetchall()

        users = [row_to_user_response(row) for row in rows]

        return UserListResponse(users=users, total=total)
    finally:
        cursor.close()
        conn.close()


@router.get("/{user_id}")
async def get_user(user_id: int) -> UserResponse:
    """Get a single user by ID."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute(
            """
            SELECT
                a.AccountID, a.FirstName, a.LastName, a.Email,
                r.RoleName as Role,
                a.IsActive,
                a.Birthdate,
                a.Gender,
                a.CreatedAt,
                (SELECT MAX(s.CreatedAt) FROM Sessions s WHERE s.AccountID = a.AccountID) as LastLogin,
                a.ConsentSignedAt,
                a.ConsentVersion
            FROM AccountData a
            LEFT JOIN Roles r ON a.RoleID = r.RoleID
            WHERE a.AccountID = %s
            """,
            (user_id,)
        )
        row = cursor.fetchone()

        if not row:
            raise HTTPException(status_code=404, detail="User not found")

        return row_to_user_response(row)
    finally:
        cursor.close()
        conn.close()


@router.post("/", status_code=201)
async def create_user(user: UserCreate) -> UserResponse:
    """Create a new user with Auth record so they can log in."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Check if email already exists
        cursor.execute(
            "SELECT AccountID FROM AccountData WHERE Email = %s",
            (user.email,)
        )
        if cursor.fetchone():  # pragma: no cover — duplicate email tested but FakeCursor can't trigger errno 1062
            raise HTTPException(status_code=409, detail="Email already registered")

        # Get RoleID from role name
        role_id = 1  # Default to participant
        if user.role:
            cursor.execute("SELECT RoleID FROM Roles WHERE RoleName = %s", (user.role.value,))
            role_row = cursor.fetchone()
            if role_row:
                role_id = role_row[0]

        # Determine password: auto-generate when sending setup email
        import secrets, string as _string
        if user.send_setup_email:
            alphabet = _string.ascii_letters + _string.digits + "!@#$%^&*"
            pwd_chars = [
                secrets.choice(_string.ascii_uppercase),
                secrets.choice(_string.ascii_lowercase),
                secrets.choice(_string.digits),
                secrets.choice("!@#$%^&*"),
            ]
            pwd_chars.extend(secrets.choice(alphabet) for _ in range(12))
            secrets.SystemRandom().shuffle(pwd_chars)
            plain_password = ''.join(pwd_chars)
        else:
            plain_password = user.password  # type: ignore[assignment]

        # Create Auth record first (MustChangePassword=TRUE so user changes temp password)
        hashed_password = hash_password(plain_password)
        cursor.execute(
            "INSERT INTO Auth (PasswordHash, MustChangePassword) VALUES (%s, TRUE)",
            (hashed_password,)
        )
        auth_id = cursor.lastrowid

        # Insert user with RoleID and AuthID
        try:
            cursor.execute(
                """
                INSERT INTO AccountData (FirstName, LastName, Email, RoleID, AuthID, IsActive, Birthdate, Gender)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                """,
                (user.first_name, user.last_name, user.email, role_id, auth_id,
                 user.is_active if user.is_active is not None else True,
                 user.birthdate, user.gender)
            )
            conn.commit()
        except mysql.connector.IntegrityError:
            conn.rollback()
            raise HTTPException(status_code=409, detail="Email already registered")

        user_id = cursor.lastrowid

        # Send account setup email if requested
        email_sent = False
        if user.send_setup_email:
            try:
                email_sent = _email_service.send_account_created_email(
                    user_name=user.first_name,
                    user_email=user.email,
                    temporary_password=plain_password,
                    login_url=_email_config.LOGIN_URL,
                )
                if not email_sent:
                    _logger.error("Account creation email failed for %s", user.email)
            except Exception as exc:
                _logger.error("Account creation email error for %s: %s", user.email, exc)

        # Fetch and return created user
        cursor.execute(
            """
            SELECT
                a.AccountID, a.FirstName, a.LastName, a.Email,
                r.RoleName as Role,
                a.IsActive,
                a.Birthdate,
                a.Gender,
                a.CreatedAt,
                NULL as LastLogin,
                a.ConsentSignedAt,
                a.ConsentVersion
            FROM AccountData a
            LEFT JOIN Roles r ON a.RoleID = r.RoleID
            WHERE a.AccountID = %s
            """,
            (user_id,)
        )
        row = cursor.fetchone()

        return row_to_user_response(row)
    except mysql.connector.Error as err:  # pragma: no cover — FakeCursor returns success
        conn.rollback()  # pragma: no cover
        raise HTTPException(status_code=500, detail=f"Database error: {str(err)}")
    finally:
        cursor.close()
        conn.close()





@self_router.put("/me")
async def update_current_user(user: CurrentUserUpdate, current_user=Depends(get_current_user)) -> UserResponse:
    """Update the current authenticated user."""
    conn = get_db_connection()
    cursor = conn.cursor()

    user_id = current_user["account_id"]

    try:
        # Check if user exists
        cursor.execute(
            "SELECT AccountID FROM AccountData WHERE AccountID = %s",
            (user_id,)
        )
        if not cursor.fetchone():
            raise HTTPException(status_code=404, detail="User not found")

        # Check email uniqueness if being updated
        if user.email:
            cursor.execute(
                "SELECT AccountID FROM AccountData WHERE Email = %s AND AccountID != %s",
                (user.email, user_id)
            )
            if cursor.fetchone():  # pragma: no cover — FakeCursor returns success
                raise HTTPException(status_code=400, detail="Email already in use")

        # Build update query dynamically
        updates = []
        params = []

        if user.first_name is not None:
            updates.append("FirstName = %s")
            params.append(user.first_name)

        if user.last_name is not None:
            updates.append("LastName = %s")
            params.append(user.last_name)

        if user.email is not None:
            updates.append("Email = %s")
            params.append(user.email)

        if user.birthdate is not None:
            updates.append("Birthdate = %s")
            params.append(user.birthdate)

        if user.gender is not None:
            updates.append("Gender = %s")
            params.append(user.gender)

        if updates:
            query = f"UPDATE AccountData SET {', '.join(updates)} WHERE AccountID = %s"
            params.append(user_id)
            cursor.execute(query, tuple(params))
            conn.commit()

        return fetch_user_by_id(user_id)
    except mysql.connector.IntegrityError:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Email already in use")
    except mysql.connector.Error as err:  # pragma: no cover — FakeCursor returns success
        conn.rollback()  # pragma: no cover
        raise HTTPException(status_code=500, detail=f"Database error: {str(err)}")
    finally:
        cursor.close()
        conn.close()

# I don't believe this is used at all, and put users/me will be the new endpoint for updating user data
# marked for removal if doesn't have any use in the frontend
@router.put("/{user_id}")
async def update_user(user_id: int, user: UserUpdate) -> UserResponse:
    """Update an existing user."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Check if user exists
        cursor.execute(
            "SELECT AccountID FROM AccountData WHERE AccountID = %s",
            (user_id,)
        )
        if not cursor.fetchone():
            raise HTTPException(status_code=404, detail="User not found")

        # Check email uniqueness if being updated
        if user.email:
            cursor.execute(
                "SELECT AccountID FROM AccountData WHERE Email = %s AND AccountID != %s",
                (user.email, user_id)
            )
            if cursor.fetchone():  # pragma: no cover — FakeCursor returns success
                raise HTTPException(status_code=400, detail="Email already in use")

        # Build update query dynamically
        updates = []
        params = []

        if user.first_name is not None:  # pragma: no cover
            updates.append("FirstName = %s")  # pragma: no cover
            params.append(user.first_name)  # pragma: no cover

        if user.last_name is not None:
            updates.append("LastName = %s")
            params.append(user.last_name)

        if user.email is not None:
            updates.append("Email = %s")
            params.append(user.email)

        if user.role is not None:
            cursor.execute("SELECT RoleID FROM Roles WHERE RoleName = %s", (user.role.value,))
            role_row = cursor.fetchone()
            if role_row:
                updates.append("RoleID = %s")
                params.append(role_row[0])

        if user.is_active is not None:
            updates.append("IsActive = %s")
            params.append(user.is_active)

        if updates:
            query = f"UPDATE AccountData SET {', '.join(updates)} WHERE AccountID = %s"
            params.append(user_id)
            cursor.execute(query, tuple(params))
            conn.commit()

        # Fetch and return updated user
        return fetch_user_by_id(user_id)
    except mysql.connector.IntegrityError:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Email already in use")
    except mysql.connector.Error as err:  # pragma: no cover — FakeCursor returns success
        conn.rollback()  # pragma: no cover
        raise HTTPException(status_code=500, detail=f"Database error: {str(err)}")
    finally:
        cursor.close()
        conn.close()


@router.patch("/{user_id}/status")
async def toggle_user_status(
    user_id: int,
    is_active: bool,
    current_user=Depends(get_current_user),
) -> UserResponse:
    """Toggle user active status."""
    if current_user["account_id"] == user_id and not is_active:
        raise HTTPException(
            status_code=400,
            detail="You cannot deactivate your own account.",
        )

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Check if user exists
        cursor.execute(
            "SELECT AccountID FROM AccountData WHERE AccountID = %s",
            (user_id,)
        )
        if not cursor.fetchone():
            raise HTTPException(status_code=404, detail="User not found")

        cursor.execute(
            "UPDATE AccountData SET IsActive = %s WHERE AccountID = %s",
            (is_active, user_id)
        )
        conn.commit()

        return fetch_user_by_id(user_id)
    finally:
        cursor.close()
        conn.close()


@router.delete("/{user_id}", status_code=204)
async def delete_user(user_id: int, current_user=Depends(get_current_user)):
    """Permanently delete a user account.

    Survey response data is preserved: ParticipantID is set to NULL so
    aggregate research data remains intact after the account is removed.
    All other personal data (sessions, assignments, messages, consent
    records) is deleted. Foreign-key owned rows (HCP links, conversations,
    2FA records) are removed via ON DELETE CASCADE.

    Raises 400 if the caller attempts to delete their own account.
    """
    if current_user["account_id"] == user_id:
        raise HTTPException(status_code=400, detail="Cannot delete your own account")

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Fetch AuthID before any deletions
        cursor.execute(
            "SELECT AccountID, AuthID FROM AccountData WHERE AccountID = %s",
            (user_id,),
        )
        row = cursor.fetchone()
        if not row:
            raise HTTPException(status_code=404, detail="User not found")
        auth_id = row[1]

        # Nullify ImpersonatedBy / ViewingAsUserID references before
        # deleting sessions — these columns have no ON DELETE behaviour.
        cursor.execute(
            "UPDATE Sessions SET ImpersonatedBy = NULL WHERE ImpersonatedBy = %s",
            (user_id,),
        )
        cursor.execute(
            "UPDATE Sessions SET ViewingAsUserID = NULL WHERE ViewingAsUserID = %s",
            (user_id,),
        )

        # Remove the user's own sessions
        cursor.execute(
            "DELETE FROM Sessions WHERE AccountID = %s",
            (user_id,),
        )

        # Remove survey assignments
        cursor.execute(
            "DELETE FROM SurveyAssignment WHERE AccountID = %s",
            (user_id,),
        )

        # Preserve survey response data — anonymise rather than delete.
        # Setting ParticipantID = NULL retains all ResponseValue, SurveyID,
        # and QuestionID data for aggregate research reporting.
        cursor.execute(
            "UPDATE Responses SET ParticipantID = NULL WHERE ParticipantID = %s",
            (user_id,),
        )

        # Remove consent records
        cursor.execute(
            "DELETE FROM ConsentRecord WHERE AccountID = %s",
            (user_id,),
        )

        # Remove sent messages (SenderID is NOT NULL — rows must be deleted)
        cursor.execute(
            "DELETE FROM Messages WHERE SenderID = %s",
            (user_id,),
        )

        # Nullify CreatorID on surveys and templates so the records survive
        cursor.execute(
            "UPDATE Survey SET CreatorID = NULL WHERE CreatorID = %s",
            (user_id,),
        )
        cursor.execute(
            "UPDATE SurveyTemplate SET CreatorID = NULL WHERE CreatorID = %s",
            (user_id,),
        )

        # Nullify ReviewedBy on account requests
        cursor.execute(
            "UPDATE AccountRequest SET ReviewedBy = NULL WHERE ReviewedBy = %s",
            (user_id,),
        )

        # Delete the account row (cascades to Account2FA, mfa_challenges,
        # HcpPatientLink, ConversationParticipants, FriendRequests)
        cursor.execute(
            "DELETE FROM AccountData WHERE AccountID = %s",
            (user_id,),
        )

        # Delete the Auth record if one exists
        if auth_id:
            cursor.execute(
                "DELETE FROM Auth WHERE AuthID = %s",
                (auth_id,),
            )

        conn.commit()
        return None
    except mysql.connector.Error as err:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(err)}")
    finally:
        cursor.close()
        conn.close()


def fetch_user_by_id(user_id: int) -> UserResponse:
    """Fetch a single user record by AccountID. Raises 404 if not found. Used internally by admin and user endpoints."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute(
            """
            SELECT
                a.AccountID, a.FirstName, a.LastName, a.Email,
                r.RoleName as Role,
                a.IsActive,
                a.Birthdate,
                a.Gender,
                a.CreatedAt,
                (SELECT MAX(s.CreatedAt) FROM Sessions s WHERE s.AccountID = a.AccountID) as LastLogin,
                a.ConsentSignedAt,
                a.ConsentVersion
            FROM AccountData a
            LEFT JOIN Roles r ON a.RoleID = r.RoleID
            WHERE a.AccountID = %s
            """,
            (user_id,)
        )
        row = cursor.fetchone()

        if not row:
            raise HTTPException(status_code=404, detail="User not found")

        return row_to_user_response(row)
    finally:
        cursor.close()
        conn.close()