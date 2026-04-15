# BaseScaffold

## Overview

`BaseScaffold` is a reusable layout scaffold that provides a consistent page structure for all non-admin pages in the application. It standardizes:

- A fixed header at the top  
- A responsive content area with optional scrolling  
- A footer that either scrolls with content or remains fixed at the bottom  
- Optional floating action button support  

This scaffold is intended for general site pages. For admin layouts with side navigation, a separate `AdminScaffold` should be used.

---

## Architecture / Design

### Design Goals

- Enforce a consistent top-level layout across pages.
- Provide responsive max-width constraints for large screens.
- Support both scrollable and non-scrollable page content.
- Ensure header remains fixed and footer behaves predictably.
- Integrate with routing via `go_router`.

### Layout Structure

The layout hierarchy is:

```
Scaffold
 └── SafeArea (top: false)
      └── LayoutBuilder
           └── Column
                ├── Header (optional)
                ├── Expanded (content area)
                │     └── Center
                │          └── ConstrainedBox (maxWidth)
                │               └── Scrollable or Non-scrollable content
                └── Footer (optional, non-scroll mode only)
```

### Header Behavior

- If `showHeader == true`:
  - Uses provided `header` if available.
  - Otherwise falls back to `_DefaultHeader`, which renders a `Header` with empty navigation items.
- `_DefaultHeader` implements `PreferredSizeWidget` with a fixed height of `64`.

### Content Area

The content area:

- Is wrapped in `Expanded` to fill available vertical space.
- Is horizontally centered using `Center`.
- Is width-constrained using:

```dart
BoxConstraints(maxWidth: Breakpoints.maxContent)
```

This prevents content from stretching excessively on ultra-wide displays.

### Scrollable vs Non-Scrollable Modes

#### Scrollable Mode (`scrollable = true`, default)

- Wraps content in `SingleChildScrollView`.
- Renders:
  - Padded `child`
  - Footer appended below content (if `showFooter == true`)
- Footer scrolls with the page.

#### Non-Scrollable Mode (`scrollable = false`)

- Renders content directly (optionally padded).
- If `showFooter == true`, footer is rendered outside `Expanded`, fixed at the bottom of the page.
- Intended for pages that manage their own scrolling (e.g., internal `ListView`).

### Responsive Padding

Padding is responsive based on breakpoint:

- Uses `Breakpoints.isMobile(constraints.maxWidth)`
- On mobile:
  - Ensures padding does not exceed `16` on each side.
- On larger screens:
  - Uses provided `padding` as-is.

---

## Configuration

### Required Dependencies

- Flutter `material`
- `Breakpoints` utility
- `Header` widget
- `Footer` widget
- `go_router` (for footer navigation links)

### Routing Integration

Footer link taps are wired to:

```dart
context.go(route)
```

Ensure `GoRouter` is properly configured in the application.

---

## API Reference

### Constructor

```dart
const BaseScaffold({
  Key? key,
  required Widget child,
  PreferredSizeWidget? header,
  bool showHeader = true,
  bool showFooter = true,
  EdgeInsets padding = const EdgeInsets.all(24),
  bool scrollable = true,
  Widget? floatingActionButton,
})
```

### Parameters

#### `child` (Widget, required)  
The main page content.

#### `header` (PreferredSizeWidget?, optional)  
Custom header widget.  
If `null` and `showHeader == true`, `_DefaultHeader` is used.

#### `showHeader` (bool, optional)  
Whether to render the header.  
Default: `true`

#### `showFooter` (bool, optional)  
Whether to render the footer.  
Behavior differs based on `scrollable`.  
Default: `true`

#### `padding` (EdgeInsets, optional)  
Padding applied around the main content.  
Default:

```dart
EdgeInsets.all(24)
```

On mobile, padding is clamped to a maximum of `16`.

#### `scrollable` (bool, optional)  
Controls whether content is wrapped in `SingleChildScrollView`.

- `true` → outer page scroll  
- `false` → child manages its own scroll  

Default: `true`

#### `floatingActionButton` (Widget?, optional)  
Optional floating action button passed directly to `Scaffold`.

---

## Return Type

Build method returns:

```dart
Scaffold
```

Containing:

- Optional header
- Responsive content area
- Optional footer (scrolling or fixed)
- Optional floating action button

---

## Error Handling

This widget does not throw explicit exceptions but includes layout safeguards.

### Safeguards

- Responsive max width prevents layout overflow on ultra-wide screens.
- Mobile padding is clamped to avoid excessive horizontal spacing.
- Footer placement logic prevents double footers across scroll modes.

### Potential Runtime Considerations

- When `scrollable == false` and `showFooter == true`, ensure the `child` does not require additional bottom spacing that conflicts with the fixed footer.
- If used without a properly configured `GoRouter`, footer navigation will fail.
- `SafeArea(top: false)` assumes the header handles top system insets correctly.

---

## Usage Examples

### Default Scrollable Page

```dart
BaseScaffold(
  header: Header(
    navItems: [...],
    currentRoute: '/dashboard',
  ),
  child: DashboardContent(),
);
```

### Non-Scrollable Page (Internal ListView)

```dart
BaseScaffold(
  header: Header(...),
  scrollable: false,
  showFooter: false,
  child: UsersListPage(),
);
```

### With Floating Action Button

```dart
BaseScaffold(
  header: Header(...),
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: const Icon(Icons.add),
  ),
  child: ContentPage(),
);
```

---

## Related Files

- `breakpoints.dart`
- `basics/header.dart`
- `basics/footer.dart`
- `AdminScaffold`
- `go_router`