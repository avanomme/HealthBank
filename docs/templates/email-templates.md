# Email Templates

HTML and plain text email templates for HealthBank.

## Password Reset Email

Used when an administrator resets a user's password.

### Template Functions

```python
from app.services import password_reset_email, password_reset_plain

# Get HTML version
html = password_reset_email(
    user_name="John",
    temporary_password="TempPass123"
)

# Get plain text version
plain = password_reset_plain(
    user_name="John",
    temporary_password="TempPass123"
)
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `user_name` | str | User's first name for greeting |
| `temporary_password` | str | The new temporary password |

### Template Sections

1. **Header** - HealthBank branding with dark blue background
2. **Greeting** - Personalized "Hello {name},"
3. **Explanation** - Clear statement that password was reset by administrator
4. **Password Box** - Prominently displayed temporary password in styled box
5. **Next Steps** - Numbered list of what to do:
   - Log in with temporary password
   - Go to account settings
   - Change to a new secure password
6. **Security Notice** - Yellow warning to contact support if not requested
7. **Footer** - Automated message disclaimer

### Styling

- Uses inline CSS for email client compatibility
- Responsive design (max-width: 600px)
- Color scheme matches HealthBank branding:
  - Primary: `#1a365d` (dark blue)
  - Background: `#f5f5f5`
  - Warning: `#f59e0b` (amber)

### Example Output

**Subject:** Password Reset - HealthBank

**Preview:**
```
Hello John,

Your password has been reset by a system administrator...

Your Temporary Password: TempPass123

Next Steps:
1. Log in to your account...
```

## Files

- `backend/app/services/email_templates.py` - Template functions
