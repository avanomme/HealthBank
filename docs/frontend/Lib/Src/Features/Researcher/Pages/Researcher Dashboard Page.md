# ResearcherDashboardPage

## Overview

`ResearcherDashboardPage` is the main landing page for researcher users. It serves as the dashboard where researchers will eventually see an overview of their surveys, quick access to creating new surveys, and analytics summaries.

The current implementation is a placeholder page wrapped in the researcher layout scaffold.

File: `frontend/lib/src/features/researcher/pages/researcher_dashboard_page.dart`

## Architecture / Design

The page is implemented as a `StatelessWidget` and uses the shared `ResearcherScaffold` layout component to provide consistent navigation and page structure for researcher-facing views.

Layout structure:

ResearcherScaffold
└── Center
  └── Text (placeholder content)

Key scaffold configuration:

* `currentRoute` is set to `/researcher/dashboard` so the navigation header highlights the dashboard route.
* `scrollable` is enabled to allow future dashboard content to scroll.
* `showFooter` is enabled for consistent layout with other researcher pages.

The content currently displays a placeholder message until dashboard functionality is implemented.

## Configuration

Constructor:

```
const ResearcherDashboardPage({ Key? key })
```

No additional parameters are required.

## API Reference

Class: `ResearcherDashboardPage extends StatelessWidget`

Properties:

* None (static page)

Build behavior:

Returns a `ResearcherScaffold` configured with:

* `currentRoute: '/researcher/dashboard'`
* `scrollable: true`
* `showFooter: true`

The scaffold child is a centered text widget displaying a placeholder message.

## Error Handling

This widget does not implement error handling because it contains no dynamic data or asynchronous logic.

## Usage Examples

Basic route usage:

```
routes: {
  '/researcher/dashboard': (context) => const ResearcherDashboardPage(),
}
```

Direct widget usage:

```
const ResearcherDashboardPage()
```

## Related Files

* `frontend/lib/src/features/researcher/widgets/researcher_scaffold.dart` — Provides the base page layout and navigation for researcher pages.
