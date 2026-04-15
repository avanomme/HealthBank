# Footer

**File:** `frontend/lib/src/core/widgets/basics/footer.dart`

## Overview

`Footer` is a reusable, localized application footer widget that renders a brand header and one or more link sections. It is implemented as a Riverpod `ConsumerWidget` to allow future extensibility with providers, though the current implementation primarily uses `BuildContext` for theming and localization.

The footer supports:

- Configurable sections and links
- Localized default sections when none are provided
- Route-based link handling via a callback
- Direct link tap handlers per link

---

## Architecture / Design

### Data Models

#### `FooterLink`

Represents a single footer link item.

- `label`: required display text
- `route`: optional route string for navigation
- `onTap`: optional direct callback for handling taps

Tap priority:
1. If `onTap` is provided, it is invoked.
2. Else if `route` is provided, `Footer.onLinkTap(route)` is invoked (if set).
3. Otherwise, tap does nothing.

#### `FooterSection`

Represents a section in the footer:

- `title`: required section heading text
- `links`: list of `FooterLink` items under the section

---

### Widget Composition

#### `Footer` (ConsumerWidget)

- Inputs:
  - `sections`: optional list of `FooterSection`
  - `onLinkTap`: optional callback invoked when a link with a route is tapped

- Behavior:
  - If `sections` is empty, `Footer` uses two localized defaults:
    - Help & Services section
    - Legal section

- Layout:
  - Root `Container` spanning full width
  - Background uses `Theme.of(context).colorScheme.primary`
  - Brand title “HealthBank” rendered using `AppTheme.logo`
  - Divider line beneath brand title
  - Section list rendered using a `Wrap` for responsive layout

---

## Configuration

### Dependencies

- Flutter Material theme (`Theme.of(context)`)
- Riverpod (`ConsumerWidget`, `WidgetRef`)
- App theme tokens:
  - `AppTheme.logo`
- Localization:
  - `AppLocalizations` via `context.l10n` (from `frontend/src/core/l10n/l10n.dart`)

### Default Sections (Localization)

If `sections` is not provided (or is empty), the footer constructs defaults using localized strings:

- `getDefaultHelpSection(AppLocalizations l10n)`
  - Routes:
    - `/help`
    - `/contact`
    - `/help-desk`

- `getDefaultLegalSection(AppLocalizations l10n)`
  - Routes:
    - `/privacy-policy`
    - `/terms`

---

## API Reference

## `FooterLink`

### Constructor

```dart
const FooterLink({
  required String label,
  String? route,
  VoidCallback? onTap,
})