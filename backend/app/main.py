# Created with the Assistance of Claude Code
# backend/app/main.py
"""
HealthBank FastAPI application entry point.

Configures middleware (CORS, audit logging, maintenance mode), registers
all API routers under /api/v1, and exposes a /health liveness probe.
Database structure is initialised on startup via utils.init_db_structure().
"""
import os
from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from app.middleware.audit_to_auditevent import AuditEveryRequestToAuditEventMiddleware
from app.middleware.maintenance import MaintenanceModeMiddleware
from app.api.v1 import auth, users, question_bank, surveys, assignments, templates, sessions, admin, two_factor, tos, research, responses, participants, consent, hcp_links, hcp_patients, messaging, health_tracking
from app.utils import utils
from app.api.deps import require_tos_accepted, require_role

app = FastAPI(
    title="HealthBank API",
    version="1.0.0",
    #redirect_slashes=False, # uncomment if we're having more issues with CORS and trailing slashes
)
app.add_middleware(AuditEveryRequestToAuditEventMiddleware)
app.add_middleware(MaintenanceModeMiddleware)

# TODO: Remove in production - CORS for local Flutter development
# Enable CORS when CORS_ORIGINS env var is set (e.g., "http://localhost:3000")
cors_origins_raw = os.getenv("CORS_ORIGINS", "")
if cors_origins_raw:  # pragma: no cover — runs at import time, tested via test_main.py CORS tests
    cors_kwargs: dict = {
        "allow_methods": ["*"],
        "allow_headers": ["*"],
    }
    if cors_origins_raw.strip() == "*":
        cors_kwargs["allow_origins"] = ["*"]
        cors_kwargs["allow_credentials"] = False
    elif cors_origins_raw.strip() == "localhost":
        # Dev mode: allow any localhost port with credentials
        cors_kwargs["allow_origin_regex"] = r"^https?://(localhost|127\.0\.0\.1)(:\d+)?$"
        cors_kwargs["allow_credentials"] = True
    else:
        cors_kwargs["allow_origins"] = [o.strip() for o in cors_origins_raw.split(",")]
        cors_kwargs["allow_credentials"] = True
    app.add_middleware(CORSMiddleware, **cors_kwargs)

# Causing Race condition, sometimes working other times launch fails
# utils.init_db_structure()
# Fix switched to startup event and modified /backend/utils/utils.py
@app.on_event("startup")
def startup_event():
    utils.init_db_structure()

# Router registration = app wiring
app.include_router(auth.router, prefix="/api/v1/auth", tags=["auth"])
app.include_router(users.self_router, prefix="/api/v1/users", tags=["users"])
app.include_router(users.router, prefix="/api/v1/users", tags=["users"])
app.include_router(two_factor.router, prefix="/api/v1/2fa", tags=["2fa"])
app.include_router(sessions.router, prefix="/api/v1/sessions", tags=["sessions"])
app.include_router(participants.router, prefix="/api/v1/participants", tags=["participants"])
app.include_router(question_bank.router, prefix="/api/v1/questions", tags=["questions"])
app.include_router(surveys.router, prefix="/api/v1/surveys", tags=["surveys"])
app.include_router(assignments.survey_router, prefix="/api/v1/surveys", tags=["assignments"])
app.include_router(assignments.router, prefix="/api/v1/assignments", tags=["assignments"])
app.include_router(templates.router, prefix="/api/v1/templates", tags=["templates"])
app.include_router(admin.router, prefix="/api/v1/admin", tags=["admin"])
app.include_router(tos.router, prefix="/api/v1/tos", tags=["tos"])
app.include_router(research.router, prefix="/api/v1/research", tags=["research"])
app.include_router(responses.router, prefix="/api/v1/responses", tags=["responses"])
app.include_router(consent.router, prefix="/api/v1/consent", tags=["consent"])
app.include_router(hcp_links.router, prefix="/api/v1/hcp-links", tags=["hcp-links"])
app.include_router(hcp_patients.router, prefix="/api/v1")
app.include_router(messaging.router, prefix="/api/v1")
app.include_router(health_tracking.router, prefix="/api/v1/health-tracking", tags=["health-tracking"])


@app.get("/health", tags=["system"])
def health_check():
    return {"status": "ok"}

@app.get("/me")
async def me(user=Depends(require_tos_accepted)):
    return {
        "account_id": user["account_id"],
        "email": user["email"],
    }

@app.post("/seed_data", dependencies=[Depends(require_role(4))])
async def seed_data():
    utils.create_seed_data()
    return {
        "message": "attempt to put seed data in database. likely to create duplicates if data already exists"
    }


@app.post("/init_db_structure", dependencies=[Depends(require_role(4))])
async def init_db_structure():
    utils.init_db_structure()
    return {
        "message": "attempt to init database structure..."
    }