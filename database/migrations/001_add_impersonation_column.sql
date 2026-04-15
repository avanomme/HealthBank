-- Migration: Add ImpersonatedBy column to Sessions table
-- Created with the Assistance of Claude Code
--
-- This migration adds support for admin impersonation of users.
-- The ImpersonatedBy column stores the AccountID of the admin who initiated
-- the impersonation session.

USE healthdatabase;

-- Add ImpersonatedBy column if it doesn't exist
SET @dbname = DATABASE();
SET @tablename = 'Sessions';
SET @columnname = 'ImpersonatedBy';
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = @dbname
    AND TABLE_NAME = @tablename
    AND COLUMN_NAME = @columnname
  ) > 0,
  'SELECT "Column already exists"',
  CONCAT('ALTER TABLE ', @tablename, ' ADD COLUMN ', @columnname, ' INT NULL')
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Add foreign key constraint if column was just added
-- Note: Run this separately if the column already exists without the FK
-- ALTER TABLE Sessions ADD CONSTRAINT FK_Sessions_ImpersonatedBy
--   FOREIGN KEY (ImpersonatedBy) REFERENCES AccountData(AccountID);
