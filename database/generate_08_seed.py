#!/usr/bin/env python3
"""
Generate 08_health_tracking_all_participants_seed.sql
Seeds health tracking entries for all participants that don't have data yet.
Participants 13–18 already have data in files 05 and 07 — skip them.
"""

import math

OUTPUT = "init/08_health_tracking_all_participants_seed.sql"

# Monthly snapshot dates (1st of each month, representing monthly check-ins)
MONTHLY_DATES = [
    "2024-05-01", "2024-07-01", "2024-09-01", "2024-11-01",
    "2025-01-01", "2025-03-01", "2025-05-01", "2025-07-01", "2025-09-01",
]
BASELINE_DATE = "2025-10-01"
RECENT_DATES  = ["2025-11-01", "2025-11-15"]

# ─── Participant profiles ──────────────────────────────────────────────────────
# Each profile defines values at start (2024-05) and end (2025-09), linearly
# interpolated for intermediate dates, plus baseline and housing/income arcs.
#
# Trajectory fields (all interpolated start→end unless listed per-date):
#   health, sleep_hrs, sleep_q, pain, mood, anxiety, stress, safety,
#   meals, food_access, water, energy, exercise
# Categorical fields:
#   housing_arc  — list of 9 values matching MONTHLY_DATES
#   income_arc   — list of 9 values
#   medications  — yes/no (stable)
#   smoking      — yes/no (stable)
#   drug_use     — yes/no (stable)

profiles = [
    # ── ID 2: part@hb.com — test participant, strong improvement arc ───────────
    {
        "pid": 2, "label": "Participant User (part@hb.com)",
        "start": dict(health=4, sleep_hrs=5.5, sleep_q=3, pain=6, mood=2, anxiety=8,
                      stress=8, safety=2, meals=2, food_access=2, water=4,
                      energy=3, exercise=0),
        "end":   dict(health=8, sleep_hrs=7.5, sleep_q=8, pain=2, mood=4, anxiety=3,
                      stress=3, safety=5, meals=3, food_access=5, water=8,
                      energy=8, exercise=30),
        "baseline": dict(health=8, sleep_hrs=7.5, sleep_q=8, pain=2, mood=4, anxiety=3,
                         stress=3, safety=5, meals=3, food_access=5, water=8,
                         energy=8, exercise=30,
                         housing_status="Permanent Housing", housing_security=8,
                         days_housed=365, income_source="Government Benefits",
                         afford_essentials=4, social_interactions=6, support_access=4,
                         hopefulness=5, goal_progress=7, self_improvement=8,
                         doctor_visit="no", missed_appointment="no",
                         medication_access="yes"),
        "housing_arc":  ["shelter","shelter","transitional","transitional","transitional",
                         "permanent","permanent","permanent","permanent"],
        "income_arc":   ["none","none","benefits","benefits","benefits",
                         "benefits","benefits","employment","employment"],
        "medications":  "yes", "smoking": "no", "drug_use": "no",
    },

    # ── ID 19: William Thomas — moderate improvement ───────────────────────────
    {
        "pid": 19, "label": "William Thomas",
        "start": dict(health=5, sleep_hrs=6.0, sleep_q=4, pain=4, mood=3, anxiety=6,
                      stress=6, safety=3, meals=2, food_access=3, water=5,
                      energy=4, exercise=10),
        "end":   dict(health=7, sleep_hrs=7.0, sleep_q=7, pain=2, mood=4, anxiety=4,
                      stress=4, safety=4, meals=3, food_access=4, water=7,
                      energy=6, exercise=20),
        "baseline": dict(health=7, sleep_hrs=7.0, sleep_q=7, pain=2, mood=4, anxiety=4,
                         stress=4, safety=4, meals=3, food_access=4, water=7,
                         energy=6, exercise=20,
                         housing_status="Transitional Housing", housing_security=7,
                         days_housed=180, income_source="Government Benefits",
                         afford_essentials=3, social_interactions=4, support_access=3,
                         hopefulness=4, goal_progress=6, self_improvement=6,
                         doctor_visit="no", missed_appointment="no",
                         medication_access="yes"),
        "housing_arc":  ["transitional","transitional","transitional","transitional","transitional",
                         "transitional","permanent","permanent","permanent"],
        "income_arc":   ["none","benefits","benefits","benefits","benefits",
                         "benefits","benefits","benefits","employment"],
        "medications":  "no", "smoking": "yes", "drug_use": "no",
    },

    # ── ID 20: Elizabeth Hernandez — stable, already doing well ───────────────
    {
        "pid": 20, "label": "Elizabeth Hernandez",
        "start": dict(health=6, sleep_hrs=6.5, sleep_q=6, pain=3, mood=3, anxiety=5,
                      stress=5, safety=4, meals=3, food_access=4, water=6,
                      energy=5, exercise=15),
        "end":   dict(health=8, sleep_hrs=7.5, sleep_q=8, pain=2, mood=4, anxiety=3,
                      stress=3, safety=5, meals=3, food_access=5, water=8,
                      energy=7, exercise=25),
        "baseline": dict(health=8, sleep_hrs=7.5, sleep_q=8, pain=2, mood=5, anxiety=3,
                         stress=3, safety=5, meals=3, food_access=5, water=8,
                         energy=7, exercise=25,
                         housing_status="Permanent Housing", housing_security=9,
                         days_housed=400, income_source="Employment",
                         afford_essentials=5, social_interactions=7, support_access=5,
                         hopefulness=5, goal_progress=8, self_improvement=8,
                         doctor_visit="no", missed_appointment="no",
                         medication_access="yes"),
        "housing_arc":  ["transitional","transitional","permanent","permanent","permanent",
                         "permanent","permanent","permanent","permanent"],
        "income_arc":   ["benefits","benefits","benefits","employment","employment",
                         "employment","employment","employment","employment"],
        "medications":  "yes", "smoking": "no", "drug_use": "no",
    },

    # ── ID 21: David Moore — rock bottom to recovery ──────────────────────────
    {
        "pid": 21, "label": "David Moore",
        "start": dict(health=2, sleep_hrs=4.0, sleep_q=2, pain=8, mood=1, anxiety=9,
                      stress=9, safety=1, meals=1, food_access=1, water=3,
                      energy=2, exercise=0),
        "end":   dict(health=7, sleep_hrs=7.0, sleep_q=7, pain=3, mood=4, anxiety=3,
                      stress=3, safety=4, meals=3, food_access=4, water=7,
                      energy=7, exercise=20),
        "baseline": dict(health=7, sleep_hrs=7.0, sleep_q=7, pain=3, mood=4, anxiety=3,
                         stress=3, safety=4, meals=3, food_access=4, water=7,
                         energy=7, exercise=20,
                         housing_status="Permanent Housing", housing_security=7,
                         days_housed=200, income_source="Government Benefits",
                         afford_essentials=3, social_interactions=4, support_access=4,
                         hopefulness=4, goal_progress=6, self_improvement=7,
                         doctor_visit="yes", missed_appointment="no",
                         medication_access="yes"),
        "housing_arc":  ["none","shelter","shelter","transitional","transitional",
                         "transitional","permanent","permanent","permanent"],
        "income_arc":   ["none","none","none","none","benefits",
                         "benefits","benefits","benefits","benefits"],
        "medications":  "no", "smoking": "yes", "drug_use": "yes",
    },

    # ── ID 22: Jennifer Jackson — positive, quick to improve ──────────────────
    {
        "pid": 22, "label": "Jennifer Jackson",
        "start": dict(health=5, sleep_hrs=6.0, sleep_q=5, pain=3, mood=3, anxiety=6,
                      stress=6, safety=3, meals=2, food_access=3, water=5,
                      energy=4, exercise=10),
        "end":   dict(health=9, sleep_hrs=8.0, sleep_q=9, pain=1, mood=5, anxiety=2,
                      stress=2, safety=5, meals=3, food_access=5, water=9,
                      energy=9, exercise=45),
        "baseline": dict(health=9, sleep_hrs=8.0, sleep_q=9, pain=1, mood=5, anxiety=2,
                         stress=2, safety=5, meals=3, food_access=5, water=9,
                         energy=9, exercise=45,
                         housing_status="Permanent Housing", housing_security=10,
                         days_housed=500, income_source="Employment",
                         afford_essentials=5, social_interactions=9, support_access=5,
                         hopefulness=5, goal_progress=9, self_improvement=9,
                         doctor_visit="no", missed_appointment="no",
                         medication_access="yes"),
        "housing_arc":  ["transitional","permanent","permanent","permanent","permanent",
                         "permanent","permanent","permanent","permanent"],
        "income_arc":   ["benefits","benefits","employment","employment","employment",
                         "employment","employment","employment","employment"],
        "medications":  "no", "smoking": "no", "drug_use": "no",
    },

    # ── ID 24: Susan Lee — sporadic tracker, shelter background ──────────────
    {
        "pid": 24, "label": "Susan Lee",
        "start": dict(health=4, sleep_hrs=5.0, sleep_q=3, pain=5, mood=2, anxiety=7,
                      stress=7, safety=2, meals=2, food_access=2, water=4,
                      energy=3, exercise=0),
        "end":   dict(health=6, sleep_hrs=6.5, sleep_q=5, pain=4, mood=3, anxiety=5,
                      stress=5, safety=3, meals=2, food_access=3, water=5,
                      energy=5, exercise=10),
        "baseline": dict(health=6, sleep_hrs=6.5, sleep_q=5, pain=4, mood=3, anxiety=5,
                         stress=5, safety=3, meals=2, food_access=3, water=5,
                         energy=5, exercise=10,
                         housing_status="Transitional Housing", housing_security=5,
                         days_housed=90, income_source="Government Benefits",
                         afford_essentials=2, social_interactions=2, support_access=2,
                         hopefulness=3, goal_progress=4, self_improvement=4,
                         doctor_visit="no", missed_appointment="yes",
                         medication_access="no"),
        "housing_arc":  ["shelter","shelter","shelter","transitional","transitional",
                         "transitional","transitional","transitional","transitional"],
        "income_arc":   ["none","none","none","benefits","benefits",
                         "benefits","benefits","benefits","benefits"],
        "medications":  "yes", "smoking": "yes", "drug_use": "no",
        "sparse": True,  # only 4 of 9 monthly dates
    },

    # ── ID 25: Joseph Perez — rapid improvement, already housed ───────────────
    {
        "pid": 25, "label": "Joseph Perez",
        "start": dict(health=6, sleep_hrs=6.5, sleep_q=6, pain=2, mood=3, anxiety=5,
                      stress=5, safety=4, meals=3, food_access=4, water=6,
                      energy=5, exercise=20),
        "end":   dict(health=9, sleep_hrs=8.0, sleep_q=9, pain=1, mood=5, anxiety=2,
                      stress=2, safety=5, meals=3, food_access=5, water=9,
                      energy=9, exercise=45),
        "baseline": dict(health=9, sleep_hrs=8.0, sleep_q=9, pain=1, mood=5, anxiety=2,
                         stress=2, safety=5, meals=3, food_access=5, water=9,
                         energy=9, exercise=45,
                         housing_status="Permanent Housing", housing_security=9,
                         days_housed=600, income_source="Employment",
                         afford_essentials=5, social_interactions=8, support_access=5,
                         hopefulness=5, goal_progress=9, self_improvement=9,
                         doctor_visit="no", missed_appointment="no",
                         medication_access="yes"),
        "housing_arc":  ["permanent","permanent","permanent","permanent","permanent",
                         "permanent","permanent","permanent","permanent"],
        "income_arc":   ["benefits","benefits","employment","employment","employment",
                         "employment","employment","employment","employment"],
        "medications":  "no", "smoking": "no", "drug_use": "no",
    },

    # ── ID 26: Margaret White — elderly, chronic health issues ────────────────
    {
        "pid": 26, "label": "Margaret White",
        "start": dict(health=4, sleep_hrs=5.5, sleep_q=4, pain=7, mood=3, anxiety=6,
                      stress=5, safety=3, meals=2, food_access=3, water=5,
                      energy=3, exercise=5),
        "end":   dict(health=6, sleep_hrs=6.5, sleep_q=6, pain=5, mood=4, anxiety=4,
                      stress=4, safety=4, meals=3, food_access=4, water=6,
                      energy=5, exercise=10),
        "baseline": dict(health=6, sleep_hrs=6.5, sleep_q=6, pain=5, mood=4, anxiety=4,
                         stress=4, safety=4, meals=3, food_access=4, water=6,
                         energy=5, exercise=10,
                         housing_status="Permanent Housing", housing_security=7,
                         days_housed=300, income_source="Government Benefits",
                         afford_essentials=3, social_interactions=3, support_access=3,
                         hopefulness=3, goal_progress=5, self_improvement=5,
                         doctor_visit="yes", missed_appointment="no",
                         medication_access="yes"),
        "housing_arc":  ["transitional","transitional","transitional","permanent","permanent",
                         "permanent","permanent","permanent","permanent"],
        "income_arc":   ["benefits","benefits","benefits","benefits","benefits",
                         "benefits","benefits","benefits","benefits"],
        "medications":  "yes", "smoking": "no", "drug_use": "no",
    },

    # ── ID 27: Charles Harris — consistent tracker, steady improvement ─────────
    {
        "pid": 27, "label": "Charles Harris",
        "start": dict(health=5, sleep_hrs=6.0, sleep_q=5, pain=4, mood=3, anxiety=6,
                      stress=6, safety=3, meals=2, food_access=3, water=5,
                      energy=4, exercise=15),
        "end":   dict(health=8, sleep_hrs=7.5, sleep_q=8, pain=2, mood=4, anxiety=3,
                      stress=3, safety=5, meals=3, food_access=5, water=8,
                      energy=8, exercise=30),
        "baseline": dict(health=8, sleep_hrs=7.5, sleep_q=8, pain=2, mood=4, anxiety=3,
                         stress=3, safety=5, meals=3, food_access=5, water=8,
                         energy=8, exercise=30,
                         housing_status="Permanent Housing", housing_security=8,
                         days_housed=250, income_source="Government Benefits",
                         afford_essentials=4, social_interactions=5, support_access=4,
                         hopefulness=4, goal_progress=7, self_improvement=7,
                         doctor_visit="no", missed_appointment="no",
                         medication_access="yes"),
        "housing_arc":  ["shelter","transitional","transitional","transitional","permanent",
                         "permanent","permanent","permanent","permanent"],
        "income_arc":   ["none","benefits","benefits","benefits","benefits",
                         "benefits","benefits","employment","employment"],
        "medications":  "yes", "smoking": "no", "drug_use": "no",
    },

    # ── ID 28: Dorothy Clark — high anxiety, mental health focus ──────────────
    {
        "pid": 28, "label": "Dorothy Clark",
        "start": dict(health=4, sleep_hrs=5.0, sleep_q=3, pain=4, mood=2, anxiety=9,
                      stress=9, safety=2, meals=2, food_access=3, water=4,
                      energy=3, exercise=5),
        "end":   dict(health=7, sleep_hrs=7.0, sleep_q=7, pain=2, mood=4, anxiety=4,
                      stress=4, safety=4, meals=3, food_access=4, water=7,
                      energy=6, exercise=20),
        "baseline": dict(health=7, sleep_hrs=7.0, sleep_q=7, pain=2, mood=4, anxiety=4,
                         stress=4, safety=4, meals=3, food_access=4, water=7,
                         energy=6, exercise=20,
                         housing_status="Permanent Housing", housing_security=7,
                         days_housed=180, income_source="Government Benefits",
                         afford_essentials=3, social_interactions=4, support_access=4,
                         hopefulness=4, goal_progress=6, self_improvement=6,
                         doctor_visit="yes", missed_appointment="no",
                         medication_access="yes"),
        "housing_arc":  ["shelter","shelter","transitional","transitional","transitional",
                         "permanent","permanent","permanent","permanent"],
        "income_arc":   ["none","none","none","benefits","benefits",
                         "benefits","benefits","benefits","benefits"],
        "medications":  "yes", "smoking": "no", "drug_use": "no",
    },

    # ── ID 29: Thomas Lewis — physical health challenges ──────────────────────
    {
        "pid": 29, "label": "Thomas Lewis",
        "start": dict(health=3, sleep_hrs=5.0, sleep_q=3, pain=8, mood=3, anxiety=6,
                      stress=6, safety=3, meals=2, food_access=3, water=5,
                      energy=2, exercise=0),
        "end":   dict(health=6, sleep_hrs=7.0, sleep_q=6, pain=4, mood=4, anxiety=4,
                      stress=4, safety=4, meals=3, food_access=4, water=7,
                      energy=6, exercise=15),
        "baseline": dict(health=6, sleep_hrs=7.0, sleep_q=6, pain=4, mood=4, anxiety=4,
                         stress=4, safety=4, meals=3, food_access=4, water=7,
                         energy=6, exercise=15,
                         housing_status="Transitional Housing", housing_security=6,
                         days_housed=120, income_source="Government Benefits",
                         afford_essentials=3, social_interactions=3, support_access=3,
                         hopefulness=3, goal_progress=5, self_improvement=5,
                         doctor_visit="yes", missed_appointment="no",
                         medication_access="yes"),
        "housing_arc":  ["shelter","shelter","shelter","transitional","transitional",
                         "transitional","transitional","transitional","permanent"],
        "income_arc":   ["none","none","benefits","benefits","benefits",
                         "benefits","benefits","benefits","benefits"],
        "medications":  "yes", "smoking": "yes", "drug_use": "no",
    },

    # ── ID 31: Christopher Walker — young adult, quick adaptor ────────────────
    {
        "pid": 31, "label": "Christopher Walker",
        "start": dict(health=5, sleep_hrs=7.0, sleep_q=5, pain=2, mood=3, anxiety=6,
                      stress=6, safety=3, meals=2, food_access=3, water=5,
                      energy=5, exercise=20),
        "end":   dict(health=8, sleep_hrs=8.0, sleep_q=8, pain=1, mood=5, anxiety=2,
                      stress=2, safety=5, meals=3, food_access=5, water=8,
                      energy=8, exercise=40),
        "baseline": dict(health=8, sleep_hrs=8.0, sleep_q=8, pain=1, mood=5, anxiety=2,
                         stress=2, safety=5, meals=3, food_access=5, water=8,
                         energy=8, exercise=40,
                         housing_status="Permanent Housing", housing_security=9,
                         days_housed=300, income_source="Employment",
                         afford_essentials=5, social_interactions=8, support_access=5,
                         hopefulness=5, goal_progress=9, self_improvement=9,
                         doctor_visit="no", missed_appointment="no",
                         medication_access="yes"),
        "housing_arc":  ["shelter","transitional","transitional","permanent","permanent",
                         "permanent","permanent","permanent","permanent"],
        "income_arc":   ["none","none","benefits","benefits","employment",
                         "employment","employment","employment","employment"],
        "medications":  "no", "smoking": "no", "drug_use": "no",
    },

    # ── ID 32: Karen Hall — mixed patterns, some setbacks ─────────────────────
    {
        "pid": 32, "label": "Karen Hall",
        "start": dict(health=5, sleep_hrs=6.0, sleep_q=4, pain=5, mood=3, anxiety=7,
                      stress=7, safety=3, meals=2, food_access=3, water=5,
                      energy=4, exercise=5),
        "end":   dict(health=7, sleep_hrs=7.0, sleep_q=6, pain=3, mood=4, anxiety=4,
                      stress=4, safety=4, meals=3, food_access=4, water=7,
                      energy=6, exercise=20),
        "baseline": dict(health=7, sleep_hrs=7.0, sleep_q=6, pain=3, mood=4, anxiety=4,
                         stress=4, safety=4, meals=3, food_access=4, water=7,
                         energy=6, exercise=20,
                         housing_status="Permanent Housing", housing_security=7,
                         days_housed=150, income_source="Government Benefits",
                         afford_essentials=3, social_interactions=4, support_access=3,
                         hopefulness=4, goal_progress=6, self_improvement=6,
                         doctor_visit="no", missed_appointment="yes",
                         medication_access="yes"),
        "housing_arc":  ["transitional","transitional","shelter","transitional","transitional",
                         "permanent","permanent","permanent","permanent"],
        "income_arc":   ["benefits","benefits","benefits","benefits","benefits",
                         "benefits","benefits","benefits","employment"],
        "medications":  "yes", "smoking": "yes", "drug_use": "no",
    },

    # ── ID 33: Daniel Young — recently homeless, dramatic improvement ──────────
    {
        "pid": 33, "label": "Daniel Young",
        "start": dict(health=2, sleep_hrs=3.5, sleep_q=2, pain=5, mood=1, anxiety=9,
                      stress=9, safety=1, meals=1, food_access=1, water=3,
                      energy=2, exercise=0),
        "end":   dict(health=8, sleep_hrs=7.5, sleep_q=8, pain=2, mood=4, anxiety=3,
                      stress=3, safety=5, meals=3, food_access=5, water=8,
                      energy=7, exercise=30),
        "baseline": dict(health=8, sleep_hrs=7.5, sleep_q=8, pain=2, mood=4, anxiety=3,
                         stress=3, safety=5, meals=3, food_access=5, water=8,
                         energy=7, exercise=30,
                         housing_status="Permanent Housing", housing_security=8,
                         days_housed=120, income_source="Government Benefits",
                         afford_essentials=4, social_interactions=5, support_access=4,
                         hopefulness=5, goal_progress=7, self_improvement=8,
                         doctor_visit="no", missed_appointment="no",
                         medication_access="yes"),
        "housing_arc":  ["none","shelter","shelter","transitional","transitional",
                         "permanent","permanent","permanent","permanent"],
        "income_arc":   ["none","none","none","none","benefits",
                         "benefits","benefits","benefits","benefits"],
        "medications":  "no", "smoking": "yes", "drug_use": "yes",
    },
]

# Housing status label mapping (what's stored in Value)
HOUSING_LABELS = {
    "none":         "No Fixed Housing",
    "shelter":      "Emergency Shelter",
    "transitional": "Transitional Housing",
    "permanent":    "Permanent Housing",
}
INCOME_LABELS = {
    "none":       "No Income",
    "benefits":   "Government Benefits",
    "employment": "Employment",
    "other":      "Other",
}

def interp(start_val, end_val, step, total):
    """Linear interpolation from start to end across total steps."""
    if total <= 1:
        return start_val
    v = start_val + (end_val - start_val) * step / (total - 1)
    return v

def fmt_val(v, key):
    """Format a numeric value for insertion (round to 1dp for floats)."""
    if key == "sleep_hrs":
        return f"{v:.1f}"
    return str(int(round(v)))

def ins(pid, metric_key, value, date, is_baseline=0):
    return (
        f"INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) "
        f"SELECT {pid}, MetricID, '{value}', '{date}', {is_baseline} "
        f"FROM TrackingMetric WHERE MetricKey = '{metric_key}';"
    )

lines = []

header = """\
-- ─────────────────────────────────────────────────────────────────────────────
-- 08_health_tracking_all_participants_seed.sql
--
-- Seed health tracking entries for ALL remaining participants.
-- Participants 13–18 already have data in files 05 and 07 — not repeated here.
--
-- Coverage per participant:
--   • Baseline snapshot  : 2025-10-01 (IsBaseline=1), all core metrics
--   • Monthly snapshots  : 2024-05-01 → 2025-09-01 (every 2 months, 9 dates)
--   • Recent daily data  : 2025-11-01 and 2025-11-15
--
-- All INSERTs use INSERT IGNORE — safe to re-run (idempotent).
-- ─────────────────────────────────────────────────────────────────────────────
"""
lines.append(header)

for p in profiles:
    pid   = p["pid"]
    label = p["label"]
    s     = p["start"]
    e     = p["end"]
    bl    = p["baseline"]
    sparse = p.get("sparse", False)

    lines.append(f"\n-- {'═' * 77}")
    lines.append(f"-- AccountID {pid} — {label}")
    lines.append(f"-- {'═' * 77}\n")

    # ── 1. Baseline ─────────────────────────────────────────────────────────
    lines.append(f"-- Baseline (IsBaseline=1) : {BASELINE_DATE}")
    for mk, val in [
        ("self_rated_health", bl["health"]),
        ("sleep_hours",       bl["sleep_hrs"]),
        ("sleep_quality",     bl["sleep_q"]),
        ("pain_level",        bl["pain"]),
        ("mood_score",        bl["mood"]),
        ("anxiety_level",     bl["anxiety"]),
        ("stress_level",      bl["stress"]),
        ("feeling_safe",      bl["safety"]),
        ("meals_today",       bl["meals"]),
        ("food_access",       bl["food_access"]),
        ("water_intake",      bl["water"]),
        ("energy_level",      bl["energy"]),
        ("exercise_minutes",  bl["exercise"]),
        ("medications_taken", p["medications"]),
        ("smoking",           p["smoking"]),
        ("drug_use",          p["drug_use"]),
        ("housing_status",    bl["housing_status"]),
        ("housing_security",  bl["housing_security"]),
        ("days_housed",       bl["days_housed"]),
        ("income_source",     bl["income_source"]),
        ("afford_essentials", bl["afford_essentials"]),
        ("social_interactions", bl["social_interactions"]),
        ("support_access",    bl["support_access"]),
        ("hopefulness",       bl["hopefulness"]),
        ("goal_progress",     bl["goal_progress"]),
        ("self_improvement",  bl["self_improvement"]),
        ("doctor_visit",      bl["doctor_visit"]),
        ("missed_appointment",bl["missed_appointment"]),
        ("medication_access", bl["medication_access"]),
    ]:
        v = val if isinstance(val, str) else fmt_val(val, mk)
        lines.append(ins(pid, mk, v, BASELINE_DATE, 1))

    lines.append("")

    # ── 2. Monthly snapshots ─────────────────────────────────────────────────
    n_dates = len(MONTHLY_DATES)
    # For sparse profiles, only include 4 evenly-spaced dates
    active_indices = (
        [0, 2, 5, 8] if sparse else list(range(n_dates))
    )

    for step_i, date_i in enumerate(active_indices):
        date = MONTHLY_DATES[date_i]
        # Interpolation position within total span
        frac = date_i / (n_dates - 1)

        def iv(key):
            return s[key] + (e[key] - s[key]) * frac

        lines.append(f"-- {date}")
        for mk, raw in [
            ("self_rated_health",  iv("health")),
            ("sleep_hours",        iv("sleep_hrs")),
            ("sleep_quality",      iv("sleep_q")),
            ("pain_level",         iv("pain")),
            ("mood_score",         iv("mood")),
            ("anxiety_level",      iv("anxiety")),
            ("stress_level",       iv("stress")),
            ("feeling_safe",       iv("safety")),
            ("meals_today",        iv("meals")),
            ("food_access",        iv("food_access")),
            ("water_intake",       iv("water")),
            ("energy_level",       iv("energy")),
            ("exercise_minutes",   iv("exercise")),
            ("medications_taken",  p["medications"]),
            ("smoking",            p["smoking"]),
            ("drug_use",           p["drug_use"]),
        ]:
            v = raw if isinstance(raw, str) else fmt_val(raw, mk)
            lines.append(ins(pid, mk, v, date))

        # Weekly/monthly categoricals
        h_label = HOUSING_LABELS.get(p["housing_arc"][date_i], p["housing_arc"][date_i])
        lines.append(ins(pid, "housing_status",    h_label,                     date))
        lines.append(ins(pid, "housing_security",  fmt_val(2 + frac * 7, ""),  date))
        lines.append(ins(pid, "days_housed",       fmt_val(frac * bl["days_housed"], ""), date))
        i_label = INCOME_LABELS.get(p["income_arc"][date_i], p["income_arc"][date_i])
        lines.append(ins(pid, "income_source",     i_label,                     date))
        lines.append(ins(pid, "afford_essentials", fmt_val(2 + frac * (bl["afford_essentials"] - 2), ""), date))
        lines.append(ins(pid, "social_interactions",fmt_val(1 + frac * (bl["social_interactions"] - 1), ""), date))
        lines.append(ins(pid, "support_access",    fmt_val(2 + frac * (bl["support_access"] - 2), ""), date))
        lines.append(ins(pid, "hopefulness",       fmt_val(1 + frac * (bl["hopefulness"] - 1), ""), date))
        lines.append(ins(pid, "goal_progress",     fmt_val(1 + frac * (bl["goal_progress"] - 1), ""), date))
        lines.append(ins(pid, "self_improvement",  fmt_val(1 + frac * (bl["self_improvement"] - 1), ""), date))
        lines.append("")

    # ── 3. Recent entries (Nov 2025) ─────────────────────────────────────────
    if not sparse:
        for rd in RECENT_DATES:
            lines.append(f"-- {rd} (recent)")
            # Use end values with slight variation
            for mk, val in [
                ("self_rated_health", e["health"]),
                ("sleep_hours",       e["sleep_hrs"]),
                ("sleep_quality",     e["sleep_q"]),
                ("pain_level",        e["pain"]),
                ("mood_score",        e["mood"]),
                ("anxiety_level",     e["anxiety"]),
                ("stress_level",      e["stress"]),
                ("feeling_safe",      e["safety"]),
                ("meals_today",       e["meals"]),
                ("food_access",       e["food_access"]),
                ("water_intake",      e["water"]),
                ("energy_level",      e["energy"]),
                ("exercise_minutes",  e["exercise"]),
                ("medications_taken", p["medications"]),
                ("smoking",           p["smoking"]),
                ("drug_use",          p["drug_use"]),
            ]:
                v = val if isinstance(val, str) else fmt_val(val, mk)
                lines.append(ins(pid, mk, v, rd))
            lines.append("")

sql = "\n".join(lines)
with open(OUTPUT, "w") as f:
    f.write(sql)

print(f"Written {len([l for l in lines if l.startswith('INSERT')])} INSERT statements to {OUTPUT}")
