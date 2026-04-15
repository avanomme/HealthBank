# Adding Authentication & Authorization to New Pages

This guide shows how to protect new backend API endpoints and frontend pages using HealthBank's existing auth system. Follow these patterns for every new feature.

## Role Reference

| RoleID | Name        | String Key    | Dashboard Route          |
|--------|-------------|---------------|--------------------------|
| 1      | Participant | `participant` | `/participant/dashboard`  |
| 2      | Researcher  | `researcher`  | `/surveys`               |
| 3      | HCP         | `hcp`         | `/hcp/dashboard`         |
| 4      | Admin       | `admin`       | `/admin`                 |

**Admin (RoleID=4) always has access to everything.** The `SYSTEM_ADMIN_ROLE_ID` constant in `deps.py` ensures `require_role()` always passes for admin, regardless of which roles are specified.

---

## Backend: Protecting API Endpoints

### Core Dependencies (in `backend/app/api/deps.py`)

| Function | Purpose | Returns |
|----------|---------|---------|
| `get_current_user` | Validates Bearer token or session cookie | `{"account_id", "email", "role_id", "viewing_as_user_id", ...}` |
| `require_role(*role_ids)` | Checks user has an allowed role | Same dict + `effective_account_id`, `effective_role_id` |
| `sanitized_string(v)` | Wraps `sanitizeData()` for Pydantic validators | Cleaned string |

### Pattern 1: Router-Level Guard (All Endpoints Same Role)

Use this when every endpoint in a router requires the same role(s). This is the most common pattern.

```python
# backend/app/api/v1/analytics.py
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel, field_validator
from ..deps import require_role, sanitized_string

# Router-level dependency — applies to ALL endpoints in this router
router = APIRouter(dependencies=[Depends(require_role(2, 4))])


class AnalyticsQuery(BaseModel):
    metric_name: str
    date_range: str | None = None

    @field_validator("metric_name", "date_range", mode="before")
    @classmethod
    def sanitize(cls, v):
        return sanitized_string(v)


@router.get("/metrics")
def get_metrics(user=Depends(require_role(2, 4))):
    """
    Access user dict via the `user` parameter:
    - user["account_id"]           — the logged-in user's account
    - user["effective_account_id"] — the effective account (may differ during admin view-as)
    - user["effective_role_id"]    — the effective role
    """
    account_id = user["effective_account_id"]
    # ... your logic here
    return {"metrics": []}
```

**How it works:**
1. `dependencies=[Depends(require_role(2, 4))]` on the router runs the auth check for every request
2. If the user isn't authenticated → **401 Unauthorized**
3. If the user's role isn't in `(2, 4)` and isn't admin → **403 Forbidden**
4. Admin (RoleID=4) always passes, even if not explicitly listed

### Pattern 2: Per-Endpoint Guard (Mixed Access)

Use this when different endpoints in the same router need different roles.

```python
# backend/app/api/v1/mixed_access.py
from fastapi import APIRouter, Depends
from ..deps import get_current_user, require_role

# No router-level dependency
router = APIRouter()


@router.get("/public-info")
def get_public_info():
    """No auth required — anyone can call this."""
    return {"status": "ok"}


@router.post("/submit")
def submit_data(user=Depends(require_role(1, 2, 4))):
    """Participant, researcher, or admin can submit."""
    return {"submitted_by": user["effective_account_id"]}


@router.delete("/{item_id}")
def delete_item(item_id: int, user=Depends(require_role(4))):
    """Admin only."""
    return {"deleted": item_id}


@router.post("/disable-feature")
def disable_feature(user=Depends(get_current_user)):
    """Any authenticated user (no role restriction)."""
    return {"disabled_by": user["account_id"]}
```

### Pattern 3: Sanitizing User Input

Per `docs/Security.md`: use `sanitizeData()` for all user-supplied text written to the database.

```python
from pydantic import BaseModel, field_validator
from ..deps import sanitized_string


class ReportCreate(BaseModel):
    title: str
    body: str | None = None
    priority: int  # Numeric fields don't need sanitization

    @field_validator("title", "body", mode="before")
    @classmethod
    def sanitize(cls, v):
        return sanitized_string(v)
```

**What `sanitized_string()` does:**
- Unicode NFKC normalization
- Removes null bytes (`\x00`)
- Removes control characters (ASCII 0-31, 127)
- Trims whitespace
- Truncates to 10,000 characters

**Do NOT sanitize:**
- Passwords (would alter the password)
- Email fields that use `EmailStr` (Pydantic already validates)
- Numeric/boolean fields (not strings)

### Registering a New Router

Add the router in `backend/app/main.py`:

```python
from app.api.v1 import analytics

app.include_router(
    analytics.router,
    prefix="/api/v1/analytics",
    tags=["Analytics"],
)
```

---

## Frontend: Protecting Pages

### How Route Guards Work

GoRouter's `redirect` callback runs before every navigation. It checks:

1. **Session ready?** — During startup, allow all navigation (no redirects)
2. **Public route?** — Routes in `_publicRoutes` are always accessible
3. **Authenticated?** — If not, redirect to `/login`
4. **Role allowed?** — Check the user's role against `_roleAllowedPrefixes`

### Role-to-Route Prefix Map

```dart
// frontend/lib/src/config/go_router.dart
const _roleAllowedPrefixes = <String, List<String>>{
  'participant': ['/participant'],
  'researcher': ['/researcher', '/surveys', '/templates', '/questions'],
  'hcp': ['/hcp'],
  // Admin is omitted — handled by `role != 'admin'` check in redirect
};
```

**Rule:** A user can only access routes whose path starts with one of their allowed prefixes. Admin bypasses this check entirely (the redirect logic skips prefix checking when `role == 'admin'`).

### Adding a New Protected Page

**Example:** Adding a researcher analytics page at `/researcher/analytics`.

#### Step 1: Add the route path

```dart
// frontend/lib/src/config/go_router.dart
class AppRoutes {
  // ... existing routes ...
  static const researcherAnalytics = '/researcher/analytics';  // NEW
}
```

#### Step 2: Add the GoRoute entry

```dart
// In the routes list:
GoRoute(
  path: AppRoutes.researcherAnalytics,
  pageBuilder: (context, state) =>
      _noTransitionPage(const ResearcherAnalyticsPage(), state),
),
```

#### Step 3: Verify the route prefix matches the role

`/researcher/analytics` starts with `/researcher`, which is in the `researcher` list in `_roleAllowedPrefixes`. No changes needed.

If you were adding `/analytics` (no prefix), you would need to add `'/analytics'` to the researcher list:

```dart
'researcher': ['/researcher', '/surveys', '/templates', '/questions', '/analytics'],
```

#### Step 4: Add navigation item (optional)

```dart
// frontend/lib/src/config/navigation.dart
static const List<NavItem> _researcherNavItems = [
  NavItem(label: 'Dashboard', route: '/researcher/dashboard'),
  NavItem(label: 'Surveys', route: '/surveys'),
  NavItem(label: 'Templates', route: '/templates'),
  NavItem(label: 'Question Bank', route: '/questions'),
  NavItem(label: 'Analytics', route: '/researcher/analytics'),  // NEW
];
```

#### Step 5: Create the page widget

```dart
// frontend/lib/src/features/researcher/pages/researcher_analytics_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResearcherAnalyticsPage extends ConsumerStatefulWidget {
  const ResearcherAnalyticsPage({super.key});

  @override
  ConsumerState<ResearcherAnalyticsPage> createState() =>
      _ResearcherAnalyticsPageState();
}

class _ResearcherAnalyticsPageState
    extends ConsumerState<ResearcherAnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    // Use ref.watch() for reactive data from providers
    return const Scaffold(
      body: Center(child: Text('Analytics')),
    );
  }
}
```

#### Step 6: Export from feature barrel

```dart
// frontend/lib/src/features/researcher/researcher.dart
export 'pages/researcher_analytics_page.dart';
```

---

## Auth Flow Summary

```
Browser/App                    Backend (FastAPI)
    │                               │
    ├─ POST /auth/login ───────────►│ Validates credentials
    │◄─ Set-Cookie: session_token ──│ Creates session in DB (SHA-256 hashed)
    │                               │
    ├─ GET /api/v1/surveys ────────►│ get_current_user():
    │   Cookie: session_token       │   1. Extract token from cookie (or Bearer header)
    │                               │   2. Hash token → look up in Sessions table
    │                               │   3. JOIN AccountData → get RoleID
    │                               │   4. Return user dict
    │                               │
    │                               │ require_role(2, 4):
    │                               │   1. Receive user dict from get_current_user
    │                               │   2. Check if ViewingAsUserID is set
    │                               │   3. Compare effective role against allowed roles
    │                               │   4. Admin (RoleID=4) always passes
    │                               │   5. Return enriched user dict
    │◄─ 200 OK / 401 / 403 ─────────│
    │                               │
    ├─ GoRouter redirect ──────────►│ (Frontend only, no backend call)
    │   Check: sessionReady?        │
    │   Check: isAuthenticated?     │
    │   Check: role in allowed      │
    │          prefixes for path?   │
    │   Redirect if unauthorized    │
```

---

## Security Checklist for New Features

Before merging any new page or API endpoint, verify:

- [ ] **Backend router has `require_role()` dependency** — either router-level or per-endpoint
- [ ] **Frontend route prefix matches the role** in `_roleAllowedPrefixes` (go_router.dart)
- [ ] **Write endpoints sanitize string inputs** via `sanitized_string()` in Pydantic validators
- [ ] **Endpoint uses `user["effective_account_id"]`** (not query params) for user identity
- [ ] **All SQL queries use parameterized statements** — never f-strings or string interpolation
- [ ] **Password fields are NOT sanitized** — sanitization would alter the password
- [ ] **No secrets in logs** — never log tokens, passwords, master keys, or full encrypted values
- [ ] **Tests cover 401 (unauthenticated) and 403 (wrong role)** response codes
- [ ] **Test results logged to Testing_Log.xlsx**

---

## Current Auth Guard Status

### Backend Routers

| Router | Prefix | Guard | Roles |
|--------|--------|-------|-------|
| `auth.py` | `/api/v1/auth` | Public (except DELETE) | — |
| `sessions.py` | `/api/v1/sessions` | Public / custom | — |
| `two_factor.py` | `/api/v1/2fa` | Public (except /disable) | — |
| `tos.py` | `/api/v1/tos` | `get_current_user` | Any authenticated |
| `research.py` | `/api/v1/research` | `require_role(2, 4)` | Researcher, Admin |
| `responses.py` | `/api/v1/responses` | `require_role(1)` | Participant (+Admin) |
| `admin.py` | `/api/v1/admin` | `require_role(4)` | Admin |
| `users.py` | `/api/v1/users` | `require_role(4)` | Admin |
| `surveys.py` | `/api/v1/surveys` | `require_role(2, 4)` | Researcher, Admin |
| `templates.py` | `/api/v1/templates` | `require_role(2, 4)` | Researcher, Admin |
| `question_bank.py` | `/api/v1/questions` | `require_role(2, 4)` | Researcher, Admin |
| `assignments.py` | `/api/v1/surveys` (sub) | `require_role(2, 4)` | Researcher, Admin |
| `assignments.py` | `/api/v1/assignments` | `require_role(1, 2, 4)` | Participant, Researcher, Admin |

### Frontend Route Prefixes

| Role | Allowed Prefixes | Dashboard |
|------|-----------------|-----------|
| Participant | `/participant` | `/participant/dashboard` |
| Researcher | `/researcher`, `/surveys`, `/templates`, `/questions` | `/surveys` |
| HCP | `/hcp` | `/hcp/dashboard` |
| Admin | *all routes* | `/admin` |
