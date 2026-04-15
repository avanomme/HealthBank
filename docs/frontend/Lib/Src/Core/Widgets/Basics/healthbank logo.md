# HealthBankLogo

**File:** `frontend/lib/src/core/widgets/basics/healthbank_logo.dart`

## Overview

`HealthBankLogo` is a reusable brand component that renders the HealthBank logo consisting of:

- A heart icon (representing health)
- The “HealthBank” wordmark
- An optional tagline

It supports multiple size variants and optional color overrides to ensure consistent branding across headers, dialogs, previews, and completion screens.

This file also defines `HealthBankLogoHeader`, a lightweight header bar wrapper for displaying the logo with optional background styling and divider.

---

## Architecture / Design

### `HealthBankLogoSize` Enum

Defines three predefined size variants:

- `small`
- `medium`
- `large`

Each size controls:

- Icon size
- Wordmark font size
- Spacing between icon and text

This ensures consistent scaling without requiring manual layout adjustments at each usage site.

---

## HealthBankLogo

### Layout Structure

`HealthBankLogo` renders:

- A `Column` (min main axis size)
  - `Row`
    - Heart icon (`Icons.favorite`)
    - Horizontal spacing
    - “HealthBank” text styled with `AppTheme.logo`
  - Optional tagline (if `showTagline == true`)

### Size Resolution

Based on `size`:

| Size Variant | Icon Size | Font Size | Spacing |
|-------------|-----------|-----------|---------|
| `small` | 20 | 16 | 6 |
| `medium` | 28 | 22 | 8 |
| `large` | 40 | 32 | 12 |

### Color Resolution

- `logoColor = color ?? AppTheme.primary`
- Applies to:
  - Icon
  - Wordmark text
  - Tagline (with reduced opacity)

### Tagline Behavior

If `showTagline` is `true`:

- Renders the text: