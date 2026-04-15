-- Migration: Fix Responses.ParticipantID FK to ON DELETE SET NULL
-- Created with the Assistance of Claude Code

USE healthdatabase;

-- Make ParticipantID nullable
ALTER TABLE Responses MODIFY COLUMN ParticipantID INT NULL;

-- Drop existing FK and re-add with ON DELETE SET NULL
SET @db = DATABASE();
SET @fk_name = (
  SELECT CONSTRAINT_NAME
  FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
  WHERE TABLE_SCHEMA = @db
    AND TABLE_NAME = 'Responses'
    AND COLUMN_NAME = 'ParticipantID'
    AND REFERENCED_TABLE_NAME = 'AccountData'
  LIMIT 1
);

SET @drop_fk = IF(@fk_name IS NOT NULL,
  CONCAT('ALTER TABLE Responses DROP FOREIGN KEY ', @fk_name),
  'SELECT "No FK to drop"'
);
PREPARE stmt FROM @drop_fk;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

ALTER TABLE Responses
  ADD CONSTRAINT fk_responses_participant
  FOREIGN KEY (ParticipantID) REFERENCES AccountData(AccountID) ON DELETE SET NULL;
