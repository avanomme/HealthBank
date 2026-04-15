# Localization BuildContext Extension (`l10n_extension.dart`)

## Overview

This module provides a `BuildContext` extension for accessing localized strings in a concise and readable way.

It simplifies usage of `AppLocalizations` by exposing a `l10n` getter directly on `BuildContext`.

File: `frontend/lib/src/core/l10n/l10n_extension.dart`

---

## Architecture / Design

### Problem Solved

Without this extension, localized strings must be accessed using:

```dart
final l10n = AppLocalizations.of(context);
Text(l10n.authLoginButton);