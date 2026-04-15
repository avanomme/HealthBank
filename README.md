# HealthBank — Researcher Health Data Bank

A secure, accessible, multi-platform web and mobile application for collecting, storing, and analyzing health and demographic data from research participants.

Built for CS-4820 at UPEI for Dr. Montelpare, School of Medicine.

---

## Overview

HealthBank enables researchers to design and publish structured surveys, collect participant health data over time, and export anonymized datasets for analysis. Participants track their own health metrics and compare them against k-anonymized aggregate data. Healthcare providers can access linked patient data. Administrators manage accounts, audit logs, system settings, and database maintenance.

The application runs as a responsive web app and is deployable to Android and iOS from a single Flutter codebase. It is fully localized in English, French, and Spanish, and meets WCAG 2.1/2.2 AA accessibility standards.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter 3 (Dart) — web, Android, iOS |
| State Management | Riverpod 2.5 |
| Routing | GoRouter 14 |
| Backend | Python 3.11, FastAPI |
| Database | MySQL 8 |
| Infrastructure | Docker Compose, Nginx |
| Localization | flutter gen-l10n (EN, FR, ES) |
| Accessibility | WCAG 2.1/2.2 AA (55 criteria, all fulfilled) |
| Authentication | PBKDF2-SHA256, TOTP 2FA, HttpOnly session cookies |
| Anonymization | K-anonymity (k=5), SHA-256 participant ID hashing |

### Frontend Libraries

| Library | Purpose |
|---|---|
| `flutter_riverpod` | State management |
| `go_router` | Declarative routing |
| `retrofit` + `dio` | Type-safe API client |
| `freezed` + `json_serializable` | Immutable models + JSON |
| `fl_chart` | Charts and graphs |
| `shared_preferences` | Locale + UI preferences only |

### Backend Libraries

| Library | Purpose |
|---|---|
| `fastapi` | REST API framework |
| `mysql-connector-python` | Database driver |
| `pyotp` | TOTP two-factor authentication |
| `bleach` | Input sanitization |
| `python-dotenv` | Environment configuration |

---

## User Roles

| Role ID | Role | Access |
|---|---|---|
| 1 | **Participant** | Dashboard, assigned surveys, draft/submit responses, personal results, compare to aggregate |
| 2 | **Researcher** | Survey builder, template bank, question bank, publish surveys, aggregate reports, CSV export |
| 3 | **HCP** | Link to consented patients, view patient survey data, in-app messaging |
| 4 | **Admin** | User management, account approvals, audit log, system settings, database viewer, all of the above |

---

## Project Structure

```
HealthBank/
├── frontend/                        # Flutter application (web + mobile)
│   └── lib/src/
│       ├── core/
│       │   ├── api/                 # Retrofit services, Dio client, API models
│       │   ├── l10n/arb/            # Localization strings (app_en.arb, app_fr.arb, app_es.arb)
│       │   ├── state/               # Riverpod providers (auth, cookie consent, locale, etc.)
│       │   ├── theme/               # AppTheme, colors, typography
│       │   └── widgets/             # Reusable UI components (buttons, forms, layout, basics)
│       ├── features/
│       │   ├── admin/               # Admin dashboard, user management, audit log, database viewer
│       │   ├── auth/                # Login, 2FA, password reset, session expiry monitor
│       │   ├── hcp_clients/         # HCP patient management
│       │   ├── messaging/           # In-app messaging (HCP ↔ participant)
│       │   ├── participant/         # Participant dashboard, results, progress tracking
│       │   ├── question_bank/       # Reusable question library
│       │   ├── researcher/          # Researcher dashboard, data export
│       │   ├── surveys/             # Survey builder, survey response flow
│       │   └── templates/           # Survey template builder
│       └── config/                  # GoRouter, environment config
├── backend/
│   └── app/
│       ├── api/v1/                  # REST endpoints (see API section below)
│       ├── utils/                   # DB connection, sanitization, email, helpers
│       └── main.py                  # FastAPI app entrypoint
├── database/
│   └── init/                        # MySQL schema (create_database.sql) + seed data
├── nginx/                           # Reverse proxy config
├── docs/                            # Project documentation, WCAG checklist, testing logs
├── tools/                           # Dev utilities (WCAG audit scripts, test parser)
├── env/                             # Environment files (not in git — see setup below)
├── Makefile                         # All development and deployment commands
└── docker-compose.yml               # Full stack: MySQL + API + Frontend + Nginx
```

---

## Getting Started

### Prerequisites

- Docker & Docker Compose
- Make
- Flutter SDK 3+ with Dart (for local frontend development)
- Python 3.11+ with `uv` (for backend development)

### Environment Setup

Copy the example env files and fill in your values:

```bash
cp env/api.env.example env/api.env
cp env/db.env.example env/db.env
```

Key variables in `env/api.env`:

```
DB_HOST=db
DB_NAME=healthbank
DB_USER=...
DB_PASSWORD=...
SECRET_KEY=...                   # Session token signing key
SMTP_HOST=...                    # Email service for account notifications
CURRENT_CONSENT_VERSION=1        # Consent document version
```

### Quick Start (Docker)

```bash
# Build and start all services (MySQL, API, Frontend, Nginx)
make build
make up

# Wait for API to be ready
make wait-api

# Application is available at:
# Web:      http://localhost:3000
# API:      http://localhost:8000
# API Docs: http://localhost:8000/docs
```

### Local Frontend Development (Fastest)

```bash
# Start backend only (MySQL + API)
make docker-back

# Run Flutter with hot reload against local backend
make flutter

# Or run against the UPEI server
make flutter-server
```

---

## Make Commands

### Docker / Server

| Command | Description |
|---|---|
| `make up` | Start all containers |
| `make build` | Build Docker images |
| `make up-build` | Build images and start containers |
| `make down` | Stop and remove containers |
| `make logs` | Follow API logs |
| `make front` | Hot-swap Flutter build into running nginx (~45s) |
| `make deploy` | Build Flutter locally and rsync to UPEI server |
| `make deploy-api` | Push backend changes to server and restart API |
| `make api` | Rebuild API container only |
| `make nginx` | Rebuild nginx config only |
| `make docker` | Smart rebuild — only changed services |
| `make docker-new` | Full rebuild with fresh DB |
| `make docker-purge` | Wipe everything including image caches |

### Database

| Command | Description |
|---|---|
| `make db` | Recreate and reseed the database |
| `make db-seed` | Reseed with test data (drops existing data) |
| `make db-reset` | Reset schema only (no seed data) |
| `make db-migrate` | Run pending SQL migrations (local) |
| `make db-migrate-remote` | Run pending SQL migrations (UPEI server via SSH) |
| `make db-nuke` | Full database wipe and restart |

### Testing

| Command | Description |
|---|---|
| `make test` | Run all tests (backend + frontend) |
| `make test-backend` | Backend pytest only |
| `make test-frontend` | Frontend Flutter tests (failures + summary) |
| `make test-file FILE=path` | Run a single test file |

### Mobile

| Command | Description |
|---|---|
| `make android` | Build Android release APK → UPEI server |
| `make phone` | Install release APK on connected Android device |
| `make android-dev` | Run Flutter debug on Android → UPEI server |
| `make android-local` | Run Flutter debug on Android → local Docker |
| `make ios` | Build iOS release → UPEI server |
| `make iPhone` | Install iOS build on connected iPhone |
| `make iPad` | Install iOS build on connected iPad |
| `make ios-dev` | Run Flutter on iOS device/simulator → UPEI server |
| `make ios-local` | Run Flutter on iOS simulator → local Docker |

---

## API Endpoints

All routes are under `/api/v1/`. Authentication is required for all routes except `/auth/login`.

| Route | Description |
|---|---|
| `/auth` | Login, logout, 2FA verify, password reset |
| `/sessions` | Session info, refresh, expiry |
| `/users` | User CRUD (admin only) |
| `/surveys` | Survey CRUD, publish, assign |
| `/responses` | Submit and retrieve survey responses |
| `/assignments` | Assign surveys to participants |
| `/templates` | Survey template builder |
| `/question_bank` | Reusable question library |
| `/research` | Aggregate data, CSV export (researcher) |
| `/participants` | Participant management |
| `/hcp_links` | HCP ↔ participant link requests |
| `/hcp_patients` | HCP view of linked patient data |
| `/messaging` | In-app messaging |
| `/consent` | Consent record management |
| `/tos` | Terms of service |
| `/two_factor` | 2FA setup and management |
| `/admin` | Settings, audit log, database viewer |

Interactive API documentation: `http://localhost:8000/docs`

---

## Security

- **Authentication**: PBKDF2-SHA256 password hashing, TOTP 2FA, SHA-256 hashed session tokens
- **Session storage**: HttpOnly `SameSite=Strict` cookies (web); in-memory Bearer token (mobile)
- **Role-based access**: `require_role()` dependency on all routes; admin (RoleID=4) always exempt
- **SQL injection**: All queries use `%s` parameterized placeholders — no f-strings with user data
- **Input sanitization**: All user text fields validated with `sanitized_string()` (bleach-backed) in Pydantic models
- **K-anonymity**: Aggregate data requires minimum k=5 participants; participant IDs are SHA-256 hashed before inclusion
- **Account lockout**: Failed login attempts counted and rate-limited; accounts locked after configured maximum
- **Audit log**: Every meaningful action is recorded with actor, timestamp, IP, and action detail

---

## Accessibility

The application meets all 55 WCAG 2.1/2.2 Level A and AA success criteria, including:

- All interactive elements keyboard-accessible (no `GestureDetector` for interactive targets)
- Screen reader support: semantic labels, live regions, focus management
- Focus trap in overlays/modals (`FocusTraversalGroup` + `FocusScope`)
- Skip-to-main-content for keyboard users
- Visible focus ring on all interactive elements
- Non-text contrast ≥ 3:1 for input borders and icons
- All charts have accessible data table fallbacks
- Session expiry warning dialog (WCAG 2.2.1 — Timing Adjustable)
- Cookie banner does not obscure focused content (WCAG 2.4.11)
- Keyboard alternatives for reorderable lists (WCAG 2.5.7)
- Fully localized in English, French, and Spanish (1,768 string keys per locale)

---

## Testing

```bash
# Run full test suite
make test-frontend   # 1822 Flutter widget/unit tests
make test-backend    # pytest — backend API + unit tests
```

Test results are logged to `docs/testing/Testing_Log.xlsx` and `docs/testing/Adam_Testing_Log.csv`.

---

## Team

**CS-4820 — University of Prince Edward Island, April 2026**

| Name | Role |
|---|---|
| Adam Joseph Van Omme | Project Lead / Full-Stack Developer |
| Camryn Fairbanks | Technical Lead / Full-Stack Developer |
| Robert Bryan-Gilmore | Communications Lead / Developer |
| Shaun Lee | Developer |
| Allan Harris | Developer |

**Client:** Dr. Montelpare, School of Medicine, UPEI
**Course Instructor:** Professor David LeBlanc
