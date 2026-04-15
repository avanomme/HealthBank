# `markdown/config.md` — Application Configuration (`backend/app/core/config.py`)

## Overview

`backend/app/core/config.py` provides environment-driven configuration for SMTP email delivery.

It defines:

- A typed `SMTPConfig` dataclass
- A factory function `get_smtp_config()` that loads configuration from environment variables

This module centralizes email-related configuration and isolates environment access from business logic.

---

## Architecture / Design Explanation

### Environment-Based Configuration

SMTP settings are loaded directly from environment variables using `os.getenv`.

Defaults are provided for non-sensitive values such as:

- Host
- Port
- From display name
- Timeout

Credentials (`SMTP_USER`, `SMTP_PASSWORD`) are optional but required for full SMTP authentication.

### Typed Configuration Object

`SMTPConfig` is a `@dataclass`, providing:

- Strongly-typed attributes
- Computed properties for:
  - `is_configured`
  - `from_address`

This design allows:

- Clean dependency injection into email services
- Clear separation between configuration loading and usage

### Lazy Loading Pattern

`get_smtp_config()`:

- Reads environment variables at call time
- Returns a new `SMTPConfig` instance
- Does not cache configuration

This allows runtime overrides in testing environments if needed.

---

## Configuration

### Environment Variables

| Variable            | Type   | Default            | Description |
|--------------------|--------|-------------------|-------------|
| `SMTP_HOST`        | str    | `smtp.gmail.com`  | SMTP server hostname |
| `SMTP_PORT`        | int    | `587`             | SMTP server port |
| `SMTP_USER`        | str    | `None`            | SMTP username (usually email address) |
| `SMTP_PASSWORD`    | str    | `None`            | SMTP password or app-specific password |
| `SMTP_FROM_NAME`   | str    | `HealthBank`      | Display name for outgoing emails |
| `SMTP_TIMEOUT`     | int    | `30`              | SMTP connection timeout in seconds |

### Example `.env`

```env
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=healthbank@example.com
SMTP_PASSWORD=your-app-password
SMTP_FROM_NAME=HealthBank
SMTP_TIMEOUT=30