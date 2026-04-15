<!-- Created with the Assistance of Claude Code -->
# Database Schema

## Overview

The HealthBank database uses MySQL and stores all data related to users, surveys, questions, and responses.

**Location:** `database/init/create_database.sql`

---

## Tables

### Auth
Stores password hashes for user authentication.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| AuthID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique identifier |
| PasswordHash | VARCHAR(255) | NOT NULL | Hashed password |

---

### Roles
User role definitions for role-based access control (RBAC).

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| RoleID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique identifier |
| RoleName | VARCHAR(50) | UNIQUE, NOT NULL | Role name (e.g., 'admin', 'researcher') |
| Description | TEXT | | Human-readable description of role |

**Default Roles:**

| RoleID | RoleName | Description |
|--------|----------|-------------|
| 1 | participant | Standard user who takes surveys |
| 2 | researcher | Creates and manages surveys |
| 3 | hcp | Healthcare professional with elevated access |
| 4 | admin | Full system access |

---

### AccountData
User account information.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| AccountID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique identifier |
| FirstName | VARCHAR(64) | | User's first name |
| LastName | VARCHAR(64) | | User's last name |
| Email | VARCHAR(255) | UNIQUE | User's email address |
| AuthID | INT | FOREIGN KEY -> Auth(AuthID) | Link to authentication |
| RoleID | INT | FOREIGN KEY -> Roles(RoleID), DEFAULT 1 | User's role for access control |
| IsActive | BOOLEAN | DEFAULT TRUE | Whether user account is active |
| CreatedAt | DATETIME | DEFAULT CURRENT_TIMESTAMP | When account was created |

---

### Sessions
User login sessions for JWT management.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| SessionID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique identifier |
| AccountID | INT | FOREIGN KEY -> AccountData(AccountID) | User who owns session |
| TokenHash | TEXT | | Hashed session token |
| CreatedAt | DATETIME | | When session was created |
| ExpiresAt | DATETIME | | When session expires |
| IpAddress | VARCHAR(50) | | Client IP address |
| UserAgent | VARCHAR(50) | | Client user agent |

---

### DataTypes
Categories for health data collected by questions.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| DataID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique identifier |
| Name | VARCHAR(255) | | Data type name |
| Description | TEXT | | Description of data type |

---

### Survey
Survey definitions created by researchers.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| SurveyID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique identifier |
| Title | VARCHAR(255) | NOT NULL | Survey title |
| Description | TEXT | | Detailed survey description |
| Status | ENUM | 'in-progress', 'complete', 'not-started', 'cancelled', DEFAULT 'not-started' | Participant completion status |
| PublicationStatus | ENUM | 'draft', 'published', 'closed', DEFAULT 'draft' | Survey visibility/availability |
| CreatorID | INT | FOREIGN KEY -> AccountData(AccountID) | User who created the survey |
| StartDate | DATETIME | | When survey opens for responses |
| EndDate | DATETIME | | When survey closes |
| CreatedAt | DATETIME | DEFAULT CURRENT_TIMESTAMP | Record creation time |
| UpdatedAt | DATETIME | DEFAULT CURRENT_TIMESTAMP ON UPDATE | Last modification time |

**Publication Status Values:**
- `draft` - Survey is being created/edited, not visible to participants
- `published` - Survey is live and accepting responses
- `closed` - Survey is no longer accepting responses

---

### QuestionBank
Reusable questions that can be added to surveys.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| QuestionID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique identifier |
| Title | VARCHAR(128) | | Short title for the question |
| QuestionContent | TEXT | NOT NULL | Full question text |
| ResponseType | ENUM | NOT NULL | Type of response expected (see below) |
| IsRequired | BOOLEAN | DEFAULT FALSE | Whether answer is required |
| Category | VARCHAR(64) | | Question category for organization |
| QuestionData | INT | FOREIGN KEY -> DataTypes(DataID) | Category of health data |
| CreatedAt | DATETIME | DEFAULT CURRENT_TIMESTAMP | Record creation time |
| UpdatedAt | DATETIME | DEFAULT CURRENT_TIMESTAMP ON UPDATE | Last modification time |

**Response Types:**
- `number` - Numeric input
- `yesno` - Yes/No toggle
- `openended` - Free text response
- `single_choice` - Select one option (uses QuestionOptions)
- `multi_choice` - Select multiple options (uses QuestionOptions)
- `scale` - Rating scale (1-10)

---

### QuestionOptions
Options for single_choice and multi_choice question types.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| OptionID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique identifier |
| QuestionID | INT | NOT NULL, FOREIGN KEY -> QuestionBank(QuestionID) | Parent question |
| OptionText | VARCHAR(255) | NOT NULL | The option text displayed to user |
| DisplayOrder | INT | DEFAULT 0 | Order in which options appear |

**Note:** Options are deleted when parent question is deleted (ON DELETE CASCADE)

---

### QuestionList
Links questions to surveys (many-to-many relationship).

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| ID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique identifier |
| SurveyID | INT | FOREIGN KEY -> Survey(SurveyID) | Survey containing question |
| QuestionID | INT | FOREIGN KEY -> QuestionBank(QuestionID) | Question in survey |

---

### Responses
Stores participant answers to survey questions.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| ResponseID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique identifier |
| SurveyID | INT | FOREIGN KEY -> Survey(SurveyID) | Survey being answered |
| ParticipantID | INT | FOREIGN KEY -> AccountData(AccountID) | User answering |
| QuestionID | INT | FOREIGN KEY -> QuestionBank(QuestionID) | Question being answered |
| ResponseValue | VARCHAR(255) | | The answer value |

---

### SurveyAssignment
Tracks which surveys are assigned to which participants.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| AssignmentID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique identifier |
| SurveyID | INT | NOT NULL, FOREIGN KEY -> Survey(SurveyID) | Survey being assigned |
| AccountID | INT | NOT NULL, FOREIGN KEY -> AccountData(AccountID) | User assigned to survey |
| AssignedAt | DATETIME | DEFAULT CURRENT_TIMESTAMP | When assignment was made |
| DueDate | DATETIME | | Optional deadline |
| CompletedAt | DATETIME | | When participant completed survey |
| Status | ENUM | 'pending', 'completed', 'expired', DEFAULT 'pending' | Assignment status |

**Unique Constraint:** `(SurveyID, AccountID)` - Prevents duplicate assignments

---

### SurveyTemplate
Reusable survey templates that can be used to quickly create new surveys.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| TemplateID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique identifier |
| Title | VARCHAR(255) | NOT NULL | Template name |
| Description | TEXT | | Template description |
| CreatorID | INT | FOREIGN KEY -> AccountData(AccountID) | User who created template |
| IsPublic | BOOLEAN | DEFAULT FALSE | Whether template is visible to all users |
| CreatedAt | DATETIME | DEFAULT CURRENT_TIMESTAMP | Record creation time |
| UpdatedAt | DATETIME | DEFAULT CURRENT_TIMESTAMP ON UPDATE | Last modification time |

---

### TemplateQuestions
Links questions to templates (many-to-many relationship).

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| ID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique identifier |
| TemplateID | INT | NOT NULL, FOREIGN KEY -> SurveyTemplate(TemplateID) | Parent template |
| QuestionID | INT | NOT NULL, FOREIGN KEY -> QuestionBank(QuestionID) | Question in template |
| DisplayOrder | INT | DEFAULT 0 | Order in which questions appear |

**Unique Constraint:** `(TemplateID, QuestionID)` - Prevents duplicate questions in template
**Note:** Questions are removed from template when template is deleted (ON DELETE CASCADE)

---

---

### SystemSettings

Runtime-configurable key/value settings store. Read by multiple modules via the 30-second cached helper in `services/settings.py`.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| SettingKey | VARCHAR(128) | PRIMARY KEY | Setting name (e.g. `k_anonymity_threshold`) |
| SettingValue | TEXT | NOT NULL | Value stored as string; cast in code |
| UpdatedBy | INT | FOREIGN KEY -> AccountData(AccountID) | Last admin to update |
| UpdatedAt | DATETIME | ON UPDATE CURRENT_TIMESTAMP | Last modification time |

Seeded defaults: `k_anonymity_threshold=5`, `registration_open=true`, `maintenance_mode=false`, `max_login_attempts=5`, `lockout_duration_minutes=30`, `consent_required=true`.

---

### TrackingCategory

Admin-configurable health tracking categories. Nothing is hardcoded — all categories are seeded via `database/migrations/009_add_health_tracking.sql` and can be managed at runtime.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| CategoryID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique identifier |
| CategoryKey | VARCHAR(64) | UNIQUE, NOT NULL | Stable programmatic key (e.g. `physical_health`) |
| DisplayName | VARCHAR(128) | NOT NULL | Label shown to users |
| Description | TEXT | | Category description |
| Icon | VARCHAR(64) | | Material icon name |
| DisplayOrder | INT | DEFAULT 0 | Sort order |
| IsActive | TINYINT(1) | DEFAULT 1 | Hidden from participants when 0 |
| IsDeleted | TINYINT(1) | DEFAULT 0 | Soft-delete flag |
| CreatedAt | DATETIME | DEFAULT CURRENT_TIMESTAMP | |
| UpdatedAt | DATETIME | ON UPDATE CURRENT_TIMESTAMP | |

---

### TrackingMetric

Individual measurable metrics within a category.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| MetricID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique identifier |
| CategoryID | INT | FOREIGN KEY -> TrackingCategory | Parent category |
| MetricKey | VARCHAR(64) | UNIQUE, NOT NULL | Stable programmatic key (e.g. `sleep_hours`) |
| DisplayName | VARCHAR(128) | NOT NULL | Label shown to participants |
| Description | TEXT | | Help text shown below metric input |
| MetricType | ENUM | `number`, `scale`, `yesno`, `single_choice`, `text` | Controls input widget and validation |
| Unit | VARCHAR(32) | | Unit suffix (e.g. `hours`, `glasses`) |
| ScaleMin | INT | DEFAULT 1 | Lower bound for scale type |
| ScaleMax | INT | DEFAULT 10 | Upper bound for scale type |
| ChoiceOptions | JSON | | Array of strings for single_choice type |
| Frequency | ENUM | `daily`, `weekly`, `monthly`, `any`, DEFAULT `daily` | Expected logging frequency |
| DisplayOrder | INT | DEFAULT 0 | Sort order within category |
| IsActive | TINYINT(1) | DEFAULT 1 | Hidden from participants when 0 |
| IsBaseline | TINYINT(1) | DEFAULT 0 | Whether metric is included in baseline snapshot |
| IsDeleted | TINYINT(1) | DEFAULT 0 | Soft-delete flag |
| CreatedAt | DATETIME | DEFAULT CURRENT_TIMESTAMP | |

---

### TrackingEntry

Participant health metric entries — one row per participant per metric per calendar day.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| EntryID | INT | PRIMARY KEY, AUTO_INCREMENT | Unique identifier |
| ParticipantID | INT | FOREIGN KEY -> AccountData(AccountID) | Participant who logged the value |
| MetricID | INT | FOREIGN KEY -> TrackingMetric | Which metric was logged |
| Value | TEXT | NOT NULL | Stored as string; type-validated on write |
| Notes | TEXT | | Optional free-text note |
| EntryDate | DATE | NOT NULL | Date of the logged entry (not insert time) |
| IsBaseline | TINYINT(1) | DEFAULT 0 | True for onboarding baseline snapshot entries |
| CreatedAt | DATETIME | DEFAULT CURRENT_TIMESTAMP | Row insert time |

**Unique constraint:** `(ParticipantID, MetricID, EntryDate)` — enables the upsert pattern; one entry per participant per metric per day.

---

### TrackingCategoryTranslation

Optional display name and description translations for categories.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| CategoryID | INT | PK, FOREIGN KEY -> TrackingCategory | Parent category |
| LanguageCode | VARCHAR(8) | PK | ISO language code (e.g. `fr`, `es`) |
| DisplayName | VARCHAR(128) | | Translated name (NULL = fall back to English) |
| Description | TEXT | | Translated description |

---

### TrackingMetricTranslation

Optional display name and description translations for metrics.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| MetricID | INT | PK, FOREIGN KEY -> TrackingMetric | Parent metric |
| LanguageCode | VARCHAR(8) | PK | ISO language code (e.g. `fr`, `es`) |
| DisplayName | VARCHAR(128) | | Translated name |
| Description | TEXT | | Translated description |

---

## Entity Relationship Diagram

```
Auth 1──1 AccountData 1──* Sessions
              │
         Roles 1──*
              │
              │ 1
              ├────────* Responses
              │              │
              │              │ *
              │              │
              ├────────* SurveyAssignment
              │              │
              │              │ *
              │              │
              ├────────* TrackingEntry *──1 TrackingMetric *──1 TrackingCategory
              │
              └───────SystemSettings (SettingKey PK — key/value store)

DataTypes 1──* QuestionBank ─┼──* QuestionList *──1 Survey
                             │                       │
                             └───────────────────────┘

TrackingCategory 1──* TrackingCategoryTranslation (per language)
TrackingMetric   1──* TrackingMetricTranslation   (per language)
```

---

## Common Queries

### Get user with role name
```sql
SELECT a.*, r.RoleName
FROM AccountData a
LEFT JOIN Roles r ON a.RoleID = r.RoleID
WHERE a.AccountID = %s;
```

### Get all users with a specific role
```sql
SELECT a.*
FROM AccountData a
JOIN Roles r ON a.RoleID = r.RoleID
WHERE r.RoleName = %s;
```

### Get all surveys assigned to a user
```sql
SELECT s.*, sa.Status as AssignmentStatus, sa.DueDate
FROM Survey s
JOIN SurveyAssignment sa ON s.SurveyID = sa.SurveyID
WHERE sa.AccountID = %s;
```

### Get pending assignments for a user
```sql
SELECT s.Title, sa.AssignedAt, sa.DueDate
FROM SurveyAssignment sa
JOIN Survey s ON sa.SurveyID = s.SurveyID
WHERE sa.AccountID = %s AND sa.Status = 'pending';
```

### Mark assignment as completed
```sql
UPDATE SurveyAssignment
SET Status = 'completed', CompletedAt = NOW()
WHERE SurveyID = %s AND AccountID = %s;
```

---

## Security Notes

**CRITICAL: Always use parameterized queries!**

```python
# CORRECT - Safe from SQL injection
cursor.execute(
    "SELECT * FROM SurveyAssignment WHERE AccountID = %s",
    (account_id,)
)

# WRONG - Vulnerable to SQL injection
cursor.execute(f"SELECT * FROM SurveyAssignment WHERE AccountID = {account_id}")
```

Values MUST go in the parameters tuple, NEVER in the SQL string.
