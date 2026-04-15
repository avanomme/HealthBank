# Admin Password Reset with Email Service

## Overview

The admin password reset feature allows system administrators to reset user passwords and optionally send an email notification with the temporary password.

## Architecture

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Frontend      │     │   Backend API   │     │  Gmail SMTP     │
│   (Flutter)     │────▶│   (FastAPI)     │────▶│  (Email Send)   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

## Components

### Frontend
- **File:** `frontend/lib/src/features/admin/widgets/reset_password_modal.dart`
- Modal dialog with password field, generate button, and email options

### Backend API
- **File:** `backend/app/api/v1/admin.py`
- `POST /api/v1/admin/users/{user_id}/reset-password` - Resets password
- `POST /api/v1/admin/users/{user_id}/send-reset-email` - Sends email notification

### Email Service
- **Files:** `backend/app/services/email/`
  - `service.py` - High-level email service
  - `config.py` - Environment configuration
  - `templates.py` - Email templates
  - `gmail.py` - Gmail SMTP provider

## Setup

### 1. Gmail App Password

1. Go to [Google Account Security](https://myaccount.google.com/security)
2. Enable 2-Step Verification (required)
3. Go to "App passwords" under 2-Step Verification
4. Generate a new app password for "Mail"
5. Copy the 16-character password

### 2. Environment Variables

Add to `env/api.prod.env`:

```env
# Email Service Configuration
GMAIL_USER=your-email@gmail.com
GMAIL_APP_PASSWORD=xxxx xxxx xxxx xxxx

# Application URLs (for email links)
APP_BASE_URL=http://localhost:3000
```

### 3. Verify Setup

```bash
# Check email service is configured
docker compose exec api python -c "from app.services.email import email_service; print('Email service ready')"
```

## Usage Flow

### Admin Resets Password

1. Admin opens User Management page
2. Clicks "Reset Password" icon on a user row
3. Modal opens with options:
   - Enter password manually OR click generate
   - Optionally check "Send email notification"
   - Optionally use alternate email address
4. Click "Reset Password"

### API Calls Made

```
1. POST /api/v1/admin/users/{id}/reset-password
   Body: { "new_password": "TempPass123" }

2. POST /api/v1/admin/users/{id}/send-reset-email (if email checkbox checked)
   Body: { "temporary_password": "TempPass123", "email_override": null }
```

## Email Templates

### Account Created Email
Sent when admin creates a new user account with temporary password.

### Password Reset Email
Sent when admin resets an existing user's password.

**Template includes:**
- User's name
- Temporary password
- Login URL
- Expiry notice (60 minutes default)

## Configuration Options

| Variable | Default | Description |
|----------|---------|-------------|
| `GMAIL_USER` | (required) | Gmail address for sending |
| `GMAIL_APP_PASSWORD` | (required) | 16-char app password |
| `APP_BASE_URL` | `http://localhost:3000` | Base URL for email links |
| `PASSWORD_RESET_EXPIRY_MINUTES` | `60` | Token expiry time |

## Security Notes

1. **App Passwords**: Never use your actual Gmail password; always use app passwords
2. **Temporary Passwords**: Generated passwords use secure random (no ambiguous chars like 0/O, 1/l)
3. **Admin Only**: Only authenticated admins can reset passwords
4. **Audit Trail**: Password resets should be logged (see audit log)

## Troubleshooting

### Email Not Sending

```bash
# Check environment variables are set
docker compose exec api env | grep GMAIL

# Test email service directly
docker compose exec api python -c "
from app.services.email import email_service
email_service.send_password_reset_email('Test', 'your@email.com', 'test123')
"
```

### Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| "Missing required email environment variables" | Env vars not set | Add GMAIL_USER and GMAIL_APP_PASSWORD |
| "Authentication failed" | Wrong app password | Regenerate app password in Google |
| "Less secure apps" error | Using regular password | Use app password instead |

## Related Files

```
backend/
├── app/
│   ├── api/v1/admin.py              # API endpoints
│   └── services/email/
│       ├── __init__.py
│       ├── base.py                   # Abstract provider
│       ├── config.py                 # Environment config
│       ├── gmail.py                  # Gmail SMTP implementation
│       ├── service.py                # High-level service
│       └── templates.py              # Email templates

frontend/
└── lib/src/features/admin/
    └── widgets/
        └── reset_password_modal.dart # UI modal
```
