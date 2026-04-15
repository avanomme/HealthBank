# Research API Models (`research.dart`)

## Overview
This module defines research-facing models for survey analytics and data export, matching backend Pydantic schemas. It supports:

- Listing research surveys with high-level counts
- Survey-level overview statistics
- Per-question aggregate statistics
- Individual anonymized response exports (single survey)
- Cross-survey analytics and anonymized exports

All models use:
- `freezed` for immutable value types
- `json_serializable` for JSON (de)serialization

File: `frontend/lib/src/core/api/models/research.dart`

---

## Architecture / Design

### Design Principles
- **Immutable models** using `@freezed`
- **Explicit JSON key mapping** using `@JsonKey(name: ...)`
- **Nested model composition** for structured payloads (overview → aggregates → rows)
- **Suppression-aware responses**: many responses include `suppressed` and optional `reason`
- **Loose aggregate payloads** where backend shape varies (`Map<String, dynamic>` fields)

### Model Groupings

#### 1. Research Survey List & Survey Overview
- `ResearchSurvey`: list item metadata/counts
- `SurveyOverview`: high-level overview stats for a single survey

#### 2. Aggregates (Per Survey, Per Question)
- `QuestionAggregate`: aggregate record per question, optionally includes arbitrary `data`
- `AggregateResponse`: wrapper containing per-question aggregates for a survey

#### 3. Individual Response Export (Single Survey)
- `ResponseQuestion`: question metadata for export payloads
- `ResponseRow`: anonymized response row keyed by question/field identifiers
- `IndividualResponseData`: export wrapper with questions + rows and suppression metadata

#### 4. Cross-Survey Models
Used when combining multiple surveys into a single dataset:
- `CrossSurveyQuestion`: question metadata including survey context
- `CrossSurveyRow`: anonymized response row including survey context
- `CrossSurveySummary`: per-survey summary stats
- `CrossSurveyOverview`: aggregated overview across multiple surveys
- `CrossSurveyResponseData`: cross-survey export wrapper

### Suppression Semantics (Model-Level)
Many responses include:
- `suppressed: bool`
- `reason: String?` (optional explanation)

Consumers should treat suppressed payloads as potentially incomplete, redacted, or unavailable for privacy/statistical disclosure control.

### Code Generation
Generated files required:
- `research.freezed.dart`
- `research.g.dart`

Run:
```bash
dart run build_runner build