# `markdown/totp_secret_storage.md` — TOTP Secret Storage & Verification Utilities

## Overview

This module provides utilities to securely generate, encrypt, store, and verify TOTP (Time-based One-Time Password) secrets.

Key capabilities:

- Generate a new Base32 TOTP secret (`create_secret`)
- Encrypt/decrypt TOTP secrets for database storage using:
  - scrypt key derivation + AES-256-GCM authenticated encryption
- Produce an `otpauth://` provisioning URI for authenticator apps
- Provide enrollment helpers returning a DB-safe token + provisioning URI
- Verify a 6-digit TOTP code using an encrypted DB token

Encryption is designed so the database stores only an opaque token and never stores the raw TOTP secret.

---

## Architecture / Design Explanation

### Threat Model and Storage Approach

- The plaintext TOTP secret is never intended to be stored directly in the database.
- Instead, a single token is stored:
  - base64url-encoded JSON payload (versioned)
  - containing salt, nonce, and ciphertext produced by AES-256-GCM
- A master key (from an environment variable by default) is used to derive an encryption key per record.

This design provides:

- Confidentiality of the TOTP secret at rest
- Integrity/authenticity of ciphertext via AES-GCM
- Per-record uniqueness via random salt + nonce
- Versioned payload format for future migrations

### Key Derivation

A 256-bit key is derived from the master key using `scrypt`:

- `n = 2**14`
- `r = 8`
- `p = 1`
- `dklen = 32`

The salt is randomly generated per encrypted record (`16 bytes`) and stored in the payload.

### Encryption

Encryption uses `cryptography.hazmat.primitives.ciphers.aead.AESGCM` with:

- Nonce: random `12 bytes` per record
- Associated data: `None`
- Ciphertext includes the authentication tag as produced by AESGCM

### Payload Format (DB Token)

Encryption produces a JSON payload:

- `v`: payload version (`1`)
- `kdf`: `"scrypt"`
- `cipher`: `"aes-256-gcm"`
- `salt_b64`: base64-encoded 16-byte salt
- `nonce_b64`: base64-encoded 12-byte nonce
- `ct_b64`: base64-encoded ciphertext+tag

This JSON is:

- encoded as UTF-8
- base64url encoded
- padding stripped (`=` removed)

Decryption restores padding before decoding.

### Provisioning URI

The module uses `pyotp.TOTP(...).provisioning_uri(...)` to produce an `otpauth://` URI suitable for:

- Google Authenticator
- Authy
- Microsoft Authenticator
- Most RFC-compatible authenticator apps

### Verification

Verification flow:

1. Validate code format: must be 6 digits
2. Load master key (explicit param or env var)
3. Decrypt secret from DB token
4. Verify via `pyotp.TOTP.verify(code, valid_window=...)`

`valid_window` supports clock drift by allowing ±N time steps.

---

## Configuration (if applicable)

### Environment Variables

#### `TOTP_MASTERKEY` (default env var name)

Used as the master key to derive per-record encryption keys. The default env var name is provided by `TwoFAConfig.masterkey_env`.

- Default `TwoFAConfig.masterkey_env`: `"TOTP_MASTERKEY"`
- Required for `enroll_for_db(...)` and `verify_totp_from_db_token(...)` unless `masterkey` is passed explicitly.

Recommended properties:

- High-entropy, long random string
- Treated as a secret and never logged
- Rotating this key will prevent decrypting existing stored tokens unless you implement a migration strategy

---

## API Reference

### Exceptions

#### `SecretStorageError`

Raised when secret encryption/decryption or configuration fails (e.g., missing master key, corrupt token).

---

### Dataclasses

#### `TwoFAConfig`

Configuration used for provisioning and verification.

Fields:

- `app_name: str`
  - Issuer name displayed in authenticator apps.
- `account_name: str`
  - Account identifier displayed in authenticator apps (often email).
- `masterkey_env: str` (default `"TOTP_MASTERKEY"`)
  - Environment variable containing the master key.
- `interval_seconds: int` (default `30`)
  - TOTP time step interval.

---

### Functions

#### `create_secret() -> str`

Generates a new Base32-encoded secret suitable for TOTP.

Uses `pyotp.random_base32()`.

---

#### `encrypt_2fa_secret_for_db(secret: str, masterkey: str) -> str`

Encrypts a plaintext TOTP secret and returns a DB-safe token:

- base64url-encoded JSON
- padding removed

**Parameters**
- `secret: str`
- `masterkey: str`

**Returns**
- `str` token suitable for DB storage (opaque string)

**Raises**
- `SecretStorageError` if `secret` or `masterkey` is missing/blank

---

#### `decrypt_2fa_secret_from_db(token: str, masterkey: str) -> str`

Decrypts a DB token back into the original plaintext secret.

**Parameters**
- `token: str`
- `masterkey: str`

**Returns**
- `str` plaintext secret

**Raises**
- `SecretStorageError` if:
  - master key is missing
  - token is missing
  - token is corrupt (base64/JSON decode fails)
  - payload format/version is unsupported
  - decryption fails (wrong master key or tampered ciphertext)

---

#### `provisioning_uri(secret: str, app_name: str, account_name: str, interval_seconds: int = 30) -> str`

Creates an `otpauth://` provisioning URI used to enroll an authenticator app.

**Parameters**
- `secret: str`
- `app_name: str`
- `account_name: str`
- `interval_seconds: int`

**Returns**
- `str` provisioning URI

---

#### `enroll_for_db(config: TwoFAConfig, *, masterkey: str | None = None) -> tuple[str, str]`

Enrollment helper that returns:

- `db_token: str` (encrypted secret token for DB)
- `uri: str` (provisioning URI for authenticator enrollment)

Master key selection:

- Uses `masterkey` argument if provided and non-blank
- Otherwise loads from environment variable `config.masterkey_env`

**Parameters**
- `config: TwoFAConfig`
- `masterkey: Optional[str]`

**Returns**
- `(token: str, uri: str)`

**Raises**
- `SecretStorageError` if master key is missing

---

#### `verify_totp_from_db_token(...) -> bool`

Verifies a 6-digit TOTP code using an encrypted DB token.

**Signature**
- `verify_totp_from_db_token(code: str, *, token: str, config: TwoFAConfig, valid_window: int = 1, masterkey: str | None = None) -> bool`

**Parameters**
- `code: str`
  - Must be exactly 6 digits; otherwise returns `False`.
- `token: str`
  - Encrypted DB token created by `encrypt_2fa_secret_for_db` / `enroll_for_db`.
- `config: TwoFAConfig`
  - Provides interval and master key env var name.
- `valid_window: int` (default `1`)
  - Allows ±N time steps for clock drift.
- `masterkey: Optional[str]`
  - Overrides environment lookup if provided.

**Returns**
- `bool`
  - `True` if the code verifies within the allowed window.

**Raises**
- `SecretStorageError` if:
  - master key is missing, or
  - token decryption fails

---

## Parameters and Return Types

### Summary Table

- `create_secret() -> str`
- `encrypt_2fa_secret_for_db(secret: str, masterkey: str) -> str`
- `decrypt_2fa_secret_from_db(token: str, masterkey: str) -> str`
- `provisioning_uri(secret: str, app_name: str, account_name: str, interval_seconds: int = 30) -> str`
- `enroll_for_db(config: TwoFAConfig, masterkey: Optional[str] = None) -> tuple[str, str]`
- `verify_totp_from_db_token(code: str, token: str, config: TwoFAConfig, valid_window: int = 1, masterkey: Optional[str] = None) -> bool`

---

## Error Handling

### Master Key Requirements

- `_require_masterkey(env_var)` raises `SecretStorageError` if the env var is missing or blank.
- `encrypt_2fa_secret_for_db` and `decrypt_2fa_secret_from_db` raise `SecretStorageError` if the master key is missing/blank.

### Corrupt Token / Payload

Decryption raises `SecretStorageError` when:

- base64url decoding fails
- JSON parsing fails
- payload metadata does not match supported format:
  - `v != 1`, `kdf != "scrypt"`, or `cipher != "aes-256-gcm"`

### Wrong Key / Tampering

AES-GCM decryption failure raises:

- `SecretStorageError("Failed to decrypt secret. Wrong master key?")`

### Verification Input

- `verify_totp_from_db_token` returns `False` (no exception) if:
  - `code` is not exactly 6 digits

---

## Usage Examples (only where helpful)

### Enroll a user and store token in DB

```python
from your_module import TwoFAConfig, enroll_for_db

config = TwoFAConfig(app_name="HealthBank", account_name="user@example.com")
db_token, uri = enroll_for_db(config)

# Store db_token in your Account2FA (or equivalent) table
# Display `uri` as a QR code in your frontend (or convert to QR server-side)