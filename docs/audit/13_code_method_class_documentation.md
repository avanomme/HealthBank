# Code Documentation Audit Report
**Project:** HealthBank  
**Date:** April 3, 2026  
**Scope:** Backend Python (api/v1 & services), Frontend Dart (core & features)

---

## Section 1: Backend — Undocumented Public Functions

### Python API Functions (>10 lines without docstrings)

| File | Function | Lines | Issue |
|------|----------|-------|-------|
| backend/app/api/v1/auth.py | `create_account` | 140-180 | No docstring; creates account with hashed password |
| backend/app/api/v1/auth.py | `delete_account` | 258-283 | No docstring; deletes user account |
| backend/app/api/v1/auth.py | `login` | 286-442 | No docstring; critical auth function (156 lines, includes MFA logic) |
| backend/app/api/v1/auth.py | `verify_password` | 793-810 | No docstring; security-critical function |
| backend/app/api/v1/users.py | `fetch_user_by_id` | 659-690 | No docstring; helper function for user retrieval |
| backend/app/api/v1/participants.py | `list_my_surveys` | 524-597 | No explicit docstring; lists surveys with filtering |
| backend/app/api/v1/participants.py | `list_my_responded_surveys` | 603-735 | No explicit docstring; fetches survey responses (132 lines) |
| backend/app/api/v1/participants.py | `compare_my_responses_to_aggregate` | 739-806 | No explicit docstring; complex comparison logic |
| backend/app/api/v1/question_bank.py | `get_question_options` | 126-140 | No docstring; fetches options for a question |
| backend/app/api/v1/question_bank.py | `create_question_options` | 143-149 | No docstring; inserts question options |
| backend/app/api/v1/question_bank.py | `delete_question_options` | 152-157 | No docstring; removes all options for a question |
| backend/app/api/v1/sessions.py | `create_session_for_account` | 47-130 | **CRITICAL:** No docstring; 83 lines of session creation with token hashing & capping |
| backend/app/api/v1/two_factor.py | `enroll_2fa` | 44-106 | No docstring; creates TOTP secret (62 lines) |
| backend/app/api/v1/two_factor.py | `confirm_2fa` | 109-163 | No docstring; enables 2FA after verification (54 lines) |
| backend/app/api/v1/two_factor.py | `verify_2fa_challenge` | 166-260+ | No docstring; critical auth function validating MFA tokens (>40 lines) |

### Service Functions (Well-documented overall)

**Translation Service** (`backend/app/services/translation.py`)
- ✅ All public functions have docstrings
- translate_text, translate_question, translate_options, get_translated_question, get_translated_options

**Email Service** (`backend/app/services/email/service.py`)
- ✅ All public methods have docstrings
- Class docstring present; all email-sending methods documented

**Aggregation Service** (`backend/app/services/aggregation.py`)
- ✅ All public methods have docstrings
- get_survey_overview, get_question_aggregate, get_survey_aggregates all documented

---

## Section 2: Frontend — Undocumented Public Classes/Methods

### Dart Core & Features (Mostly well-documented)

**Status:** Good overall; most classes and key methods have `///` doc comments.

**Minor gaps identified:**

| File | Class/Method | Issue |
|------|-------------|-------|
| frontend/lib/src/core/api/api_client.dart | `_LoggingInterceptor` | Class lacks `///` doc comment (lines 150+) |
| frontend/lib/src/core/api/api_client.dart | `_ErrorInterceptor` | Class lacks `///` doc comment |
| frontend/lib/src/core/widgets/buttons/app_filled_button.dart | Some callback parameters | Inconsistent documentation of onPressed/onLongPress params |
| frontend/lib/src/core/widgets/forms/app_text_input.dart | `AppTextInput` widget | Missing description of validation error handling |
| frontend/lib/src/features/surveys/widgets/question_types/multi_choice_widget.dart | `MultiChoiceWidget` | No `///` class doc comment describing rendering behavior |
| frontend/lib/src/features/surveys/widgets/question_types/single_choice_widget.dart | `SingleChoiceWidget` | No `///` class doc comment |

**Notable well-documented classes:**
- `ApiClient` (api_client.dart) — comprehensive doc comments
- `AppDataTable<T>` (app_data_table.dart) — excellent factory constructor docs
- `AuthNotifier` (auth_providers.dart) — state machine well-explained
- `AppTableColumn<T>` (app_data_table.dart) — detailed factory constructors

---

## Section 3: TODO/FIXME Catalogue

### Backend (Python)

| File | Line | Content |
|------|------|---------|
| backend/app/main.py | 20 | `# TODO: Remove in production - CORS for local Flutter development` |
| backend/app/api/v1/auth.py | 428 | `# TODO(HTTPS): Remove this block once the server has HTTPS + SameSite=None;Secure` |
| backend/app/api/v1/two_factor.py | 260 | `# TODO(HTTPS): Remove once HTTPS + SameSite=None;Secure is in place.` |
| backend/tests/api/test_templates.py | 29 | `# TODO: Add creator_id when auth is implemented` |
| backend/tests/api/test_surveys.py | 31 | `# TODO: Add creator_id when auth is implemented` |

### Frontend (Dart)

| File | Line | Content |
|------|------|---------|
| frontend/lib/src/core/api/api_client.dart | 127 | `// TODO(HTTPS): Remove once HTTPS + SameSite=None;Secure cookies are` |
| frontend/lib/src/core/api/mobile_auth_interceptor.dart | 39 | `// TODO(HTTPS): Once HTTPS + SameSite=None;Secure is in place, switch` |

**Total TODOs/FIXMEs:** 7 (5 backend, 2 frontend)
- **6 are HTTPS-related** (security config for production)
- **1 is development environment cleanup** (CORS)
- **2 are test setup** (auth implementation)

---

## Section 4: Complex Logic Blocks (>20 lines) Without Explaining Comments

### Backend Python

#### Critical Issues

**1. Session Creation & Capping** (`backend/app/api/v1/sessions.py` lines 67-88)
```sql
UPDATE Sessions SET IsActive = 0 WHERE ... AND TokenHash NOT IN (...)
```
- **Issue:** Complex nested SELECT with MAX_ACTIVE_SESSIONS capping logic
- **Lines:** 21 lines of SQL without inline comments explaining the deactivation strategy
- **Impact:** Session management is security-critical; logic should be self-documenting

**2. Multi-Choice Response Validation** (`backend/app/api/v1/participants.py` lines 297-340)
```python
try: parsed = json.loads(response_value)
    if isinstance(parsed, list): ...
except (json.JSONDecodeError, ...): raw_ids = [...]
```
- **Issue:** Handles two response formats (JSON array and comma-separated); lacks comment explaining fallback logic
- **Lines:** 43 lines of response parsing and validation
- **Impact:** Test/validation code; fallback behavior not immediately obvious

**3. 2FA Verification Challenge** (`backend/app/api/v1/two_factor.py` lines 175-230+)
```python
if revoked_at is not None or used_at is not None or expires_at <= now:
```
- **Issue:** Multiple revocation/expiration conditions without explaining the security model
- **Lines:** 55+ lines without high-level comment block
- **Impact:** Security-critical 2FA token validation; conditions should be documented

**4. Survey Assignment Filtering** (`backend/app/api/v1/assignments.py` lines 113-160)
```python
is_bulk = assignment.assign_all or assignment.gender is not None or ...
if is_bulk: query = "SELECT ... WHERE RoleID = %s AND IsActive = %s"
```
- **Issue:** Demographic filtering logic for bulk assignment; branches into two paths without explaining heuristics
- **Lines:** 47 lines of assignment logic with conditional branching

#### Moderate Issues

**5. User Deletion Cascade** (`backend/app/api/v1/users.py` lines 565-656)
- Multiple UPDATE/DELETE statements with specific nullification strategy
- Comments explain intent but could be more structured

**6. Lockout Logic** (`backend/app/api/v1/auth.py` lines 319-352)
- ✅ HAS explanatory comments; good structure with "Lockout check" section header

### Frontend Dart

**No significant blocks of >20 lines identified** without explaining comments. Widget builder functions are typically concise or grouped logically.

---

## Summary & Recommendations

### Key Findings

| Category | Count | Severity |
|----------|-------|----------|
| **Backend public functions >10 lines without docstring** | 14 | HIGH |
| **Session management function without docs** | 1 | **CRITICAL** |
| **2FA/Auth functions without docs** | 3 | **CRITICAL** |
| **Complex logic blocks (>20 lines) without comments** | 6 | HIGH |
| **TODOs/FIXMEs** | 7 | MEDIUM |
| **Frontend doc gaps** | 5-6 | LOW |

### Immediate Actions (Priority)

1. **CRITICAL:** Add docstrings to:
   - `create_session_for_account()` — explains token generation, hashing, session capping algorithm
   - `verify_2fa_challenge()` — documents challenge validation state machine
   - `login()` — documents MFA branching and password lockout

2. **HIGH:** Add docstrings to all remaining public functions in auth.py, sessions.py, two_factor.py

3. **HIGH:** Add inline comments to complex logic blocks:
   - Session capping SQL query (sessions.py line 70-88)
   - 2FA challenge validation conditions (two_factor.py)
   - Multi-choice response parsing fallback (participants.py)

4. **MEDIUM:** Resolve 6 HTTPS-related TODOs:
   - Plan HTTPS + SameSite=None;Secure implementation
   - Remove dev-only CORS allowlist
   - Update session/auth interceptor logic

### Long-Term (Process)

1. **Enforce docstring requirements** in CI/CD:
   - Require docstrings for all public functions >15 lines
   - Require docstrings for security-critical functions (auth, sessions, 2FA)

2. **Document architecture decisions:**
   - Session capping strategy (MAX_ACTIVE_SESSIONS = 5)
   - K-anonymity threshold (default 5 respondents)
   - Password reset token TTL, MFA challenge TTL

3. **Frontend:** Standardize `///` comments for all public widget classes

4. **Automate:** Use `pydantic-settings` doc generation for API models (already well-documented)

---

**Report Generated:** 2026-04-03 | **Audit Scope:** Code review, no modifications made
