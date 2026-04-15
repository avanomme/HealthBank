-- Migration: Add question translation tables
-- Created with the Assistance of Claude Code

USE healthdatabase;

CREATE TABLE IF NOT EXISTS QuestionTranslations(
    TranslationID INT PRIMARY KEY AUTO_INCREMENT,
    QuestionID INT NOT NULL,
    LanguageCode VARCHAR(5) NOT NULL,
    Title VARCHAR(128),
    QuestionContent TEXT NOT NULL,
    FOREIGN KEY (QuestionID) REFERENCES QuestionBank(QuestionID) ON DELETE CASCADE,
    UNIQUE KEY unique_question_lang (QuestionID, LanguageCode)
);

CREATE TABLE IF NOT EXISTS QuestionOptionTranslations(
    TranslationID INT PRIMARY KEY AUTO_INCREMENT,
    OptionID INT NOT NULL,
    LanguageCode VARCHAR(5) NOT NULL,
    OptionText VARCHAR(255) NOT NULL,
    FOREIGN KEY (OptionID) REFERENCES QuestionOptions(OptionID) ON DELETE CASCADE,
    UNIQUE KEY unique_option_lang (OptionID, LanguageCode)
);
