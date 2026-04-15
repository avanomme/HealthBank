# Created with the assistance of Claude Code
# backend/app/services/email/templates.py
"""
Email templates for HealthBank notifications.

All templates return (subject, body_text, body_html) tuples.
All HTML uses inline styles only — <style> blocks are stripped by Gmail and
most email clients.
"""
from typing import Tuple


# ── Brand colours ─────────────────────────────────────────────────────────────
_BLUE        = "#2563eb"
_BLUE_DARK   = "#1d4ed8"
_GRAY_BG     = "#f3f4f6"
_GRAY_BORDER = "#d1d5db"
_CODE_BG     = "#e5e7eb"
_WARN_BG     = "#fef3c7"
_WARN_BORDER = "#f59e0b"
_TEXT        = "#1f2937"
_MUTED       = "#6b7280"


def _base_html(content: str) -> str:
    """Wrap content in a robust inline-styled email shell."""
    return f"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>HealthBank</title>
</head>
<body style="margin:0;padding:0;background-color:{_GRAY_BG};font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;">
  <table role="presentation" cellpadding="0" cellspacing="0" width="100%"
         style="background-color:{_GRAY_BG};padding:32px 16px;">
    <tr>
      <td align="center">
        <table role="presentation" cellpadding="0" cellspacing="0" width="100%"
               style="max-width:600px;">

          <!-- Header -->
          <tr>
            <td style="background-color:{_BLUE};border-radius:8px 8px 0 0;
                        padding:24px 32px;text-align:center;">
              <h1 style="margin:0;color:#ffffff;font-size:24px;font-weight:700;
                          letter-spacing:0.5px;">HealthBank</h1>
            </td>
          </tr>

          <!-- Body -->
          <tr>
            <td style="background-color:#ffffff;border:1px solid {_GRAY_BORDER};
                        border-top:none;border-radius:0 0 8px 8px;
                        padding:32px;color:{_TEXT};font-size:15px;line-height:1.6;">
              {content}
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="text-align:center;color:{_MUTED};font-size:12px;
                        padding:20px 0;">
              <p style="margin:4px 0;">This is an automated message from HealthBank.
                Please do not reply to this email.</p>
              <p style="margin:4px 0;">&copy; 2025 HealthBank &mdash; UPEI Health Data Bank Project</p>
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>"""


def _button(url: str, label: str) -> str:
    """Inline-styled CTA button that renders correctly in all email clients."""
    return (
        f'<table role="presentation" cellpadding="0" cellspacing="0" '
        f'style="margin:24px auto;">'
        f'<tr><td style="background-color:{_BLUE};border-radius:6px;'
        f'text-align:center;">'
        f'<a href="{url}" '
        f'style="display:inline-block;background-color:{_BLUE};color:#ffffff !important;'
        f'font-size:15px;font-weight:600;text-decoration:none;padding:13px 28px;'
        f'border-radius:6px;border:none;">{label}</a>'
        f'</td></tr></table>'
    )


def _code_block(value: str) -> str:
    return (
        f'<div style="background-color:{_CODE_BG};border-radius:6px;'
        f'padding:16px 20px;text-align:center;margin:16px 0;'
        f'font-family:monospace;font-size:20px;font-weight:700;'
        f'letter-spacing:3px;color:{_TEXT};">{value}</div>'
    )


def _warning_box(content: str) -> str:
    return (
        f'<div style="background-color:{_WARN_BG};border:1px solid {_WARN_BORDER};'
        f'border-radius:6px;padding:16px 20px;margin:20px 0;'
        f'color:{_TEXT};font-size:14px;">'
        f'{content}</div>'
    )


# ── Templates ─────────────────────────────────────────────────────────────────

def account_created(
    user_name: str,
    user_email: str,
    temporary_password: str,
    login_url: str,
) -> Tuple[str, str, str]:
    """New account creation email with temporary password."""

    subject = "Welcome to HealthBank — Your Account Has Been Created"

    body_text = f"""\
Welcome to HealthBank, {user_name}!

Your account has been created. Here are your login credentials:

  Email:              {user_email}
  Temporary Password: {temporary_password}

Log in at: {login_url}

IMPORTANT:
- You will be required to change your password on first login.
- You will need to set up Two-Factor Authentication (2FA).
- Keep your credentials secure and do not share them.

If you did not expect this email, please contact your administrator.

— The HealthBank Team
"""

    warn = _warning_box(
        "<strong>Before you start:</strong>"
        "<ul style='margin:8px 0 0;padding-left:20px;'>"
        "<li>You will be required to change your password on first login.</li>"
        "<li>You will need to set up Two-Factor Authentication (2FA).</li>"
        "<li>Keep your credentials secure &mdash; do not share them.</li>"
        "</ul>"
    )
    code = _code_block(temporary_password)
    btn  = _button(login_url, "Log In to HealthBank")
    body_html = _base_html(
        f"<h2 style='margin:0 0 12px;font-size:20px;color:{_TEXT};'>"
        f"Welcome to HealthBank, {user_name}!</h2>"
        f"<p style='margin:0 0 16px;'>Your account has been created."
        f" Use the credentials below to log in for the first time.</p>"
        f"<p style='margin:0 0 4px;font-size:14px;color:{_MUTED};'>Email address</p>"
        f"<p style='margin:0 0 16px;font-family:monospace;font-size:15px;"
        f"font-weight:600;'>{user_email}</p>"
        f"<p style='margin:0 0 4px;font-size:14px;color:{_MUTED};'>Temporary password</p>"
        f"{code}{btn}{warn}"
        f"<p style='margin:20px 0 0;font-size:13px;color:{_MUTED};'>"
        f"If you did not expect this email, please contact your administrator.</p>"
    )

    return subject, body_text, body_html


def password_reset_request(
    user_name: str,
    reset_url: str,
    expiry_minutes: int = 60,
) -> Tuple[str, str, str]:
    """Password reset request email with secure link."""

    subject = "HealthBank — Password Reset Request"

    body_text = f"""\
Hello {user_name},

We received a request to reset your HealthBank password. Since you have verified
your identity with Two-Factor Authentication, you can now reset your password:

  Reset link: {reset_url}

This link expires in {expiry_minutes} minutes.

If you did not request a password reset, ignore this email — your password will
remain unchanged. If you are concerned about account security, contact your
administrator.

— The HealthBank Team
"""

    warn = _warning_box(
        "<strong>Didn't request this?</strong><br>"
        "If you did not request a password reset, ignore this email &mdash; your password"
        " will remain unchanged. If you're concerned about account security, please"
        " contact your administrator."
    )
    btn = _button(reset_url, "Reset Your Password")
    body_html = _base_html(
        f"<h2 style='margin:0 0 12px;font-size:20px;color:{_TEXT};'>Password Reset Request</h2>"
        f"<p style='margin:0 0 16px;'>Hello {user_name},</p>"
        f"<p style='margin:0 0 16px;'>We received a request to reset your password."
        f" Since you have verified your identity with Two-Factor Authentication,"
        f" you can reset your password using the button below.</p>"
        f"{btn}"
        f"<p style='text-align:center;margin:-12px 0 16px;font-size:13px;color:{_MUTED};'>"
        f"This link expires in <strong>{expiry_minutes}&nbsp;minutes</strong>.</p>"
        f"{warn}"
    )

    return subject, body_text, body_html


def password_changed(
    user_name: str,
    user_email: str,
) -> Tuple[str, str, str]:
    """Password change confirmation email."""

    subject = "HealthBank — Your Password Has Been Changed"

    body_text = f"""\
Hello {user_name},

Your HealthBank password has been successfully changed.

Account: {user_email}

If you did not make this change, contact your administrator immediately — your
account may be compromised.

— The HealthBank Team
"""

    warn = _warning_box(
        "<strong>Didn't make this change?</strong><br>"
        "Contact your administrator immediately &mdash; your account may be compromised."
    )
    body_html = _base_html(
        f"<h2 style='margin:0 0 12px;font-size:20px;color:{_TEXT};'>"
        f"Password Changed Successfully</h2>"
        f"<p style='margin:0 0 16px;'>Hello {user_name},</p>"
        f"<p style='margin:0 0 16px;'>Your HealthBank password has been successfully changed.</p>"
        f"<p style='margin:0 0 16px;'>"
        f"<span style='font-size:14px;color:{_MUTED};'>Account:</span>&nbsp;"
        f"<strong style='font-family:monospace;'>{user_email}</strong></p>"
        f"{warn}"
    )

    return subject, body_text, body_html


def two_factor_setup(
    user_name: str,
    setup_url: str,
) -> Tuple[str, str, str]:
    """2FA setup reminder email."""

    subject = "HealthBank — Complete Your Two-Factor Authentication Setup"

    body_text = f"""\
Hello {user_name},

To secure your HealthBank account, please complete Two-Factor Authentication (2FA) setup:

  Setup link: {setup_url}

What you'll need:
- An authenticator app (Google Authenticator, Authy, etc.)
- Your mobile phone

2FA adds an extra layer of security by requiring both your password and a
time-based code from your phone to log in.

— The HealthBank Team
"""

    btn = _button(setup_url, "Set Up 2FA")
    body_html = _base_html(
        f"<h2 style='margin:0 0 12px;font-size:20px;color:{_TEXT};'>"
        f"Complete Your 2FA Setup</h2>"
        f"<p style='margin:0 0 16px;'>Hello {user_name},</p>"
        f"<p style='margin:0 0 16px;'>To secure your HealthBank account, please complete"
        f" Two-Factor Authentication (2FA) setup using the button below.</p>"
        f"{btn}"
        f"<h3 style='margin:24px 0 8px;font-size:15px;color:{_TEXT};'>What you'll need</h3>"
        f"<ul style='margin:0;padding-left:20px;color:{_TEXT};'>"
        f"<li>An authenticator app (Google Authenticator, Authy, etc.)</li>"
        f"<li>Your mobile phone</li>"
        f"</ul>"
        f"<p style='margin:16px 0 0;'>2FA adds an extra layer of security by requiring"
        f" both your password and a time-based code from your phone every time you log in.</p>"
    )

    return subject, body_text, body_html


def admin_password_reset(
    user_name: str,
    temporary_password: str,
) -> Tuple[str, str, str]:
    """Admin-initiated password reset with temporary password."""

    subject = "HealthBank — Your Password Has Been Reset"

    body_text = f"""\
Hello {user_name},

Your HealthBank password has been reset by an administrator.
Use the temporary password below to log in, then change it immediately.

  Temporary Password: {temporary_password}

If you did not expect this reset, contact your administrator immediately.

— The HealthBank Team
"""

    warn = _warning_box(
        "<strong>Security Notice:</strong> If you did not request this password reset, "
        "please contact your administrator immediately."
    )
    body_html = _base_html(
        f"<h2 style='margin:0 0 12px;font-size:20px;color:{_TEXT};'>"
        f"Password Reset by Administrator</h2>"
        f"<p style='margin:0 0 16px;'>Hello {user_name},</p>"
        f"<p style='margin:0 0 16px;'>Your HealthBank password has been reset by an "
        f"administrator. Use the temporary password below to log in, then change it "
        f"immediately.</p>"
        f"<p style='margin:0 0 4px;font-size:14px;color:{_MUTED};'>Temporary password</p>"
        f"{_code_block(temporary_password)}"
        f"{warn}"
    )

    return subject, body_text, body_html


def account_rejected(
    user_name: str,
    admin_notes: str | None = None,
) -> Tuple[str, str, str]:
    """Account request rejection notification."""

    subject = "HealthBank — Account Request Update"

    notes_section = f"\n\nAdministrator notes:\n{admin_notes}" if admin_notes else ""

    body_text = f"""\
Hello {user_name},

Thank you for your interest in HealthBank. After reviewing your account request,
we are unable to approve it at this time.{notes_section}

If you believe this was in error or would like more information, please contact
our support team.

— The HealthBank Team
"""

    notes_html = ""
    if admin_notes:
        notes_html = (
            f"<div style='background-color:{_GRAY_BG};border-radius:6px;"
            f"padding:16px 20px;margin:16px 0;'>"
            f"<p style='margin:0 0 4px;font-size:13px;color:{_MUTED};'>"
            f"Administrator notes</p>"
            f"<p style='margin:0;color:{_TEXT};'>{admin_notes}</p></div>"
        )

    body_html = _base_html(
        f"<h2 style='margin:0 0 12px;font-size:20px;color:{_TEXT};'>"
        f"Account Request Update</h2>"
        f"<p style='margin:0 0 16px;'>Hello {user_name},</p>"
        f"<p style='margin:0 0 16px;'>Thank you for your interest in HealthBank. After "
        f"reviewing your account request, we are unable to approve it at this time.</p>"
        f"{notes_html}"
        f"<p style='margin:16px 0 0;'>If you believe this was in error or would like "
        f"more information, please contact our support team.</p>"
    )

    return subject, body_text, body_html


def account_deletion_rejected(
    user_name: str,
    admin_notes: str | None = None,
) -> Tuple[str, str, str]:
    """Notification sent when an admin rejects an account deletion request."""

    subject = "HealthBank — Account Deletion Request Update"

    notes_section = f"\n\nReason provided:\n{admin_notes}" if admin_notes else ""

    body_text = f"""\
Hello {user_name},

Your request to delete your HealthBank account has been reviewed by our team.
After careful consideration, we are unable to process this deletion at this time.{notes_section}

Your account has been reactivated and you can continue to use HealthBank as normal.

If you have questions or would like to discuss this further, please contact our
support team.

— The HealthBank Team
"""

    notes_html = ""
    if admin_notes:
        notes_html = (
            f"<div style='background-color:{_GRAY_BG};border-radius:6px;"
            f"padding:16px 20px;margin:16px 0;'>"
            f"<p style='margin:0 0 4px;font-size:13px;color:{_MUTED};'>"
            f"Reason provided</p>"
            f"<p style='margin:0;color:{_TEXT};'>{admin_notes}</p></div>"
        )

    body_html = _base_html(
        f"<h2 style='margin:0 0 12px;font-size:20px;color:{_TEXT};'>"
        f"Account Deletion Request Update</h2>"
        f"<p style='margin:0 0 16px;'>Hello {user_name},</p>"
        f"<p style='margin:0 0 16px;'>Your request to delete your HealthBank account has "
        f"been reviewed by our team. After careful consideration, we are unable to process "
        f"this deletion at this time.</p>"
        f"{notes_html}"
        f"<p style='margin:0 0 16px;'>Your account has been <strong>reactivated</strong> "
        f"and you can continue to use HealthBank as normal.</p>"
        f"<p style='margin:0;'>If you have questions or would like to discuss this further, "
        f"please contact our support team.</p>"
    )

    return subject, body_text, body_html


def account_deletion_approved(
    user_name: str,
) -> Tuple[str, str, str]:
    """Notification sent when an admin approves an account deletion request."""

    subject = "HealthBank — Your Account Has Been Deleted"

    body_text = f"""\
Hello {user_name},

Your request to delete your HealthBank account has been reviewed and approved.
Your account and personal information have now been permanently removed from our system.

Please note that anonymised research data you contributed (survey responses) is
retained to protect the integrity of ongoing studies. This data contains no
personally identifiable information and cannot be traced back to you.

If you believe this was done in error or have any questions, please contact our
support team.

Thank you for being part of HealthBank.

— The HealthBank Team
"""

    body_html = _base_html(
        f"<h2 style='margin:0 0 12px;font-size:20px;color:{_TEXT};'>"
        f"Account Deletion Confirmed</h2>"
        f"<p style='margin:0 0 16px;'>Hello {user_name},</p>"
        f"<p style='margin:0 0 16px;'>Your request to delete your HealthBank account has "
        f"been reviewed and approved. Your account and personal information have been "
        f"<strong>permanently removed</strong> from our system.</p>"
        f"<div style='background-color:{_GRAY_BG};border-radius:6px;"
        f"padding:16px 20px;margin:16px 0;'>"
        f"<p style='margin:0 0 8px;font-size:14px;color:{_TEXT};'>"
        f"<strong>About your research contributions</strong></p>"
        f"<p style='margin:0;font-size:14px;color:{_MUTED};'>"
        f"Anonymised survey responses you contributed are retained to protect the "
        f"integrity of ongoing research studies. This data contains no personally "
        f"identifiable information and cannot be traced back to you.</p></div>"
        f"<p style='margin:16px 0 0;'>If you believe this was done in error or have "
        f"any questions, please contact our support team.</p>"
        f"<p style='margin:16px 0 0;'>Thank you for being part of HealthBank.</p>"
    )

    return subject, body_text, body_html


def forgot_password(
    user_name: str,
    reset_link: str,
) -> Tuple[str, str, str]:
    """Self-service forgot-password email with a reset link."""

    subject = "HealthBank — Password Reset Request"

    body_text = f"""\
Hello {user_name},

We received a request to reset your HealthBank password.
Use the link below to set a new password:

  {reset_link}

This link expires in 60 minutes. If you did not request a reset, ignore this
email — your password will remain unchanged.

— The HealthBank Team
"""

    warn = _warning_box(
        "<strong>Didn't request this?</strong><br>"
        "Ignore this email &mdash; your password will remain unchanged."
    )
    btn = _button(reset_link, "Reset Your Password")
    body_html = _base_html(
        f"<h2 style='margin:0 0 12px;font-size:20px;color:{_TEXT};'>"
        f"Password Reset Request</h2>"
        f"<p style='margin:0 0 16px;'>Hello {user_name},</p>"
        f"<p style='margin:0 0 16px;'>We received a request to reset your HealthBank "
        f"password. Click the button below to set a new password.</p>"
        f"{btn}"
        f"<p style='text-align:center;margin:-12px 0 16px;font-size:13px;color:{_MUTED};'>"
        f"This link expires in <strong>60&nbsp;minutes</strong>.</p>"
        f"{warn}"
    )

    return subject, body_text, body_html
