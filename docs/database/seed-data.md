<!-- Created with the Assistance of Claude Code -->
# Seed Data

## Overview

The seed data file populates the database with sample questions, templates, and surveys for development and testing purposes.

**Location:** `database/init/survey_seed_data.sql`

**Run after:** `create_database.sql`

---

## Contents

### Question Bank (25 Questions)

The seed data includes 25 sample questions across 5 categories:

| Category | Questions | IDs |
|----------|-----------|-----|
| Demographics | 5 | 1-5 |
| Mental Health | 5 | 6-10 |
| Physical Health | 5 | 11-15 |
| Lifestyle | 5 | 16-20 |
| Symptoms | 5 | 21-25 |

### Question Types Used

| Type | Count | Description |
|------|-------|-------------|
| `single_choice` | 10 | Select one option from a list |
| `scale` | 5 | Rating scale (1-10) |
| `number` | 4 | Numeric input |
| `multi_choice` | 2 | Select multiple options |
| `yesno` | 3 | Yes/No toggle |
| `openended` | 1 | Free text response |

### Question Options

All `single_choice` and `multi_choice` questions have predefined options populated in the `QuestionOptions` table with appropriate `DisplayOrder` values.

---

## Survey Templates (3 Templates)

### Template 1: General Health Assessment
- **ID:** 1
- **Questions:** 10
- **Description:** Comprehensive health assessment covering demographics, physical health, and lifestyle factors
- **Use case:** Initial patient intake, annual health reviews

**Includes:** Age Range, Gender Identity, Occupation Status, Exercise Frequency, Chronic Conditions, Pain Level, Last Checkup, Smoking Status, Alcohol Consumption, Diet Quality

### Template 2: Mental Health Check-in
- **ID:** 2
- **Questions:** 6
- **Description:** Quick mental health screening tool
- **Use case:** Regular check-ins with patients or research participants

**Includes:** Stress Level, Sleep Quality, Anxiety Frequency, Mood Description, Support System, open-ended Symptom Description

### Template 3: Lifestyle & Wellness Survey
- **ID:** 3
- **Questions:** 8
- **Description:** Survey focused on lifestyle habits
- **Use case:** Wellness programs, lifestyle intervention studies

**Includes:** Exercise Frequency, Smoking Status, Alcohol Consumption, Diet Quality, Water Intake, Screen Time, Sleep Quality, Stress Level

---

## Sample Survey

The seed data includes one pre-created survey for testing:

- **ID:** 2 (ID 1 may already be used by manual testing)
- **Title:** Q1 2026 Health Assessment
- **Status:** published, in-progress
- **Questions:** 6 (Age Range, Gender Identity, Stress Level, Sleep Quality, Exercise Frequency, Smoking Status)

---

## Running the Seed Data

### Development (Docker)

```bash
# Connect to MySQL container and run seed data
docker compose exec mysql mysql -u root -p healthdatabase < database/init/survey_seed_data.sql
```

### Manual Execution

```bash
mysql -u [username] -p healthdatabase < database/init/survey_seed_data.sql
```

### Verify Data

```sql
-- Check question count
SELECT COUNT(*) FROM QuestionBank;  -- Should return 25+

-- Check templates
SELECT * FROM SurveyTemplate;  -- Should return 3 rows

-- Check template questions
SELECT t.Title, COUNT(tq.QuestionID) as QuestionCount
FROM SurveyTemplate t
JOIN TemplateQuestions tq ON t.TemplateID = tq.TemplateID
GROUP BY t.TemplateID;
```

---

## Resetting Seed Data

To reset and reload seed data:

```sql
-- Delete existing seed data (preserves user-created content with higher IDs)
DELETE FROM TemplateQuestions WHERE TemplateID <= 3;
DELETE FROM SurveyTemplate WHERE TemplateID <= 3;
DELETE FROM QuestionList WHERE SurveyID = 2;
DELETE FROM Survey WHERE SurveyID = 2;
DELETE FROM QuestionOptions WHERE QuestionID <= 25;
DELETE FROM QuestionBank WHERE QuestionID <= 25;

-- Re-run seed file
SOURCE database/init/survey_seed_data.sql;
```

---

## Extending Seed Data

When adding new seed data:

1. Use explicit IDs to avoid conflicts
2. Keep IDs in a reserved range (e.g., 1-100 for seed data)
3. Update this documentation
4. Test both fresh installs and updates

```sql
-- Example: Adding a new category
INSERT INTO QuestionBank (QuestionID, Title, QuestionContent, ResponseType, Category) VALUES
(26, 'New Question', 'Question content here', 'single_choice', 'New Category');
```
