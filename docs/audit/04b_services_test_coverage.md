# Backend Services Test Coverage Audit

**Date:** April 3, 2026  
**Scope:** Backend services in `backend/app/services/` mapped to test files  
**Status:** 4 service modules identified, 2 with tests

---

## Summary Table

| Service | File | Purpose | Tests | Coverage | Status |
|---------|------|---------|-------|----------|--------|
| Email Service | `services/email/` | Email sending (Gmail, SMTP) | ⚠️ Indirect | Partial | ⚠️ |
| Settings Service | `services/settings.py` | System settings cache | ❌ None | 0% | ❌ |
| Translation Service | `services/translation.py` | Question translation (Google Translate) | ❌ None | 0% | ❌ |
| Aggregation Service | `services/aggregation.py` | Research data analytics | ✅ Yes | 80% | ✅ |
| **TOTAL** | **4 services** | | **1 direct** | **25%** | ⚠️ |

---

## Detailed Coverage Analysis

### Email Service (Indirect Testing) ⚠️

**Location:** `backend/app/services/email/`

**Components:**
- `base.py` - Base email provider interface
- `service.py` - Email service facade
- `gmail.py` - Gmail provider implementation
- `config.py` - Email configuration
- `templates.py` - Email template rendering

**Test Coverage:** ⚠️ Indirect via API tests

The email service is tested indirectly through:
- `test_auth.py` - Password reset email sending tests
- `test_user.py` - Account creation email tests
- `test_admin.py` - Admin email operations

**Test Methods Involving Email (Counted):**
- POST `/auth/password_reset_request` - Tests email notification
- POST `/admin/users` with `send_setup_email=true` - Tests account setup email
- POST `/admin/users/{id}/send-reset-email` - Tests reset email delivery

**Missing Direct Tests:**
- Email template rendering (`services/email/templates.py`)
- Email provider abstraction (`services/email/base.py`)
- Gmail authentication and rate limiting
- SMTP fallback behavior
- Email error handling and retry logic
- Template variable substitution

**Recommendation:** Create `test_email_service.py` with:
- Template rendering tests
- Provider interface tests
- Error handling scenarios

---

### Settings Service ❌ NO TESTS

**Location:** `backend/app/services/settings.py`

**Functionality:**
- Reads system settings from `SystemSettings` table
- Implements 30-second TTL cache for performance
- Provides typed accessors: `get_setting()`, `get_int_setting()`, `get_bool_setting()`
- Supports cache invalidation after admin updates

**Current Implementation:**
```python
def get_setting(key: str) -> str:
    _ensure_fresh()
    return _cache.get(key, DEFAULTS.get(key, ""))

def get_int_setting(key: str) -> int:
    try:
        return int(get_setting(key))
    except (ValueError, TypeError):
        return int(DEFAULTS.get(key, "0"))

def get_bool_setting(key: str) -> bool:
    return get_setting(key).strip().lower() in ("true", "1", "yes")
```

**Settings Currently Used:**
- `registration_open` - Boolean controlling registration
- `maintenance_mode` - Boolean for maintenance mode
- `max_login_attempts` - Integer for login lockout threshold
- `lockout_duration_minutes` - Integer for account lockout duration
- `k_anonymity_threshold` - Integer for research data suppression (default 5)

**Missing Test Coverage:**
- ❌ Cache TTL behavior (30-second refresh)
- ❌ Cache invalidation after admin updates
- ❌ Fallback to defaults when DB unavailable
- ❌ Type conversion edge cases
- ❌ Boolean parsing variations ("true", "1", "yes", "True", "TRUE")
- ❌ Integer parsing with invalid values
- ❌ Database connection errors
- ❌ Settings read during migrations

**Recommendation:** Create `test_settings_service.py` with:
- Cache refresh behavior tests
- Fallback to defaults tests
- Type conversion validation
- Error handling scenarios

---

### Translation Service ❌ NO TESTS

**Location:** `backend/app/services/translation.py`

**Functionality:**
- Auto-translates question content into supported languages
- Uses Google Translate via `deep-translator` library
- Currently supports French ('fr') plus English source
- Best-effort: logs warnings on translation failure

**Supported Languages:**
```python
SUPPORTED_LANGUAGES = ["fr"]
```

**Public API:**
```python
def translate_text(text: str, target_lang: str, source_lang: str = "en") -> Optional[str]
def translate_question(cursor, question_id: int, title: Optional[str], content: str) -> None
def translate_options(cursor, options: list[tuple[int, str]]) -> None
def get_translated_question(cursor, question_id: int, lang: str) -> Optional[dict]
def get_translated_options(cursor, question_id: int, lang: str) -> Optional[dict]
```

**Missing Test Coverage:**
- ❌ Translation API integration (mocked Google Translate)
- ❌ Language fallback behavior
- ❌ Handling missing translations
- ❌ Error handling on API failures
- ❌ Database insertion of translations
- ❌ Duplicate key handling (ON DUPLICATE KEY UPDATE)
- ❌ Question option translation persistence
- ❌ Empty/null text handling
- ❌ Rate limiting on translation API

**Where Used in API:**
- Question creation/update (auto-translates)
- Survey retrieval with `?language=fr` parameter
- Research data queries with language filters

**Recommendation:** Create `test_translation_service.py` with:
- Translation text tests (mock Google Translate)
- Database persistence tests
- Fallback/missing translation tests
- Error scenario tests

---

### Aggregation Service (Partial Testing) ✅

**Location:** `backend/app/services/aggregation.py`

**Test File:** `backend/tests/api/test_aggregation.py`

**Functionality:**
- Computes survey response statistics (mean, median, histograms)
- Enforces k-anonymity (suppresses data if < 5 respondents)
- Anonymizes participant IDs using SHA-256 hash
- Exports individual response rows as CSV
- Supports cross-survey aggregation

**Public API:**
```python
def get_survey_overview(survey_id: int) -> dict
def get_question_aggregate(survey_id: int, question_id: int) -> dict
def get_survey_aggregates(survey_id: int, ...) -> dict
def get_individual_responses(survey_id: int) -> dict
def get_individual_csv_export(survey_id: int) -> bytes
```

**Test Coverage (80%):**

✅ **Covered:**
- `get_survey_overview()` with normal data
- Suppression when respondent count < K (k-anonymity)
- Nonexistent survey handling
- Question aggregates for all 6 response types
  - number (mean, median, std dev)
  - scale (1-10 distribution)
  - yesno (counts)
  - openended (response count only)
  - single_choice (option distribution)
  - multi_choice (parsed from JSON)
- CSV export format
- Category and response_type filtering
- Anonymization consistency (same participant hash across responses)

❌ **Missing:**
- Cross-survey aggregation tests
- Data bank overview functionality
- Complex filtering scenarios
- Large dataset performance
- NULL/empty response handling
- Concurrent access patterns
- Cache invalidation (if any)
- CSV delimiter edge cases

**Test Methods Found:**
- `test_returns_overview_with_correct_stats()` - Overview stats
- `test_returns_suppressed_when_under_threshold()` - K-anonymity
- `test_returns_none_for_nonexistent_survey()` - Nonexistent handling
- `test_question_aggregate_with_numeric_data()` - Number type
- `test_question_aggregate_with_scale()` - Scale type
- `test_question_aggregate_with_choices()` - Choice type
- Multiple other type-specific tests

**Recommendation:** Complete missing tests for cross-survey analysis and edge cases.

---

## Integration Points

### Services Called from API Endpoints

| Service | Called From | Test Coverage |
|---------|------------|----------------|
| **Email Service** | `auth.py`, `users.py`, `admin.py` | ⚠️ Indirect via API tests |
| **Settings Service** | `auth.py`, `admin.py`, `research.py` | ❌ None (cached reads untested) |
| **Translation Service** | `surveys.py`, `research.py` | ❌ None (translation untested) |
| **Aggregation Service** | `research.py` | ✅ Partial via service tests + research API |

### Service Dependencies

```
email/service.py
  └─ Depends: Gmail API, SMTP config, email templates

settings.py
  └─ Depends: SystemSettings table
  └─ Used by: auth (login attempts), admin (various), research (k-anonymity)

translation.py
  └─ Depends: Google Translate API
  └─ Used by: surveys (question storage), research (data retrieval)

aggregation.py
  └─ Depends: Responses, SurveyAssignment, QuestionBank tables
  └─ Used by: research.py endpoints
```

---

## Gap Analysis

### Critical Missing Coverage

| Service | Gap | Impact | Priority |
|---------|-----|--------|----------|
| settings.py | No unit tests | Settings behavior undefined | P0 |
| translation.py | No unit tests | Translation failures untested | P1 |
| email/ | No provider tests | Email delivery untested | P1 |
| aggregation.py | No cross-survey tests | Data bank analysis untested | P2 |

### Error Scenarios Not Tested

1. **Email Service:**
   - Gmail authentication failure
   - SMTP connection timeout
   - Rate limiting exceeded
   - Template rendering errors

2. **Settings Service:**
   - Database unavailable during read
   - Invalid setting values in DB
   - Cache refresh during concurrent updates
   - Settings modified while cached

3. **Translation Service:**
   - Google Translate API unavailable
   - Unsupported language requested
   - Extremely long text truncation
   - Character encoding issues

4. **Aggregation Service:**
   - Concurrent response submissions
   - Large response datasets (memory)
   - Question/option deletion mid-analysis

---

## Recommendations (Priority Order)

### P0 - Critical
1. **Create `test_settings_service.py`**
   - Cache behavior with TTL
   - Fallback to defaults
   - Type conversions
   - Error handling

2. **Create direct email provider tests**
   - Abstract away actual Gmail/SMTP
   - Test error scenarios

### P1 - Important
3. **Create `test_translation_service.py`**
   - Mock Google Translate
   - Database persistence
   - Fallback behavior

4. **Complete aggregation service tests**
   - Cross-survey scenarios
   - Large dataset handling
   - Edge cases

### P2 - Enhancement
5. Add integration tests for service chains
6. Add performance tests for large datasets
7. Add concurrent access tests

---

**Generated:** April 3, 2026
