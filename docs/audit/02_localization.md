# Audit 02: Localization

**Date:** 2026-04-03
**Previous Audit:** 2026-03-02
**Auditor:** audit-localization agent
**Scope:** `frontend/lib/src/features/` (all `.dart` files) and `frontend/lib/src/core/l10n/arb/`
**ARB Files Analyzed:** `app_en.arb` (346 keys), `app_fr.arb` (346 keys)

---

## Part 1: Hardcoded Strings

Found **26 hardcoded user-facing strings** in Dart widget trees not using `context.l10n.*`.

| # | File | String | Suggested Key | Priority |
|---|------|--------|---------------|----------|
| 1 | `settings/pages/settings_page.dart` | `'Reset'` | `commonReset` | HIGH |
| 2 | `participant/widgets/view_all_tasks_button.dart` | `'View All Tasks'` | `participantViewAllTasks` | HIGH |
| 3 | `admin/widgets/admin_scaffold.dart` | `'User Management'` | `adminUserManagement` | HIGH |
| 4 | `admin/widgets/admin_scaffold.dart` | `'Database'` | `adminDatabase` | HIGH |
| 5 | `admin/widgets/admin_scaffold.dart` | `'Account Requests'` | `adminAccountRequests` | HIGH |
| 6 | `admin/widgets/admin_scaffold.dart` | `'Audit Log'` | `adminAuditLog` | HIGH |
| 7 | `admin/widgets/admin_scaffold.dart` | `'Settings'` | `adminSettings` | HIGH |
| 8 | `admin/widgets/admin_scaffold.dart` | `'UI Test'` | `adminUiTest` | MEDIUM (test page) |
| 9 | `admin/widgets/admin_scaffold.dart` | `'Page Navigator'` | `adminPageNavigator` | MEDIUM (test page) |
| 10 | `surveys/widgets/survey_preview_dialog.dart` | `'Close'` | `commonClose` | HIGH |
| 11 | `surveys/widgets/question_types/yesno_question_widget.dart` | `'Yes'` (Semantics) | `surveyYesLabel` | HIGH |
| 12 | `surveys/widgets/question_types/yesno_question_widget.dart` | `'Yes'` (button) | `surveyYesLabel` | HIGH |
| 13 | `surveys/widgets/question_types/yesno_question_widget.dart` | `'No'` (Semantics) | `surveyNoLabel` | HIGH |
| 14 | `surveys/widgets/question_types/yesno_question_widget.dart` | `'No'` (button) | `surveyNoLabel` | HIGH |
| 15 | `question_bank/pages/question_bank_page.dart` | `'Clear Filters'` | `commonClearFilters` | HIGH |
| 16 | `question_bank/pages/question_bank_page.dart` | `'Add Question'` | `questionBankAddQuestion` | HIGH |
| 17 | `question_bank/pages/question_bank_page.dart` | `'Retry'` | `commonRetry` | HIGH |
| 18 | `messaging/widgets/recipient_tile.dart` | `'Open conversation with $name'` | `messagingOpenConversationWith` | HIGH |
| 19 | `admin/pages/audit_log_page.dart` | `'GET'` | `auditLogMethodGet` | LOW (technical term) |
| 20 | `admin/pages/audit_log_page.dart` | `'POST'` | `auditLogMethodPost` | LOW (technical term) |
| 21 | `admin/pages/audit_log_page.dart` | `'PUT'` | `auditLogMethodPut` | LOW (technical term) |
| 22 | `admin/pages/audit_log_page.dart` | `'PATCH'` | `auditLogMethodPatch` | LOW (technical term) |
| 23 | `admin/pages/audit_log_page.dart` | `'DELETE'` | `auditLogMethodDelete` | LOW (technical term) |
| 24 | `participant/pages/participant_results_page.dart` | `'  •  '` | N/A (styling) | LOW |
| 25 | `admin/pages/audit_log_page.dart` | `'-'` | N/A (styling) | LOW |
| 26 | `admin/pages/audit_log_page.dart` | `''` (empty string) | N/A | NONE |

**18 of 26** are legitimate UI labels requiring localization. The rest are HTTP method labels (5 — acceptable as technical terms), structural separators (2), or empty strings (1).

---

## Part 2: ARB Key Parity

| Metric | Count |
|--------|-------|
| Keys in `app_en.arb` | 346 |
| Keys in `app_fr.arb` | 346 |
| Keys missing from FR | **0** |
| Keys missing from EN | **0** |
| **Parity Status** | **PERFECT ✓** |

No localization gaps exist between English and French. Both files are fully in sync.

---

## Part 3: Unused ARB Keys

**~146 keys unused (~42% of all keys)**

### Category A: `@` metadata annotation keys (~73)
ARB annotation objects (`@keyName`) providing placeholder/type metadata — not called directly in Dart, by ARB design. These are technically correct and expected.

### Category B: Likely unused UI keys (~73)
Keys such as `assigned`, `category`, `count`, `email`, `status`, `title`, `total`, `value`, `version` — appear to be either:
- Data property names added to ARB instead of kept as code constants
- Keys added in anticipation of features not yet built
- Legacy keys from removed features

---

## Part 4: Summary & Recommendations

| Metric | Value |
|--------|-------|
| Hardcoded user-facing strings found | 26 |
| Strings needing new ARB keys | 9 |
| EN ↔ FR parity | Perfect (346 = 346) |
| Unused non-metadata ARB keys | ~73 |
| Active localization coverage | ~79% |

### Priority Fixes

**HIGH — Localize immediately:**
- `yesno_question_widget.dart` — Yes/No button labels and Semantics labels (4 instances)
- `admin_scaffold.dart` — 7 sidebar navigation labels
- `view_all_tasks_button.dart` — "View All Tasks"
- `question_bank_page.dart` — "Clear Filters", "Add Question", "Retry"
- `survey_preview_dialog.dart` — "Close" button
- `recipient_tile.dart` — "Open conversation with $name"

**MEDIUM:**
- Admin dev/test page labels ("UI Test", "Page Navigator") — localize if pages are shown to users

**LOW / Defer:**
- HTTP method labels in audit log (acceptable as universal technical terms)
- Styling separators (`•`, `-`) — typically not localized

### Recommended Actions

1. Add the 9 missing ARB keys to both `app_en.arb` and `app_fr.arb`, run `flutter gen-l10n`
2. Replace all 18 HIGH-priority hardcoded strings with `context.l10n.*` equivalents
3. Audit the ~73 unused non-metadata keys — deprecate stale ones, implement pending ones
4. Enforce in code review: no string literals in widget trees without an l10n key
