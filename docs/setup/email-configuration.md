# Email Configuration

Guide for configuring email functionality in HealthBank.

## Overview

HealthBank uses SMTP to send emails for:
- Password reset notifications
- (Future) Account verification
- (Future) Survey notifications

By default, the system uses Gmail SMTP, but any SMTP server can be used.

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `SMTP_HOST` | `smtp.gmail.com` | SMTP server hostname |
| `SMTP_PORT` | `587` | SMTP server port (587 for TLS, 465 for SSL) |
| `SMTP_USER` | (none) | SMTP username/email for authentication |
| `SMTP_PASSWORD` | (none) | SMTP password or app password |
| `SMTP_FROM_NAME` | `HealthBank` | Display name for sent emails |
| `SMTP_TIMEOUT` | `30` | Connection timeout in seconds |

## Gmail Configuration

### Step 1: Enable 2-Step Verification

1. Go to [Google Account Security](https://myaccount.google.com/security)
2. Under "Signing in to Google", enable **2-Step Verification**
3. Follow the prompts to complete setup

### Step 2: Generate App Password

**Important**: Never use your actual Gmail password! App passwords are required for third-party apps.

1. Go to [App Passwords](https://myaccount.google.com/apppasswords)
   - Or: Google Account > Security > 2-Step Verification > App Passwords
2. Click **Select app** and choose "Mail"
3. Click **Select device** and choose "Other (Custom name)"
4. Enter "HealthBank" as the name
5. Click **Generate**
6. Copy the 16-character password (format: `xxxx xxxx xxxx xxxx`)

### Step 3: Configure Environment

Edit your environment file (`env/api.prod.env` or `env/api.dev.env`):

```bash
# Email / SMTP Configuration
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=xxxx xxxx xxxx xxxx
SMTP_FROM_NAME=HealthBank
SMTP_TIMEOUT=30
```

**Note**: Remove spaces from the app password or keep them - both work.

## Other SMTP Providers

### Microsoft 365 / Outlook

```bash
SMTP_HOST=smtp.office365.com
SMTP_PORT=587
SMTP_USER=your-email@your-domain.com
SMTP_PASSWORD=your-password
```

### Amazon SES

```bash
SMTP_HOST=email-smtp.us-east-1.amazonaws.com
SMTP_PORT=587
SMTP_USER=your-ses-smtp-username
SMTP_PASSWORD=your-ses-smtp-password
```

### Generic SMTP

```bash
SMTP_HOST=mail.your-provider.com
SMTP_PORT=587
SMTP_USER=your-username
SMTP_PASSWORD=your-password
```

## Development Mode

For local development without email:

1. Leave `SMTP_USER` and `SMTP_PASSWORD` empty
2. Email functionality will be disabled
3. Password resets will still work, but no email will be sent
4. Check server logs for what would have been sent

```bash
# Disable email in development
SMTP_USER=
SMTP_PASSWORD=
```

## Testing Email Configuration

### Using the API

Send a test password reset email:

```bash
# First, reset password to get a temporary password
curl -X POST "http://localhost:8000/api/v1/admin/users/1/reset-password" \
  -H "Content-Type: application/json" \
  -H "Cookie: session_token=YOUR_ADMIN_TOKEN" \
  -d '{"new_password": "TempPass123!"}'

# Then send the email
curl -X POST "http://localhost:8000/api/v1/admin/users/1/send-reset-email" \
  -H "Content-Type: application/json" \
  -H "Cookie: session_token=YOUR_ADMIN_TOKEN" \
  -d '{"temporary_password": "TempPass123!"}'
```

### Check Server Logs

If email is not configured, you'll see:

```
WARNING: Email service not configured - SMTP credentials missing
```

If email fails:

```
ERROR: Failed to send email: [error details]
```

## Security Best Practices

1. **Never commit credentials** - Keep `.env` files out of git
2. **Use app passwords** - Never use your main account password
3. **Rotate passwords** - Change app passwords periodically
4. **Limit scope** - Use a dedicated email account for the application
5. **Monitor usage** - Check sent mail for unusual activity

## Troubleshooting

### "Authentication failed"

- Verify app password is correct (no typos)
- Ensure 2-Step Verification is enabled
- Try regenerating the app password

### "Connection timed out"

- Check firewall allows outbound port 587
- Verify `SMTP_HOST` is correct
- Try increasing `SMTP_TIMEOUT`

### "Less secure app access"

- This error means you're using password authentication without 2FA
- Enable 2-Step Verification and use App Passwords instead

### Emails not received

- Check spam/junk folder
- Verify `SMTP_USER` is a valid email address
- Check server logs for errors
