# Auth Middleware — Role-Based Access Control

## Overview

`require_role()` is a FastAPI dependency factory in `backend/app/api/deps.py` that restricts endpoint access to users with specific roles. It also supports admin impersonation via the `ViewingAsUserID` column in the `Sessions` table.

## Usage

```python
from app.api.deps import require_role

# Researcher or admin only
@router.get("/data", dependencies=[Depends(require_role(2, 4))])
async def get_data():
    ...

# Inject user dict with effective role info
@router.get("/data")
async def get_data(user=Depends(require_role(2, 4))):
    print(user["effective_account_id"])  # The acting account
    print(user["effective_role_id"])     # That account's RoleID
    ...

# Participant only
@router.post("/submit", dependencies=[Depends(require_role(1))])
async def submit():
    ...
```

## Role IDs

| RoleID | Name | Description |
|--------|------|-------------|
| 1 | participant | Standard user who takes surveys |
| 2 | researcher | Creates and manages surveys |
| 3 | hcp | Healthcare professional |
| 4 | admin | Full system access |

## Impersonation Support

When an admin (RoleID=4) uses the "View As" feature, their session's `ViewingAsUserID` is set to the target user's `AccountID`. `require_role()` checks:

1. Look up `ViewingAsUserID` from the current session
2. If set, use the **target user's** RoleID for the permission check
3. If not set, use the **authenticated user's** own RoleID

This means an admin viewing-as a researcher can access researcher-only endpoints.

## Return Value

Returns the standard `get_current_user()` dict plus:

```python
{
    "account_id": 1,           # The authenticated admin's ID
    "email": "admin@example.com",
    "tos_accepted_at": "...",
    "tos_version": "1.0",
    "effective_account_id": 5, # The target user (or self if not impersonating)
    "effective_role_id": 2     # The target user's RoleID
}
```

## Error Responses

| Status | Detail | Condition |
|--------|--------|-----------|
| 401 | Not authenticated | Missing or invalid session token |
| 403 | Insufficient role permissions | User's effective role not in allowed list |
| 500 | Role check failed | Database error during role lookup |

## Protected Endpoints

| Router | Guard | Roles |
|--------|-------|-------|
| `admin.py` | `require_role(4)` | Admin only |
| `users.py` | `require_role(4)` | Admin only |
| `surveys.py` | `require_role(2, 4)` | Researcher + Admin |
| `templates.py` | `require_role(2, 4)` | Researcher + Admin |
| `question_bank.py` | `require_role(2, 4)` | Researcher + Admin |
| `assignments.py` survey_router | `require_role(2, 4)` | Researcher + Admin |
| `assignments.py` router | `require_role(1, 2, 4)` | Participant + Researcher + Admin |
| `responses.py` | `require_role(1)` | Participant (per-endpoint) |
| `research.py` | `require_role(2, 4)` | Researcher + Admin |
| `two_factor.py` POST /disable | `get_current_user` | Any authenticated user |
| `auth.py` DELETE /account/{id} | `require_role(4)` | Admin only |

### Sanitized Pydantic Models

| Model | File | Sanitized Fields |
|-------|------|-----------------|
| `SurveyCreate` / `SurveyUpdate` | surveys.py | title, description |
| `TemplateCreate` / `TemplateUpdate` | templates.py | title, description |
| `QuestionCreate` / `QuestionUpdate` | question_bank.py | title, question_content, category |
| `AccountCreate` | auth.py | first_name, last_name |
| `AdminUserCreate` | admin.py | email, first_name, last_name |
| `ResponseItem` | responses.py | response_value |

### Assignments /me Security Fix

The `GET /assignments/me` endpoint previously accepted `account_id` as a query parameter, allowing any user to query any other user's assignments. This has been fixed to use `user["effective_account_id"]` from the auth dependency, ensuring users can only see their own assignments.

## Existing Dependencies

| Dependency | Purpose |
|------------|---------|
| `get_current_user` | Validates session token, returns user dict |
| `require_tos_accepted` | Ensures user accepted latest Terms of Service |
| `require_role(*ids)` | Checks user role, supports impersonation |
| `rate_limit(rule)` | IP or account-based rate limiting |
| `sanitized_string(v)` | Pydantic field validator helper — strips null bytes, control chars, normalizes unicode |
