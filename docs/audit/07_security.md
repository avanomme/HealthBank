# HealthBank Security Audit Report
**Date:** April 3, 2026  
**Auditor:** Claude Security Agent  
**Scope:** Full Backend & Frontend Security Assessment

---

## Executive Summary

HealthBank demonstrates **strong foundational security practices** with proper password hashing, parameterized SQL queries, role-based access control, and session management. However, **CRITICAL production deployment issues** exist with hardcoded credentials and insecure default configurations that must be fixed before any production release.

**Overall Risk Level: CRITICAL (blocking production) → HIGH (after credential fixes)**

---

## CRITICAL Findings — Must Fix Before Production

### 1. Hardcoded Credentials in Repository
**Severity:** CRITICAL  
**Location:** `/env/api.prod.env`, `/env/mysql.prod.env`  
**Issue:**
```
env/api.prod.env:22    SMTP_PASSWORD="peqw mfab ivkr qlol"
env/api.prod.env:36    2FA_MASTER_KEY=OIaU#VWT*&#eoiu
env/mysql.prod.env:1   MYSQL_ROOT_PASSWORD=password
env/mysql.prod.env:4   MYSQL_PASSWORD=mypassword
```

**Impact:** Any attacker with repo access has production database and email service credentials.

**Remediation:**
- Remove `.env` production files from git history using `git filter-branch` or `git filter-repo`
- Ensure `env/*.prod.env` is in `.gitignore`
- Generate new credentials for all services immediately
- Use secure secrets management in production (AWS Secrets Manager, HashiCorp Vault, etc.)
- Use environment-variable-only configuration for production deployments

**Timeline:** Fix before any production deployment

---

### 2. Insecure Default Docker Healthcheck Password
**Severity:** CRITICAL  
**Location:** `docker-compose.yml:18`  
**Issue:**
```yaml
test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-ppassword"]
```

Hardcoded password exposed in container config.

**Remediation:**
- Use environment variable substitution: `-p"${MYSQL_ROOT_PASSWORD}"`
- Use bash with proper expansion for passwords containing special chars

---

### 3. Database Password Exposed in Command Line
**Severity:** CRITICAL  
**Location:** `docker-compose.yml:138, 140`  
**Issue:**
```yaml
mysql -h mysql -u"$${MYSQL_USER}" -p"$${MYSQL_PASSWORD}" < "$${BACKUP_FILE}"
```

Password may be visible in process list, Docker logs, and shell history.

**Remediation:**
- Use `--login-path` for MySQL credentials
- Pass credentials via file descriptor or heredoc
- Mask from process list by reading from environment

---

## HIGH Findings

### 1. COOKIE_SECURE=false in Production Config
**Severity:** HIGH  
**Location:** `env/api.prod.env:7`  
**Issue:**
```
COOKIE_SECURE=false
```

In production without HTTPS, this would expose HttpOnly cookies over HTTP. Currently flagged as development setup, but the prod file exists and could be misused.

**Impact:** If deployed to production without HTTPS, session tokens transmitted insecurely.

**Remediation:**
- Ensure `COOKIE_SECURE=true` in actual production
- Set `Secure` attribute only when HTTPS is enabled
- Verify HTTPS is enforced before deploying prod config

---

### 2. CORS_ORIGINS=localhost in Production Config
**Severity:** HIGH  
**Location:** `env/api.prod.env:14`  
**Issue:**
```
CORS_ORIGINS=localhost
```

Allows any localhost port with credentials. In production, this should be a whitelist of specific domains.

**Impact:** Dev configuration left in prod file increases attack surface.

**Remediation:**
- Change to: `CORS_ORIGINS=https://example.com,https://app.example.com` (production domain list)
- Never use wildcard `*` with `allow_credentials=True`
- Validate domain list is restrictive

---

### 3. X-Client-Type Header for Bearer Token Fallback
**Severity:** HIGH  
**Location:** `backend/app/api/v1/auth.py:436-437`  
**Issue:**
```python
if request.headers.get("x-client-type") != "native":
    session_data.pop("session_token", None)
```

Exposes session token in response body based on client-controlled header. MitM could strip header to force token inclusion.

**Impact:** Session token in HTTP response body is vulnerable to interception if any header is modified.

**Remediation:**
- Rely solely on HttpOnly cookies for web builds
- For mobile, use secure token storage (flutter_secure_storage on Flutter, Keychain/Keystore on native)
- Remove this header-based fallback or require explicit protocol negotiation

---

### 4. SQL Injection via f-string in Dynamic UPDATE Queries
**Severity:** HIGH  
**Location:** Multiple files with dynamic UPDATE column assembly:
- `backend/app/api/v1/surveys.py:447`
- `backend/app/api/v1/question_bank.py:397`
- `backend/app/api/v1/templates.py:274`
- `backend/app/api/v1/assignments.py:360`
- `backend/app/utils/utils.py:91, 127`

**Issue:**
```python
# surveys.py:447
query = f"UPDATE Survey SET {', '.join(updates)} WHERE SurveyID = %s"
# BUT: updates list has parameterized placeholders like "Title = %s"
# The f-string interpolation itself is safe because:
# - updates contains only "ColumnName = %s" strings (column names from Pydantic models)
# - Values go into params tuple
# - The actual SQL execution: cursor.execute(query, tuple(params))
```

**Assessment:** These are **SAFE** (not exploitable) because:
1. Column names come from Pydantic model class attributes (not user input)
2. The `%s` placeholders are hardcoded in the string
3. Actual values are passed in params tuple to `cursor.execute()`

However, the pattern is fragile and could be misused elsewhere. No vulnerability currently.

**Recommendation:** Use `build_update()` helper from utils.py (which validates columns against whitelist) consistently across all endpoints.

---

### 5. MFA Master Key Exposed in Environment File
**Severity:** HIGH  
**Location:** `env/api.prod.env:36`  
**Issue:**
```
2FA_MASTER_KEY=OIaU#VWT*&#eoiu
```

Master key for encrypting TOTP secrets is hardcoded in repo.

**Impact:** Anyone with repo access can decrypt 2FA secrets from database backups.

**Remediation:**
- Remove from version control
- Rotate the key immediately
- Use secure secrets management system
- Consider splitting key across multiple systems (threshold encryption)

---

## MEDIUM Findings

### 1. Email Credentials in Environment File
**Severity:** MEDIUM  
**Location:** `env/api.prod.env:22-23`  
**Issue:**
```
SMTP_USER=softwaresyshealthprojectupei@gmail.com
SMTP_PASSWORD="peqw mfab ivkr qlol"
```

Gmail app password is hardcoded (overlaps with CRITICAL section above, but also medium from email perspective).

**Remediation:**
- Generate new Gmail App Password
- Use Google OAuth instead of app passwords where possible
- Store in secure secrets vault, not environment files

---

### 2. No Specific Rate Limits on Sensitive Endpoints
**Severity:** MEDIUM  
**Location:** Multiple endpoints lack rate limiting
**Finding:**
- ✓ `/login` has rate limit: 10 requests/60 sec
- ✓ `/password_reset_request` has rate limit: 5 requests/60 sec
- ✓ `/change_password` has rate limit: 10 requests/account/60 sec
- ✗ `/validate_password_reset` - NO RATE LIMIT
- ✗ Password reset confirmation - NO RATE LIMIT
- ✗ Most admin endpoints only have role guard, no rate limiting

**Impact:** Brute force attacks possible on password reset token validation.

**Remediation:**
- Add rate limiting to token validation endpoints: 5 attempts per IP/60 sec
- Add rate limiting to sensitive admin operations (user creation, deletion)

---

### 3. Logout Doesn't Invalidate Bearer Token Fallback
**Severity:** MEDIUM  
**Location:** `backend/app/api/v1/sessions.py:271-310`  
**Issue:**

Login returns session token in response body for "native" clients. On logout, token is invalidated in DB, but if client cached it elsewhere, it remains valid until expiry.

**Impact:** If token is exposed (via logs, cache, etc.), it remains valid for up to 8 hours.

**Remediation:**
- Implement token blacklist for invalidated tokens
- Reduce session expiry from 8 hours to 4 hours or less
- Notify clients to clear cached tokens on logout

---

### 4. Account Lockout Duration Not Configurable via Settings
**Severity:** MEDIUM  
**Location:** `backend/app/api/v1/auth.py:321`  
**Finding:**
```python
max_attempts = get_int_setting("max_login_attempts")
lockout_minutes = get_int_setting("lockout_duration_minutes")
```

Lockout duration is read from settings but hardcoded defaults not verified in config.

**Remediation:**
- Ensure settings have reasonable defaults (e.g., max_attempts=5, lockout=15 minutes)
- Document in settings schema
- Add logging for account lockouts

---

### 5. No HSTS Header in Nginx
**Severity:** MEDIUM  
**Location:** `nginx/` configuration  
**Finding:** No HTTPS Strict-Transport-Security header configuration found.

**Remediation:**
- Add `add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;`
- Enforce HTTPS redirects from HTTP

---

### 6. X-Frame-Options and X-Content-Type-Options Headers Missing
**Severity:** MEDIUM  
**Location:** Nginx reverse proxy configuration  
**Finding:** No headers to prevent clickjacking or MIME sniffing.

**Remediation:**
- Add `X-Frame-Options: DENY` or `SAMEORIGIN`
- Add `X-Content-Type-Options: nosniff`
- Add `X-XSS-Protection: 1; mode=block`

---

## LOW / Informational Findings

### 1. Password Reset Token Stored in Plaintext in Auth Table
**Severity:** LOW  
**Location:** `backend/app/utils/password_reset_tokens.py`  
**Finding:**
```python
cur.execute("""
    UPDATE Auth a
    JOIN AccountData ad ON ad.AuthID = a.AuthID
    SET a.ResetToken = %s,
        a.ResetTokenExpires = %s
    WHERE ad.Email = %s
""", (token, expires_at.replace(tzinfo=None), email))
```

Token is stored plaintext (though with 1-hour expiry).

**Assessment:** LOW risk because:
- Token has 1-hour expiry
- DB backup access requires DB compromise first
- Token value is cryptographically random

**Enhancement:** Consider hashing tokens before storage (like sessions do), but current implementation is acceptable.

---

### 2. Phone Home for Password Reset Link URL
**Severity:** LOW  
**Location:** `backend/app/api/v1/auth.py:486`  
**Finding:**
```python
reset_link = f"{os.getenv('FRONTEND_URL', 'http://localhost:3000')}/#/reset-password?token={token}"
```

Frontend URL is not set in env/api.prod.env, falls back to localhost.

**Impact:** Password reset emails would contain invalid localhost URL in production.

**Remediation:**
- Add `FRONTEND_URL=https://healthbank.example.com` to env/api.prod.env
- Validate URL is HTTPS in production

---

### 3. Debug Print Statements in Production Code
**Severity:** LOW  
**Location:** Multiple files:
- `backend/app/api/v1/auth.py:282` - `print(err)`
- `backend/app/api/v1/auth.py:445` - `print(err)`
- Multiple other endpoints

**Impact:** Database errors may leak to logs/stdout without proper sanitization.

**Remediation:**
- Replace `print()` with `logger.error()` 
- Ensure logs don't expose sensitive data
- Use structured logging with sanitization

---

### 4. Viewing-As Feature Lacks Audit Trail
**Severity:** LOW  
**Location:** `backend/app/api/v1/sessions.py:349-381`  
**Finding:** Admin viewing-as functionality exists but may not have detailed audit logging.

**Recommendation:** Ensure all view-as actions are logged with:
- Admin who initiated view-as
- User being viewed-as
- Timestamp
- Actions taken while viewing-as

---

### 5. No Account Enumeration Prevention in All Endpoints
**Severity:** LOW  
**Location:** `backend/app/api/v1/auth.py:480-482`  
**Finding:**
Good: Password reset request returns generic message:
```python
return {"message": "If an account exists for that email, a reset link has been sent."}
```

But some endpoints might leak account existence via timing or error messages.

**Recommendation:** Audit all endpoints for account enumeration vectors (user lookup, etc.)

---

## PASSING Checks

### ✓ Password Hashing: PBKDF2-SHA256
**Location:** `backend/app/api/v1/auth.py:758-790`  
**Status:** PASS
```python
iterations = 210_000  # Industry standard
derived_key = hashlib.pbkdf2_hmac(
    "sha256",
    password.encode("utf-8"),
    salt,
    iterations,
    dklen=32,
)
```
Uses strong KDF with 210,000 iterations. Verified with:
- `hmac.compare_digest()` for timing-attack resistance
- Random salt generation via `os.urandom(32)`

---

### ✓ HttpOnly Cookies for Web Sessions
**Location:** `backend/app/api/v1/sessions.py:132-143`  
**Status:** PASS
```python
response.set_cookie(
    key="session_token",
    value=token,
    max_age=max_age,
    httponly=True,      # ✓ Prevents JavaScript XSS theft
    secure=COOKIE_SECURE,  # ✓ HTTPS-only (when enabled)
    samesite="strict"    # ✓ CSRF protection
)
```

---

### ✓ Parameterized SQL Queries
**Location:** Entire backend codebase  
**Status:** PASS (with one caveat noted above)

All SQL queries use parameterized `%s` placeholders:
```python
cursor.execute(
    "SELECT AccountID FROM Auth WHERE Email = %s",
    (email,)
)
```

No f-string SQL injection vulnerabilities found. Dynamic column names use whitelist validation.

---

### ✓ Input Sanitization with sanitized_string()
**Location:** `backend/app/utils/sanitize.py` and Pydantic validators  
**Status:** PASS

String fields use `@field_validator` with `sanitized_string()`:
- Removes null bytes
- Removes control characters
- Unicode normalization (NFKC)
- Truncates to max length
- Coverage includes: names, titles, descriptions, gender

Example:
```python
@field_validator('first_name', 'last_name', mode='before')
@classmethod
def sanitize(cls, v):
    return sanitized_string(v)
```

---

### ✓ Role-Based Access Control (RBAC)
**Location:** `backend/app/api/deps.py:179-241`  
**Status:** PASS

All admin-only endpoints use `require_role(4)`:
- Router-level protection for entire admin module
- Per-endpoint protection for sensitive operations
- Support for view-as functionality with proper authorization checks

Example:
```python
router = APIRouter(dependencies=[Depends(require_role(4))])

@router.post("/deletion-requests/{id}/approve", 
             dependencies=[Depends(require_role(4))])
```

---

### ✓ Session Invalidation on Logout
**Location:** `backend/app/api/v1/sessions.py:271-310`  
**Status:** PASS

Logout properly:
1. Updates database session record: `IsActive = 0, RevokedAt = UTC_TIMESTAMP()`
2. Deletes HttpOnly cookie: `response.delete_cookie(key="session_token")`

---

### ✓ 2FA Encryption
**Location:** `backend/app/core/totp.py`  
**Status:** PASS

TOTP secrets are encrypted before database storage:
- Algorithm: AES-256-GCM
- KDF: scrypt (n=2^14, r=8, p=1)
- Per-record random salt (16 bytes) and nonce (12 bytes)
- No plaintext secrets in database

---

### ✓ Bearer Token Extraction
**Location:** `backend/app/api/deps.py:50-66`  
**Status:** PASS

Token extraction properly prefers HttpOnly cookies:
```python
def _extract_session_token(request: Request, credentials: HTTPAuthorizationCredentials | None) -> str | None:
    # 1) Cookie (preferred)
    cookie_token = request.cookies.get(SESSION_COOKIE_NAME)
    if cookie_token:
        return cookie_token
    
    # 2) Bearer fallback (during transition)
    if credentials and credentials.scheme and credentials.credentials:
        if credentials.scheme.lower() == "bearer":
            return credentials.credentials
    
    return None
```

---

### ✓ Frontend: No Insecure Token Storage
**Location:** Flutter frontend codebase  
**Status:** PASS

No use of:
- `localStorage` (JavaScript)
- `sessionStorage` (JavaScript)
- `SharedPreferences` (Android, insecure)
- `flutter_secure_storage` (not found in audit)

Tokens are stored in HttpOnly cookies (same-domain requests) or in-memory (native apps).

---

### ✓ Rate Limiting Implementation
**Location:** `backend/app/api/deps.py:259-329`  
**Status:** PASS

Endpoints have appropriate rate limits:
- Login: 10 req/60 sec
- Password reset request: 5 req/60 sec  
- Change password: 10 req/account/60 sec
- 2FA confirm: 5 req/60 sec
- 2FA verify: 5 req/60 sec

---

### ✓ CORS Configuration
**Location:** `backend/app/main.py:20-38`  
**Status:** PASS

CORS properly configured:
- Only enabled when `CORS_ORIGINS` env var is set
- Wildcard `*` disables credentials (`allow_credentials=False`)
- Specific domains allow credentials
- localhost dev mode uses regex for flexibility

Concerns noted in HIGH section about prod config.

---

### ✓ Session Token Hashing
**Location:** `backend/app/api/v1/sessions.py:43-45`  
**Status:** PASS

Session tokens are hashed before database storage:
```python
def hash_token(token: str) -> str:
    """Hash session token before storage"""
    return hashlib.sha256(token.encode()).hexdigest()
```

Database breaches don't leak usable session tokens.

---

## Summary Statistics

| Category | Count | Status |
|----------|-------|--------|
| CRITICAL Findings | 3 | ❌ Must fix |
| HIGH Findings | 5 | ⚠️ Should fix |
| MEDIUM Findings | 6 | ⚠️ Recommended |
| LOW Findings | 5 | 💡 Informational |
| PASSING Checks | 12 | ✓ OK |

---

## Production Readiness Checklist

### Before Production Deployment:

- [ ] **CRITICAL:** Remove hardcoded credentials from all env files
- [ ] **CRITICAL:** Generate new credentials for all services (MySQL, Email, 2FA)
- [ ] **CRITICAL:** Fix Docker healthcheck password hardcoding
- [ ] **CRITICAL:** Fix database password exposure in shell commands
- [ ] **HIGH:** Set `COOKIE_SECURE=true` and verify HTTPS is enforced
- [ ] **HIGH:** Update `CORS_ORIGINS` to production domain list
- [ ] **HIGH:** Add rate limiting to password reset validation endpoints
- [ ] **HIGH:** Replace X-Client-Type header token fallback with secure mobile auth
- [ ] **MEDIUM:** Configure all recommended security headers (HSTS, X-Frame-Options, etc.)
- [ ] **MEDIUM:** Add `FRONTEND_URL` to prod env
- [ ] **MEDIUM:** Replace all `print()` debug statements with structured logging
- [ ] **LOW:** Review audit logging for view-as functionality
- [ ] **LOW:** Perform account enumeration testing

---

## Recommendations for Future Improvements

1. **Secrets Management:** Migrate from env files to AWS Secrets Manager, HashiCorp Vault, or similar
2. **Audit Logging:** Implement comprehensive audit trail for sensitive operations
3. **API Versioning:** Consider API versioning strategy for future breaking changes
4. **Session Management:** Implement token blacklist/revocation list for immediate token invalidation
5. **Mobile Security:** Implement proper Bearer token handling with secure storage
6. **Penetration Testing:** Conduct third-party penetration test before production launch
7. **OWASP Compliance:** Verify against OWASP Top 10 and secure coding standards
8. **CSP Headers:** Implement Content Security Policy for XSS prevention
9. **Logging & Monitoring:** Set up centralized logging and real-time alerting for security events
10. **Incident Response:** Establish incident response plan for security breaches

---

## Conclusion

HealthBank has **solid security foundations** with:
- ✓ Strong password hashing (PBKDF2)
- ✓ Secure session management (HttpOnly, SameSite, hashed tokens)
- ✓ Proper input validation and sanitization
- ✓ Role-based access control
- ✓ Parameterized SQL queries
- ✓ 2FA encryption

However, **CRITICAL production blockers** exist:
- ❌ Hardcoded credentials in repository
- ❌ Insecure Docker configurations
- ❌ Development settings in production env files

**Status:** ⛔ **NOT PRODUCTION-READY** until CRITICAL findings are remediated. After credential rotation and configuration fixes, the security posture is **STRONG** and suitable for production with the recommended enhancements.

---

**Report Generated:** April 3, 2026  
**Next Review:** After production deployment and quarterly thereafter
