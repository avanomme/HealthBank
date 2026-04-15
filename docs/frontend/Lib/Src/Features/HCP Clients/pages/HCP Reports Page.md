# HcpReportsPage

File: `frontend/lib/src/features/hcp_clients/pages/hcp_reports_page.dart`

## Overview

`HcpReportsPage` is a `StatelessWidget` representing the Healthcare Professional (HCP) reports section of the application.

The current implementation is a placeholder screen rendered inside the shared `HcpScaffold` layout. It displays a centered message indicating that the reports functionality has not yet been implemented.

The intended purpose of this page is to provide tools for healthcare professionals to generate and manage reports related to their clients.

Planned capabilities include:

- Generating reports based on client data
- Viewing previously generated reports
- Exporting reports to supported formats (e.g., PDF, CSV)

## Architecture / Design

### Layout Structure

The page relies on a shared layout component:

- `HcpScaffold`

`HcpScaffold` provides a consistent UI shell for all HCP-related pages and is responsible for:

- Navigation structure (likely sidebar or header navigation)
- Scroll behavior
- Footer display
- Layout styling for the HCP module

### Scaffold Configuration

The scaffold is configured with the following properties:

- `currentRoute: '/hcp/reports'`
  - Used by the navigation system to mark the Reports section as active.

- `scrollable: true`
  - Allows the page content to scroll when the UI expands beyond the viewport.

- `showFooter: true`
  - Displays the application footer on this page.

### Page Content

The page currently renders placeholder UI consisting of:

- `Center`
- `Text`

Displayed text:
