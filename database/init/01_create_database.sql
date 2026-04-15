-- Created with the Assistance of Claude Code
CREATE DATABASE IF NOT EXISTS healthdatabase;
USE healthdatabase;

CREATE TABLE IF NOT EXISTS Auth(
	AuthID INT PRIMARY KEY AUTO_INCREMENT,
	PasswordHash VARCHAR(255) NOT NULL,
	ResetToken VARCHAR(64) NULL,
	ResetTokenExpires DATETIME NULL,
	MustChangePassword BOOLEAN DEFAULT FALSE,
	FailedLoginAttempts INT NOT NULL DEFAULT 0,
	LockedUntil DATETIME NULL,
	UNIQUE KEY uq_auth_resettoken (ResetToken)
);

CREATE TABLE IF NOT EXISTS Roles(
	RoleID INT PRIMARY KEY AUTO_INCREMENT,
	RoleName VARCHAR(50) UNIQUE NOT NULL,
	Description TEXT
);

-- Insert default roles (IGNORE prevents errors on restart when data exists)
INSERT IGNORE INTO Roles (RoleID, RoleName, Description) VALUES
(1, 'participant', 'Standard user who takes surveys'),
(2, 'researcher', 'Creates and manages surveys'),
(3, 'hcp', 'Healthcare professional with elevated access'),
(4, 'admin', 'Full system access');

CREATE TABLE IF NOT EXISTS AccountData(
	AccountID INT PRIMARY KEY AUTO_INCREMENT,
	FirstName VARCHAR(64),
	LastName VARCHAR (64),
	Email VARCHAR(255) UNIQUE,
	AuthID INT,
	RoleID INT DEFAULT 1,
	IsActive BOOLEAN DEFAULT TRUE,
	Birthdate DATE NULL,
	Gender VARCHAR(32) NULL,
	CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
	LastLogin DATETIME NULL,
	TosAcceptedAt DATETIME NULL,
	TosVersion VARCHAR(32) NULL,
  	TosAcceptedIp VARBINARY(16) NULL,
	ConsentSignedAt DATETIME NULL,
	ConsentVersion VARCHAR(32) NULL,
	FOREIGN KEY (AuthID) REFERENCES Auth(AuthID),
	FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

CREATE TABLE IF NOT EXISTS Sessions(
	SessionID INT PRIMARY KEY AUTO_INCREMENT,
	AccountID INT,
	TokenHash TEXT,
	CreatedAt DATETIME,
	ExpiresAt DATETIME,
	IsActive BOOLEAN DEFAULT TRUE,
	RevokedAt DATETIME NULL,
	IpAddress VARCHAR(50),
	UserAgent VARCHAR(512),
	ImpersonatedBy INT NULL,
	ViewingAsUserID INT NULL,
	FOREIGN KEY (AccountID) REFERENCES AccountData(AccountID),
	FOREIGN KEY (ImpersonatedBy) REFERENCES AccountData(AccountID),
	FOREIGN KEY (ViewingAsUserID) REFERENCES AccountData(AccountID)
);

CREATE TABLE IF NOT EXISTS DataTypes(
	DataID INT PRIMARY KEY AUTO_INCREMENT,
	Name VARCHAR(255),
	Description TEXT
);

CREATE TABLE IF NOT EXISTS Survey(
	SurveyID INT PRIMARY KEY AUTO_INCREMENT,
	Title VARCHAR(255) NOT NULL,
	Description TEXT,
	Status ENUM('in-progress', 'complete', 'not-started', 'cancelled') DEFAULT 'not-started',
	PublicationStatus ENUM('draft', 'published', 'closed') DEFAULT 'draft',
	CreatorID INT,
	StartDate DATETIME,
	EndDate DATETIME,
	CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
	UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (CreatorID) REFERENCES AccountData(AccountID)
);

CREATE TABLE IF NOT EXISTS QuestionCategories(
	CategoryID INT PRIMARY KEY AUTO_INCREMENT,
	CategoryKey VARCHAR(64) UNIQUE NOT NULL,
	DisplayOrder INT DEFAULT 0,
	CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Insert default question categories (IGNORE prevents errors on restart when data exists)
INSERT IGNORE INTO QuestionCategories (CategoryID, CategoryKey, DisplayOrder) VALUES
(1, 'demographics', 0),
(2, 'mental_health', 1),
(3, 'physical_health', 2),
(4, 'lifestyle', 3),
(5, 'symptoms', 4);

CREATE TABLE IF NOT EXISTS QuestionBank(
	QuestionID INT PRIMARY KEY AUTO_INCREMENT,
	Title VARCHAR(128),
	QuestionContent TEXT NOT NULL,
	ResponseType ENUM('number', 'yesno', 'openended', 'single_choice', 'multi_choice', 'scale') NOT NULL,
	Category VARCHAR(64),
	ScaleMin INT DEFAULT 1,
	ScaleMax INT DEFAULT 10,
	QuestionData INT,
	CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
	UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (QuestionData) REFERENCES DataTypes(DataID)
);

CREATE TABLE IF NOT EXISTS QuestionOptions(
	OptionID INT PRIMARY KEY AUTO_INCREMENT,
	QuestionID INT NOT NULL,
	OptionText VARCHAR(255) NOT NULL,
	DisplayOrder INT DEFAULT 0,
	FOREIGN KEY (QuestionID) REFERENCES QuestionBank(QuestionID) ON DELETE CASCADE
);

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

CREATE TABLE IF NOT EXISTS QuestionList(
	ID INT PRIMARY KEY AUTO_INCREMENT,
	SurveyID INT,
	QuestionID INT,
	IsRequired BOOLEAN NOT NULL DEFAULT FALSE,
	FOREIGN KEY (SurveyID) REFERENCES Survey(SurveyID) ON DELETE CASCADE,
	FOREIGN KEY (QuestionID) REFERENCES QuestionBank(QuestionID)
);

CREATE TABLE IF NOT EXISTS Responses(
	ResponseID INT PRIMARY KEY AUTO_INCREMENT,
	SurveyID INT NULL,
	ParticipantID INT NULL,
	QuestionID INT,
	ResponseValue LONGTEXT,
	FOREIGN KEY (SurveyID) REFERENCES Survey(SurveyID) ON DELETE SET NULL,
	FOREIGN KEY (ParticipantID) REFERENCES AccountData(AccountID) ON DELETE SET NULL,
	FOREIGN KEY (QuestionID) REFERENCES QuestionBank(QuestionID),
	INDEX idx_responses_survey (SurveyID),
	INDEX idx_responses_participant (ParticipantID),
	INDEX idx_responses_question (QuestionID),
	INDEX idx_responses_survey_participant (SurveyID, ParticipantID)
);

CREATE TABLE IF NOT EXISTS SurveyAssignment (
	AssignmentID INT PRIMARY KEY AUTO_INCREMENT,
	SurveyID INT NOT NULL,
	AccountID INT NOT NULL,
	AssignedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
	DueDate DATETIME,
	CompletedAt DATETIME,
	Status ENUM('pending', 'completed', 'expired') DEFAULT 'pending',
	DraftData TEXT,
	FOREIGN KEY (SurveyID) REFERENCES Survey(SurveyID) ON DELETE CASCADE,
	FOREIGN KEY (AccountID) REFERENCES AccountData(AccountID) ON DELETE CASCADE,
	UNIQUE KEY unique_survey_account (SurveyID, AccountID)
);

CREATE TABLE IF NOT EXISTS SurveyTemplate (
	TemplateID INT PRIMARY KEY AUTO_INCREMENT,
	Title VARCHAR(255) NOT NULL,
	Description TEXT,
	CreatorID INT,
	IsPublic BOOLEAN DEFAULT FALSE,
	CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
	UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (CreatorID) REFERENCES AccountData(AccountID)
);

CREATE TABLE IF NOT EXISTS TemplateQuestions (
	ID INT PRIMARY KEY AUTO_INCREMENT,
	TemplateID INT NOT NULL,
	QuestionID INT NOT NULL,
	IsRequired BOOLEAN NOT NULL DEFAULT FALSE,
	DisplayOrder INT DEFAULT 0,
	FOREIGN KEY (TemplateID) REFERENCES SurveyTemplate(TemplateID) ON DELETE CASCADE,
	FOREIGN KEY (QuestionID) REFERENCES QuestionBank(QuestionID),
	UNIQUE KEY unique_template_question (TemplateID, QuestionID)
);

CREATE TABLE IF NOT EXISTS Account2FA (
    AccountID INT NOT NULL,
    TotpSecret VARCHAR(255) NOT NULL,
    IsEnabled TINYINT(1) NOT NULL DEFAULT 0,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    VerifiedAt DATETIME NULL,
    LastUsedAt DATETIME NULL,
    PRIMARY KEY (AccountID),
    CONSTRAINT fk_account2fa_account FOREIGN KEY (AccountID) REFERENCES AccountData(AccountID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS AuditEvent (
  	AuditEventID   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  	CreatedAt      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  	RequestID      CHAR(36) NULL,
  	ActorType      ENUM('user','admin','system','service') NOT NULL DEFAULT 'user',
  	ActorAccountID BIGINT UNSIGNED NULL,
  	IpAddress      VARBINARY(16) NULL,
  	UserAgent      VARCHAR(512) NULL,
  	HttpMethod     VARCHAR(8) NULL,
  	Path           VARCHAR(512) NULL,
  	Action         VARCHAR(64) NOT NULL,
  	ResourceType   VARCHAR(64) NOT NULL,
  	ResourceID     VARCHAR(128) NULL,
  	Status         ENUM('success','failure','denied') NOT NULL,
  	HttpStatusCode SMALLINT UNSIGNED NULL,
  	ErrorCode      VARCHAR(64) NULL,
  	MetadataJSON   JSON NULL,
  	PRIMARY KEY (AuditEventID),
  	INDEX idx_createdat (CreatedAt),
  	INDEX idx_request (RequestID),
  	INDEX idx_actor (ActorAccountID, CreatedAt),
  	INDEX idx_resource (ResourceType, ResourceID, CreatedAt),
  	INDEX idx_action (Action, CreatedAt)
);

CREATE TABLE IF NOT EXISTS AccountRequest (
	RequestID INT PRIMARY KEY AUTO_INCREMENT,
	FirstName VARCHAR(64) NOT NULL,
	LastName VARCHAR(64) NOT NULL,
	Email VARCHAR(255) NOT NULL,
	RoleID INT NOT NULL,
	Birthdate DATE NULL,
	Gender VARCHAR(32) NULL,
	GenderOther VARCHAR(64) NULL,
	Status ENUM('pending','approved','rejected') DEFAULT 'pending',
	AdminNotes TEXT NULL,
	ReviewedBy INT NULL,
	CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
	ReviewedAt DATETIME NULL,
	FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
	FOREIGN KEY (ReviewedBy) REFERENCES AccountData(AccountID)
);

CREATE TABLE IF NOT EXISTS AccountDeletionRequest (
	RequestID INT PRIMARY KEY AUTO_INCREMENT,
	AccountID INT NOT NULL,
	Status ENUM('pending','approved','rejected') DEFAULT 'pending',
	AdminNotes TEXT NULL,
	ReviewedBy INT NULL,
	RequestedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
	ReviewedAt DATETIME NULL,
	FOREIGN KEY (AccountID) REFERENCES AccountData(AccountID) ON DELETE CASCADE,
	FOREIGN KEY (ReviewedBy) REFERENCES AccountData(AccountID) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS ConsentRecord (
	ConsentRecordID INT PRIMARY KEY AUTO_INCREMENT,
	AccountID INT NOT NULL,
	RoleID INT NOT NULL,
	ConsentVersion VARCHAR(32) NOT NULL,
	DocumentLanguage VARCHAR(5) NOT NULL DEFAULT 'en',
	DocumentText LONGTEXT NOT NULL,
	SignatureName VARCHAR(128) NOT NULL,
	SignedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	IpAddress VARBINARY(16) NULL,
	UserAgent VARCHAR(512) NULL,
	FOREIGN KEY (AccountID) REFERENCES AccountData(AccountID) ON DELETE CASCADE,
	FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
	INDEX idx_consent_account (AccountID, SignedAt)
);

CREATE TABLE IF NOT EXISTS mfa_challenges (
	ChallengeID BIGINT AUTO_INCREMENT PRIMARY KEY,
	AccountID INT NOT NULL,
	TokenHash CHAR(64) NOT NULL,
	Purpose VARCHAR(20) NOT NULL DEFAULT 'login',
	CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
	ExpiresAt DATETIME NOT NULL,
	UsedAt DATETIME NULL,
	RevokedAt DATETIME NULL,
	AttemptCount INT NOT NULL DEFAULT 0,
	LastAttemptAt DATETIME NULL,

	UNIQUE KEY uq_mfa_tokenhash (TokenHash),
	KEY idx_mfa_account (AccountID),
	KEY idx_mfa_expires (ExpiresAt),

	CONSTRAINT fk_mfa_account FOREIGN KEY (AccountID) REFERENCES AccountData(AccountID) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS HcpPatientLink (
    LinkID INT PRIMARY KEY AUTO_INCREMENT,
    HcpID INT NOT NULL,
    PatientID INT NOT NULL,
    Status ENUM('pending', 'active', 'rejected', 'removed') DEFAULT 'pending',
    RequestedBy ENUM('hcp', 'patient') NOT NULL,
    RequestedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    ConsentRevoked TINYINT(1) NOT NULL DEFAULT 0,
    UNIQUE KEY unique_hcp_patient (HcpID, PatientID),
    FOREIGN KEY (HcpID) REFERENCES AccountData(AccountID) ON DELETE CASCADE,
    FOREIGN KEY (PatientID) REFERENCES AccountData(AccountID) ON DELETE CASCADE
);

-- ── Messaging ────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS Conversations (
    ConvID INT PRIMARY KEY AUTO_INCREMENT,
    ConvType ENUM('direct') NOT NULL DEFAULT 'direct',
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ConversationParticipants (
    ConvID INT NOT NULL,
    AccountID INT NOT NULL,
    JoinedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    LastReadAt DATETIME NULL DEFAULT NULL,
    PRIMARY KEY (ConvID, AccountID),
    FOREIGN KEY (ConvID) REFERENCES Conversations(ConvID) ON DELETE CASCADE,
    FOREIGN KEY (AccountID) REFERENCES AccountData(AccountID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Messages (
    MessageID INT PRIMARY KEY AUTO_INCREMENT,
    ConvID INT NOT NULL,
    SenderID INT NOT NULL,
    Body TEXT NOT NULL,
    SentAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ConvID) REFERENCES Conversations(ConvID) ON DELETE CASCADE,
    FOREIGN KEY (SenderID) REFERENCES AccountData(AccountID) ON DELETE CASCADE,
    INDEX idx_messages_conv (ConvID, SentAt)
);

-- ── System Settings ──────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS SystemSettings (
    SettingKey   VARCHAR(64)  PRIMARY KEY,
    SettingValue VARCHAR(255) NOT NULL,
    Description  TEXT,
    UpdatedBy    INT NULL,
    UpdatedAt    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (UpdatedBy) REFERENCES AccountData(AccountID) ON DELETE SET NULL
);

INSERT IGNORE INTO SystemSettings (SettingKey, SettingValue, Description) VALUES
('k_anonymity_threshold',   '1',     'Minimum distinct respondents before research data is exposed. Default: 1.'),
('registration_open',       'true',  'Whether new account requests are accepted. Default: true.'),
('maintenance_mode',        'false', 'When true, non-admin users cannot login or access protected endpoints. Default: false.'),
('maintenance_message',     '',      'Optional message shown to users during maintenance (e.g. expected return time). Default: empty.'),
('max_login_attempts',      '10',    'Failed login attempts before temporary lockout. 0 = unlimited. Default: 10.'),
('lockout_duration_minutes','30',    'Minutes an account is locked after exceeding max failed attempts. Default: 30.'),
('consent_required',        'true',  'Whether users must sign the consent form before accessing the app. Default: true.');


CREATE TABLE IF NOT EXISTS FriendRequests (
    RequestID INT PRIMARY KEY AUTO_INCREMENT,
    RequesterID INT NOT NULL,
    TargetEmail VARCHAR(255) NOT NULL,
    TargetAccountID INT,
    Status ENUM('pending', 'accepted', 'rejected') DEFAULT 'pending',
    RequestedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_friend_request (RequesterID, TargetEmail),
    FOREIGN KEY (RequesterID) REFERENCES AccountData(AccountID) ON DELETE CASCADE,
    FOREIGN KEY (TargetAccountID) REFERENCES AccountData(AccountID) ON DELETE SET NULL
);

-- ─────────────────────────────────────────────────────────────────────────────
-- Health Tracking
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
    MetricID     INT          NOT NULL,
    LanguageCode VARCHAR(8)   NOT NULL,
    DisplayName  VARCHAR(128) NOT NULL,
    Description  TEXT,
    PRIMARY KEY (MetricID, LanguageCode),
    FOREIGN KEY (MetricID) REFERENCES TrackingMetric(MetricID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS TrackingCategoryTranslation (
    CategoryID   INT          NOT NULL,
    LanguageCode VARCHAR(8)   NOT NULL,
    DisplayName  VARCHAR(128) NOT NULL,
    Description  TEXT,
    PRIMARY KEY (CategoryID, LanguageCode),
    FOREIGN KEY (CategoryID) REFERENCES TrackingCategory(CategoryID) ON DELETE CASCADE
);
