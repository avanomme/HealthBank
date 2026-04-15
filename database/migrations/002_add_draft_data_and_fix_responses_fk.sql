-- Migration: Add DraftData column to SurveyAssignment and fix Responses FK
-- Created with the Assistance of Claude Code
--
-- 1. Adds DraftData TEXT column to SurveyAssignment for survey auto-save
-- 2. Changes Responses.SurveyID FK to ON DELETE SET NULL so surveys can be
--    deleted while preserving response data

USE healthdatabase;

-- 1. Add DraftData column to SurveyAssignment if it doesn't exist
SET @dbname = DATABASE();
SET @tablename = 'SurveyAssignment';
SET @columnname = 'DraftData';
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = @dbname
    AND TABLE_NAME = @tablename
    AND COLUMN_NAME = @columnname
  ) > 0,
  'SELECT "DraftData column already exists"',
  CONCAT('ALTER TABLE ', @tablename, ' ADD COLUMN ', @columnname, ' TEXT NULL')
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- 2. Make Responses.SurveyID nullable (if not already)
ALTER TABLE Responses MODIFY COLUMN SurveyID INT NULL;

-- 3. Drop existing FK on Responses.SurveyID and recreate with ON DELETE SET NULL
--    The default constraint name varies, so find and drop it dynamically.
SET @fk_name = (
  SELECT CONSTRAINT_NAME
  FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
  WHERE TABLE_SCHEMA = @dbname
    AND TABLE_NAME = 'Responses'
    AND COLUMN_NAME = 'SurveyID'
    AND REFERENCED_TABLE_NAME = 'Survey'
  LIMIT 1
);

SET @drop_fk = IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE Responses DROP FOREIGN KEY ', @fk_name),
  'SELECT "No FK to drop"'
);
PREPARE stmt FROM @drop_fk;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Re-add FK with ON DELETE SET NULL
ALTER TABLE Responses
  ADD CONSTRAINT fk_responses_survey
  FOREIGN KEY (SurveyID) REFERENCES Survey(SurveyID) ON DELETE SET NULL;
