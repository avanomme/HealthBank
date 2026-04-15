# Assignment API Models

**File:** `frontend/lib/core/api/models/assignment.dart`  
**Purpose:** Defines assignment-related request and response models that align with backend Pydantic schemas.

---

## Overview

This file provides immutable data models for:

- Creating assignments (single and bulk)
- Updating assignments
- Representing assignment responses
- Representing authenticated user assignment views (`/assignments/me`)

All models use:

- `freezed` for immutability and value equality
- `json_serializable` for JSON serialization
- `@JsonKey` for snake_case backend compatibility
- `DateTime` for timestamp fields

---

## Code Generation

After modifying this file, run:

```bash
dart run build_runner build