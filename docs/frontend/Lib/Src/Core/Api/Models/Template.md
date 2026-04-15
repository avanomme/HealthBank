# Template API Models (`template.dart`)

## Overview
This module defines the data models for the Template domain, matching backend Pydantic schemas. Templates allow reusable sets of questions to be defined and later used to create surveys.

This file includes:
- Template creation and update request models
- Template response model
- Question representation within a template

All models use:
- `freezed` for immutable value types
- `json_serializable` for JSON (de)serialization

File: `frontend/lib/core/api/models/template.dart`

---

## Architecture / Design

### Design Principles
- **Immutable models** using `@freezed`
- **Explicit JSON key mapping** via `@JsonKey(name: ...)`
- **Partial update support** through optional fields
- **Nested question composition**
- **Re-use of shared models**:
  - `QuestionOption` is imported from `survey.dart` for consistency

### Model Relationships
- `TemplateCreate` and `TemplateUpdate` reference questions via `questionIds`.
- `Template` may embed full question definitions using `QuestionInTemplate`.
- `QuestionInTemplate` includes `displayOrder` to preserve template ordering.
- `QuestionOption` (imported from `survey.dart`) models choice-based options.

### Code Generation
Generated files required:
- `template.freezed.dart`
- `template.g.dart`

Run:
```bash
dart run build_runner build