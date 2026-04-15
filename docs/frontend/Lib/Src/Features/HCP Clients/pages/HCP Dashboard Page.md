# HcpDashboardPage

File: `frontend/lib/src/features/hcp_clients/pages/hcp_dashboard_page.dart`

## Overview

`HcpDashboardPage` is a `StatelessWidget` representing the Healthcare Professional (HCP) dashboard within the application. The page serves as the main landing area for users with the HCP role.

In the current implementation, the page is a placeholder that renders inside the role-specific `HcpScaffold` layout and displays centered text indicating that the dashboard functionality has not yet been implemented.

The intended responsibilities of this page include:

- Providing an overview of clients assigned to the HCP
- Offering quick access to reporting tools
- Displaying relevant notifications and alerts
- Acting as the primary navigation entry point for HCP workflows

## Architecture / Design

The page is intentionally minimal and relies on a shared role-specific layout wrapper to maintain consistent UI structure across all HCP pages.

### Layout Wrapper

The page is built using the `HcpScaffold` widget, which is responsible for providing:

- HCP navigation structure (likely sidebar or header navigation)
- Consistent layout styling across HCP pages
- Footer visibility control
- Scroll management

The scaffold receives configuration parameters:

- `currentRoute: '/hcp/dashboard'`
  - Allows the navigation system to highlight the active route.
- `scrollable: true`
  - Enables scrolling for the page content.
- `showFooter: true`
  - Ensures the standard application footer is displayed.

### Page Content

The current implementation contains a simple placeholder layout:

- A `Center` widget
- A `Text` widget displaying:
