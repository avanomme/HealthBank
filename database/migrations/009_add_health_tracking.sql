-- Migration 009: Health Tracking
-- Creates tables and seed data for the participant health tracking feature.
-- Tables: TrackingCategory, TrackingMetric, TrackingEntry,
--         TrackingCategoryTranslation, TrackingMetricTranslation

-- ─────────────────────────────────────────────────────────────────────────────
-- 1. TABLE CREATION
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS TrackingCategory (
    CategoryID   INT AUTO_INCREMENT PRIMARY KEY,
    CategoryKey  VARCHAR(64)  NOT NULL UNIQUE,
    DisplayName  VARCHAR(128) NOT NULL,
    Description  TEXT,
    Icon         VARCHAR(64),
    DisplayOrder INT          NOT NULL DEFAULT 0,
    IsActive     TINYINT(1)   NOT NULL DEFAULT 1,
    IsDeleted    TINYINT(1)   NOT NULL DEFAULT 0,
    CreatedAt    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS TrackingMetric (
    MetricID      INT AUTO_INCREMENT PRIMARY KEY,
    CategoryID    INT          NOT NULL,
    MetricKey     VARCHAR(64)  NOT NULL UNIQUE,
    DisplayName   VARCHAR(128) NOT NULL,
    Description   TEXT,
    MetricType    ENUM('number','scale','yesno','single_choice','text') NOT NULL,
    Unit          VARCHAR(32),
    ScaleMin      INT          DEFAULT 1,
    ScaleMax      INT          DEFAULT 10,
    ChoiceOptions JSON,
    Frequency     ENUM('daily','weekly','monthly','any') NOT NULL DEFAULT 'daily',
    DisplayOrder  INT          NOT NULL DEFAULT 0,
    IsActive      TINYINT(1)   NOT NULL DEFAULT 1,
    IsDeleted     TINYINT(1)   NOT NULL DEFAULT 0,
    IsBaseline    TINYINT(1)   NOT NULL DEFAULT 0,
    CreatedBy     INT,
    CreatedAt     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (CategoryID) REFERENCES TrackingCategory(CategoryID) ON DELETE RESTRICT,
    FOREIGN KEY (CreatedBy)  REFERENCES AccountData(AccountID)       ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS TrackingEntry (
    EntryID       INT AUTO_INCREMENT PRIMARY KEY,
    ParticipantID INT        NOT NULL,
    MetricID      INT        NOT NULL,
    Value         TEXT       NOT NULL,
    Notes         TEXT,
    EntryDate     DATE       NOT NULL,
    IsBaseline    TINYINT(1) NOT NULL DEFAULT 0,
    CreatedAt     DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_entry (ParticipantID, MetricID, EntryDate),
    FOREIGN KEY (ParticipantID) REFERENCES AccountData(AccountID)    ON DELETE CASCADE,
    FOREIGN KEY (MetricID)      REFERENCES TrackingMetric(MetricID)  ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS TrackingMetricTranslation (
    MetricID     INT         NOT NULL,
    LanguageCode VARCHAR(8)  NOT NULL,
    DisplayName  VARCHAR(128) NOT NULL,
    Description  TEXT,
    PRIMARY KEY (MetricID, LanguageCode),
    FOREIGN KEY (MetricID) REFERENCES TrackingMetric(MetricID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS TrackingCategoryTranslation (
    CategoryID   INT         NOT NULL,
    LanguageCode VARCHAR(8)  NOT NULL,
    DisplayName  VARCHAR(128) NOT NULL,
    Description  TEXT,
    PRIMARY KEY (CategoryID, LanguageCode),
    FOREIGN KEY (CategoryID) REFERENCES TrackingCategory(CategoryID) ON DELETE CASCADE
);


-- Seed data (categories, metrics, translations) is in database/init/04_health_tracking_seed.sql
-- and runs automatically on fresh builds. Re-run that file manually if seeding an existing DB.
