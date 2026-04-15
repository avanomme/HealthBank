# PrivacyPolicyPage

File: `frontend/lib/<path-to-file>/privacy_policy_page.dart`  
Note: The provided snippet does not include the source file path. Replace the placeholder path above with the actual repository location.

## Overview

`PrivacyPolicyPage` is a `StatefulWidget` that renders a privacy policy document with:

- A scrollable main content area containing sectioned policy text.
- A right-hand “Table of Contents” (TOC) panel that scrolls the main content to specific sections when clicked.
- Localized titles and body text sourced from `context.l10n`.
- A consistent application layout via `BaseScaffold`.

This page is suitable for desktop/tablet layouts where a two-column document + TOC experience is expected.

## Architecture / Design

### High-level layout

The UI is structured as a two-column `Row`:

1. **Main Content (Expanded)**
   - `SingleChildScrollView` controlled by `_scrollController`
   - A `Column` containing:
     - Page title
     - Section 1 block
     - Section 2 block
   - Each section is wrapped in a `Container` associated with a `GlobalKey`, enabling programmatic scrolling.

2. **Table of Contents (Fixed width)**
   - A styled `Container` with fixed width `220`
   - Uses `InkWell` entries that call `_scrollToSection(...)` with the corresponding section key.

### Section navigation (scroll-to-section)

- Each section is identified with a `GlobalKey` (`section1Key`, `section2Key`).
- `_scrollToSection(GlobalKey key)` uses:

  - `key.currentContext` to locate the widget
  - `Scrollable.ensureVisible(...)` to animate the scroll to the target section

Behavior details:

- Duration: 400ms
- Curve: `Curves.easeInOut`
- Alignment: `0.1` (positions the target slightly below the top of the viewport)

### State and lifecycle

State owned by `_PrivacyPolicyPageState`:

- `_scrollController` (`ScrollController`)
- `section1Key` (`GlobalKey`)
- `section2Key` (`GlobalKey`)

Lifecycle:

- `_scrollController` is disposed in `dispose()` to prevent leaks.

### Theming and localization

- Theme data is obtained via `Theme.of(context)` and used for typography:
  - Title uses `headlineMedium` with overrides (color, size 44, bold)
  - Section headings use `headlineSmall` with secondary color
  - Section bodies use `bodyMedium`

- Colors and surfaces use `AppTheme`:
  - Primary/secondary text emphasis
  - TOC background (`AppTheme.backgroundMuted`)
  - Borders (`AppTheme.gray`)
  - Title color (`AppTheme.primary`)

- All displayed strings are localized via `context.l10n`, including:
  - Page title
  - TOC title
  - Section titles and bodies

## Configuration

No runtime configuration is required.

Prerequisites:

- `BaseScaffold` must be available via `frontend/src/core/widgets/widgets.dart` (or re-exported there).
- `AppTheme` must define:
  - `primary`, `secondary`, `gray`, `backgroundMuted`
- Localization must define the referenced keys (see API Reference section).

## API Reference

## `PrivacyPolicyPage`

### Constructor

```dart
const PrivacyPolicyPage({Key? key});