# [Feature Name] Database Schema

> Last updated: [DATE] | Task: [TASK_ID]

## Overview

Brief description of the database tables/changes and their purpose.

## Tables

### `TableName`

Description of what this table stores.

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| id | INT | NO | AUTO_INCREMENT | Primary key |
| foreign_id | INT | NO | - | FK to OtherTable |
| name | VARCHAR(255) | NO | - | Display name |
| status | ENUM('a','b','c') | NO | 'a' | Current status |
| created_at | DATETIME | NO | CURRENT_TIMESTAMP | Creation time |
| updated_at | DATETIME | YES | ON UPDATE CURRENT_TIMESTAMP | Last update |

**Indexes:**
- `PRIMARY KEY (id)`
- `INDEX idx_foreign_id (foreign_id)`
- `UNIQUE KEY unique_name (name)`

**Foreign Keys:**
- `fk_table_foreign` → `OtherTable(id)` ON DELETE CASCADE

**Example Row:**
```json
{
  "id": 1,
  "foreign_id": 5,
  "name": "Example",
  "status": "active",
  "created_at": "2026-01-22 10:00:00"
}
```

## Relationships

```
┌─────────────┐       ┌─────────────┐
│   Survey    │──1:N──│  Question   │
└─────────────┘       └─────────────┘
       │
       │ 1:N
       ▼
┌─────────────┐
│ Assignment  │
└─────────────┘
```

## Migrations

### Migration: [migration_name].sql

**Purpose:** What this migration does

**Up (Apply):**
```sql
ALTER TABLE TableName
ADD COLUMN new_column VARCHAR(100) AFTER existing_column;

CREATE INDEX idx_new_column ON TableName(new_column);
```

**Down (Rollback):**
```sql
ALTER TABLE TableName
DROP COLUMN new_column;
```

**Run Migration:**
```bash
# Development
docker compose exec mysql mysql -u root -p healthbank < database/migrations/001_migration.sql

# Or via script
python scripts/run_migrations.py
```

## Enums and Status Values

### Status Enum
| Value | Description | Transitions To |
|-------|-------------|----------------|
| draft | Initial state | published |
| published | Visible to users | closed |
| closed | No longer active | - |

## Data Integrity Rules

1. **Rule Name:** Description of constraint
   - Enforced by: Database/Application
   - Example: User cannot delete own account

2. **Cascade Behavior:**
   - Deleting Survey → Deletes all Questions
   - Deleting User → Preserves Surveys (sets creator to NULL)

## Common Queries

### Get [Resource] with Related Data
```sql
SELECT s.*, COUNT(q.id) as question_count
FROM Survey s
LEFT JOIN Question q ON s.id = q.survey_id
WHERE s.status = 'published'
GROUP BY s.id;
```

### Performance Notes

- Index `idx_status` used for filtering published surveys
- Query typically returns in <10ms for <10k records

## Seed Data

Location: `database/init/seed_data.sql` or `scripts/seed_data.py`

```bash
# Run seed data
python scripts/seed_data.py

# Reset and reseed
python scripts/seed_data.py --reset
```

## Backup & Recovery

```bash
# Backup
mysqldump -u root -p healthbank > backup_$(date +%Y%m%d).sql

# Restore
mysql -u root -p healthbank < backup_20260122.sql
```

## Related Documentation

- [API Documentation](../api/[feature].md)
- [Migration Guide](./migrations.md)
