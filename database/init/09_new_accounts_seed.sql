-- 09_new_accounts_seed.sql
-- Alan Adams (34) - Participant, DOB 1985-09-12, Male
-- Alana Calvert (35) - HCP
-- Arthur Owens (36) - Researcher
-- ALL PASSWORDS: password

USE healthdatabase;

-- ── Auth ─────────────────────────────────────────────────────────────────────
INSERT INTO Auth (AuthID, PasswordHash) VALUES
(34, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(35, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(36, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0=');

-- ── AccountData ───────────────────────────────────────────────────────────────
INSERT INTO AccountData (AccountID, FirstName, LastName, Email, AuthID, RoleID, IsActive, Birthdate, Gender, CreatedAt) VALUES
(34, 'Alan',   'Adams',   'aadams@hb.com',   34, 1, TRUE, '1985-09-12', 'Male',   '2024-06-01 10:00:00'),
(35, 'Alana',  'Calvert', 'acalvert@hb.com', 35, 3, TRUE, NULL,         NULL,     '2024-06-01 10:30:00'),
(36, 'Arthur', 'Owens',   'aowens@hb.com',   36, 2, TRUE, NULL,         NULL,     '2024-06-01 11:00:00');

UPDATE AccountData SET
  ConsentVersion = '1.0',
  ConsentSignedAt = '2024-06-01 10:00:00',
  TosAcceptedAt   = '2024-06-01 10:00:00',
  TosVersion      = '1.0'
WHERE AccountID IN (34, 35, 36);

-- ── ConsentRecord ─────────────────────────────────────────────────────────────
INSERT IGNORE INTO ConsentRecord (AccountID, RoleID, ConsentVersion, DocumentLanguage, DocumentText, SignatureName, SignedAt) VALUES
(34, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Alan Adams',   '2024-06-01 10:00:00'),
(35, 3, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Alana Calvert','2024-06-01 10:30:00'),
(36, 2, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Arthur Owens', '2024-06-01 11:00:00');

-- ── HCP–Patient Link ──────────────────────────────────────────────────────────
INSERT IGNORE INTO HcpPatientLink (HcpID, PatientID, Status, RequestedBy) VALUES
(35, 34, 'active', 'hcp');

INSERT IGNORE INTO FriendRequests (RequesterID, TargetEmail, TargetAccountID, Status) VALUES
(35, 'aadams@hb.com', 34, 'accepted');

-- ── Messaging ─────────────────────────────────────────────────────────────────
INSERT IGNORE INTO Conversations (ConvID, ConvType) VALUES (5, 'direct'), (6, 'direct');
INSERT IGNORE INTO ConversationParticipants (ConvID, AccountID) VALUES
(5, 35), (5, 34),
(6, 36), (6,  5);
INSERT IGNORE INTO Messages (ConvID, SenderID, Body) VALUES
(5, 35, 'Hi Alan, I have reviewed your recent health data. Great progress!'),
(5, 34, 'Thank you! I have been working hard on improving my routine.'),
(5, 35, 'Keep logging daily your trends are really encouraging.'),
(6, 36, 'Sarah, have you looked at the latest aggregate data from the new cohort?'),
(6,  5, 'Yes, the housing stability metrics are showing strong correlation. Lets discuss.');

-- ── Survey Assignments ────────────────────────────────────────────────────────
-- Alan Adams (34): Survey 1 completed, Survey 2 completed, Survey 3 pending, Survey 6 completed
INSERT IGNORE INTO SurveyAssignment (SurveyID, AccountID, AssignedAt, DueDate, CompletedAt, Status) VALUES
(1, 34, '2026-01-02 09:00:00', '2026-01-31 23:59:59', '2026-01-12 11:00:00', 'completed'),
(2, 34, '2026-01-06 09:00:00', '2026-01-13 23:59:59', '2026-01-10 09:30:00', 'completed'),
(3, 34, '2026-01-15 10:00:00', '2026-02-15 23:59:59', NULL,                  'pending'),
(6, 34, '2025-10-01 09:00:00', '2025-10-31 23:59:59', '2025-10-14 14:00:00', 'completed');

-- Alana Calvert (35) HCP: Survey 1 completed, Survey 2 completed
INSERT IGNORE INTO SurveyAssignment (SurveyID, AccountID, AssignedAt, DueDate, CompletedAt, Status) VALUES
(1, 35, '2026-01-02 09:00:00', '2026-01-31 23:59:59', '2026-01-09 08:00:00', 'completed'),
(2, 35, '2026-01-06 09:00:00', '2026-01-13 23:59:59', '2026-01-08 07:45:00', 'completed');

-- ── Survey Responses ─────────────────────────────────────────────────────────
-- Alan Adams — Survey 1 (Q1 2026 Health Assessment)
INSERT IGNORE INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(1, 34, 1,  '35-44'),
(1, 34, 2,  'Male'),
(1, 34, 3,  'Unemployed'),
(1, 34, 11, '2'),
(1, 34, 12, 'None'),
(1, 34, 13, '3'),
(1, 34, 15, 'Within the last 6 months'),
(1, 34, 16, 'No, I quit'),
(1, 34, 17, 'Rarely (a few times a year)'),
(1, 34, 18, '3');

-- Alan Adams — Survey 2 (Mental Health Weekly Check-in)
INSERT IGNORE INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(2, 34, 6,  '4'),
(2, 34, 7,  '7'),
(2, 34, 8,  'Several days'),
(2, 34, 9,  'Good'),
(2, 34, 10, 'Yes');

-- Alan Adams — Survey 6 (Q4 2025 Health Assessment)
INSERT IGNORE INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(6, 34, 1,  '35-44'),
(6, 34, 2,  'Male'),
(6, 34, 11, '1'),
(6, 34, 12, 'None'),
(6, 34, 16, 'Yes, occasionally'),
(6, 34, 17, 'Weekly');

-- Alana Calvert — Survey 1
INSERT IGNORE INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(1, 35, 1,  '35-44'),
(1, 35, 2,  'Female'),
(1, 35, 3,  'Employed full-time'),
(1, 35, 11, '4'),
(1, 35, 12, 'None'),
(1, 35, 13, '1'),
(1, 35, 15, 'Within the last 6 months'),
(1, 35, 16, 'No, never'),
(1, 35, 17, 'Rarely (a few times a year)'),
(1, 35, 18, '4');

-- Alana Calvert — Survey 2
INSERT IGNORE INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(2, 35, 6,  '3'),
(2, 35, 7,  '8'),
(2, 35, 8,  'Not at all'),
(2, 35, 9,  'Very good'),
(2, 35, 10, 'Yes');

-- ── Health Tracking — Alan Adams (AccountID 34) ───────────────────────────────
-- Narrative: Precariously housed → gradual improvement → permanent housing Nov 2025

-- Baseline 2025-10-01 (IsBaseline=1) — Transitional housing, moderate health
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '6',                  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',                '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',                 '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'er_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '6',                  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '6',                  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',                  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',                  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',                '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',                 '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'Transitional Housing','2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '90',                 '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'Government Benefits', '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'income_source';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',                  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',                 '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'doctor_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',                 '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'missed_appointment';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',                '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'medication_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '10',                 '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2025-10-01', 1 FROM TrackingMetric WHERE MetricKey = 'self_improvement';

-- 2024-05-01 — worst period: no stable shelter
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '7',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',        '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',       '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'er_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '1',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '9',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '9',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '1',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '1',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '1',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '1',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '6',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',       '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',       '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'No Shelter','2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '1',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '0',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'None',      '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '1',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '0',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '1',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',        '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'doctor_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',       '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'missed_appointment';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',        '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'medication_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '1',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '0',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '1',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '1',         '2024-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_improvement';

-- 2024-09-01 — in shelter, some support beginning
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '6',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',         '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',         '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'er_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '8',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '8',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '1',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',        '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',        '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'Shelter',    '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '30',         '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'None',       '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '1',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '1',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '1',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',         '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'doctor_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',        '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'missed_appointment';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',         '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'medication_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',          '2024-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_improvement';

-- 2025-01-01 — transitional housing, benefits started
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '6',                  '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '6',                  '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',                '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',                 '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'er_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',                  '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '7',                  '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '7',                  '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',                  '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',                  '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',                  '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',                  '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',                '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',                 '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'Transitional Housing','2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '60',                 '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'Government Benefits', '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',                  '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',                  '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',                  '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',                '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'doctor_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',                 '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'missed_appointment';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',                '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'medication_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',                  '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '10',                 '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-01-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_improvement';

-- 2025-05-01 — stable transitional, improving
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '6',                  '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',                '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',                 '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'er_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '6',                  '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '6',                  '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',                  '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',                '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',                 '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'Transitional Housing','2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '180',                '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'Government Benefits', '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',                  '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',                '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'doctor_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',                 '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'missed_appointment';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',                '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'medication_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '15',                 '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2025-05-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_improvement';

-- 2025-09-01 — near permanent housing, much improved
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '6',                  '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '7',                  '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '6',                  '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',                '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',                 '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'er_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',                  '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '6',                  '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',                  '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',                '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',                 '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'Transitional Housing','2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '6',                  '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '300',                '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'Government Benefits', '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',                '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'doctor_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',                 '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'missed_appointment';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',                '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'medication_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '6',                  '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '20',                 '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2025-09-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_improvement';

-- 2025-11-15 — just got permanent housing!
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '7',                  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '7',                  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '7',                  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',                '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',                 '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'er_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '6',                  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '1',                  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',                 '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',                 '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'Permanent Housing',  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '8',                  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '14',                 '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'Government Benefits', '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',                '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'doctor_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',                 '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'missed_appointment';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',                '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'medication_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '7',                  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '25',                 '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '6',                  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '6',                  '2025-11-15', 0 FROM TrackingMetric WHERE MetricKey = 'self_improvement';

-- 2026-02-01 — settled in permanent housing, strong recovery
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '8',                  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_rated_health';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '8',                  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_hours';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '7',                  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'sleep_quality';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '2',                  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'pain_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',                '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'medications_taken';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',                 '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'er_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'mood_score';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'anxiety_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'stress_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'feeling_safe';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'hopefulness';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '3',                  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'meals_today';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'food_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '7',                  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'water_intake';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '0',                  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'alcohol_units';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',                 '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'smoking';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',                 '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'drug_use';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'Permanent Housing',  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_status';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '9',                  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'housing_security';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '78',                 '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'days_housed';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'Government Benefits', '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'income_source';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '4',                  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'afford_essentials';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '6',                  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'social_interactions';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'support_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',                '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'doctor_visit';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'no',                 '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'missed_appointment';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, 'yes',                '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'medication_access';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '8',                  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'energy_level';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '5',                  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'task_completion';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '30',                 '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'exercise_minutes';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '8',                  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'goal_progress';
INSERT IGNORE INTO TrackingEntry (ParticipantID, MetricID, Value, EntryDate, IsBaseline) SELECT 34, MetricID, '8',                  '2026-02-01', 0 FROM TrackingMetric WHERE MetricKey = 'self_improvement';
