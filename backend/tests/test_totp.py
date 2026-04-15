"""Tests for app.core.totp — encryption, decryption, key derivation, enrollment, verification."""

import base64
import json
from unittest.mock import patch

import pytest
import pyotp

from app.core.totp import (
    SecretStorageError,
    TwoFAConfig,
    _require_masterkey,
    _kdf_scrypt,
    _encrypt_secret,
    _decrypt_secret,
    create_secret,
    encrypt_2fa_secret_for_db,
    decrypt_2fa_secret_from_db,
    provisioning_uri,
    enroll_for_db,
    verify_totp_from_db_token,
)

MASTER_KEY = "test-master-key-for-unit-tests"


# ── _require_masterkey ──────────────────────────────────────────────────────

class TestRequireMasterkey:
    def test_returns_key_when_set(self, monkeypatch):
        monkeypatch.setenv("TOTP_MASTERKEY", "s3cret")
        assert _require_masterkey("TOTP_MASTERKEY") == "s3cret"

    def test_raises_when_missing(self, monkeypatch):
        monkeypatch.delenv("TOTP_MASTERKEY", raising=False)
        with pytest.raises(SecretStorageError, match="Missing master key"):
            _require_masterkey("TOTP_MASTERKEY")

    def test_raises_when_empty(self, monkeypatch):
        monkeypatch.setenv("TOTP_MASTERKEY", "")
        with pytest.raises(SecretStorageError, match="Missing master key"):
            _require_masterkey("TOTP_MASTERKEY")

    def test_raises_when_whitespace_only(self, monkeypatch):
        monkeypatch.setenv("TOTP_MASTERKEY", "   ")
        with pytest.raises(SecretStorageError, match="Missing master key"):
            _require_masterkey("TOTP_MASTERKEY")


# ── _kdf_scrypt ─────────────────────────────────────────────────────────────

class TestKdfScrypt:
    def test_returns_32_bytes(self):
        key = _kdf_scrypt("password", salt=b"0123456789abcdef")
        assert isinstance(key, bytes)
        assert len(key) == 32

    def test_deterministic(self):
        salt = b"fixed-salt-value"
        k1 = _kdf_scrypt("password", salt=salt)
        k2 = _kdf_scrypt("password", salt=salt)
        assert k1 == k2

    def test_different_salt_gives_different_key(self):
        k1 = _kdf_scrypt("password", salt=b"salt_aaaaaaaaaaaa")
        k2 = _kdf_scrypt("password", salt=b"salt_bbbbbbbbbbbb")
        assert k1 != k2

    def test_different_password_gives_different_key(self):
        salt = b"0123456789abcdef"
        k1 = _kdf_scrypt("alpha", salt=salt)
        k2 = _kdf_scrypt("bravo", salt=salt)
        assert k1 != k2


# ── _encrypt_secret / _decrypt_secret ───────────────────────────────────────

class TestEncryptDecryptSecret:
    def test_round_trip(self):
        plaintext = "JBSWY3DPEHPK3PXP"
        payload = _encrypt_secret(plaintext, MASTER_KEY)
        recovered = _decrypt_secret(payload, MASTER_KEY)
        assert recovered == plaintext

    def test_payload_structure(self):
        payload = _encrypt_secret("secret", MASTER_KEY)
        assert payload["v"] == 1
        assert payload["kdf"] == "scrypt"
        assert payload["cipher"] == "aes-256-gcm"
        assert "salt_b64" in payload
        assert "nonce_b64" in payload
        assert "ct_b64" in payload

    def test_decrypt_wrong_key_raises(self):
        payload = _encrypt_secret("secret", MASTER_KEY)
        with pytest.raises(SecretStorageError, match="Failed to decrypt"):
            _decrypt_secret(payload, "wrong-key")

    def test_decrypt_corrupt_b64_raises(self):
        # Missing required keys triggers a KeyError caught by the except block
        payload = {"bad_key": "value"}
        with pytest.raises(SecretStorageError, match="Corrupt secret payload"):
            _decrypt_secret(payload, MASTER_KEY)


# ── create_secret ───────────────────────────────────────────────────────────

class TestCreateSecret:
    def test_returns_base32_string(self):
        secret = create_secret()
        assert isinstance(secret, str)
        # valid base32 should decode without error
        base64.b32decode(secret)

    def test_unique_each_call(self):
        s1 = create_secret()
        s2 = create_secret()
        assert s1 != s2


# ── encrypt_2fa_secret_for_db / decrypt_2fa_secret_from_db ──────────────────

class TestDbTokenRoundTrip:
    def test_round_trip(self):
        secret = "JBSWY3DPEHPK3PXP"
        token = encrypt_2fa_secret_for_db(secret, MASTER_KEY)
        recovered = decrypt_2fa_secret_from_db(token, MASTER_KEY)
        assert recovered == secret

    def test_token_is_url_safe_base64(self):
        token = encrypt_2fa_secret_for_db("secret", MASTER_KEY)
        assert isinstance(token, str)
        # Should not contain padding '='
        assert "=" not in token
        # Should only have URL-safe chars
        allowed = set("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_")
        assert set(token).issubset(allowed)

    def test_encrypt_empty_masterkey_raises(self):
        with pytest.raises(SecretStorageError, match="Missing master key"):
            encrypt_2fa_secret_for_db("secret", "")

    def test_encrypt_whitespace_masterkey_raises(self):
        with pytest.raises(SecretStorageError, match="Missing master key"):
            encrypt_2fa_secret_for_db("secret", "   ")

    def test_encrypt_empty_secret_raises(self):
        with pytest.raises(SecretStorageError, match="Missing 2FA secret"):
            encrypt_2fa_secret_for_db("", MASTER_KEY)

    def test_decrypt_empty_masterkey_raises(self):
        with pytest.raises(SecretStorageError, match="Missing master key"):
            decrypt_2fa_secret_from_db("token", "")

    def test_decrypt_empty_token_raises(self):
        with pytest.raises(SecretStorageError, match="Missing encrypted token"):
            decrypt_2fa_secret_from_db("", MASTER_KEY)

    def test_decrypt_whitespace_token_raises(self):
        with pytest.raises(SecretStorageError, match="Missing encrypted token"):
            decrypt_2fa_secret_from_db("   ", MASTER_KEY)

    def test_decrypt_corrupt_token_raises(self):
        with pytest.raises(SecretStorageError, match="Corrupt token"):
            decrypt_2fa_secret_from_db("not-valid-json!!!", MASTER_KEY)

    def test_decrypt_wrong_version_raises(self):
        payload = {
            "v": 99,
            "kdf": "scrypt",
            "cipher": "aes-256-gcm",
            "salt_b64": base64.b64encode(b"a" * 16).decode(),
            "nonce_b64": base64.b64encode(b"b" * 12).decode(),
            "ct_b64": base64.b64encode(b"c" * 32).decode(),
        }
        raw = json.dumps(payload).encode()
        token = base64.urlsafe_b64encode(raw).decode().rstrip("=")
        with pytest.raises(SecretStorageError, match="Unsupported payload format"):
            decrypt_2fa_secret_from_db(token, MASTER_KEY)

    def test_decrypt_wrong_kdf_raises(self):
        payload = {
            "v": 1,
            "kdf": "argon2",
            "cipher": "aes-256-gcm",
            "salt_b64": base64.b64encode(b"a" * 16).decode(),
            "nonce_b64": base64.b64encode(b"b" * 12).decode(),
            "ct_b64": base64.b64encode(b"c" * 32).decode(),
        }
        raw = json.dumps(payload).encode()
        token = base64.urlsafe_b64encode(raw).decode().rstrip("=")
        with pytest.raises(SecretStorageError, match="Unsupported payload format"):
            decrypt_2fa_secret_from_db(token, MASTER_KEY)

    def test_decrypt_wrong_cipher_raises(self):
        payload = {
            "v": 1,
            "kdf": "scrypt",
            "cipher": "chacha20",
            "salt_b64": base64.b64encode(b"a" * 16).decode(),
            "nonce_b64": base64.b64encode(b"b" * 12).decode(),
            "ct_b64": base64.b64encode(b"c" * 32).decode(),
        }
        raw = json.dumps(payload).encode()
        token = base64.urlsafe_b64encode(raw).decode().rstrip("=")
        with pytest.raises(SecretStorageError, match="Unsupported payload format"):
            decrypt_2fa_secret_from_db(token, MASTER_KEY)


# ── provisioning_uri ────────────────────────────────────────────────────────

class TestProvisioningUri:
    def test_returns_otpauth_uri(self):
        secret = pyotp.random_base32()
        uri = provisioning_uri(secret, "HealthBank", "user@example.com")
        assert uri.startswith("otpauth://totp/")
        assert "HealthBank" in uri
        assert "user%40example.com" in uri or "user@example.com" in uri

    def test_custom_interval(self):
        secret = pyotp.random_base32()
        uri = provisioning_uri(secret, "App", "user", interval_seconds=60)
        assert "period=60" in uri


# ── enroll_for_db ───────────────────────────────────────────────────────────

class TestEnrollForDb:
    def test_returns_token_and_uri(self):
        cfg = TwoFAConfig(app_name="HealthBank", account_name="test@hb.com")
        token, uri = enroll_for_db(cfg, masterkey=MASTER_KEY)
        assert isinstance(token, str) and len(token) > 0
        assert uri.startswith("otpauth://totp/")

    def test_token_decryptable(self):
        cfg = TwoFAConfig(app_name="HealthBank", account_name="test@hb.com")
        token, _ = enroll_for_db(cfg, masterkey=MASTER_KEY)
        secret = decrypt_2fa_secret_from_db(token, MASTER_KEY)
        assert len(secret) > 0

    def test_uses_env_when_no_masterkey(self, monkeypatch):
        monkeypatch.setenv("TOTP_MASTERKEY", MASTER_KEY)
        cfg = TwoFAConfig(app_name="HealthBank", account_name="test@hb.com")
        token, uri = enroll_for_db(cfg)
        assert isinstance(token, str) and len(token) > 0

    def test_raises_when_no_masterkey_anywhere(self, monkeypatch):
        monkeypatch.delenv("TOTP_MASTERKEY", raising=False)
        cfg = TwoFAConfig(app_name="HealthBank", account_name="test@hb.com")
        with pytest.raises(SecretStorageError, match="Missing master key"):
            enroll_for_db(cfg)


# ── verify_totp_from_db_token ───────────────────────────────────────────────

class TestVerifyTotpFromDbToken:
    @pytest.fixture()
    def enrolled(self):
        cfg = TwoFAConfig(app_name="HealthBank", account_name="test@hb.com")
        token, _ = enroll_for_db(cfg, masterkey=MASTER_KEY)
        secret = decrypt_2fa_secret_from_db(token, MASTER_KEY)
        return token, secret, cfg

    def test_valid_code_passes(self, enrolled):
        token, secret, cfg = enrolled
        totp = pyotp.TOTP(secret, interval=cfg.interval_seconds)
        code = totp.now()
        assert verify_totp_from_db_token(code, token=token, config=cfg, masterkey=MASTER_KEY) is True

    def test_wrong_code_fails(self, enrolled):
        token, _, cfg = enrolled
        assert verify_totp_from_db_token("000000", token=token, config=cfg, masterkey=MASTER_KEY) is False

    def test_non_digit_code_fails(self, enrolled):
        token, _, cfg = enrolled
        assert verify_totp_from_db_token("abcdef", token=token, config=cfg, masterkey=MASTER_KEY) is False

    def test_short_code_fails(self, enrolled):
        token, _, cfg = enrolled
        assert verify_totp_from_db_token("123", token=token, config=cfg, masterkey=MASTER_KEY) is False

    def test_long_code_fails(self, enrolled):
        token, _, cfg = enrolled
        assert verify_totp_from_db_token("1234567", token=token, config=cfg, masterkey=MASTER_KEY) is False

    def test_uses_env_masterkey(self, monkeypatch, enrolled):
        token, secret, cfg = enrolled
        monkeypatch.setenv("TOTP_MASTERKEY", MASTER_KEY)
        totp = pyotp.TOTP(secret, interval=cfg.interval_seconds)
        code = totp.now()
        assert verify_totp_from_db_token(code, token=token, config=cfg) is True
