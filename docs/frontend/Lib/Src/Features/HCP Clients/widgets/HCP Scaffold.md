# HcpScaffold

File: `frontend/lib/src/features/hcp_clients/widgets/hcp_scaffold.dart`

## Overview

`HcpScaffold` is a reusable layout wrapper for all Healthcare Professional (HCP) pages. It combines the application’s base layout (`BaseScaffold`) with the HCP-specific navigation header (`HcpHeader`) to provide a consistent structure across the HCP section of the application.

This component simplifies page creation by:

- Automatically including the HCP navigation header
- Passing layout configuration to the shared `BaseScaffold`
- Providing a consistent layout for HCP pages such as dashboards, client lists, and reports

Typical usage includes list pages, scrollable dashboards, and pages requiring floating action buttons.

## Architecture / Design

`HcpScaffold` is a thin composition wrapper around two core layout components:

- `BaseScaffold` – the application’s core page layout container
- `HcpHeader` – the HCP-specific navigation header

### Layout Composition

The widget delegates all layout behavior to `BaseScaffold`, while injecting an `HcpHeader` configured with the active route and user interaction callbacks.

Structure:
