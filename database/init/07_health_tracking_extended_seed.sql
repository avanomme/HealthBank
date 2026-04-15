-- ─────────────────────────────────────────────────────────────────────────────
-- 07_health_tracking_extended_seed.sql
--
-- Extended backdated TrackingEntry seed data showing an improvement arc
-- from account creation (Apr 2024) through Sep 2025 (before the Oct 2025
-- baseline in 05_health_tracking_entries_seed.sql).
--
-- Coverage: 2024-05-01 → 2025-09-01 (monthly, 1st of each month = 17 dates)
-- Participants:
--   AccountID 13 — John Smith      — created 2024-04-01
--   AccountID 14 — Maria Garcia    — created 2024-04-02
--   AccountID 15 — James Wilson    — created 2024-04-03
--   AccountID 16 — Linda Martinez  — created 2024-04-05
--   AccountID 17 — Robert Anderson — created 2024-04-08
--   AccountID 18 — Patricia Taylor — created 2024-04-10
--
-- All entries use INSERT IGNORE — safe to re-run (idempotent via unique key).
-- IsBaseline = 0 for all entries in this file.
-- Values show a realistic improvement trajectory over time.
-- ─────────────────────────────────────────────────────────────────────────────

-- ═════════════════════════════════════════════════════════════════════════════
-- AccountID 13 — John Smith (offset: base values, strongest improver)
-- ═════════════════════════════════════════════════════════════════════════════

-- 2024-05-01
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '4',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5.5', '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '7',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '8',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '8',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '10',  '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'shelter', '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '1',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'no',  '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'none','2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2024-07-01
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '4',   '2024-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5.8', '2024-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '4',   '2024-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '6',   '2024-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '2',   '2024-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '7',   '2024-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '7',   '2024-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2024-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '2',   '2024-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '4',   '2024-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2024-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2024-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '35',  '2024-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'shelter', '2024-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '2',   '2024-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '2',   '2024-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2024-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2024-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'no',  '2024-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'none','2024-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2024-09-01
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '6.0', '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '6',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '6',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '2',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '4',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '60',  '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'transitional', '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'yes', '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'benefits', '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2024-11-01
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '6',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '6.5', '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '6',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '6',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '4',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '6',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '120', '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'transitional', '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '4',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '4',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '4',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'yes', '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'benefits', '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2025-01-01
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '7',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '7.0', '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '6',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '4',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '4',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '4',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '6',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '6',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '180', '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'transitional', '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '4',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'yes', '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'benefits', '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2025-04-01
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '7',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '7.2', '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '7',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '4',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '4',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '4',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '7',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '4',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '8',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '272', '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'permanent', '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '4',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '7',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '7',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'yes', '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'employment', '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2025-07-01
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '8',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '7.5', '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '8',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '2',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '4',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '8',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '9',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '365', '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'permanent', '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '8',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '8',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'yes', '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'employment', '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2025-09-01
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '8',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '7.7', '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '9',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '1',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '4',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '2',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '3',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '9',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '9',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '400', '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'permanent', '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '9',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '5',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, '9',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'yes', '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 13, MetricID, 'employment', '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- ═════════════════════════════════════════════════════════════════════════════
-- AccountID 14 — Maria Garcia (slower improver, -1 offset on health metrics)
-- ═════════════════════════════════════════════════════════════════════════════

-- 2024-05-01
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '3',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '5.0', '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '8',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '1',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '9',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '9',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '1',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '1',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '1',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '1',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '5',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, 'none','2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '1',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '1',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '1',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '1',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, 'no',  '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, 'none','2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2024-09-01
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '4',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '5.5', '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '4',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '6',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '2',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '7',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '7',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '2',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '2',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '4',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '2',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '3',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '45',  '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, 'shelter', '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '2',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '2',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '2',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '2',   '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, 'no',  '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, 'none','2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2025-01-01
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '5',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '6.5', '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '5',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '5',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '3',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '5',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '5',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '3',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '3',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '5',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '3',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '5',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '160', '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, 'transitional', '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '3',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '4',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '4',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '4',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, 'yes', '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, 'benefits', '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2025-05-01
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '7',   '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '7.2', '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '7',   '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '3',   '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '4',   '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '4',   '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '3',   '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '4',   '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '3',   '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '7',   '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '4',   '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '7',   '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '290', '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, 'permanent', '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '4',   '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '6',   '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '5',   '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '7',   '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, 'yes', '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, 'employment', '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2025-09-01
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '8',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '7.5', '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '8',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '2',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '4',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '3',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '2',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '5',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '3',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '8',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '5',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '9',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '380', '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, 'permanent', '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '5',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '8',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '5',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, '9',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, 'yes', '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 14, MetricID, 'employment', '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- ═════════════════════════════════════════════════════════════════════════════
-- AccountID 15 — James Wilson (had a setback 2024-10, then recovered)
-- ═════════════════════════════════════════════════════════════════════════════

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '3',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '5',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '3',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '7',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '8',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '9',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '3',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '8',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, 'shelter', '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '1',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '1',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, 'no',  '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, 'none','2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2024-08-01 (improving)
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '5',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '6.0', '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '5',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '5',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '3',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '6',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '6',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '3',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '2',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '5',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '3',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '4',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '50',  '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, 'transitional', '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '3',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '3',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '3',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '3',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, 'yes', '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, 'benefits', '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2024-10-01 (setback — lost housing temporarily)
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '3',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '5.0', '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '3',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '7',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '2',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '8',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '8',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '2',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '1',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '3',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '2',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '2',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '5',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, 'shelter', '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '2',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '1',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '2',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '2',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, 'no',  '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, 'none','2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2025-02-01 (recovering)
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '6',   '2025-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '6.8', '2025-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '6',   '2025-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '4',   '2025-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '3',   '2025-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '5',   '2025-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '5',   '2025-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '4',   '2025-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '3',   '2025-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '6',   '2025-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '3',   '2025-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '6',   '2025-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '120', '2025-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, 'transitional', '2025-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '3',   '2025-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '5',   '2025-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '4',   '2025-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '5',   '2025-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, 'yes', '2025-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, 'benefits', '2025-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2025-07-01 (stable)
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '7',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '7.2', '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '7',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '3',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '4',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '4',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '3',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '4',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '3',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '7',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '4',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '8',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '300', '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, 'permanent', '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '4',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '7',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '5',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, '7',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, 'yes', '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 15, MetricID, 'employment', '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- ═════════════════════════════════════════════════════════════════════════════
-- AccountID 16 — Linda Martinez (quick improver, starts moderate)
-- ═════════════════════════════════════════════════════════════════════════════

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '4',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '6.0', '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '4',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '6',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '7',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '7',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '4',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '3',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '3',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '20',  '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, 'shelter', '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '3',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '3',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, 'yes', '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, 'benefits', '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2024-08-01 (quick progress)
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '6',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '6.8', '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '6',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '4',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '3',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '5',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '5',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '4',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '3',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '6',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '4',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '6',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '90',  '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, 'transitional', '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '3',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '5',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '4',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '5',   '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, 'yes', '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, 'benefits', '2024-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2025-01-01
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '7',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '7.2', '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '7',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '3',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '4',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '4',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '3',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '4',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '3',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '7',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '4',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '7',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '210', '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, 'permanent', '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '4',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '6',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '5',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '6',   '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, 'yes', '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, 'employment', '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2025-07-01
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '9',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '8.0', '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '9',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '1',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '5',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '2',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '2',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '5',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '3',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '9',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '5',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '10',  '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '420', '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, 'permanent', '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '5',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '10',  '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '5',   '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, '10',  '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, 'yes', '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 16, MetricID, 'employment', '2025-07-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- ═════════════════════════════════════════════════════════════════════════════
-- AccountID 17 — Robert Anderson (slow improver, starts very poor)
-- ═════════════════════════════════════════════════════════════════════════════

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '4.5', '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '9',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '1',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '10',  '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '10',  '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '1',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '1',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '1',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '1',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '3',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, 'none','2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '1',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '1',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '1',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '1',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, 'no',  '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, 'none','2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2024-11-01 (still struggling but slight improvement)
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '4',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '5.5', '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '4',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '7',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '2',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '8',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '8',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '2',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '2',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '4',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '2',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '3',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '30',  '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, 'shelter', '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '2',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '2',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '2',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '2',   '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, 'no',  '2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, 'none','2024-11-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2025-04-01
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '5',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '6.5', '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '5',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '5',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '3',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '6',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '5',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '3',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '2',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '5',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '3',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '5',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '150', '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, 'transitional', '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '3',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '4',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '3',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '4',   '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, 'yes', '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, 'benefits', '2025-04-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2025-09-01
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '6',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '7.0', '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '6',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '4',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '3',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '4',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '4',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '4',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '3',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '6',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '4',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '7',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '280', '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, 'permanent', '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '4',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '6',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '4',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, '6',   '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, 'yes', '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 17, MetricID, 'benefits', '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- ═════════════════════════════════════════════════════════════════════════════
-- AccountID 18 — Patricia Taylor (variable but overall improvement)
-- ═════════════════════════════════════════════════════════════════════════════

INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '3',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '5.5', '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '4',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '7',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '8',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '7',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '3',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '12',  '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, 'shelter', '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '2',   '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, 'no',  '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, 'none','2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2024-10-01 (good progress)
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '6',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '6.5', '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '6',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '5',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '3',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '5',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '5',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '3',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '3',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '6',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '3',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '5',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '100', '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, 'transitional', '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '3',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '4',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '4',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '4',   '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, 'yes', '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, 'benefits', '2024-10-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2025-03-01 (slight dip — variable)
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '5',   '2025-03-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '6.2', '2025-03-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '5',   '2025-03-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '6',   '2025-03-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '3',   '2025-03-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '6',   '2025-03-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '6',   '2025-03-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '3',   '2025-03-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '2',   '2025-03-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '5',   '2025-03-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '3',   '2025-03-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '5',   '2025-03-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '180', '2025-03-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, 'transitional', '2025-03-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '3',   '2025-03-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '4',   '2025-03-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '3',   '2025-03-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '4',   '2025-03-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, 'yes', '2025-03-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, 'benefits', '2025-03-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- 2025-08-01 (recovered and stable)
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '7',   '2025-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '7.3', '2025-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '7',   '2025-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '3',   '2025-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '4',   '2025-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '3',   '2025-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '3',   '2025-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '4',   '2025-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '3',   '2025-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '7',   '2025-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '4',   '2025-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '8',   '2025-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '330', '2025-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, 'permanent', '2025-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '4',   '2025-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '7',   '2025-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '5',   '2025-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, '7',   '2025-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, 'yes', '2025-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 18, MetricID, 'employment', '2025-08-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';

-- ─────────────────────────────────────────────────────────────────────────────
-- Entries for participant 2 (AccountID=2, part@hb.com, created 2024-01-01)
-- Arc: shelter/rough → transitional → permanent housing, full recovery
-- ─────────────────────────────────────────────────────────────────────────────
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) VALUES
(2,1,'3','2024-02-01',1),(2,2,'4.5','2024-02-01',1),(2,3,'3','2024-02-01',1),(2,4,'7','2024-02-01',1),(2,5,'no','2024-02-01',1),(2,6,'yes','2024-02-01',1),(2,7,'2','2024-02-01',1),(2,8,'8','2024-02-01',1),(2,9,'9','2024-02-01',1),(2,10,'2','2024-02-01',1),(2,11,'1','2024-02-01',1),(2,12,'1','2024-02-01',1),(2,13,'2','2024-02-01',1),(2,14,'3','2024-02-01',1),(2,15,'4','2024-02-01',1),(2,16,'yes','2024-02-01',1),(2,17,'yes','2024-02-01',1),(2,18,'shelter','2024-02-01',1),(2,19,'2','2024-02-01',1),(2,20,'0','2024-02-01',1),(2,21,'none','2024-02-01',1),(2,22,'1','2024-02-01',1),(2,23,'1','2024-02-01',1),(2,24,'1','2024-02-01',1),(2,25,'no','2024-02-01',1),(2,26,'yes','2024-02-01',1),(2,27,'no','2024-02-01',1),(2,28,'2','2024-02-01',1),(2,29,'2','2024-02-01',1),(2,30,'0','2024-02-01',1),(2,31,'2','2024-02-01',1),(2,32,'2','2024-02-01',1),
(2,1,'4','2024-05-01',0),(2,2,'5.5','2024-05-01',0),(2,3,'4','2024-05-01',0),(2,4,'6','2024-05-01',0),(2,5,'no','2024-05-01',0),(2,6,'no','2024-05-01',0),(2,7,'2','2024-05-01',0),(2,8,'7','2024-05-01',0),(2,9,'8','2024-05-01',0),(2,10,'3','2024-05-01',0),(2,11,'2','2024-05-01',0),(2,12,'2','2024-05-01',0),(2,13,'3','2024-05-01',0),(2,14,'5','2024-05-01',0),(2,15,'3','2024-05-01',0),(2,16,'yes','2024-05-01',0),(2,17,'no','2024-05-01',0),(2,18,'transitional','2024-05-01',0),(2,19,'4','2024-05-01',0),(2,20,'30','2024-05-01',0),(2,21,'benefits','2024-05-01',0),(2,22,'2','2024-05-01',0),(2,23,'2','2024-05-01',0),(2,24,'2','2024-05-01',0),(2,25,'yes','2024-05-01',0),(2,26,'yes','2024-05-01',0),(2,27,'no','2024-05-01',0),(2,28,'3','2024-05-01',0),(2,29,'2','2024-05-01',0),(2,30,'5','2024-05-01',0),(2,31,'3','2024-05-01',0),(2,32,'3','2024-05-01',0),
(2,1,'5','2024-08-15',0),(2,2,'6','2024-08-15',0),(2,3,'5','2024-08-15',0),(2,4,'5','2024-08-15',0),(2,5,'yes','2024-08-15',0),(2,6,'no','2024-08-15',0),(2,7,'3','2024-08-15',0),(2,8,'6','2024-08-15',0),(2,9,'6','2024-08-15',0),(2,10,'3','2024-08-15',0),(2,11,'3','2024-08-15',0),(2,12,'2','2024-08-15',0),(2,13,'3','2024-08-15',0),(2,14,'6','2024-08-15',0),(2,15,'2','2024-08-15',0),(2,16,'yes','2024-08-15',0),(2,17,'no','2024-08-15',0),(2,18,'transitional','2024-08-15',0),(2,19,'5','2024-08-15',0),(2,20,'75','2024-08-15',0),(2,21,'benefits','2024-08-15',0),(2,22,'3','2024-08-15',0),(2,23,'3','2024-08-15',0),(2,24,'3','2024-08-15',0),(2,25,'yes','2024-08-15',0),(2,26,'no','2024-08-15',0),(2,27,'yes','2024-08-15',0),(2,28,'4','2024-08-15',0),(2,29,'3','2024-08-15',0),(2,30,'10','2024-08-15',0),(2,31,'4','2024-08-15',0),(2,32,'4','2024-08-15',0),
(2,1,'6','2024-11-01',0),(2,2,'6.5','2024-11-01',0),(2,3,'6','2024-11-01',0),(2,4,'4','2024-11-01',0),(2,5,'yes','2024-11-01',0),(2,6,'no','2024-11-01',0),(2,7,'3','2024-11-01',0),(2,8,'5','2024-11-01',0),(2,9,'5','2024-11-01',0),(2,10,'4','2024-11-01',0),(2,11,'3','2024-11-01',0),(2,12,'3','2024-11-01',0),(2,13,'4','2024-11-01',0),(2,14,'7','2024-11-01',0),(2,15,'1','2024-11-01',0),(2,16,'no','2024-11-01',0),(2,17,'no','2024-11-01',0),(2,18,'permanent','2024-11-01',0),(2,19,'7','2024-11-01',0),(2,20,'30','2024-11-01',0),(2,21,'benefits','2024-11-01',0),(2,22,'3','2024-11-01',0),(2,23,'4','2024-11-01',0),(2,24,'4','2024-11-01',0),(2,25,'yes','2024-11-01',0),(2,26,'no','2024-11-01',0),(2,27,'yes','2024-11-01',0),(2,28,'5','2024-11-01',0),(2,29,'3','2024-11-01',0),(2,30,'15','2024-11-01',0),(2,31,'5','2024-11-01',0),(2,32,'5','2024-11-01',0),
(2,1,'7','2025-02-01',0),(2,2,'7','2025-02-01',0),(2,3,'7','2025-02-01',0),(2,4,'3','2025-02-01',0),(2,5,'yes','2025-02-01',0),(2,6,'no','2025-02-01',0),(2,7,'4','2025-02-01',0),(2,8,'4','2025-02-01',0),(2,9,'4','2025-02-01',0),(2,10,'4','2025-02-01',0),(2,11,'4','2025-02-01',0),(2,12,'3','2025-02-01',0),(2,13,'4','2025-02-01',0),(2,14,'7','2025-02-01',0),(2,15,'1','2025-02-01',0),(2,16,'no','2025-02-01',0),(2,17,'no','2025-02-01',0),(2,18,'permanent','2025-02-01',0),(2,19,'8','2025-02-01',0),(2,20,'90','2025-02-01',0),(2,21,'employment','2025-02-01',0),(2,22,'4','2025-02-01',0),(2,23,'5','2025-02-01',0),(2,24,'4','2025-02-01',0),(2,25,'yes','2025-02-01',0),(2,26,'no','2025-02-01',0),(2,27,'yes','2025-02-01',0),(2,28,'6','2025-02-01',0),(2,29,'4','2025-02-01',0),(2,30,'20','2025-02-01',0),(2,31,'6','2025-02-01',0),(2,32,'6','2025-02-01',0),
(2,1,'8','2025-06-01',0),(2,2,'7.5','2025-06-01',0),(2,3,'8','2025-06-01',0),(2,4,'2','2025-06-01',0),(2,5,'yes','2025-06-01',0),(2,6,'no','2025-06-01',0),(2,7,'4','2025-06-01',0),(2,8,'3','2025-06-01',0),(2,9,'3','2025-06-01',0),(2,10,'5','2025-06-01',0),(2,11,'5','2025-06-01',0),(2,12,'3','2025-06-01',0),(2,13,'5','2025-06-01',0),(2,14,'8','2025-06-01',0),(2,15,'0','2025-06-01',0),(2,16,'no','2025-06-01',0),(2,17,'no','2025-06-01',0),(2,18,'permanent','2025-06-01',0),(2,19,'9','2025-06-01',0),(2,20,'210','2025-06-01',0),(2,21,'employment','2025-06-01',0),(2,22,'5','2025-06-01',0),(2,23,'7','2025-06-01',0),(2,24,'5','2025-06-01',0),(2,25,'yes','2025-06-01',0),(2,26,'no','2025-06-01',0),(2,27,'yes','2025-06-01',0),(2,28,'7','2025-06-01',0),(2,29,'5','2025-06-01',0),(2,30,'30','2025-06-01',0),(2,31,'8','2025-06-01',0),(2,32,'8','2025-06-01',0),
(2,1,'8','2025-10-15',0),(2,2,'7','2025-10-15',0),(2,3,'8','2025-10-15',0),(2,4,'2','2025-10-15',0),(2,5,'yes','2025-10-15',0),(2,6,'no','2025-10-15',0),(2,7,'4','2025-10-15',0),(2,8,'3','2025-10-15',0),(2,9,'3','2025-10-15',0),(2,10,'5','2025-10-15',0),(2,11,'5','2025-10-15',0),(2,12,'3','2025-10-15',0),(2,13,'5','2025-10-15',0),(2,14,'8','2025-10-15',0),(2,15,'0','2025-10-15',0),(2,16,'no','2025-10-15',0),(2,17,'no','2025-10-15',0),(2,18,'permanent','2025-10-15',0),(2,19,'10','2025-10-15',0),(2,20,'350','2025-10-15',0),(2,21,'employment','2025-10-15',0),(2,22,'5','2025-10-15',0),(2,23,'8','2025-10-15',0),(2,24,'5','2025-10-15',0),(2,25,'yes','2025-10-15',0),(2,26,'no','2025-10-15',0),(2,27,'yes','2025-10-15',0),(2,28,'8','2025-10-15',0),(2,29,'5','2025-10-15',0),(2,30,'35','2025-10-15',0),(2,31,'8','2025-10-15',0),(2,32,'9','2025-10-15',0),
(2,1,'9','2026-01-20',0),(2,2,'7.5','2026-01-20',0),(2,3,'8','2026-01-20',0),(2,4,'1','2026-01-20',0),(2,5,'yes','2026-01-20',0),(2,6,'no','2026-01-20',0),(2,7,'5','2026-01-20',0),(2,8,'2','2026-01-20',0),(2,9,'2','2026-01-20',0),(2,10,'5','2026-01-20',0),(2,11,'5','2026-01-20',0),(2,12,'3','2026-01-20',0),(2,13,'5','2026-01-20',0),(2,14,'8','2026-01-20',0),(2,15,'0','2026-01-20',0),(2,16,'no','2026-01-20',0),(2,17,'no','2026-01-20',0),(2,18,'permanent','2026-01-20',0),(2,19,'10','2026-01-20',0),(2,20,'447','2026-01-20',0),(2,21,'employment','2026-01-20',0),(2,22,'5','2026-01-20',0),(2,23,'9','2026-01-20',0),(2,24,'5','2026-01-20',0),(2,25,'yes','2026-01-20',0),(2,26,'no','2026-01-20',0),(2,27,'yes','2026-01-20',0),(2,28,'8','2026-01-20',0),(2,29,'5','2026-01-20',0),(2,30,'40','2026-01-20',0),(2,31,'9','2026-01-20',0),(2,32,'9','2026-01-20',0);
