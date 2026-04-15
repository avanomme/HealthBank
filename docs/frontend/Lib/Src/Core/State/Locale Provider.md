# Locale Provider (`locale_provider.dart`)

## Overview

This module provides application-level locale management using Riverpod.

It enables:

- Runtime language switching
- Centralized locale state management
- Rebuilding of localized widgets when language changes
- A predefined list of supported locales

File: `frontend/lib/src/core/state/locale_provider.dart`

---

## Architecture / Design

### State Management Strategy

This implementation uses:

- `StateNotifier<Locale>` for managing locale state
- `StateNotifierProvider` from Riverpod for exposing the state to the widget tree

This approach:

- Keeps locale state globally accessible
- Ensures reactive UI updates when the locale changes
- Maintains separation of concerns between UI and state logic

### Default Behavior

- Default locale is English (`Locale('en')`)
- Locale changes trigger rebuilds of all widgets depending on localization

### Persistence

Although the documentation mentions persistence, this file does not currently implement storage.  
Persistence (e.g., SharedPreferences) must be implemented externally if required.

---

# API Reference

---

## `localeProvider`

```dart
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});