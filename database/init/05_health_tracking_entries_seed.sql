-- ─────────────────────────────────────────────────────────────────────────────
-- 05_health_tracking_entries_seed.sql
--
-- Seed realistic TrackingEntry data for demo/test participants.
-- Depends on: 01_create_database.sql (schema), 04_health_tracking_seed.sql (metrics).
--
-- Participants seeded:
--   AccountID 13 — John Smith      — active, baseline + 14 days (Nov 1-14), all categories
--   AccountID 14 — Maria Garcia    — baseline (physical only) + 3 sporadic partial days
--   AccountID 15 — James Johnson   — baseline only (physical + mental), nothing since
--   AccountID 16 — Patricia Williams — new user, zero entries
--   AccountID 17 — Robert Brown    — 7 days (Nov 1-7), physical + mental only
--   AccountID 18 — Linda Davis     — 21 days (Nov 1-21), very consistent, all categories
--
-- All entries use INSERT IGNORE — safe to re-run (idempotent via unique_entry key).
-- Weekly metrics are inserted only on Sundays. Monthly metrics on the 1st.
-- Baseline entries use IsBaseline=1, EntryDate='2025-10-01'.
-- Regular tracking entries use IsBaseline=0, dates in November 2025.
-- ─────────────────────────────────────────────────────────────────────────────

-- ═════════════════════════════════════════════════════════════════════════════
-- AccountID 13 — John Smith
-- Active user: complete baseline on 2025-10-01, daily entries Nov 1–14.
-- Weekly metrics entered on Sundays (Nov 2, Nov 9). Monthly on Nov 1.
-- ═════════════════════════════════════════════════════════════════════════════

-- ── Baseline (IsBaseline=1) ───────────────────────────────────────────────
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7.0', '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '6',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'yes', '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'er_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '6',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '2',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '1',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'Transitional Housing', '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '6',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '22',  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'Government Benefits', '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'income_source';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'doctor_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'missed_appointment';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'yes', '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'medication_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '0',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'self_improvement';

-- ── Daily entries: Nov 1 (Saturday) ─────────────────────────────────────────
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7.5', '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '2',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'yes', '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '6',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '1',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '6',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '20',  '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

-- ── Weekly metrics: Nov 2 (Sunday) + daily metrics ──────────────────────────
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '8.0', '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '2',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'yes', '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'er_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '0',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'Transitional Housing', '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '53',  '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '6',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'doctor_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'missed_appointment';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'yes', '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'medication_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '6',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '30',  '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'self_improvement';

-- ── Daily entries: Nov 3–8 (Mon–Sat) ────────────────────────────────────────
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '6.5', '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '6',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'yes', '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '6',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '0',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '0',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '8',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7.0', '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '2',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'yes', '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '6',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '0',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '45',  '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '8',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '6.0', '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '6',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '2',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'yes', '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '2',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '2',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '6',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '15',  '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7.5', '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '2',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'yes', '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '6',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '0',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '30',  '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '6.0', '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '6',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'yes', '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '0',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '6',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '20',  '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '8',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '8.0', '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '8',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '1',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'yes', '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '1',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '40',  '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

-- ── Weekly metrics: Nov 9 (Sunday) + daily metrics ──────────────────────────
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '8',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7.5', '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '8',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '1',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'yes', '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'er_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '2',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '0',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'Transitional Housing', '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '60',  '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '8',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'yes', '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'doctor_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'missed_appointment';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'yes', '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'medication_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '8',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '35',  '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '6',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '6',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'self_improvement';

-- ── Daily entries: Nov 10–14 (Mon–Fri) ──────────────────────────────────────
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '8',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7.0', '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '1',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'yes', '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '2',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '8',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '0',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '8',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '40',  '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '8',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7.5', '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '8',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '1',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'yes', '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '2',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '0',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '8',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '30',  '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7.0', '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '2',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'yes', '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '6',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '0',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '30',  '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '8',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7.0', '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '1',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'yes', '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '2',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '2',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '8',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '0',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '8',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '45',  '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '8',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7.5', '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '1',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'yes', '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '2',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '4',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '3',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '7',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '0',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, 'no',  '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '8',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '5',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 13, MetricID, '30',  '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';


-- ═════════════════════════════════════════════════════════════════════════════
-- AccountID 14 — Maria Garcia
-- Baseline for physical_health only, then 3 sporadic partial days.
-- ═════════════════════════════════════════════════════════════════════════════

-- ── Baseline: physical_health metrics only ───────────────────────────────────
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '5',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '5.0', '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '4',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '6',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, 'no',  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, 'no',  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'er_visit';

-- ── Sporadic day: Nov 5 (only physical + nutrition) ──────────────────────────
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '5',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '5.0', '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '5',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '5',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '2',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '2',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '4',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';

-- ── Sporadic day: Nov 12 (only physical + mental) ────────────────────────────
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '6',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '6.0', '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '5',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, 'yes', '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '3',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '6',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '7',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';

-- ── Sporadic day: Nov 20 (only physical + daily_functioning) ─────────────────
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '6',   '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '6.5', '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '4',   '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, 'yes', '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '5',   '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '3',   '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 14, MetricID, '10',  '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';


-- ═════════════════════════════════════════════════════════════════════════════
-- AccountID 15 — James Johnson
-- Baseline only: physical_health + mental_health. No subsequent entries.
-- ═════════════════════════════════════════════════════════════════════════════

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 15, MetricID, '4',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 15, MetricID, '4.5', '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 15, MetricID, '4',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 15, MetricID, '7',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 15, MetricID, 'no',  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 15, MetricID, '2',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 15, MetricID, '8',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 15, MetricID, '8',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 15, MetricID, '2',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 15, MetricID, '2',   '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'hopefulness';


-- ═════════════════════════════════════════════════════════════════════════════
-- AccountID 16 — Patricia Williams
-- New user — no entries at all.
-- ═════════════════════════════════════════════════════════════════════════════


-- ═════════════════════════════════════════════════════════════════════════════
-- AccountID 17 — Robert Brown
-- Active 7 days (Nov 1-7), physical_health + mental_health metrics only.
-- ═════════════════════════════════════════════════════════════════════════════

-- Nov 1
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '6',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '5.5', '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '5',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '4',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, 'yes', '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '3',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '6',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '6',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '3',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';

-- Nov 2 (Sunday) — include er_visit and hopefulness as weekly metrics
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '6',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '6.0', '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '6',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '4',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, 'yes', '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, 'no',  '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'er_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '3',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '6',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '5',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '3',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '2',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';

-- Nov 3
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '5',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '5.0', '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '5',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '5',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, 'yes', '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '2',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '7',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '7',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '2',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';

-- Nov 4
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '6',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '6.0', '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '5',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '4',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, 'yes', '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '3',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '5',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '6',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '3',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';

-- Nov 5
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '6',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '5.5', '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '5',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '4',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, 'yes', '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '3',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '5',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '5',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '3',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';

-- Nov 6
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '7',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '6.5', '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '6',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '3',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, 'yes', '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '4',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '4',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '4',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '3',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';

-- Nov 7
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '7',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '6.0', '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '6',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '3',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, 'yes', '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '4',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '4',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '4',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 17, MetricID, '4',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';


-- ═════════════════════════════════════════════════════════════════════════════
-- AccountID 18 — Linda Davis
-- Very consistent: 21 days (Nov 1-21), all daily metrics daily,
-- weekly metrics on Sundays (Nov 2, 9, 16), monthly on Nov 1.
-- Shows steady improvement trend across all categories.
-- ═════════════════════════════════════════════════════════════════════════════

-- Nov 1 (Saturday) + monthly metric
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '6',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7.0', '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '6',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '6',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '0',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '6',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '20',  '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';
-- monthly metric
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'Government Benefits', '2025-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- Nov 2 (Sunday) + weekly metrics
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '6',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7.5', '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'er_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '0',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'Permanent Housing', '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '90',  '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'doctor_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'missed_appointment';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'medication_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '6',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '25',  '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-02', 0 FROM TrackingMetric WHERE MetricKey = 'self_improvement';

-- Nov 3-8: daily metrics only (Mon-Sat)
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '6',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7.0', '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '6',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '0',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '6',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '30',  '2025-11-03', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7.5', '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '2',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '0',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '35',  '2025-11-04', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7.0', '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '2',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '0',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '30',  '2025-11-05', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7.5', '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '2',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '0',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '40',  '2025-11-06', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7.0', '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '2',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '2',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '0',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '45',  '2025-11-07', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8.0', '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '2',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '2',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '2',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '0',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '40',  '2025-11-08', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

-- Nov 9 (Sunday) + weekly metrics
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8.0', '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'er_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '2',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '2',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '0',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'Permanent Housing', '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '97',  '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '4',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'doctor_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'missed_appointment';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'medication_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '45',  '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '7',   '2025-11-09', 0 FROM TrackingMetric WHERE MetricKey = 'self_improvement';

-- Nov 10-15: daily metrics (Mon-Sat) — showing continued improvement
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8.0', '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '2',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '2',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '0',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '50',  '2025-11-10', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8.0', '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '2',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '2',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '0',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '45',  '2025-11-11', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8.0', '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '2',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '0',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '50',  '2025-11-12', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8.0', '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '2',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '0',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '55',  '2025-11-13', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8.0', '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '2',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '0',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '50',  '2025-11-14', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8.5', '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '2',   '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '0',   '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '60',  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

-- Nov 16 (Sunday) + weekly metrics
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8.5', '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'er_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '0',   '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'Permanent Housing', '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '104', '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'doctor_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'missed_appointment';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'medication_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '60',  '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-16', 0 FROM TrackingMetric WHERE MetricKey = 'self_improvement';

-- Nov 17-21: daily metrics (Mon-Fri) — peak performance
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-17', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8.5', '2025-11-17', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-17', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-17', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-17', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-17', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-17', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-17', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-17', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-17', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-17', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-17', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '0',   '2025-11-17', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-17', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-17', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-17', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-17', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '60',  '2025-11-17', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-18', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8.5', '2025-11-18', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-18', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-18', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-18', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-18', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-18', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-18', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-18', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-18', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-18', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-18', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '0',   '2025-11-18', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-18', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-18', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-18', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-18', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '55',  '2025-11-18', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-19', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8.0', '2025-11-19', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-19', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-19', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-19', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-19', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '2',   '2025-11-19', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '2',   '2025-11-19', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-19', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-19', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-19', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-19', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '0',   '2025-11-19', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-19', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-19', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-19', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-19', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '50',  '2025-11-19', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8.5', '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '0',   '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '60',  '2025-11-20', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-21', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8.5', '2025-11-21', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-21', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-21', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'yes', '2025-11-21', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-21', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-21', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '1',   '2025-11-21', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-21', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '3',   '2025-11-21', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-21', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '8',   '2025-11-21', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '0',   '2025-11-21', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-21', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, 'no',  '2025-11-21', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '9',   '2025-11-21', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '5',   '2025-11-21', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline)
SELECT 18, MetricID, '60',  '2025-11-21', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';
