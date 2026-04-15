"""Tests for app.utils.sanitize — covers missing lines for full coverage."""

import base64
import json
import math
from datetime import date, datetime, time
from decimal import Decimal, InvalidOperation
from unittest.mock import patch, MagicMock

import pytest

from app.utils.sanitize import SanitizeConfig, sanitizeData


# ---------------------------------------------------------------------------
# None passthrough (line 121)
# ---------------------------------------------------------------------------

def test_none_returns_none():
    assert sanitizeData(None) is None


# ---------------------------------------------------------------------------
# Bool passthrough (line 125)
# ---------------------------------------------------------------------------

def test_bool_true():
    assert sanitizeData(True) is True


def test_bool_false():
    assert sanitizeData(False) is False


# ---------------------------------------------------------------------------
# Int passthrough (line 129)
# ---------------------------------------------------------------------------

def test_int_passthrough():
    assert sanitizeData(42) == 42
    assert sanitizeData(-1) == -1
    assert sanitizeData(0) == 0


# ---------------------------------------------------------------------------
# Float — NaN / Inf handling (lines 134-136)
# ---------------------------------------------------------------------------

def test_float_normal():
    assert sanitizeData(3.14) == 3.14


def test_float_nan_returns_none():
    assert sanitizeData(float("nan")) is None


def test_float_inf_returns_none():
    assert sanitizeData(float("inf")) is None
    assert sanitizeData(float("-inf")) is None


def test_float_nan_allowed():
    cfg = SanitizeConfig(allow_nan_inf=True)
    result = sanitizeData(float("nan"), cfg)
    assert math.isnan(result)


def test_float_inf_allowed():
    cfg = SanitizeConfig(allow_nan_inf=True)
    assert sanitizeData(float("inf"), cfg) == float("inf")


def test_float_nan_invalid_to_none_false():
    cfg = SanitizeConfig(allow_nan_inf=False, invalid_to_none=False)
    result = sanitizeData(float("nan"), cfg)
    assert math.isnan(result)


# ---------------------------------------------------------------------------
# Decimal (lines 140-145)
# ---------------------------------------------------------------------------

def test_decimal_valid():
    assert sanitizeData(Decimal("10.5")) == Decimal("10.5")


def test_decimal_invalid_returns_none():
    # sNaN triggers InvalidOperation on arithmetic
    val = Decimal("sNaN")
    assert sanitizeData(val) is None


def test_decimal_invalid_to_none_false():
    cfg = SanitizeConfig(invalid_to_none=False)
    val = Decimal("sNaN")
    result = sanitizeData(val, cfg)
    assert isinstance(result, Decimal)


# ---------------------------------------------------------------------------
# datetime / date / time (lines 149-153)
# ---------------------------------------------------------------------------

def test_datetime_iso():
    dt = datetime(2025, 1, 27, 12, 30, 45)
    assert sanitizeData(dt) == "2025-01-27T12:30:45"


def test_date_iso():
    d = date(2025, 1, 27)
    assert sanitizeData(d) == "2025-01-27"


def test_time_iso():
    t = time(12, 30, 45)
    assert sanitizeData(t) == "12:30:45"


# ---------------------------------------------------------------------------
# bytes / bytearray / memoryview (lines 158-170)
# ---------------------------------------------------------------------------

def test_bytes_base64():
    raw = b"\x00\x01\x02\xff"
    result = sanitizeData(raw)
    assert result == base64.b64encode(raw).decode("ascii")


def test_bytearray_base64():
    raw = bytearray(b"hello")
    result = sanitizeData(raw)
    assert result == base64.b64encode(b"hello").decode("ascii")


def test_memoryview_base64():
    raw = memoryview(b"data")
    result = sanitizeData(raw)
    assert result == base64.b64encode(b"data").decode("ascii")


def test_bytes_utf8_mode():
    cfg = SanitizeConfig(bytes_mode="utf8")
    result = sanitizeData(b"hello world", cfg)
    assert result == "hello world"


def test_bytes_utf8_mode_with_replace():
    cfg = SanitizeConfig(bytes_mode="utf8", bytes_errors="replace")
    result = sanitizeData(b"\xff\xfe", cfg)
    # Should contain replacement characters
    assert isinstance(result, str)


# ---------------------------------------------------------------------------
# String cleaning helpers
# ---------------------------------------------------------------------------

def test_unicode_normalization():
    # NFKC normalizes compatibility characters, e.g. fullwidth A → A
    cfg = SanitizeConfig()
    result = sanitizeData("\uff21")  # fullwidth 'A'
    assert result == "A"


def test_null_byte_removal():
    result = sanitizeData("hel\x00lo")
    assert result == "hello"


def test_control_char_removal():
    result = sanitizeData("he\x07llo")
    assert result == "hello"


def test_string_truncation():
    cfg = SanitizeConfig(max_string_length=5)
    result = sanitizeData("abcdefghij", cfg)
    assert result == "abcde"


def test_string_no_truncation_when_none():
    cfg = SanitizeConfig(max_string_length=None)
    long_str = "a" * 20_000
    result = sanitizeData(long_str, cfg)
    assert len(result) == 20_000


def test_trim_whitespace():
    result = sanitizeData("  hello  ")
    assert result == "hello"


# ---------------------------------------------------------------------------
# Complex types — JSON mode (lines 177-216)
# ---------------------------------------------------------------------------

def test_dict_json_mode():
    result = sanitizeData({"a": 1, "b": "hi"})
    parsed = json.loads(result)
    assert parsed == {"a": 1, "b": "hi"}


def test_list_json_mode():
    result = sanitizeData([1, 2, 3])
    parsed = json.loads(result)
    assert parsed == [1, 2, 3]


def test_tuple_json_mode():
    result = sanitizeData((1, "x"))
    parsed = json.loads(result)
    assert parsed == [1, "x"]


def test_set_json_mode():
    result = sanitizeData({42})
    parsed = json.loads(result)
    assert parsed == [42]


def test_nested_dict():
    result = sanitizeData({"a": {"b": [1, 2]}})
    parsed = json.loads(result)
    assert parsed == {"a": {"b": [1, 2]}}


# ---------------------------------------------------------------------------
# Complex types — reject mode (lines 179-180, 202-203)
# ---------------------------------------------------------------------------

def test_dict_reject_mode():
    cfg = SanitizeConfig(complex_mode="reject")
    assert sanitizeData({"a": 1}, cfg) is None


def test_list_reject_mode():
    cfg = SanitizeConfig(complex_mode="reject")
    assert sanitizeData([1, 2], cfg) is None


def test_dict_reject_invalid_to_none_false():
    cfg = SanitizeConfig(complex_mode="reject", invalid_to_none=False)
    val = {"a": 1}
    assert sanitizeData(val, cfg) == val


def test_list_reject_invalid_to_none_false():
    cfg = SanitizeConfig(complex_mode="reject", invalid_to_none=False)
    val = [1, 2]
    assert sanitizeData(val, cfg) == val


# ---------------------------------------------------------------------------
# Depth limiting (lines 116-117)
# ---------------------------------------------------------------------------

def test_depth_limit_returns_none():
    cfg = SanitizeConfig(max_depth=1)
    # Depth 0 → dict, depth 1 → inner dict, depth 2 → exceeds limit
    deep = {"a": {"b": {"c": 1}}}
    result = sanitizeData(deep, cfg)
    parsed = json.loads(result)
    # The innermost {"c": 1} should hit depth > max_depth and become None
    assert parsed["a"]["b"] is None


def test_depth_limit_invalid_to_none_false():
    cfg = SanitizeConfig(max_depth=0, invalid_to_none=False)
    # At depth 0 with max_depth=0, the first recursion enters at _depth=0
    # which is NOT > 0, so it proceeds. Inner items at _depth=1 > 0 → returns value as-is.
    deep = {"a": 1}
    result = sanitizeData(deep, cfg)
    parsed = json.loads(result)
    assert parsed == {"a": 1}


# ---------------------------------------------------------------------------
# Collection length limiting (lines 186-187, 209-210)
# ---------------------------------------------------------------------------

def test_dict_collection_len_limit():
    cfg = SanitizeConfig(max_collection_len=2)
    data = {"a": 1, "b": 2, "c": 3, "d": 4}
    result = sanitizeData(data, cfg)
    parsed = json.loads(result)
    assert len(parsed) == 2


def test_list_collection_len_limit():
    cfg = SanitizeConfig(max_collection_len=3)
    data = [1, 2, 3, 4, 5]
    result = sanitizeData(data, cfg)
    parsed = json.loads(result)
    assert len(parsed) == 3


# ---------------------------------------------------------------------------
# Unknown object fallback (lines 221-225)
# ---------------------------------------------------------------------------

def test_unknown_object_converted_to_str():
    class Foo:
        def __str__(self):
            return "I am Foo"

    result = sanitizeData(Foo())
    assert result == "I am Foo"


def test_unknown_object_str_fails():
    class Bad:
        def __str__(self):
            raise RuntimeError("cannot stringify")

    cfg = SanitizeConfig(invalid_to_none=True)
    result = sanitizeData(Bad(), cfg)
    assert result is None


def test_unknown_object_str_fails_invalid_to_none_false():
    class Bad:
        def __str__(self):
            raise RuntimeError("cannot stringify")

    cfg = SanitizeConfig(invalid_to_none=False)
    result = sanitizeData(Bad(), cfg)
    assert isinstance(result, Bad)


# ---------------------------------------------------------------------------
# _to_json failure path (lines 283-290)
# ---------------------------------------------------------------------------

def test_to_json_failure_returns_none():
    """Force json.dumps to fail by including a non-serializable value
    that survives sanitization (via invalid_to_none=False)."""
    class Unserializable:
        def __str__(self):
            raise TypeError("nope")

    cfg = SanitizeConfig(invalid_to_none=False)
    # The inner value will fail str() conversion and be returned as-is (invalid_to_none=False).
    # Then json.dumps will fail on it, triggering the except branch in _to_json.
    result = sanitizeData([Unserializable()], cfg)
    # _to_json with invalid_to_none=False falls back to str(obj)
    assert isinstance(result, str)


# ---------------------------------------------------------------------------
# Unicode normalization exception path (lines 245-247)
# ---------------------------------------------------------------------------

def test_unicode_normalization_bad_form():
    """Invalid normalization form should not crash — passes through original."""
    cfg = SanitizeConfig(normalize_unicode="INVALID_FORM")
    result = sanitizeData("hello", cfg)
    assert result == "hello"


# ---------------------------------------------------------------------------
# Edge cases
# ---------------------------------------------------------------------------

def test_empty_string():
    assert sanitizeData("") == ""


def test_empty_dict():
    result = sanitizeData({})
    assert result == "{}"


def test_empty_list():
    result = sanitizeData([])
    assert result == "[]"


def test_frozenset():
    result = sanitizeData(frozenset([1]))
    parsed = json.loads(result)
    assert parsed == [1]


# ---------------------------------------------------------------------------
# datetime isoformat failure (lines 152-153)
# ---------------------------------------------------------------------------

def test_datetime_isoformat_failure():
    """Trigger the except branch when isoformat() raises."""
    bad_dt = MagicMock(spec=datetime)
    bad_dt.isoformat.side_effect = ValueError("broken")
    # isinstance check with spec=datetime will match
    result = sanitizeData(bad_dt)
    assert result is None


def test_datetime_isoformat_failure_invalid_to_none_false():
    bad_dt = MagicMock(spec=datetime)
    bad_dt.isoformat.side_effect = ValueError("broken")
    cfg = SanitizeConfig(invalid_to_none=False)
    result = sanitizeData(bad_dt, cfg)
    assert result is bad_dt


# ---------------------------------------------------------------------------
# bytes decode failure (lines 167-168)
# ---------------------------------------------------------------------------

def test_bytes_decode_failure():
    """Use an invalid bytes_errors value to trigger decode exception."""
    cfg = SanitizeConfig(bytes_mode="utf8", bytes_errors="INVALID_ERROR_HANDLER")
    result = sanitizeData(b"\xff\xfe", cfg)
    # Invalid error handler causes LookupError, hitting the except branch
    assert result is None


def test_bytes_decode_failure_invalid_to_none_false():
    cfg = SanitizeConfig(bytes_mode="utf8", bytes_errors="INVALID_ERROR_HANDLER",
                         invalid_to_none=False)
    result = sanitizeData(b"\xff\xfe", cfg)
    assert result == b"\xff\xfe"
