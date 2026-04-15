# GraphCard Widget Documentation

**File:** `frontend/lib/src/features/participant/widgets/graph_card.dart`

## Overview

`GraphCard` is a reusable Flutter UI component designed to display charts, graphs, or other analytical visualizations within a styled card layout. It follows the visual structure defined in the application’s design system and is intended for use in dashboards or analytics sections.

The widget provides:

- A titled card container
- A designated graph display area
- A placeholder when no graph content is provided

This component ensures consistent visual styling for analytics cards across participant-facing pages.

## Architecture / Design Explanation

### Widget Type

`GraphCard` is implemented as a `StatelessWidget` because:

- It does not manage internal state.
- All configuration is passed through constructor parameters.

### Layout Structure

The widget renders a card-like container consisting of two sections:

1. **Title Section**
   - Displays the card title at the top.
   - Styled using theme typography and spacing.

2. **Graph Content Area**
   - A container reserved for rendering a chart or graph widget.
   - Displays a placeholder message if no graph widget is provided.

### Styling

The card uses theme constants from `AppTheme`:

- `AppTheme.white` for background color
- `AppTheme.gray` for the border
- `AppTheme.body` typography for the title
- `AppTheme.textPrimary` and `AppTheme.textMuted` for text colors
- `AppTheme.placeholder` for the graph placeholder background

Spacing and layout follow a consistent padding pattern:

- Title padding: `16px`
- Graph container margin: `EdgeInsets.fromLTRB(16, 0, 16, 16)`

### Placeholder Behavior

If no `child` widget is provided, the graph area displays a centered placeholder text:
