# NotificationBanner Documentation

## Overview

`NotificationBanner` is a Flutter `StatelessWidget` that conditionally displays an orange, tappable notification banner indicating a number of new messages. If `messageCount` is `0` or less, the widget renders nothing.

This widget is intended for participant-facing UI and matches a specific design requirement: an orange banner with a chat/message icon and localized message text.

**Source file:** `frontend/lib/src/features/participant/widgets/notification_banner.dart`

## Architecture / Design

### Responsibilities

- **Visibility logic:** Hides itself when there are no new messages (`messageCount <= 0`).
- **Interaction:** Wraps its content in an `InkWell` to support tap interaction via `onTap`.
- **Presentation:** Renders a styled `Container` with:
  - Background color: `AppTheme.caution`
  - Rounded corners: `BorderRadius.circular(4)`
  - Horizontal layout: icon + spacing + localized text

### Key Dependencies

- **Flutter Material:** Provides core widgets (`InkWell`, `Container`, `Row`, `Icon`, `Text`, etc.)
- **AppTheme (`frontend/src/core/theme/theme.dart`):** Provides:
  - Colors: `AppTheme.caution`, `AppTheme.white`
  - Typography: `AppTheme.body`
- **Localization (`frontend/src/core/l10n/l10n.dart`):**
  - Uses `context.l10n.participantNotificationMessage(messageCount)` to build the banner text.

### Localization Contract

The widget assumes `l10n` defines a function with the following conceptual signature:

- `participantNotificationMessage(int messageCount) -> String`

This should return an appropriately pluralized, localized string (e.g., “You have 1 new message…” vs “You have 5 new messages…”), depending on how your localization system is set up.

## Configuration

No external configuration is required. The widget relies on:

- `AppTheme` being available (static members used directly).
- Localization being correctly wired such that `context.l10n` is accessible in the widget tree.

## API Reference

### Class: `NotificationBanner`

A stateless widget that displays a new-message banner when `messageCount > 0`.

#### Constructor

`const NotificationBanner({ Key? key, required int messageCount, VoidCallback? onTap })`

#### Parameters

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `key` | `Key?` | No | `null` | Standard Flutter widget key. |
| `messageCount` | `int` | Yes | — | Number of new messages. Determines visibility and displayed text. |
| `onTap` | `VoidCallback?` | No | `null` | Callback invoked when the banner is tapped. If `null`, the banner is non-interactive but still rendered with `InkWell`. |

#### Return Types

- `build(BuildContext context) -> Widget`

Build behavior:
- Returns `SizedBox.shrink()` when `messageCount <= 0`.
- Returns an `InkWell` containing the banner UI when `messageCount > 0`.

## Error Handling

This widget does not explicitly throw or catch errors. Potential runtime issues depend on surrounding app configuration:

- **Localization not configured:** If `context.l10n` is unavailable or `participantNotificationMessage` is missing, the build may fail.
- **Invalid `messageCount` values:** Negative values are handled gracefully by hiding the banner (treated the same as `0`).

## Usage Examples

### Basic usage (display when count > 0)

```dart
NotificationBanner(
  messageCount: newMessageCount,
  onTap: () {
    // Navigate to messages or open a message panel
  },
)