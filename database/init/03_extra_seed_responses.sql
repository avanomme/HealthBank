-- ============================================================================
-- EXTRA SEED DATA: Expanded responses for Researcher & Participant data views
-- Run: docker compose exec mysql mysql -u root -ppassword healthdatabase < database/init/extra_seed_responses.sql
-- ============================================================================

-- ============================================================================
-- PART 0: Test user seed data — part@hb.com (AccountID 2)
-- ============================================================================

-- Test participant (AccountID 2, part@hb.com) — assign and complete Survey 1
INSERT INTO SurveyAssignment (SurveyID, AccountID, AssignedAt, DueDate, CompletedAt, Status) VALUES
(1, 2, '2026-01-05 10:00:00', '2026-03-31 23:59:59', '2026-01-10 14:30:00', 'completed');
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(1, 2, 1, '25-34'), (1, 2, 2, 'Male'), (1, 2, 3, 'Student'),
(1, 2, 11, '4'), (1, 2, 12, 'None'), (1, 2, 13, '2'),
(1, 2, 15, 'Within the last 6 months'), (1, 2, 16, 'No, never'),
(1, 2, 17, 'Weekly'), (1, 2, 18, '7');

-- ============================================================================
-- PART 1: Complete all pending Survey 1 assignments (Q1 2026 Health Assessment)
-- Questions: Q1(single),Q2(single),Q3(single),Q11(number),Q12(multi),Q13(scale),Q15(single),Q16(single),Q17(single),Q18(scale)
-- ============================================================================

-- Participant 12 (AccountID 12) - pending
UPDATE SurveyAssignment SET CompletedAt = '2026-01-28 09:15:00', Status = 'completed' WHERE SurveyID = 1 AND AccountID = 12;
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(1, 12, 1, '25-34'), (1, 12, 2, 'Female'), (1, 12, 3, 'Student'),
(1, 12, 11, '5'), (1, 12, 12, 'None'), (1, 12, 13, '1'),
(1, 12, 15, 'Within the last 6 months'), (1, 12, 16, 'No, never'),
(1, 12, 17, 'Rarely (a few times a year)'), (1, 12, 18, '8');

-- Participant 13 - pending
UPDATE SurveyAssignment SET CompletedAt = '2026-01-29 11:00:00', Status = 'completed' WHERE SurveyID = 1 AND AccountID = 13;
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(1, 13, 1, '45-54'), (1, 13, 2, 'Male'), (1, 13, 3, 'Employed full-time'),
(1, 13, 11, '2'), (1, 13, 12, 'Hypertension'), (1, 13, 13, '4'),
(1, 13, 15, '6-12 months ago'), (1, 13, 16, 'No, I quit'),
(1, 13, 17, 'Monthly'), (1, 13, 18, '5');

-- Participant 15 - pending
UPDATE SurveyAssignment SET CompletedAt = '2026-01-30 14:20:00', Status = 'completed' WHERE SurveyID = 1 AND AccountID = 15;
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(1, 15, 1, '35-44'), (1, 15, 2, 'Female'), (1, 15, 3, 'Self-employed'),
(1, 15, 11, '4'), (1, 15, 12, 'Asthma'), (1, 15, 13, '2'),
(1, 15, 15, 'Within the last 6 months'), (1, 15, 16, 'No, never'),
(1, 15, 17, 'Weekly'), (1, 15, 18, '7');

-- Participant 16 - pending
UPDATE SurveyAssignment SET CompletedAt = '2026-02-01 08:45:00', Status = 'completed' WHERE SurveyID = 1 AND AccountID = 16;
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(1, 16, 1, '55-64'), (1, 16, 2, 'Male'), (1, 16, 3, 'Retired'),
(1, 16, 11, '3'), (1, 16, 12, 'Diabetes,Hypertension'), (1, 16, 13, '5'),
(1, 16, 15, 'Within the last 6 months'), (1, 16, 16, 'No, I quit'),
(1, 16, 17, 'Rarely (a few times a year)'), (1, 16, 18, '6');

-- Participant 18 - pending
UPDATE SurveyAssignment SET CompletedAt = '2026-02-02 10:30:00', Status = 'completed' WHERE SurveyID = 1 AND AccountID = 18;
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(1, 18, 1, '18-24'), (1, 18, 2, 'Non-binary'), (1, 18, 3, 'Student'),
(1, 18, 11, '6'), (1, 18, 12, 'None'), (1, 18, 13, '1'),
(1, 18, 15, '1-2 years ago'), (1, 18, 16, 'No, never'),
(1, 18, 17, 'Monthly'), (1, 18, 18, '7');

-- Participant 19 - pending
UPDATE SurveyAssignment SET CompletedAt = '2026-02-03 13:15:00', Status = 'completed' WHERE SurveyID = 1 AND AccountID = 19;
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(1, 19, 1, '25-34'), (1, 19, 2, 'Female'), (1, 19, 3, 'Employed part-time'),
(1, 19, 11, '3'), (1, 19, 12, 'None'), (1, 19, 13, '2'),
(1, 19, 15, '6-12 months ago'), (1, 19, 16, 'Yes, occasionally'),
(1, 19, 17, 'Weekly'), (1, 19, 18, '6');

-- Participant 21 - pending
UPDATE SurveyAssignment SET CompletedAt = '2026-02-04 09:00:00', Status = 'completed' WHERE SurveyID = 1 AND AccountID = 21;
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(1, 21, 1, '65+'), (1, 21, 2, 'Male'), (1, 21, 3, 'Retired'),
(1, 21, 11, '2'), (1, 21, 12, 'Arthritis,Heart disease'), (1, 21, 13, '6'),
(1, 21, 15, 'Within the last 6 months'), (1, 21, 16, 'No, I quit'),
(1, 21, 17, 'Never'), (1, 21, 18, '5');

-- Participant 23 - pending
UPDATE SurveyAssignment SET CompletedAt = '2026-02-05 11:45:00', Status = 'completed' WHERE SurveyID = 1 AND AccountID = 23;
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(1, 23, 1, '35-44'), (1, 23, 2, 'Female'), (1, 23, 3, 'Employed full-time'),
(1, 23, 11, '4'), (1, 23, 12, 'None'), (1, 23, 13, '3'),
(1, 23, 15, '6-12 months ago'), (1, 23, 16, 'No, never'),
(1, 23, 17, 'Monthly'), (1, 23, 18, '7');

-- Participant 24 - pending
UPDATE SurveyAssignment SET CompletedAt = '2026-02-05 16:00:00', Status = 'completed' WHERE SurveyID = 1 AND AccountID = 24;
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(1, 24, 1, '45-54'), (1, 24, 2, 'Male'), (1, 24, 3, 'Self-employed'),
(1, 24, 11, '1'), (1, 24, 12, 'Diabetes'), (1, 24, 13, '4'),
(1, 24, 15, 'More than 2 years ago'), (1, 24, 16, 'Yes, daily'),
(1, 24, 17, 'Daily'), (1, 24, 18, '4');

-- Participant 25 - pending
UPDATE SurveyAssignment SET CompletedAt = '2026-02-06 08:30:00', Status = 'completed' WHERE SurveyID = 1 AND AccountID = 25;
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(1, 25, 1, '25-34'), (1, 25, 2, 'Prefer not to say'), (1, 25, 3, 'Employed full-time'),
(1, 25, 11, '5'), (1, 25, 12, 'None'), (1, 25, 13, '1'),
(1, 25, 15, 'Within the last 6 months'), (1, 25, 16, 'No, never'),
(1, 25, 17, 'Rarely (a few times a year)'), (1, 25, 18, '8');

-- ============================================================================
-- PART 2: Assign + complete remaining participants for Survey 1
-- AccountIDs 20, 26, 27, 28, 29, 30, 31, 32, 33 not yet assigned
-- ============================================================================

INSERT INTO SurveyAssignment (SurveyID, AccountID, AssignedAt, DueDate, CompletedAt, Status) VALUES
(1, 20, '2026-01-15 09:00:00', '2026-02-15 23:59:59', '2026-02-01 15:00:00', 'completed'),
(1, 26, '2026-01-15 09:00:00', '2026-02-15 23:59:59', '2026-02-02 09:30:00', 'completed'),
(1, 27, '2026-01-15 09:00:00', '2026-02-15 23:59:59', '2026-02-02 14:00:00', 'completed'),
(1, 28, '2026-01-15 09:00:00', '2026-02-15 23:59:59', '2026-02-03 11:15:00', 'completed'),
(1, 29, '2026-01-15 09:00:00', '2026-02-15 23:59:59', '2026-02-04 10:45:00', 'completed'),
(1, 30, '2026-01-15 09:00:00', '2026-02-15 23:59:59', '2026-02-05 08:00:00', 'completed'),
(1, 31, '2026-01-15 09:00:00', '2026-02-15 23:59:59', '2026-02-05 16:30:00', 'completed'),
(1, 32, '2026-01-15 09:00:00', '2026-02-15 23:59:59', '2026-02-06 09:00:00', 'completed'),
(1, 33, '2026-01-15 09:00:00', '2026-02-15 23:59:59', '2026-02-07 13:20:00', 'completed');

INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
-- Participant 20
(1, 20, 1, '18-24'), (1, 20, 2, 'Female'), (1, 20, 3, 'Student'),
(1, 20, 11, '5'), (1, 20, 12, 'None'), (1, 20, 13, '1'),
(1, 20, 15, '1-2 years ago'), (1, 20, 16, 'No, never'),
(1, 20, 17, 'Rarely (a few times a year)'), (1, 20, 18, '7'),
-- Participant 26
(1, 26, 1, '35-44'), (1, 26, 2, 'Male'), (1, 26, 3, 'Employed full-time'),
(1, 26, 11, '3'), (1, 26, 12, 'Hypertension'), (1, 26, 13, '3'),
(1, 26, 15, '6-12 months ago'), (1, 26, 16, 'No, I quit'),
(1, 26, 17, 'Monthly'), (1, 26, 18, '6'),
-- Participant 27
(1, 27, 1, '55-64'), (1, 27, 2, 'Female'), (1, 27, 3, 'Retired'),
(1, 27, 11, '2'), (1, 27, 12, 'Arthritis'), (1, 27, 13, '5'),
(1, 27, 15, 'Within the last 6 months'), (1, 27, 16, 'No, never'),
(1, 27, 17, 'Never'), (1, 27, 18, '6'),
-- Participant 28
(1, 28, 1, '25-34'), (1, 28, 2, 'Male'), (1, 28, 3, 'Employed full-time'),
(1, 28, 11, '4'), (1, 28, 12, 'Asthma'), (1, 28, 13, '2'),
(1, 28, 15, '6-12 months ago'), (1, 28, 16, 'No, never'),
(1, 28, 17, 'Weekly'), (1, 28, 18, '7'),
-- Participant 29
(1, 29, 1, '45-54'), (1, 29, 2, 'Female'), (1, 29, 3, 'Employed part-time'),
(1, 29, 11, '3'), (1, 29, 12, 'Diabetes'), (1, 29, 13, '3'),
(1, 29, 15, '1-2 years ago'), (1, 29, 16, 'Yes, occasionally'),
(1, 29, 17, 'Monthly'), (1, 29, 18, '5'),
-- Participant 30
(1, 30, 1, '65+'), (1, 30, 2, 'Male'), (1, 30, 3, 'Retired'),
(1, 30, 11, '1'), (1, 30, 12, 'Diabetes,Hypertension,Heart disease'), (1, 30, 13, '7'),
(1, 30, 15, 'Within the last 6 months'), (1, 30, 16, 'No, I quit'),
(1, 30, 17, 'Never'), (1, 30, 18, '5'),
-- Participant 31
(1, 31, 1, '18-24'), (1, 31, 2, 'Non-binary'), (1, 31, 3, 'Student'),
(1, 31, 11, '6'), (1, 31, 12, 'None'), (1, 31, 13, '1'),
(1, 31, 15, '1-2 years ago'), (1, 31, 16, 'No, never'),
(1, 31, 17, 'Monthly'), (1, 31, 18, '8'),
-- Participant 32
(1, 32, 1, '35-44'), (1, 32, 2, 'Female'), (1, 32, 3, 'Self-employed'),
(1, 32, 11, '4'), (1, 32, 12, 'None'), (1, 32, 13, '2'),
(1, 32, 15, '6-12 months ago'), (1, 32, 16, 'No, never'),
(1, 32, 17, 'Weekly'), (1, 32, 18, '7'),
-- Participant 33
(1, 33, 1, '25-34'), (1, 33, 2, 'Male'), (1, 33, 3, 'Employed full-time'),
(1, 33, 11, '3'), (1, 33, 12, 'None'), (1, 33, 13, '2'),
(1, 33, 15, 'Within the last 6 months'), (1, 33, 16, 'No, never'),
(1, 33, 17, 'Rarely (a few times a year)'), (1, 33, 18, '6');


-- ============================================================================
-- PART 3: Complete all pending Survey 2 assignments (Mental Health Weekly Check-in)
-- Questions: Q6(scale),Q7(scale),Q8(single),Q9(single),Q10(yesno)
-- ============================================================================

-- Participant 12 - pending
UPDATE SurveyAssignment SET CompletedAt = '2026-01-12 09:30:00', Status = 'completed' WHERE SurveyID = 2 AND AccountID = 12;
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(2, 12, 6, '4'), (2, 12, 7, '7'), (2, 12, 8, 'Several days'),
(2, 12, 9, 'Good'), (2, 12, 10, 'true');

-- Participant 17 - pending
UPDATE SurveyAssignment SET CompletedAt = '2026-01-12 14:00:00', Status = 'completed' WHERE SurveyID = 2 AND AccountID = 17;
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(2, 17, 6, '6'), (2, 17, 7, '5'), (2, 17, 8, 'More than half the days'),
(2, 17, 9, 'Neutral'), (2, 17, 10, 'true');

-- Participant 21 - pending
UPDATE SurveyAssignment SET CompletedAt = '2026-01-13 08:15:00', Status = 'completed' WHERE SurveyID = 2 AND AccountID = 21;
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(2, 21, 6, '3'), (2, 21, 7, '6'), (2, 21, 8, 'Not at all'),
(2, 21, 9, 'Good'), (2, 21, 10, 'true');

-- Assign + complete more participants for Survey 2
INSERT INTO SurveyAssignment (SurveyID, AccountID, AssignedAt, DueDate, CompletedAt, Status) VALUES
(2, 13, '2026-01-06 09:00:00', '2026-01-13 23:59:59', '2026-01-10 16:00:00', 'completed'),
(2, 15, '2026-01-06 09:00:00', '2026-01-13 23:59:59', '2026-01-11 09:00:00', 'completed'),
(2, 16, '2026-01-06 09:00:00', '2026-01-13 23:59:59', '2026-01-11 14:30:00', 'completed'),
(2, 18, '2026-01-06 09:00:00', '2026-01-13 23:59:59', '2026-01-12 08:00:00', 'completed'),
(2, 20, '2026-01-06 09:00:00', '2026-01-13 23:59:59', '2026-01-12 11:45:00', 'completed'),
(2, 22, '2026-01-06 09:00:00', '2026-01-13 23:59:59', '2026-01-12 15:30:00', 'completed'),
(2, 24, '2026-01-06 09:00:00', '2026-01-13 23:59:59', '2026-01-13 09:00:00', 'completed'),
(2, 25, '2026-01-06 09:00:00', '2026-01-13 23:59:59', '2026-01-13 10:30:00', 'completed'),
(2, 26, '2026-01-06 09:00:00', '2026-01-13 23:59:59', '2026-01-13 14:00:00', 'completed'),
(2, 27, '2026-01-06 09:00:00', '2026-01-13 23:59:59', '2026-01-13 16:00:00', 'completed'),
(2, 28, '2026-01-06 09:00:00', '2026-01-13 23:59:59', '2026-01-13 17:30:00', 'completed'),
(2, 29, '2026-01-06 09:00:00', '2026-01-13 23:59:59', '2026-01-13 19:00:00', 'completed'),
(2, 30, '2026-01-06 09:00:00', '2026-01-13 23:59:59', '2026-01-13 20:00:00', 'completed');

INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(2, 13, 6, '5'), (2, 13, 7, '6'), (2, 13, 8, 'Several days'), (2, 13, 9, 'Neutral'), (2, 13, 10, 'true'),
(2, 15, 6, '7'), (2, 15, 7, '4'), (2, 15, 8, 'More than half the days'), (2, 15, 9, 'Low'), (2, 15, 10, 'false'),
(2, 16, 6, '3'), (2, 16, 7, '7'), (2, 16, 8, 'Not at all'), (2, 16, 9, 'Good'), (2, 16, 10, 'true'),
(2, 18, 6, '8'), (2, 18, 7, '3'), (2, 18, 8, 'Nearly every day'), (2, 18, 9, 'Low'), (2, 18, 10, 'true'),
(2, 20, 6, '6'), (2, 20, 7, '5'), (2, 20, 8, 'Several days'), (2, 20, 9, 'Neutral'), (2, 20, 10, 'true'),
(2, 22, 6, '4'), (2, 22, 7, '8'), (2, 22, 8, 'Not at all'), (2, 22, 9, 'Very good'), (2, 22, 10, 'true'),
(2, 24, 6, '9'), (2, 24, 7, '2'), (2, 24, 8, 'Nearly every day'), (2, 24, 9, 'Very low'), (2, 24, 10, 'false'),
(2, 25, 6, '5'), (2, 25, 7, '6'), (2, 25, 8, 'Several days'), (2, 25, 9, 'Good'), (2, 25, 10, 'true'),
(2, 26, 6, '4'), (2, 26, 7, '7'), (2, 26, 8, 'Not at all'), (2, 26, 9, 'Good'), (2, 26, 10, 'true'),
(2, 27, 6, '6'), (2, 27, 7, '5'), (2, 27, 8, 'Several days'), (2, 27, 9, 'Neutral'), (2, 27, 10, 'true'),
(2, 28, 6, '3'), (2, 28, 7, '8'), (2, 28, 8, 'Not at all'), (2, 28, 9, 'Very good'), (2, 28, 10, 'true'),
(2, 29, 6, '7'), (2, 29, 7, '4'), (2, 29, 8, 'More than half the days'), (2, 29, 9, 'Low'), (2, 29, 10, 'false'),
(2, 30, 6, '5'), (2, 30, 7, '6'), (2, 30, 8, 'Several days'), (2, 30, 9, 'Neutral'), (2, 30, 10, 'true');


-- ============================================================================
-- PART 4: Complete all pending Survey 3 assignments (Lifestyle Habits Study)
-- Questions: Q11(number),Q16(single),Q17(single),Q18(scale),Q19(number),Q20(number),Q7(scale)
-- ============================================================================

-- Participant 13 - pending
UPDATE SurveyAssignment SET CompletedAt = '2026-02-01 10:00:00', Status = 'completed' WHERE SurveyID = 3 AND AccountID = 13;
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(3, 13, 11, '2'), (3, 13, 16, 'No, I quit'), (3, 13, 17, 'Monthly'),
(3, 13, 18, '5'), (3, 13, 19, '6'), (3, 13, 20, '4'), (3, 13, 7, '6');

-- Participant 15 - pending
UPDATE SurveyAssignment SET CompletedAt = '2026-02-01 14:30:00', Status = 'completed' WHERE SurveyID = 3 AND AccountID = 15;
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(3, 15, 11, '4'), (3, 15, 16, 'No, never'), (3, 15, 17, 'Weekly'),
(3, 15, 18, '7'), (3, 15, 19, '8'), (3, 15, 20, '3'), (3, 15, 7, '7');

-- Participant 18 - pending
UPDATE SurveyAssignment SET CompletedAt = '2026-02-02 09:00:00', Status = 'completed' WHERE SurveyID = 3 AND AccountID = 18;
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(3, 18, 11, '6'), (3, 18, 16, 'No, never'), (3, 18, 17, 'Rarely (a few times a year)'),
(3, 18, 18, '8'), (3, 18, 19, '10'), (3, 18, 20, '6'), (3, 18, 7, '5');

-- Participant 22 - pending
UPDATE SurveyAssignment SET CompletedAt = '2026-02-02 15:00:00', Status = 'completed' WHERE SurveyID = 3 AND AccountID = 22;
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(3, 22, 11, '5'), (3, 22, 16, 'No, never'), (3, 22, 17, 'Monthly'),
(3, 22, 18, '7'), (3, 22, 19, '7'), (3, 22, 20, '5'), (3, 22, 7, '8');

-- Participant 26 - pending
UPDATE SurveyAssignment SET CompletedAt = '2026-02-03 10:30:00', Status = 'completed' WHERE SurveyID = 3 AND AccountID = 26;
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(3, 26, 11, '3'), (3, 26, 16, 'No, I quit'), (3, 26, 17, 'Weekly'),
(3, 26, 18, '6'), (3, 26, 19, '5'), (3, 26, 20, '7'), (3, 26, 7, '6');

-- Participant 28 - pending
UPDATE SurveyAssignment SET CompletedAt = '2026-02-03 16:00:00', Status = 'completed' WHERE SurveyID = 3 AND AccountID = 28;
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(3, 28, 11, '4'), (3, 28, 16, 'No, never'), (3, 28, 17, 'Rarely (a few times a year)'),
(3, 28, 18, '7'), (3, 28, 19, '8'), (3, 28, 20, '4'), (3, 28, 7, '7');

-- Participant 29 - pending
UPDATE SurveyAssignment SET CompletedAt = '2026-02-04 11:00:00', Status = 'completed' WHERE SurveyID = 3 AND AccountID = 29;
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(3, 29, 11, '2'), (3, 29, 16, 'Yes, occasionally'), (3, 29, 17, 'Monthly'),
(3, 29, 18, '5'), (3, 29, 19, '4'), (3, 29, 20, '8'), (3, 29, 7, '5');

-- Assign + complete even more participants for Survey 3
INSERT INTO SurveyAssignment (SurveyID, AccountID, AssignedAt, DueDate, CompletedAt, Status) VALUES
(3, 11, '2026-01-15 10:00:00', '2026-02-15 23:59:59', '2026-02-01 11:00:00', 'completed'),
(3, 12, '2026-01-15 10:00:00', '2026-02-15 23:59:59', '2026-02-02 09:30:00', 'completed'),
(3, 14, '2026-01-15 10:00:00', '2026-02-15 23:59:59', '2026-02-02 14:00:00', 'completed'),
(3, 17, '2026-01-15 10:00:00', '2026-02-15 23:59:59', '2026-02-03 10:00:00', 'completed'),
(3, 19, '2026-01-15 10:00:00', '2026-02-15 23:59:59', '2026-02-03 15:30:00', 'completed'),
(3, 20, '2026-01-15 10:00:00', '2026-02-15 23:59:59', '2026-02-04 08:00:00', 'completed'),
(3, 21, '2026-01-15 10:00:00', '2026-02-15 23:59:59', '2026-02-04 12:30:00', 'completed'),
(3, 23, '2026-01-15 10:00:00', '2026-02-15 23:59:59', '2026-02-05 09:00:00', 'completed'),
(3, 25, '2026-01-15 10:00:00', '2026-02-15 23:59:59', '2026-02-05 14:00:00', 'completed'),
(3, 27, '2026-01-15 10:00:00', '2026-02-15 23:59:59', '2026-02-06 10:00:00', 'completed'),
(3, 30, '2026-01-15 10:00:00', '2026-02-15 23:59:59', '2026-02-06 16:00:00', 'completed'),
(3, 31, '2026-01-15 10:00:00', '2026-02-15 23:59:59', '2026-02-07 09:30:00', 'completed'),
(3, 32, '2026-01-15 10:00:00', '2026-02-15 23:59:59', '2026-02-07 14:00:00', 'completed'),
(3, 33, '2026-01-15 10:00:00', '2026-02-15 23:59:59', '2026-02-08 08:00:00', 'completed');

INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(3, 11, 11, '3'), (3, 11, 16, 'No, never'), (3, 11, 17, 'Weekly'), (3, 11, 18, '6'), (3, 11, 19, '7'), (3, 11, 20, '5'), (3, 11, 7, '6'),
(3, 12, 11, '5'), (3, 12, 16, 'No, never'), (3, 12, 17, 'Rarely (a few times a year)'), (3, 12, 18, '8'), (3, 12, 19, '9'), (3, 12, 20, '3'), (3, 12, 7, '7'),
(3, 14, 11, '4'), (3, 14, 16, 'No, never'), (3, 14, 17, 'Monthly'), (3, 14, 18, '7'), (3, 14, 19, '6'), (3, 14, 20, '6'), (3, 14, 7, '6'),
(3, 17, 11, '2'), (3, 17, 16, 'Yes, occasionally'), (3, 17, 17, 'Weekly'), (3, 17, 18, '5'), (3, 17, 19, '4'), (3, 17, 20, '8'), (3, 17, 7, '5'),
(3, 19, 11, '3'), (3, 19, 16, 'No, never'), (3, 19, 17, 'Monthly'), (3, 19, 18, '6'), (3, 19, 19, '7'), (3, 19, 20, '5'), (3, 19, 7, '6'),
(3, 20, 11, '5'), (3, 20, 16, 'No, never'), (3, 20, 17, 'Never'), (3, 20, 18, '7'), (3, 20, 19, '8'), (3, 20, 20, '4'), (3, 20, 7, '7'),
(3, 21, 11, '1'), (3, 21, 16, 'No, I quit'), (3, 21, 17, 'Never'), (3, 21, 18, '5'), (3, 21, 19, '5'), (3, 21, 20, '3'), (3, 21, 7, '6'),
(3, 23, 11, '4'), (3, 23, 16, 'No, never'), (3, 23, 17, 'Monthly'), (3, 23, 18, '7'), (3, 23, 19, '7'), (3, 23, 20, '5'), (3, 23, 7, '7'),
(3, 25, 11, '5'), (3, 25, 16, 'No, never'), (3, 25, 17, 'Rarely (a few times a year)'), (3, 25, 18, '8'), (3, 25, 19, '8'), (3, 25, 20, '4'), (3, 25, 7, '8'),
(3, 27, 11, '2'), (3, 27, 16, 'No, never'), (3, 27, 17, 'Never'), (3, 27, 18, '6'), (3, 27, 19, '6'), (3, 27, 20, '3'), (3, 27, 7, '5'),
(3, 30, 11, '1'), (3, 30, 16, 'No, I quit'), (3, 30, 17, 'Never'), (3, 30, 18, '5'), (3, 30, 19, '4'), (3, 30, 20, '4'), (3, 30, 7, '5'),
(3, 31, 11, '6'), (3, 31, 16, 'No, never'), (3, 31, 17, 'Monthly'), (3, 31, 18, '7'), (3, 31, 19, '9'), (3, 31, 20, '7'), (3, 31, 7, '6'),
(3, 32, 11, '4'), (3, 32, 16, 'No, never'), (3, 32, 17, 'Weekly'), (3, 32, 18, '7'), (3, 32, 19, '7'), (3, 32, 20, '5'), (3, 32, 7, '7'),
(3, 33, 11, '3'), (3, 33, 16, 'No, never'), (3, 33, 17, 'Rarely (a few times a year)'), (3, 33, 18, '6'), (3, 33, 19, '6'), (3, 33, 20, '6'), (3, 33, 7, '6');


-- ============================================================================
-- PART 5: Publish and populate Survey 5 (Chronic Pain Assessment)
-- Questions: Q13(scale),Q14(yesno),Q21(multi),Q22(single),Q23(scale),Q24(openended),Q25(yesno)
-- ============================================================================

UPDATE Survey SET Status = 'in-progress', PublicationStatus = 'published' WHERE SurveyID = 5;

INSERT INTO SurveyAssignment (SurveyID, AccountID, AssignedAt, DueDate, CompletedAt, Status) VALUES
(5, 10, '2026-01-20 09:00:00', '2026-02-20 23:59:59', '2026-01-28 10:00:00', 'completed'),
(5, 11, '2026-01-20 09:00:00', '2026-02-20 23:59:59', '2026-01-29 11:30:00', 'completed'),
(5, 13, '2026-01-20 09:00:00', '2026-02-20 23:59:59', '2026-01-30 09:15:00', 'completed'),
(5, 14, '2026-01-20 09:00:00', '2026-02-20 23:59:59', '2026-01-31 14:00:00', 'completed'),
(5, 15, '2026-01-20 09:00:00', '2026-02-20 23:59:59', '2026-02-01 08:30:00', 'completed'),
(5, 16, '2026-01-20 09:00:00', '2026-02-20 23:59:59', '2026-02-01 16:00:00', 'completed'),
(5, 17, '2026-01-20 09:00:00', '2026-02-20 23:59:59', '2026-02-02 10:00:00', 'completed'),
(5, 19, '2026-01-20 09:00:00', '2026-02-20 23:59:59', '2026-02-02 15:30:00', 'completed'),
(5, 21, '2026-01-20 09:00:00', '2026-02-20 23:59:59', '2026-02-03 09:00:00', 'completed'),
(5, 22, '2026-01-20 09:00:00', '2026-02-20 23:59:59', '2026-02-03 14:00:00', 'completed'),
(5, 24, '2026-01-20 09:00:00', '2026-02-20 23:59:59', '2026-02-04 10:30:00', 'completed'),
(5, 26, '2026-01-20 09:00:00', '2026-02-20 23:59:59', '2026-02-04 16:00:00', 'completed'),
(5, 27, '2026-01-20 09:00:00', '2026-02-20 23:59:59', '2026-02-05 09:00:00', 'completed'),
(5, 29, '2026-01-20 09:00:00', '2026-02-20 23:59:59', '2026-02-05 13:30:00', 'completed'),
(5, 30, '2026-01-20 09:00:00', '2026-02-20 23:59:59', '2026-02-06 08:00:00', 'completed'),
(5, 12, '2026-01-20 09:00:00', '2026-02-20 23:59:59', NULL, 'pending'),
(5, 18, '2026-01-20 09:00:00', '2026-02-20 23:59:59', NULL, 'pending'),
(5, 20, '2026-01-20 09:00:00', '2026-02-20 23:59:59', NULL, 'pending');

INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
-- Participant 10
(5, 10, 13, '3'), (5, 10, 14, 'false'), (5, 10, 21, 'None'),
(5, 10, 22, 'Less than 24 hours'), (5, 10, 23, '2'), (5, 10, 24, 'Occasional lower back stiffness after sitting'), (5, 10, 25, 'false'),
-- Participant 11
(5, 11, 13, '5'), (5, 11, 14, 'true'), (5, 11, 21, 'Fatigue,Headache'),
(5, 11, 22, '1-2 weeks'), (5, 11, 23, '5'), (5, 11, 24, 'Chronic knee pain from old injury'), (5, 11, 25, 'true'),
-- Participant 13
(5, 13, 13, '6'), (5, 13, 14, 'true'), (5, 13, 21, 'Fatigue,Dizziness'),
(5, 13, 22, 'More than 2 weeks'), (5, 13, 23, '6'), (5, 13, 24, 'Persistent joint pain in hands and wrists'), (5, 13, 25, 'true'),
-- Participant 14
(5, 14, 13, '2'), (5, 14, 14, 'false'), (5, 14, 21, 'Headache'),
(5, 14, 22, '1-3 days'), (5, 14, 23, '2'), (5, 14, 24, 'Tension headaches during stressful weeks'), (5, 14, 25, 'false'),
-- Participant 15
(5, 15, 13, '4'), (5, 15, 14, 'false'), (5, 15, 21, 'Fatigue'),
(5, 15, 22, '4-7 days'), (5, 15, 23, '4'), (5, 15, 24, 'General fatigue, possibly work-related stress'), (5, 15, 25, 'false'),
-- Participant 16
(5, 16, 13, '7'), (5, 16, 14, 'true'), (5, 16, 21, 'Fatigue,Nausea,Dizziness'),
(5, 16, 22, 'More than 2 weeks'), (5, 16, 23, '7'), (5, 16, 24, 'Chronic back pain and frequent nausea'), (5, 16, 25, 'true'),
-- Participant 17
(5, 17, 13, '4'), (5, 17, 14, 'false'), (5, 17, 21, 'Headache,Fatigue'),
(5, 17, 22, '4-7 days'), (5, 17, 23, '4'), (5, 17, 24, 'Recurring migraines twice a month'), (5, 17, 25, 'true'),
-- Participant 19
(5, 19, 13, '3'), (5, 19, 14, 'false'), (5, 19, 21, 'None'),
(5, 19, 22, 'Less than 24 hours'), (5, 19, 23, '3'), (5, 19, 24, 'Minor aches after exercise'), (5, 19, 25, 'false'),
-- Participant 21
(5, 21, 13, '8'), (5, 21, 14, 'true'), (5, 21, 21, 'Fatigue,Shortness of breath'),
(5, 21, 22, 'More than 2 weeks'), (5, 21, 23, '8'), (5, 21, 24, 'Arthritis in both knees, difficulty walking'), (5, 21, 25, 'true'),
-- Participant 22
(5, 22, 13, '2'), (5, 22, 14, 'false'), (5, 22, 21, 'None'),
(5, 22, 22, 'Less than 24 hours'), (5, 22, 23, '1'), (5, 22, 24, 'No significant pain issues'), (5, 22, 25, 'false'),
-- Participant 24
(5, 24, 13, '6'), (5, 24, 14, 'true'), (5, 24, 21, 'Headache,Fatigue,Nausea'),
(5, 24, 22, '1-2 weeks'), (5, 24, 23, '6'), (5, 24, 24, 'Fibromyalgia symptoms flaring up'), (5, 24, 25, 'true'),
-- Participant 26
(5, 26, 13, '4'), (5, 26, 14, 'false'), (5, 26, 21, 'Headache'),
(5, 26, 22, '1-3 days'), (5, 26, 23, '3'), (5, 26, 24, 'Occasional headaches, likely dehydration'), (5, 26, 25, 'false'),
-- Participant 27
(5, 27, 13, '7'), (5, 27, 14, 'true'), (5, 27, 21, 'Fatigue,Dizziness'),
(5, 27, 22, 'More than 2 weeks'), (5, 27, 23, '7'), (5, 27, 24, 'Hip replacement recovery, limited mobility'), (5, 27, 25, 'true'),
-- Participant 29
(5, 29, 13, '5'), (5, 29, 14, 'true'), (5, 29, 21, 'Fatigue,Cough'),
(5, 29, 22, '4-7 days'), (5, 29, 23, '5'), (5, 29, 24, 'Persistent cough and general tiredness'), (5, 29, 25, 'true'),
-- Participant 30
(5, 30, 13, '8'), (5, 30, 14, 'true'), (5, 30, 21, 'Fatigue,Shortness of breath,Dizziness'),
(5, 30, 22, 'More than 2 weeks'), (5, 30, 23, '8'), (5, 30, 24, 'Heart condition causing chronic fatigue and breathlessness'), (5, 30, 25, 'true');
