# Email Templates

Transactional email templates for HealthBank notifications.

**File:** `backend/app/services/email/templates.py`

---

## Overview

This module defines all transactional email templates used by the HealthBank application.

Each template function returns a tuple:

```
(subject, body_text, body_html)
```

All templates:

- Provide both plain text and HTML versions
- Use a shared HTML wrapper for consistent styling
- Are designed for transactional and security-related notifications
- Follow a consistent branding and formatting structure

---

## Base HTML Layout

All HTML emails are wrapped using a shared internal layout.

### Layout Characteristics

- Responsive design
- Maximum width of 600px
- Branded header with HealthBank styling
- Structured content container
- Standardized footer
- Styled buttons and warning boxes
- Accessible typography

### Shared Visual Elements

| Component | Purpose |
|------------|----------|
| Header | Displays "HealthBank" branding |
| Content container | Main email body |
| Button styling | Primary action links |
| Code block styling | Temporary password display |
| Warning box | Security or caution notices |
| Footer | Automated message notice and copyright |

This ensures visual consistency across all emails.

---

## Templates

### 1. Account Creation Email

**Function:** `account_created(...)`

Sent when an administrator creates a new user account.

#### Parameters

- `user_name` (`str`) — Name of the new user  
- `user_email` (`str`) — User's email address  
- `temporary_password` (`str`) — Temporary password for first login  
- `login_url` (`str`) — URL to login page  

#### Features

- Displays temporary password prominently
- Includes login button
- Instructs user to:
  - Change password on first login
  - Set up Two-Factor Authentication
- Contains security warning

#### Subject Line

```
Welcome to HealthBank - Your Account Has Been Created
```

---

### 2. Password Reset Request Email

**Function:** `password_reset_request(...)`

Sent after a user verifies identity via 2FA and requests a password reset.

#### Parameters

- `user_name` (`str`) — Name of the user  
- `reset_url` (`str`) — Secure reset link containing token  
- `expiry_minutes` (`int`) — Token expiration time (default: 60)  

#### Features

- Secure reset button
- Expiry time clearly stated
- Warning if reset was not requested
- Emphasizes 2FA verification step

#### Subject Line

```
HealthBank - Password Reset Request
```

---

### 3. Password Changed Confirmation Email

**Function:** `password_changed(...)`

Sent after a user successfully changes their password.

#### Parameters

- `user_name` (`str`) — Name of the user  
- `user_email` (`str`) — Account email address  

#### Features

- Confirms successful password change
- Displays account email
- Security warning if change was unauthorized

#### Subject Line

```
HealthBank - Your Password Has Been Changed
```

---

### 4. Two-Factor Authentication Setup Email

**Function:** `two_factor_setup(...)`

Sent when a user needs to complete 2FA setup.

#### Parameters

- `user_name` (`str`) — Name of the user  
- `setup_url` (`str`) — URL for completing 2FA setup  

#### Features

- Direct setup button
- Lists required items:
  - Authenticator app
  - Mobile phone
- Explains security benefits of 2FA

#### Subject Line

```
HealthBank - Complete Your Two-Factor Authentication Setup
```

---

## Template Structure Pattern

All templates follow this internal pattern:

1. Define `subject`
2. Create plain text version (`body_text`)
3. Generate HTML content using shared layout wrapper
4. Return `(subject, body_text, body_html)`

This ensures:

- Email clients without HTML support are handled properly
- Consistent formatting across providers
- Easy template expansion in the future

---

## Security Considerations

These templates are used for security-sensitive operations:

- Account creation
- Password reset
- Password change
- Two-factor authentication setup

Important implementation notes:

- Password reset emails should only be sent after 2FA verification
- Reset tokens must be securely generated and time-limited
- Temporary passwords should be randomly generated
- URLs must use HTTPS in production

---

## Extending Templates

To add a new email template:

1. Create a new function returning `(subject, body_text, body_html)`
2. Use the shared base HTML wrapper
3. Maintain consistent branding and structure
4. Add corresponding method in `EmailService`

---

## Related Files

- `backend/app/services/email/service.py` — High-level email service
- `backend/app/services/email/base.py` — Email provider interface
- `backend/app/services/email/gmail.py` — Gmail SMTP provider
- `backend/app/services/email/config.py` — Email configuration