# Backend Security Overview

## 1. Purpose

This document defines how security-sensitive operations are implemented and reused within the backend. Its purpose is to:

- Enforce consistent security practices
- Prevent duplication of cryptographic or sanitization logic
- Eliminate conflicting or ad-hoc security implementations
- Define canonical security modules and responsibilities

This document is authoritative for backend security behavior.

---

## 2. Guiding Principle

**For X, use Y.**

If approved security functionality already exists, reuse it.  
Do not re-implement cryptography, secret handling, or sanitization logic unless explicitly required and formally reviewed.

---

# 3. Two-Factor Authentication (TOTP)

All TOTP-related functionality is implemented exclusively in:

- `totp.py`

No alternative implementations are permitted.

---

## 3.1 Canonical Function Usage

| Task | Required Function |
|------|------------------|
| Generate a new TOTP secret | `create_secret()` |
| Enroll a user for 2FA (secret + provisioning URI) | `enroll_for_db(config, masterkey=...)` |
| Encrypt a TOTP secret for database storage | `encrypt_2fa_secret_for_db(secret, masterkey)` |
| Decrypt a stored TOTP secret | `decrypt_2fa_secret_from_db(token, masterkey)` |
| Verify a 6-digit TOTP code | `verify_totp_from_db_token(...)` |

### Mandatory Rule

All TOTP operations must use these functions.

---

## 3.2 TOTP Storage Model

### Storage Requirements

- Only encrypted TOTP tokens are stored in the database.
- Raw TOTP secrets must never be stored.
- Encrypted tokens must be:
  - AES-256-GCM encrypted
  - Key-derived using scrypt
  - Stored as base64url-encoded, versioned JSON

### Strictly Prohibited

- Storing raw TOTP secrets
- Creating alternate encryption formats
- Re-implementing TOTP verification logic
- Implementing custom clock-drift handling
- Logging decrypted secrets
- Logging master keys
- Logging full encrypted tokens

---

# 4. Encryption of TOTP Secrets (At Rest)

## 4.1 Encryption Specification

- **Cipher:** AES-256-GCM  
- **Key Derivation Function:** scrypt  
- **Per-record requirements:**
  - Random salt
  - Random nonce
- Payload must be versioned to support future migrations.

---

## 4.2 Encrypted Payload Structure

Encrypted tokens are base64url-encoded JSON containing:

| Field | Description |
|-------|------------|
| `v` | Payload version |
| `kdf` | Key derivation function (`scrypt`) |
| `cipher` | Encryption algorithm (`aes-256-gcm`) |
| `salt_b64` | Base64-encoded salt |
| `nonce_b64` | Base64-encoded nonce |
| `ct_b64` | Base64-encoded ciphertext |

No alternate formats are allowed.

---

# 5. Master Key Management

## 5.1 Source of Master Key

- Loaded from an environment variable.
- Default variable name: `TOTP_MASTERKEY`
- May be overridden via `TwoFAConfig.masterkey_env`

## 5.2 Operational Requirements

The master key environment variable must be present for:

- 2FA enrollment
- TOTP verification

Services must fail closed if the master key is missing.

## 5.3 Strictly Prohibited

- Hardcoding the master key
- Storing the master key in the database
- Committing the master key to version control
- Printing or logging the master key

---

# 6. Data Sanitization for Database Storage

All sanitization logic is implemented in:

- `sanitize.py` (or equivalent module)

No alternative sanitization implementations are permitted.

---

## 6.1 Canonical Usage

To convert arbitrary Python objects into database-safe values:

    sanitizeData(value, config=...)

This function must be used for all untrusted or user-supplied data before database storage.

---

## 6.2 Sanitization Behavior

The sanitizer enforces:

- Unicode normalization (default: NFKC)
- Null byte removal
- Control character removal
- Whitespace trimming
- String length limits
- Safe encoding of binary data (default: base64)
- JSON serialization of complex structures
- Depth limits to mitigate nested-input attacks
- Collection size limits to mitigate DoS-style payloads

---

## 6.3 Complex Type Handling

The following types are:

- Recursively sanitized:
  - `list`
  - `dict`
  - `set`
  - `tuple`

- Serialized to JSON at the top level
- Subject to maximum depth and collection size enforcement

---

## 6.4 Strictly Prohibited

- Writing ad-hoc sanitization logic
- Treating sanitization as a replacement for parameterized queries
- Bypassing sanitization for untrusted or user-supplied data

Sanitization must be used alongside parameterized queries.

---

# 7. Base Security Modules

## 7.1 `totp.py`

Responsibilities:

- TOTP secret generation
- Provisioning URI creation
- Encryption of TOTP secrets
- Decryption of TOTP secrets
- Verification of user-provided TOTP codes

This module defines the canonical encrypted TOTP format.

---

## 7.2 `sanitize.py`

Responsibilities:

- Database-safe value conversion
- Unicode normalization
- Control character handling
- Safe JSON serialization
- Depth and size enforcement

This module defines the canonical database-safe conversion path.

---

# 8. Dependencies

## 8.1 TOTP & Encryption

- `pyotp`
- `cryptography`
  - Uses `cryptography.hazmat.primitives.ciphers.aead.AESGCM`

## 8.2 Sanitization

Python standard library only:

- `json`
- `base64`
- `re`
- `unicodedata`
- `datetime`
- `decimal`
- `math`

---

# 9. Operational Expectations

- The master key environment variable must exist in all relevant environments.
- Systems must fail securely if required security configuration is missing.
- Logs must never contain sensitive material.
- Security modules must remain centralized and canonical.

---

# 10. Non-Conflict Policy

- `totp.py` defines the authoritative encrypted TOTP format.
- `sanitize.py` defines the authoritative database-safe conversion path.
- Any new security-related implementation must be reviewed for overlap before being added.
- Duplication of security logic is prohibited.

Security consistency takes precedence over convenience.