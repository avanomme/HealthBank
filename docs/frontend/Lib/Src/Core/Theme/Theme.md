# Application Theme (`app_theme.dart`)

## Overview

This module defines the centralized visual theme for the HealthBank frontend application.

It provides:

- Brand color definitions
- Semantic color mappings
- Static typography styles (Roboto via Google Fonts)
- Responsive typography based on breakpoints
- Breakpoint-aware `ThemeData` generation
- A default theme configuration

File: `frontend/lib/src/core/theme/app_theme.dart`  
(Exports `breakpoints.dart`)

---

## Architecture / Design

### Design Goals

- Centralize all design tokens (colors, typography)
- Ensure consistent styling across the app
- Support responsive typography
- Align with Figma design specifications
- Keep theme logic breakpoint-aware

### Structure

The `AppTheme` class contains:

1. Color constants
2. Static typography styles
3. Responsive `TextTheme` generation
4. Breakpoint-based `ThemeData` factory
5. Backwards-compatible default theme

---

# Color System

---

## Primary Brand Colors

| Name | Hex |
|------|------|
| `primary` | `#22446D` |
| `primaryHover` | `#1C3666` |
| `secondary` | `#145B2C` |
| `secondaryHover` | `#0F1A38` |
| `muted` | `#5E6773` |
| `mutedHover` | `#4E5467` |

---

## Text Colors

| Name | Hex |
|------|------|
| `textPrimary` | `#000000` |
| `textContrast` | `#FFFFFF` |
| `textMuted` | `#5E6773` |

---

## Background

| Name | Hex |
|------|------|
| `backgroundMuted` | `#FAFAFA` |

---

## Semantic Colors

| Name | Hex | Purpose |
|------|------|----------|
| `error` | `#A6192E` | Errors / destructive actions |
| `caution` | `#FF9900` | Warnings |
| `success` | `#04B34F` | Success states |
| `info` | `#0057B8` | Informational highlights |

---

## Additional Utility Colors

| Name | Hex |
|------|------|
| `black` | `#000000` |
| `white` | `#FFFFFF` |
| `whiteHover` | `#E9E9E9` |
| `gray` | `#EFEFEF` |
| `placeholder` | `#A9BAFF` |

---

# Typography

All text styles use:
