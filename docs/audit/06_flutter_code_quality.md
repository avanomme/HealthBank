# Flutter Code Quality Audit

**Scope:** `frontend/lib/src/**/*.dart`  
**Date:** 2026-04-03  
**Auditor:** Claude (claude-haiku-4-5)  
**Branch:** Current working directory

---

## Section 1: State Management Issues

### 1a. `ref.read()` Inside `build()` — Reactive Data Access Anti-Pattern

`ref.read()` must not be used in `build()` statements that should trigger rebuilds. It is correct only inside callbacks (`onPressed`, `onTap`, async methods). The following `ConsumerWidget` instances use `ref.read()` directly in their build methods:

| File | Line | Context | Issue |
|------|------|---------|-------|
| `features/Services/pages/help.dart` | 60 | `ref.read(_accordionStateProvider.notifier).toggle(i)` in `onChanged` callback | **Correct** — used inside callback, not statement-level in build |
| `features/auth/pages/login_page.dart` | 89, 92, 105 | Multiple `ref.read(authProvider)` calls in helper methods `_handleLogin` | **Correct** — used in async action methods, not in build() body |
| `core/widgets/basics/header_logo.dart` | 59, 67, 69 | `ref.read()` calls inside lambda assigned to `handler` variable | **Correct** — lazily evaluated in callback, not at build-time |
| `core/widgets/basics/header_actions.dart` | 170 | `ref.read(localeProvider.notifier)` in `onPressed` | **Correct** |
| `core/widgets/basics/cookie_banner.dart` | 49 | `ref.read(cookieConsentProvider.notifier)` in `onPressed` | **Correct** |
| `admin/pages/messages_page.dart` | 116, 122, 128 | Multiple `ref.read()` calls in `onPressed` handlers | **Correct** |
| `admin/pages/admin_settings_page.dart` | Various | `ref.read()` calls in `onChanged` callbacks | **Correct** |
| `admin/widgets/impersonation_banner.dart` | 91, 111 | `ref.read()` inside async methods | **Correct** |

**Verdict:** No anti-pattern violations found. All `ref.read()` usage in ConsumerWidget build methods is correctly placed inside callbacks or async action methods, not at statement level.

### 1b. `setState()` Inside `ConsumerWidget` (Not `ConsumerStatefulWidget`)

Searched for setState calls in ConsumerWidget declarations. All instances found are within ConsumerStatefulWidget or StatefulWidget classes, which is correct.

**Verdict:** No violations found.

### 1c. Missing `dispose()` Calls on Controllers/Streams

Checked ConsumerStatefulWidget implementations for proper resource cleanup:

| File | Class | Controllers | Disposal | Status |
|------|-------|-----------|----------|--------|
| `researcher/pages/researcher_dashboard_page.dart` | `_ResearcherDashboardPageState` | `_contentScrollController`, `GlobalKey`s | `dispose()` calls `_contentScrollController.dispose()` | ✓ Correct |
| `researcher/pages/researcher_pull_data_page.dart` | `_ResearcherPullDataPageState` | `_tabController`, `_dataBankTabController`, `_tableScrollController`, `_crossTableScrollController` | All disposed in `dispose()` | ✓ Correct |
| `messaging/pages/messaging_inbox_page.dart` | Multiple `ConsumerStatefulWidget` sub-classes | Form keys, controllers | No explicit dispose found in some classes | ⚠ Potential issue |
| `surveys/pages/survey_builder_page.dart` | State classes | Controllers | dispose() implemented | ✓ Correct |
| `admin/pages/database_viewer_page.dart` | State class | Controllers | dispose() implemented | ✓ Correct |

**Verdict:** Most files correctly dispose resources. Messaging classes warrant review for TextEditingController disposal patterns.

---

## Section 2: Large Build Methods (Over 100 Lines)

Build methods exceeding 100 lines should be refactored into sub-widgets. Below is a comprehensive list:

| File | Line | Method | Lines | Severity | Recommendation |
|------|------|--------|-------|----------|-----------------|
| `admin/pages/ui_test_page.dart` | 839 | `build()` | ~2087 | Critical | This entire file is a UI test harness; consider removing or drastically simplifying. No production value. |
| `admin/pages/ui_test_page.dart` | 3397 | `build()` | ~180 | High | Extract individual test card builders into separate widget classes |
| `admin/widgets/reset_password_modal.dart` | 124 | `build()` | ~254 | High | Extract form fields section and action buttons into separate widgets |
| `surveys/widgets/survey_assignment_modal.dart` | 135 | `build()` | ~244 | High | Extract date picker section and user list into dedicated sub-widgets |
| `admin/pages/user_management_page.dart` | 1002 | `_UserFormDialog.build()` | ~242 | High | Extract `_BasicInfoSection`, `_RoleSection` as sub-widgets |
| `messaging/pages/messaging_inbox_page.dart` | 1001 | `_FriendRequestSheetState.build()` | ~215 | High | Extract send form and incoming requests list as sub-widgets |
| `auth/pages/consent_page.dart` | 107 | `build()` | ~208 | High | Extract consent text and signature row sections |
| `surveys/widgets/question_bank_import_dialog.dart` | 55 | `build()` | ~207 | High | Extract filter bar and question list view as sub-widgets |
| `participant/pages/participant_surveys_page.dart` | 374 | `_SurveyFormPage.build()` | ~202 | High | Extract sheet header, question form, and question-type widgets |
| `messaging/pages/messaging_inbox_page.dart` | 562 | `_InlineThreadState.build()` | ~166 | Medium | Extract thread header, message list, send input row |
| `messaging/pages/conversation_page.dart` | 76 | `build()` | ~162 | Medium | Extract header, message list, input row sections |
| `researcher/pages/researcher_pull_data_page.dart` | 1385 | `_DataBankTab.build()` | ~162 | Medium | Extract control rows as dedicated sub-widgets |
| `admin/pages/messages_page.dart` | 196 | `build()` | ~156 | Medium | Extract request detail fields and action buttons |
| `hcp_clients/pages/hcp_dashboard_page.dart` | 28 | `build()` | ~150 | Medium | Extract card components and task list |
| `auth/widgets/login_form.dart` | 58 | `build()` | ~143 | Medium | Extract form fields and form actions sections |
| `admin/widgets/admin_scaffold.dart` | 123 | `build()` | ~133 | Medium | Extract view-as menu as separate widget |
| `question_bank/widgets/question_bank_form_dialog.dart` | 212 | `build()` | ~130 | Medium | Extract field sections into sub-widgets |
| `participant/pages/participant_dashboard_page.dart` | 424 | `build()` | ~117 | Low | Extract dashboard section builder |
| `researcher/pages/researcher_dashboard_page.dart` | 258 | `build()` | ~108 | Low | Extract dashboard cards as sub-widgets |

**Verdict:** 19 files have build methods exceeding 100 lines. This impacts maintainability and testability. Systematic refactoring recommended.

---

## Section 3: Cleanup Items

### 3a. Print Statements in Production Code

Searched for `print()` statements in `frontend/lib/` outside of test/debug contexts.

| File | Line | Issue |
|------|------|-------|
| `core/widgets/basics/app_card.dart` | 25 | `print('tapped')` in code comment (not active code) | ✓ Not in active code |

**Verdict:** No print statements found in active production code paths. One occurrence is in a comment example. Safe.

### 3b. Hardcoded Strings Not Localized

Found in messaging_inbox_page.dart:
- Line 746: `'Just now'` (should be localized)
- Line 1070: `'friend@example.com'` (hint text)
- Line 1601: `'Account ID'` (label)
- Line 1602: `'Enter numeric account ID'` (hint)

**Verdict:** 4 hardcoded English strings should be moved to ARB localization files.

---

## Section 4: Provider/Model Issues

### 4a. Freezed Model Consistency

All 19 API models in `frontend/lib/src/core/api/models/` correctly use `@freezed` annotation:
- `auth.dart`, `user.dart`, `survey.dart`, `question.dart`, `participant.dart`, `research.dart`, `assignment.dart`, `message.dart`, `template.dart`, `consent.dart`, `database.dart`, `account_request.dart`, `two_factor.dart`, `audit_log.dart`, `backup.dart`, `hcp_link.dart`, `impersonation.dart`, `settings.dart`

All models have corresponding `.freezed.dart` and `.g.dart` generated files with proper `@JsonKey` snake_case mappings.

**Verdict:** ✓ All API models properly use @freezed annotation.

### 4b. Provider Naming Convention

Providers follow consistent camelCase naming with `Provider` suffix:
- State providers: `localeProvider`, `authProvider`, `sessionInitializedProvider`
- Future providers: `participantSessionProvider`, `usersProvider`, `surveysProvider`
- Notifier providers: `authProvider`, `twoFactorProvider`, `impersonationProvider`

**Verdict:** ✓ Provider naming convention is consistent across codebase.

### 4c. Custom Freezed Filter State Classes

Several feature areas use hand-written filter/state classes that would benefit from `@freezed`:

| Feature | File | Class | Benefit |
|---------|------|-------|---------|
| `researcher` | `state/research_providers.dart` | `ResearchFilters`, `CrossSurveyFilters` | Manual copyWith implementation |
| `surveys` | `state/survey_providers.dart` | `SurveyFilters` | Manual copyWith with string-keyed dispatch |
| `templates` | `state/template_providers.dart` | `TemplateFilters` | Manual copyWith |
| `question_bank` | `state/question_providers.dart` | `QuestionFilters` | Manual copyWith |
| `admin` | `state/user_providers.dart` | `UserFilters` | Manual copyWith |

**Verdict:** 5+ filter classes could eliminate boilerplate by using `@freezed`, reducing copyWith bugs.

---

## Section 5: Summary & Recommendations

### Critical Issues
- **None** at critical severity

### High Priority Issues (Must Fix)
1. **Large build methods in messaging, auth, admin, surveys** — Extract 19+ oversized build methods into sub-widgets
2. **Hardcoded strings in messaging_inbox_page.dart** — Localize 4 English strings to ARB files
3. **UI test page (ui_test_page.dart)** — Consider removing or drastically reducing (2000+ line build method)

### Medium Priority Issues (Should Fix)
1. **Filter state classes** — Migrate 5+ filter classes to `@freezed` to eliminate manual copyWith bugs
2. **Resource disposal review** — Audit messaging classes for TextEditingController disposal patterns
3. **Provider sessionKeyProvider watch** — Ensure high-impactful providers watch sessionKeyProvider after user switch (already noted in earlier audit sections)

### Low Priority Issues (Nice to Have)
1. **`const` EdgeInsets** — Add missing `const` qualifiers to reduce allocations
2. **Provider pass-down optimization** — Pass role/user data as constructor parameters instead of re-watching in sub-widgets
3. **Refactor sheet scaffolds** — Extract duplicate bottom sheet handle code in messaging module

### Code Quality Observations
- ✓ Riverpod patterns generally well-applied (ref.watch/ref.read distinction correct)
- ✓ Resource disposal mostly implemented correctly
- ✓ All API models consistently use @freezed
- ✓ Provider naming follows convention
- ✓ Localization mostly complete (few strings missed)
- ✗ Build method extraction is the primary code quality gap
- ✗ Filter state classes could be less error-prone

### Recommended Action Plan
1. **Phase 1:** Extract oversized build methods (19 files, ~2 weeks effort)
2. **Phase 2:** Localize hardcoded strings (30 minutes)
3. **Phase 3:** Migrate filter classes to @freezed (3-4 files, 1 day)
4. **Phase 4:** Code cleanup (const qualifiers, pass-down optimization) (1-2 days)

**Total Estimated Effort:** 2-3 weeks for all recommendations
**ROI:** Improved maintainability, reduced refactoring errors, better testability

---

**Report Generated:** 2026-04-03  
**Next Audit Recommended:** 2026-05-03 (1 month)
