-- Created with the Assistance of Claude Code
-- HealthBank Seed Data
-- Comprehensive test data for development and API testing
-- Run AFTER create_database.sql

USE healthdatabase;

-- ============================================================================
-- USER ACCOUNTS SEED DATA
-- Original test users (4) + 5 researchers, 3 HCPs, 20 participants = 33 users total
-- ALL PASSWORDS ARE: password
-- ============================================================================

-- Insert password hashes into Auth table (33 users)
-- ALL PASSWORDS ARE: password
-- Hash format: pbkdf2_sha256$iterations$dklen$salt_base64=$hash_base64
INSERT INTO Auth (AuthID, PasswordHash) VALUES
-- Original test users (1-4) - admin@hb.com, part@hb.com, hcp@hb.com, research@hb.com
(1, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(2, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(3, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(4, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
-- Additional Researchers (5-9)
(5, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(6, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(7, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(8, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(9, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
-- Additional HCPs (10-12)
(10, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(11, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(12, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
-- Participants (13-33)
(13, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(14, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(15, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(16, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(17, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(18, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(19, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(20, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(21, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(22, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(23, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(24, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(25, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(26, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(27, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(28, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(29, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(30, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(31, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(32, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0='),
(33, 'pbkdf2_sha256$210000$32$VEVTVFNBTFQxMjM0NTY3OA==$zovJYLkHcIuPbtOoEBRvHV93mWdQmngFyW8qrECGks0=');

-- Insert user accounts linked to auth records
-- RoleID: 1=participant, 2=researcher, 3=hcp, 4=admin
-- ALL PASSWORDS ARE: password
INSERT INTO AccountData (AccountID, FirstName, LastName, Email, AuthID, RoleID, IsActive, CreatedAt) VALUES
-- Original test users (1-4) - simple @hb.com emails for testing
(1, 'Admin', 'User', 'admin@hb.com', 1, 4, TRUE, '2024-01-01 09:00:00'),
(2, 'Participant', 'User', 'part@hb.com', 2, 1, TRUE, '2024-01-01 09:00:00'),
(3, 'HCP', 'User', 'hcp@hb.com', 3, 3, TRUE, '2024-01-01 09:00:00'),
(4, 'Research', 'User', 'research@hb.com', 4, 2, TRUE, '2024-01-01 09:00:00'),

-- Additional Researchers (5-9)
(5, 'Sarah', 'Chen', 'sarah.chen@healthbank.com', 5, 2, TRUE, '2024-01-15 10:30:00'),
(6, 'Michael', 'Rodriguez', 'michael.rodriguez@healthbank.com', 6, 2, TRUE, '2024-02-01 14:00:00'),
(7, 'Emily', 'Thompson', 'emily.thompson@healthbank.com', 7, 2, TRUE, '2024-02-15 09:15:00'),
(8, 'David', 'Kim', 'david.kim@healthbank.com', 8, 2, TRUE, '2024-03-01 11:45:00'),
(9, 'Jennifer', 'Patel', 'jennifer.patel@healthbank.com', 9, 2, FALSE, '2024-03-15 16:00:00'),

-- Additional HCPs (10-12)
(10, 'Dr. Robert', 'Williams', 'dr.williams@healthbank.com', 10, 3, TRUE, '2024-01-20 08:00:00'),
(11, 'Dr. Amanda', 'Johnson', 'dr.johnson@healthbank.com', 11, 3, TRUE, '2024-02-10 10:00:00'),
(12, 'Dr. James', 'Brown', 'dr.brown@healthbank.com', 12, 3, TRUE, '2024-03-05 13:30:00'),

-- Participants (13-33) - 21 additional participants with varied demographics
(13, 'John', 'Smith', 'john.smith@email.com', 13, 1, TRUE, '2024-04-01 09:00:00'),
(14, 'Maria', 'Garcia', 'maria.garcia@email.com', 14, 1, TRUE, '2024-04-02 10:30:00'),
(15, 'James', 'Wilson', 'james.wilson@email.com', 15, 1, TRUE, '2024-04-03 14:15:00'),
(16, 'Linda', 'Martinez', 'linda.martinez@email.com', 16, 1, TRUE, '2024-04-05 11:00:00'),
(17, 'Robert', 'Anderson', 'robert.anderson@email.com', 17, 1, TRUE, '2024-04-08 08:45:00'),
(18, 'Patricia', 'Taylor', 'patricia.taylor@email.com', 18, 1, TRUE, '2024-04-10 16:30:00'),
(19, 'William', 'Thomas', 'william.thomas@email.com', 19, 1, TRUE, '2024-04-12 09:20:00'),
(20, 'Elizabeth', 'Hernandez', 'elizabeth.hernandez@email.com', 20, 1, TRUE, '2024-04-15 13:00:00'),
(21, 'David', 'Moore', 'david.moore@email.com', 21, 1, TRUE, '2024-04-18 10:45:00'),
(22, 'Jennifer', 'Jackson', 'jennifer.jackson@email.com', 22, 1, TRUE, '2024-04-20 15:15:00'),
(23, 'Richard', 'Martin', 'richard.martin@email.com', 23, 1, FALSE, '2024-04-22 08:30:00'),
(24, 'Susan', 'Lee', 'susan.lee@email.com', 24, 1, TRUE, '2024-04-25 11:45:00'),
(25, 'Joseph', 'Perez', 'joseph.perez@email.com', 25, 1, TRUE, '2024-04-28 14:00:00'),
(26, 'Margaret', 'White', 'margaret.white@email.com', 26, 1, TRUE, '2024-05-01 09:30:00'),
(27, 'Charles', 'Harris', 'charles.harris@email.com', 27, 1, TRUE, '2024-05-05 16:00:00'),
(28, 'Dorothy', 'Clark', 'dorothy.clark@email.com', 28, 1, TRUE, '2024-05-08 10:15:00'),
(29, 'Thomas', 'Lewis', 'thomas.lewis@email.com', 29, 1, TRUE, '2024-05-12 13:45:00'),
(30, 'Nancy', 'Robinson', 'nancy.robinson@email.com', 30, 1, FALSE, '2024-05-15 08:00:00'),
(31, 'Christopher', 'Walker', 'christopher.walker@email.com', 31, 1, TRUE, '2024-05-18 11:30:00'),
(32, 'Karen', 'Hall', 'karen.hall@email.com', 32, 1, TRUE, '2024-05-20 15:45:00'),
(33, 'Daniel', 'Young', 'daniel.young@email.com', 33, 1, TRUE, '2024-05-22 10:00:00');

-- Mark all seeded accounts as having signed the current consent version
-- (AccountData.ConsentVersion is the field checked at login for has_signed_consent)
UPDATE AccountData SET ConsentVersion = '1.0' WHERE AccountID BETWEEN 1 AND 33;

-- ============================================================================
-- DATA TYPES SEED DATA
-- Types of health data that can be collected
-- ============================================================================

INSERT INTO DataTypes (DataID, Name, Description) VALUES
(1, 'Vital Signs', 'Blood pressure, heart rate, temperature, respiratory rate'),
(2, 'Body Measurements', 'Height, weight, BMI, body fat percentage'),
(3, 'Blood Work', 'Complete blood count, metabolic panel, lipid panel'),
(4, 'Mental Health Scores', 'PHQ-9, GAD-7, stress scales, mood assessments'),
(5, 'Activity Data', 'Steps, exercise minutes, sleep hours, sedentary time'),
(6, 'Medication Records', 'Current medications, dosages, adherence data'),
(7, 'Dietary Information', 'Caloric intake, macronutrients, meal frequency'),
(8, 'Symptom Reports', 'Pain levels, symptom frequency, severity ratings'),
(9, 'Lab Results', 'Glucose, cholesterol, thyroid, vitamin levels'),
(10, 'Immunization Records', 'Vaccination history, dates, types');

-- ============================================================================
-- QUESTION BANK SEED DATA
-- Categories: Demographics, Mental Health, Physical Health, Lifestyle, Symptoms
-- ============================================================================

-- Demographics Questions (1-5)
INSERT INTO QuestionBank (QuestionID, Title, QuestionContent, ResponseType, Category, QuestionData) VALUES
(1, 'Age Range', 'What is your age range?', 'single_choice', 'demographics', 2),
(2, 'Gender Identity', 'How do you identify your gender?', 'single_choice', 'demographics', NULL),
(3, 'Occupation Status', 'What is your current occupation status?', 'single_choice', 'demographics', NULL),
(4, 'Living Situation', 'What best describes your current living situation?', 'single_choice', 'demographics', NULL),
(5, 'Years at Current Address', 'How many years have you lived at your current address?', 'number', 'demographics', NULL);

-- Options for Demographics Questions
INSERT INTO QuestionOptions (QuestionID, OptionText, DisplayOrder) VALUES
-- Age Range options
(1, '18-24', 0), (1, '25-34', 1), (1, '35-44', 2), (1, '45-54', 3), (1, '55-64', 4), (1, '65+', 5),
-- Gender Identity options
(2, 'Male', 0), (2, 'Female', 1), (2, 'Non-binary', 2), (2, 'Prefer not to say', 3),
-- Occupation Status options
(3, 'Employed full-time', 0), (3, 'Employed part-time', 1), (3, 'Self-employed', 2), (3, 'Unemployed', 3), (3, 'Retired', 4), (3, 'Student', 5),
-- Living Situation options
(4, 'Own home', 0), (4, 'Rent apartment', 1), (4, 'Live with family', 2), (4, 'Shared housing', 3), (4, 'Other', 4);

-- Mental Health Questions (6-10)
INSERT INTO QuestionBank (QuestionID, Title, QuestionContent, ResponseType, Category, QuestionData) VALUES
(6, 'Stress Level', 'How would you rate your current stress level?', 'scale', 'mental_health', 4),
(7, 'Sleep Quality', 'How would you rate your sleep quality over the past week?', 'scale', 'mental_health', 4),
(8, 'Anxiety Frequency', 'How often have you felt anxious in the past two weeks?', 'single_choice', 'mental_health', 4),
(9, 'Mood Description', 'How would you describe your overall mood today?', 'single_choice', 'mental_health', 4),
(10, 'Support System', 'Do you have someone you can talk to when you feel overwhelmed?', 'yesno', 'mental_health', 4);

-- Options for Mental Health Questions
INSERT INTO QuestionOptions (QuestionID, OptionText, DisplayOrder) VALUES
-- Anxiety Frequency options
(8, 'Not at all', 0), (8, 'Several days', 1), (8, 'More than half the days', 2), (8, 'Nearly every day', 3),
-- Mood Description options
(9, 'Very good', 0), (9, 'Good', 1), (9, 'Neutral', 2), (9, 'Low', 3), (9, 'Very low', 4);

-- Physical Health Questions (11-15)
INSERT INTO QuestionBank (QuestionID, Title, QuestionContent, ResponseType, Category, QuestionData) VALUES
(11, 'Exercise Frequency', 'How many days per week do you exercise for at least 30 minutes?', 'number', 'physical_health', 5),
(12, 'Chronic Conditions', 'Do you have any chronic health conditions?', 'multi_choice', 'physical_health', 3),
(13, 'Pain Level', 'Please rate your current pain level', 'scale', 'physical_health', 8),
(14, 'Physical Limitations', 'Do you experience any physical limitations in daily activities?', 'yesno', 'physical_health', 8),
(15, 'Last Checkup', 'When was your last general health checkup?', 'single_choice', 'physical_health', 1);

-- Options for Physical Health Questions
INSERT INTO QuestionOptions (QuestionID, OptionText, DisplayOrder) VALUES
-- Chronic Conditions options (multi_choice)
(12, 'Diabetes', 0), (12, 'Hypertension', 1), (12, 'Heart disease', 2), (12, 'Asthma', 3), (12, 'Arthritis', 4), (12, 'None', 5),
-- Last Checkup options
(15, 'Within the last 6 months', 0), (15, '6-12 months ago', 1), (15, '1-2 years ago', 2), (15, 'More than 2 years ago', 3), (15, 'Never', 4);

-- Lifestyle Questions (16-20)
INSERT INTO QuestionBank (QuestionID, Title, QuestionContent, ResponseType, Category, QuestionData) VALUES
(16, 'Smoking Status', 'Do you currently smoke or use tobacco products?', 'single_choice', 'lifestyle', 7),
(17, 'Alcohol Consumption', 'How often do you consume alcoholic beverages?', 'single_choice', 'lifestyle', 7),
(18, 'Diet Quality', 'How would you rate the overall quality of your diet?', 'scale', 'lifestyle', 7),
(19, 'Water Intake', 'How many glasses of water do you drink per day on average?', 'number', 'lifestyle', 7),
(20, 'Screen Time', 'How many hours per day do you spend looking at screens (phone, computer, TV)?', 'number', 'lifestyle', 5);

-- Options for Lifestyle Questions
INSERT INTO QuestionOptions (QuestionID, OptionText, DisplayOrder) VALUES
-- Smoking Status options
(16, 'Yes, daily', 0), (16, 'Yes, occasionally', 1), (16, 'No, I quit', 2), (16, 'No, never', 3),
-- Alcohol Consumption options
(17, 'Never', 0), (17, 'Rarely (a few times a year)', 1), (17, 'Monthly', 2), (17, 'Weekly', 3), (17, 'Daily', 4);

-- Symptoms Questions (21-25)
INSERT INTO QuestionBank (QuestionID, Title, QuestionContent, ResponseType, Category, QuestionData) VALUES
(21, 'Current Symptoms', 'Which of the following symptoms are you currently experiencing?', 'multi_choice', 'symptoms', 8),
(22, 'Symptom Duration', 'How long have you been experiencing these symptoms?', 'single_choice', 'symptoms', 8),
(23, 'Symptom Severity', 'How severe are your current symptoms?', 'scale', 'symptoms', 8),
(24, 'Symptom Description', 'Please describe any other symptoms or concerns you have.', 'openended', 'symptoms', 8),
(25, 'Medication Use', 'Are you currently taking any medications for these symptoms?', 'yesno', 'symptoms', 6);

-- Options for Symptoms Questions
INSERT INTO QuestionOptions (QuestionID, OptionText, DisplayOrder) VALUES
-- Current Symptoms options (multi_choice)
(21, 'Headache', 0), (21, 'Fatigue', 1), (21, 'Nausea', 2), (21, 'Dizziness', 3), (21, 'Cough', 4), (21, 'Shortness of breath', 5), (21, 'None', 6),
-- Symptom Duration options
(22, 'Less than 24 hours', 0), (22, '1-3 days', 1), (22, '4-7 days', 2), (22, '1-2 weeks', 3), (22, 'More than 2 weeks', 4);

-- ============================================================================
-- SURVEY TEMPLATES SEED DATA
-- 3 templates: General Health Assessment, Mental Health Check-in, Lifestyle Survey
-- ============================================================================

INSERT INTO SurveyTemplate (TemplateID, Title, Description, CreatorID, IsPublic, CreatedAt) VALUES
(1, 'Test-General Health Assessment', 'Comprehensive health assessment covering demographics, physical health, and lifestyle factors. Ideal for initial patient intake or annual health reviews.', 2, TRUE, '2024-02-01 10:00:00'),
(2, 'Test-Mental Health Check-in', 'Quick mental health screening tool to assess stress, anxiety, sleep, and mood. Suitable for regular check-ins with patients or research participants.', 2, TRUE, '2024-02-15 14:30:00'),
(3, 'Test-Lifestyle & Wellness Survey', 'Survey focused on lifestyle habits including exercise, diet, substance use, and daily routines. Great for wellness programs and lifestyle interventions.', 3, TRUE, '2024-03-01 09:00:00'),
(4, 'Test-Symptom Tracker', 'Daily symptom tracking survey for patients managing chronic conditions or recovering from illness.', 4, FALSE, '2024-03-15 11:30:00'),
(5, 'Test-Pre-Appointment Questionnaire', 'Comprehensive questionnaire to complete before medical appointments. Covers current symptoms, medications, and concerns.', 7, TRUE, '2024-04-01 08:00:00');

-- Template 1: General Health Assessment (10 questions)
INSERT INTO TemplateQuestions (TemplateID, QuestionID, DisplayOrder) VALUES
(1, 1, 0),   -- Age Range
(1, 2, 1),   -- Gender Identity
(1, 3, 2),   -- Occupation Status
(1, 11, 3),  -- Exercise Frequency
(1, 12, 4),  -- Chronic Conditions
(1, 13, 5),  -- Pain Level
(1, 15, 6),  -- Last Checkup
(1, 16, 7),  -- Smoking Status
(1, 17, 8),  -- Alcohol Consumption
(1, 18, 9);  -- Diet Quality

-- Template 2: Mental Health Check-in (6 questions)
INSERT INTO TemplateQuestions (TemplateID, QuestionID, DisplayOrder) VALUES
(2, 6, 0),   -- Stress Level
(2, 7, 1),   -- Sleep Quality
(2, 8, 2),   -- Anxiety Frequency
(2, 9, 3),   -- Mood Description
(2, 10, 4),  -- Support System
(2, 24, 5);  -- Symptom Description (open-ended for additional concerns)

-- Template 3: Lifestyle & Wellness Survey (8 questions)
INSERT INTO TemplateQuestions (TemplateID, QuestionID, DisplayOrder) VALUES
(3, 11, 0),  -- Exercise Frequency
(3, 16, 1),  -- Smoking Status
(3, 17, 2),  -- Alcohol Consumption
(3, 18, 3),  -- Diet Quality
(3, 19, 4),  -- Water Intake
(3, 20, 5),  -- Screen Time
(3, 7, 6),   -- Sleep Quality
(3, 6, 7);   -- Stress Level

-- Template 4: Symptom Tracker (5 questions)
INSERT INTO TemplateQuestions (TemplateID, QuestionID, DisplayOrder) VALUES
(4, 21, 0),  -- Current Symptoms
(4, 22, 1),  -- Symptom Duration
(4, 23, 2),  -- Symptom Severity
(4, 24, 3),  -- Symptom Description
(4, 25, 4);  -- Medication Use

-- Template 5: Pre-Appointment Questionnaire (8 questions)
INSERT INTO TemplateQuestions (TemplateID, QuestionID, DisplayOrder) VALUES
(5, 21, 0),  -- Current Symptoms
(5, 23, 1),  -- Symptom Severity
(5, 13, 2),  -- Pain Level
(5, 12, 3),  -- Chronic Conditions
(5, 25, 4),  -- Medication Use
(5, 14, 5),  -- Physical Limitations
(5, 6, 6),   -- Stress Level
(5, 24, 7);  -- Symptom Description

-- ============================================================================
-- REAL CLIENT SURVEY TEMPLATES
-- Based on actual survey instruments from docs/Survey-Examples/
-- ============================================================================

-- ---------------------------------------------------------------------------
-- Template 6: Connections Intake Questionnaire (Appendix D)
-- Questions 26-38
-- ---------------------------------------------------------------------------
INSERT INTO QuestionBank (QuestionID, Title, QuestionContent, ResponseType, Category, QuestionData) VALUES
(26, 'Living Situation', 'Where do you live?', 'single_choice', 'demographics', NULL),
(27, 'Dependents', 'Do you have any dependents?', 'yesno', 'demographics', NULL),
(28, 'Transportation Access', 'What access to transportation do you have?', 'multi_choice', 'demographics', NULL),
(29, 'Work Hours', 'Do you work?', 'single_choice', 'demographics', NULL),
(30, 'Stress Sources', 'What causes stress in your life?', 'multi_choice', 'mental_health', NULL),
(31, 'Substance Use', 'In the past month which of these substances have you consumed?', 'multi_choice', 'lifestyle', NULL),
(32, 'Food Barriers', 'Do you have any barrier to eating the foods that you want to?', 'multi_choice', 'lifestyle', NULL),
(33, 'Meal Location', 'Where do you eat most of your meals?', 'multi_choice', 'lifestyle', NULL),
(34, 'Eating Alone or With Others', 'Do you eat alone or with others for the majority of your meals?', 'openended', 'lifestyle', NULL),
(35, 'Aerobic Activity Days', 'In a typical week, how many days do you perform moderate intensity (brisk walking) to vigorous intensity (running), aerobic activity?', 'number', 'physical_health', NULL),
(36, 'Aerobic Activity Minutes', 'On average for days that you do at least moderate-intensity aerobic physical activity, how many minutes?', 'number', 'physical_health', NULL),
(37, 'Exercise Focus', 'Which one of the three categories would you be most interested in focusing on during this program?', 'single_choice', 'physical_health', NULL),
(38, 'Sitting Hours', 'On a typical day, how many hours do you spend sitting: at school, at work, commuting?', 'single_choice', 'physical_health', NULL);

INSERT INTO QuestionOptions (QuestionID, OptionText, DisplayOrder) VALUES
-- Living Situation (26)
(26, 'On campus', 0), (26, 'With Friends', 1), (26, 'With Family', 2), (26, 'Other', 3),
-- Transportation Access (28)
(28, 'Bus', 0), (28, 'Walking', 1), (28, 'Car', 2), (28, 'Bike', 3), (28, 'Other', 4),
-- Work Hours (29)
(29, 'Don''t work', 0), (29, 'Less than 10 hours per week', 1), (29, '10-20 hours per week', 2), (29, 'Over 20 hours per week', 3),
-- Stress Sources (30)
(30, 'School', 0), (30, 'Work', 1), (30, 'Social life', 2), (30, 'Home life', 3),
-- Substance Use (31)
(31, 'Alcohol', 0), (31, 'THC in any form (cannabis)', 1), (31, 'Cigarettes, chewing tobacco, vaping', 2), (31, 'Other drugs', 3),
-- Food Barriers (32)
(32, 'Income', 0), (32, 'Transportation', 1), (32, 'Lack of variety/choice', 2), (32, 'Lack of storage', 3), (32, 'Lack of kitchen access', 4), (32, 'Lack of food skills', 5), (32, 'Loneliness', 6), (32, 'Health Conditions', 7), (32, 'Other', 8),
-- Meal Location (33)
(33, 'At home', 0), (33, 'On campus (cafeteria)', 1), (33, 'On campus (brought from home)', 2), (33, 'Restaurants (on or off campus)', 3), (33, 'Other', 4),
-- Exercise Focus (37)
(37, 'Cardio/Endurance Training', 0), (37, 'Functional Strength/Resistance Training', 1), (37, 'Both', 2),
-- Sitting Hours (38)
(38, '< 1 hour', 0), (38, '1-3 hours', 1), (38, '3-5 hours', 2), (38, '> 5 hours', 3);

-- ---------------------------------------------------------------------------
-- Template 7: Knowledge & Confidence Scale (Appendix E)
-- Questions 39-56 (all single_choice with 1-5 confidence scale)
-- ---------------------------------------------------------------------------
INSERT INTO QuestionBank (QuestionID, Title, QuestionContent, ResponseType, Category, QuestionData) VALUES
(39, 'Sexual Health Resources', 'How confident are you accessing resources regarding sexual health on campus? (i.e. STI Testing, PAP, HPV vaccination etc..)', 'single_choice', 'lifestyle', NULL),
(40, 'Safe Sex Knowledge', 'How confident are you regarding your knowledge when it comes to practicing safe sex?', 'single_choice', 'lifestyle', NULL),
(41, 'Alcohol Guidelines', 'How confident are you regarding practicing safe guidelines for consuming alcohol?', 'single_choice', 'lifestyle', NULL),
(42, 'Alcohol Products Knowledge', 'How confident are you with your knowledge on various alcohol products and the effects they may have when used?', 'single_choice', 'lifestyle', NULL),
(43, 'Cannabis Products Knowledge', 'How confident are you with your knowledge on various cannabis products and the effects they may have when used?', 'single_choice', 'lifestyle', NULL),
(44, 'Tobacco Products Knowledge', 'How confident are you with your knowledge on various tobacco products and the effects they may have when used?', 'single_choice', 'lifestyle', NULL),
(45, 'Stress Warning Signs', 'How confident are you on acknowledging early warning signs when becoming stressed?', 'single_choice', 'mental_health', NULL),
(46, 'Stress Coping', 'How confident are you knowing what to do when you start to feel stressed?', 'single_choice', 'mental_health', NULL),
(47, 'Work-Life Balance', 'How confident are you with your work/life/school/social balance?', 'single_choice', 'mental_health', NULL),
(48, 'Exercise Ability', 'How confident are you in your ability to perform strength exercises and cardiovascular training on your own?', 'single_choice', 'physical_health', NULL),
(49, 'Healthy Food Choices', 'How confident are you in being able to choose healthy foods and beverages for yourself?', 'single_choice', 'lifestyle', NULL),
(50, 'Meal Budgeting', 'How confident are you in budgeting finances for meal planning and grocery shopping?', 'single_choice', 'lifestyle', NULL),
(51, 'Reading Food Labels', 'How confident are you in reading labels on packaged foods?', 'single_choice', 'lifestyle', NULL),
(52, 'Grocery Store Navigation', 'How confident are you that you can navigate a grocery store?', 'single_choice', 'lifestyle', NULL),
(53, 'Food Skills', 'How confident are you in food skills (preparing, cooking, and food storage)?', 'single_choice', 'lifestyle', NULL),
(54, 'Social Connection', 'How confident are you in finding social connection at your institution?', 'single_choice', 'mental_health', NULL),
(55, 'Sedentary Lifestyle Effects', 'How confident are you in understanding the long-term effects of sedentary lifestyle?', 'single_choice', 'physical_health', NULL),
(56, 'Incorporating Movement', 'How confident are you in finding ways of incorporating movement into your everyday life?', 'single_choice', 'physical_health', NULL);

-- Options for ALL confidence scale questions (39-56): same 5 options each
INSERT INTO QuestionOptions (QuestionID, OptionText, DisplayOrder) VALUES
(39, '1 (not confident)', 0), (39, '2', 1), (39, '3 (neutral)', 2), (39, '4', 3), (39, '5 (very confident)', 4),
(40, '1 (not confident)', 0), (40, '2', 1), (40, '3 (neutral)', 2), (40, '4', 3), (40, '5 (very confident)', 4),
(41, '1 (not confident)', 0), (41, '2', 1), (41, '3 (neutral)', 2), (41, '4', 3), (41, '5 (very confident)', 4),
(42, '1 (not confident)', 0), (42, '2', 1), (42, '3 (neutral)', 2), (42, '4', 3), (42, '5 (very confident)', 4),
(43, '1 (not confident)', 0), (43, '2', 1), (43, '3 (neutral)', 2), (43, '4', 3), (43, '5 (very confident)', 4),
(44, '1 (not confident)', 0), (44, '2', 1), (44, '3 (neutral)', 2), (44, '4', 3), (44, '5 (very confident)', 4),
(45, '1 (not confident)', 0), (45, '2', 1), (45, '3 (neutral)', 2), (45, '4', 3), (45, '5 (very confident)', 4),
(46, '1 (not confident)', 0), (46, '2', 1), (46, '3 (neutral)', 2), (46, '4', 3), (46, '5 (very confident)', 4),
(47, '1 (not confident)', 0), (47, '2', 1), (47, '3 (neutral)', 2), (47, '4', 3), (47, '5 (very confident)', 4),
(48, '1 (not confident)', 0), (48, '2', 1), (48, '3 (neutral)', 2), (48, '4', 3), (48, '5 (very confident)', 4),
(49, '1 (not confident)', 0), (49, '2', 1), (49, '3 (neutral)', 2), (49, '4', 3), (49, '5 (very confident)', 4),
(50, '1 (not confident)', 0), (50, '2', 1), (50, '3 (neutral)', 2), (50, '4', 3), (50, '5 (very confident)', 4),
(51, '1 (not confident)', 0), (51, '2', 1), (51, '3 (neutral)', 2), (51, '4', 3), (51, '5 (very confident)', 4),
(52, '1 (not confident)', 0), (52, '2', 1), (52, '3 (neutral)', 2), (52, '4', 3), (52, '5 (very confident)', 4),
(53, '1 (not confident)', 0), (53, '2', 1), (53, '3 (neutral)', 2), (53, '4', 3), (53, '5 (very confident)', 4),
(54, '1 (not confident)', 0), (54, '2', 1), (54, '3 (neutral)', 2), (54, '4', 3), (54, '5 (very confident)', 4),
(55, '1 (not confident)', 0), (55, '2', 1), (55, '3 (neutral)', 2), (55, '4', 3), (55, '5 (very confident)', 4),
(56, '1 (not confident)', 0), (56, '2', 1), (56, '3 (neutral)', 2), (56, '4', 3), (56, '5 (very confident)', 4);

-- ---------------------------------------------------------------------------
-- Template 8: Perceived Stress Scale PSS-10 (Appendix P)
-- Questions 57-66 (all single_choice with 0-4 frequency scale)
-- ---------------------------------------------------------------------------
INSERT INTO QuestionBank (QuestionID, Title, QuestionContent, ResponseType, Category, QuestionData) VALUES
(57, 'PSS-1 Upset Unexpectedly', 'In the last month, how often have you been upset because of something that happened unexpectedly?', 'single_choice', 'mental_health', NULL),
(58, 'PSS-2 Unable to Control', 'In the last month, how often have you felt that you were unable to control the important things in your life?', 'single_choice', 'mental_health', NULL),
(59, 'PSS-3 Nervous and Stressed', 'In the last month, how often have you felt nervous and stressed?', 'single_choice', 'mental_health', NULL),
(60, 'PSS-4 Confident Handling Problems', 'In the last month, how often have you felt confident about your ability to handle your personal problems?', 'single_choice', 'mental_health', NULL),
(61, 'PSS-5 Things Going Your Way', 'In the last month, how often have you felt that things were going your way?', 'single_choice', 'mental_health', NULL),
(62, 'PSS-6 Could Not Cope', 'In the last month, how often have you found that you could not cope with all the things that you had to do?', 'single_choice', 'mental_health', NULL),
(63, 'PSS-7 Control Irritations', 'In the last month, how often have you been able to control irritations in your life?', 'single_choice', 'mental_health', NULL),
(64, 'PSS-8 On Top of Things', 'In the last month, how often have you felt that you were on top of things?', 'single_choice', 'mental_health', NULL),
(65, 'PSS-9 Angered Outside Control', 'In the last month, how often have you been angered because of things that happened that were outside of your control?', 'single_choice', 'mental_health', NULL),
(66, 'PSS-10 Difficulties Piling Up', 'In the last month, how often have you felt difficulties were piling up so high that you could not overcome them?', 'single_choice', 'mental_health', NULL);

-- Options for ALL PSS-10 questions (57-66): same 5 options each
INSERT INTO QuestionOptions (QuestionID, OptionText, DisplayOrder) VALUES
(57, '0 - Never', 0), (57, '1 - Almost never', 1), (57, '2 - Sometimes', 2), (57, '3 - Fairly often', 3), (57, '4 - Very often', 4),
(58, '0 - Never', 0), (58, '1 - Almost never', 1), (58, '2 - Sometimes', 2), (58, '3 - Fairly often', 3), (58, '4 - Very often', 4),
(59, '0 - Never', 0), (59, '1 - Almost never', 1), (59, '2 - Sometimes', 2), (59, '3 - Fairly often', 3), (59, '4 - Very often', 4),
(60, '0 - Never', 0), (60, '1 - Almost never', 1), (60, '2 - Sometimes', 2), (60, '3 - Fairly often', 3), (60, '4 - Very often', 4),
(61, '0 - Never', 0), (61, '1 - Almost never', 1), (61, '2 - Sometimes', 2), (61, '3 - Fairly often', 3), (61, '4 - Very often', 4),
(62, '0 - Never', 0), (62, '1 - Almost never', 1), (62, '2 - Sometimes', 2), (62, '3 - Fairly often', 3), (62, '4 - Very often', 4),
(63, '0 - Never', 0), (63, '1 - Almost never', 1), (63, '2 - Sometimes', 2), (63, '3 - Fairly often', 3), (63, '4 - Very often', 4),
(64, '0 - Never', 0), (64, '1 - Almost never', 1), (64, '2 - Sometimes', 2), (64, '3 - Fairly often', 3), (64, '4 - Very often', 4),
(65, '0 - Never', 0), (65, '1 - Almost never', 1), (65, '2 - Sometimes', 2), (65, '3 - Fairly often', 3), (65, '4 - Very often', 4),
(66, '0 - Never', 0), (66, '1 - Almost never', 1), (66, '2 - Sometimes', 2), (66, '3 - Fairly often', 3), (66, '4 - Very often', 4);

-- ---------------------------------------------------------------------------
-- Template 9: UCLA Loneliness Scale Version 3 (Appendix Q)
-- Questions 67-86 (all single_choice with 1-4 frequency scale)
-- ---------------------------------------------------------------------------
INSERT INTO QuestionBank (QuestionID, Title, QuestionContent, ResponseType, Category, QuestionData) VALUES
(67, 'UCLA-1 In Tune', 'How often do you feel that you are "in tune" with the people around you?', 'single_choice', 'mental_health', NULL),
(68, 'UCLA-2 Lack Companionship', 'How often do you feel that you lack companionship?', 'single_choice', 'mental_health', NULL),
(69, 'UCLA-3 No One to Turn To', 'How often do you feel that there is no one you can turn to?', 'single_choice', 'mental_health', NULL),
(70, 'UCLA-4 Feel Alone', 'How often do you feel alone?', 'single_choice', 'mental_health', NULL),
(71, 'UCLA-5 Part of Group', 'How often do you feel part of a group of friends?', 'single_choice', 'mental_health', NULL),
(72, 'UCLA-6 Common With Others', 'How often do you feel that you have a lot in common with the people around you?', 'single_choice', 'mental_health', NULL),
(73, 'UCLA-7 No Longer Close', 'How often do you feel that you are no longer close to anyone?', 'single_choice', 'mental_health', NULL),
(74, 'UCLA-8 Ideas Not Shared', 'How often do you feel that your interests and ideas are not shared by those around you?', 'single_choice', 'mental_health', NULL),
(75, 'UCLA-9 Outgoing and Friendly', 'How often do you feel outgoing and friendly?', 'single_choice', 'mental_health', NULL),
(76, 'UCLA-10 Close to People', 'How often do you feel close to people?', 'single_choice', 'mental_health', NULL),
(77, 'UCLA-11 Left Out', 'How often do you feel left out?', 'single_choice', 'mental_health', NULL),
(78, 'UCLA-12 Relationships Not Meaningful', 'How often do you feel that your relationships with others are not meaningful?', 'single_choice', 'mental_health', NULL),
(79, 'UCLA-13 No One Knows You', 'How often do you feel that no one really knows you well?', 'single_choice', 'mental_health', NULL),
(80, 'UCLA-14 Isolated', 'How often do you feel isolated from others?', 'single_choice', 'mental_health', NULL),
(81, 'UCLA-15 Find Companionship', 'How often do you feel you can find companionship when you want it?', 'single_choice', 'mental_health', NULL),
(82, 'UCLA-16 People Understand You', 'How often do you feel that there are people who really understand you?', 'single_choice', 'mental_health', NULL),
(83, 'UCLA-17 Feel Shy', 'How often do you feel shy?', 'single_choice', 'mental_health', NULL),
(84, 'UCLA-18 Around But Not With', 'How often do you feel that people are around you but not with you?', 'single_choice', 'mental_health', NULL),
(85, 'UCLA-19 People to Talk To', 'How often do you feel that there are people you can talk to?', 'single_choice', 'mental_health', NULL),
(86, 'UCLA-20 People to Turn To', 'How often do you feel that there are people you can turn to?', 'single_choice', 'mental_health', NULL);

-- Options for ALL UCLA questions (67-86): same 4 options each
INSERT INTO QuestionOptions (QuestionID, OptionText, DisplayOrder) VALUES
(67, '1 - Never', 0), (67, '2 - Rarely', 1), (67, '3 - Sometimes', 2), (67, '4 - Often', 3),
(68, '1 - Never', 0), (68, '2 - Rarely', 1), (68, '3 - Sometimes', 2), (68, '4 - Often', 3),
(69, '1 - Never', 0), (69, '2 - Rarely', 1), (69, '3 - Sometimes', 2), (69, '4 - Often', 3),
(70, '1 - Never', 0), (70, '2 - Rarely', 1), (70, '3 - Sometimes', 2), (70, '4 - Often', 3),
(71, '1 - Never', 0), (71, '2 - Rarely', 1), (71, '3 - Sometimes', 2), (71, '4 - Often', 3),
(72, '1 - Never', 0), (72, '2 - Rarely', 1), (72, '3 - Sometimes', 2), (72, '4 - Often', 3),
(73, '1 - Never', 0), (73, '2 - Rarely', 1), (73, '3 - Sometimes', 2), (73, '4 - Often', 3),
(74, '1 - Never', 0), (74, '2 - Rarely', 1), (74, '3 - Sometimes', 2), (74, '4 - Often', 3),
(75, '1 - Never', 0), (75, '2 - Rarely', 1), (75, '3 - Sometimes', 2), (75, '4 - Often', 3),
(76, '1 - Never', 0), (76, '2 - Rarely', 1), (76, '3 - Sometimes', 2), (76, '4 - Often', 3),
(77, '1 - Never', 0), (77, '2 - Rarely', 1), (77, '3 - Sometimes', 2), (77, '4 - Often', 3),
(78, '1 - Never', 0), (78, '2 - Rarely', 1), (78, '3 - Sometimes', 2), (78, '4 - Often', 3),
(79, '1 - Never', 0), (79, '2 - Rarely', 1), (79, '3 - Sometimes', 2), (79, '4 - Often', 3),
(80, '1 - Never', 0), (80, '2 - Rarely', 1), (80, '3 - Sometimes', 2), (80, '4 - Often', 3),
(81, '1 - Never', 0), (81, '2 - Rarely', 1), (81, '3 - Sometimes', 2), (81, '4 - Often', 3),
(82, '1 - Never', 0), (82, '2 - Rarely', 1), (82, '3 - Sometimes', 2), (82, '4 - Often', 3),
(83, '1 - Never', 0), (83, '2 - Rarely', 1), (83, '3 - Sometimes', 2), (83, '4 - Often', 3),
(84, '1 - Never', 0), (84, '2 - Rarely', 1), (84, '3 - Sometimes', 2), (84, '4 - Often', 3),
(85, '1 - Never', 0), (85, '2 - Rarely', 1), (85, '3 - Sometimes', 2), (85, '4 - Often', 3),
(86, '1 - Never', 0), (86, '2 - Rarely', 1), (86, '3 - Sometimes', 2), (86, '4 - Often', 3);

-- ---------------------------------------------------------------------------
-- New Template entries (6-9) for the real client surveys
-- ---------------------------------------------------------------------------
INSERT INTO SurveyTemplate (TemplateID, Title, Description, CreatorID, IsPublic, CreatedAt) VALUES
(6, 'Connections Intake Questionnaire', 'Intake questionnaire collecting demographic, lifestyle, and wellness information from program participants. Covers living situation, transportation, work, stress, substance use, food barriers, physical activity, and exercise preferences.', 2, TRUE, '2024-05-01 10:00:00'),
(7, 'Knowledge & Confidence Scale', 'Self-assessment measuring confidence levels across health literacy domains including sexual health, substance knowledge, stress management, physical activity, nutrition, and social connection. Uses a 1-5 confidence scale.', 2, TRUE, '2024-05-15 10:00:00'),
(8, 'Perceived Stress Scale (PSS-10)', 'The Perceived Stress Scale (PSS) is a classic stress assessment instrument. Questions ask about feelings and thoughts during the last month, indicating how often you felt or thought a certain way. Scores range 0-40: Low stress (0-13), Moderate stress (14-26), High perceived stress (27-40).', 2, TRUE, '2024-06-01 10:00:00'),
(9, 'UCLA Loneliness Scale Version 3', 'A 20-item scale designed to measure subjective feelings of loneliness and social isolation. Respondents indicate how often each statement is descriptive of them on a 1-4 frequency scale.', 2, TRUE, '2024-06-15 10:00:00');

-- Template 6: Connections Intake Questionnaire (13 questions)
INSERT INTO TemplateQuestions (TemplateID, QuestionID, DisplayOrder) VALUES
(6, 26, 0),  -- Living Situation
(6, 27, 1),  -- Dependents
(6, 28, 2),  -- Transportation Access
(6, 29, 3),  -- Work Hours
(6, 30, 4),  -- Stress Sources
(6, 31, 5),  -- Substance Use
(6, 32, 6),  -- Food Barriers
(6, 33, 7),  -- Meal Location
(6, 34, 8),  -- Eating Alone or With Others
(6, 35, 9),  -- Aerobic Activity Days
(6, 36, 10), -- Aerobic Activity Minutes
(6, 37, 11), -- Exercise Focus
(6, 38, 12); -- Sitting Hours

-- Template 7: Knowledge & Confidence Scale (18 questions)
INSERT INTO TemplateQuestions (TemplateID, QuestionID, DisplayOrder) VALUES
(7, 39, 0),  -- Sexual Health Resources
(7, 40, 1),  -- Safe Sex Knowledge
(7, 41, 2),  -- Alcohol Guidelines
(7, 42, 3),  -- Alcohol Products Knowledge
(7, 43, 4),  -- Cannabis Products Knowledge
(7, 44, 5),  -- Tobacco Products Knowledge
(7, 45, 6),  -- Stress Warning Signs
(7, 46, 7),  -- Stress Coping
(7, 47, 8),  -- Work-Life Balance
(7, 48, 9),  -- Exercise Ability
(7, 49, 10), -- Healthy Food Choices
(7, 50, 11), -- Meal Budgeting
(7, 51, 12), -- Reading Food Labels
(7, 52, 13), -- Grocery Store Navigation
(7, 53, 14), -- Food Skills
(7, 54, 15), -- Social Connection
(7, 55, 16), -- Sedentary Lifestyle Effects
(7, 56, 17); -- Incorporating Movement

-- Template 8: Perceived Stress Scale PSS-10 (10 questions)
INSERT INTO TemplateQuestions (TemplateID, QuestionID, DisplayOrder) VALUES
(8, 57, 0),  -- Upset Unexpectedly
(8, 58, 1),  -- Unable to Control
(8, 59, 2),  -- Nervous and Stressed
(8, 60, 3),  -- Confident Handling Problems
(8, 61, 4),  -- Things Going Your Way
(8, 62, 5),  -- Could Not Cope
(8, 63, 6),  -- Control Irritations
(8, 64, 7),  -- On Top of Things
(8, 65, 8),  -- Angered Outside Control
(8, 66, 9);  -- Difficulties Piling Up

-- Template 9: UCLA Loneliness Scale Version 3 (20 questions)
INSERT INTO TemplateQuestions (TemplateID, QuestionID, DisplayOrder) VALUES
(9, 67, 0),  -- In Tune
(9, 68, 1),  -- Lack Companionship
(9, 69, 2),  -- No One to Turn To
(9, 70, 3),  -- Feel Alone
(9, 71, 4),  -- Part of Group
(9, 72, 5),  -- Common With Others
(9, 73, 6),  -- No Longer Close
(9, 74, 7),  -- Ideas Not Shared
(9, 75, 8),  -- Outgoing and Friendly
(9, 76, 9),  -- Close to People
(9, 77, 10), -- Left Out
(9, 78, 11), -- Relationships Not Meaningful
(9, 79, 12), -- No One Knows You
(9, 80, 13), -- Isolated
(9, 81, 14), -- Find Companionship
(9, 82, 15), -- People Understand You
(9, 83, 16), -- Feel Shy
(9, 84, 17), -- Around But Not With
(9, 85, 18), -- People to Talk To
(9, 86, 19); -- People to Turn To

-- ============================================================================
-- SURVEYS SEED DATA
-- Various surveys in different states for testing
-- ============================================================================

INSERT INTO Survey (SurveyID, Title, Description, Status, PublicationStatus, CreatorID, StartDate, EndDate, CreatedAt) VALUES
-- Published and active surveys
(1, 'Q1 2026 Health Assessment', 'Quarterly health assessment for enrolled participants.', 'in-progress', 'published', 2, '2026-01-01 00:00:00', '2026-03-31 23:59:59', '2025-12-15 10:00:00'),
(2, 'Mental Health Weekly Check-in', 'Weekly mental health monitoring survey.', 'in-progress', 'published', 2, '2026-01-01 00:00:00', '2026-12-31 23:59:59', '2025-12-20 14:30:00'),
(3, 'Lifestyle Habits Study', 'Research study on lifestyle habits and health outcomes.', 'in-progress', 'published', 3, '2026-01-15 00:00:00', '2026-06-15 23:59:59', '2026-01-10 09:00:00'),

-- Draft surveys (not yet published)
(4, 'Sleep Quality Research', 'Investigating factors affecting sleep quality in adults.', 'not-started', 'draft', 4, NULL, NULL, '2026-01-20 11:00:00'),
(5, 'Chronic Pain Assessment', 'Assessment survey for chronic pain management program.', 'not-started', 'draft', 3, NULL, NULL, '2026-01-22 15:30:00'),

-- Completed surveys
(6, 'Q4 2025 Health Assessment', 'Quarterly health assessment - completed.', 'complete', 'closed', 2, '2025-10-01 00:00:00', '2025-12-31 23:59:59', '2025-09-15 10:00:00'),
(7, 'COVID-19 Symptom Tracker', 'COVID symptom monitoring - study concluded.', 'complete', 'closed', 4, '2025-06-01 00:00:00', '2025-09-30 23:59:59', '2025-05-20 08:00:00'),

-- Cancelled survey
(8, 'Discontinued Study', 'Study cancelled due to low participation.', 'cancelled', 'closed', 5, '2025-08-01 00:00:00', '2025-11-30 23:59:59', '2025-07-15 13:00:00');

-- Link questions to surveys
-- Survey 1: Q1 2026 Health Assessment
INSERT INTO QuestionList (SurveyID, QuestionID) VALUES
(1, 1), (1, 2), (1, 3), (1, 11), (1, 12), (1, 13), (1, 15), (1, 16), (1, 17), (1, 18);

-- Survey 2: Mental Health Weekly Check-in
INSERT INTO QuestionList (SurveyID, QuestionID) VALUES
(2, 6), (2, 7), (2, 8), (2, 9), (2, 10);

-- Survey 3: Lifestyle Habits Study
INSERT INTO QuestionList (SurveyID, QuestionID) VALUES
(3, 11), (3, 16), (3, 17), (3, 18), (3, 19), (3, 20), (3, 7);

-- Survey 4: Sleep Quality Research (draft)
INSERT INTO QuestionList (SurveyID, QuestionID) VALUES
(4, 7), (4, 6), (4, 20), (4, 19);

-- Survey 5: Chronic Pain Assessment (draft)
INSERT INTO QuestionList (SurveyID, QuestionID) VALUES
(5, 13), (5, 14), (5, 21), (5, 22), (5, 23), (5, 24), (5, 25);

-- Survey 6: Q4 2025 Health Assessment (completed)
INSERT INTO QuestionList (SurveyID, QuestionID) VALUES
(6, 1), (6, 2), (6, 11), (6, 12), (6, 16), (6, 17);

-- Survey 7: COVID-19 Symptom Tracker (completed)
INSERT INTO QuestionList (SurveyID, QuestionID) VALUES
(7, 21), (7, 22), (7, 23), (7, 24), (7, 25);

-- ============================================================================
-- SURVEY ASSIGNMENTS
-- Assign participants to surveys with various statuses
-- ============================================================================

INSERT INTO SurveyAssignment (SurveyID, AccountID, AssignedAt, DueDate, CompletedAt, Status) VALUES
-- Survey 1: Q1 2026 Health Assessment - assign to most participants
(1, 10, '2026-01-02 09:00:00', '2026-01-31 23:59:59', '2026-01-15 14:30:00', 'completed'),
(1, 11, '2026-01-02 09:00:00', '2026-01-31 23:59:59', '2026-01-18 10:00:00', 'completed'),
(1, 12, '2026-01-02 09:00:00', '2026-01-31 23:59:59', NULL, 'pending'),
(1, 13, '2026-01-02 09:00:00', '2026-01-31 23:59:59', NULL, 'pending'),
(1, 14, '2026-01-02 09:00:00', '2026-01-31 23:59:59', '2026-01-20 16:45:00', 'completed'),
(1, 15, '2026-01-02 09:00:00', '2026-01-31 23:59:59', NULL, 'pending'),
(1, 16, '2026-01-05 10:00:00', '2026-02-05 23:59:59', NULL, 'pending'),
(1, 17, '2026-01-05 10:00:00', '2026-02-05 23:59:59', '2026-01-22 11:30:00', 'completed'),
(1, 18, '2026-01-08 11:00:00', '2026-02-08 23:59:59', NULL, 'pending'),
(1, 19, '2026-01-08 11:00:00', '2026-02-08 23:59:59', NULL, 'pending'),
(1, 21, '2026-01-10 09:00:00', '2026-02-10 23:59:59', NULL, 'pending'),
(1, 22, '2026-01-10 09:00:00', '2026-02-10 23:59:59', '2026-01-25 09:15:00', 'completed'),
(1, 23, '2026-01-12 14:00:00', '2026-02-12 23:59:59', NULL, 'pending'),
(1, 24, '2026-01-12 14:00:00', '2026-02-12 23:59:59', NULL, 'pending'),
(1, 25, '2026-01-15 08:00:00', '2026-02-15 23:59:59', NULL, 'pending'),

-- Survey 2: Mental Health Weekly Check-in
(2, 10, '2026-01-06 09:00:00', '2026-01-13 23:59:59', '2026-01-10 08:30:00', 'completed'),
(2, 11, '2026-01-06 09:00:00', '2026-01-13 23:59:59', '2026-01-12 15:00:00', 'completed'),
(2, 12, '2026-01-06 09:00:00', '2026-01-13 23:59:59', NULL, 'pending'),
(2, 14, '2026-01-06 09:00:00', '2026-01-13 23:59:59', '2026-01-11 10:45:00', 'completed'),
(2, 17, '2026-01-06 09:00:00', '2026-01-13 23:59:59', NULL, 'pending'),
(2, 19, '2026-01-06 09:00:00', '2026-01-13 23:59:59', '2026-01-09 17:20:00', 'completed'),
(2, 21, '2026-01-06 09:00:00', '2026-01-13 23:59:59', NULL, 'pending'),
(2, 23, '2026-01-06 09:00:00', '2026-01-13 23:59:59', '2026-01-13 11:00:00', 'completed'),

-- Survey 3: Lifestyle Habits Study
(3, 10, '2026-01-15 10:00:00', '2026-02-15 23:59:59', '2026-01-28 14:00:00', 'completed'),
(3, 13, '2026-01-15 10:00:00', '2026-02-15 23:59:59', NULL, 'pending'),
(3, 15, '2026-01-15 10:00:00', '2026-02-15 23:59:59', NULL, 'pending'),
(3, 16, '2026-01-15 10:00:00', '2026-02-15 23:59:59', '2026-01-25 09:30:00', 'completed'),
(3, 18, '2026-01-15 10:00:00', '2026-02-15 23:59:59', NULL, 'pending'),
(3, 22, '2026-01-15 10:00:00', '2026-02-15 23:59:59', NULL, 'pending'),
(3, 24, '2026-01-15 10:00:00', '2026-02-15 23:59:59', '2026-01-27 16:15:00', 'completed'),
(3, 26, '2026-01-15 10:00:00', '2026-02-15 23:59:59', NULL, 'pending'),
(3, 28, '2026-01-15 10:00:00', '2026-02-15 23:59:59', NULL, 'pending'),
(3, 29, '2026-01-15 10:00:00', '2026-02-15 23:59:59', NULL, 'pending'),

-- Survey 6: Q4 2025 Health Assessment (completed - all assignments done)
(6, 10, '2025-10-01 09:00:00', '2025-10-31 23:59:59', '2025-10-15 11:00:00', 'completed'),
(6, 11, '2025-10-01 09:00:00', '2025-10-31 23:59:59', '2025-10-18 14:30:00', 'completed'),
(6, 12, '2025-10-01 09:00:00', '2025-10-31 23:59:59', '2025-10-20 09:45:00', 'completed'),
(6, 14, '2025-10-01 09:00:00', '2025-10-31 23:59:59', '2025-10-22 16:00:00', 'completed'),
(6, 17, '2025-10-01 09:00:00', '2025-10-31 23:59:59', '2025-10-25 10:30:00', 'completed'),
(6, 19, '2025-10-01 09:00:00', '2025-10-31 23:59:59', '2025-10-28 13:15:00', 'completed'),

-- Survey 7: COVID-19 Symptom Tracker (completed)
(7, 10, '2025-06-01 08:00:00', '2025-06-30 23:59:59', '2025-06-15 09:00:00', 'completed'),
(7, 11, '2025-06-01 08:00:00', '2025-06-30 23:59:59', '2025-06-18 11:30:00', 'completed'),
(7, 13, '2025-06-01 08:00:00', '2025-06-30 23:59:59', '2025-06-20 14:45:00', 'completed'),
(7, 15, '2025-06-01 08:00:00', '2025-06-30 23:59:59', '2025-06-22 08:20:00', 'completed'),
(7, 18, '2025-06-01 08:00:00', '2025-06-30 23:59:59', '2025-06-25 16:00:00', 'completed'),

-- Survey 8: Discontinued Study (expired assignments)
(8, 12, '2025-08-01 10:00:00', '2025-08-31 23:59:59', NULL, 'expired'),
(8, 14, '2025-08-01 10:00:00', '2025-08-31 23:59:59', NULL, 'expired'),
(8, 16, '2025-08-01 10:00:00', '2025-08-31 23:59:59', NULL, 'expired');

-- ============================================================================
-- RESPONSES SEED DATA
-- Sample responses from participants who completed surveys
-- ============================================================================

-- Responses for Survey 1: Q1 2026 Health Assessment
-- Participant 10 (John Smith) - completed
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(1, 10, 1, '35-44'),
(1, 10, 2, 'Male'),
(1, 10, 3, 'Employed full-time'),
(1, 10, 11, '3'),
(1, 10, 12, 'None'),
(1, 10, 13, '2'),
(1, 10, 15, 'Within the last 6 months'),
(1, 10, 16, 'No, never'),
(1, 10, 17, 'Weekly'),
(1, 10, 18, '7');

-- Participant 11 (Maria Garcia) - completed
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(1, 11, 1, '25-34'),
(1, 11, 2, 'Female'),
(1, 11, 3, 'Employed full-time'),
(1, 11, 11, '5'),
(1, 11, 12, 'None'),
(1, 11, 13, '1'),
(1, 11, 15, 'Within the last 6 months'),
(1, 11, 16, 'No, never'),
(1, 11, 17, 'Rarely (a few times a year)'),
(1, 11, 18, '8');

-- Participant 14 (Robert Anderson) - completed
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(1, 14, 1, '55-64'),
(1, 14, 2, 'Male'),
(1, 14, 3, 'Retired'),
(1, 14, 11, '4'),
(1, 14, 12, 'Hypertension'),
(1, 14, 13, '3'),
(1, 14, 15, 'Within the last 6 months'),
(1, 14, 16, 'No, I quit'),
(1, 14, 17, 'Monthly'),
(1, 14, 18, '6');

-- Participant 17 (Elizabeth Hernandez) - completed
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(1, 17, 1, '45-54'),
(1, 17, 2, 'Female'),
(1, 17, 3, 'Employed part-time'),
(1, 17, 11, '2'),
(1, 17, 12, 'Arthritis'),
(1, 17, 13, '5'),
(1, 17, 15, '6-12 months ago'),
(1, 17, 16, 'No, never'),
(1, 17, 17, 'Never'),
(1, 17, 18, '7');

-- Participant 22 (Joseph Perez) - completed
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(1, 22, 1, '18-24'),
(1, 22, 2, 'Male'),
(1, 22, 3, 'Student'),
(1, 22, 11, '2'),
(1, 22, 12, 'None'),
(1, 22, 13, '1'),
(1, 22, 15, '1-2 years ago'),
(1, 22, 16, 'Yes, occasionally'),
(1, 22, 17, 'Weekly'),
(1, 22, 18, '5');

-- Responses for Survey 2: Mental Health Weekly Check-in
-- Participant 10 - completed
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(2, 10, 6, '4'),
(2, 10, 7, '6'),
(2, 10, 8, 'Several days'),
(2, 10, 9, 'Good'),
(2, 10, 10, 'true');

-- Participant 11 - completed
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(2, 11, 6, '3'),
(2, 11, 7, '8'),
(2, 11, 8, 'Not at all'),
(2, 11, 9, 'Very good'),
(2, 11, 10, 'true');

-- Participant 14 - completed
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(2, 14, 6, '5'),
(2, 14, 7, '5'),
(2, 14, 8, 'Several days'),
(2, 14, 9, 'Neutral'),
(2, 14, 10, 'true');

-- Participant 19 - completed
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(2, 19, 6, '6'),
(2, 19, 7, '4'),
(2, 19, 8, 'More than half the days'),
(2, 19, 9, 'Low'),
(2, 19, 10, 'false');

-- Participant 23 - completed
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(2, 23, 6, '2'),
(2, 23, 7, '9'),
(2, 23, 8, 'Not at all'),
(2, 23, 9, 'Very good'),
(2, 23, 10, 'true');

-- Responses for Survey 3: Lifestyle Habits Study
-- Participant 10 - completed
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(3, 10, 11, '3'),
(3, 10, 16, 'No, never'),
(3, 10, 17, 'Weekly'),
(3, 10, 18, '7'),
(3, 10, 19, '6'),
(3, 10, 20, '8'),
(3, 10, 7, '6');

-- Participant 16 - completed
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(3, 16, 11, '5'),
(3, 16, 16, 'No, never'),
(3, 16, 17, 'Monthly'),
(3, 16, 18, '8'),
(3, 16, 19, '8'),
(3, 16, 20, '6'),
(3, 16, 7, '7');

-- Participant 24 - completed
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(3, 24, 11, '1'),
(3, 24, 16, 'Yes, daily'),
(3, 24, 17, 'Daily'),
(3, 24, 18, '4'),
(3, 24, 19, '3'),
(3, 24, 20, '10'),
(3, 24, 7, '4');

-- Responses for Survey 6: Q4 2025 Health Assessment (historical data)
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(6, 10, 1, '35-44'), (6, 10, 2, 'Male'), (6, 10, 11, '3'), (6, 10, 12, 'None'), (6, 10, 16, 'No, never'), (6, 10, 17, 'Weekly'),
(6, 11, 1, '25-34'), (6, 11, 2, 'Female'), (6, 11, 11, '4'), (6, 11, 12, 'None'), (6, 11, 16, 'No, never'), (6, 11, 17, 'Monthly'),
(6, 12, 1, '45-54'), (6, 12, 2, 'Male'), (6, 12, 11, '2'), (6, 12, 12, 'Diabetes'), (6, 12, 16, 'No, I quit'), (6, 12, 17, 'Never'),
(6, 14, 1, '55-64'), (6, 14, 2, 'Male'), (6, 14, 11, '3'), (6, 14, 12, 'Hypertension'), (6, 14, 16, 'No, I quit'), (6, 14, 17, 'Monthly'),
(6, 17, 1, '45-54'), (6, 17, 2, 'Female'), (6, 17, 11, '2'), (6, 17, 12, 'Arthritis'), (6, 17, 16, 'No, never'), (6, 17, 17, 'Never'),
(6, 19, 1, '35-44'), (6, 19, 2, 'Female'), (6, 19, 11, '4'), (6, 19, 12, 'None'), (6, 19, 16, 'No, never'), (6, 19, 17, 'Rarely (a few times a year)');

-- Responses for Survey 7: COVID-19 Symptom Tracker (historical data)
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(7, 10, 21, 'Fatigue'), (7, 10, 22, '4-7 days'), (7, 10, 23, '4'), (7, 10, 24, 'Mild fatigue and occasional headaches'), (7, 10, 25, 'false'),
(7, 11, 21, 'None'), (7, 11, 22, 'Less than 24 hours'), (7, 11, 23, '1'), (7, 11, 24, 'No symptoms'), (7, 11, 25, 'false'),
(7, 13, 21, '["Headache", "Cough"]'), (7, 13, 22, '1-3 days'), (7, 13, 23, '3'), (7, 13, 24, 'Mild cold-like symptoms'), (7, 13, 25, 'true'),
(7, 15, 21, '["Fatigue", "Shortness of breath"]'), (7, 15, 22, '1-2 weeks'), (7, 15, 23, '6'), (7, 15, 24, 'Recovering from COVID, still fatigued'), (7, 15, 25, 'true'),
(7, 18, 21, 'None'), (7, 18, 22, 'Less than 24 hours'), (7, 18, 23, '1'), (7, 18, 24, 'Feeling healthy'), (7, 18, 25, 'false');

-- ============================================================================
-- SESSIONS SEED DATA (for active users)
-- Recent sessions for testing authentication state
-- ============================================================================

INSERT INTO Sessions (AccountID, TokenHash, CreatedAt, ExpiresAt, IpAddress, UserAgent) VALUES
-- Active admin session
(1, 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', '2026-01-29 08:00:00', '2026-01-30 08:00:00', '192.168.1.100', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) Chrome/120.0.0.0'),

-- Active researcher sessions
(2, 'a1b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef123456', '2026-01-29 09:15:00', '2026-01-30 09:15:00', '192.168.1.101', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Firefox/121.0'),
(3, 'b2c3d4e5f67890123456789012345678901abcdef01234567890abcdef1234567', '2026-01-28 14:30:00', '2026-01-29 14:30:00', '192.168.1.102', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) Safari/17.2'),

-- Active HCP sessions
(7, 'c3d4e5f6789012345678901234567890abcdef012345678901abcdef01234567', '2026-01-29 07:45:00', '2026-01-30 07:45:00', '10.0.0.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0'),

-- Active participant sessions
(10, 'd4e5f67890123456789012345678901abcdef0123456789012abcdef012345678', '2026-01-29 10:00:00', '2026-01-30 10:00:00', '73.45.123.89', 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_2 like Mac OS X) Safari/604.1'),
(11, 'e5f678901234567890123456789012abcdef01234567890123abcdef0123456789', '2026-01-29 11:30:00', '2026-01-30 11:30:00', '98.76.54.32', 'Mozilla/5.0 (Android 14; Mobile) Chrome/120.0.0.0'),

-- Expired sessions (for testing session cleanup)
(4, 'f67890123456789012345678901234abcdef012345678901234abcdef01234567', '2026-01-25 09:00:00', '2026-01-26 09:00:00', '192.168.1.103', 'Mozilla/5.0 (Linux; Android 13) Chrome/119.0.0.0'),
(12, '0789012345678901234567890123abcdef0123456789012345abcdef012345678', '2026-01-20 16:45:00', '2026-01-21 16:45:00', '45.67.89.123', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Edge/120.0.0.0');

-- HCP Patient Links (test data)
-- HCP AccountIDs: 3 (hcp@hb.com), 10 (Dr. Williams), 11 (Dr. Johnson), 12 (Dr. Brown)
-- Participant AccountIDs: 2 (part@hb.com), 13-22 (additional participants)
INSERT IGNORE INTO HcpPatientLink (HcpID, PatientID, Status, RequestedBy) VALUES
-- hcp@hb.com (AccountID 3) — active links for full dashboard demo
(3, 2, 'active', 'hcp'),      -- part@hb.com linked to hcp@hb.com (active)
(3, 13, 'active', 'hcp'),     -- participant 13 linked to hcp@hb.com (active)
(3, 14, 'active', 'hcp'),     -- participant 14 linked to hcp@hb.com (active)
(3, 15, 'pending', 'hcp'),    -- pending request FROM hcp@hb.com TO participant 15
(3, 16, 'pending', 'patient'),-- pending request FROM participant 16 TO hcp@hb.com (can accept)
(3, 17, 'rejected', 'hcp'),   -- rejected link (historical)
-- Dr. Williams (AccountID 10)
(10, 2, 'active', 'hcp'),
(10, 13, 'active', 'hcp'),
(10, 18, 'pending', 'patient'), -- participant 18 requesting Dr. Williams
-- Dr. Johnson (AccountID 11) — pending from HCP side (patient must accept)
(11, 2, 'pending', 'hcp'),
(11, 19, 'active', 'hcp'),
-- Dr. Brown (AccountID 12)
(12, 20, 'active', 'hcp'),
(12, 21, 'active', 'hcp');

-- ── FriendRequests seed data ──────────────────────────────────────────────
-- Mirror active HCP-patient links so contacts list is populated on fresh DB
-- HCP is always RequesterID (matches auto-creation logic in hcp_links.py)
INSERT IGNORE INTO FriendRequests (RequesterID, TargetEmail, TargetAccountID, Status) VALUES
-- hcp@hb.com (3) ↔ active patients
(3, 'part@hb.com', 2, 'accepted'),
(3, 'john.smith@email.com', 13, 'accepted'),
(3, 'maria.garcia@email.com', 14, 'accepted'),
-- Dr. Williams (10) ↔ active patients
(10, 'part@hb.com', 2, 'accepted'),
(10, 'john.smith@email.com', 13, 'accepted'),
-- Dr. Johnson (11) ↔ active patients
(11, 'william.thomas@email.com', 19, 'accepted'),
-- Dr. Brown (12) ↔ active patients
(12, 'elizabeth.hernandez@email.com', 20, 'accepted'),
(12, 'david.moore@email.com', 21, 'accepted'),
-- Researcher pair: research@hb.com (4) ↔ sarah.chen (5)
(4, 'sarah.chen@healthbank.com', 5, 'accepted');

-- ── Messaging seed data ────────────────────────────────────────────────────
-- ConvID 1: Direct conversation between part@hb.com (AccountID 2) and Dr. Williams (AccountID 10)
INSERT IGNORE INTO Conversations (ConvID, ConvType) VALUES (1, 'direct');
INSERT IGNORE INTO ConversationParticipants (ConvID, AccountID) VALUES (1, 2), (1, 10);
INSERT IGNORE INTO Messages (ConvID, SenderID, Body) VALUES
  (1, 10, 'Hello, I have reviewed your latest results.'),
  (1, 2, 'Thank you, Doctor. I had some questions about my health data.');

-- ConvID 2: Direct conversation between two researchers (AccountIDs 4 and 5)
INSERT IGNORE INTO Conversations (ConvID, ConvType) VALUES (2, 'direct');
INSERT IGNORE INTO ConversationParticipants (ConvID, AccountID) VALUES (2, 4), (2, 5);
INSERT IGNORE INTO Messages (ConvID, SenderID, Body) VALUES
  (2, 4, 'Have you reviewed the latest survey data?'),
  (2, 5, 'Yes, I will share my analysis shortly.');

-- ConvID 3: hcp@hb.com (AccountID 3) with part@hb.com (AccountID 2)
INSERT IGNORE INTO Conversations (ConvID, ConvType) VALUES (3, 'direct');
INSERT IGNORE INTO ConversationParticipants (ConvID, AccountID) VALUES (3, 2), (3, 3);
INSERT IGNORE INTO Messages (ConvID, SenderID, Body) VALUES
  (3, 3, 'Good morning! I have reviewed your recent health data. Everything looks good.'),
  (3, 2, 'Thank you, that is reassuring to hear.'),
  (3, 3, 'Please continue with the current medication schedule and complete the next survey when it becomes available.');

-- ConvID 4: hcp@hb.com (AccountID 3) with participant 13
INSERT IGNORE INTO Conversations (ConvID, ConvType) VALUES (4, 'direct');
INSERT IGNORE INTO ConversationParticipants (ConvID, AccountID) VALUES (4, 3), (4, 13);
INSERT IGNORE INTO Messages (ConvID, SenderID, Body) VALUES
  (4, 3, 'Hello, I wanted to follow up on your last survey responses.'),
  (4, 13, 'I have been feeling much better lately, thank you.');

-- ============================================================================
-- CONSENT RECORDS
-- All 33 test accounts have signed consent version 1.0.
-- Admin (RoleID=4) is code-exempt but included for completeness.
-- ============================================================================
INSERT IGNORE INTO ConsentRecord (AccountID, RoleID, ConsentVersion, DocumentLanguage, DocumentText, SignatureName, SignedAt) VALUES
-- Original 4 accounts
(1,  4, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Admin User',        '2024-01-01 09:00:00'),
(2,  1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Participant User',  '2024-01-01 09:00:00'),
(3,  3, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'HCP User',          '2024-01-01 09:00:00'),
(4,  2, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Research User',     '2024-01-01 09:00:00'),
-- Researchers (5-9)
(5,  2, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Sarah Chen',        '2024-01-15 10:30:00'),
(6,  2, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Michael Rodriguez', '2024-02-01 14:00:00'),
(7,  2, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Emily Thompson',    '2024-02-15 09:15:00'),
(8,  2, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'David Kim',         '2024-03-01 11:45:00'),
(9,  2, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Jennifer Patel',    '2024-03-15 16:00:00'),
-- HCPs (10-12)
(10, 3, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Dr. Robert Williams', '2024-01-20 08:00:00'),
(11, 3, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Dr. Amanda Johnson',  '2024-02-10 10:00:00'),
(12, 3, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Dr. James Brown',     '2024-03-05 13:30:00'),
-- Participants (13-33)
(13, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'John Smith',        '2024-04-01 09:00:00'),
(14, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Maria Garcia',      '2024-04-02 10:30:00'),
(15, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'James Wilson',      '2024-04-03 14:15:00'),
(16, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Linda Martinez',    '2024-04-05 11:00:00'),
(17, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Robert Anderson',   '2024-04-08 08:45:00'),
(18, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Patricia Taylor',   '2024-04-10 16:30:00'),
(19, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'William Thomas',    '2024-04-12 09:20:00'),
(20, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Elizabeth Hernandez','2024-04-15 13:00:00'),
(21, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'David Moore',       '2024-04-18 10:45:00'),
(22, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Jennifer Jackson',  '2024-04-20 15:15:00'),
(23, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Richard Martin',    '2024-04-22 08:30:00'),
(24, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Susan Lee',         '2024-04-25 11:45:00'),
(25, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Joseph Perez',      '2024-04-28 14:00:00'),
(26, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Margaret White',    '2024-05-01 09:30:00'),
(27, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Charles Harris',    '2024-05-05 16:00:00'),
(28, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Dorothy Clark',     '2024-05-08 10:15:00'),
(29, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Thomas Lewis',      '2024-05-12 13:45:00'),
(30, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Nancy Robinson',    '2024-05-15 08:00:00'),
(31, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Christopher Walker','2024-05-18 11:30:00'),
(32, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Karen Hall',        '2024-05-20 15:45:00'),
(33, 1, '1.0', 'en', 'I agree to the HealthBank terms of service and privacy policy.', 'Daniel Young',      '2024-05-22 10:00:00');

-- ── French translations for seed questions ─────────────────────────────────
INSERT INTO QuestionTranslations (QuestionID, LanguageCode, Title, QuestionContent) VALUES
(1, 'fr', 'Groupe d''âge', 'Quelle est votre tranche d''âge ?'),
(2, 'fr', 'Identité de genre', 'Quelle est votre identité de genre ?'),
(3, 'fr', 'Statut d''emploi', 'Quelle est votre situation professionnelle actuelle ?'),
(4, 'fr', 'Niveau d''anxiété', 'Au cours des 2 dernières semaines, à quelle fréquence vous êtes-vous senti nerveux, anxieux ou sur les nerfs ?'),
(5, 'fr', 'Qualité du sommeil', 'Comment évalueriez-vous la qualité globale de votre sommeil ?'),
(6, 'fr', 'Niveau de stress', 'Sur une échelle de 1 à 10, à quel point vous sentez-vous stressé au cours d''une journée moyenne ?'),
(7, 'fr', 'Satisfaction de la vie', 'Sur une échelle de 1 à 10, dans quelle mesure êtes-vous globalement satisfait de votre vie ?'),
(8, 'fr', 'Dépistage de la dépression', 'Au cours des deux dernières semaines, à quelle fréquence vous êtes-vous senti déprimé ou désespéré ?'),
(9, 'fr', 'Évaluation de l''humeur', 'Comment évalueriez-vous votre humeur actuelle ?'),
(10, 'fr', 'Soutien social', 'Pensez-vous bénéficier d''un soutien social adéquat de la part de vos amis et de votre famille ?'),
(11, 'fr', 'Fréquence d''exercice', 'Combien de fois par semaine pratiquez-vous une activité physique modérée à vigoureuse ?'),
(12, 'fr', 'Conditions chroniques', 'Souffrez-vous de l''une des maladies chroniques suivantes ? (Sélectionnez tout ce qui s''applique)'),
(13, 'fr', 'Niveau de douleur', 'Sur une échelle de 1 à 10, comment évalueriez-vous votre niveau de douleur actuel ?'),
(14, 'fr', 'État de la tension artérielle', 'Un professionnel de la santé vous a-t-il déjà dit que vous souffriez d''hypertension ?'),
(15, 'fr', 'Accès aux soins de santé', 'À quand remonte votre dernière visite chez un professionnel de la santé ?'),
(16, 'fr', 'Consommation de substances', 'Consommez-vous actuellement des produits du tabac ?'),
(17, 'fr', 'Consommation d''alcool', 'À quelle fréquence consommez-vous des boissons alcoolisées ?'),
(18, 'fr', 'Bien-être général', 'Sur une échelle de 1 à 10, comment évalueriez-vous votre bien-être général ?'),
(19, 'fr', 'IMC', 'Quel est votre IMC (indice de masse corporelle) approximatif ?'),
(20, 'fr', 'Pas par jour', 'En moyenne, combien de pas faites-vous par jour ?'),
(21, 'fr', 'Notes sur les antécédents médicaux', 'Veuillez décrire tout antécédent médical important ou tout problème de santé persistant.'),
(22, 'fr', 'Qualité du régime', 'Comment évalueriez-vous la qualité globale de votre alimentation ?'),
(23, 'fr', 'Prise d''eau', 'Combien de verres d''eau buvez-vous par jour en moyenne ?'),
(24, 'fr', 'Histoire du tabagisme', 'Avez-vous déjà fumé des cigarettes ?'),
(25, 'fr', 'Soutien en santé mentale', 'Avez-vous déjà demandé un soutien professionnel en santé mentale ?'),
(26, 'fr', 'Antécédents médicaux familiaux', 'Votre famille a-t-elle des antécédents dans les cas suivants ? (Sélectionnez tout ce qui s''applique)'),
(27, 'fr', 'Personnes à charge', 'Avez-vous des personnes à charge ?');

INSERT INTO QuestionOptionTranslations (OptionID, LanguageCode, OptionText) VALUES
(1, 'fr', '18-24'), (2, 'fr', '25-34'), (3, 'fr', '35-44'),
(4, 'fr', '45-54'), (5, 'fr', '55-64'), (6, 'fr', '65+'),
(7, 'fr', 'Homme'), (8, 'fr', 'Femme'), (9, 'fr', 'Non binaire'),
(10, 'fr', 'Je préfère ne pas dire'), (11, 'fr', 'Autre'),
(12, 'fr', 'Employé à temps plein'), (13, 'fr', 'Employé à temps partiel'),
(14, 'fr', 'Travailleur indépendant'), (15, 'fr', 'Sans emploi'),
(16, 'fr', 'Étudiant'), (17, 'fr', 'À la retraite'), (18, 'fr', 'Autre'),
(19, 'fr', 'Pas du tout'), (20, 'fr', 'Plusieurs jours'),
(21, 'fr', 'Plus de la moitié des jours'), (22, 'fr', 'Presque tous les jours'),
(23, 'fr', 'Excellent'), (24, 'fr', 'Bon'), (25, 'fr', 'Passable'),
(26, 'fr', 'Mauvais'), (27, 'fr', 'Très mauvais'),
(28, 'fr', 'Pas du tout'), (29, 'fr', 'Plusieurs jours'),
(30, 'fr', 'Plus de la moitié des jours'), (31, 'fr', 'Presque tous les jours'),
(32, 'fr', 'Excellent'), (33, 'fr', 'Bon'), (34, 'fr', 'Neutre'),
(35, 'fr', 'Mauvais'), (36, 'fr', 'Très mauvais'),
(37, 'fr', 'Diabète'), (38, 'fr', 'Maladie cardiaque'),
(39, 'fr', 'Asthme/MPOC'), (40, 'fr', 'Arthrite'),
(41, 'fr', 'Cancer'), (42, 'fr', 'Aucune des réponses ci-dessus'),
(43, 'fr', 'Au cours du dernier mois'), (44, 'fr', 'Au cours des 6 derniers mois'),
(45, 'fr', 'Au cours de la dernière année'), (46, 'fr', 'Il y a plus d''un an'),
(47, 'fr', 'Jamais'),
(48, 'fr', 'Oui, quotidiennement'), (49, 'fr', 'Oui, de temps en temps'),
(50, 'fr', 'Non, j''ai arrêté'), (51, 'fr', 'Non, jamais'),
(52, 'fr', 'Tous les jours'), (53, 'fr', 'Plusieurs fois par semaine'),
(54, 'fr', 'Une fois par semaine'), (55, 'fr', 'Rarement'), (56, 'fr', 'Jamais'),
(57, 'fr', 'Excellent'), (58, 'fr', 'Bon'), (59, 'fr', 'Passable'), (60, 'fr', 'Mauvais'),
(61, 'fr', 'Oui, je fume actuellement'), (62, 'fr', 'Oui, mais j''ai arrêté'),
(63, 'fr', 'Non, jamais'),
(64, 'fr', 'Oui, je reçois actuellement du soutien'), (65, 'fr', 'Oui, dans le passé'),
(66, 'fr', 'Non, mais j''y réfléchirais'), (67, 'fr', 'Non, et je ne l''envisagerais pas'),
(68, 'fr', 'Maladie cardiaque'), (69, 'fr', 'Diabète'), (70, 'fr', 'Cancer'),
(71, 'fr', 'Troubles de santé mentale'), (72, 'fr', 'Maladies auto-immunes'),
(73, 'fr', 'Aucune des réponses ci-dessus');
