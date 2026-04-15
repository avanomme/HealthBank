# Account Request API Models

**File:** `frontend/lib/src/core/api/models/account_request.dart`  
**Purpose:** Defines request and response models for the account request flow using `freezed` and `json_serializable`.

---

## Overview

This file contains immutable data models used in the public account request flow and admin review workflow.

The models support:

- Submitting a new account request (public endpoint)
- Listing and reviewing account requests (admin endpoint)
- Retrieving a count of pending requests
- Rejecting an account request

All models use:

- `freezed` for immutability and union/sealed types
- `json_serializable` for JSON (de)serialization
- Explicit `@JsonKey` mappings to match backend snake_case API fields

---

## Architecture / Design

### Key Design Decisions

- **Immutable models** via `@freezed`
- **Sealed classes** to prevent unintended subclassing
- **Explicit JSON mapping** for backend compatibility
- **Generated code** via build_runner

### Code Generation

After modifying this file, run:

```bash
dart run build_runner build