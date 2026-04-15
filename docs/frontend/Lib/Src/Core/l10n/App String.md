# App Strings Localization (`app_strings.dart`)

## Overview

This module centralizes all user-facing strings for the HealthBank application.

It provides:

- Structured string grouping by feature/domain
- A single access point for UI text
- Preparation for future internationalization (i18n)
- Maintainable organization by role and feature

File: `frontend/lib/src/core/l10n/app_strings.dart`

---

## Architecture / Design

### Centralized String Management

All user-visible text is defined in this file to:

- Prevent hardcoded UI strings
- Enable consistent wording across the app
- Simplify translation and localization
- Improve maintainability

### Organizational Structure

The root class:

```dart
AppStrings