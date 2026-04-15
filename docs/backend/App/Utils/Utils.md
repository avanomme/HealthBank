# Data Sanitization Module (Python)

## Overview

This module provides a configurable sanitizer that converts arbitrary Python objects into **database-safe values**. It is designed to:

- Normalize and clean strings for safer storage
- Convert common Python types into primitives suitable for DB insertion
- Encode binary data safely
- Serialize complex/nested structures deterministically to JSON (optional)
- Enforce depth and collection-size limits to reduce DoS risk from pathological inputs

The public entry point is `sanitizeData(value, config=None)`.

---

## Architecture / Design

### High-level flow

1. `sanitizeData(...)` creates or uses a `SanitizeConfig`.
2. `_sanitize_internal(...)` recursively converts values into DB-safe primitives:
   - `None`, `bool`, `int`, valid `float`, valid `Decimal` pass through (with rules)
   - `datetime/date/time` become ISO-8601 strings
   - `bytes/bytearray/memoryview` become base64 (default) or UTF-8-decoded strings
   - `str` is normalized/cleaned
   - `Mapping` and sequence types are sanitized recursively
3. Complex types are optionally JSON-serialized at the **top-level only** by default (via `_dump_complex`), preventing accidental double-encoding.

### Key design points

- **Depth limiting:** recursion stops once `_depth > cfg.max_depth`.
- **Collection limiting:** `Mapping` and iterables stop after `cfg.max_collection_len` elements.
- **String hardening:** `_db_ready_string(...)` enforces:
  - Unicode normalization
  - removal of null bytes and control characters
  - trimming
  - length limit
- **Complex object handling:** controlled by `cfg.complex_mode`:
  - `"json"`: serialize dict/list-like inputs (top-level by default)
  - `"reject"`: treat complex types as invalid (return `None` if `invalid_to_none=True`)

---

## Configuration

Configuration is provided through the immutable dataclass:

### `SanitizeConfig`

| Field | Type | Default | Meaning |
|------|------|---------|---------|
| `normalize_unicode` | `str \| None` | `"NFKC"` | Unicode normalization form; `None` disables normalization. |
| `remove_null_bytes` | `bool` | `True` | Removes `\x00` from strings. |
| `remove_control_chars` | `bool` | `True` | Removes ASCII control chars (0–31, 127) except `\t`, `\n`, `\r`. |
| `trim` | `bool` | `True` | Strips leading/trailing whitespace. |
| `max_string_length` | `int \| None` | `10_000` | Truncates strings longer than this; `None` disables truncation. |
| `bytes_mode` | `str` | `"base64"` | `"base64"` encodes binary to base64; any other value triggers UTF-8 decoding attempt. |
| `bytes_errors` | `str` | `"replace"` | Error strategy for UTF-8 decoding (`"replace"`, `"ignore"`, `"strict"`, etc.). |
| `allow_nan_inf` | `bool` | `False` | If `False`, converts `NaN` / `±Infinity` floats to `None` (depending on `invalid_to_none`). |
| `max_depth` | `int` | `8` | Maximum recursion depth before treating values as invalid. |
| `max_collection_len` | `int` | `2_000` | Maximum items processed from any collection/map. |
| `complex_mode` | `str` | `"json"` | `"json"` to serialize, `"reject"` to discard complex values. |
| `invalid_to_none` | `bool` | `True` | If `True`, invalid/unrepresentable values become `None`; otherwise original values may be returned. |

---

## API Reference

### `sanitizeData(value: Any, config: Optional[SanitizeConfig] = None) -> Any`

Public entry point that sanitizes any Python value.

**Parameters**
- `value: Any`  
  Arbitrary Python object to sanitize.
- `config: Optional[SanitizeConfig]`  
  If `None`, defaults are used.

**Returns**
One of:
- `None` for invalid/unrepresentable inputs (when `invalid_to_none=True`)
- `bool`, `int`, `float`, `Decimal` (validated per rules)
- `str` for:
  - cleaned strings
  - ISO-8601 string form of `datetime/date/time`
  - base64 string form of binary input (default)
  - JSON string form of complex types (when applicable)

**Notes**
- For complex objects (`dict`, `list`, `tuple`, `set`, `frozenset`), the default behavior is:
  - Top-level: JSON string
  - Nested: Python structures that are JSON-serializable, then included into the top-level JSON

---

### `SanitizeConfig` (dataclass)

Immutable config container that controls sanitization behavior. See **Configuration**.

---

### Internal helpers (implementation details)

These functions are internal, but important to understand behavior:

#### `_sanitize_internal(value: Any, cfg: SanitizeConfig, *, _depth: int, _dump_complex: bool) -> Any`

Recursive conversion engine.

- `_depth` is incremented when entering nested structures
- `_dump_complex` controls whether complex values should be JSON-serialized at this level

#### `_db_ready_string(s: str, cfg: SanitizeConfig) -> str`

Cleans strings via:
1. Unicode normalization (`cfg.normalize_unicode`)
2. Optional null-byte removal
3. Optional control-char removal
4. Optional trim
5. Optional max-length truncation

#### `_to_json(obj: Any, cfg: SanitizeConfig) -> str`

Serializes lists/dicts into compact JSON using:
- `ensure_ascii=False`
- `separators=(",", ":")`

On failure:
- returns `None` if `cfg.invalid_to_none` is `True`
- otherwise returns `str(obj)`

---

## Sanitization Rules by Type

### `None`
Returns `None`.

### `bool`
Returns as-is.

### `int`
Returns as-is.

### `float`
- If `cfg.allow_nan_inf` is `False` and the value is `NaN` or infinite:
  - returns `None` (when `invalid_to_none=True`)
  - otherwise returns the original float
- Otherwise returns as-is.

### `Decimal`
Validated by attempting `value + Decimal(0)`:
- If that raises `InvalidOperation` or `ValueError`, treated as invalid (see `invalid_to_none`).
- Otherwise returned as-is.

### `datetime`, `date`, `time`
Converted to `value.isoformat()`.
If `isoformat()` raises, treated as invalid.

### `bytes`, `bytearray`, `memoryview`
- Default: base64 encoded string (`cfg.bytes_mode == "base64"`)
- Otherwise: attempt UTF-8 decode with `errors=cfg.bytes_errors`, then apply `_db_ready_string(...)`

### `str`
Runs through `_db_ready_string(...)`.

### `Mapping`
- If `cfg.complex_mode == "reject"`, treated as invalid.
- Otherwise:
  - keys are converted to `str`, then cleaned via `_db_ready_string`
  - values sanitized recursively
  - truncated to at most `cfg.max_collection_len` entries
  - JSON-serialized at the current level only if `_dump_complex=True`

### `list`, `tuple`, `set`, `frozenset`
- If `cfg.complex_mode == "reject"`, treated as invalid.
- Otherwise:
  - items sanitized recursively
  - truncated to at most `cfg.max_collection_len`
  - JSON-serialized at the current level only if `_dump_complex=True`

### Other / Unknown Objects
Falls back to `str(value)` and cleans it with `_db_ready_string(...)`.
If `str(...)` fails, treated as invalid.

---

## Error Handling

This module is defensive and generally **does not raise** errors to the caller. Instead:

- Conversion/normalization/serialization failures yield:
  - `None` when `cfg.invalid_to_none=True` (default)
  - original value (or string fallback in `_to_json`) when `cfg.invalid_to_none=False`
- Known guarded operations:
  - Unicode normalization (`unicodedata.normalize`)
  - ISO formatting (`isoformat()`)
  - byte decoding
  - Decimal validity check
  - JSON serialization

If you need strict failure behavior, set `invalid_to_none=False` and validate outputs at the call site.

---

## Usage Examples

### Basic sanitization

```python
from decimal import Decimal
from datetime import datetime

safe = sanitizeData({
    "name": "  José\u0000 ",
    "created": datetime(2026, 2, 25, 13, 45),
    "score": float("nan"),
    "price": Decimal("12.50"),
})
# Returns a JSON string by default (top-level complex -> JSON)