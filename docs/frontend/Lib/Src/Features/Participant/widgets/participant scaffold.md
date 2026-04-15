# Participant UI Scaffolding (Flutter)

This document covers the participant-facing layout wrappers used to provide a consistent participant UI across pages:

- `ParticipantHeader` (`frontend/lib/src/features/participant/widgets/participant_header.dart`)
- `ParticipantScaffold` (`frontend/lib/src/features/participant/widgets/participant_scaffold.dart`)

---

## Overview
`ParticipantScaffold` is a participant-specific convenience widget that composes the shared `BaseScaffold` layout with a participant-configured `ParticipantHeader`. It centralizes common page layout concerns (header, scrolling behavior, footer visibility, padding, FAB) so participant pages can stay focused on their content.

`ParticipantHeader` (documented below for completeness) is the participant-specific wrapper around the shared `Header` component and provides standardized navigation items and routing.

---

## Architecture / Design

### ParticipantScaffold
- **Wrapper role:** `ParticipantScaffold` is a thin wrapper that configures `BaseScaffold` with a `ParticipantHeader`.
- **Consistency:** Ensures participant pages share the same header navigation, footer behavior, and default spacing.
- **Pass-through configuration:** Most layout controls (scrollable, footer, padding, FAB) are passed directly into `BaseScaffold`.

### ParticipantHeader (dependency)
- Provides participant navigation items and route navigation behavior (via `go_router`).
- Receives `currentRoute` so active navigation can be highlighted.

---

## Configuration

### Defaults
`ParticipantScaffold` applies participant-friendly defaults:

- `scrollable`: `true`
- `showFooter`: `true`
- `padding`: `EdgeInsets.all(24)`

These can be overridden per page when needed.

---

## API Reference

## ParticipantScaffold

### Signature
```dart
class ParticipantScaffold extends StatelessWidget