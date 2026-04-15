-- Migration: Add indexes to Responses table for query performance
-- Created with the Assistance of Claude Code

USE healthdatabase;

-- Check and create indexes only if they don't exist
SET @db = DATABASE();

SELECT COUNT(*) INTO @exists FROM information_schema.statistics WHERE table_schema = @db AND table_name = 'Responses' AND index_name = 'idx_responses_survey';
SET @sql = IF(@exists = 0, 'CREATE INDEX idx_responses_survey ON Responses(SurveyID)', 'SELECT "idx_responses_survey already exists"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SELECT COUNT(*) INTO @exists FROM information_schema.statistics WHERE table_schema = @db AND table_name = 'Responses' AND index_name = 'idx_responses_participant';
SET @sql = IF(@exists = 0, 'CREATE INDEX idx_responses_participant ON Responses(ParticipantID)', 'SELECT "idx_responses_participant already exists"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SELECT COUNT(*) INTO @exists FROM information_schema.statistics WHERE table_schema = @db AND table_name = 'Responses' AND index_name = 'idx_responses_question';
SET @sql = IF(@exists = 0, 'CREATE INDEX idx_responses_question ON Responses(QuestionID)', 'SELECT "idx_responses_question already exists"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SELECT COUNT(*) INTO @exists FROM information_schema.statistics WHERE table_schema = @db AND table_name = 'Responses' AND index_name = 'idx_responses_survey_participant';
SET @sql = IF(@exists = 0, 'CREATE INDEX idx_responses_survey_participant ON Responses(SurveyID, ParticipantID)', 'SELECT "idx_responses_survey_participant already exists"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
