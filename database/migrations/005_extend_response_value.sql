-- Migration: Extend ResponseValue from VARCHAR(255) to LONGTEXT
-- Created with the Assistance of Claude Code
--
-- VARCHAR(255) is too short for JSON arrays (multi-choice) and
-- open-ended text responses.

USE healthdatabase;

ALTER TABLE Responses MODIFY COLUMN ResponseValue LONGTEXT;
