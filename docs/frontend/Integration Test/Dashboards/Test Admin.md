# Admin Dashboard E2E Tests (Playwright)

End-to-end (E2E) tests for the Admin Dashboard using Playwright (synchronous Python API).

These tests validate:

- Unauthenticated access control for `/admin`
- Rendering of core admin dashboard UI sections
- Presence of primary admin actions
- Navigation links to Templates and Surveys
- Role isolation between Admin and Participant dashboards

## Overview

This test module uses Playwright’s `page` fixture to drive a real browser session against a running frontend application.

It assumes:

- The application is running locally at `http://localhost:8080`
- Routing is client-side or server-side but URL changes reflect navigation
- Accessibility roles (`role`, `aria-label`, region landmarks) are correctly implemented in the UI

All assertions use:

```python
from playwright.sync_api import expect