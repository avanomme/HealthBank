# HealthBank Security & Auth Integration Guide

How authentication works and how to integrate it when building new features.

## Architecture Overview

HealthBank uses **HttpOnly cookie-based session authentication**. The backend sets a `session_token` cookie on login; the browser sends it automatically on every request. No tokens are stored in JavaScript-accessible storage (no localStorage, no sessionStorage).

```
┌──────────┐   POST /auth/login          ┌─────────┐
│ Browser  │ ──────────────────────────► │ Backend │
│ (Flutter)│ ◄────────────────────────── │ (FastAPI)│
│          │   Set-Cookie: session_token │         │
│          │   (HttpOnly, SameSite=Strict)         │
│          │                             │         │
│          │   GET /sessions/me          │         │
│          │   Cookie: session_token ──► │         │
│          │ ◄────── { user, role, ... } │         │
└──────────┘                             └─────────┘
```

**Key properties:**
- Cookie is `HttpOnly` — JavaScript cannot read it (XSS-safe)
- Cookie is `SameSite=Strict` — not sent on cross-origin requests (CSRF-safe)
- Cookie is the **primary** auth mechanism; Bearer header is a fallback for non-browser clients
- Session tokens are SHA-256 hashed before storage in the database
- No token is ever returned in a JSON response body

---

## Backend: Protecting New Endpoints

### Router-Level Guard (All Endpoints Same Role)

Use `require_role()` from `deps.py` as a router dependency:

```python
from fastapi import APIRouter, Depends
from ..deps import require_role

# All endpoints require researcher (2) or admin (4)
router = APIRouter(dependencies=[Depends(require_role(2, 4))])

@router.get("/")
async def list_items():
    ...

@router.post("/")
async def create_item(user=Depends(require_role(2, 4))):
    # `user` dict available here for accessing account info
    account_id = user["effective_account_id"]
    ...
```

### Per-Endpoint Guard (Mixed Access)

When different endpoints need different roles:

```python
from fastapi import APIRouter, Depends
from ..deps import require_role, get_current_user

router = APIRouter()

@router.get("/public")
async def public_endpoint():
    ...  # No auth required

@router.get("/me")
async def my_data(user=Depends(require_role(1, 2, 4))):
    return get_data_for(user["effective_account_id"])

@router.delete("/{id}")
async def delete_item(id: int, user=Depends(require_role(4))):
    ...  # Admin only
```

### The `user` Dict

Both `get_current_user` and `require_role()` return a dict:

| Key | Type | Description |
|-----|------|-------------|
| `account_id` | `int` | The logged-in admin/user's AccountID |
| `email` | `str` | Account email |
| `role_id` | `int` | The logged-in user's RoleID |
| `viewing_as_user_id` | `int \| None` | Set when admin is viewing-as another user |
| `tos_accepted_at` | `datetime \| None` | When ToS was accepted |
| `tos_version` | `str \| None` | Which ToS version was accepted |
| `effective_account_id` | `int` | **Use this** — resolves to viewed-as user if active |
| `effective_role_id` | `int` | **Use this** — resolves to viewed-as user's role |

**Always use `effective_account_id` and `effective_role_id`** in business logic — they correctly resolve admin view-as.

### Role Reference

| RoleID | Name | Description |
|--------|------|-------------|
| 1 | participant | Survey respondents |
| 2 | researcher | Survey creators, data viewers |
| 3 | hcp | Healthcare professionals |
| 4 | admin | System administrators (access all routes) |

### Input Sanitization

Use `sanitized_string()` in Pydantic models to strip null bytes, control characters, and normalize Unicode:

```python
from pydantic import BaseModel, field_validator
from ..deps import sanitized_string

class MyCreate(BaseModel):
    title: str
    description: str | None = None

    @field_validator("title", "description", mode="before")
    @classmethod
    def sanitize(cls, v):
        return sanitized_string(v)
```

**Do NOT sanitize:** passwords (alters user input) or emails (EmailStr validates).

---

## Frontend: Adding Auth-Protected Pages

### Step 1: Create the Page Widget

```dart
// lib/src/features/my_feature/pages/my_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});
  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  @override
  Widget build(BuildContext context) {
    // Use ref.watch() for reactive data
    return Scaffold(
      body: Text('Hello'),
    );
  }
}
```

### Step 2: Add the Route

In `lib/src/config/go_router.dart`:

```dart
// 1. Add the route path constant
class AppRoutes {
  // ... existing routes ...
  static const myFeature = '/researcher/my-feature';
}

// 2. Add the GoRoute entry
GoRoute(
  path: AppRoutes.myFeature,
  pageBuilder: (context, state) =>
      _noTransitionPage(const MyPage(), state),
),
```

### Step 3: Ensure the Route Prefix Matches the Role

The `_roleAllowedPrefixes` map in `go_router.dart` controls which routes each role can access:

```dart
const _roleAllowedPrefixes = <String, List<String>>{
  'participant': ['/participant'],
  'researcher': ['/researcher', '/surveys', '/templates', '/questions'],
  'hcp': ['/hcp'],
  // Admin is omitted — admins can access ALL routes
};
```

Your route path **must** start with one of the prefixes for the intended role. For example:
- Researcher feature: `/researcher/my-feature` or `/surveys/my-feature`
- Participant feature: `/participant/my-feature`
- Admin feature: `/admin/my-feature`

### Step 4: Making API Calls

API calls automatically include the session cookie. No token management needed:

```dart
// 1. Define the API service (Retrofit)
@RestApi()
abstract class MyApi {
  factory MyApi(Dio dio) = _MyApi;

  @GET('/my-feature/items')
  Future<List<MyItem>> getItems();

  @POST('/my-feature/items')
  Future<MyItem> createItem(@Body() CreateItemRequest request);
}

// 2. Create the provider
final myApiProvider = Provider<MyApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return MyApi(client.dio);
});

// 3. Create data providers
final itemsProvider = FutureProvider<List<MyItem>>((ref) async {
  final api = ref.watch(myApiProvider);
  return api.getItems();
});
```

### Step 5: Session Handling

The app handles session lifecycle automatically:

- **Login**: `POST /auth/login` — backend sets `Set-Cookie` header, browser stores it
- **Session restore**: On app startup, `GET /sessions/me` checks if cookie is valid
- **401 handling**: `_ErrorInterceptor` calls `ApiClient.onSessionExpired`, which resets auth state and GoRouter redirects to `/login`
- **Logout**: `DELETE /sessions/logout` — backend deletes session and clears cookie

**You do NOT need to:**
- Store or read tokens manually
- Set Authorization headers
- Handle cookie management in your feature code

---

## Security Checklist for New Features

- [ ] Backend endpoints protected with `require_role()` or `get_current_user`
- [ ] Use `user["effective_account_id"]` (not raw `account_id`) for data queries
- [ ] String inputs sanitized via `sanitized_string()` in Pydantic validators
- [ ] No raw session tokens returned in JSON response bodies
- [ ] Frontend route prefix matches the intended role in `_roleAllowedPrefixes`
- [ ] SQL queries use parameterized statements (`%s` placeholders, never f-strings)
- [ ] Sensitive columns excluded from admin database viewer (add to `SENSITIVE_COLUMNS` in admin.py)
