# AdminDashboardPage (`admin_dashboard_page.dart`)

## Overview

`AdminDashboardPage` is a Flutter `StatelessWidget` that serves as the landing page for the admin area. It provides a simple dashboard header and welcome message wrapped in a shared admin layout (`AdminScaffold`).

Key responsibilities:
- Render the admin dashboard title and introductory text.
- Use app localization (`l10n`) for user-facing strings.
- Apply consistent theming for the dashboard title.

## Architecture / Design

### Placement and role
- **Feature area:** `features/admin/pages`
- **UI composition:** The page delegates layout concerns (navigation, padding, common admin UI chrome) to `AdminScaffold`, and focuses only on its content.

### Composition
- **Root container:** `AdminScaffold`
  - `currentRoute: '/admin'` is provided to allow the scaffold (or its navigation components) to reflect the active section.
- **Content:** A `Column` aligned to the start of the cross-axis, containing:
  1. A title text (`adminDashboardTitle`) styled using `displaySmall` plus overrides:
     - `color: AppTheme.primary`
     - `fontWeight: FontWeight.bold`
  2. Vertical spacing (`SizedBox(height: 24)`)
  3. A welcome message (`adminWelcomeMessage`) using `bodyLarge`

### Localization
- Uses `context.l10n` to fetch localized strings.
  - This implies the project provides a `BuildContext` extension (commonly via generated localization code) to access localized values.

### Theming
- The title styling is derived from the current `Theme` (`Theme.of(context).textTheme.displaySmall`) and then modified with `copyWith`.
- `AppTheme.primary` is used for the title color, ensuring consistency with the app’s design system.

## Configuration

No runtime configuration is required.

Prerequisites:
- Localization (`l10n`) must be properly initialized in the app so that `context.l10n` is available.
- The admin feature’s widget exports must include `AdminScaffold`.

## API Reference

## `AdminDashboardPage`

A stateless page widget representing the admin dashboard landing screen.

### Constructor

`const AdminDashboardPage({Key? key})`

#### Parameters
- `key` (`Key?`): Optional Flutter widget key.

#### Returns
- An instance of `AdminDashboardPage`.

### Public Members

#### `build(BuildContext context) -> Widget`

Builds the admin dashboard UI.

##### Parameters
- `context` (`BuildContext`): The build context used to access theme and localization.

##### Returns
- `Widget`: An `AdminScaffold` containing the dashboard content.

## Error Handling

This widget does not implement explicit error handling.

Potential integration/runtime considerations:
- If localization is not set up correctly, `context.l10n` access may fail (or return unexpected values depending on implementation).
- If `AdminScaffold` is not exported or available at runtime, the file will not compile.

## Usage Examples

### Basic usage in routing

```dart
// Example route registration (illustrative; adapt to your routing solution)
routes: {
  '/admin': (_) => const AdminDashboardPage(),
}