# HealthBank API — `backend/app/main.py`

## Overview

`backend/app/main.py` is the FastAPI application entrypoint for the HealthBank backend. It:

- Creates the FastAPI app instance and attaches middleware.
- Optionally enables CORS for local development based on environment configuration.
- Initializes database structure on application startup.
- Registers all versioned API routers under `/api/v1/*`.
- Exposes a small set of root-level system and developer utility endpoints:
  - `GET /health`
  - `GET /me`
  - `POST /seed_data`
  - `POST /init_db_structure`

This file is primarily responsible for wiring and bootstrapping, not implementing business logic.

---

## Architecture / Design Explanation

### Application Initialization

- The app is created with FastAPI metadata:
  - `title="HealthBank API"`
  - `version="1.0.0"`

- A request-auditing middleware is added globally:
  - `AuditEveryRequestToAuditEventMiddleware`

This suggests an audit/event logging layer that captures every request and emits an audit event, likely for compliance and traceability.

### Startup Hook for Database Structure

A startup event handler runs:

- `utils.init_db_structure()`

A comment indicates a previous approach caused race conditions when called at import time, and was moved to the startup event for reliability.

### Router Registration Strategy

Each functional area is split into its own router module under `app.api.v1`. Routers are mounted with:

- A versioned URL prefix (mostly `/api/v1/<area>`)
- Tags to group endpoints in OpenAPI docs

This keeps API surface modular and discoverable in docs and facilitates versioning.

### CORS Handling

CORS is enabled only when the `CORS_ORIGINS` environment variable is set. There is special handling for `*`:

- If `CORS_ORIGINS="*"`, `allow_origin_regex=".*"` is used so that credentials can still be enabled.
- Otherwise, `CORS_ORIGINS` is treated as a comma-separated allowlist.

This is intended for local Flutter development and is explicitly marked as not for production.

---

## Configuration (if applicable)

### Environment Variables

#### `CORS_ORIGINS`

Controls whether CORS middleware is enabled and which origins are allowed.

- If unset or empty: CORS middleware is not added.
- If set to `"*"`: all origins are matched via regex, compatible with credentials.
- If set to a comma-separated list: each origin is added to `allow_origins`.

Examples:

- Allow a local web frontend:
  - `CORS_ORIGINS=http://localhost:3000`

- Allow multiple origins:
  - `CORS_ORIGINS=http://localhost:3000,http://localhost:5173`

- Allow all origins (with origin reflection):
  - `CORS_ORIGINS=*`

CORS middleware is configured with:

- `allow_credentials=True`
- `allow_methods=["*"]`
- `allow_headers=["*"]`

---

## API Reference

### System Endpoints

#### `GET /health`

Health check endpoint.

- Tags: `["system"]`
- Returns a simple status payload.

**Response**
- `200 OK`

```json
{ "status": "ok" }