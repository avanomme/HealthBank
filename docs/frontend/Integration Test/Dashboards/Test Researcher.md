# Researcher Dashboard E2E Tests (Playwright)

End-to-end (E2E) tests for the Researcher Dashboard using Playwright (synchronous Python API).

These tests validate:

- Unauthenticated access control for `/r`
- Rendering of core researcher dashboard sections
- Presence of chart-type toggles (Pie, Bar, Line)
- Presence of CSV export functionality
- Navigation to Surveys and Question Bank
- Role isolation (researcher cannot access admin dashboard)

## Overview

This test module uses Playwright’s `page` fixture to drive a real browser session against a running frontend application.

It assumes:

- The frontend is running at `http://localhost:8080`
- Routing updates the browser URL appropriately
- The UI uses semantic accessibility roles and labels

All assertions use:

```python
from playwright.sync_api import expect