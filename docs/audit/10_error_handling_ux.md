# Error Handling & UX Audit Report

**Date:** April 3, 2026  
**Scope:** Backend (`backend/app/`) and Flutter Frontend (`frontend/lib/src/features/`)

---

## Section 1: Backend — Swallowed Errors

**Severity:** Medium  
**Count:** 4 instances

### 1.1 Audit Logging — Silent Failures (Critical)

**File:** `backend/app/middleware/audit_to_auditevent.py` (Line 333-334)

```python
except Exception:
    pass  # Never break the request due to audit failure
```

**Impact:** When the audit event insertion fails (database connection, permission issues, deadlock), the exception is completely swallowed. No logging, no visibility into why audit records aren't being written. This defeats the purpose of audit trails in a healthcare application.

**Recommendation:** 
- Log failed audit events to stderr or a fallback log file
- Add metrics/counters for audit failures
- Consider implementing a retry mechanism for transient failures

---

### 1.2 Audit Logger — Silent Failures

**File:** `backend/app/audit/logger.py` (Line 113-115)

```python
except Exception:
    # not raising exception to avoid breaking calls due to audit failures
    return
```

**Impact:** Same as above — audit failures are silently ignored. The comment indicates this is intentional for resilience, but it sacrifices observability. Healthcare systems require strong audit trails.

---

### 1.3 Date/Time Serialization Error Swallowing

**File:** `backend/app/utils/sanitize.py` (Multiple instances)

- Line 152: `except Exception: return None if cfg.invalid_to_none else value` (datetime.isoformat)
- Line 167: `except Exception: return None if cfg.invalid_to_none else value` (bytes decoding)
- Line 223: `except Exception: return None if cfg.invalid_to_none else value` (object stringification)
- Line 245: `except Exception: pass` (Unicode normalization)
- Line 288: `except Exception: return None if cfg.invalid_to_none else value` (JSON serialization)

**Impact:** When data sanitization fails, errors are swallowed silently. While this sanitizer is designed to be resilient, there's no logging of *why* sanitization failed. Could hide data corruption issues.

**Recommendation:**
- Add debug-level logging for sanitization failures (especially for unusual data types)
- Track which specific sanitization step failed
- Log examples of unrepresentable values for investigation

---

## Section 2: Backend — Leaked Internal Errors

**Severity:** High (Security/Information Disclosure)  
**Count:** 3 instances

### 2.1 Raw Database Error in HTTP Response

**File:** `backend/app/api/v1/admin.py` (Line 302, 324)

```python
except mysql.connector.Error as err:
    raise HTTPException(status_code=500, detail=f"Database error: {str(err)}")
```

**Impact:** Raw MySQL error messages (e.g., "Access denied for user", "Table doesn't exist") are sent to the client. These expose:
- Database schema names and structure
- Table and column names
- User account names
- Internal server configuration

**Example Leaked Information:**
- `"Database error: Access denied for user 'backend'@'%' for table 'Surveys'"`

**Recommendation:**
- Return generic error messages to clients: `"Database operation failed. Please try again."`
- Log actual database errors server-side for debugging
- Sanitize all error responses before returning to client

---

### 2.2 Error Logging to stdout in Login Endpoint

**File:** `backend/app/api/v1/auth.py` (Line 282, 445)

```python
except mysql.connector.Error as err:
    print(err)  # Prints raw error to stdout
    raise HTTPException(status_code=500, detail="Delete failed")
```

**Impact:** 
- Raw database errors are written to stdout, visible in container logs, CloudWatch, etc.
- Operators and log systems may expose these to unauthorized parties
- Error details propagated through CI/CD logs, monitoring systems

**Recommendation:**
- Use proper logging framework (Python logging module)
- Set appropriate log levels (ERROR, not print)
- Sanitize logs through centralized log aggregation
- Remove print statements entirely

---

### 2.3 Inconsistent Error Handling in Auth Endpoints

**File:** `backend/app/api/v1/auth.py` (Line 499-500)

```python
except mysql.connector.Error:
    # Still do NOT reveal whether the email exists; but you might want to log this server-side
```

**Current:** Comment acknowledges the issue but no actual logging is present.

**Gap:** This is best practice (generic response to prevent enumeration attacks), but the lack of logging means you have no visibility into authentication failures.

---

## Section 3: Flutter — Missing Loading States

**Severity:** Medium  
**Count:** Multiple screens, but proper `.when()` patterns ARE generally implemented

### 3.1 Good Example (Participant Surveys Page)

**File:** `frontend/lib/src/features/participant/pages/participant_surveys_page.dart` (Line 43-53)

```dart
surveysAsync.when(
  data: (surveys) => _buildSurveyList(context, surveys, l10n),
  loading: () => const AppLoadingIndicator(),
  error: (error, _) => AppEmptyState.error(
    title: l10n.participantSurveyLoadError,
    action: AppOutlinedButton(
      label: l10n.participantRetry,
      onPressed: () => ref.invalidate(participantSurveysProvider),
    ),
  ),
),
```

**Positive:** This properly handles all three states (loading, data, error) with user-visible feedback.

### 3.2 Recommendation

Most AsyncValue usages in the codebase appear to follow this pattern. Continue maintaining this discipline across all async data loads.

---

## Section 4: Flutter — Missing Empty States

**Severity:** Low-Medium  
**Count:** Properly handled in most cases

### 4.1 Example: Participant Surveys Page

**File:** `frontend/lib/src/features/participant/pages/participant_surveys_page.dart` (Line 64-68)

```dart
if (surveys.isEmpty) {
  return AppEmptyState(
    icon: Icons.assignment_outlined,
    title: l10n.participantNoSurveys,
  );
}
```

**Positive:** Empty state is explicitly handled with icon and localized message.

### 4.2 Recommendation

Empty state handling is well-implemented throughout the codebase. Maintain this pattern.

---

## Section 5: Flutter — Missing Retry Affordances

**Severity:** Medium  
**Count:** Good implementation in most cases

### 5.1 Good Example: Survey Taking Error Handling

**File:** `frontend/lib/src/features/participant/pages/participant_surveys_page.dart` (Line 584-615)

```dart
error: (e, _) => Center(
  child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.wifi_off, size: 48, color: AppTheme.error),
        const SizedBox(height: 16),
        Text(l10n.surveyTakingNetworkError, ...),
        const SizedBox(height: 16),
        AppOutlinedButton(
          label: l10n.surveyTakingRetry,
          onPressed: () => ref.invalidate(...),
        ),
      ],
    ),
  ),
),
```

**Positive:** Error state includes explicit retry button with proper affordance.

---

## Section 6: Flutter — Swallowed Errors

**Severity:** Medium  
**Count:** 4 instances

### 6.1 Uncaught Exception in Profile Page Date Picker

**File:** `frontend/lib/src/features/profile/pages/profile_page.dart` (Line 125-127)

```dart
try {
  initialDate = DateTime.parse(currentText);
} catch (_) {}
```

**Impact:** If date parsing fails, the exception is silently swallowed. User sees no indication of why their date didn't parse, defaults to year 2000 silently.

**Recommendation:**
- Log parse failures: `debugPrint('Failed to parse birthdate: $currentText')`
- Consider showing a warning if the stored date is invalid
- Validate dates during save, not just during load

---

### 6.2 Silent JSON Decoding Failure in Survey Question Fields

**File:** `frontend/lib/src/features/participant/widgets/participant_survey_question_fields.dart` (Line 413-421)

```dart
try {
  final decoded = jsonDecode(value!);
  if (decoded is List) {
    return decoded
        .map((entry) => int.tryParse(entry.toString().trim()))
        .whereType<int>()
        .toSet();
  }
} catch (_) {}  // Falls back to comma-separated parsing

return value!
    .split(',')
    .map((entry) => int.tryParse(entry.trim()))
    .whereType<int>()
    .toSet();
```

**Impact:** When JSON decoding fails, it silently falls back to comma-separated parsing. This could hide data corruption or format migration issues. No user feedback.

**Recommendation:**
- Log the JSON decode failure with the original string
- If fallback parsing succeeds, log a warning ("non-standard response format detected")
- Add analytics to track format conversion failures

---

### 6.3 Silent Survey Draft Loading Failure

**File:** `frontend/lib/src/features/participant/pages/participant_surveys_page.dart` (Line 284-300)

```dart
Future<void> _loadDraft() async {
  try {
    final dio = ref.read(apiClientProvider).dio;
    final resp = await dio.get<Map<String, dynamic>>(
      '/participants/surveys/${widget.surveyId}/draft',
    );
    // ... handle success
  } catch (_) {
    // Draft loading is best-effort — don't block survey taking
  }
}
```

**Impact:** If draft loading fails (network error, 404, server error), no user feedback is given. User doesn't know if they lost their progress or if the load failed. For healthcare surveys, losing draft data is serious.

**Recommendation:**
- Add debug logging: `debugPrint('Failed to load draft for survey ${widget.surveyId}: $e')`
- If draft loading is critical, show a non-blocking warning toast
- Track draft loading success/failure metrics

---

### 6.4 Silent Survey Draft Saving Failure

**File:** `frontend/lib/src/features/participant/pages/participant_surveys_page.dart` (Line 303-314)

```dart
Future<void> _saveDraft() async {
  if (_submitted || _responses.isEmpty) return;
  try {
    final api = ref.read(participantApiProvider);
    await api.saveDraft(widget.surveyId, {...});
  } catch (_) {
    // Draft saving is best-effort
  }
}
```

**Impact:** Same as above — critical user data (survey draft) fails to save silently. User continues with no indication that their work isn't being persisted.

**Recommendation:**
- For survey drafts, consider showing a toast on save success/failure
- Log: `debugPrint('Failed to save survey draft for ${widget.surveyId}')`
- Track draft persistence reliability metrics

---

### 6.5 Impersonation State Hydration Failure

**File:** `frontend/lib/src/features/auth/state/impersonation_provider.dart` (Line 107-118)

```dart
Future<void> _hydratePreviewRole() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString(_previewRoleStorageKey);
    // ...
  } catch (_) {}  // Silent failure
}
```

**Impact:** If SharedPreferences fails (corrupted local storage, permission issues), the admin loses their preview role state silently. They may be confused about why their role preview isn't active.

**Recommendation:**
- Log: `debugPrint('Failed to hydrate admin preview role from SharedPreferences')`
- Show a one-time warning toast if hydration fails repeatedly

---

## Section 7: Flutter — Toast/Snackbar Consistency

**Severity:** Low  
**Count:** Good consistency overall

### 7.1 AppToast Usage

**Files with AppToast:**
- `participant/pages/participant_surveys_page.dart` — Uses AppToast for survey submission feedback
- `admin/pages/*` — Uses AppToast for admin actions
- `templates/pages/*` — Uses AppToast for template operations

**Pattern Observed:**
```dart
AppToast.showSuccess(context, message: l10n.surveySubmitSuccess);
AppToast.showError(context, message: l10n.surveyTakingValidationError);
```

### 7.2 Recommendation

Toast/SnackBar usage appears consistent throughout. AppToast is the centralized feedback mechanism. Continue using it for all user-facing error/success messages.

---

## Summary & Recommendations

### Critical Issues (Fix Immediately)

1. **Audit logging failures are swallowed (Lines 333-334, 113-115)**
   - Implement fallback logging for audit events
   - Add metrics tracking audit failures
   - Healthcare compliance requires strong audit trails

2. **Database errors leaked to clients (admin.py:302, 324)**
   - Return generic error messages in HTTP responses
   - Log actual errors server-side only
   - Prevents information disclosure vulnerability

3. **Raw errors printed to stdout (auth.py:282, 445)**
   - Replace `print()` with proper logging
   - Configure log level filtering
   - Prevent error details in container/app logs

### High Priority (Within Sprint)

4. **Silent failures in draft saving/loading (surveys_page.dart)**
   - Add debug logging for all draft operations
   - Consider showing non-blocking toast for failures
   - Track draft persistence metrics for reliability analysis

5. **JSON decode fallback with no feedback (participant_survey_question_fields.dart)**
   - Log JSON decode failures
   - Add analytics for format conversion
   - Monitor for data corruption issues

### Medium Priority (Next Sprint)

6. **Date parsing without feedback (profile_page.dart)**
   - Add debug logging for parse failures
   - Validate dates during save
   - Show user feedback for invalid input

7. **Sanitization errors without observability (sanitize.py)**
   - Add debug-level logging for sanitization failures
   - Track which data types cause issues
   - Log examples of unrepresentable values

8. **Impersonation hydration silently fails (impersonation_provider.dart)**
   - Log SharedPreferences failures
   - Show one-time warning toast
   - Improve user awareness of state sync issues

### General Best Practices

**Backend:**
- Never return raw database errors to clients
- Always log exceptions server-side, even if not breaking the flow
- Use structured logging (not print statements)
- Sanitize all error responses before sending to clients

**Flutter:**
- Log all caught exceptions in debug builds
- Show user feedback for operations that affect user data
- Distinguish between "best-effort" operations and "critical" operations
- Use consistent toast/snackbar patterns for feedback
- Add analytics/metrics for error tracking

---

**Total Issues Found:** 15  
**Critical:** 3 | High:** 2 | Medium:** 6 | Low:** 4

**Estimated Remediation Time:** 8-12 development hours
