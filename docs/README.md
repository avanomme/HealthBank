# HealthBank Documentation

> **Goal:** Any developer should be able to understand, maintain, and extend this system without contacting original developers.

## Documentation Structure

```
docs/
├── README.md                         # This file - documentation guide
│
├── api/                              # Backend API endpoint reference
│   ├── hcp_endpoints.md              # HCP links + patient access endpoints
│   ├── health_tracking_endpoints.md  # Health tracking endpoints (all roles)
│   └── messaging_endpoints.md        # Messaging system endpoints
│
├── database/                         # Database documentation
│   ├── schema.md                     # Full database schema (all tables)
│   ├── migrations.md                 # Migration history and guide
│   └── seed-data.md                  # Seed data documentation
│
├── frontend/                         # Frontend documentation
│   ├── theme.md                      # App theme colors and typography
│   ├── localization.md               # Localization/translation guide
│   ├── survey-builder.md             # Survey builder page
│   ├── question-bank.md              # Question bank UI
│   ├── survey-widgets.md             # Question type widgets
│   ├── health-tracking.md            # Health tracking feature (all roles)
│   ├── research-data.md              # Researcher survey aggregates + HT research
│   ├── admin-pages.md                # Admin pages including HT settings, backup, settings
│   └── ...
│
├── backend/App/api/V1/               # Backend implementation docs
│   ├── Admin.md                      # Admin API (+ backup/restore + system settings)
│   ├── health_tracking.md            # Health Tracking API implementation
│   └── ...
│
├── guides/                           # Setup and integration guides
│   ├── deployment.md                 # Docker deployment guide
│   ├── email_service.md              # Email/SMTP configuration
│   ├── 2fa-plan.md                   # 2FA implementation details
│   └── 2FA Flowchart.pdf             # 2FA visual flowchart
│
├── templates/                        # Documentation templates
│   ├── api-template.md               # Template for API docs
│   ├── database-template.md          # Template for DB docs
│   └── frontend-template.md          # Template for frontend docs
│
└── internal/                         # INTERNAL ONLY - Not for delivery
    ├── 01-scope.md                   # Project scope (dev reference)
    ├── 02-decisions.md               # Decision log (dev reference)
    ├── 03-tasks.json                 # Master task list
    ├── architecture.md               # System architecture (dev reference)
    ├── Project_Plan.pdf              # Original project plan
    └── archived-ci/                  # Archived CI/CD configs
```

## Quick Links

### For Developers
- [Deployment Guide](./guides/deployment.md) - Docker setup and deployment
- [Theme & Styling](./frontend/theme.md)
- [Localization Guide](./frontend/localization.md) - Adding translatable strings
- [Email Service Setup](./guides/email_service.md)
- [2FA Implementation](./guides/2fa-plan.md)
- [Health Tracking API](./api/health_tracking_endpoints.md) - All HT endpoints
- [Health Tracking Frontend](./frontend/health-tracking.md) - Flutter feature docs
- [Database Schema](./database/schema.md) - All tables including new HT + Settings tables

### For Admins
- [Deployment Guide](./guides/deployment.md) - Docker setup and deployment
- [Database Schema](./database/schema.md)
- [Admin Pages](./frontend/admin-pages.md) - Health Tracking settings, backup, system settings
- Database Migrations (coming soon)
- Seed Data Guide (coming soon)

## Documentation Standards

### Every Feature Must Document

1. **What it does** - Purpose and functionality
2. **How to use it** - Step-by-step instructions
3. **How to configure it** - Environment variables, settings
4. **How to troubleshoot it** - Common issues and solutions
5. **How to extend it** - For future developers

### When to Create/Update Docs

| Event | Action |
|-------|--------|
| New API endpoint | Create/update `docs/api/[feature].md` |
| Database change | Update `docs/database/schema.md` |
| New migration | Add to `docs/database/migrations.md` |
| New frontend page | Create `docs/frontend/[feature].md` |
| Architecture decision | Add to `docs/internal/02-decisions.md` |

### Documentation Checklist

Before marking a task complete:
- [ ] Code examples are tested and work
- [ ] All endpoints have request/response examples
- [ ] Error scenarios are documented
- [ ] Related docs are cross-linked
- [ ] A new developer could follow the docs

## Using Templates

Templates are in `docs/templates/`. Copy and customize:

```bash
# For a new API doc
cp docs/templates/api-template.md docs/api/new-feature.md

# For a new database doc
cp docs/templates/database-template.md docs/database/new-feature.md

# For a new frontend doc
cp docs/templates/frontend-template.md docs/frontend/new-feature.md
```

## Internal Documentation

The `docs/internal/` folder contains development-only documents:
- **NOT included in final delivery**
- Used for project management and decision tracking
- Contains task lists, architecture decisions, original scope

## Task Integration

Every task in `.claude/tasks.json` has a `docs` field listing required documentation:

```json
{
  "id": "S2-034",
  "title": "Implement POST /api/surveys",
  "docs": ["docs/api/surveys.md"],
  "acceptance": "... API docs complete with request/response examples"
}
```

The task is **not complete** until documentation is created/updated.
