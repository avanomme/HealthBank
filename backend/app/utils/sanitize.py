# Created with the assistance of Generative AI
"""
DATA SANITIZATION MODULE
This module provides a comprehensive sanitizer that converts arbitrary Python objects
into database-safe values. It handles:
  - Type validation and conversion
  - Unicode normalization
  - Removal of dangerous control characters
  - Safe encoding of binary data
  - Complex object serialization
  - Depth/size limiting to prevent DoS attacks
"""
from __future__ import annotations

import base64
import json
import math
import re
import unicodedata
from dataclasses import dataclass
from datetime import date, datetime, time
from decimal import Decimal, InvalidOperation
from typing import Any, Mapping, Optional

# Regex pattern to match control characters (ASCII 0-31 and 127)
# These are non-printable characters that can cause issues in databases
_CONTROL_CHARS_RE = re.compile(r"[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]")


@dataclass(frozen=True, slots=True)
class SanitizeConfig:
    """
    Configuration object for controlling sanitization behavior.
    Frozen dataclass = immutable.
    """
 
    normalize_unicode: str | None = "NFKC"
    
    remove_null_bytes: bool = True
    
    remove_control_chars: bool = True
    
    trim: bool = True
    
    # max_string_length: Truncate strings exceeding this length (prevents huge DB values)
    max_string_length: int | None = 10_000

    # bytes_mode: How to encode binary data
    #   - "base64": Encode as base64
    #   - Other modes attempt UTF-8 decoding
    bytes_mode: str = "base64"
    
    # bytes_errors: Error handling strategy for byte decoding
    bytes_errors: str = "replace"

    # allow_nan_inf: Whether to permit NaN and infinity values
    #   - False: Convert invalid floats to None
    allow_nan_inf: bool = False

    # max_depth: Maximum nesting depth for recursive structures
    #   - Prevents stack overflow on deeply nested objects
    max_depth: int = 8
    
    # max_collection_len: Maximum items to process in collections
    #   - Prevents processing huge lists/dicts that could cause performance issues
    max_collection_len: int = 2_000

    # complex_mode: How to handle dict/list/set/tuple types
    #   - "json": Convert to JSON string for DB insertion
    #   - "reject": Return None for complex types
    complex_mode: str = "json"

    # invalid_to_none: Convert unrepresentable values to None (vs. leaving unchanged)
    invalid_to_none: bool = True


def sanitizeData(value: Any, config: Optional[SanitizeConfig] = None) -> Any:
    """
    PUBLIC ENTRY POINT
    
    Converts any Python object into a database-safe value.
    
    Args:
        value: Any Python object to sanitize
        config: Optional SanitizeConfig for custom behavior (uses defaults if None)
    
    Returns:
        One of:
          - None (for invalid/unrepresentable values)
          - bool/int/float/Decimal (primitive types pass through)
          - str (dates→ISO format, bytes→base64, complex→JSON, strings→cleaned)
    """
    # Use provided config or default settings
    cfg = config or SanitizeConfig()
    # Start recursion with depth=0 and _dump_complex=True to serialize top-level objects to JSON
    return _sanitize_internal(value, cfg, _depth=0, _dump_complex=True)


def _sanitize_internal(value: Any, cfg: SanitizeConfig, *, _depth: int, _dump_complex: bool) -> Any:
    """
    INTERNAL RECURSIVE SANITIZER
    
    Args:
        value: The value to sanitize
        cfg: Configuration settings
        _depth: Current recursion depth (keyword-only, used for tracking)
        _dump_complex: If True, serialize complex types to JSON string
                      If False, return JSON-serializable Python structure (list/dict)
                      This flag prevents double-encoding when recursing
    
    Returns:
        Sanitized value ready for database storage
    """

    # Prevent stack overflow from deeply nested structures
    if _depth > cfg.max_depth:
        return None if cfg.invalid_to_none else value

    # Pass through as-is
    if value is None:
        return None

    # Pass through directly (must check bool before int since bool is subclass of int)
    if isinstance(value, bool):
        return value

    # Pass through directly
    if isinstance(value, int):
        return value

    # Check for NaN and Infinity
    if isinstance(value, float):
        # If NaN or Infinity detected and config forbids them, return None or original
        if not cfg.allow_nan_inf and (math.isnan(value) or math.isinf(value)):
            return None if cfg.invalid_to_none else value
        return value

    # Validate that it's a valid decimal number
    if isinstance(value, Decimal):
        try:
            # Test validity by adding 0 (catches InvalidOperation and overflow)
            _ = value + Decimal(0)
        except (InvalidOperation, ValueError):
            return None if cfg.invalid_to_none else value
        return value

    # Convert to ISO 8601 string format (e.g., "2025-01-27T12:30:45")
    if isinstance(value, (datetime, date, time)):
        try:
            # isoformat() produces standardized ISO string
            return value.isoformat()
        except Exception:
            return None if cfg.invalid_to_none else value

    # Encode binary data safely for database storage
    if isinstance(value, (bytes, bytearray, memoryview)):
        # Convert to bytes (memoryview and bytearray are byte-like)
        b = bytes(value)
        
        # Base64 encoding is safe for all databases and preserves exact binary data
        if cfg.bytes_mode == "base64":
            return base64.b64encode(b).decode("ascii")
        
        # Alternative: Try UTF-8 decoding
        try:
            s = b.decode("utf-8", errors=cfg.bytes_errors)
        except Exception:
            return None if cfg.invalid_to_none else value
        # Clean the resulting string for database storage
        return _db_ready_string(s, cfg)

    # Apply database-safe cleaning transformations
    if isinstance(value, str):
        return _db_ready_string(value, cfg)

    # Convert to JSON string or sanitized dict
    if isinstance(value, Mapping):
        # If config rejects complex types, return None or original
        if cfg.complex_mode == "reject":
            return None if cfg.invalid_to_none else value

        # Recursively sanitize each key-value pair
        obj: dict[str, Any] = {}
        for i, (k, v) in enumerate(value.items()):
            # Enforce max collection size limit to prevent memory issues
            if i >= cfg.max_collection_len:
                break
            
            # Keys must be strings for JSON, so convert and clean
            key = _db_ready_string(str(k), cfg)
            
            # Recursively sanitize value with _dump_complex=False to avoid double-encoding
            # (nested structures stay as Python objects, only top-level gets JSON stringified)
            obj[key] = _sanitize_internal(v, cfg, _depth=_depth + 1, _dump_complex=False)

        # Convert to JSON string if this is top-level, otherwise keep as dict
        return _to_json(obj, cfg) if _dump_complex else obj

    # Convert to JSON string or sanitized list
    if isinstance(value, (list, tuple, set, frozenset)):
        # If config rejects complex types, return None or original
        if cfg.complex_mode == "reject":
            return None if cfg.invalid_to_none else value

        # Recursively sanitize each item
        arr: list[Any] = []
        for i, item in enumerate(value):
            # Enforce max collection size limit
            if i >= cfg.max_collection_len:
                break
            
            # Recursively sanitize with _dump_complex=False to avoid double-encoding
            arr.append(_sanitize_internal(item, cfg, _depth=_depth + 1, _dump_complex=False))

        # Convert to JSON string if top-level, otherwise keep as list
        return _to_json(arr, cfg) if _dump_complex else arr

    # FALLBACK
    # For unknown types, convert to string and clean it
    # This handles custom objects, classes, etc.
    try:
        return _db_ready_string(str(value), cfg)
    except Exception:
        # If even stringification fails, give up
        return None if cfg.invalid_to_none else value


def _db_ready_string(s: str, cfg: SanitizeConfig) -> str:
    """
    HELPER: Cleans a string for safe database storage.
    
    Applies cleaning transformations in order:
    1. Unicode normalization
    2. Remove null bytes
    3. Remove control characters
    4. Trim whitespace
    5. Truncate to max length
    """
    # STEP 1: Unicode normalization
    # NFKC form: compatibility decomposition + canonical composition
    # Example: "ﬁ" (ligature fi) → "fi" (separate characters)
    if cfg.normalize_unicode:
        try:
            s = unicodedata.normalize(cfg.normalize_unicode, s)
        except Exception:
            # If normalization fails, continue with original string
            pass

    # STEP 2: Remove null bytes (\x00)
    # These can terminate strings in C-based string handling
    if cfg.remove_null_bytes:
        s = s.replace("\x00", "")

    # STEP 3: Remove control characters (ASCII 0-31 and 127)
    # Non-printable characters that cause database issues
    if cfg.remove_control_chars:
        s = _CONTROL_CHARS_RE.sub("", s)

    # STEP 4: Strip leading/trailing whitespace
    if cfg.trim:
        s = s.strip()

    # STEP 5: Enforce maximum string length
    # Prevents storing huge strings in database
    if cfg.max_string_length is not None and len(s) > cfg.max_string_length:
        s = s[: cfg.max_string_length]

    return s


def _to_json(obj: Any, cfg: SanitizeConfig) -> str:
    """
    HELPER: Serializes an object to JSON string for database storage.
    
    Args:
        obj: Python object (dict or list) to serialize
        cfg: Configuration settings
    
    Returns:
        Compact JSON string (non-ASCII characters preserved, minimal whitespace)
        or None on serialization failure
    """
    try:
        # json.dumps options:
        # - ensure_ascii=False: Keep Unicode characters (more readable, smaller size)
        # - separators=(",", ":"): Compact format without spaces (smallest JSON size)
        return json.dumps(obj, ensure_ascii=False, separators=(",", ":"))
    except Exception:
        # If JSON serialization fails, either return None or fallback to str()
        return None if cfg.invalid_to_none else str(obj)
