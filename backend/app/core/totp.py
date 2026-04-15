# Created with the assistance of Generative AI
"""
TOTP (Time-based One-Time Password) secret management for HealthBank.

Provides AES-GCM encrypted storage and retrieval of TOTP secrets via the
TwoFASecretManager class. The master encryption key is loaded from the
TOTP_MASTERKEY environment variable and derived with scrypt. Use
TwoFASecretManager to enroll, verify, and disable 2FA for user accounts.
"""

from __future__ import annotations

import base64
import json
import os
from dataclasses import dataclass
from pathlib import Path
from typing import Optional

import pyotp
#import qrcode
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
from hashlib import scrypt


class SecretStorageError(RuntimeError):
    """Raised when secret encryption/decryption fails."""


@dataclass(frozen=True)
class TwoFAConfig:
    app_name: str
    account_name: str
    masterkey_env: str = "TOTP_MASTERKEY"
    interval_seconds: int = 30


def _require_masterkey(env_var: str) -> str:
    mk = os.getenv(env_var)
    if not mk or not mk.strip():
        raise SecretStorageError(
            f"Missing master key. Set environment variable {env_var}."
        )
    return mk


def _kdf_scrypt(masterkey: str, salt: bytes) -> bytes:
    """Derive a 256-bit key from a master key string using scrypt."""
    return scrypt(
        masterkey.encode("utf-8"),
        salt=salt,
        n=2**14,  # CPU/memory cost
        r=8,
        p=1,
        dklen=32,
    )


def _encrypt_secret(secret: str, masterkey: str) -> dict:
    """Encrypt secret using AES-256-GCM with a per-record random salt + nonce."""
    salt = os.urandom(16)
    key = _kdf_scrypt(masterkey, salt)
    aesgcm = AESGCM(key)
    nonce = os.urandom(12)
    ct = aesgcm.encrypt(nonce, secret.encode("utf-8"), associated_data=None)

    return {
        "v": 1,
        "kdf": "scrypt",
        "cipher": "aes-256-gcm",
        "salt_b64": base64.b64encode(salt).decode("ascii"),
        "nonce_b64": base64.b64encode(nonce).decode("ascii"),
        "ct_b64": base64.b64encode(ct).decode("ascii"),
    }


def _decrypt_secret(payload: dict, masterkey: str) -> str:
    """Decrypt payload created by _encrypt_secret back into the plaintext secret."""
    try:
        salt = base64.b64decode(payload["salt_b64"])
        nonce = base64.b64decode(payload["nonce_b64"])
        ct = base64.b64decode(payload["ct_b64"])
    except Exception as e:
        raise SecretStorageError("Corrupt secret payload (base64 decode failed).") from e

    key = _kdf_scrypt(masterkey, salt)
    aesgcm = AESGCM(key)
    try:
        pt = aesgcm.decrypt(nonce, ct, associated_data=None)
        return pt.decode("utf-8")
    except Exception as e:
        raise SecretStorageError("Failed to decrypt secret. Wrong master key?") from e


def create_secret() -> str:
    """Generate a new Base32 secret suitable for TOTP."""
    return pyotp.random_base32()


def encrypt_2fa_secret_for_db(secret: str, masterkey: str) -> str:
    """Returns a single base64url-encoded JSON token containing:
    version/kdf/cipher + salt + nonce + ciphertext."""
    if not masterkey or not masterkey.strip():
        raise SecretStorageError("Missing master key.")
    if not secret:
        raise SecretStorageError("Missing 2FA secret.")

    payload = _encrypt_secret(secret, masterkey)

    raw = json.dumps(payload, separators=(",", ":")).encode("utf-8")
    token = base64.urlsafe_b64encode(raw).decode("ascii").rstrip("=")
    return token


def decrypt_2fa_secret_from_db(token: str, masterkey: str) -> str:
    """Decrypt a DB-stored token back into the original 2FA secret."""
    if not masterkey or not masterkey.strip():
        raise SecretStorageError("Missing master key.")
    if not token or not token.strip():
        raise SecretStorageError("Missing encrypted token.")

    # Restore base64 padding
    padded = token + "=" * (-len(token) % 4)

    try:
        raw = base64.urlsafe_b64decode(padded.encode("ascii"))
        payload = json.loads(raw.decode("utf-8"))
    except Exception as e:
        raise SecretStorageError("Corrupt token (base64/JSON decode failed).") from e

    # Sanity checks (helps future migrations)
    if (
        payload.get("v") != 1
        or payload.get("kdf") != "scrypt"
        or payload.get("cipher") != "aes-256-gcm"
    ):
        raise SecretStorageError("Unsupported payload format/version.")

    return _decrypt_secret(payload, masterkey)


def provisioning_uri(
    secret: str,
    app_name: str,
    account_name: str,
    interval_seconds: int = 30,
) -> str:
    """Create an otpauth provisioning URI for authenticator apps."""
    totp = pyotp.TOTP(secret, interval=interval_seconds)
    return totp.provisioning_uri(name=account_name, issuer_name=app_name)

'''
def write_qr_png(uri: str, qr_file: Path) -> None:
    """Generate a QR code PNG for the provisioning URI."""
    qr_file.parent.mkdir(parents=True, exist_ok=True)
    img = qrcode.make(uri)
    img.save(qr_file)
'''

def enroll_for_db(config: TwoFAConfig, *, masterkey: Optional[str] = None) -> tuple[str, str]:
    """Enrollment helper for DB storage.
    Creates a new secret, encrypts it into a DB token, and returns: db_token, provisioning_uri)
    """
    mk = masterkey if (masterkey and masterkey.strip()) else _require_masterkey(config.masterkey_env)

    secret = create_secret()
    token = encrypt_2fa_secret_for_db(secret, mk)
    uri = provisioning_uri(
        secret=secret,
        app_name=config.app_name,
        account_name=config.account_name,
        interval_seconds=config.interval_seconds,
    )
    return token, uri


def verify_totp_from_db_token(
    code: str,
    *,
    token: str,
    config: TwoFAConfig,
    valid_window: int = 1,
    masterkey: Optional[str] = None,
) -> bool:
    """
    Verify a 6-digit code from an authenticator using the DB token.

    valid_window allows ±N time steps for clock drift (default 1).
    """
    if not (code.isdigit() and len(code) == 6):
        return False

    mk = masterkey if (masterkey and masterkey.strip()) else _require_masterkey(config.masterkey_env)

    secret = decrypt_2fa_secret_from_db(token, mk)
    totp = pyotp.TOTP(secret, interval=config.interval_seconds)
    return bool(totp.verify(code, valid_window=valid_window))