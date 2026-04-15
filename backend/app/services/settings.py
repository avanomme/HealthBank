# Created with the Assistance of Claude Code
# backend/app/services/settings.py
"""
Cached system settings reader.

Settings are stored in the SystemSettings table and cached in memory for
_CACHE_TTL seconds (30s) to avoid a DB hit on every request.

Call invalidate_cache() after any PUT to /admin/settings so the new
values are picked up on the next read (within one cache cycle).
"""
from __future__ import annotations

import time
from typing import Optional

from ..utils.utils import get_db_connection

# ── Defaults (used if DB row is missing or DB is unavailable) ─────────────────
DEFAULTS: dict[str, str] = {
    "k_anonymity_threshold":    "1",
    "registration_open":        "true",
    "maintenance_mode":         "false",
    "maintenance_message":      "",
    "maintenance_completion":   "",
    "max_login_attempts":       "10",
    "lockout_duration_minutes": "30",
    "consent_required":         "true",
}

_cache: dict[str, str] = {}
_cache_at: float = 0.0
_CACHE_TTL: float = 30.0  # seconds


def _refresh() -> None:
    global _cache, _cache_at
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        try:
            cur.execute("SELECT SettingKey, SettingValue FROM SystemSettings")
            rows = cur.fetchall()
            _cache = {row[0]: row[1] for row in rows}
            _cache_at = time.monotonic()
        finally:
            cur.close()
            conn.close()
    except Exception:
        # Keep stale cache / defaults — never crash the app over a settings read
        _cache_at = time.monotonic()


def _ensure_fresh() -> None:
    if time.monotonic() - _cache_at > _CACHE_TTL:
        _refresh()


def get_setting(key: str) -> str:
    _ensure_fresh()
    return _cache.get(key, DEFAULTS.get(key, ""))


def get_int_setting(key: str) -> int:
    try:
        return int(get_setting(key))
    except (ValueError, TypeError):
        try:
            return int(DEFAULTS.get(key, "0"))
        except (ValueError, TypeError):
            return 0


def get_bool_setting(key: str) -> bool:
    return get_setting(key).strip().lower() in ("true", "1", "yes")


def invalidate_cache() -> None:
    """Force a cache refresh on the next read (call after saving settings)."""
    global _cache_at
    _cache_at = 0.0


def get_all_settings() -> dict[str, str]:
    """Return all settings as a key→value dict (refreshes cache if stale)."""
    _ensure_fresh()
    result = dict(DEFAULTS)
    result.update(_cache)
    return result
