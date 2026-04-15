<!-- Created with the assistance of Claude Code -->

# Email Service Integration Guide

This guide explains how to integrate the HealthBank email service into your API endpoints and pages.

## Overview

The email service is located at `backend/app/services/email/` and provides:

- **Account Creation Emails** - Sends temporary password to new users
- **Password Reset Emails** - Sends secure reset link (after 2FA verification)
- **Password Changed Confirmation** - Notifies user of password change
- **2FA Setup Emails** - Reminds users to complete 2FA setup

## Quick Start

```python
from app.services.email import email_service

# Send an email
email_service.send_account_created_email(
    user_name="John Doe",
    user_email="john@example.com",
    temporary_password="TempPass123!"
)
```

---

## Integration Examples

### 1. Account Creation (Admin Endpoint)

When an admin creates a new user account, send the welcome email with temporary credentials.

```python
# backend/app/api/v1/endpoints/admin.py

from fastapi import APIRouter, Depends, HTTPException
from app.services.email import email_service
from app.core.security import generate_temporary_password
from app.models.user import User
from app.db.session import get_db

router = APIRouter()

@router.post("/accounts")
async def create_account(
    request: CreateAccountRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_admin_user)
):
    # Generate temporary password
    temp_password = generate_temporary_password()

    # Create user in database
    new_user = User(
        name=request.name,
        email=request.email,
        role=request.role,
        password_hash=hash_password(temp_password),
        must_change_password=True
    )
    db.add(new_user)
    db.commit()

    # Send welcome email with temporary password
    email_sent = email_service.send_account_created_email(
        user_name=new_user.name,
        user_email=new_user.email,
        temporary_password=temp_password
    )

    if not email_sent:
        # Log warning but don't fail - user exists, admin can share password manually
        logger.warning(f"Failed to send welcome email to {new_user.email}")

    return {
        "id": new_user.id,
        "email": new_user.email,
        "temporary_password": temp_password,  # Show to admin as backup
        "email_sent": email_sent
    }
```

### 2. Password Reset Flow (Requires 2FA)

The password reset flow has two steps:

1. **Request Reset** - User provides email, verifies 2FA, then receives reset link
2. **Complete Reset** - User clicks link and sets new password

#### Step 1: Request Password Reset

```python
# backend/app/api/v1/endpoints/auth.py

from fastapi import APIRouter, Depends, HTTPException
from app.services.email import email_service
from app.models.user import User
import secrets

router = APIRouter()

@router.post("/forgot-password/request")
async def request_password_reset(
    request: ForgotPasswordRequest,
    db: Session = Depends(get_db)
):
    """
    Step 1: User requests password reset.
    Returns 200 regardless of whether email exists (prevents enumeration).
    """
    user = db.query(User).filter(User.email == request.email).first()

    if user:
        # Return that 2FA is required
        return {
            "requires_2fa": True,
            "message": "Please verify your identity with 2FA"
        }

    # Don't reveal if user exists
    return {
        "requires_2fa": True,
        "message": "Please verify your identity with 2FA"
    }


@router.post("/forgot-password/verify-2fa")
async def verify_2fa_for_reset(
    request: Verify2FARequest,
    db: Session = Depends(get_db)
):
    """
    Step 2: User verifies 2FA, then we send the reset email.
    """
    user = db.query(User).filter(User.email == request.email).first()

    if not user:
        # Don't reveal if user exists
        return {"message": "If your email is registered, you will receive a reset link."}

    # Verify TOTP code
    if not verify_totp(user.totp_secret, request.totp_code):
        raise HTTPException(status_code=400, detail="Invalid 2FA code")

    # Generate secure reset token
    reset_token = secrets.token_urlsafe(32)
    user.reset_token = reset_token
    user.reset_token_expires = datetime.utcnow() + timedelta(hours=1)
    db.commit()

    # Send password reset email
    email_sent = email_service.send_password_reset_email(
        user_name=user.name,
        user_email=user.email,
        reset_token=reset_token
    )

    return {
        "message": "If your email is registered, you will receive a reset link.",
        "email_sent": email_sent
    }
```

#### Step 2: Complete Password Reset

```python
@router.post("/reset-password")
async def reset_password(
    request: ResetPasswordRequest,
    db: Session = Depends(get_db)
):
    """
    User clicks reset link and sets new password.
    """
    user = db.query(User).filter(User.reset_token == request.token).first()

    if not user:
        raise HTTPException(status_code=400, detail="Invalid or expired reset link")

    if user.reset_token_expires < datetime.utcnow():
        raise HTTPException(status_code=400, detail="Reset link has expired")

    # Update password
    user.password_hash = hash_password(request.new_password)
    user.reset_token = None
    user.reset_token_expires = None
    user.must_change_password = False
    db.commit()

    # Send confirmation email
    email_service.send_password_changed_email(
        user_name=user.name,
        user_email=user.email
    )

    return {"message": "Password has been reset successfully"}
```

### 3. Flutter Frontend Integration

#### Calling the Password Reset API

```dart
// lib/services/auth_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String baseUrl;

  AuthService({required this.baseUrl});

  /// Step 1: Request password reset
  Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/forgot-password/request'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return jsonDecode(response.body);
  }

  /// Step 2: Verify 2FA and send reset email
  Future<Map<String, dynamic>> verify2FAForReset({
    required String email,
    required String totpCode,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/forgot-password/verify-2fa'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'totp_code': totpCode,
      }),
    );
    return jsonDecode(response.body);
  }

  /// Step 3: Reset password with token
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': token,
        'new_password': newPassword,
      }),
    );
    return jsonDecode(response.body);
  }
}
```

#### Password Reset Screen

```dart
// lib/screens/auth/forgot_password_screen.dart

import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _totpController = TextEditingController();

  int _step = 1;  // 1: Enter email, 2: Enter 2FA, 3: Check email
  bool _isLoading = false;

  Future<void> _requestReset() async {
    setState(() => _isLoading = true);

    try {
      final result = await authService.requestPasswordReset(
        _emailController.text,
      );

      if (result['requires_2fa'] == true) {
        setState(() => _step = 2);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verify2FA() async {
    setState(() => _isLoading = true);

    try {
      await authService.verify2FAForReset(
        email: _emailController.text,
        totpCode: _totpController.text,
      );

      setState(() => _step = 3);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid 2FA code')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: _buildStep(),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 1:
        return Column(
          children: [
            Text('Enter your email address'),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _requestReset,
              child: Text('Continue'),
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            Text('Enter your 2FA code'),
            TextField(
              controller: _totpController,
              decoration: InputDecoration(labelText: '6-digit code'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _verify2FA,
              child: Text('Verify & Send Reset Link'),
            ),
          ],
        );
      case 3:
        return Column(
          children: [
            Icon(Icons.check_circle, size: 64, color: Colors.green),
            Text('Check your email for the reset link'),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back to Login'),
            ),
          ],
        );
      default:
        return Container();
    }
  }
}
```

---

## Available Email Methods

| Method | Description | When to Use |
|--------|-------------|-------------|
| `send_account_created_email()` | Sends welcome email with temp password | Admin creates new user |
| `send_password_reset_email()` | Sends secure reset link | After user verifies 2FA |
| `send_password_changed_email()` | Confirms password was changed | After successful password change |
| `send_2fa_setup_email()` | Reminds user to set up 2FA | After first login |

---

## Configuration

### Current Setup (Development)

Credentials are hardcoded in `backend/app/services/email/config.py`:

```python
GMAIL_USER = "softwaresyshealthprojectupei@gmail.com"
GMAIL_APP_PASSWORD = "ujpy npbi afsw atqf"  # TODO: Move to .env
```

### Production Setup

Before deploying, move credentials to environment variables:

```python
# config.py (updated for production)
import os

GMAIL_USER = os.getenv("GMAIL_USER")
GMAIL_APP_PASSWORD = os.getenv("GMAIL_APP_PASSWORD")
APP_BASE_URL = os.getenv("APP_BASE_URL", "http://localhost:3000")
```

```bash
# .env
GMAIL_USER=softwaresyshealthprojectupei@gmail.com
GMAIL_APP_PASSWORD=ujpy npbi afsw atqf
APP_BASE_URL=https://healthbank.upei.ca
```

---

## Switching Email Providers

To switch from Gmail to another service (SendGrid, Mailgun, AWS SES):

### 1. Create New Provider

```python
# backend/app/services/email/sendgrid.py

from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail
from .base import EmailProvider, EmailMessage

class SendGridProvider(EmailProvider):
    def __init__(self, api_key: str):
        self.client = SendGridAPIClient(api_key)

    def send(self, message: EmailMessage) -> bool:
        mail = Mail(
            from_email=f"{message.from_name} <noreply@healthbank.upei.ca>",
            to_emails=message.to,
            subject=message.subject,
            plain_text_content=message.body_text,
            html_content=message.body_html
        )
        try:
            self.client.send(mail)
            return True
        except Exception as e:
            logger.error(f"SendGrid error: {e}")
            return False

    def send_bulk(self, messages: list[EmailMessage]) -> dict[str, bool]:
        return {msg.to: self.send(msg) for msg in messages}
```

### 2. Update Service

```python
# backend/app/services/email/service.py

def _get_provider(self) -> EmailProvider:
    if self._provider is None:
        # Switch provider here
        # self._provider = GmailProvider(...)
        self._provider = SendGridProvider(api_key=config.SENDGRID_API_KEY)
    return self._provider
```

### 3. Add Config

```python
# backend/app/services/email/config.py

SENDGRID_API_KEY = "SG.xxxxx"  # TODO: Move to .env
```

---

## Error Handling

Email sending is designed to be non-blocking. If an email fails:

1. The method returns `False`
2. An error is logged
3. The API operation continues (user is created, password is reset, etc.)

Always have a fallback for critical operations:

```python
email_sent = email_service.send_account_created_email(...)

if not email_sent:
    # Fallback: show temp password to admin
    logger.warning(f"Email failed for {user.email}")
    return {"temporary_password": temp_password, "email_sent": False}
```

---

## Testing

### Manual Test

```python
# Run in Python shell
from app.services.email import email_service

result = email_service.send_account_created_email(
    user_name="Test User",
    user_email="your-email@example.com",
    temporary_password="TestPass123!"
)
print(f"Email sent: {result}")
```

### Unit Test Mock

```python
# tests/test_account_creation.py

from unittest.mock import patch

@patch('app.services.email.email_service.send_account_created_email')
def test_create_account_sends_email(mock_send_email):
    mock_send_email.return_value = True

    response = client.post("/api/admin/accounts", json={...})

    assert response.status_code == 200
    mock_send_email.assert_called_once()
```
