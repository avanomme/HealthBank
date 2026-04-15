# GoRouter Route Map and Role Guarding

This document describes the app’s GoRouter configuration (`frontend/lib/src/config/go_router.dart`): route paths, authentication/role redirects, and how frontend route guarding interacts with your Playwright E2E tests.

---

## Route paths

### Public + auth
| Name | Path |
|---|---|
| Home | `/` |
| Dev Hub | `/dev` |
| Login | `/login` |
| Logout | `/logout` |
| Forgot password | `/forgot-password` |
| Reset password | `/reset-password?token=...` |
| Request account | `/request-account` |
| Two-factor | `/two-factor?returnTo=...` |

### Onboarding / general authenticated
| Name | Path |
|---|---|
| Change password | `/change-password` |
| Consent | `/consent` |
| Complete profile | `/complete-profile` |
| About | `/about` |
| Help | `/help` |
| Terms of service | `/terms-of-service` |
| Privacy policy | `/privacy-policy` |
| Settings | `/settings` |

### Participant
| Name | Path |
|---|---|
| Dashboard | `/participant/dashboard` |
| Surveys | `/participant/surveys` |
| Results | `/participant/results` |
| Tasks | `/participant/tasks` |

### Researcher
| Name | Path |
|---|---|
| Dashboard | `/researcher/dashboard` |
| Data pull | `/researcher/data` |
| Surveys list | `/surveys` |
| Survey builder | `/surveys/new` |
| Survey edit | `/surveys/:id/edit` |
| Templates list | `/templates` |
| Template builder | `/templates/new` |
| Template edit | `/templates/:id/edit` |
| Question bank | `/questions` |

### HCP
| Name | Path |
|---|---|
| Dashboard | `/hcp/dashboard` |
| Clients | `/hcp/clients` |
| Reports | `/hcp/reports` |

### Admin
| Name | Path |
|---|---|
| Admin dashboard | `/admin` |
| Users | `/admin/users` |
| Database | `/admin/database` |
| Tickets | `/admin/tickets` |
| Messages | `/admin/messages` |
| Logs | `/admin/logs` |
| UI test | `/admin/ui-test` |

---

## Authentication + redirect logic

Routing uses a global `AuthChangeNotifier` (`authChangeNotifier`) as `refreshListenable`.

### Session initialization behavior
If `sessionReady == false`, **no redirects are applied** (router returns `null`). This is intentional so the app can bootstrap and decide whether a stored session exists.

### Home and login redirect behavior
- If `matchedLocation == '/'` and the user **is authenticated**, router redirects to `getDashboardRouteForRole(role)`.
- If `matchedLocation == '/login'` and the user **is authenticated**, router redirects to `getDashboardRouteForRole(role)`.

### Public routes
Routes in `_publicRoutes` are always accessible (even unauthenticated):

```dart
const _publicRoutes = [
  '/', '/login', '/logout', '/forgot-password', '/reset-password',
  '/request-account', '/two-factor', '/dev',
];