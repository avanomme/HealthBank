-- Migration 007: Fix missing ON DELETE CASCADE constraints and add Messages index
-- Date: 2026-04-03
-- Fixes referential integrity gaps identified in audit 08_database_schema.md

-- ── QuestionList.SurveyID — add ON DELETE CASCADE ──────────────────────────
ALTER TABLE QuestionList
    DROP FOREIGN KEY QuestionList_ibfk_1,
    ADD CONSTRAINT fk_questionlist_survey
    FOREIGN KEY (SurveyID) REFERENCES Survey(SurveyID) ON DELETE CASCADE;

-- ── SurveyAssignment — add ON DELETE CASCADE for SurveyID and AccountID ────
ALTER TABLE SurveyAssignment
    DROP FOREIGN KEY SurveyAssignment_ibfk_1,
    DROP FOREIGN KEY SurveyAssignment_ibfk_2,
    ADD CONSTRAINT fk_surveyassignment_survey
    FOREIGN KEY (SurveyID) REFERENCES Survey(SurveyID) ON DELETE CASCADE,
    ADD CONSTRAINT fk_surveyassignment_account
    FOREIGN KEY (AccountID) REFERENCES AccountData(AccountID) ON DELETE CASCADE;

-- ── AccountDeletionRequest — ON DELETE CASCADE for AccountID, SET NULL for ReviewedBy
ALTER TABLE AccountDeletionRequest
    DROP FOREIGN KEY AccountDeletionRequest_ibfk_1,
    DROP FOREIGN KEY AccountDeletionRequest_ibfk_2,
    ADD CONSTRAINT fk_deletionrequest_account
    FOREIGN KEY (AccountID) REFERENCES AccountData(AccountID) ON DELETE CASCADE,
    ADD CONSTRAINT fk_deletionrequest_reviewer
    FOREIGN KEY (ReviewedBy) REFERENCES AccountData(AccountID) ON DELETE SET NULL;

-- ── ConsentRecord — add ON DELETE CASCADE for AccountID ─────────────────────
ALTER TABLE ConsentRecord
    DROP FOREIGN KEY ConsentRecord_ibfk_1,
    ADD CONSTRAINT fk_consentrecord_account
    FOREIGN KEY (AccountID) REFERENCES AccountData(AccountID) ON DELETE CASCADE;

-- ── Messages — add ON DELETE CASCADE for SenderID ───────────────────────────
ALTER TABLE Messages
    DROP FOREIGN KEY Messages_ibfk_2,
    ADD CONSTRAINT fk_messages_sender
    FOREIGN KEY (SenderID) REFERENCES AccountData(AccountID) ON DELETE CASCADE;

-- ── Messages — composite index for per-conversation message fetching ─────────
CREATE INDEX idx_messages_conv ON Messages (ConvID, SentAt);
