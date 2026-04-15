# HcpClientListPage

File: `frontend/lib/src/features/hcp_clients/pages/hcp_client_list_page.dart`

## Overview

`HcpClientListPage` is a `StatelessWidget` representing the Healthcare Professional (HCP) client list screen. In its current form, it is a placeholder UI that renders within `HcpScaffold` and displays centered text indicating the page is not yet implemented.

Intended future features (per file documentation/comments):

- Display a list of the HCP’s clients
- Provide search and filter controls
- Support navigation to individual client detail pages

## Architecture / Design

This page is deliberately thin and delegates layout and role-specific UI chrome to `HcpScaffold`.

- **Layout wrapper:** `HcpScaffold`
  - Receives `currentRoute: '/hcp/clients'` for navigation highlighting / active state in the HCP shell.
  - Receives `scrollable: true` so scaffold-managed content is scrollable.
  - Receives `showFooter: true` to display the standard footer in this role layout.

- **Content:** A `Center` widget containing a `Text` placeholder.
  - The placeholder is a non-localized hardcoded string:
    - `HCP Clients\n(Placeholder)`
  - Uses an inline `TextStyle(fontSize: 24)`.

Because the page uses `const HcpScaffold(...)` and the placeholder subtree is also `const`, the current widget tree is compile-time constant and should be inexpensive to rebuild.

## Configuration

No runtime configuration is required for the current placeholder implementation.

Prerequisites for integration:

- The app’s router must define a route matching `/hcp/clients` that builds `HcpClientListPage`.
- `HcpScaffold` must exist and be compatible with the following constructor arguments:
  - `currentRoute`
  - `scrollable`
  - `showFooter`
  - `child`

## API Reference

## `HcpClientListPage`

### Constructor

```dart
const HcpClientListPage({Key? key});