# Participant Dashboard E2E Tests (Playwright)

End-to-end (E2E) tests for the Participant Dashboard using Playwright (synchronous Python API).

These tests validate:

- Unauthenticated access control for `/p`
- Rendering of the participant dashboard’s core UI sections
- Presence of “Start Survey” action(s) in the todo list area
- Presence of “Compare to Aggregate” action
- Navigation links to Surveys and Privacy Policy
- Role isolation (participant cannot access researcher or admin dashboards)

## Overview

This test module uses Playwright’s `page` fixture to drive a real browser session against a running frontend application.

It assumes:

- The application is running locally at `http://localhost:8080`
- Routing updates the browser URL when navigating
- Accessibility roles (`role`, accessible `name`, and region landmarks) are correctly implemented

All assertions use:

```python
from playwright.sync_api import expect