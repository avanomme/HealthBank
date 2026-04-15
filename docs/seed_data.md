# HealthBank Seed Data Reference

## Database Schema Quick Reference

### Tables & Relationships

```
Auth (AuthID PK, PasswordHash, ResetToken, ResetTokenExpires)
  ^
AccountData (AccountID PK, FirstName, LastName, Email, AuthID FK, RoleID FK, IsActive, CreatedAt, LastLogin, TosAcceptedAt, TosVersion)
  ^                                                        |
  |                                                  Roles (RoleID PK, RoleName, Description)
  |                                                    1=participant, 2=researcher, 3=hcp, 4=admin
  |
  +--- Survey (SurveyID PK, Title, Description, Status, PublicationStatus, CreatorID FK, StartDate, EndDate)
  |      Status ENUM: 'in-progress','complete','not-started','cancelled'
  |      PublicationStatus ENUM: 'draft','published','closed'
  |
  +--- SurveyAssignment (AssignmentID PK, SurveyID FK, AccountID FK, AssignedAt, DueDate, CompletedAt, Status)
  |      Status ENUM: 'pending','completed','expired'
  |      UNIQUE(SurveyID, AccountID)
  |
  +--- Responses (ResponseID PK, SurveyID FK, ParticipantID FK, QuestionID FK, ResponseValue VARCHAR(255))
  |      One row per question per participant per survey
  |
  +--- QuestionBank (QuestionID PK, Title, QuestionContent, ResponseType, IsRequired, Category, QuestionData FK)
  |      ResponseType ENUM: 'number','yesno','openended','single_choice','multi_choice','scale'
  |      Category: 'demographics','mental_health','physical_health','lifestyle','symptoms'
  |
  +--- QuestionOptions (OptionID PK, QuestionID FK, OptionText, DisplayOrder)
  |      Stores choices for single_choice and multi_choice questions
  |
  +--- QuestionList (ID PK, SurveyID FK, QuestionID FK)
         Junction table: which questions belong to which surveys
```

### ResponseValue Format by Type

| ResponseType   | Format                          | Example                        |
|----------------|---------------------------------|--------------------------------|
| number         | Numeric string                  | `"3"`, `"5.5"`                 |
| scale          | Integer 1-10                    | `"4"`, `"7"`                   |
| yesno          | `"true"` or `"false"`           | `"true"`                       |
| single_choice  | Exact OptionText match          | `"Male"`, `"Employed full-time"` |
| multi_choice   | Comma-separated OptionText      | `"Headache,Fatigue"`           |
| openended      | Free text                       | `"Mild fatigue and headaches"` |

### Aggregation Notes
- K-Anonymity threshold: K=5 (data suppressed if < 5 respondents)
- multi_choice: Split on commas, strip whitespace
- openended: Not aggregated (privacy protection)

---

## Existing Seed Data (survey_seed_data.sql)

### Users (33 accounts, all password: "password")

| AccountID | Name              | Role        | Email              |
|-----------|-------------------|-------------|-------------------|
| 1         | Admin User        | admin       | admin@hb.com       |
| 2         | Participant User  | participant | part@hb.com        |
| 3         | HCP User          | hcp         | hcp@hb.com         |
| 4         | Researcher User   | researcher  | research@hb.com    |
| 5-9       | 5 Researchers     | researcher  | sarah@hb.com, etc. |
| 10-12     | 3 HCPs            | hcp         | rwilliams@hb.com   |
| 13-33     | 21 Participants   | participant | jsmith@hb.com, etc.|

### Surveys (8 total)

| SurveyID | Title                        | Status       | PubStatus | Questions              |
|----------|------------------------------|-------------|-----------|------------------------|
| 1        | Q1 2026 Health Assessment    | in-progress | published | Q1,2,3,11,12,13,15,16,17,18 |
| 2        | Mental Health Weekly Check-in| in-progress | published | Q6,7,8,9,10            |
| 3        | Lifestyle Habits Study       | in-progress | published | Q11,16,17,18,19,20,7   |
| 4        | Sleep Quality Research       | not-started | draft     | Q7,6,20,19             |
| 5        | Chronic Pain Assessment      | not-started | draft     | Q13,14,21,22,23,24,25  |
| 6        | Q4 2025 Health Assessment    | complete    | closed    | Q1,2,11,12,16,17       |
| 7        | COVID-19 Symptom Tracker     | complete    | closed    | Q21,22,23,24,25        |
| 8        | Discontinued Study           | cancelled   | closed    | (none assigned)        |

### Questions (25 total)

| QID | Title                    | Type          | Category        | Options                                                |
|-----|--------------------------|---------------|-----------------|--------------------------------------------------------|
| 1   | Age Range                | single_choice | demographics    | 18-24, 25-34, 35-44, 45-54, 55-64, 65+                |
| 2   | Gender Identity          | single_choice | demographics    | Male, Female, Non-binary, Prefer not to say            |
| 3   | Occupation Status        | single_choice | demographics    | Employed full-time, Employed part-time, Self-employed, Unemployed, Retired, Student |
| 4   | Living Situation         | single_choice | demographics    | Own home, Rent apartment, Live with family, Shared housing, Other |
| 5   | Years at Current Address | number        | demographics    | (numeric)                                              |
| 6   | Stress Level             | scale         | mental_health   | 1-10                                                   |
| 7   | Sleep Quality            | scale         | mental_health   | 1-10                                                   |
| 8   | Anxiety Frequency        | single_choice | mental_health   | Not at all, Several days, More than half the days, Nearly every day |
| 9   | Mood Description         | single_choice | mental_health   | Very good, Good, Neutral, Low, Very low                |
| 10  | Support System           | yesno         | mental_health   | true/false                                             |
| 11  | Exercise Frequency       | number        | physical_health | (numeric, days per week)                               |
| 12  | Chronic Conditions       | multi_choice  | physical_health | Diabetes, Hypertension, Heart disease, Asthma, Arthritis, None |
| 13  | Pain Level               | scale         | physical_health | 1-10                                                   |
| 14  | Physical Limitations     | yesno         | physical_health | true/false                                             |
| 15  | Last Checkup             | single_choice | physical_health | Within the last 6 months, 6-12 months ago, 1-2 years ago, More than 2 years ago, Never |
| 16  | Smoking Status           | single_choice | lifestyle       | Yes daily, Yes occasionally, No I quit, No never       |
| 17  | Alcohol Consumption      | single_choice | lifestyle       | Never, Rarely (a few times a year), Monthly, Weekly, Daily |
| 18  | Diet Quality             | scale         | lifestyle       | 1-10                                                   |
| 19  | Water Intake             | number        | lifestyle       | (numeric, glasses per day)                             |
| 20  | Screen Time              | number        | lifestyle       | (numeric, hours per day)                               |
| 21  | Current Symptoms         | multi_choice  | symptoms        | Headache, Fatigue, Nausea, Dizziness, Cough, Shortness of breath, None |
| 22  | Symptom Duration         | single_choice | symptoms        | Less than 24 hours, 1-3 days, 4-7 days, 1-2 weeks, More than 2 weeks |
| 23  | Symptom Severity         | scale         | symptoms        | 1-10                                                   |
| 24  | Symptom Description      | openended     | symptoms        | (free text)                                            |
| 25  | Medication Use           | yesno         | symptoms        | true/false                                             |

### Existing Response Count: 176 (from survey_seed_data.sql)

---

## How to Seed Additional Data

### Via Docker (recommended)
```bash
# Run a SQL file against the running MySQL container
docker compose exec mysql mysql -u root -ppassword healthdatabase < database/init/extra_seed.sql

# Or run inline SQL
docker compose exec mysql mysql -u root -ppassword healthdatabase -e "SELECT COUNT(*) FROM Responses;"
```

### Via Makefile
```bash
make db-seed    # Full reseed (drops and recreates all data)
make db-reset   # Schema only reset (no seed data)
```

### INSERT Patterns

**New Assignment + Responses (complete a pending assignment):**
```sql
-- Mark assignment as completed
UPDATE SurveyAssignment
SET CompletedAt = '2026-02-01 10:00:00', Status = 'completed'
WHERE SurveyID = 1 AND AccountID = 12;

-- Insert responses for all questions in that survey
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(1, 12, 1, '25-34'),           -- single_choice
(1, 12, 2, 'Female'),          -- single_choice
(1, 12, 3, 'Student'),         -- single_choice
(1, 12, 11, '4'),              -- number
(1, 12, 12, 'Asthma'),         -- multi_choice (single selection)
(1, 12, 13, '3'),              -- scale
(1, 12, 15, '6-12 months ago'),-- single_choice
(1, 12, 16, 'No, never'),      -- single_choice
(1, 12, 17, 'Rarely (a few times a year)'), -- single_choice
(1, 12, 18, '6');              -- scale
```

**Bulk new assignments + responses:**
```sql
-- Assign participant to survey
INSERT INTO SurveyAssignment (SurveyID, AccountID, AssignedAt, DueDate, CompletedAt, Status)
VALUES (1, 30, NOW(), '2026-03-31 23:59:59', NOW(), 'completed');

-- Then insert one Responses row per question in the survey
INSERT INTO Responses (SurveyID, ParticipantID, QuestionID, ResponseValue) VALUES
(1, 30, 1, '45-54'),
...
```

### Important Constraints
- `SurveyAssignment` has UNIQUE(SurveyID, AccountID) - one assignment per user per survey
- `Responses.ParticipantID` must reference an existing AccountID
- `Responses.QuestionID` must be linked to the survey via `QuestionList`
- multi_choice values must be comma-separated with NO spaces: `"Headache,Fatigue"` not `"Headache, Fatigue"`
- yesno values must be lowercase: `"true"` or `"false"`
- scale values: integer strings 1-10
