# `markdown/password_reset_tokens.md` — Password Reset Token Utilities

## Overview

`backend/app/utils/password_reset_tokens.py` provides secure password reset token management for HealthBank.

It supports:

- Generating a secure, time-limited reset token
- Validating reset tokens
- Clearing reset tokens after use
- Preventing account enumeration (when used correctly by caller)

Reset tokens are:

- Cryptographically secure
- URL-safe
- Time-limited (default: 1 hour)
- Stored in the `Auth` table
- Invalidated after successful password reset

---

## Architecture / Design Explanation

### Token Generation

- Uses `secrets.token_urlsafe(32)`
- Produces a high-entropy, URL-safe string
- Intended to be embedded in frontend password reset URLs

### Storage Model

The token is stored in:

- `Auth.ResetToken`
- `Auth.ResetTokenExpires`

The update is performed via:

```sql
UPDATE Auth a
JOIN AccountData ad ON ad.AuthID = a.AuthID
SET a.ResetToken = %s,
    a.ResetTokenExpires = %s
WHERE ad.Email = %s