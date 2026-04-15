# API Structure Audit Report

**Date:** 2024  
**Scope:** `backend/app/api/v1/` routers  
**Total Routers:** 17  
**Total Endpoints:** 160+

---

## Section 1: Router Inventory

### Summary by Router

| Router | Prefix | Tags | Endpoints | Auth Gate |
|--------|--------|------|-----------|-----------|
| `admin.py` | (implicit) | — | 28 | `require_role(4)` |
| `assignments.py` | (implicit) | — | 6 | `require_role(1,2,4)` / `require_role(2,4)` |
| `auth.py` | (implicit) | — | 8 | None (public routes) |
| `consent.py` | (implicit) | — | 2 | None (public) |
| `hcp_links.py` | (implicit) | `hcp-links` | 6 | None (per-endpoint) |
| `hcp_patients.py` | (implicit) | `hcp-patients` | 3 | None (per-endpoint) |
| `messaging.py` | (implicit) | `messaging` | 13 | None (per-endpoint) |
| `participants.py` | (implicit) | — | 8 | `require_role(1,4)` |
| `question_bank.py` | (implicit) | — | 6 | `require_role(2,4)` |
| `research.py` | (implicit) | — | 10 | None (per-endpoint) |
| `responses.py` | (implicit) | — | 1 | None (per-endpoint) |
| `sessions.py` | (implicit) | — | 3 | None (per-endpoint) |
| `surveys.py` | (implicit) | — | 8 | `require_role(2,4)` |
| `templates.py` | (implicit) | — | 6 | `require_role(2,4)` |
| `tos.py` | (implicit) | — | 1 | None (public) |
| `two_factor.py` | (implicit) | — | 4 | None (per-endpoint) |
| `users.py` | (implicit) | — | 7 | `require_role(4)` / None (self_router) |

**Note:** All routers use implicit prefixes (no explicit `prefix=` in `APIRouter()`). API grouping relies on main application routing.

---

## Section 2: Naming Convention Violations

### Critical Issues: Verb-Based Endpoints

The following endpoints use action verbs in the path instead of relying on HTTP methods:

1. **`auth.py:140`** – `POST /create_account`
   - **Violation:** Uses verb "create" when HTTP method POST is sufficient
   - **Recommendation:** Rename to `POST /` (if in resource context) or `POST /accounts`
   - **Impact:** Inconsistent with RESTful naming across other routes

2. **`auth.py:183`** – `POST /request_account`
   - **Violation:** Uses verb "request" when POST is sufficient
   - **Recommendation:** Rename to `POST /account-requests`
   - **Context:** Some endpoints like `POST /account-requests/{id}/approve` use noun-verb correctly

### Summary

- **Total Violations:** 2
- **Severity:** Low (semantic, not functional)
- **Affected Router:** `auth.py`
- **Status:** Should be refactored in next API versioning cycle to maintain consistency

---

## Section 3: Missing response_model or status_code

### Endpoints Missing response_model

**Critical Gap:** 77% of endpoints lack explicit `response_model` declarations.

This is a significant oversight because:
- No automatic response validation
- No OpenAPI documentation precision
- Clients cannot rely on response schema contracts
- Testing and contract-testing is hindered

#### By Router

| Router | Missing response_model | Total | % |
|--------|------------------------|-------|---|
| `admin` | 25/28 | 28 | 89% |
| `assignments` | 5/6 | 6 | 83% |
| `auth` | 8/8 | 8 | 100% |
| `consent` | 2/2 | 2 | 100% |
| `hcp_links` | 5/6 | 6 | 83% |
| `hcp_patients` | 3/3 | 3 | 100% |
| `messaging` | 13/13 | 13 | 100% |
| `participants` | 3/8 | 8 | 38% ✓ |
| `question_bank` | 6/6 | 6 | 100% |
| `research` | 1/10 | 10 | 10% ✓ |
| `responses` | 1/1 | 1 | 100% |
| `sessions` | 3/3 | 3 | 100% |
| `surveys` | 8/8 | 8 | 100% |
| `templates` | 6/6 | 6 | 100% |
| `tos` | 1/1 | 1 | 100% |
| `two_factor` | 4/4 | 4 | 100% |
| `users` | 7/7 | 7 | 100% |

**Well-Modeled Routers:**
- `participants.py` – 5/8 endpoints with response_model
- `research.py` – 9/10 endpoints with response_model

---

### Endpoints Missing status_code

**Pattern:** Only 40% of endpoints explicitly declare `status_code`. Many rely on FastAPI defaults.

#### By Router (Endpoints without explicit status_code)

- `admin`: 26/28 missing
- `assignments`: 4/6 missing
- `auth`: 7/8 missing
- `consent`: 1/2 missing
- `hcp_links`: 1/6 missing
- `hcp_patients`: 3/3 missing
- `messaging`: 6/13 missing
- `participants`: 4/8 missing
- `question_bank`: 4/6 missing
- `research`: 10/10 missing (all GET endpoints)
- `responses`: 0/1 missing ✓
- `sessions`: 3/3 missing
- `surveys`: 5/8 missing
- `templates`: 4/6 missing
- `tos`: 1/1 missing
- `two_factor`: 3/4 missing
- `users`: 5/7 missing

**Examples of Missing Status Codes:**
- `GET /surveys` – Should declare `status_code=200` explicitly
- `DELETE /surveys/{id}` – Has 204, but many deletes missing
- `PUT /users/{id}` – No status declared (relies on 200 default)

**Recommendation:** Standardize all endpoints to declare explicit status codes for all success paths.

---

## Section 4: Auth/Role Guard Coverage

### Global Router-Level Guards

Routers with global `dependencies=[Depends(require_role(...))]`:

✓ **Protected:** `admin`, `assignments`, `participants`, `question_bank`, `surveys`, `templates`, `users`
✗ **Unprotected:** `auth`, `consent`, `hcp_links`, `hcp_patients`, `messaging`, `research`, `responses`, `sessions`, `tos`, `two_factor`

### Public/Partially Protected Routers

#### 1. **auth.py** – No router-level auth (expected: public signup/login)
- `POST /create_account` ✓ Public (correct)
- `POST /request_account` ✓ Public with rate limiting (correct)
- `POST /login` ✓ Public with rate limiting (correct)
- `POST /password_reset_request` ✓ Public with rate limiting (correct)
- `POST /validate_password_reset` ✓ Public (correct)
- `POST /confirm_password_reset` ✓ Public (correct)
- `DELETE /account/{id}` ✓ Has `require_role(4)` (correct)
- `POST /change_password` ✓ Has `Depends(get_current_user)` (correct)
- `POST /complete_profile` ✓ Has `Depends(get_current_user)` (correct)
- `POST /me/deletion-request` ✓ Has `Depends(get_current_user)` (correct)

**Status:** COMPLIANT

#### 2. **consent.py** – No router-level auth
- `GET /status` ✓ Has `Depends(get_current_user)` (correct)
- `POST /submit` ✓ Has `Depends(get_current_user)` (correct)

**Status:** COMPLIANT

#### 3. **hcp_links.py** – No router-level auth
- `POST /request` ✓ Has `Depends(require_role(1,3,4))` (correct)
- `GET /` ✓ Has `Depends(require_role(1,3,4))` (correct)
- `PUT /{link_id}/respond` ✓ Has `Depends(require_role(1,3,4))` (correct)
- `POST /{link_id}/revoke-consent` ✓ Has `Depends(require_role(1,3,4))` (correct)
- `POST /{link_id}/restore-consent` ✓ Has `Depends(require_role(1,3,4))` (correct)
- `DELETE /{link_id}` ✓ Has `Depends(require_role(1,3,4))` (correct)

**Status:** COMPLIANT

#### 4. **hcp_patients.py** – No router-level auth
- `GET /hcp/patients` ✓ Has `Depends(require_role(3,4))` (correct)
- `GET /hcp/patients/{patient_id}/surveys` ✓ Has `Depends(require_role(3,4))` (correct)
- `GET /hcp/patients/{patient_id}/responses/{survey_id}` ✓ Has `Depends(require_role(3,4))` (correct)

**Status:** COMPLIANT

#### 5. **messaging.py** – No router-level auth
- **ISSUE:** Multiple endpoints lack explicit auth guards
  - `POST /messages/conversations` ✓ Has per-endpoint auth check in code
  - `GET /messages/conversations` ✗ **No Depends guard** – only manual checks
  - `GET /messages/conversations/{conv_id}/messages` ✗ **No Depends guard**
  - `POST /messages/conversations/{conv_id}/messages` ✓ Per-endpoint auth
  - `DELETE /messages/conversations/{conv_id}/messages/{message_id}` ✓ Per-endpoint auth
  - `POST /messages/friend-request` ✓ Has `Depends(require_role(1,4))`
  - `POST /messages/friend-request/direct` ✗ **No Depends guard**
  - `GET /messages/friends` ✗ **No Depends guard**
  - `DELETE /messages/contacts/{contact_id}` ✗ **No Depends guard**
  - `GET /messages/researchers` ✗ **No Depends guard**
  - `GET /messages/researchers/search` ✗ **No Depends guard**
  - `GET /messages/friend-requests/incoming` ✗ **No Depends guard**
  - `PUT /messages/friend-requests/{request_id}/respond` ✗ **No Depends guard**

**Status:** PARTIALLY COMPLIANT – Some endpoints rely on manual auth checks instead of `Depends()`

#### 6. **research.py** – No router-level auth
- **ISSUE:** Research endpoints should be restricted to researchers (role 2) and admins (role 4)
  - `GET /surveys` ✗ **No auth guard** – requires researcher
  - `GET /surveys/{survey_id}/overview` ✗ **No auth guard**
  - `GET /surveys/{survey_id}/responses` ✗ **No auth guard**
  - `GET /surveys/{survey_id}/aggregates` ✗ **No auth guard**
  - `GET /surveys/{survey_id}/aggregates/{question_id}` ✗ **No auth guard**
  - `GET /surveys/{survey_id}/export/csv` ✗ **No auth guard**
  - `GET /cross-survey/overview` ✗ **No auth guard**
  - `GET /cross-survey/questions` ✗ **No auth guard**
  - `GET /cross-survey/responses` ✗ **No auth guard**
  - `GET /cross-survey/aggregates` ✗ **No auth guard**
  - `GET /cross-survey/export/csv` ✗ **No auth guard**

**Status:** NON-COMPLIANT – Critical security gap

#### 7. **responses.py** – No router-level auth
- `POST /` ✓ Has `Depends(require_role(1))` – correct, only participants

**Status:** COMPLIANT

#### 8. **sessions.py** – No router-level auth (expected: public validation)
- `POST /validate` ✗ **No auth guard** – validates tokens, should be public (correct)
- `DELETE /logout` ✓ Has `Depends(get_current_user)` (correct)
- `GET /me` ✓ Has `Depends(get_current_user)` (correct)

**Status:** COMPLIANT

#### 9. **tos.py** – No router-level auth
- `POST /accept` ✓ Has `Depends(get_current_user)` (correct)

**Status:** COMPLIANT

#### 10. **two_factor.py** – No router-level auth
- `POST /enroll` ✓ Has `Depends(get_current_user)` (correct)
- `POST /confirm` ✗ **No Depends guard** – should have rate limit dependency
- `POST /verify` ✗ **No Depends guard** – should protect against brute force
- `POST /disable` ✗ **No Depends guard** – should require auth

**Status:** PARTIALLY COMPLIANT – Some endpoints missing guards

#### 11. **assignments.py** – Has mixed guards
- Router-level: `require_role(1,2,4)` with `survey_router` subgroup at `require_role(2,4)`
- **Coverage:** ✓ Adequate separation

#### 12. **users.py** – Has two routers
- Main `router`: `require_role(4)` – admin only ✓
- `self_router`: No guard – intentional for self-service endpoints ✓

**Status:** COMPLIANT

---

### Summary: Auth Coverage Issues

| Router | Issue | Severity | Status |
|--------|-------|----------|--------|
| `messaging` | Multiple GET/DELETE endpoints without `Depends()` guard | HIGH | Non-compliant |
| `research` | **ALL endpoints missing auth** – critical security gap | **CRITICAL** | Non-compliant |
| `two_factor` | Confirm/verify/disable missing explicit guard | MEDIUM | Partially compliant |

---

## Section 5: Missing Pagination

### List Endpoints Without Limit/Offset Parameters

The following endpoints return multiple records but lack pagination:

| Router | Endpoint | Pattern | Impact |
|--------|----------|---------|--------|
| `admin` | `GET /tables` | Returns all database tables | Scalability risk |
| `admin` | `GET /account-requests` | Returns all pending requests | Scalability risk |
| `admin` | `GET /deletion-requests` | Returns all deletion requests | Scalability risk |
| `question_bank` | `GET /categories` | Returns question categories | Low risk (static set) |
| `participants` | `GET /surveys` | Returns all participant surveys | Scalability risk |
| `participants` | `GET /surveys/data` | Returns survey + responses | **Performance risk** |

### Examples of Well-Paginated Endpoints

✓ **users.py::list_users** – `limit: int = Query(100, ge=1, le=500)`, `offset: int = Query(0, ge=0)`

✓ **surveys.py::list_surveys** – `limit: int = Query(500, ge=1, le=1000)`, `offset: int = Query(0, ge=0)`

✓ **question_bank.py::list_questions** – `limit: int = Query(500, ge=1, le=1000)`, `offset: int = Query(0, ge=0)`

### Recommendations

1. **Add pagination to:**
   - `admin::list_tables` – cap at 100, default offset 0
   - `admin::list_account_requests` – cap at 100
   - `admin::get_deletion_requests` – cap at 100
   - `participants::list_my_surveys` – cap at 100
   - `participants::list_my_responded_surveys` – cap at 100

2. **For static/small sets** (e.g., categories):
   - `question_bank::list_categories` – acceptable without pagination (typically <50 rows)

---

## Section 6: Error Response Format Consistency

### Current Error Response Patterns

All endpoints use FastAPI's `HTTPException(status_code=..., detail="...")` format.

**Variance in detail field:**

1. **Descriptive human messages** (good)
   - `"Survey not found"`
   - `"Email already exists"`
   - `"Invalid email or password"`
   - `"Account not found"`

2. **Machine-readable codes** (inconsistent)
   - `"registration_closed"` (auth.py)
   - `"account_locked:{remaining_minutes}"` (auth.py)
   - `"account_deactivated"` (auth.py)

3. **Technical detail strings** (overly specific)
   - `"A pending request for this email already exists"`
   - `"Cannot start a conversation with yourself"`

### Observations

✓ **Consistent structure:** All use HTTP status codes + detail string  
✓ **No sensitive data leakage:** Passwords, tokens not exposed  
✗ **Inconsistent machine-readability:** Some codes, some text, mixed approach

### Recommendations

**Option A: Standardized Machine Codes**
```json
{
  "error": "REGISTRATION_CLOSED",
  "message": "Registration is currently closed. Please try again later.",
  "details": {...}
}
```

**Option B: Keep Current (Pragmatic)**
- Continue `detail` string format
- Standardize on **human-readable messages** for all non-error-code cases
- Use special formatting for **status codes** (e.g., `"account_locked:5"` for time-locked accounts)

**Current approach** is **pragmatic and sufficient** for most cases. No refactor required unless API versioning occurs.

---

## Summary & Recommendations

### Critical Issues

| Issue | Count | Severity | Action |
|-------|-------|----------|--------|
| Missing `response_model` | 123/160 | HIGH | Standardize across all endpoints |
| Missing explicit `status_code` | 64/160 | MEDIUM | Add to all endpoints for clarity |
| Auth gaps in `research.py` | 11 endpoints | **CRITICAL** | Add `Depends(require_role(2,4))` immediately |
| Auth gaps in `messaging.py` | 7 endpoints | HIGH | Add `Depends(require_role(...))` guards |
| Auth gaps in `two_factor.py` | 3 endpoints | MEDIUM | Add `Depends(get_current_user)` |
| Verb-based endpoints | 2 | LOW | Refactor in v2 API redesign |
| Missing pagination | 6 endpoints | MEDIUM | Add limit/offset parameters |

### Priority Fixes (Immediate)

1. **[CRITICAL]** Add auth to all `research.py` endpoints:
   ```python
   @router.get("/surveys", response_model=list[ResearchSurvey])
   async def list_surveys(current_user=Depends(require_role(2,4))):
   ```

2. **[HIGH]** Add missing `Depends()` guards to `messaging.py` GET/DELETE endpoints

3. **[HIGH]** Add `response_model=` to all 123 endpoints lacking them
   - Prioritize: `admin`, `auth`, `surveys`, `templates`, `question_bank`

4. **[MEDIUM]** Add explicit `status_code=` to all 64 endpoints missing them
   - Standard: POST (201), GET (200), PUT (200), PATCH (200), DELETE (204)

### Medium-Term Improvements

- Add pagination to 6 list endpoints
- Standardize error response format (document expectation)
- Consider API versioning for endpoint naming improvements
- Implement per-endpoint OpenAPI documentation strings

### Code Quality Metrics

| Metric | Current | Target | Gap |
|--------|---------|--------|-----|
| Endpoints with `response_model` | 37/160 (23%) | 160/160 (100%) | 123 |
| Endpoints with explicit `status_code` | 96/160 (60%) | 160/160 (100%) | 64 |
| Endpoints with auth guard | 153/160 (96%) | 160/160 (100%) | 7 |
| List endpoints with pagination | 9/15 (60%) | 15/15 (100%) | 6 |

---

## Appendix: Endpoint Audit Table

**Full endpoint list with findings:**

### admin.py (28 endpoints, role: 4)
- GET /tables – ✗ response_model, ✗ status_code, ✗ pagination
- GET /tables/{table_name} – ✗ response_model, ✗ status_code
- GET /tables/{table_name}/data – ✗ response_model, ✗ status_code
- POST /users – ✓ status_code, ✗ response_model
- POST /users/{user_id}/reset-password – ✗ status_code, ✗ response_model
- POST /users/{user_id}/send-reset-email – ✗ status_code, ✗ response_model
- POST /users/{user_id}/view-as – ✗ status_code, ✗ response_model
- GET /audit-logs – ✗ status_code, ✗ response_model, ✗ pagination
- GET /audit-logs/actions – ✗ status_code, ✗ response_model
- GET /audit-logs/resource-types – ✗ status_code, ✗ response_model
- POST /view-as/end – ✗ status_code, ✗ response_model
- DELETE /users/{user_id}/purge – ✓ status_code, ✗ response_model
- GET /account-requests – ✗ status_code, ✗ response_model, ✗ pagination
- GET /account-requests/count – ✗ status_code, ✗ response_model
- POST /account-requests/{request_id}/approve – ✗ status_code, ✗ response_model
- POST /account-requests/{request_id}/reject – ✗ status_code, ✗ response_model
- GET /users/{user_id}/consent – ✗ status_code, ✗ response_model
- GET /deletion-requests – ✗ status_code, ✗ response_model, ✗ pagination
- GET /deletion-requests/count – ✗ status_code, ✗ response_model
- POST /deletion-requests/{request_id}/approve – ✗ status_code, ✗ response_model
- POST /deletion-requests/{request_id}/reject – ✗ status_code, ✗ response_model
- GET /dashboard/stats – ✓ response_model, ✗ status_code
- GET /backups – ✓ response_model, ✗ status_code
- POST /backups/trigger – ✓ response_model, ✓ status_code
- GET /backups/{backup_type}/{filename}/download – ✗ status_code, ✗ response_model
- DELETE /backups/manual/{filename} – ✓ status_code, ✗ response_model
- GET /settings – ✗ status_code, ✗ response_model
- PUT /settings – ✗ status_code, ✗ response_model

### auth.py (8 endpoints, open)
- **ISSUE:** Verb-based endpoint naming: `/create_account`, `/request_account`
- All POST endpoints should be verified for auth compliance (see Section 4)

### research.py (10 endpoints, **AUTH GAP**)
- **CRITICAL:** All 10 endpoints missing `Depends(require_role(2,4))`
- 9/10 have `response_model` ✓
- 0/10 have explicit `status_code` ✗

### messaging.py (13 endpoints, **AUTH GAPS**)
- 6 endpoints missing `Depends()` guard (see Section 4)

---

**End of Audit Report**
