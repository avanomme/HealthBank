# Created with the assistance of Generative AI
import base64
import json
import pytest
import pyotp

import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent.parent.parent / "backend"))
from app.core import totp as m


MASTERKEY = "correct horse battery staple"
WRONG_MASTERKEY = "hunter2"


def _decode_token_to_payload(token: str) -> dict:
    """Helper: decode the base64url JSON token back into a dict."""
    padded = token + "=" * (-len(token) % 4)
    raw = base64.urlsafe_b64decode(padded.encode("ascii"))
    return json.loads(raw.decode("utf-8"))


def test_encrypt_decrypt_roundtrip():
    secret = m.create_secret()
    token = m.encrypt_2fa_secret_for_db(secret, MASTERKEY)
    recovered = m.decrypt_2fa_secret_from_db(token, MASTERKEY)
    assert recovered == secret


def test_token_is_base64url_no_padding():
    secret = m.create_secret()
    token = m.encrypt_2fa_secret_for_db(secret, MASTERKEY)

    # No '=' padding
    assert "=" not in token

    # URL-safe alphabet only
    allowed = set("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_")
    assert set(token) <= allowed


def test_wrong_masterkey_fails():
    secret = m.create_secret()
    token = m.encrypt_2fa_secret_for_db(secret, MASTERKEY)
    with pytest.raises(m.SecretStorageError, match="Failed to decrypt secret"):
        m.decrypt_2fa_secret_from_db(token, WRONG_MASTERKEY)


def test_corrupt_token_base64_or_json_fails():
    with pytest.raises(m.SecretStorageError, match="Corrupt token"):
        m.decrypt_2fa_secret_from_db("not-base64!!!!", MASTERKEY)

    # valid base64url, invalid JSON
    bad_json = base64.urlsafe_b64encode(b"not json").decode("ascii").rstrip("=")
    with pytest.raises(m.SecretStorageError, match="Corrupt token"):
        m.decrypt_2fa_secret_from_db(bad_json, MASTERKEY)


def test_payload_format_version_checks():
    secret = m.create_secret()
    token = m.encrypt_2fa_secret_for_db(secret, MASTERKEY)
    payload = _decode_token_to_payload(token)

    payload["v"] = 999  # unsupported
    raw = json.dumps(payload, separators=(",", ":")).encode("utf-8")
    bad_token = base64.urlsafe_b64encode(raw).decode("ascii").rstrip("=")

    with pytest.raises(m.SecretStorageError, match="Unsupported payload format/version"):
        m.decrypt_2fa_secret_from_db(bad_token, MASTERKEY)


def test_enroll_for_db_returns_token_and_uri():
    config = m.TwoFAConfig(app_name="TestApp", account_name="zak@example.com", interval_seconds=30)
    token, uri = m.enroll_for_db(config, masterkey=MASTERKEY)

    assert isinstance(token, str) and token.strip()
    assert isinstance(uri, str) and uri.startswith("otpauth://totp/")

    # token should decrypt
    secret = m.decrypt_2fa_secret_from_db(token, MASTERKEY)
    assert isinstance(secret, str) and secret.strip()


def test_verify_totp_success_and_failure():
    config = m.TwoFAConfig(app_name="TestApp", account_name="zak@example.com", interval_seconds=30)

    # enroll
    token, _ = m.enroll_for_db(config, masterkey=MASTERKEY)
    secret = m.decrypt_2fa_secret_from_db(token, MASTERKEY)

    # Generate a valid code at a fixed unix time (deterministic)
    t = 1_700_000_000
    totp = pyotp.TOTP(secret, interval=config.interval_seconds)
    code = totp.at(t)

    # Your verify function doesn't accept for_time, so we verify "now".
    # To keep this deterministic without changing your code, we instead
    # generate a code for the current time and test that.
    now_code = totp.now()
    assert m.verify_totp_from_db_token(
        now_code, token=token, config=config, masterkey=MASTERKEY, valid_window=1
    ) is True

    # Wrong code should fail
    wrong_code = "000000" if now_code != "000000" else "111111"
    assert m.verify_totp_from_db_token(
        wrong_code, token=token, config=config, masterkey=MASTERKEY, valid_window=1
    ) is False


@pytest.mark.parametrize("bad_code", ["", "123", "1234567", "12a456", "abcdef", " 123456"])
def test_verify_totp_rejects_bad_code_format(bad_code):
    config = m.TwoFAConfig(app_name="TestApp", account_name="zak@example.com", interval_seconds=30)
    token, _ = m.enroll_for_db(config, masterkey=MASTERKEY)

    assert m.verify_totp_from_db_token(
        bad_code, token=token, config=config, masterkey=MASTERKEY
    ) is False


def test_missing_masterkey_errors():
    secret = m.create_secret()

    with pytest.raises(m.SecretStorageError, match="Missing master key"):
        m.encrypt_2fa_secret_for_db(secret, masterkey="")

    token = m.encrypt_2fa_secret_for_db(secret, MASTERKEY)
    with pytest.raises(m.SecretStorageError, match="Missing master key"):
        m.decrypt_2fa_secret_from_db(token, masterkey="")

    # verify_totp_from_db_token uses env var when masterkey not provided;
    # to avoid depending on env, we just ensure it errors if env var is missing.
    config = m.TwoFAConfig(app_name="TestApp", account_name="zak@example.com", masterkey_env="DOES_NOT_EXIST")
    with pytest.raises(m.SecretStorageError, match="Missing master key"):
        m.verify_totp_from_db_token("123456", token=token, config=config)