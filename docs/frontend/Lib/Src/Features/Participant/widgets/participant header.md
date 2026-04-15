# ParticipantHeader (Flutter)

## Overview
`ParticipantHeader` is a participant-facing app header widget that wraps the shared `Header` component and preconfigures it with participant-specific navigation routes and localized labels. It provides navigation to:

- Dashboard
- Tasks (To-Do)
- Surveys
- Results

It integrates with `go_router` to perform route navigation, and relies on the base `Header` widget for common behaviors (including logout handling).

**File:** `frontend/lib/src/features/participant/widgets/participant_header.dart`

## Architecture / Design
### Role in UI
- `ParticipantHeader` is a **thin configuration wrapper** around the shared `Header` widget (`frontend/src/core/widgets/basics/header.dart`).
- It defines a participant navigation model (`List<NavItem>`) and passes it to `Header`.
- It exposes optional callbacks for notifications and profile interaction while preserving the base header’s common functionality.

### Key Design Choices
- **Localization-first labels:** Labels are sourced from `context.l10n.*` (via `frontend/src/core/l10n/l10n.dart`).
- **Declarative routing:** Uses `go_router` (`context.go(route)`) for navigation.
- **PreferredSizeWidget:** Implements `PreferredSizeWidget` with a fixed height (`64`) so it can be used in places like `Scaffold.appBar` or app scaffolding constructs expecting an app bar-like widget.

## Configuration
### Constructor Parameters
`ParticipantHeader` is configured entirely via constructor arguments:

- `currentRoute` (**required**): Used to indicate which navigation item is currently active.
- `onNotificationsTap` (optional): Called when the notifications icon is tapped (if surfaced by `Header`).
- `onProfileTap` (optional): Called when the profile UI is tapped (if surfaced by `Header`).
- `hasNotifications` (optional, default `false`): Indicates whether there are unread notifications.
- `userName` (optional): Passed through to `Header` to display in a profile dropdown or profile area.

### Preferred Size
- `preferredSize` is fixed at `Size.fromHeight(64)`.

## API Reference

## ParticipantHeader
A `StatelessWidget` implementing `PreferredSizeWidget`.

### Signature
```dart
class ParticipantHeader extends StatelessWidget implements PreferredSizeWidget