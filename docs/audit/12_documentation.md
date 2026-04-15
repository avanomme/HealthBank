# Audit 12: Documentation Completeness

**Date:** 2026-04-03
**Previous Audit:** 2026-03-02
**Auditor:** audit-documentation agent
**Scope:** `docs/`, `README.md`, project root

---

## Section 1: Documentation Inventory

### docs/api/ (16 files)
| File | Coverage | Status |
|------|----------|--------|
| hcp_endpoints.md | HCP-specific endpoints | Current (Feb 2026) |
| messaging_endpoints.md | Messaging API | Current (Feb 2026) |
| Admin.md | Admin endpoints | Partially current |
| auth_docs.md | Auth endpoints | **STALE** — shows token in body, actual uses HttpOnly cookie |
| consent.md | Consent endpoints | Current |
| participants.md | Participant endpoints | Current |
| auth-middleware.md | Middleware | Current |
| admin-impersonation(DEP).md | Impersonation | **DEPRECATED** — includes migration SQL for column that already exists |
| admin-password-reset(DEP).md | Password reset | **DEPRECATED** |
| assignments.md | Assignments | Current |
| question-bank.md | Question bank | Current |
| research-data.md | Research endpoints | **STALE** — describes 5 endpoints, implementation has 11 |
| response-submission.md | Survey responses | Current |
| sessions.md | Sessions | **STALE** — documents POST /sessions/create that doesn't exist |
| surveys.md | Survey endpoints | Current |
| templates.md | Template endpoints | Current |
| tos_docs.md | Terms of service | Current |
| two_factor_docs.md | 2FA endpoints | **STALE** — documents /api/v1/two_factor/, actual path is /api/v1/2fa/ |
| users.md | User endpoints | **STALE** — states "Role column not yet implemented" |

### docs/database/ (2 files)
| File | Coverage | Status |
|------|----------|--------|
| schema.md | Database schema | **SEVERELY STALE** — documents 9 of 28 tables |
| seed-data.md | Seed data | Current |

**Missing from schema.md:** Account2FA, AccountDeletionRequest, AuditEvent, ConsentRecord, Conversations, ConversationParticipants, FriendRequests, HcpPatientLink, Messages, mfa_challenges, QuestionCategories, QuestionOptionTranslations, QuestionTranslations, and more.

### docs/frontend/ (17 files)
All current. Covers Flutter components, state management, survey builder, widgets, localization, etc. WCAG 2.2 Guidelines Checklist.xlsx present.

### docs/guides/ (7 files)
| File | Status |
|------|--------|
| deployment.md | Current and comprehensive (Feb 2026) |
| email_service.md | Current (Feb 2026) |
| Adding-auth-to-pages.md | Current |
| 2fa-plan.md | Informal design notes — functional |
| test-accounts.md | **STALE** — references old 4-account seed; actual seed has 33 accounts |

### docs/services/ (email service docs)
Current and comprehensive.

### docs/testing/
Present and current.

### docs/audit/ (this directory)
13 audit files, updated 2026-04-03.

---

## Section 2: Missing Documentation

### CRITICAL GAPS

**1. Deletion Request Workflow — NO DOCUMENTATION**
- `AccountDeletionRequest` table exists with 5 endpoints in `admin.py` and `auth.py`
- Endpoints: `POST /me/deletion-request`, `GET /admin/deletion-requests`, `POST /admin/deletion-requests/{id}/approve`, `POST /admin/deletion-requests/{id}/reject`, `GET /admin/deletion-requests/count`
- Zero documentation on approval/rejection workflow, email notifications, database schema, or user-facing flow

**2. MobileAuthInterceptor — NO DOCUMENTATION**
- File: `frontend/lib/src/core/api/mobile_auth_interceptor.dart`
- Used in `api_client.dart` for Bearer token management on mobile
- No documentation explaining token refresh flow, interceptor pattern, or error handling

**3. Messaging Frontend — NO DOCUMENTATION**
- Backend API (`messaging_endpoints.md`) is well documented
- Four frontend pages exist: `messaging_inbox_page.dart`, `conversation_page.dart`, `friend_request_page.dart`, `new_conversation_page.dart`
- Zero documentation for frontend state, providers, or polling implementation

**4. Account Request Workflow — PARTIALLY DOCUMENTED**
- `POST /auth/request_account` endpoint exists but not in API reference
- Frontend account request pages exist but undocumented
- Approval/rejection admin flow not documented end-to-end

### HIGH GAPS

**5. Admin Deletion Queue** — distinct from manual account purge; not documented separately
**6. Email notification system** — triggers (account created, rejected, deletion approved/rejected, password reset) not documented in one place
**7. ~34 backend endpoints** across all routers with no documentation

---

## Section 3: Potentially Outdated Documentation

| File | Issue |
|------|-------|
| `docs/README.md` | References non-existent files: `migrations.md`, `01-scope.md`, `02-decisions.md`, `architecture.md` |
| `docs/database/schema.md` | Documents 9 of 28 tables |
| `docs/api/auth_docs.md` | Shows `session_token` in response body; actual uses HttpOnly cookie only |
| `docs/api/sessions.md` | Documents `POST /sessions/create` that doesn't exist |
| `docs/api/two_factor_docs.md` | Wrong base path (`/two_factor/` vs `/2fa/`) |
| `docs/guides/test-accounts.md` | References old 4-account seed; actual has 33 accounts |
| `docs/api/research-data.md` | Describes 5 endpoints; implementation has 11 |
| `docs/api/users.md` | States "Role column not yet implemented" — RoleID has been in AccountData from the start |
| `docs/api/admin-impersonation(DEP).md` | Migration SQL for column that already exists |
| `Project root README.md` | Lists 6 API prefixes; 16 router prefixes exist |

---

## Section 4: Summary & Recommendations

### Health Metrics

| Area | Total | Documented | Stale |
|------|-------|------------|-------|
| Database tables | 28 | 9 (32%) | — |
| Backend API endpoints | ~85 | ~51 (60%) | — |
| Stale doc files | — | — | 10 |
| Critical undocumented features | 4 | 0 | — |

### Priority 1 — Block developer onboarding without these
1. Update `docs/database/schema.md` with all 28 tables and current columns
2. Create `docs/api/deletion_request.md` — full workflow + 5 endpoints
3. Create `docs/frontend/messaging.md` — 4 pages + providers + polling
4. Update `docs/api/auth_docs.md` to reflect HttpOnly cookie (not token in body)

### Priority 2 — High onboarding impact
1. Document `MobileAuthInterceptor` pattern
2. Document account request workflow end-to-end
3. Create email notification trigger reference
4. Fix wrong API path in `docs/api/two_factor_docs.md`
5. Update `docs/guides/test-accounts.md` for current 33-account seed

### Priority 3 — Quality improvements
1. Document the 34 undocumented backend endpoints
2. Create `docs/database/migrations.md` (referenced in README but doesn't exist)
3. Add WCAG remediation roadmap beyond the audit report
4. Document 6 missing env vars in `api.env.example` (`GMAIL_USER`, `GMAIL_APP_PASSWORD`)

### No action needed
- Docker/deployment documentation is comprehensive and current
- Frontend widget/state documentation is thorough and current
- Email service backend documentation is complete
