# Health Data Bank - Project Structure & Architecture

> Single source of truth for project layout and system architecture.
> Last updated: 2026-01-27

## Project Overview

The Health Data Bank is a web-based application that helps people who are precariously housed to track and manage their health data. The system stores user-entered health information (daily habits, medical data, nutrition) and makes it viewable via graphs. The data helps researchers understand health patterns over time.

### User Roles

| Role | Capabilities |
|------|--------------|
| **Participant** | Dashboard, surveys, progress tracking, personal reports, aggregate comparison |
| **Researcher** | Create surveys, view aggregate data, generate reports, export to CSV |
| **HCP** | View individual participant data, filter by fields, generate HCP reports |
| **Admin** | User management, audit logs, ticket handling, database maintenance |

---

```
HealthBank/
├── README.md
├── CONTEXT.md                      # Project context summary
├── project_structure.md            # This file
├── project_plan.md
├── .gitignore
├── .env.example
├── requirements.txt                # Root Python dependencies
├── docker-compose.yml              # Docker orchestration (all services)
│
├── docs/                           # Documentation
│   ├── README.md                   # Documentation guide
│   ├── api/                        # API documentation
│   │   ├── surveys.md              # Survey endpoints
│   │   ├── question-bank.md        # Question bank endpoints
│   │   └── templates.md            # Template endpoints
│   ├── database/                   # Database documentation
│   │   ├── schema.md               # Full schema reference
│   │   ├── migrations.md           # Migration history
│   │   └── seed-data.md            # Seed data guide
│   ├── frontend/                   # Frontend documentation
│   │   ├── theme.md                # Theme colors & typography
│   │   ├── survey-builder.md       # Survey builder page
│   │   ├── question-bank.md        # Question bank UI
│   │   └── survey-widgets.md       # Question type widgets
│   ├── guides/                     # Setup & integration guides
│   │   ├── deployment.md           # Docker deployment guide
│   │   ├── email_service.md        # Email/SMTP configuration
│   │   └── 2fa-plan.md             # 2FA implementation
│   ├── assets/                     # Images & design exports
│   │   ├── figma/                  # Figma PNG exports
│   │   └── diagrams/               # Architecture diagrams
│   ├── templates/                  # Doc templates
│   │   ├── api-template.md
│   │   ├── database-template.md
│   │   └── frontend-template.md
│   └── internal/                   # INTERNAL (not for delivery)
│       ├── 01-scope.md             # Project scope
│       ├── 02-decisions.md         # Decision log
│       ├── 03-tasks.json           # Master task list
│       ├── architecture.md         # System architecture
│       └── Project_Plan.pdf        # Original plan
│
├── sprint_tracking/                # Sprint management
│   ├── HealthBank_Sprint_Tasks.csv
│   └── HealthBank_Sprint_Tasks.xlsx
│
├── scripts/github/                 # GitHub/Sprint management scripts
│   ├── import_sprint.sh            # Import sprint tasks to GitHub
│   ├── sprint2.tsv                 # Sprint 2 tasks
│   └── dev_map.tsv                 # Developer mapping
│
├── database/                       # Database management
│   ├── init/                       # Initial schema
│   ├── migrations/                 # Raw SQL migrations
│   ├── scripts/                    # Backup/restore scripts
│   └── backups/                    # Database backups
│
├── scripts/                        # Project-wide scripts
│   ├── run_tests.sh                # Unified test runner
│   └── seed_data.py                # Test data seeding
│
├── backend/                        # FastAPI Backend
│   ├── requirements.txt
│   ├── pytest.ini
│   │
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py                 # FastAPI app entry
│   │   │
│   │   ├── api/
│   │   │   └── v1/                 # API v1 routes (flat structure)
│   │   │       ├── auth.py         # Login, 2FA (PyOTP), logout
│   │   │       ├── users.py        # User endpoints
│   │   │       ├── surveys.py      # Survey endpoints
│   │   │       ├── question_bank.py # Question bank endpoints
│   │   │       └── templates.py    # Template endpoints
│   │   │
│   │   ├── services/               # Business logic
│   │   │   └── email/              # Email service
│   │   │       ├── base.py         # Abstract provider interface
│   │   │       ├── gmail.py        # Gmail SMTP implementation
│   │   │       ├── templates.py    # HTML/text email templates
│   │   │       └── service.py      # High-level email service
│   │   │
│   │   ├── middleware/
│   │   │   └── auth.py             # Auth middleware
│   │   │
│   │   └── utils/
│   │       └── utils.py            # get_db_connection() for MySQL
│   │
│   └── tests/                      # pytest tests
│       ├── conftest.py             # Fixtures
│       └── api/                    # API tests
│           └── test_*.py
│
├── nginx/                          # Nginx Web Server
│   ├── Dockerfile                  # Nginx Alpine image
│   ├── nginx.conf                  # SPA routing + API proxy config
│   └── ssl/                        # SSL certificates (production)
│
├── frontend/                       # Flutter Web App
│   ├── pubspec.yaml
│   ├── analysis_options.yaml
│   ├── Dockerfile                  # Flutter build (outputs to volume)
│   ├── .dockerignore
│   │
│   ├── web/                        # Web platform
│   │   ├── index.html
│   │   ├── manifest.json
│   │   └── icons/
│   │
│   ├── lib/                        # Dart source code
│   │   ├── main.dart               # App entry point
│   │   │
│   │   └── src/                    # All app code encapsulated here
│   │       │
│   │       ├── config/             # App configuration
│   │       │   ├── go_router.dart  # Route definitions & GoRouter setup
│   │       │   └── navigation.dart # Role-based navigation config
│   │       │
│   │       ├── core/               # Truly shared, app-wide utilities
│   │       │   ├── api/            # API client & models
│   │       │   │   ├── api.dart    # Barrel file
│   │       │   │   ├── models/     # Shared API models
│   │       │   │   └── services/   # API services (auth, etc.)
│   │       │   ├── theme/
│   │       │   │   └── theme.dart  # AppTheme (colors, typography)
│   │       │   ├── l10n/           # Localization/translation
│   │       │   │   ├── l10n.dart   # Barrel file
│   │       │   │   └── app_strings.dart  # All translatable strings
│   │       │   └── widgets/        # Generic, app-wide widgets ONLY
│   │       │       ├── widgets.dart      # Main barrel file
│   │       │       ├── basics/           # Basic components
│   │       │       │   ├── basics.dart   # Barrel file
│   │       │       │   ├── header.dart   # Global header with NavItem
│   │       │       │   ├── footer.dart   # Global footer
│   │       │       │   ├── dev_nav_button.dart  # Dev-only navigation
│   │       │       │   └── healthbank_logo.dart # Branded logo widget
│   │       │       ├── layout/           # Layout wrappers
│   │       │       │   ├── layout.dart   # Barrel file
│   │       │       │   └── base_scaffold.dart  # Base page wrapper
│   │       │       ├── data_display/     # Data display components
│   │       │       │   ├── data_display.dart   # Barrel file
│   │       │       │   └── data_table_cell.dart # Reusable table cells
│   │       │       ├── buttons/          # Button components (TODO)
│   │       │       ├── forms/            # Form components (TODO)
│   │       │       ├── feedback/         # Feedback components (TODO)
│   │       │       └── survey/           # Survey display components (TODO)
│   │       │
│   │       └── features/           # Feature modules (by role/domain)
│   │           │
│   │           ├── auth/           # Authentication (all roles)
│   │           │   ├── pages/      # login_page, forgot_password_page
│   │           │   ├── widgets/    # login_card, etc.
│   │           │   └── state/      # auth_provider.dart
│   │           │
│   │           ├── participant/    # Participant features
│   │           │   ├── pages/      # dashboard, surveys, results, tasks
│   │           │   ├── widgets/    # welcome_banner, task_card, graph_card, etc.
│   │           │   └── state/
│   │           │
│   │           ├── researcher/     # Researcher features
│   │           │   ├── pages/      # researcher_dashboard
│   │           │   ├── widgets/
│   │           │   └── state/
│   │           │
│   │           ├── surveys/        # Researcher: Survey creation/management
│   │           │   ├── pages/      # survey_list, survey_builder
│   │           │   ├── widgets/    # survey_card, question_editor
│   │           │   └── state/      # survey_provider.dart
│   │           │
│   │           ├── templates/      # Researcher: Survey templates
│   │           │   ├── pages/
│   │           │   ├── widgets/
│   │           │   └── state/
│   │           │
│   │           ├── question_bank/  # Researcher: Question bank
│   │           │   ├── pages/
│   │           │   ├── widgets/
│   │           │   └── state/
│   │           │
│   │           ├── hcp_clients/    # HCP: Dashboard, clients, reports
│   │           │   ├── pages/      # hcp_dashboard, client_list, reports
│   │           │   ├── widgets/
│   │           │   └── state/
│   │           │
│   │           └── admin/          # Admin features
│   │               ├── pages/      # admin_dashboard, user_management, tickets, audit_log
│   │               ├── widgets/    # admin_scaffold, admin_sidebar
│   │               └── state/      # user_providers.dart
│   │
│   ├── test/                       # Flutter unit/widget tests
│   │
│   └── integration_test/           # E2E tests
│
└── .claude/                        # Claude Code config
    ├── commands/
    └── agents/
```

---

## System Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              PRESENTATION TIER                               │
│  ┌───────────────────────────────────────────────────────────────────────┐  │
│  │                         Flutter Web Frontend                           │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │  │
│  │  │  Dashboard  │  │   Surveys   │  │   Reports   │  │    Admin    │  │  │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘  │  │
│  │  ┌───────────────────────────────────────────────────────────────┐   │  │
│  │  │   features/ | widgets/ | core/ | config/ (GoRouter, Theme)    │   │  │
│  │  └───────────────────────────────────────────────────────────────┘   │  │
│  └───────────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────┘
                                     │ HTTPS
                                     ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              PROXY LAYER (Nginx)                             │
│              SSL Termination | Load Balancing | SPA Routing                 │
└─────────────────────────────────────────────────────────────────────────────┘
                                     │
                                     ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              APPLICATION TIER                                │
│  ┌───────────────────────────────────────────────────────────────────────┐  │
│  │                        FastAPI Backend                                 │  │
│  │  API Layer:      /auth | /users | /surveys | /reports | /audit        │  │
│  │  Middleware:     Auth | Logging | Rate Limiting | CORS                 │  │
│  │  Services:       Business Logic | Email | TOTP/Auth                    │  │
│  │  Data Access:    Raw MySQL with Parameterized Queries                 │  │
│  └───────────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────┘
                                     │
                                     ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                                DATA TIER                                     │
│  ┌───────────────────────────────────────────────────────────────────────┐  │
│  │                          MySQL 8.0                                     │  │
│  │  users | surveys | questions | responses | answers | audit_logs       │  │
│  │  sessions | totp_secrets | tickets | hcp_patient_assignments          │  │
│  └───────────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Tech Stack

| Layer | Technology | Notes |
|-------|------------|-------|
| Frontend | Flutter Web (Dart 3.10+) | Feature-first architecture, Riverpod state |
| Backend | FastAPI (Python 3.11+) | REST API, async, auto OpenAPI docs |
| Database | MySQL 8.0 | Raw SQL with parameterized queries |
| Auth | bcrypt + PyOTP (TOTP 2FA) | Password hashing + authenticator app 2FA |
| Testing | pytest, flutter test, Playwright | Unit, widget, and E2E |
| Email | Gmail SMTP | App password, account/password emails |
| Deployment | Docker Compose + Nginx | SPA routing + API proxy |

---

## Security Architecture

| Layer | Implementation |
|-------|---------------|
| Transport Security | TLS 1.3, HTTPS only |
| Authentication | bcrypt + TOTP 2FA (PyOTP) |
| 2FA | QR code generation (qrcode lib) + TOTP verification |
| Authorization | Role-based access control (RBAC) |
| Input Validation | Pydantic schemas + sanitization |
| Session Management | Secure httponly cookies, 30min timeout |
| Rate Limiting | Per-endpoint + circuit breaker |
| Audit Logging | All actions tracked + anomaly flagging |
| Data Protection | Encryption at rest, 7-year retention |

---

## Frontend Architecture

### Pattern: Feature-First Architecture

The frontend uses **feature-first architecture** (industry standard for larger Flutter projects):

```
lib/
├── main.dart              # App entry point
└── src/                   # All app code encapsulated here
    ├── config/            # Routes (GoRouter), navigation config
    ├── core/              # Truly shared, app-wide utilities
    │   ├── api/           # API client, models, services
    │   ├── theme/         # AppTheme (colors, typography)
    │   ├── l10n/          # Localization (AppStrings)
    │   └── widgets/       # Generic widgets ONLY (organized by category)
    │       ├── basics/    # Header, Footer, DevNavButton, HealthBankLogo
    │       ├── layout/    # BaseScaffold
    │       ├── data_display/  # DataTableCell
    │       ├── buttons/   # (TODO)
    │       ├── forms/     # (TODO)
    │       ├── feedback/  # (TODO)
    │       └── survey/    # (TODO)
    └── features/          # Feature modules by domain/role
        ├── auth/          # Login, forgot password, request account
        ├── participant/   # Dashboard, surveys, results, tasks + widgets
        ├── researcher/    # Dashboard
        ├── surveys/       # Survey list, builder
        ├── templates/     # Template list, builder
        ├── question_bank/ # Question bank
        ├── hcp_clients/   # Dashboard, clients, reports
        └── admin/         # Dashboard, user management, tickets, logs
```

### Feature Module Structure

Each feature follows this pattern (no presentation wrapper needed):
```
features/<feature>/
├── pages/       # Screen widgets (*_page.dart)
├── widgets/     # Feature-specific widgets
└── state/       # Riverpod providers (*_provider.dart)
```

API calls are handled by `core/api/services/` - no feature-level `data/` folders needed.

### Where Do Widgets Go?

| Widget Type | Location | Example |
|-------------|----------|---------|
| **Generic/App-wide** | `core/widgets/<category>/` | Header, Footer, BaseScaffold, DataTableCell |
| **Feature-specific** | `features/<feature>/widgets/` | AdminSidebar, SurveyCard, WelcomeBanner |

**Rule**: If the name or logic mentions Admin, Participant, Survey, HCP, Researcher, etc., it belongs in that feature's `widgets/`, not in `core/widgets/`.

### Key Patterns

- **BaseScaffold**: Generic page wrapper with Header/Footer (in `core/widgets/layout/`)
- **AdminScaffold**: Admin-specific wrapper with sidebar (in `features/admin/widgets/`)
- **State management**: Riverpod providers co-located with features
- **Role-based navigation**: NavigationConfig provides nav items per UserRole
- **No top-level `lib/widgets/`**: Avoids the "junk drawer" antipattern
- **Each role has its own dashboard**: Dashboards live in their respective feature folders
- **Localization**: All user-facing text uses `AppStrings` (see [Localization Guide](docs/frontend/localization.md))

### Localization Pattern

All user-facing text is centralized in `core/l10n/app_strings.dart` to enable future translation:

```dart
// Import
import 'package:frontend/src/core/l10n/app_strings.dart';

// Usage
Text(AppStrings.common.submit)
Text(AppStrings.auth.loginButton)
Text(AppStrings.participant.welcomeMessage(userName))
```

**Rules:**
- Brand name "HealthBank" stays hardcoded (not translated)
- All other UI text goes through `AppStrings`
- Dynamic text uses methods: `welcomeMessage(String name) => 'Welcome, $name!'`
- New strings must be added to `app_strings.dart` before use

---

## Backend Architecture

### Pattern: Layered with Flat Routes

```
backend/app/
├── api/v1/           # Route handlers (flat: auth.py, surveys.py, etc.)
├── services/         # Business logic (email/, etc.)
├── middleware/       # Auth middleware
└── utils/            # Database connection (get_db_connection())
```

### Key Patterns

- **API versioning**: All endpoints under `/api/v1/`
- **Pydantic models**: Request/response validation inline in route files
- **Parameterized queries**: All SQL uses `%s` placeholders (no ORM)
- **Database migrations**: Raw SQL files in `database/migrations/`

---

## Testing Strategy

| Type | Tool | Location |
|------|------|----------|
| Backend Unit | pytest | `backend/tests/` |
| Frontend Unit/Widget | flutter test | `frontend/test/` |
| E2E | Playwright | `frontend/integration_test/` |

---

## Deployment

### Docker Compose Services

| Service | Port | Image |
|---------|------|-------|
| Nginx (frontend) | 3000 | nginx:alpine |
| API (backend) | 8000 | Python + uvicorn |
| MySQL | 3307 | mysql:8 |

### Access Points

- Frontend: http://localhost:3000
- API: http://localhost:8000
- MySQL: localhost:3307
