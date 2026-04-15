# Playwright Coverage Matrix

This matrix tracks demo-video coverage for the Flutter web app.

Status values:
- `Recorded`: spec exists and current MP4 exists in `tools/demo-videos/output/web/videos/`
- `Scripted`: spec exists but has not been rendered into the current flat MP4 set
- `Missing`: route/page exists but no dedicated Playwright flow exists yet

## Current Coverage

| Area | Routes / Pages | Current Flow IDs | Status | Notes |
| --- | --- | --- | --- | --- |
| Public auth onboarding | `/request-account`, first-login flows for participant/researcher/hcp, admin login | `01`-`05` | Recorded | Current auth base set exists and is refreshed. |
| Participant core | `/participant/dashboard`, `/participant/tasks`, `/participant/surveys`, `/participant/results` | `06`-`11` | Recorded | Good end-user coverage. |
| Participant messaging/account | `/messages`, `/messages/new`, `/profile`, `/settings` | `12`-`17` | Recorded | `12` and `13` overlap and can be merged later. |
| Researcher core | `/researcher/dashboard`, `/surveys`, `/templates`, `/questions`, `/researcher/data`, `/messages` | `18`-`32` | Recorded | Full current researcher suite rendered. |
| HCP core | `/hcp/dashboard`, `/hcp/clients`, `/hcp/reports` | `33`-`37` | Recorded | HCP suite is rendered in the current flat MP4 set. |
| Admin core | `/admin`, `/admin/users`, `/admin/messages`, `/admin/logs`, `/admin/settings`, `/admin/database`, `/admin/nav-hub` | `38`-`45` | Recorded | Admin suite is rendered in the current flat MP4 set. |
| Shared public/legal | `/`, `/about`, `/contact`, `/help`, `/privacy-policy`, `/terms-of-service` | `46` | Recorded | Public-information walkthrough exists and is exported. |
| Shared auth recovery/support | `/forgot-password`, `/reset-password`, `/two-factor`, `/logout`, `/deactivated-notice` | `47` | Recorded | Shared auth/support walkthrough exists and is exported. |
| Shared messaging secondary routes | `/messages/friends`, direct `/messages/:convId` conversation route | `48`, `49` | Recorded | Dedicated messaging follow-up recordings now exist in the flat MP4 set. |
| Admin secondary routes | `/admin/deletion-queue`, `/admin/ui-test` | `50`, `51` | Recorded | Dedicated admin follow-up recordings now exist in the flat MP4 set. |
| Participant results behavior coverage | `/participant/results` charts toggle, aggregate comparison toggle, rendered comparison/chart states | `52` | Recorded | Dedicated behavior flow now proves toggle interactions after the recent UI changes. |
| Admin dashboard behavior coverage | `/admin` KPI cards, quick links, dashboard-level navigation/actions | `53` | Recorded | Dedicated action flow now complements the existing dashboard walkthrough. |
| Admin user management behavior coverage | `/admin/users` add, edit, reset password, activate/deactivate, delete | `54` | Recorded | Dedicated action flow now exercises the core user-management lifecycle. |
| Admin request moderation behavior coverage | `/admin/messages` new-account request approve/reject actions | `55` | Recorded | Dedicated moderation flow now covers the core account-request actions. |
| Admin settings persistence coverage | `/admin/settings` save/apply settings changes | `56` | Recorded | Dedicated save behavior flow now complements the settings walkthrough. |
| Admin backup lifecycle coverage | `/admin/database` create manual backup, download, delete | `57` | Recorded | Dedicated backup-lifecycle flow now complements the database viewer walkthrough. |
| Admin audit export coverage | `/admin/logs` export CSV action | `58` | Recorded | Dedicated export flow now complements the audit-log walkthrough. |

## Recommended Flow Consolidation

| Proposed Combined Video | Existing Flows | Reason |
| --- | --- | --- |
| Participant Messaging | `12`, `13` | Add contact and send message are one natural user journey. |
| Participant Account Management | `14`, `15`, `16`, `17` | Avatar language, profile, and settings are all account-level actions. |
| Researcher Survey Lifecycle | `20`-`26` | Build, publish, assign, and manage status read better as a single end-to-end story. |
| Researcher Content Library | `27`, `28`, `29` | Templates and question bank are tightly related authoring surfaces. |
| Public Information | `46` | Home, about, contact, help, privacy, and terms fit one public walkthrough. |
| Shared Auth Support | `47` | Forgot/reset password, 2FA, logout, and deactivated notice fit one support flow. |
| Shared Messaging Secondary Routes | `48`, `49` | Friend requests and direct conversation routing are better as targeted route demos. |
| Admin Secondary Pages | `50`, `51` | Deletion-queue redirect and UI-test coverage are better as dedicated admin follow-ups. |
| Admin Action Coverage | `53`-`58` | These are behavior-oriented flows that should stay separate from the route walkthrough set. |

## Priority Order

1. Decide later whether to keep `12` and `13` split or replace them with one combined participant messaging video.
2. Decide later whether to keep `20`-`29` split or replace them with grouped researcher lifecycle/content videos.
3. Decide later whether some of `53`-`58` should stay as separate QA-style E2E videos or be merged into broader admin demos for delivery.
