# Database Schema Audit Report
**HealthBank Project**  
**Date:** April 3, 2026  
**Audit Level:** Complete Schema Analysis

---

## Section 1: Table Inventory

### 1.1 Core Tables (28 Total)

#### Auth Table
- **Columns:** AuthID (INT PK, AUTO_INCREMENT), PasswordHash (VARCHAR 255 NOT NULL), ResetToken (VARCHAR 64 NULL), ResetTokenExpires (DATETIME NULL), MustChangePassword (BOOLEAN), FailedLoginAttempts (INT NOT NULL DEFAULT 0), LockedUntil (DATETIME NULL)
- **Primary Key:** AuthID
- **Foreign Keys:** 0
- **Unique Constraints:** uq_auth_resettoken (ResetToken)
- **Indexes:** PK only
- **Status:** Well-structured; password hash is appropriately sized

#### Roles Table
- **Columns:** RoleID (INT PK, AUTO_INCREMENT), RoleName (VARCHAR 50 UNIQUE NOT NULL), Description (TEXT)
- **Primary Key:** RoleID
- **Foreign Keys:** 0
- **Unique Constraints:** RoleName
- **Indexes:** PK only
- **Default Data:** 4 roles (participant, researcher, hcp, admin) inserted via INSERT IGNORE

#### AccountData Table
- **Columns:** AccountID (INT PK, AUTO_INCREMENT), FirstName (VARCHAR 64), LastName (VARCHAR 64), Email (VARCHAR 255 UNIQUE), AuthID (INT), RoleID (INT DEFAULT 1), IsActive (BOOLEAN DEFAULT TRUE), Birthdate (DATE NULL), Gender (VARCHAR 32 NULL), CreatedAt (DATETIME DEFAULT CURRENT_TIMESTAMP), LastLogin (DATETIME NULL), TosAcceptedAt (DATETIME NULL), TosVersion (VARCHAR 32 NULL), TosAcceptedIp (VARBINARY 16 NULL), ConsentSignedAt (DATETIME NULL), ConsentVersion (VARCHAR 32 NULL)
- **Primary Key:** AccountID
- **Foreign Keys:** 2 (AuthID → Auth, RoleID → Roles)
- **Unique Constraints:** Email
- **Indexes:** PK only
- **Status:** Account lifecycle fields properly included

#### Sessions Table
- **Columns:** SessionID (INT PK, AUTO_INCREMENT), AccountID (INT), TokenHash (TEXT), CreatedAt (DATETIME), ExpiresAt (DATETIME), IsActive (BOOLEAN DEFAULT TRUE), RevokedAt (DATETIME NULL), IpAddress (VARCHAR 50), UserAgent (VARCHAR 512), ImpersonatedBy (INT NULL), ViewingAsUserID (INT NULL)
- **Primary Key:** SessionID
- **Foreign Keys:** 3 (AccountID → AccountData, ImpersonatedBy → AccountData, ViewingAsUserID → AccountData)
- **Unique Constraints:** None
- **Indexes:** PK only
- **Status:** Missing indexes on frequently filtered columns (AccountID, ExpiresAt)

#### DataTypes Table
- **Columns:** DataID (INT PK, AUTO_INCREMENT), Name (VARCHAR 255), Description (TEXT)
- **Primary Key:** DataID
- **Foreign Keys:** 0
- **Unique Constraints:** None
- **Indexes:** PK only
- **Status:** Minimal usage; no constraints on Name column

#### Survey Table
- **Columns:** SurveyID (INT PK, AUTO_INCREMENT), Title (VARCHAR 255 NOT NULL), Description (TEXT), Status (ENUM 'in-progress', 'complete', 'not-started', 'cancelled' DEFAULT 'not-started'), PublicationStatus (ENUM 'draft', 'published', 'closed' DEFAULT 'draft'), CreatorID (INT), StartDate (DATETIME), EndDate (DATETIME), CreatedAt (DATETIME DEFAULT CURRENT_TIMESTAMP), UpdatedAt (DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE)
- **Primary Key:** SurveyID
- **Foreign Keys:** 1 (CreatorID → AccountData)
- **Unique Constraints:** None
- **Indexes:** PK only
- **Status:** Missing indexes on CreatorID, Status for filtering

#### QuestionCategories Table
- **Columns:** CategoryID (INT PK, AUTO_INCREMENT), CategoryKey (VARCHAR 64 UNIQUE NOT NULL), DisplayOrder (INT DEFAULT 0), CreatedAt (DATETIME DEFAULT CURRENT_TIMESTAMP)
- **Primary Key:** CategoryID
- **Foreign Keys:** 0
- **Unique Constraints:** CategoryKey
- **Indexes:** PK only
- **Default Data:** 5 categories inserted via INSERT IGNORE

#### QuestionBank Table
- **Columns:** QuestionID (INT PK, AUTO_INCREMENT), Title (VARCHAR 128), QuestionContent (TEXT NOT NULL), ResponseType (ENUM 'number', 'yesno', 'openended', 'single_choice', 'multi_choice', 'scale' NOT NULL), IsRequired (BOOLEAN DEFAULT FALSE), Category (VARCHAR 64), ScaleMin (INT DEFAULT 1), ScaleMax (INT DEFAULT 10), QuestionData (INT), CreatedAt (DATETIME DEFAULT CURRENT_TIMESTAMP), UpdatedAt (DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE)
- **Primary Key:** QuestionID
- **Foreign Keys:** 1 (QuestionData → DataTypes)
- **Unique Constraints:** None
- **Indexes:** PK only
- **Status:** Category field is VARCHAR but doesn't FK to QuestionCategories (data quality risk)

#### QuestionOptions Table
- **Columns:** OptionID (INT PK, AUTO_INCREMENT), QuestionID (INT NOT NULL), OptionText (VARCHAR 255 NOT NULL), DisplayOrder (INT DEFAULT 0)
- **Primary Key:** OptionID
- **Foreign Keys:** 1 (QuestionID → QuestionBank ON DELETE CASCADE)
- **Unique Constraints:** None
- **Indexes:** PK only
- **Status:** Well-designed; cascade delete ensures orphan prevention

#### QuestionTranslations Table
- **Columns:** TranslationID (INT PK, AUTO_INCREMENT), QuestionID (INT NOT NULL), LanguageCode (VARCHAR 5 NOT NULL), Title (VARCHAR 128), QuestionContent (TEXT NOT NULL)
- **Primary Key:** TranslationID
- **Foreign Keys:** 1 (QuestionID → QuestionBank ON DELETE CASCADE)
- **Unique Constraints:** unique_question_lang (QuestionID, LanguageCode)
- **Indexes:** PK only
- **Status:** Well-designed; composite unique constraint prevents duplicate translations

#### QuestionOptionTranslations Table
- **Columns:** TranslationID (INT PK, AUTO_INCREMENT), OptionID (INT NOT NULL), LanguageCode (VARCHAR 5 NOT NULL), OptionText (VARCHAR 255 NOT NULL)
- **Primary Key:** TranslationID
- **Foreign Keys:** 1 (OptionID → QuestionOptions ON DELETE CASCADE)
- **Unique Constraints:** unique_option_lang (OptionID, LanguageCode)
- **Indexes:** PK only
- **Status:** Well-designed mirror of QuestionTranslations

#### QuestionList Table
- **Columns:** ID (INT PK, AUTO_INCREMENT), SurveyID (INT), QuestionID (INT)
- **Primary Key:** ID
- **Foreign Keys:** 2 (SurveyID → Survey, QuestionID → QuestionBank)
- **Unique Constraints:** None
- **Indexes:** PK only
- **Status:** RISK - Missing ON DELETE CASCADE for SurveyID; orphans possible

#### Responses Table
- **Columns:** ResponseID (INT PK, AUTO_INCREMENT), SurveyID (INT NULL), ParticipantID (INT NULL), QuestionID (INT), ResponseValue (LONGTEXT)
- **Primary Key:** ResponseID
- **Foreign Keys:** 3 (SurveyID → Survey ON DELETE SET NULL [migrated], ParticipantID → AccountData ON DELETE SET NULL [migrated], QuestionID → QuestionBank [no cascade])
- **Unique Constraints:** None
- **Indexes:** 4 (idx_responses_survey, idx_responses_participant, idx_responses_question, idx_responses_survey_participant)
- **Status:** Good index coverage; nullable FKs appropriate for data preservation

#### SurveyAssignment Table
- **Columns:** AssignmentID (INT PK, AUTO_INCREMENT), SurveyID (INT NOT NULL), AccountID (INT NOT NULL), AssignedAt (DATETIME DEFAULT CURRENT_TIMESTAMP), DueDate (DATETIME), CompletedAt (DATETIME), Status (ENUM 'pending', 'completed', 'expired' DEFAULT 'pending'), DraftData (TEXT)
- **Primary Key:** AssignmentID
- **Foreign Keys:** 2 (SurveyID → Survey, AccountID → AccountData)
- **Unique Constraints:** unique_survey_account (SurveyID, AccountID)
- **Indexes:** PK only
- **Status:** RISK - No ON DELETE CASCADE/SET NULL; orphans possible if Survey/Account deleted

#### SurveyTemplate Table
- **Columns:** TemplateID (INT PK, AUTO_INCREMENT), Title (VARCHAR 255 NOT NULL), Description (TEXT), CreatorID (INT), IsPublic (BOOLEAN DEFAULT FALSE), CreatedAt (DATETIME DEFAULT CURRENT_TIMESTAMP), UpdatedAt (DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE)
- **Primary Key:** TemplateID
- **Foreign Keys:** 1 (CreatorID → AccountData)
- **Unique Constraints:** None
- **Indexes:** PK only
- **Status:** Missing ON DELETE CASCADE for CreatorID

#### TemplateQuestions Table
- **Columns:** ID (INT PK, AUTO_INCREMENT), TemplateID (INT NOT NULL), QuestionID (INT NOT NULL), DisplayOrder (INT DEFAULT 0)
- **Primary Key:** ID
- **Foreign Keys:** 2 (TemplateID → SurveyTemplate ON DELETE CASCADE, QuestionID → QuestionBank [no cascade])
- **Unique Constraints:** unique_template_question (TemplateID, QuestionID)
- **Indexes:** PK only
- **Status:** Good cascade on TemplateID; question reference could be restricted

#### Account2FA Table
- **Columns:** AccountID (INT NOT NULL), TotpSecret (VARCHAR 255 NOT NULL), IsEnabled (TINYINT(1) NOT NULL DEFAULT 0), CreatedAt (DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP), VerifiedAt (DATETIME NULL), LastUsedAt (DATETIME NULL)
- **Primary Key:** AccountID
- **Foreign Keys:** 1 (AccountID → AccountData ON DELETE CASCADE)
- **Unique Constraints:** None
- **Indexes:** PK only
- **Status:** Well-designed; cascade delete cleans up 2FA on account deletion

#### AuditEvent Table
- **Columns:** AuditEventID (BIGINT UNSIGNED PK, AUTO_INCREMENT), CreatedAt (DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP), RequestID (CHAR 36 NULL), ActorType (ENUM 'user','admin','system','service' NOT NULL DEFAULT 'user'), ActorAccountID (BIGINT UNSIGNED NULL), IpAddress (VARBINARY 16 NULL), UserAgent (VARCHAR 512 NULL), HttpMethod (VARCHAR 8 NULL), Path (VARCHAR 512 NULL), Action (VARCHAR 64 NOT NULL), ResourceType (VARCHAR 64 NOT NULL), ResourceID (VARCHAR 128 NULL), Status (ENUM 'success','failure','denied' NOT NULL), HttpStatusCode (SMALLINT UNSIGNED NULL), ErrorCode (VARCHAR 64 NULL), MetadataJSON (JSON NULL)
- **Primary Key:** AuditEventID
- **Foreign Keys:** 0 (ActorAccountID is intentionally unlinked to preserve historical records)
- **Unique Constraints:** None
- **Indexes:** 5 (idx_createdat, idx_request, idx_actor, idx_resource, idx_action)
- **Status:** Excellent index coverage for audit queries; proper denormalization strategy

#### AccountRequest Table
- **Columns:** RequestID (INT PK, AUTO_INCREMENT), FirstName (VARCHAR 64 NOT NULL), LastName (VARCHAR 64 NOT NULL), Email (VARCHAR 255 NOT NULL), RoleID (INT NOT NULL), Birthdate (DATE NULL), Gender (VARCHAR 32 NULL), GenderOther (VARCHAR 64 NULL), Status (ENUM 'pending','approved','rejected' DEFAULT 'pending'), AdminNotes (TEXT NULL), ReviewedBy (INT NULL), CreatedAt (DATETIME DEFAULT CURRENT_TIMESTAMP), ReviewedAt (DATETIME NULL)
- **Primary Key:** RequestID
- **Foreign Keys:** 2 (RoleID → Roles, ReviewedBy → AccountData)
- **Unique Constraints:** None
- **Indexes:** PK only
- **Status:** Missing email uniqueness constraint during pending state; multiple requests for same email possible

#### AccountDeletionRequest Table
- **Columns:** RequestID (INT PK, AUTO_INCREMENT), AccountID (INT NOT NULL), Status (ENUM 'pending','approved','rejected' DEFAULT 'pending'), AdminNotes (TEXT NULL), ReviewedBy (INT NULL), RequestedAt (DATETIME DEFAULT CURRENT_TIMESTAMP), ReviewedAt (DATETIME NULL)
- **Primary Key:** RequestID
- **Foreign Keys:** 2 (AccountID → AccountData [no cascade], ReviewedBy → AccountData)
- **Unique Constraints:** None
- **Indexes:** PK only
- **Status:** CRITICAL - Missing ON DELETE CASCADE; orphaned deletion requests if account hard-deleted first

#### ConsentRecord Table
- **Columns:** ConsentRecordID (INT PK, AUTO_INCREMENT), AccountID (INT NOT NULL), RoleID (INT NOT NULL), ConsentVersion (VARCHAR 32 NOT NULL), DocumentLanguage (VARCHAR 5 NOT NULL DEFAULT 'en'), DocumentText (LONGTEXT NOT NULL), SignatureName (VARCHAR 128 NOT NULL), SignedAt (DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP), IpAddress (VARBINARY 16 NULL), UserAgent (VARCHAR 512 NULL)
- **Primary Key:** ConsentRecordID
- **Foreign Keys:** 2 (AccountID → AccountData, RoleID → Roles)
- **Unique Constraints:** None
- **Indexes:** 1 (idx_consent_account on AccountID, SignedAt)
- **Status:** Good index; missing ON DELETE CASCADE for AccountID

#### mfa_challenges Table
- **Columns:** ChallengeID (BIGINT AUTO_INCREMENT PK), AccountID (INT NOT NULL), TokenHash (CHAR 64 NOT NULL), Purpose (VARCHAR 20 NOT NULL DEFAULT 'login'), CreatedAt (DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP()), ExpiresAt (DATETIME NOT NULL), UsedAt (DATETIME NULL), RevokedAt (DATETIME NULL), AttemptCount (INT NOT NULL DEFAULT 0), LastAttemptAt (DATETIME NULL)
- **Primary Key:** ChallengeID
- **Foreign Keys:** 1 (AccountID → AccountData ON DELETE CASCADE)
- **Unique Constraints:** uq_mfa_tokenhash (TokenHash)
- **Indexes:** 3 (uq_mfa_tokenhash, idx_mfa_account, idx_mfa_expires)
- **Status:** Excellent security design; proper cascade delete and expiration indexing

#### HcpPatientLink Table
- **Columns:** LinkID (INT PK, AUTO_INCREMENT), HcpID (INT NOT NULL), PatientID (INT NOT NULL), Status (ENUM 'pending', 'active', 'rejected', 'removed' DEFAULT 'pending'), RequestedBy (ENUM 'hcp', 'patient' NOT NULL), RequestedAt (DATETIME DEFAULT CURRENT_TIMESTAMP), UpdatedAt (DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE), ConsentRevoked (TINYINT(1) NOT NULL DEFAULT 0)
- **Primary Key:** LinkID
- **Foreign Keys:** 2 (HcpID → AccountData ON DELETE CASCADE, PatientID → AccountData ON DELETE CASCADE)
- **Unique Constraints:** unique_hcp_patient (HcpID, PatientID)
- **Indexes:** PK only
- **Status:** Good design with cascade deletes; prevents duplicate links

#### Conversations Table
- **Columns:** ConvID (INT PK, AUTO_INCREMENT), ConvType (ENUM 'direct' NOT NULL DEFAULT 'direct'), CreatedAt (DATETIME DEFAULT CURRENT_TIMESTAMP)
- **Primary Key:** ConvID
- **Foreign Keys:** 0
- **Unique Constraints:** None
- **Indexes:** PK only
- **Status:** Minimal; extensible design for future conversation types

#### ConversationParticipants Table
- **Columns:** ConvID (INT NOT NULL), AccountID (INT NOT NULL), JoinedAt (DATETIME DEFAULT CURRENT_TIMESTAMP), LastReadAt (DATETIME NULL)
- **Primary Key:** (ConvID, AccountID)
- **Foreign Keys:** 2 (ConvID → Conversations ON DELETE CASCADE, AccountID → AccountData ON DELETE CASCADE)
- **Unique Constraints:** None (composite PK implies uniqueness)
- **Indexes:** PK only
- **Status:** Well-designed; composite key and cascade deletes prevent orphans

#### Messages Table
- **Columns:** MessageID (INT PK, AUTO_INCREMENT), ConvID (INT NOT NULL), SenderID (INT NOT NULL), Body (TEXT NOT NULL), SentAt (DATETIME DEFAULT CURRENT_TIMESTAMP)
- **Primary Key:** MessageID
- **Foreign Keys:** 2 (ConvID → Conversations ON DELETE CASCADE, SenderID → AccountData [no cascade])
- **Unique Constraints:** None
- **Indexes:** PK only
- **Status:** RISK - Missing index on ConvID for conversation retrieval; SenderID has no cascade

#### SystemSettings Table
- **Columns:** SettingKey (VARCHAR 64 PK), SettingValue (VARCHAR 255 NOT NULL), Description (TEXT), UpdatedBy (INT NULL), UpdatedAt (DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE)
- **Primary Key:** SettingKey
- **Foreign Keys:** 1 (UpdatedBy → AccountData ON DELETE SET NULL)
- **Unique Constraints:** None
- **Indexes:** PK only
- **Default Data:** 5 settings inserted via INSERT IGNORE
- **Status:** Good design; ON DELETE SET NULL preserves audit trail

#### FriendRequests Table
- **Columns:** RequestID (INT PK, AUTO_INCREMENT), RequesterID (INT NOT NULL), TargetEmail (VARCHAR 255 NOT NULL), TargetAccountID (INT NULL), Status (ENUM 'pending', 'accepted', 'rejected' DEFAULT 'pending'), RequestedAt (DATETIME DEFAULT CURRENT_TIMESTAMP)
- **Primary Key:** RequestID
- **Foreign Keys:** 2 (RequesterID → AccountData ON DELETE CASCADE, TargetAccountID → AccountData ON DELETE SET NULL)
- **Unique Constraints:** unique_friend_request (RequesterID, TargetEmail)
- **Indexes:** PK only
- **Status:** Good design; allows pre-account friend requests and cascades properly

---

## Section 2: Foreign Key Coverage Gaps

### Critical Gaps (Referential Integrity Risk)

1. **QuestionList.SurveyID** - MISSING CASCADE
   - Issue: If Survey is deleted, orphaned QuestionList entries remain
   - Recommendation: Add `ON DELETE CASCADE` or implement soft delete

2. **SurveyAssignment** - MISSING DELETE ACTIONS
   - Issue: SurveyID has no ON DELETE action; AccountID has no action
   - Risk: Orphaned assignments if Survey or Account is deleted
   - Recommendation: Add `ON DELETE CASCADE` for SurveyID, `ON DELETE CASCADE` for AccountID

3. **AccountDeletionRequest.AccountID** - MISSING CASCADE
   - Issue: If account is deleted, deletion request loses its reference
   - Risk: Orphaned deletion requests in the system
   - Recommendation: Add `ON DELETE CASCADE`

4. **ConsentRecord.AccountID** - MISSING CASCADE
   - Issue: If account is deleted, consent records become orphaned
   - Risk: Loss of audit trail for consent
   - Recommendation: Add `ON DELETE CASCADE` (preserve historical records)

5. **SurveyTemplate.CreatorID** - MISSING CASCADE
   - Issue: If creator is deleted, orphaned templates remain
   - Recommendation: Add `ON DELETE CASCADE` or `ON DELETE SET NULL` with soft delete consideration

6. **Messages.SenderID** - MISSING CASCADE
   - Issue: If sender is deleted, message loses sender reference
   - Risk: Foreign key constraint would break (should use SET NULL instead)
   - Recommendation: Add `ON DELETE SET NULL`

7. **QuestionBank.Category** - NOT A FOREIGN KEY
   - Issue: Category is VARCHAR(64), not a FK to QuestionCategories
   - Risk: Data integrity - categories can be misspelled, orphaned, inconsistent
   - Recommendation: Change to FK: `FOREIGN KEY (Category) REFERENCES QuestionCategories(CategoryKey)`

### Moderate Gaps (Foreign Key Defined, But Delete Behavior Concerns)

8. **Survey.CreatorID** - NO DELETE ACTION SPECIFIED
   - Current: CreatorID references AccountData with no cascade
   - Risk: If creator is deleted, survey becomes orphaned (NULL is not set)
   - Recommendation: Add explicit `ON DELETE SET NULL` or `ON DELETE RESTRICT`

9. **AccountRequest.ReviewedBy** - NO CASCADE
   - Current: ReviewedBy references AccountData without action
   - Risk: If reviewer is deleted, request loses approval reference
   - Recommendation: Add `ON DELETE SET NULL` to preserve request history

10. **SurveyTemplate.CreatorID** - NO DELETE ACTION SPECIFIED
    - Issue: Template loses creator reference if account deleted
    - Recommendation: Add `ON DELETE SET NULL`

### Data Preservation Gaps

11. **TemplateQuestions.QuestionID** - NO CASCADE
    - Risk: If question is deleted, template-question links become orphaned
    - Status: Lower priority if questions are never deleted

---

## Section 3: Index Coverage Gaps

### High-Priority Missing Indexes (Common Query Patterns)

1. **Sessions Table**
   - Missing: `idx_sessions_accountid` on AccountID (session lookup by user)
   - Missing: `idx_sessions_expiresat` on ExpiresAt (cleanup queries)
   - Missing: `idx_sessions_isactive` on IsActive (active session queries)

2. **Survey Table**
   - Missing: `idx_survey_creatorid` on CreatorID (user's surveys)
   - Missing: `idx_survey_status` on Status (filtering by status)
   - Missing: `idx_survey_publicationstatus` on PublicationStatus

3. **Messages Table**
   - Missing: `idx_messages_convid` on ConvID (conversation retrieval - CRITICAL)
   - Missing: `idx_messages_senderid` on SenderID (message by user)
   - Missing: `idx_messages_sentat` on SentAt (chronological ordering)

4. **SurveyAssignment Table**
   - Missing: `idx_assignment_accountid` on AccountID (user's assignments)
   - Missing: `idx_assignment_status` on Status (filter by status)
   - Missing: `idx_assignment_duedate` on DueDate (due date tracking)

5. **QuestionList Table**
   - Missing: `idx_questionlist_surveyid` on SurveyID (survey questions)

6. **QuestionBank Table**
   - Missing: `idx_questionbank_category` on Category (category filtering)

### Moderate-Priority Missing Indexes

7. **AccountData Table**
   - Missing: `idx_accountdata_roleId` on RoleID (filter by role)
   - Missing: `idx_accountdata_isactive` on IsActive (active users)
   - Missing: `idx_accountdata_created_at` on CreatedAt (date range queries)

8. **Responses Table**
   - Has: idx_responses_survey, idx_responses_participant, idx_responses_question, idx_responses_survey_participant
   - Status: Good coverage, but consider: `idx_responses_questionid_participantid` for per-user response retrieval

9. **SurveyTemplate Table**
   - Missing: `idx_surveytemplate_creatorid` on CreatorID (user's templates)
   - Missing: `idx_surveytemplate_ispublic` on IsPublic (public templates)

10. **HcpPatientLink Table**
    - Missing: `idx_hcppatientlink_hcpid` on HcpID (HCP's patients)
    - Missing: `idx_hcppatientlink_patientid` on PatientID (patient's HCPs)
    - Missing: `idx_hcppatientlink_status` on Status (active links)

11. **ConversationParticipants Table**
    - Missing: `idx_convpart_accountid` on AccountID (user's conversations)

12. **FriendRequests Table**
    - Missing: `idx_friendrequests_requesterid` on RequesterID (outgoing requests)
    - Missing: `idx_friendrequests_targetaccountid` on TargetAccountID (incoming requests)
    - Missing: `idx_friendrequests_status` on Status (pending requests)

---

## Section 4: Data Type & Constraint Issues

### 4.1 Missing NOT NULL Constraints

| Table | Column | Issue | Risk |
|-------|--------|-------|------|
| Auth | PasswordHash | NOT NULL ✓ | Secure |
| Auth | ResetToken | NULL | Allows multiple null tokens |
| AccountData | FirstName | NULL | Can create accounts without name |
| AccountData | LastName | NULL | Can create accounts without name |
| AccountData | AuthID | NULL | FK can be null (orphaned accounts) |
| Survey | Title | NOT NULL ✓ | Secure |
| Survey | CreatorID | NULL | Can create surveys without creator |
| DataTypes | Name | NULL | Unnamed data types possible |
| DataTypes | Description | NULL | OK for optional field |
| QuestionBank | Title | NULL | Questions without titles |
| QuestionBank | QuestionData | NULL | Optional data type reference |
| SurveyTemplate | CreatorID | NULL | Template without creator |
| AccountRequest | Email | NOT NULL ✓ | Secure |
| ConsentRecord | AccountID | NOT NULL ✓ | Secure |
| mfa_challenges | Purpose | NOT NULL ✓ | Secure |

### 4.2 VARCHAR Length Analysis

| Column | Current | Issue | Recommendation |
|--------|---------|-------|-----------------|
| PasswordHash (Auth) | VARCHAR(255) | PBKDF2 hashes ~88 bytes, adequate | OK |
| ResetToken (Auth) | VARCHAR(64) | Typical for 256-bit token hex | OK |
| Email (AccountData) | VARCHAR(255) | RFC 5321 max ~254 chars | OK |
| FirstName/LastName | VARCHAR(64) | Covers 99.9% of names | OK |
| Gender | VARCHAR(32) | Allows custom values | OK |
| RoleName (Roles) | VARCHAR(50) | 'participant', 'researcher', 'hcp', 'admin' - OK | OK |
| CategoryKey | VARCHAR(64) | 'demographics', 'mental_health', etc. | OK |
| Title (Survey) | VARCHAR(255) | Reasonable for survey titles | OK |
| OptionText | VARCHAR(255) | May be insufficient for long options | Consider LONGTEXT |
| Description | TEXT | Appropriate | OK |
| UserAgent | VARCHAR(512) | Modern User-Agent headers ~300-600 chars | Borderline; consider 1024 |
| Path | VARCHAR(512) | URL paths can be very long | Risk; consider 2048 or TEXT |

### 4.3 Binary/IP Storage

- **TosAcceptedIp** (VARBINARY 16) - Correct for IPv4 (4 bytes) or IPv6 (16 bytes)
- **IpAddress** (VARBINARY 16 in AuditEvent) - Correct
- **IpAddress** (VARCHAR 50 in Sessions) - INCONSISTENT; should be VARBINARY 16
- **IpAddress** (VARCHAR 50 in AuditEvent) - Uses VARBINARY 16 correctly

### 4.4 Temporal Issues

- **DATETIME** used consistently (no timezone support)
- **CreatedAt** uses `DEFAULT CURRENT_TIMESTAMP` (good)
- **UpdatedAt** uses `ON UPDATE CURRENT_TIMESTAMP` (good)
- No explicit timezone handling; assumes UTC

### 4.5 Boolean Handling

- **BOOLEAN** used in AccountData (IsActive, MustChangePassword) - Good, stored as TINYINT
- **TINYINT(1)** used in Account2FA (IsEnabled) and HcpPatientLink - Functionally equivalent
- Consistent usage pattern

### 4.6 ENUM Constraints

| Table | Column | Values | Issues |
|-------|--------|--------|--------|
| Survey | Status | 'in-progress', 'complete', 'not-started', 'cancelled' | OK |
| Survey | PublicationStatus | 'draft', 'published', 'closed' | OK |
| QuestionBank | ResponseType | 'number', 'yesno', 'openended', 'single_choice', 'multi_choice', 'scale' | OK |
| SurveyAssignment | Status | 'pending', 'completed', 'expired' | OK |
| AccountRequest | Status | 'pending', 'approved', 'rejected' | OK |
| AccountDeletionRequest | Status | 'pending', 'approved', 'rejected' | OK |
| mfa_challenges | Purpose | 'login' (default) - extensible | OK |
| HcpPatientLink | Status | 'pending', 'active', 'rejected', 'removed' | OK |
| HcpPatientLink | RequestedBy | 'hcp', 'patient' | OK |
| Conversations | ConvType | 'direct' (default) - extensible | OK |
| FriendRequests | Status | 'pending', 'accepted', 'rejected' | OK |
| AuditEvent | ActorType | 'user', 'admin', 'system', 'service' | OK |
| AuditEvent | Status | 'success', 'failure', 'denied' | OK |

---

## Section 5: Messaging & Account Lifecycle Tables

### 5.1 Conversations Table Analysis

**Design:** Minimal; stores only ConvID, ConvType (extensible), CreatedAt
- **Gap:** No soft-delete flag; no conversation title/description
- **Gap:** No metadata field for future conversation attributes
- **Recommendation:** Consider adding `IsActive BOOLEAN DEFAULT TRUE` for soft delete

### 5.2 ConversationParticipants Table Analysis

**Design:** Composite PK on (ConvID, AccountID); includes JoinedAt and LastReadAt
- **Strengths:** Cascade deletes on both FKs; prevents duplicate entries; tracks read state
- **Gap:** No "left_at" timestamp to show when participant left
- **Recommendation:** Add `LeftAt DATETIME NULL` to track removal history

### 5.3 Messages Table Analysis

**Design:** Stores MessageID, ConvID, SenderID, Body, SentAt
- **Critical Gap:** No index on ConvID (required for retrieving conversation messages)
- **Gap:** No deletion cascade on SenderID (should be SET NULL)
- **Gap:** No soft-delete flag; deleting messages loses data
- **Gap:** No updated_at or edited_at for message edits
- **Recommendation:** Add `idx_messages_convid`, add `ON DELETE SET NULL` to SenderID, add `IsDeleted BOOLEAN DEFAULT FALSE`

### 5.4 FriendRequests Table Analysis

**Design:** Stores RequestID, RequesterID, TargetEmail, TargetAccountID, Status, RequestedAt
- **Strengths:** Allows pre-account friend requests (TargetEmail); cascade delete on requester; SET NULL on target
- **Strengths:** Unique constraint on (RequesterID, TargetEmail) prevents duplicates
- **Gap:** No indexes on common filters (requester, target, status)
- **Recommendation:** Add `idx_friendrequests_requesterid`, `idx_friendrequests_targetaccountid`, `idx_friendrequests_status`

### 5.5 AccountDeletionRequest Analysis (Lifecycle)

**Design:** Stores RequestID, AccountID, Status, AdminNotes, ReviewedBy, timestamps
- **Critical Gap:** Missing `ON DELETE CASCADE` on AccountID FK
- **Risk:** If account is hard-deleted before request is processed, orphaned request remains
- **Design Issue:** This table is for soft-delete workflow, but hard-delete can still occur
- **Recommendation:** Add `ON DELETE CASCADE` to enforce referential integrity

---

## Section 6: Summary & Recommendations

### 6.1 Critical Issues (Must Fix)

1. **QuestionList.SurveyID lacks ON DELETE CASCADE**
   - Risk: Orphaned question-survey mappings
   - Severity: High (data integrity)
   - Effort: Low (1 line SQL)

2. **SurveyAssignment lacks delete actions on both FKs**
   - Risk: Orphaned assignments if Survey/Account deleted
   - Severity: High (data loss)
   - Effort: Low (2 lines SQL)

3. **AccountDeletionRequest.AccountID lacks ON DELETE CASCADE**
   - Risk: Orphaned deletion requests
   - Severity: Critical (account lifecycle integrity)
   - Effort: Low (1 line SQL)

4. **Messages.ConvID lacks index**
   - Risk: O(n) scans for conversation message retrieval (performance)
   - Severity: High (performance degradation)
   - Effort: Low (1 index)

5. **QuestionBank.Category is not a foreign key**
   - Risk: Data integrity; inconsistent categories
   - Severity: Medium (data quality)
   - Effort: Medium (requires data migration or constraint)

### 6.2 High-Priority Issues (Should Fix)

6. **Sessions.IpAddress inconsistent data type**
   - Current: VARCHAR(50); should be VARBINARY(16)
   - Severity: Medium (consistency, storage)
   - Effort: Medium (alter table, data migration)

7. **Missing indexes on high-cardinality filter columns**
   - Affected: Sessions, Survey, SurveyAssignment, HcpPatientLink, FriendRequests
   - Severity: Medium (query performance)
   - Effort: Low (add indexes)

8. **AccountData.FirstName/LastName/AuthID not NOT NULL**
   - Risk: Invalid account state
   - Severity: Medium (data quality)
   - Effort: High (requires data cleanup)

9. **Survey.CreatorID lacks ON DELETE action**
   - Risk: CreatorID not nullable but creator can be deleted
   - Severity: Medium (foreign key violation risk)
   - Effort: Low (add ON DELETE SET NULL)

10. **Messages.SenderID lacks ON DELETE action**
    - Risk: FK constraint violation if sender deleted
    - Severity: Medium (referential integrity)
    - Effort: Low (add ON DELETE SET NULL)

### 6.3 Medium-Priority Issues (Nice to Have)

11. Add `idx_messages_senderid` and `idx_messages_sentat` for message queries
12. Add `idx_conversationparticipants_accountid` for user's conversations
13. Add `idx_responses_questionid_participantid` for response analysis
14. Add soft-delete flags (IsDeleted) to Messages and Conversations
15. Extend UserAgent VARCHAR from 512 to 1024 (modern headers)
16. Consider adding "left_at" timestamp to ConversationParticipants
17. Add explicit ON DELETE SET NULL to AccountRequest.ReviewedBy

### 6.4 Positive Findings

- AuditEvent table has excellent index coverage
- Auth table properly stores password hashes with appropriate length
- Cascade deletes properly configured on Account2FA, mfa_challenges, HcpPatientLink
- Translation tables (QuestionTranslations, QuestionOptionTranslations) well-designed
- Responses table has good index coverage after migrations
- Unique constraints prevent duplicates where needed (Email, ResetToken, unique_survey_account, etc.)

### 6.5 Migration Scripts Needed

```sql
-- Fix QuestionList FK
ALTER TABLE QuestionList
  ADD CONSTRAINT fk_questionlist_survey
  FOREIGN KEY (SurveyID) REFERENCES Survey(SurveyID) ON DELETE CASCADE;

-- Fix SurveyAssignment FKs
ALTER TABLE SurveyAssignment
  ADD CONSTRAINT fk_surveyassignment_survey
  FOREIGN KEY (SurveyID) REFERENCES Survey(SurveyID) ON DELETE CASCADE,
  ADD CONSTRAINT fk_surveyassignment_account
  FOREIGN KEY (AccountID) REFERENCES AccountData(AccountID) ON DELETE CASCADE;

-- Fix AccountDeletionRequest FK
ALTER TABLE AccountDeletionRequest
  ADD CONSTRAINT fk_accountdeletionrequest_account
  FOREIGN KEY (AccountID) REFERENCES AccountData(AccountID) ON DELETE CASCADE;

-- Fix Messages FK and add index
ALTER TABLE Messages
  DROP FOREIGN KEY FK_Messages_SenderID, -- if exists
  ADD CONSTRAINT fk_messages_senderid
  FOREIGN KEY (SenderID) REFERENCES AccountData(AccountID) ON DELETE SET NULL;
CREATE INDEX idx_messages_convid ON Messages(ConvID);
CREATE INDEX idx_messages_senderid ON Messages(SenderID);
CREATE INDEX idx_messages_sentat ON Messages(SentAt);

-- Add missing indexes
CREATE INDEX idx_sessions_accountid ON Sessions(AccountID);
CREATE INDEX idx_sessions_expiresat ON Sessions(ExpiresAt);
CREATE INDEX idx_survey_creatorid ON Survey(CreatorID);
CREATE INDEX idx_surveyassignment_accountid ON SurveyAssignment(AccountID);
CREATE INDEX idx_surveyassignment_status ON SurveyAssignment(Status);
CREATE INDEX idx_questionlist_surveyid ON QuestionList(SurveyID);
CREATE INDEX idx_hcppatientlink_hcpid ON HcpPatientLink(HcpID);
CREATE INDEX idx_hcppatientlink_patientid ON HcpPatientLink(PatientID);
CREATE INDEX idx_friendrequests_requesterid ON FriendRequests(RequesterID);
CREATE INDEX idx_friendrequests_targetaccountid ON FriendRequests(TargetAccountID);
CREATE INDEX idx_conversationparticipants_accountid ON ConversationParticipants(AccountID);

-- Fix Survey.CreatorID to be nullable and add ON DELETE SET NULL
ALTER TABLE Survey MODIFY COLUMN CreatorID INT NULL;
ALTER TABLE Survey
  DROP FOREIGN KEY fk_survey_creatorid, -- if exists
  ADD CONSTRAINT fk_survey_creatorid
  FOREIGN KEY (CreatorID) REFERENCES AccountData(AccountID) ON DELETE SET NULL;

-- Fix ConsentRecord and SurveyTemplate CreatorID
ALTER TABLE ConsentRecord
  DROP FOREIGN KEY fk_consentrecord_account, -- if exists
  ADD CONSTRAINT fk_consentrecord_account
  FOREIGN KEY (AccountID) REFERENCES AccountData(AccountID) ON DELETE CASCADE;

ALTER TABLE SurveyTemplate MODIFY COLUMN CreatorID INT NULL;
ALTER TABLE SurveyTemplate
  DROP FOREIGN KEY fk_surveytemplate_creatorid, -- if exists
  ADD CONSTRAINT fk_surveytemplate_creatorid
  FOREIGN KEY (CreatorID) REFERENCES AccountData(AccountID) ON DELETE SET NULL;
```

---

## Audit Conclusion

The HealthBank database schema is **functionally complete** but has **critical referential integrity gaps** that could lead to orphaned records and data loss. The migrations show active development and improvements (response indexing, draft data support, translation tables).

**Immediate Action Items:**
1. Fix critical FK cascade issues (QuestionList, SurveyAssignment, AccountDeletionRequest)
2. Add missing index on Messages.ConvID
3. Fix Messages.SenderID to allow NULL on delete
4. Standardize Sessions.IpAddress to VARBINARY(16)
5. Make QuestionBank.Category a proper FK to QuestionCategories

**Timeline:** These fixes should be prioritized before 2026-Q2 production release to prevent data integrity issues.

**Last Reviewed:** April 3, 2026
