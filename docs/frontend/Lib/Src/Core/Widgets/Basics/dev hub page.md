# DevHubPage

**File:** `frontend/lib/src/core/widgets/basics/dev_hub_page.dart`  
**Environment:** Development Only  
**Status:** Must be removed before production release

---

## Overview

`DevHubPage` is a development-only navigation hub that provides quick access to all major application routes during development.

It renders a full-screen scaffold containing grouped route cards for:

- Authentication
- Participant
- Researcher
- Healthcare Professional (HCP)
- Admin

This page is intended to accelerate UI development, testing, and navigation debugging. It should not be included in production builds.

---

## Architecture / Design

`DevHubPage` is implemented as a `StatelessWidget` and structured into the following sections:

### Layout Structure

- **Scaffold**
  - Custom AppBar (orange background for visual distinction)
  - Scrollable body content

- **AppBar**
  - Developer mode icon
  - "DEV HUB" title
  - Close button (`Navigator.pop`)

- **Body**
  - `SingleChildScrollView`
  - Warning banner (red visual indicator)
  - Multiple route sections grouped by user role

---

## Section Architecture

### `_buildSection(...)`

Responsible for rendering:

- Section title
- A responsive `Wrap` of route cards
- Spacing between sections

Uses:

- `Theme.of(context).textTheme.headlineMedium`
- `AppTheme.primary` for heading color

---

### `_buildRouteCard(...)`

Each route card:

- Uses `InkWell` for tap feedback
- Navigates using `context.go(route.path)` (GoRouter)
- Fixed width (180px)
- Styled container with:
  - Border
  - Shadow
  - Rounded corners
  - Icon + label + route path

Navigation is performed using:
