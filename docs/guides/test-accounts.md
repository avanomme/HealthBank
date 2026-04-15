<!-- Created with the Assistance of Claude Code -->
# Test Accounts

Development and testing accounts pre-seeded in the database.

## Login Credentials

| Email | Password | Role | Description |
|-------|----------|------|-------------|
| admin@upei.ca | admin | Admin | Full system access |
| researcher@upei.ca | researcher | Researcher | Creates and manages surveys |
| participant@upei.ca | participant | Participant | Takes surveys |
| hcp@upei.ca | hcp | HCP | Healthcare professional |

## Usage

These accounts are created automatically when the database is initialized from `database/init/survey_seed_data.sql`.

### Reset Database to Get Fresh Accounts

```bash
make clean-all
make up
```

**Warning:** `make clean-all` deletes all database data including any data you've added during testing.

## Notes

- Passwords match the username (e.g., admin/admin)
- All accounts are set to `IsActive = TRUE`
- These are for **development only** - do not use in production
