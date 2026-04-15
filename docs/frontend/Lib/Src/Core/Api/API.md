# HealthBank API Entry Point (`api.dart`)

## Overview

This module serves as the **public entry point** for the HealthBank frontend API layer.

It re-exports:

- Core API client configuration
- All typed API models
- All Retrofit service interfaces

Consumers can import a single file to gain access to the entire API surface.

File: `frontend/lib/core/api/api.dart`

---

## Architecture / Design

### Barrel Export Pattern

This file implements a barrel export to simplify imports across the application.

Instead of importing:

```dart
import 'api_client.dart';
import 'models/models.dart';
import 'services/services.dart';