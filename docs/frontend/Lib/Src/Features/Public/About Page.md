# About Page Documentation

**File:** `frontend/lib/src/features/public/pages/about_page.dart`

## Overview

`AboutPage` is a role-aware informational page that displays a brief description of the platform or organization. The page dynamically selects the appropriate application scaffold depending on the authenticated user’s role.

The page supports the following user roles:

- Participant
- Researcher
- Healthcare Provider (HCP)
- Administrator

Each role receives the same content but is wrapped in a different scaffold to maintain role-specific navigation, layout, and UI structure.

## Architecture / Design Explanation

### Widget Type

`AboutPage` is implemented as a `ConsumerWidget` because it reads authentication state from Riverpod providers in order to determine the current user’s role.

This allows the page to reactively rebuild when authentication state changes.

### Role-Based Layout Selection

The page determines the appropriate layout scaffold based on the authenticated user’s role.

The process is:

1. Read authentication state from `authProvider`.
2. Extract the user's role.
3. Convert the role string to an enum using `NavigationConfig.parseRole`.
4. Default to `UserRole.participant` if no role is available.
5. Render the page content inside the role-specific scaffold.

### Shared Content

The content of the page is defined once (`aboutContent`) and reused across all role layouts. This ensures consistency and avoids duplicating UI logic.

The content currently contains:

- A header text styled with the application theme.
- A placeholder paragraph describing the application.

### Scaffold Selection

The page selects one of the following scaffolds depending on the user role:

| Role | Scaffold |
|-----|------|
| Participant | `ParticipantScaffold` |
| Researcher | `ResearcherScaffold` |
| Healthcare Provider | `HcpScaffold` |
| Administrator | `AdminScaffold` |

Each scaffold handles role-specific navigation and layout behavior.

### Footer Behavior

A comment in the file notes that the footer does not appear for administrators or researchers. This behavior is determined by the scaffold implementations rather than this page itself.

Future adjustments to footer visibility can be made through scaffold configuration (for example, by adding a `showFooter` flag).

## Configuration

This page does not define its own configuration values. It relies on external configuration and providers:

- `authProvider` supplies the authenticated user state.
- `NavigationConfig.parseRole()` converts backend role values to application role enums.
- `AppTheme` provides theme styling.

## API Reference

### `AboutPage`

#### Constructor

`AboutPage({Key? key})`

**Parameters**

- `key` (`Key?`)  
  Optional Flutter widget key.

**Returns**

- A new instance of `AboutPage`.

### `build(BuildContext context, WidgetRef ref) -> Widget`

Builds the role-aware about page UI.

**Parameters**

- `context` (`BuildContext`)  
  Flutter build context used for rendering the widget tree.

- `ref` (`WidgetRef`)  
  Riverpod reference used to read providers.

**Returns**

- `Widget`  
  A role-specific scaffold containing the about page content.

### Role Determination

The following logic determines the scaffold:

1. `authState = ref.watch(authProvider)`
2. `userRole = NavigationConfig.parseRole(authState.user?.role)`
3. If parsing fails, default role is `UserRole.participant`.

### Shared Content Structure

The content rendered inside each scaffold consists of:

- `Padding`
  - Padding: `32.0`
- `Column`
  - `Text` header styled with:
    - `Theme.of(context).textTheme.headlineMedium`
    - `AppTheme.primary`
  - Spacer (`SizedBox`)
  - Paragraph text (`Text` widget)

## Error Handling

This page performs no network requests or asynchronous operations.

Potential edge cases handled:

- If `authState.user` is null or has no role:
  - The role defaults to `UserRole.participant`.
- If role parsing fails:
  - The fallback role remains `UserRole.participant`.

No additional error handling or loading states are implemented.

## Usage Examples

### Registering the About Page Route

In the application router configuration, the route should map `/about` to `AboutPage`.

Example route:

- Path: `/about`
- Builder: `(_) => const AboutPage()`

### Navigation

Users can navigate to the page using the route:

`/about`

The correct scaffold will automatically be selected based on the authenticated user role.

## Related Files

- `frontend/src/features/auth/state/auth_providers.dart`  
  Provides `authProvider`, which supplies authentication and user role data.

- `frontend/src/config/navigation.dart`  
  Defines `NavigationConfig` and the `UserRole` enum used for role parsing.

- `frontend/src/core/theme/theme.dart`  
  Defines theme values including `AppTheme.primary`.

- `frontend/src/features/participant/widgets/participant_scaffold.dart`  
  Layout shell for participant pages.

- `frontend/src/features/researcher/widgets/researcher_scaffold.dart`  
  Layout shell for researcher pages.

- `frontend/src/features/hcp_clients/widgets/hcp_scaffold.dart`  
  Layout shell for healthcare provider pages.

- `frontend/src/features/admin/widgets/admin_scaffold.dart`  
  Layout shell for administrator pages.