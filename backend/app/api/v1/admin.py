# Created with the Assistance of Claude Code
# backend/app/api/v1/admin.py
"""
Admin API - Database Viewer & User Management

Endpoints:
- GET    /api/v1/admin/tables                          - List all database tables
- GET    /api/v1/admin/tables/{name}                   - Get table schema and data
- GET    /api/v1/admin/tables/{name}/data              - Get table data only
- POST   /api/v1/admin/users                           - Create user with temp password
- POST   /api/v1/admin/users/{user_id}/reset-password  - Reset user password (admin only)
- POST   /api/v1/admin/users/{user_id}/send-reset-email - Send password reset email
- POST   /api/v1/admin/users/{user_id}/view-as         - Start viewing as user (system admin only)
- POST   /api/v1/admin/view-as/end                     - End view-as mode
- POST   /api/v1/admin/users/{user_id}/impersonate     - [DEPRECATED] Use view-as instead
- POST   /api/v1/admin/impersonate/end                 - [DEPRECATED] Use view-as/end instead

SECURITY:
- All queries use parameterized statements to prevent SQL injection.
- Sensitive data (passwords, tokens) is excluded from responses.
- Temporary passwords are generated using cryptographically secure methods.
- Password reset requires admin authentication.
- View-as/impersonation requires system administrator role (RoleID = 4).
"""

from fastapi import APIRouter, Depends, HTTPException, Query, Request, status
from pydantic import BaseModel, Field, field_validator, EmailStr
from typing import Optional, List, Any, Dict
from datetime import datetime, timezone
import logging
import mysql.connector
import secrets
import string

logger = logging.getLogger(__name__)
from ...utils.utils import get_db_connection
from .auth import hash_password
from .sessions import hash_token, get_token
from ...services.email import email_service as _email_service
from ..deps import require_role, sanitized_string
from ...services.settings import (
    get_int_setting, get_bool_setting, get_setting, invalidate_cache,
    DEFAULTS as _SETTING_DEFAULTS,
)


router = APIRouter(dependencies=[Depends(require_role(4))])


# Tables containing sensitive columns that should be excluded from responses
SENSITIVE_COLUMNS = {
    'Auth': ['PasswordHash'],
    'Sessions': ['TokenHash'],
    'mfa_challenges': ['TokenHash'],
}


import re as _re

_TABLE_NAME_RE = _re.compile(r'^[A-Za-z0-9_]+$')


def _assert_safe_identifier(name: str) -> None:
    """Raise HTTPException if name contains anything other than alphanum/underscore.

    MySQL table and column names sourced from INFORMATION_SCHEMA are safe, but
    the table_name path parameter is user-supplied, so we validate it here before
    embedding it in f-string SQL to prevent identifier injection.
    """
    if not _TABLE_NAME_RE.fullmatch(name):
        raise HTTPException(status_code=400, detail="Invalid identifier.")


def get_all_table_names(cursor) -> list[str]:
    """Return all user tables in the current database, sorted alphabetically."""
    cursor.execute("""
        SELECT TABLE_NAME
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_TYPE = 'BASE TABLE'
        ORDER BY TABLE_NAME
    """)
    return [row[0] for row in cursor.fetchall()]


def table_exists(cursor, table_name: str) -> bool:
    """Check whether a table exists in the current database."""
    cursor.execute("""
        SELECT COUNT(*)
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_TYPE = 'BASE TABLE'
          AND TABLE_NAME = %s
    """, (table_name,))
    return cursor.fetchone()[0] == 1


# Pydantic Models
class ColumnInfo(BaseModel):
    name: str
    type: str
    is_primary_key: bool = False
    is_foreign_key: bool = False
    is_nullable: bool = True
    foreign_key_ref: Optional[str] = None


class TableSchema(BaseModel):
    name: str
    description: str
    columns: List[ColumnInfo]
    row_count: int


class TableData(BaseModel):
    name: str
    columns: List[str]
    rows: List[Dict[str, Any]]
    total: int


class TableListResponse(BaseModel):
    tables: List[TableSchema]


class TableDetailResponse(BaseModel):
    schema_info: TableSchema
    data: TableData

class PurgeUserResponse(BaseModel):
    message: str
    purged_user_id: int
    deleted: Dict[str, int]


# Table descriptions — any table not listed here gets an empty description
TABLE_DESCRIPTIONS = {
    'Account2FA': 'Two-factor authentication settings per account',
    'AccountData': 'User account information and profile details',
    'AccountRequest': 'Pending account creation requests awaiting approval',
    'AuditEvent': 'Audit log of security-relevant events',
    'Auth': 'Password hashes for user authentication (sensitive columns hidden)',
    'ConsentRecord': 'Records of participants signing the consent document',
    'ConversationParticipants': 'Maps accounts to conversations (many-to-many)',
    'Conversations': 'Messaging conversations between users',
    'DataTypes': 'Categories for health data collected by questions',
    'FriendRequests': 'Friend/connection requests between participant accounts',
    'HcpPatientLink': 'Links between HCP providers and their patients',
    'Messages': 'Individual messages sent within conversations',
    'QuestionBank': 'Reusable questions that can be added to surveys',
    'QuestionCategories': 'Categories for organizing survey questions',
    'QuestionList': 'Links questions to surveys (many-to-many)',
    'QuestionOptions': 'Options for single_choice and multi_choice questions',
    'Responses': 'Participant answers to survey questions',
    'Roles': 'User roles defining access permissions',
    'Sessions': 'Active user login sessions (sensitive columns hidden)',
    'Survey': 'Survey definitions created by researchers',
    'SurveyAssignment': 'Tracks which surveys are assigned to which participants',
    'SurveyTemplate': 'Reusable survey templates created by researchers',
    'TemplateQuestions': 'Links questions to survey templates (many-to-many)',
    'mfa_challenges': 'One-time MFA token challenges (sensitive columns hidden)',
}


def get_table_schema(cursor, table_name: str) -> TableSchema:
    """Get schema information for a table."""
    _assert_safe_identifier(table_name)
    # Get column information
    cursor.execute("""
        SELECT
            COLUMN_NAME,
            COLUMN_TYPE,
            COLUMN_KEY,
            IS_NULLABLE,
            EXTRA
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = %s
        ORDER BY ORDINAL_POSITION
    """, (table_name,))

    columns_data = cursor.fetchall()

    # Get foreign key information
    cursor.execute("""
        SELECT
            COLUMN_NAME,
            REFERENCED_TABLE_NAME,
            REFERENCED_COLUMN_NAME
        FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
        WHERE TABLE_SCHEMA = DATABASE()
            AND TABLE_NAME = %s
            AND REFERENCED_TABLE_NAME IS NOT NULL
    """, (table_name,))

    fk_info = {row[0]: f"{row[1]}({row[2]})" for row in cursor.fetchall()}

    # Get row count
    cursor.execute(f"SELECT COUNT(*) FROM `{table_name}`")
    row_count = cursor.fetchone()[0]

    # Build column info
    columns = []
    sensitive_cols = SENSITIVE_COLUMNS.get(table_name, [])

    for col in columns_data:
        col_name = col[0]
        # Skip sensitive columns
        if col_name in sensitive_cols:
            continue

        columns.append(ColumnInfo(
            name=col_name,
            type=col[1],
            is_primary_key=col[2] == 'PRI',
            is_foreign_key=col_name in fk_info,
            is_nullable=col[3] == 'YES',
            foreign_key_ref=fk_info.get(col_name),
        ))

    return TableSchema(
        name=table_name,
        description=TABLE_DESCRIPTIONS.get(table_name, ''),
        columns=columns,
        row_count=row_count,
    )


def get_table_data(cursor, table_name: str, limit: int = 100, offset: int = 0) -> TableData:
    """Get data from a table, excluding sensitive columns."""
    _assert_safe_identifier(table_name)
    sensitive_cols = SENSITIVE_COLUMNS.get(table_name, [])

    # Get all columns except sensitive ones
    cursor.execute("""
        SELECT COLUMN_NAME
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = %s
        ORDER BY ORDINAL_POSITION
    """, (table_name,))

    all_columns = [row[0] for row in cursor.fetchall()]
    safe_columns = [col for col in all_columns if col not in sensitive_cols]

    if not safe_columns:
        return TableData(name=table_name, columns=[], rows=[], total=0)

    # Build column list for query — validate each column name before embedding
    for col in safe_columns:
        _assert_safe_identifier(col)
    column_list = ', '.join(f'`{col}`' for col in safe_columns)

    # Get total count
    cursor.execute(f"SELECT COUNT(*) FROM `{table_name}`")
    total = cursor.fetchone()[0]

    # Get data with limit/offset
    cursor.execute(f"SELECT {column_list} FROM `{table_name}` LIMIT %s OFFSET %s", (limit, offset))
    rows_data = cursor.fetchall()

    # Convert to list of dicts, handling non-JSON-serializable types
    rows = []
    for row in rows_data:
        row_dict = {}
        for i, col in enumerate(safe_columns):
            value = row[i]
            if isinstance(value, datetime):
                value = value.isoformat()
            elif isinstance(value, (bytes, bytearray)):
                # VARBINARY / BINARY columns (e.g. IpAddress) → hex string
                value = value.hex() if value else None
            row_dict[col] = value
        rows.append(row_dict)

    return TableData(
        name=table_name,
        columns=safe_columns,
        rows=rows,
        total=total,
    )


@router.get("/tables")
async def list_tables() -> TableListResponse:
    """List all database tables with schema info (dynamically from live DB)."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        tables = []
        for table_name in get_all_table_names(cursor):
            try:
                schema = get_table_schema(cursor, table_name)
                tables.append(schema)
            except Exception:
                pass

        return TableListResponse(tables=tables)
    finally:
        cursor.close()
        conn.close()


@router.get("/tables/{table_name}")
async def get_table(
    table_name: str,
    limit: int = Query(100, ge=1, le=1000),
    offset: int = Query(0, ge=0),
) -> TableDetailResponse:
    """Get table schema and data."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        if not table_exists(cursor, table_name):
            raise HTTPException(status_code=404, detail=f"Table '{table_name}' not found")

        schema = get_table_schema(cursor, table_name)
        data = get_table_data(cursor, table_name, limit, offset)

        return TableDetailResponse(schema_info=schema, data=data)
    except mysql.connector.Error as err:
        logger.error("get_table_detail DB error for table %s: %s", table_name, err)
        raise HTTPException(status_code=500, detail="Database error")
    finally:
        cursor.close()
        conn.close()


@router.get("/tables/{table_name}/data")
async def get_table_data_only(
    table_name: str,
    limit: int = Query(100, ge=1, le=1000),
    offset: int = Query(0, ge=0),
) -> TableData:
    """Get table data only (no schema)."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        if not table_exists(cursor, table_name):
            raise HTTPException(status_code=404, detail=f"Table '{table_name}' not found")

        return get_table_data(cursor, table_name, limit, offset)
    except mysql.connector.Error as err:
        logger.error("get_table_data_only DB error for table %s: %s", table_name, err)
        raise HTTPException(status_code=500, detail="Database error")
    finally:
        cursor.close()
        conn.close()


# =============================================================================
# Secure Temp Password Generation
# =============================================================================

def generate_temp_password(length: int = 16) -> str:
    """
    Generate a cryptographically secure temporary password.

    Uses Python's secrets module for secure random generation.
    Password includes uppercase, lowercase, digits, and special characters.

    Args:
        length: Password length (default 16, minimum 12)

    Returns:
        A secure random password string
    """
    if length < 12:
        length = 12

    # Character sets for password generation
    alphabet = string.ascii_letters + string.digits + "!@#$%^&*"

    # Ensure at least one of each required character type
    password = [
        secrets.choice(string.ascii_uppercase),
        secrets.choice(string.ascii_lowercase),
        secrets.choice(string.digits),
        secrets.choice("!@#$%^&*"),
    ]

    # Fill remaining length with random characters
    password.extend(secrets.choice(alphabet) for _ in range(length - 4))

    # Shuffle to avoid predictable positions
    secrets.SystemRandom().shuffle(password)

    return ''.join(password)


# =============================================================================
# Admin User Creation Endpoint
# =============================================================================

_ALLOWED_GENDERS = {'Male', 'Female', 'Non-Binary', 'Prefer Not to Say', 'Other'}


class AdminUserCreate(BaseModel):
    """Request body for admin-initiated user creation."""
    email: EmailStr = Field(..., description="User's email address")
    first_name: str = Field(..., min_length=1, max_length=50, description="User's first name")
    last_name: str = Field(..., min_length=1, max_length=50, description="User's last name")
    role_id: int = Field(default=1, ge=1, le=4, description="Role ID (1=Participant, 2=Researcher, 3=Admin, 4=SysAdmin)")
    birthdate: Optional[str] = Field(None, description="Date of birth (YYYY-MM-DD), participant accounts only")
    gender: Optional[str] = Field(None, description="Gender (male/female/non-binary/prefer_not_to_say/other)")

    @field_validator('email', 'first_name', 'last_name', mode='before')
    @classmethod
    def sanitize(cls, v):
        return sanitized_string(v)

    @field_validator('email')
    @classmethod
    def normalize_email(cls, v: str) -> str:
        return v.lower().strip()

    @field_validator('first_name', 'last_name')
    @classmethod
    def strip_whitespace(cls, v: str) -> str:
        return v.strip()

    @field_validator('birthdate')
    @classmethod
    def validate_birthdate(cls, v: Optional[str]) -> Optional[str]:
        if v is None:
            return v
        from datetime import datetime
        try:
            datetime.strptime(v, '%Y-%m-%d')
        except ValueError:
            raise ValueError("birthdate must be in YYYY-MM-DD format")
        return v

    @field_validator('gender')
    @classmethod
    def validate_gender(cls, v: Optional[str]) -> Optional[str]:
        if v is None:
            return v
        if v not in _ALLOWED_GENDERS:
            raise ValueError(f"gender must be one of: {', '.join(_ALLOWED_GENDERS)}")
        return v


class AdminUserCreateResponse(BaseModel):
    """Response for admin-initiated user creation."""
    message: str
    user_id: int
    email: str
    first_name: str
    last_name: str
    role_id: int


@router.post("/users", status_code=status.HTTP_201_CREATED)
async def create_user_with_temp_password(
    user_data: AdminUserCreate,
) -> AdminUserCreateResponse:
    """
    Create a new user account with an auto-generated temporary password.

    Admin-only endpoint for creating user accounts. Generates a secure
    temporary password that should be communicated to the user securely.

    Args:
        user_data: User details (email, first_name, last_name, role_id)

    Returns:
        Created user info including temporary password (shown only once)

    Raises:
        400: Email already exists
        500: Database error
    """
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        # Check if email already exists
        cursor.execute(
            "SELECT AccountID FROM AccountData WHERE Email = %s",
            (user_data.email,)
        )
        if cursor.fetchone():
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail=f"Email '{user_data.email}' is already registered"
            )

        # Generate secure temporary password
        temp_password = generate_temp_password()
        hashed_password = hash_password(temp_password)

        # Create Auth record first (MustChangePassword=TRUE so user changes temp password)
        cursor.execute(
            "INSERT INTO Auth (PasswordHash, MustChangePassword) VALUES (%s, TRUE)",
            (hashed_password,)
        )
        auth_id = cursor.lastrowid

        # Create AccountData record
        cursor.execute(
            """
            INSERT INTO AccountData (Email, FirstName, LastName, RoleID, AuthID, IsActive, Birthdate, Gender)
            VALUES (%s, %s, %s, %s, %s, TRUE, %s, %s)
            """,
            (user_data.email, user_data.first_name, user_data.last_name,
             user_data.role_id, auth_id, user_data.birthdate, user_data.gender)
        )
        account_id = cursor.lastrowid

        conn.commit()

        # Send welcome email with temp password and login link
        email_sent = False
        try:
            email_sent = _email_service.send_account_created_email(
                user_name=user_data.first_name,
                user_email=user_data.email,
                temporary_password=temp_password,
            )
        except Exception as exc:
            logger.error("Account creation email error for %s: %s", user_data.email, exc)

        msg = "User created successfully. Credentials sent via email." if email_sent \
              else "User created successfully. Email could not be sent — provide credentials manually."
        return AdminUserCreateResponse(
            message=msg,
            user_id=account_id,
            email=user_data.email,
            first_name=user_data.first_name,
            last_name=user_data.last_name,
            role_id=user_data.role_id,
        )

    except HTTPException:
        conn.rollback()
        raise
    except mysql.connector.Error as err:
        conn.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Database error: {str(err)}"
        )
    finally:
        cursor.close()
        conn.close()


# =============================================================================
# Password Reset Endpoints
# =============================================================================

class PasswordResetRequest(BaseModel):
    """Request body for password reset."""
    new_password: str = Field(..., min_length=8, description="New password (minimum 8 characters)")

    @field_validator('new_password')
    @classmethod
    def validate_password(cls, v: str) -> str:
        if len(v) < 8:
            raise ValueError('Password must be at least 8 characters long')
        return v


class PasswordResetResponse(BaseModel):
    """Response for successful password reset."""
    message: str
    user_id: int


@router.post("/users/{user_id}/reset-password")
async def reset_user_password(
    user_id: int,
    request: PasswordResetRequest,
) -> PasswordResetResponse:
    """
    Reset a user's password.

    Admin-only endpoint to reset any user's password.
    The password is hashed before storage.

    Args:
        user_id: The AccountID of the user whose password to reset
        request: Contains the new password (minimum 8 characters)

    Returns:
        Success message with user_id

    Raises:
        404: User not found
        400: Invalid password (validation error)
        500: Database error
    """
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Check if user exists and get their AuthID
        cursor.execute(
            "SELECT AuthID FROM AccountData WHERE AccountID = %s",
            (user_id,)
        )
        result = cursor.fetchone()

        if result is None:
            raise HTTPException(
                status_code=404,
                detail=f"User with ID {user_id} not found"
            )

        auth_id = result[0]

        # Hash the new password
        hashed_password = hash_password(request.new_password)

        # Update the password in Auth table
        cursor.execute(
            "UPDATE Auth SET PasswordHash = %s WHERE AuthID = %s",
            (hashed_password, auth_id)
        )

        conn.commit()

        return PasswordResetResponse(
            message="Password reset successfully",
            user_id=user_id
        )

    except HTTPException:
        raise
    except mysql.connector.Error as err:
        raise HTTPException(
            status_code=500,
            detail=f"Database error: {str(err)}"
        )
    finally:
        cursor.close()
        conn.close()


class SendResetEmailRequest(BaseModel):
    """Request body for sending password reset email."""
    temporary_password: str = Field(..., min_length=1, description="The temporary password to include in email")
    email_override: Optional[str] = Field(None, description="Optional alternate email address")

    @field_validator('email_override', mode='before')
    @classmethod
    def sanitize(cls, v):
        return sanitized_string(v)


class SendResetEmailResponse(BaseModel):
    """Response for password reset email."""
    message: str
    sent_to: str
    user_id: int


@router.post("/users/{user_id}/send-reset-email")
async def send_password_reset_email(
    user_id: int,
    request: SendResetEmailRequest,
) -> SendResetEmailResponse:
    """
    Send password reset email to a user.

    Admin-only endpoint to send a password reset notification email.
    Can optionally send to an alternate email address.

    Args:
        user_id: The AccountID of the user
        request: Contains temporary_password and optional email_override

    Returns:
        Success message with recipient email

    Raises:
        404: User not found
        500: Email send failed or database error
    """
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Get user info
        cursor.execute(
            "SELECT FirstName, Email FROM AccountData WHERE AccountID = %s",
            (user_id,)
        )
        result = cursor.fetchone()

        if result is None:
            raise HTTPException(
                status_code=404,
                detail=f"User with ID {user_id} not found"
            )

        first_name, user_email = result[0], result[1]

        # Use override email if provided, otherwise use user's email
        recipient_email = request.email_override or user_email

        # Send password reset email
        success = _email_service.send_admin_password_reset_email(
            user_name=first_name,
            user_email=recipient_email,
            temporary_password=request.temporary_password,
        )

        if not success:
            raise HTTPException(
                status_code=500,
                detail="Failed to send email"
            )

        return SendResetEmailResponse(
            message="Password reset email sent successfully",
            sent_to=recipient_email,
            user_id=user_id
        )

    except HTTPException:
        raise
    except mysql.connector.Error as err:
        raise HTTPException(
            status_code=500,
            detail=f"Database error: {str(err)}"
        )
    finally:
        cursor.close()
        conn.close()


# =============================================================================
# Impersonation Endpoints (System Administrator Only - RoleID = 4)
# =============================================================================

# System Administrator role ID
SYSTEM_ADMIN_ROLE_ID = 4


class ImpersonateRequest(BaseModel):
    """Request body for impersonation (empty, user_id comes from path)."""
    pass


class UserInfo(BaseModel):
    """User information included in impersonation response."""
    account_id: int
    first_name: Optional[str]
    last_name: Optional[str]
    email: str
    role: str


# =============================================================================
# View-As Endpoints (New Approach - No Token Switching)
# =============================================================================

class ViewAsUserInfo(BaseModel):
    """User information for view-as response."""
    user_id: int
    first_name: Optional[str]
    last_name: Optional[str]
    email: str
    role: str
    role_id: int


class ViewAsResponse(BaseModel):
    """Response for successful view-as start."""
    message: str
    is_viewing_as: bool
    viewed_user: ViewAsUserInfo


class EndViewAsResponse(BaseModel):
    """Response for ending view-as mode."""
    message: str


@router.post("/users/{user_id}/view-as")
async def start_viewing_as(
    user_id: int,
    request: Request,
) -> ViewAsResponse:
    """
    Start viewing as another user (System Admin only).

    Updates the admin's existing session with ViewingAsUserID - no new token.
    This approach eliminates token switching complexity on the frontend.

    Args:
        user_id: The AccountID of the user to view as

    Returns:
        ViewAsResponse with target user info

    Raises:
        401: Not authenticated
        403: Not a system administrator
        400: Cannot view-as yourself or inactive user
        404: Target user not found
        500: Database error
    """
    token = get_token(request)

    if not token:
        raise HTTPException(
            status_code=401,
            detail="Authentication required"
        )

    token_hash = hash_token(token)
    now = datetime.utcnow()

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        # Get admin session
        cursor.execute(
            """
            SELECT s.SessionID, s.AccountID, s.ExpiresAt, s.ViewingAsUserID,
                   a.RoleID, r.RoleName
            FROM Sessions s
            JOIN AccountData a ON s.AccountID = a.AccountID
            JOIN Roles r ON a.RoleID = r.RoleID
            WHERE s.TokenHash = %s
            """,
            (token_hash,)
        )

        session = cursor.fetchone()

        if not session:
            raise HTTPException(
                status_code=401,
                detail="Invalid session token"
            )

        if session["ExpiresAt"] < now:
            raise HTTPException(
                status_code=401,
                detail="Session expired"
            )

        # Check if admin is system administrator (RoleID = 4)
        if session["RoleID"] != SYSTEM_ADMIN_ROLE_ID:
            raise HTTPException(
                status_code=403,
                detail="Only system administrators can view as other users"
            )

        # Don't allow viewing-as yourself
        if session["AccountID"] == user_id:
            raise HTTPException(
                status_code=400,
                detail="Cannot view as yourself"
            )

        # Get target user info
        cursor.execute(
            """
            SELECT a.AccountID, a.FirstName, a.LastName, a.Email, a.IsActive,
                   a.RoleID, r.RoleName
            FROM AccountData a
            JOIN Roles r ON a.RoleID = r.RoleID
            WHERE a.AccountID = %s
            """,
            (user_id,)
        )

        target_user = cursor.fetchone()

        if not target_user:
            raise HTTPException(
                status_code=404,
                detail=f"User with ID {user_id} not found"
            )

        if not target_user["IsActive"]:
            raise HTTPException(
                status_code=400,
                detail="Cannot view as inactive user"
            )

        # Update session with ViewingAsUserID
        cursor.execute(
            """
            UPDATE Sessions SET ViewingAsUserID = %s WHERE SessionID = %s
            """,
            (user_id, session["SessionID"])
        )

        # Audit log: view-as started
        cursor.execute(
            """
            INSERT INTO AuditEvent (ActorAccountID, Action, ResourceType, ResourceID, Status, HttpMethod, Path)
            VALUES (%s, 'view_as_start', 'account', %s, 'success', 'POST', %s)
            """,
            (session["AccountID"], str(user_id), f"/admin/users/{user_id}/view-as"),
        )

        conn.commit()

        return ViewAsResponse(
            message="Now viewing as user",
            is_viewing_as=True,
            viewed_user=ViewAsUserInfo(
                user_id=target_user["AccountID"],
                first_name=target_user["FirstName"],
                last_name=target_user["LastName"],
                email=target_user["Email"],
                role=target_user["RoleName"],
                role_id=target_user["RoleID"],
            ),
        )

    except HTTPException:
        raise
    except mysql.connector.Error as err:
        raise HTTPException(
            status_code=500,
            detail=f"Database error: {str(err)}"
        )
    finally:
        cursor.close()
        conn.close()


# =============================================================================
# Audit Log Endpoints
# =============================================================================

class AuditEventResponse(BaseModel):
    """Single audit event in response."""
    audit_event_id: int
    created_at: str
    request_id: Optional[str] = None
    actor_type: str
    actor_account_id: Optional[int] = None
    actor_email: Optional[str] = None
    actor_name: Optional[str] = None
    ip_address: Optional[str] = None
    user_agent: Optional[str] = None
    http_method: Optional[str] = None
    path: Optional[str] = None
    action: str
    resource_type: str
    resource_id: Optional[str] = None
    status: str
    http_status_code: Optional[int] = None
    error_code: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None


class AuditLogResponse(BaseModel):
    """Response for audit log listing."""
    events: List[AuditEventResponse]
    total: int
    limit: int
    offset: int


@router.get("/audit-logs")
async def get_audit_logs(
    limit: int = Query(50, ge=1, le=500),
    offset: int = Query(0, ge=0),
    action: Optional[str] = Query(None, description="Filter by action"),
    status: Optional[str] = Query(None, description="Filter by status (success, failure, denied)"),
    actor_account_id: Optional[int] = Query(None, description="Filter by actor account ID"),
    resource_type: Optional[str] = Query(None, description="Filter by resource type"),
    http_method: Optional[str] = Query(None, description="Filter by HTTP method"),
    search: Optional[str] = Query(None, description="Search in path or action"),
    start_date: Optional[str] = Query(None, description="Filter from date (ISO format)"),
    end_date: Optional[str] = Query(None, description="Filter to date (ISO format)"),
) -> AuditLogResponse:
    """
    Get audit log events with optional filtering.

    Returns paginated audit events with actor information joined from AccountData.
    """
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        # Build WHERE clause
        conditions = []
        params = []

        if action:
            conditions.append("ae.Action = %s")
            params.append(action)

        if status:
            conditions.append("ae.Status = %s")
            params.append(status)

        if actor_account_id:
            conditions.append("ae.ActorAccountID = %s")
            params.append(actor_account_id)

        if resource_type:
            conditions.append("ae.ResourceType = %s")
            params.append(resource_type)

        if http_method:
            conditions.append("ae.HttpMethod = %s")
            params.append(http_method)

        if search:
            conditions.append("(ae.Path LIKE %s OR ae.Action LIKE %s)")
            search_param = f"%{search}%"
            params.extend([search_param, search_param])

        if start_date:
            conditions.append("ae.CreatedAt >= %s")
            params.append(start_date)

        if end_date:
            conditions.append("ae.CreatedAt <= %s")
            params.append(end_date)

        where_clause = " AND ".join(conditions) if conditions else "1=1"

        # Get total count
        count_query = f"""
            SELECT COUNT(*) as total
            FROM AuditEvent ae
            WHERE {where_clause}
        """
        cursor.execute(count_query, params)
        total = cursor.fetchone()["total"]

        # Get audit events with actor info
        query = f"""
            SELECT
                ae.AuditEventID,
                ae.CreatedAt,
                ae.RequestID,
                ae.ActorType,
                ae.ActorAccountID,
                ae.IpAddress,
                ae.UserAgent,
                ae.HttpMethod,
                ae.Path,
                ae.Action,
                ae.ResourceType,
                ae.ResourceID,
                ae.Status,
                ae.HttpStatusCode,
                ae.ErrorCode,
                ae.MetadataJSON,
                ad.Email as ActorEmail,
                ad.FirstName as ActorFirstName,
                ad.LastName as ActorLastName
            FROM AuditEvent ae
            LEFT JOIN AccountData ad ON ae.ActorAccountID = ad.AccountID
            WHERE {where_clause}
            ORDER BY ae.CreatedAt DESC
            LIMIT %s OFFSET %s
        """
        params.extend([limit, offset])
        cursor.execute(query, params)

        rows = cursor.fetchall()

        events = []
        for row in rows:
            # Convert IP address from binary if present
            ip_address = None
            if row["IpAddress"]:
                try:
                    import socket
                    ip_bytes = row["IpAddress"]
                    if len(ip_bytes) == 4:
                        ip_address = socket.inet_ntop(socket.AF_INET, ip_bytes)
                    elif len(ip_bytes) == 16:
                        ip_address = socket.inet_ntop(socket.AF_INET6, ip_bytes)
                except Exception:
                    ip_address = str(row["IpAddress"])

            # Parse metadata JSON
            import json
            metadata = None
            if row["MetadataJSON"]:
                try:
                    metadata = json.loads(row["MetadataJSON"]) if isinstance(row["MetadataJSON"], str) else row["MetadataJSON"]
                except Exception:
                    metadata = None

            # Build actor name
            actor_name = None
            if row["ActorFirstName"] or row["ActorLastName"]:
                actor_name = f"{row['ActorFirstName'] or ''} {row['ActorLastName'] or ''}".strip()

            events.append(AuditEventResponse(
                audit_event_id=row["AuditEventID"],
                created_at=row["CreatedAt"].isoformat() if row["CreatedAt"] else None,
                request_id=row["RequestID"],
                actor_type=row["ActorType"],
                actor_account_id=row["ActorAccountID"],
                actor_email=row["ActorEmail"],
                actor_name=actor_name,
                ip_address=ip_address,
                user_agent=row["UserAgent"],
                http_method=row["HttpMethod"],
                path=row["Path"],
                action=row["Action"],
                resource_type=row["ResourceType"],
                resource_id=row["ResourceID"],
                status=row["Status"],
                http_status_code=row["HttpStatusCode"],
                error_code=row["ErrorCode"],
                metadata=metadata,
            ))

        return AuditLogResponse(
            events=events,
            total=total,
            limit=limit,
            offset=offset,
        )

    except mysql.connector.Error as err:
        raise HTTPException(
            status_code=500,
            detail=f"Database error: {str(err)}"
        )
    finally:
        cursor.close()
        conn.close()


@router.get("/audit-logs/actions")
async def get_audit_log_actions() -> List[str]:
    """Get distinct action types from audit logs for filter dropdowns."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("SELECT DISTINCT Action FROM AuditEvent ORDER BY Action")
        return [row[0] for row in cursor.fetchall()]
    except mysql.connector.Error as err:
        raise HTTPException(
            status_code=500,
            detail=f"Database error: {str(err)}"
        )
    finally:
        cursor.close()
        conn.close()


@router.get("/audit-logs/resource-types")
async def get_audit_log_resource_types() -> List[str]:
    """Get distinct resource types from audit logs for filter dropdowns."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("SELECT DISTINCT ResourceType FROM AuditEvent ORDER BY ResourceType")
        return [row[0] for row in cursor.fetchall()]
    except mysql.connector.Error as err:
        raise HTTPException(
            status_code=500,
            detail=f"Database error: {str(err)}"
        )
    finally:
        cursor.close()
        conn.close()


@router.post("/view-as/end")
async def end_viewing_as(
    request: Request,
) -> EndViewAsResponse:
    """
    End view-as mode, return to normal admin view.

    Clears ViewingAsUserID from the admin's session.
    No token switching required - same session continues.

    Returns:
        EndViewAsResponse with success message

    Raises:
        400: Not currently viewing as another user
        401: Not authenticated
        500: Database error
    """
    token = get_token(request)

    if not token:
        raise HTTPException(
            status_code=401,
            detail="Authentication required"
        )

    token_hash = hash_token(token)
    now = datetime.utcnow()

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        # Get current session
        cursor.execute(
            """
            SELECT SessionID, AccountID, ViewingAsUserID, ExpiresAt
            FROM Sessions
            WHERE TokenHash = %s
            """,
            (token_hash,)
        )

        session = cursor.fetchone()

        if not session:
            raise HTTPException(
                status_code=401,
                detail="Invalid session"
            )

        if session["ExpiresAt"] < now:
            raise HTTPException(
                status_code=401,
                detail="Session expired"
            )

        if session["ViewingAsUserID"] is None:
            raise HTTPException(
                status_code=400,
                detail="Not currently viewing as another user"
            )

        viewed_user_id = session["ViewingAsUserID"]

        # Clear ViewingAsUserID
        cursor.execute(
            """
            UPDATE Sessions SET ViewingAsUserID = NULL WHERE SessionID = %s
            """,
            (session["SessionID"],)
        )

        # Audit log: view-as ended
        cursor.execute(
            """
            INSERT INTO AuditEvent (ActorAccountID, Action, ResourceType, ResourceID, Status, HttpMethod, Path)
            VALUES (%s, 'view_as_end', 'account', %s, 'success', 'POST', '/admin/view-as/end')
            """,
            (session["AccountID"], str(viewed_user_id)),
        )

        conn.commit()

        return EndViewAsResponse(
            message="Returned to admin view",
        )

    except HTTPException:
        raise
    except mysql.connector.Error as err:
        raise HTTPException(
            status_code=500,
            detail=f"Database error: {str(err)}"
        )
    finally:
        cursor.close()
        conn.close()


@router.delete("/users/{user_id}/purge", status_code=status.HTTP_200_OK)
async def purge_user_data(
    user_id: int,
    request: Request,
    scrub_audit_metadata: bool = True,
) -> PurgeUserResponse:
    """
    Permanently delete a participant (or any user) and all user-linked data.

    Requires System Admin (RoleID=4).

    Deletes:
      - Sessions (owned by user, and sessions referencing them in impersonation/view-as fields)
      - Responses (participant answers)
      - SurveyAssignment rows
      - Account2FA row (redundant but explicit)
      - AccountData row
      - Auth row (password hash)

    Optionally scrubs AuditEvent metadata like IP/UserAgent where ActorAccountID matches.
    """
    token = get_token(request)
    if not token:
        raise HTTPException(status_code=401, detail="Authentication required")

    token_hash = hash_token(token)
    now = datetime.utcnow()

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        # Validate caller session + role
        cursor.execute(
            """
            SELECT s.SessionID, s.AccountID, s.ExpiresAt, a.RoleID
            FROM Sessions s
            JOIN AccountData a ON s.AccountID = a.AccountID
            WHERE s.TokenHash = %s
            """,
            (token_hash,)
        )
        session = cursor.fetchone()
        if not session:
            raise HTTPException(status_code=401, detail="Invalid session token")
        if session["ExpiresAt"] < now:
            raise HTTPException(status_code=401, detail="Session expired")
        if session["RoleID"] != SYSTEM_ADMIN_ROLE_ID:
            raise HTTPException(status_code=403, detail="Only system administrators can purge users")

        # Fetch target user + auth id
        cursor.execute(
            "SELECT AccountID, AuthID FROM AccountData WHERE AccountID = %s",
            (user_id,)
        )
        target = cursor.fetchone()
        if not target:
            raise HTTPException(status_code=404, detail=f"User with ID {user_id} not found")

        auth_id = target["AuthID"]

        deleted_counts: Dict[str, int] = {}

        # Start transaction
        #conn.start_transaction()

        # 1) Sessions: user’s sessions + sessions referencing them in impersonation/view-as
        cursor.execute(
            """
            DELETE FROM Sessions
            WHERE AccountID = %s OR ImpersonatedBy = %s OR ViewingAsUserID = %s
            """,
            (user_id, user_id, user_id)
        )
        deleted_counts["Sessions"] = cursor.rowcount

        # 2) Responses (participant answers)
        cursor.execute("DELETE FROM Responses WHERE ParticipantID = %s", (user_id,))
        deleted_counts["Responses"] = cursor.rowcount

        # 3) Survey assignments
        cursor.execute("DELETE FROM SurveyAssignment WHERE AccountID = %s", (user_id,))
        deleted_counts["SurveyAssignment"] = cursor.rowcount

        # 4) 2FA (also cascades, but explicit)
        cursor.execute("DELETE FROM Account2FA WHERE AccountID = %s", (user_id,))
        deleted_counts["Account2FA"] = cursor.rowcount

        # Optional: scrub audit metadata (keep event rows but remove IP/UserAgent)
        if scrub_audit_metadata:
            cursor.execute(
                """
                UPDATE AuditEvent
                SET IpAddress = NULL, UserAgent = NULL, MetadataJSON = NULL
                WHERE ActorAccountID = %s
                """,
                (user_id,)
            )
            deleted_counts["AuditEventScrubbed"] = cursor.rowcount

        # 5) AccountData (must be after Responses/Assignments due to FK constraints)
        cursor.execute("DELETE FROM AccountData WHERE AccountID = %s", (user_id,))
        deleted_counts["AccountData"] = cursor.rowcount

        # 6) Auth (remove password hash)
        if auth_id is not None:
            cursor.execute("DELETE FROM Auth WHERE AuthID = %s", (auth_id,))
            deleted_counts["Auth"] = cursor.rowcount
        else:
            deleted_counts["Auth"] = 0

        conn.commit()

        return PurgeUserResponse(
            message="User and associated data permanently deleted",
            purged_user_id=user_id,
            deleted=deleted_counts,
        )

    except HTTPException:
        conn.rollback()
        raise
    except mysql.connector.Error as err:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(err)}")
    finally:
        cursor.close()
        conn.close()


# =============================================================================
# Account Request Management Endpoints
# =============================================================================

class AccountRequestResponse(BaseModel):
    """Response model for an account request."""
    request_id: int
    first_name: str
    last_name: str
    email: str
    role_id: int
    role_name: Optional[str] = None
    birthdate: Optional[str] = None
    gender: Optional[str] = None
    gender_other: Optional[str] = None
    status: str
    admin_notes: Optional[str] = None
    reviewed_by: Optional[int] = None
    created_at: str
    reviewed_at: Optional[str] = None


class AccountRequestCountResponse(BaseModel):
    """Response for pending account request count."""
    count: int


class AccountRequestRejectBody(BaseModel):
    """Request body for rejecting an account request."""
    admin_notes: Optional[str] = Field(None, max_length=1000)

    @field_validator('admin_notes', mode='before')
    @classmethod
    def sanitize(cls, v):
        return sanitized_string(v)


@router.get("/account-requests")
async def list_account_requests(
    request_status: Optional[str] = Query("pending", alias="status", description="Filter by status: pending, approved, rejected"),
) -> List[AccountRequestResponse]:
    """
    List account requests, filtered by status.
    Default: pending requests only.
    """
    valid_statuses = {"pending", "approved", "rejected"}
    if request_status and request_status not in valid_statuses:
        raise HTTPException(status_code=400, detail=f"Invalid status. Must be one of: {', '.join(valid_statuses)}")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        query = """
            SELECT ar.RequestID, ar.FirstName, ar.LastName, ar.Email,
                   ar.RoleID, r.RoleName, ar.Birthdate, ar.Gender,
                   ar.GenderOther, ar.Status, ar.AdminNotes,
                   ar.ReviewedBy, ar.CreatedAt, ar.ReviewedAt
            FROM AccountRequest ar
            JOIN Roles r ON ar.RoleID = r.RoleID
        """
        params = []

        if request_status:
            query += " WHERE ar.Status = %s"
            params.append(request_status)

        query += " ORDER BY ar.CreatedAt DESC"

        cursor.execute(query, params)
        rows = cursor.fetchall()

        return [
            AccountRequestResponse(
                request_id=row["RequestID"],
                first_name=row["FirstName"],
                last_name=row["LastName"],
                email=row["Email"],
                role_id=row["RoleID"],
                role_name=row["RoleName"],
                birthdate=row["Birthdate"].isoformat() if row["Birthdate"] else None,
                gender=row["Gender"],
                gender_other=row["GenderOther"],
                status=row["Status"],
                admin_notes=row["AdminNotes"],
                reviewed_by=row["ReviewedBy"],
                created_at=row["CreatedAt"].isoformat() if row["CreatedAt"] else None,
                reviewed_at=row["ReviewedAt"].isoformat() if row["ReviewedAt"] else None,
            )
            for row in rows
        ]

    except HTTPException:
        raise  # pragma: no cover — account request DB error unreachable with mock DB
    except mysql.connector.Error as err:
        raise HTTPException(status_code=500, detail=f"Database error: {str(err)}")
    finally:
        cursor.close()
        conn.close()


@router.get("/account-requests/count")
async def get_account_request_count() -> AccountRequestCountResponse:
    """Get count of pending account requests (for badge display)."""
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("SELECT COUNT(*) FROM AccountRequest WHERE Status = 'pending'")
        count = cursor.fetchone()[0]
        return AccountRequestCountResponse(count=count)

    except mysql.connector.Error as err:
        raise HTTPException(status_code=500, detail=f"Database error: {str(err)}")
    finally:
        cursor.close()
        conn.close()


@router.post("/account-requests/{request_id}/approve")
async def approve_account_request(request_id: int) -> dict:
    """
    Approve an account request.
    Creates Auth + AccountData records, sends temp password email.
    """
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        # Get the request
        cursor.execute(
            """
            SELECT RequestID, FirstName, LastName, Email, RoleID, Birthdate, Gender, Status
            FROM AccountRequest
            WHERE RequestID = %s
            """,
            (request_id,),
        )
        req = cursor.fetchone()

        if not req:
            raise HTTPException(status_code=404, detail="Account request not found")

        if req["Status"] != "pending":
            raise HTTPException(status_code=400, detail=f"Request is already {req['Status']}")

        # Check email not already in use
        cursor.execute(
            "SELECT 1 FROM AccountData WHERE Email = %s", (req["Email"],)
        )
        if cursor.fetchone():
            raise HTTPException(status_code=409, detail="An account with this email already exists")

        # Generate temp password and create account
        temp_password = generate_temp_password()
        hashed_password = hash_password(temp_password)

        cursor.execute(
            "INSERT INTO Auth (PasswordHash, MustChangePassword) VALUES (%s, TRUE)",
            (hashed_password,),
        )
        auth_id = cursor.lastrowid

        cursor.execute(
            """
            INSERT INTO AccountData (Email, FirstName, LastName, RoleID, AuthID, IsActive, Birthdate, Gender)
            VALUES (%s, %s, %s, %s, %s, TRUE, %s, %s)
            """,
            (req["Email"], req["FirstName"], req["LastName"], req["RoleID"], auth_id,
             req.get("Birthdate"), req.get("Gender")),
        )
        account_id = cursor.lastrowid

        # Mark request as approved
        cursor.execute(
            """
            UPDATE AccountRequest
            SET Status = 'approved', ReviewedAt = UTC_TIMESTAMP()
            WHERE RequestID = %s
            """,
            (request_id,),
        )

        conn.commit()

        # Send welcome email with temp password and login link
        email_sent = False
        try:
            email_sent = _email_service.send_account_created_email(
                user_name=req["FirstName"],
                user_email=req["Email"],
                temporary_password=temp_password,
            )
        except Exception as exc:
            logger.error("Account approval email error for %s: %s", req["Email"], exc)

        email_note = "" if email_sent else " Email could not be sent — provide credentials manually."
        return {
            "message": f"Account request approved and account created.{email_note}",
            "account_id": account_id,
            "email": req["Email"],
        }

    except HTTPException:
        conn.rollback()
        raise
    except mysql.connector.Error as err:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(err)}")
    finally:
        cursor.close()
        conn.close()


@router.post("/account-requests/{request_id}/reject")
async def reject_account_request(
    request_id: int,
    body: Optional[AccountRequestRejectBody] = None,
) -> dict:
    """Reject an account request with optional admin notes."""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute(
            "SELECT RequestID, FirstName, Email, Status FROM AccountRequest WHERE RequestID = %s",
            (request_id,),
        )
        req = cursor.fetchone()

        if not req:
            raise HTTPException(status_code=404, detail="Account request not found")

        if req["Status"] != "pending":
            raise HTTPException(status_code=400, detail=f"Request is already {req['Status']}")

        admin_notes = body.admin_notes if body else None

        cursor.execute(
            """
            UPDATE AccountRequest
            SET Status = 'rejected',
                AdminNotes = %s,
                ReviewedAt = UTC_TIMESTAMP()
            WHERE RequestID = %s
            """,
            (admin_notes, request_id),
        )

        conn.commit()

        # Send rejection email — failure must not affect the rejection itself
        try:
            _email_service.send_account_rejected_email(
                user_name=req["FirstName"],
                user_email=req["Email"],
                admin_notes=admin_notes,
            )
        except Exception:
            pass

        return {"message": "Account request rejected"}

    except HTTPException:
        conn.rollback()
        raise
    except mysql.connector.Error as err:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(err)}")
    finally:
        cursor.close()
        conn.close()


# =========================================================================
# Consent Record Endpoints
# =========================================================================

class UserConsentRecordResponse(BaseModel):
    """Consent record for admin viewing."""
    consent_record_id: int
    account_id: int
    role_id: int
    consent_version: str
    document_language: str
    document_text: str
    signature_name: Optional[str] = None
    signed_at: str
    ip_address: Optional[str] = None
    user_agent: Optional[str] = None


@router.get("/users/{user_id}/consent")
async def get_user_consent_record(user_id: int):
    """Get the most recent consent record for a user. Admin only."""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(
            """
            SELECT ConsentRecordID, AccountID, RoleID, ConsentVersion,
                   DocumentLanguage, DocumentText, SignatureName,
                   SignedAt, IpAddress, UserAgent
            FROM ConsentRecord
            WHERE AccountID = %s
            ORDER BY SignedAt DESC
            LIMIT 1
            """,
            (user_id,),
        )
        row = cursor.fetchone()
        if not row:
            return None

        # Convert IP from binary
        ip_address = None
        if row["IpAddress"]:
            import socket
            try:
                ip_bytes = row["IpAddress"]
                if len(ip_bytes) == 4:
                    ip_address = socket.inet_ntop(socket.AF_INET, ip_bytes)
                elif len(ip_bytes) == 16:
                    ip_address = socket.inet_ntop(socket.AF_INET6, ip_bytes)
            except Exception:  # pragma: no cover — IP bytes conversion edge case
                ip_address = None  # pragma: no cover

        return UserConsentRecordResponse(
            consent_record_id=row["ConsentRecordID"],
            account_id=row["AccountID"],
            role_id=row["RoleID"],
            consent_version=row["ConsentVersion"],
            document_language=row["DocumentLanguage"],
            document_text=row["DocumentText"],
            signature_name=row.get("SignatureName"),
            signed_at=row["SignedAt"].isoformat() if row["SignedAt"] else "",
            ip_address=ip_address,
            user_agent=row["UserAgent"],
        )
    finally:
        cursor.close()
        conn.close()

# =============================================================================
# Account Deletion Request Endpoints
# =============================================================================

class DeletionRequestResponse(BaseModel):
    """A user-submitted account deletion request."""
    request_id: int
    account_id: int
    first_name: str
    last_name: str
    email: str
    status: str
    admin_notes: Optional[str] = None
    reviewed_by: Optional[int] = None
    requested_at: str
    reviewed_at: Optional[str] = None


class DeletionRequestRejectBody(BaseModel):
    admin_notes: Optional[str] = Field(None, max_length=1000)

    @field_validator('admin_notes', mode='before')
    @classmethod
    def sanitize(cls, v):
        return sanitized_string(v)


@router.get("/deletion-requests", dependencies=[Depends(require_role(4))])
async def list_deletion_requests(
    request_status: Optional[str] = Query("pending", alias="status"),
) -> List[DeletionRequestResponse]:
    """List account deletion requests. Defaults to pending."""
    valid_statuses = {"pending", "approved", "rejected"}
    if request_status and request_status not in valid_statuses:
        raise HTTPException(status_code=400, detail=f"Invalid status. Must be one of: {', '.join(valid_statuses)}")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        query = """
            SELECT dr.RequestID, dr.AccountID, ad.FirstName, ad.LastName, ad.Email,
                   dr.Status, dr.AdminNotes, dr.ReviewedBy, dr.RequestedAt, dr.ReviewedAt
            FROM AccountDeletionRequest dr
            JOIN AccountData ad ON ad.AccountID = dr.AccountID
        """
        params = []
        if request_status:
            query += " WHERE dr.Status = %s"
            params.append(request_status)
        query += " ORDER BY dr.RequestedAt DESC"

        cursor.execute(query, params)
        rows = cursor.fetchall()
        return [
            DeletionRequestResponse(
                request_id=r["RequestID"],
                account_id=r["AccountID"],
                first_name=r["FirstName"],
                last_name=r["LastName"],
                email=r["Email"],
                status=r["Status"],
                admin_notes=r["AdminNotes"],
                reviewed_by=r["ReviewedBy"],
                requested_at=str(r["RequestedAt"]),
                reviewed_at=str(r["ReviewedAt"]) if r["ReviewedAt"] else None,
            )
            for r in rows
        ]
    finally:
        cursor.close()
        conn.close()


@router.get("/deletion-requests/count", dependencies=[Depends(require_role(4))])
async def get_deletion_request_count() -> dict:
    """Return count of pending deletion requests (for admin badge)."""
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(
            "SELECT COUNT(*) FROM AccountDeletionRequest WHERE Status = 'pending'"
        )
        count = cursor.fetchone()[0]
        return {"count": count}
    finally:
        cursor.close()
        conn.close()


@router.post("/deletion-requests/{request_id}/approve", dependencies=[Depends(require_role(4))])
async def approve_deletion_request(
    request_id: int,
    user=Depends(require_role(4)),
) -> dict:
    """Approve a deletion request — permanently deletes the account.

    Reuses the same FK cleanup order as the manual delete_user endpoint.
    Survey response data is anonymised (ParticipantID = NULL) rather than deleted.
    """
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        # Fetch the request + account (name/email needed for the notification email)
        cursor.execute(
            """
            SELECT dr.RequestID, dr.AccountID, dr.Status, a.AuthID,
                   ad.FirstName, ad.LastName, ad.Email
            FROM AccountDeletionRequest dr
            JOIN AccountData ad ON ad.AccountID = dr.AccountID
            JOIN Auth a ON a.AuthID = ad.AuthID
            WHERE dr.RequestID = %s
            """,
            (request_id,),
        )
        row = cursor.fetchone()
        if not row:
            raise HTTPException(status_code=404, detail="Deletion request not found")
        if row["Status"] != "pending":
            raise HTTPException(status_code=409, detail=f"Request is already {row['Status']}")

        account_id = row["AccountID"]
        auth_id = row["AuthID"]
        user_name = row["FirstName"]
        user_email = row["Email"]

        # FK cleanup — sessions first
        cursor.execute(
            "DELETE FROM Sessions WHERE AccountID = %s OR ImpersonatedBy = %s OR ViewingAsUserID = %s",
            (account_id, account_id, account_id),
        )
        cursor.execute("DELETE FROM SurveyAssignment WHERE AccountID = %s", (account_id,))
        # Anonymise responses instead of deleting
        cursor.execute(
            "UPDATE Responses SET ParticipantID = NULL WHERE ParticipantID = %s",
            (account_id,),
        )
        cursor.execute("DELETE FROM ConsentRecord WHERE AccountID = %s", (account_id,))
        cursor.execute("DELETE FROM Messages WHERE SenderID = %s", (account_id,))
        cursor.execute("UPDATE Survey SET CreatorID = NULL WHERE CreatorID = %s", (account_id,))
        cursor.execute("UPDATE SurveyTemplate SET CreatorID = NULL WHERE CreatorID = %s", (account_id,))
        cursor.execute("UPDATE AccountRequest SET ReviewedBy = NULL WHERE ReviewedBy = %s", (account_id,))
        cursor.execute("DELETE FROM Account2FA WHERE AccountID = %s", (account_id,))
        # Remove all deletion request rows for this account before deleting the
        # account itself — a prior rejected request would leave a FK-referencing
        # row that blocks the AccountData DELETE.
        cursor.execute(
            "DELETE FROM AccountDeletionRequest WHERE AccountID = %s",
            (account_id,),
        )
        cursor.execute("DELETE FROM AccountData WHERE AccountID = %s", (account_id,))
        cursor.execute("DELETE FROM Auth WHERE AuthID = %s", (auth_id,))

        conn.commit()

        # Send deletion-approved notification (best-effort, non-blocking)
        try:
            _email_service.send_account_deletion_approved_email(
                user_name=user_name,
                user_email=user_email,
            )
        except Exception as exc:
            logger.error("Deletion approval email error for %s: %s", user_email, exc)

        return {"message": "Account permanently deleted", "request_id": request_id, "account_id": account_id}

    except HTTPException:
        conn.rollback()
        raise
    except mysql.connector.Error as err:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(err)}")
    finally:
        cursor.close()
        conn.close()


@router.post("/deletion-requests/{request_id}/reject", dependencies=[Depends(require_role(4))])
async def reject_deletion_request(
    request_id: int,
    body: DeletionRequestRejectBody,
    user=Depends(require_role(4)),
) -> dict:
    """Reject a deletion request — reactivates the account."""
    admin_id = user["account_id"]
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(
            """
            SELECT dr.RequestID, dr.AccountID, dr.Status, ad.FirstName, ad.Email
            FROM AccountDeletionRequest dr
            JOIN AccountData ad ON ad.AccountID = dr.AccountID
            WHERE dr.RequestID = %s
            """,
            (request_id,),
        )
        row = cursor.fetchone()
        if not row:
            raise HTTPException(status_code=404, detail="Deletion request not found")
        if row["Status"] != "pending":
            raise HTTPException(status_code=409, detail=f"Request is already {row['Status']}")

        account_id = row["AccountID"]
        user_name = row["FirstName"]
        user_email = row["Email"]

        # Reactivate the account
        cursor.execute(
            "UPDATE AccountData SET IsActive = TRUE WHERE AccountID = %s",
            (account_id,),
        )
        cursor.execute(
            """
            UPDATE AccountDeletionRequest
            SET Status = 'rejected', ReviewedBy = %s, ReviewedAt = NOW(), AdminNotes = %s
            WHERE RequestID = %s
            """,
            (admin_id, body.admin_notes, request_id),
        )
        conn.commit()

        # Notify the user (best-effort, non-blocking)
        try:
            _email_service.send_account_deletion_rejected_email(
                user_name=user_name,
                user_email=user_email,
                admin_notes=body.admin_notes,
            )
        except Exception as exc:
            logger.error("Deletion rejection email error for %s: %s", user_email, exc)

        return {"message": "Deletion request rejected. Account reactivated.", "request_id": request_id}

    except HTTPException:
        conn.rollback()
        raise
    except mysql.connector.Error as err:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(err)}")
    finally:
        cursor.close()
        conn.close()


# =============================================================================
# Dashboard Stats
# =============================================================================

class DashboardStatsResponse(BaseModel):
    total_users: int
    active_users: int
    users_by_role: Dict[str, int]
    new_users_30d: int
    total_surveys: int
    published_surveys: int
    draft_surveys: int
    closed_surveys: int
    total_responses: int
    pending_account_requests: int
    pending_deletion_requests: int
    recent_account_requests: List[Dict[str, Any]]
    recent_deletion_requests: List[Dict[str, Any]]
    recent_logins: List[Dict[str, Any]]


@router.get("/dashboard/stats", response_model=DashboardStatsResponse)
async def get_dashboard_stats():
    """Get comprehensive dashboard statistics for admin overview."""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("SELECT COUNT(*) AS total FROM AccountData")
        total_users = cursor.fetchone()["total"]

        cursor.execute("SELECT COUNT(*) AS total FROM AccountData WHERE IsActive = TRUE")
        active_users = cursor.fetchone()["total"]

        cursor.execute("""
            SELECT r.RoleName, COUNT(*) AS cnt
            FROM AccountData a JOIN Roles r ON a.RoleID = r.RoleID
            WHERE a.IsActive = TRUE
            GROUP BY r.RoleName
        """)
        users_by_role = {row["RoleName"]: row["cnt"] for row in cursor.fetchall()}

        cursor.execute("""
            SELECT COUNT(*) AS total FROM AccountData
            WHERE CreatedAt >= DATE_SUB(NOW(), INTERVAL 30 DAY)
        """)
        new_users_30d = cursor.fetchone()["total"]

        cursor.execute("SELECT COUNT(*) AS total FROM Survey")
        total_surveys = cursor.fetchone()["total"]

        cursor.execute("SELECT COUNT(*) AS total FROM Survey WHERE PublicationStatus = 'published'")
        published_surveys = cursor.fetchone()["total"]

        cursor.execute("SELECT COUNT(*) AS total FROM Survey WHERE PublicationStatus = 'draft'")
        draft_surveys = cursor.fetchone()["total"]

        cursor.execute("SELECT COUNT(*) AS total FROM Survey WHERE PublicationStatus = 'closed'")
        closed_surveys = cursor.fetchone()["total"]

        cursor.execute("SELECT COUNT(*) AS total FROM Responses")
        total_responses = cursor.fetchone()["total"]

        cursor.execute("SELECT COUNT(*) AS total FROM AccountRequest WHERE Status = 'pending'")
        pending_account_requests = cursor.fetchone()["total"]

        cursor.execute("SELECT COUNT(*) AS total FROM AccountDeletionRequest WHERE Status = 'pending'")
        pending_deletion_requests = cursor.fetchone()["total"]

        cursor.execute("""
            SELECT RequestID, FirstName, LastName, Email, RoleID, CreatedAt
            FROM AccountRequest WHERE Status = 'pending'
            ORDER BY CreatedAt DESC LIMIT 5
        """)
        recent_account_requests = [
            {
                "request_id": r["RequestID"],
                "name": f"{r['FirstName']} {r['LastName']}",
                "email": r["Email"],
                "role_id": r["RoleID"],
                "created_at": r["CreatedAt"].isoformat() if r["CreatedAt"] else None,
            }
            for r in cursor.fetchall()
        ]

        cursor.execute("""
            SELECT d.RequestID, d.AccountID, a.FirstName, a.LastName, a.Email, d.RequestedAt
            FROM AccountDeletionRequest d
            JOIN AccountData a ON d.AccountID = a.AccountID
            WHERE d.Status = 'pending'
            ORDER BY d.RequestedAt DESC LIMIT 5
        """)
        recent_deletion_requests = [
            {
                "request_id": r["RequestID"],
                "name": f"{r['FirstName']} {r['LastName']}",
                "email": r["Email"],
                "requested_at": r["RequestedAt"].isoformat() if r["RequestedAt"] else None,
            }
            for r in cursor.fetchall()
        ]

        cursor.execute("""
            SELECT a.FirstName, a.LastName, a.Email, r.RoleName, s.CreatedAt
            FROM Sessions s
            JOIN AccountData a ON s.AccountID = a.AccountID
            JOIN Roles r ON a.RoleID = r.RoleID
            WHERE s.IsActive = TRUE
            ORDER BY s.CreatedAt DESC LIMIT 10
        """)
        recent_logins = [
            {
                "name": f"{r['FirstName']} {r['LastName']}",
                "email": r["Email"],
                "role": r["RoleName"],
                "logged_in_at": r["CreatedAt"].isoformat() if r["CreatedAt"] else None,
            }
            for r in cursor.fetchall()
        ]

        return DashboardStatsResponse(
            total_users=total_users,
            active_users=active_users,
            users_by_role=users_by_role,
            new_users_30d=new_users_30d,
            total_surveys=total_surveys,
            published_surveys=published_surveys,
            draft_surveys=draft_surveys,
            closed_surveys=closed_surveys,
            total_responses=total_responses,
            pending_account_requests=pending_account_requests,
            pending_deletion_requests=pending_deletion_requests,
            recent_account_requests=recent_account_requests,
            recent_deletion_requests=recent_deletion_requests,
            recent_logins=recent_logins,
        )

    except mysql.connector.Error as err:  # pragma: no cover
        raise HTTPException(status_code=500, detail=f"Database error: {str(err)}")
    finally:
        cursor.close()
        conn.close()


# =============================================================================
# Database Backup Endpoints
# =============================================================================

import os
import gzip
import subprocess
from pathlib import Path
from urllib.parse import urlparse
from fastapi.responses import FileResponse

_BACKUPS_ROOT = Path(os.getenv("BACKUPS_DIR", "/backups"))
_BACKUP_TYPES = ("daily", "weekly", "monthly", "manual")
_MANUAL_KEEP = 10


def _mysql_creds() -> dict:
    """Parse DATABASE_URL or fall back to individual MYSQL_* env vars."""
    db_url = os.getenv("DATABASE_URL", "")
    if db_url:
        p = urlparse(db_url)
        return {
            "host": p.hostname or "mysql",
            "port": str(p.port or 3306),
            "user": p.username or "",
            "password": p.password or "",
            "database": (p.path or "").lstrip("/") or "healthdatabase",
        }
    return {
        "host": os.getenv("MYSQL_HOST", "mysql"),
        "port": "3306",
        "user": os.getenv("MYSQL_USER", ""),
        "password": os.getenv("MYSQL_PASSWORD", ""),
        "database": os.getenv("MYSQL_DATABASE", "healthdatabase"),
    }


def _human_size(size_bytes: int) -> str:
    for unit in ("B", "KB", "MB", "GB"):
        if size_bytes < 1024.0:
            return f"{size_bytes:.1f} {unit}"
        size_bytes /= 1024.0
    return f"{size_bytes:.1f} TB"


class BackupInfo(BaseModel):
    filename: str        # e.g. "daily/healthdatabase_2026-03-31_020000.sql.gz"
    backup_type: str     # daily | weekly | monthly | manual
    created_at: datetime
    size_bytes: int
    size_human: str


@router.get("/backups", response_model=List[BackupInfo])
async def list_backups():
    """List all available database backup files grouped by type."""
    result: List[BackupInfo] = []
    for btype in _BACKUP_TYPES:
        bdir = _BACKUPS_ROOT / btype
        if not bdir.exists():
            continue
        for f in bdir.glob("*.sql.gz"):
            st = f.stat()
            result.append(BackupInfo(
                filename=f"{btype}/{f.name}",
                backup_type=btype,
                created_at=datetime.fromtimestamp(st.st_mtime, tz=timezone.utc),
                size_bytes=st.st_size,
                size_human=_human_size(st.st_size),
            ))
    result.sort(key=lambda b: b.created_at, reverse=True)
    return result


@router.post("/backups/trigger", status_code=201, response_model=BackupInfo)
async def trigger_backup():
    """Trigger an immediate manual database backup."""
    creds = _mysql_creds()
    manual_dir = _BACKUPS_ROOT / "manual"
    manual_dir.mkdir(parents=True, exist_ok=True)

    ts = datetime.now().strftime("%Y-%m-%d_%H%M%S")
    fname = f"{creds['database']}_{ts}.sql.gz"
    out_path = manual_dir / fname

    try:
        env = {**os.environ, "MYSQL_PWD": creds["password"]}
        proc = subprocess.run(
            [
                "mysqldump",
                f"-h{creds['host']}",
                f"-P{creds['port']}",
                f"-u{creds['user']}",
                "--skip-ssl",            # MariaDB client on Debian (no --ssl-mode)
                "--databases", creds["database"],
                "--single-transaction",
                "--routines",
                "--triggers",
                "--events",
                "--no-tablespaces",
                # NOTE: --set-gtid-purged and --ssl-mode are MySQL-only; omitted for MariaDB client compat
            ],
            capture_output=True,
            env=env,
            check=True,
        )
        with gzip.open(out_path, "wb") as gz:
            gz.write(proc.stdout)
    except subprocess.CalledProcessError as e:
        raise HTTPException(
            status_code=500,
            detail=f"mysqldump failed: {e.stderr.decode(errors='replace')[:500]}",
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Backup error: {str(e)}")

    # Trim manual backups to keep only the most recent _MANUAL_KEEP
    all_manual = sorted(manual_dir.glob("*.sql.gz"), key=lambda p: p.stat().st_mtime)
    for old in all_manual[:-_MANUAL_KEEP]:
        old.unlink(missing_ok=True)

    st = out_path.stat()
    return BackupInfo(
        filename=f"manual/{fname}",
        backup_type="manual",
        created_at=datetime.fromtimestamp(st.st_mtime),
        size_bytes=st.st_size,
        size_human=_human_size(st.st_size),
    )


@router.get("/backups/{backup_type}/{filename}/download")
async def download_backup(backup_type: str, filename: str):
    """Download a backup file. Streams the .sql.gz directly to the browser."""
    if backup_type not in _BACKUP_TYPES:
        raise HTTPException(status_code=400, detail="Invalid backup type.")
    # Block path traversal
    if ".." in filename or "/" in filename or "\\" in filename:
        raise HTTPException(status_code=400, detail="Invalid filename.")
    if not filename.endswith(".sql.gz"):
        raise HTTPException(status_code=400, detail="Only .sql.gz files can be downloaded.")

    file_path = _BACKUPS_ROOT / backup_type / filename
    if not file_path.exists():
        raise HTTPException(status_code=404, detail="Backup file not found.")

    return FileResponse(
        path=str(file_path),
        filename=filename,
        media_type="application/gzip",
        headers={"Content-Disposition": f'attachment; filename="{filename}"'},
    )


@router.delete("/backups/manual/{filename}", status_code=200)
async def delete_backup(filename: str, account=Depends(require_role(4))):
    """
    Delete a manual backup file.

    Only manual backups can be deleted — scheduled backups (daily/weekly/monthly)
    are retained by the cron rotation policy and cannot be removed via the API.
    """
    # Block path traversal
    if ".." in filename or "/" in filename or "\\" in filename:
        raise HTTPException(status_code=400, detail="Invalid filename.")
    if not filename.endswith(".sql.gz"):
        raise HTTPException(status_code=400, detail="Only .sql.gz files can be deleted.")

    file_path = _BACKUPS_ROOT / "manual" / filename
    if not file_path.exists():
        raise HTTPException(status_code=404, detail="Backup file not found.")

    file_path.unlink()
    return {"message": f"Backup {filename} deleted."}


class RestoreResult(BaseModel):
    pre_backup_filename: str
    pre_backup_size_human: str
    restored_file: str
    migrations_run: int
    message: str


@router.post("/backups/{backup_type}/{filename}/restore", status_code=200, response_model=RestoreResult)
async def restore_backup(
    backup_type: str,
    filename: str,
    account=Depends(require_role(4)),
):
    """
    Restore the database from a backup file.

    Steps:
    1. Validate inputs (path traversal, file existence).
    2. Auto-create a pre-restore backup (saved as manual).
    3. Decompress and restore from the selected backup via the mysql CLI.
    4. Run all migration files to apply any schema changes missing from the backup.
    """
    if backup_type not in _BACKUP_TYPES:
        raise HTTPException(status_code=400, detail="Invalid backup type.")
    if ".." in filename or "/" in filename or "\\" in filename:
        raise HTTPException(status_code=400, detail="Invalid filename.")
    if not filename.endswith(".sql.gz"):
        raise HTTPException(status_code=400, detail="Only .sql.gz files can be restored.")

    file_path = _BACKUPS_ROOT / backup_type / filename
    if not file_path.exists():
        raise HTTPException(status_code=404, detail="Backup file not found.")

    creds = _mysql_creds()
    env = {**os.environ, "MYSQL_PWD": creds["password"]}

    # ── Step 1: pre-restore backup ────────────────────────────────────────────
    manual_dir = _BACKUPS_ROOT / "manual"
    manual_dir.mkdir(parents=True, exist_ok=True)
    ts = datetime.now().strftime("%Y-%m-%d_%H%M%S")
    pre_fname = f"{creds['database']}_pre_restore_{ts}.sql.gz"
    pre_path = manual_dir / pre_fname

    try:
        proc = subprocess.run(
            [
                "mysqldump",
                f"-h{creds['host']}",
                f"-P{creds['port']}",
                f"-u{creds['user']}",
                "--skip-ssl",
                "--databases", creds["database"],
                "--single-transaction",
                "--routines",
                "--triggers",
                "--events",
                "--no-tablespaces",
            ],
            capture_output=True,
            env=env,
            check=True,
        )
        with gzip.open(pre_path, "wb") as gz:
            gz.write(proc.stdout)
    except subprocess.CalledProcessError as e:
        raise HTTPException(
            status_code=500,
            detail=f"Pre-restore backup failed: {e.stderr.decode(errors='replace')[:500]}",
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Pre-restore backup error: {str(e)}")

    pre_size = _human_size(pre_path.stat().st_size)

    # ── Step 2: restore ───────────────────────────────────────────────────────
    try:
        with gzip.open(file_path, "rb") as gz_in:
            sql_bytes = gz_in.read()

        subprocess.run(
            [
                "mysql",
                f"-h{creds['host']}",
                f"-P{creds['port']}",
                f"-u{creds['user']}",
                "--skip-ssl",
            ],
            input=sql_bytes,
            capture_output=True,
            env=env,
            check=True,
        )
    except subprocess.CalledProcessError as e:
        raise HTTPException(
            status_code=500,
            detail=f"Restore failed: {e.stderr.decode(errors='replace')[:500]}",
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Restore error: {str(e)}")

    # ── Step 3: run migrations ────────────────────────────────────────────────
    migrations_run = 0
    migrations_dir = Path("/code/app/migrations")
    if migrations_dir.exists():
        for mfile in sorted(migrations_dir.glob("*.sql")):
            try:
                subprocess.run(
                    [
                        "mysql",
                        f"-h{creds['host']}",
                        f"-P{creds['port']}",
                        f"-u{creds['user']}",
                        "--skip-ssl",
                        creds["database"],
                    ],
                    input=mfile.read_bytes(),
                    capture_output=True,
                    env=env,
                    check=True,
                )
                migrations_run += 1
            except subprocess.CalledProcessError:
                pass  # Migration may already be applied — safe to continue

    return RestoreResult(
        pre_backup_filename=f"manual/{pre_fname}",
        pre_backup_size_human=pre_size,
        restored_file=f"{backup_type}/{filename}",
        migrations_run=migrations_run,
        message=(
            f"Database restored from {filename}. "
            f"Pre-restore backup saved as {pre_fname} ({pre_size}). "
            f"{migrations_run} migration(s) applied."
        ),
    )


# =============================================================================
# System Settings endpoints
# =============================================================================

class SystemSettingsResponse(BaseModel):
    k_anonymity_threshold: int
    registration_open: bool
    maintenance_mode: bool
    maintenance_message: str = ""
    maintenance_completion: str = ""
    max_login_attempts: int
    lockout_duration_minutes: int
    consent_required: bool
    # Expose defaults so the frontend can show a "Reset to default" label
    defaults: dict = Field(default_factory=lambda: {
        "k_anonymity_threshold":    int(_SETTING_DEFAULTS["k_anonymity_threshold"]),
        "registration_open":        _SETTING_DEFAULTS["registration_open"].lower() == "true",
        "maintenance_mode":         _SETTING_DEFAULTS["maintenance_mode"].lower() == "true",
        "maintenance_message":      _SETTING_DEFAULTS.get("maintenance_message", ""),
        "maintenance_completion":   _SETTING_DEFAULTS.get("maintenance_completion", ""),
        "max_login_attempts":       int(_SETTING_DEFAULTS["max_login_attempts"]),
        "lockout_duration_minutes": int(_SETTING_DEFAULTS["lockout_duration_minutes"]),
        "consent_required":         _SETTING_DEFAULTS.get("consent_required", "true").lower() == "true",
    })


class SystemSettingsUpdate(BaseModel):
    k_anonymity_threshold:    int  = Field(..., ge=1,  description="Min distinct respondents (≥1)")
    registration_open:        bool
    maintenance_mode:         bool
    maintenance_message:      str  = Field("", max_length=500)
    maintenance_completion:   str  = Field("", max_length=200)
    max_login_attempts:       int  = Field(..., ge=0,  description="0 = unlimited")
    lockout_duration_minutes: int  = Field(..., ge=1,  description="Minutes before lockout clears (≥1)")
    consent_required:         bool


@router.get("/settings")
def get_settings() -> SystemSettingsResponse:
    """Return the current system-wide settings."""
    return SystemSettingsResponse(
        k_anonymity_threshold=get_int_setting("k_anonymity_threshold"),
        registration_open=get_bool_setting("registration_open"),
        maintenance_mode=get_bool_setting("maintenance_mode"),
        maintenance_message=get_setting("maintenance_message"),
        maintenance_completion=get_setting("maintenance_completion"),
        max_login_attempts=get_int_setting("max_login_attempts"),
        lockout_duration_minutes=get_int_setting("lockout_duration_minutes"),
        consent_required=get_bool_setting("consent_required"),
    )


@router.put("/settings")
def update_settings(
    body: SystemSettingsUpdate,
    account=Depends(require_role(4)),
) -> SystemSettingsResponse:
    """Update all system-wide settings atomically."""
    updates = {
        "k_anonymity_threshold":    str(body.k_anonymity_threshold),
        "registration_open":        str(body.registration_open).lower(),
        "maintenance_mode":         str(body.maintenance_mode).lower(),
        "maintenance_message":      body.maintenance_message,
        "maintenance_completion":   body.maintenance_completion,
        "max_login_attempts":       str(body.max_login_attempts),
        "lockout_duration_minutes": str(body.lockout_duration_minutes),
        "consent_required":         str(body.consent_required).lower(),
    }

    conn = get_db_connection()
    cur = conn.cursor()
    try:
        for key, value in updates.items():
            cur.execute(
                """
                INSERT INTO SystemSettings (SettingKey, SettingValue, UpdatedBy)
                VALUES (%s, %s, %s)
                ON DUPLICATE KEY UPDATE
                    SettingValue = VALUES(SettingValue),
                    UpdatedBy    = VALUES(UpdatedBy)
                """,
                (key, value, account["account_id"]),
            )
        conn.commit()
        invalidate_cache()
        return SystemSettingsResponse(
            k_anonymity_threshold=body.k_anonymity_threshold,
            registration_open=body.registration_open,
            maintenance_mode=body.maintenance_mode,
            maintenance_message=body.maintenance_message,
            maintenance_completion=body.maintenance_completion,
            max_login_attempts=body.max_login_attempts,
            lockout_duration_minutes=body.lockout_duration_minutes,
            consent_required=body.consent_required,
        )
    except mysql.connector.Error as err:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {err}")
    finally:
        cur.close()
        conn.close()
