# Created with the Assistance of Claude Code
# backend/tests/api/test_settings_service.py
"""
Tests for app.services.settings (cached system settings reader).

Covers:
- get_setting(): DB hit on cold cache, defaults fallback, stale cache kept on error
- get_int_setting(): integer parse, defaults fallback on bad value
- get_bool_setting(): true/false/1/yes parsing
- get_all_settings(): merges defaults with DB values
- invalidate_cache(): forces refresh on next read
- Cache TTL: no DB hit when cache is fresh
"""

import time
import pytest
from unittest.mock import patch, MagicMock


# ── Helpers ───────────────────────────────────────────────────────────────────

def _make_conn(rows: list):
    """Build a mock DB connection whose cursor.fetchall() returns rows."""
    cursor = MagicMock()
    cursor.fetchall.return_value = rows
    conn = MagicMock()
    conn.cursor.return_value = cursor
    return conn


def _reset_module():
    """Reset the module-level cache so each test starts cold."""
    import app.services.settings as svc
    svc._cache = {}
    svc._cache_at = 0.0


# ── get_setting ───────────────────────────────────────────────────────────────

class TestGetSetting:
    """Tests for get_setting()."""

    def test_returns_db_value_when_present(self):
        """Returns value from DB on cold cache."""
        _reset_module()
        conn = _make_conn([("registration_open", "false")])
        with patch("app.services.settings.get_db_connection", return_value=conn):
            from app.services.settings import get_setting
            result = get_setting("registration_open")
        assert result == "false"

    def test_returns_default_when_key_missing_from_db(self):
        """Returns DEFAULTS value when key not in DB."""
        _reset_module()
        conn = _make_conn([])  # empty DB
        with patch("app.services.settings.get_db_connection", return_value=conn):
            from app.services.settings import get_setting
            result = get_setting("k_anonymity_threshold")
        assert result == "1"

    def test_returns_empty_string_for_unknown_key(self):
        """Unknown key not in DB or DEFAULTS returns empty string."""
        _reset_module()
        conn = _make_conn([])
        with patch("app.services.settings.get_db_connection", return_value=conn):
            from app.services.settings import get_setting
            result = get_setting("nonexistent_key")
        assert result == ""

    def test_db_value_overrides_default(self):
        """A DB row for a key overrides its DEFAULTS entry."""
        _reset_module()
        conn = _make_conn([("max_login_attempts", "3")])
        with patch("app.services.settings.get_db_connection", return_value=conn):
            from app.services.settings import get_setting
            result = get_setting("max_login_attempts")
        assert result == "3"

    def test_no_db_hit_when_cache_fresh(self):
        """No DB call when cache is still within TTL."""
        import app.services.settings as svc
        _reset_module()
        conn = _make_conn([("registration_open", "true")])
        with patch("app.services.settings.get_db_connection", return_value=conn) as mock_db:
            svc.get_setting("registration_open")  # fills cache
            mock_db.reset_mock()
            svc.get_setting("registration_open")  # should use cache
        mock_db.assert_not_called()

    def test_stale_cache_kept_on_db_error(self):
        """When DB raises, stale cache value is preserved (no crash)."""
        import app.services.settings as svc
        _reset_module()
        # Seed cache manually
        svc._cache = {"maintenance_mode": "false"}
        svc._cache_at = 0.0  # force refresh attempt

        with patch("app.services.settings.get_db_connection", side_effect=Exception("DB down")):
            from app.services.settings import get_setting
            result = get_setting("maintenance_mode")
        assert result == "false"

    def test_default_used_when_cache_empty_and_db_errors(self):
        """Falls back to DEFAULTS when cache is empty and DB raises."""
        _reset_module()
        with patch("app.services.settings.get_db_connection", side_effect=Exception("DB down")):
            from app.services.settings import get_setting
            result = get_setting("lockout_duration_minutes")
        assert result == "30"


# ── get_int_setting ───────────────────────────────────────────────────────────

class TestGetIntSetting:
    """Tests for get_int_setting()."""

    def test_returns_integer_from_db(self):
        """Parses integer string from DB correctly."""
        _reset_module()
        conn = _make_conn([("k_anonymity_threshold", "10")])
        with patch("app.services.settings.get_db_connection", return_value=conn):
            from app.services.settings import get_int_setting
            assert get_int_setting("k_anonymity_threshold") == 10

    def test_returns_default_integer_for_known_key(self):
        """Returns integer from DEFAULTS when DB has no row."""
        _reset_module()
        conn = _make_conn([])
        with patch("app.services.settings.get_db_connection", return_value=conn):
            from app.services.settings import get_int_setting
            assert get_int_setting("max_login_attempts") == 10

    def test_returns_zero_for_unparseable_value(self):
        """Non-numeric DB value falls back to default integer, or 0."""
        _reset_module()
        conn = _make_conn([("k_anonymity_threshold", "not_a_number")])
        with patch("app.services.settings.get_db_connection", return_value=conn):
            from app.services.settings import get_int_setting
            # Default for k_anonymity_threshold is "1"
            assert get_int_setting("k_anonymity_threshold") == 1

    def test_returns_zero_for_unknown_key_with_bad_value(self):
        """Unknown key with unparseable value returns 0."""
        _reset_module()
        conn = _make_conn([("unknown_int_key", "bad")])
        with patch("app.services.settings.get_db_connection", return_value=conn):
            from app.services.settings import get_int_setting
            assert get_int_setting("unknown_int_key") == 0


# ── get_bool_setting ──────────────────────────────────────────────────────────

class TestGetBoolSetting:
    """Tests for get_bool_setting()."""

    @pytest.mark.parametrize("value,expected", [
        ("true", True),
        ("True", True),
        ("TRUE", True),
        ("1", True),
        ("yes", True),
        ("Yes", True),
        ("false", False),
        ("False", False),
        ("0", False),
        ("no", False),
        ("", False),
        ("  true  ", True),  # leading/trailing whitespace
    ])
    def test_bool_parsing(self, value, expected):
        """Various truthy/falsy string values are parsed correctly."""
        _reset_module()
        conn = _make_conn([("registration_open", value)])
        with patch("app.services.settings.get_db_connection", return_value=conn):
            from app.services.settings import get_bool_setting
            assert get_bool_setting("registration_open") == expected

    def test_default_true_value(self):
        """Default 'true' is parsed as True when DB has no row."""
        _reset_module()
        conn = _make_conn([])
        with patch("app.services.settings.get_db_connection", return_value=conn):
            from app.services.settings import get_bool_setting
            assert get_bool_setting("registration_open") is True

    def test_default_false_value(self):
        """Default 'false' is parsed as False when DB has no row."""
        _reset_module()
        conn = _make_conn([])
        with patch("app.services.settings.get_db_connection", return_value=conn):
            from app.services.settings import get_bool_setting
            assert get_bool_setting("maintenance_mode") is False


# ── invalidate_cache ──────────────────────────────────────────────────────────

class TestInvalidateCache:
    """Tests for invalidate_cache()."""

    def test_invalidate_forces_db_hit_on_next_read(self):
        """After invalidate_cache(), the next get_setting() hits DB again."""
        import app.services.settings as svc
        _reset_module()
        conn = _make_conn([("registration_open", "true")])
        with patch("app.services.settings.get_db_connection", return_value=conn) as mock_db:
            svc.get_setting("registration_open")  # fills cache
            assert mock_db.call_count == 1

            svc.invalidate_cache()
            svc.get_setting("registration_open")  # must hit DB again
            assert mock_db.call_count == 2

    def test_invalidate_sets_cache_at_to_zero(self):
        """invalidate_cache() resets _cache_at to 0."""
        import app.services.settings as svc
        svc._cache_at = time.monotonic()
        svc.invalidate_cache()
        assert svc._cache_at == 0.0


# ── get_all_settings ──────────────────────────────────────────────────────────

class TestGetAllSettings:
    """Tests for get_all_settings()."""

    def test_merges_defaults_with_db(self):
        """DB values override defaults; missing keys use defaults."""
        _reset_module()
        conn = _make_conn([("k_anonymity_threshold", "10"), ("custom_key", "custom_val")])
        with patch("app.services.settings.get_db_connection", return_value=conn):
            from app.services.settings import get_all_settings, DEFAULTS
            result = get_all_settings()

        # DB value overrides default
        assert result["k_anonymity_threshold"] == "10"
        # DB-only key present
        assert result["custom_key"] == "custom_val"
        # Unmodified defaults still present
        assert result["registration_open"] == DEFAULTS["registration_open"]
        assert result["maintenance_mode"] == DEFAULTS["maintenance_mode"]

    def test_all_defaults_present_on_empty_db(self):
        """All DEFAULTS keys appear in result when DB returns no rows."""
        _reset_module()
        conn = _make_conn([])
        with patch("app.services.settings.get_db_connection", return_value=conn):
            from app.services.settings import get_all_settings, DEFAULTS
            result = get_all_settings()

        for key, value in DEFAULTS.items():
            assert result[key] == value

    def test_does_not_mutate_defaults(self):
        """get_all_settings() does not alter the module-level DEFAULTS dict."""
        _reset_module()
        conn = _make_conn([("registration_open", "false")])
        with patch("app.services.settings.get_db_connection", return_value=conn):
            from app.services.settings import get_all_settings, DEFAULTS
            original_defaults = dict(DEFAULTS)
            get_all_settings()
            assert DEFAULTS == original_defaults
