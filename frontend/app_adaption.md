# HealthBank Frontend Responsive Adaptation Plan

This document outlines the responsive design strategy and all fixes needed for proper adaptation across phones, tablets, and desktops.

**Core Principle:** Fix at the highest level possible to minimize code changes. Changes to scaffolds and base widgets cascade to all child pages.

---

## Design Guidelines

### Key Pattern: Scroll at Page Level, Flex Inside

```
Scaffold > SafeArea > LayoutBuilder > SingleChildScrollView > Column
```

- **One scrollable root** (usually vertical SingleChildScrollView or CustomScrollView)
- **Inside that**, use Columns/Rows with `Expanded`/`Flexible`/`Wrap` to avoid overflow
- **Buttons stay fixed** - never scroll away action buttons
- **Tables get horizontal scroll** when they can overflow

### Shared Breakpoints

Create `lib/src/core/theme/breakpoints.dart`:

```dart
/// Consistent breakpoints across the app
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double maxContent = 1200; // Max content width on ultrawide

  static bool isMobile(double width) => width < mobile;
  static bool isTablet(double width) => width >= mobile && width < tablet;
  static bool isDesktop(double width) => width >= tablet;
}
```

### Localization Considerations

All responsive changes must preserve localization:
- Use `context.l10n.*` for all user-facing strings
- Text in `Wrap` widgets handles long translations better than `Row`
- Button labels may vary in length (e.g., French "Ouvrir une session" vs English "Login")
- Use `Flexible` on text buttons to allow wrapping/ellipsis

---

## Priority 1: Core Shell Pattern (Highest Impact)

### 1.1 Create ResponsivePageShell

**File:** `lib/src/core/widgets/layout/responsive_page_shell.dart` (NEW)

This replaces scattered responsive logic with one reusable shell:

```dart
class ResponsivePageShell extends StatelessWidget {
  const ResponsivePageShell({
    super.key,
    required this.child,
    this.maxWidth = 1200,
    this.padding = const EdgeInsets.all(24),
    this.mobilePadding = const EdgeInsets.all(16),
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsets padding;
  final EdgeInsets mobilePadding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < Breakpoints.mobile;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: SingleChildScrollView(
                padding: isMobile ? mobilePadding : padding,
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
```

### 1.2 Update BaseScaffold

**File:** `lib/src/core/widgets/layout/base_scaffold.dart`

**Current Issues:**
- Good structure but could use ResponsivePageShell pattern
- Ensure all pages using it benefit from consistent responsive behavior

**Changes Required:**
- [ ] Import and use shared Breakpoints
- [ ] Ensure SafeArea is properly applied
- [ ] Add maxWidth constraint for ultrawide screens

### 1.3 Update AdminScaffold

**File:** `lib/src/features/admin/widgets/admin_scaffold.dart`

**Current Issues:**
- Sidebar doesn't collapse properly on mobile (partially fixed)
- Content area needs horizontal scroll protection for tables

**Changes Required:**
- [ ] Ensure mobile drawer works correctly
- [ ] Add ConstrainedBox(maxWidth) to content area
- [ ] Preserve all `context.l10n.*` strings

---

## Priority 2: Action Rows (Horizontal Overflow Prevention)

### Pattern for Action Buttons

```dart
class ResponsiveActionsRow extends StatelessWidget {
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTight = width < 400;

    if (isTight) {
      // Stack vertically on narrow screens
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: actions.expand((a) => [a, const SizedBox(height: 8)]).toList()
          ..removeLast(),
      );
    }

    // Horizontal with auto-wrapping
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: actions,
    );
  }
}
```

### Files Requiring Action Row Updates:

| File | Issue | Lines |
|------|-------|-------|
| `login_form.dart` | Forgot Password + Login button row | 146-190 |
| `survey_builder_page.dart` | Action buttons in header | Check |
| `template_builder_page.dart` | Action buttons in header | Check |

---

## Priority 3: Data Tables (Horizontal Scroll)

### Pattern for Responsive Tables

```dart
// Wrap any table/data grid in horizontal scroll
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: ConstrainedBox(
    constraints: BoxConstraints(
      minWidth: MediaQuery.of(context).size.width,
    ),
    child: YourTableWidget(),
  ),
);
```

### Files Requiring Table Fixes:

| File | Issue | Lines | Impact |
|------|-------|-------|--------|
| `user_management_page.dart` | User table without horizontal scroll | 313-378 | HIGH |
| `database_viewer_page.dart` | Schema view without horizontal scroll | 461-576 | HIGH |
| `user_management_page.dart` | Dialog with fixed 400px width | 659 | MEDIUM |

---

## Priority 4: Cards & Grids

### Pattern for Responsive Grid

```dart
class ResponsiveCardsGrid extends StatelessWidget {
  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    int crossAxisCount;
    if (width < Breakpoints.mobile) {
      crossAxisCount = 1;
    } else if (width < Breakpoints.tablet) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 3;
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: cards,
    );
  }
}
```

### Files with Hard-coded Widths to Fix:

| File | Issue | Lines |
|------|-------|-------|
| `participant_dashboard_page.dart` | `maxWidth: 500` on task cards | 139-157 |
| `login_card.dart` | `maxWidth: 400` hard-coded | 44 |
| `logout_page.dart` | `maxWidth: 450` hard-coded | 73 |
| `dev_nav_button.dart` | `width: 400` | 42 |
| `dev_hub_page.dart` | `width: 180` for route cards | 136 |

---

## Priority 5: Dialogs

### Pattern for Responsive Dialog

```dart
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final dialogWidth = screenWidth < 540
      ? screenWidth * 0.9
      : 500.0;

  return AlertDialog(
    content: SizedBox(
      width: dialogWidth,
      child: // content
    ),
  );
}
```

### Files with Dialog Fixes Needed:

| File | Status | Notes |
|------|--------|-------|
| `question_bank_form_dialog.dart` | DONE | Responsive width implemented |
| `survey_preview_dialog.dart` | DONE | Responsive maxWidth implemented |
| `template_preview_dialog.dart` | DONE | Responsive maxWidth implemented |
| `user_management_page.dart` | TODO | Line 659 needs responsive width |

---

## Implementation Checklist

### Phase 1: Core Infrastructure
- [ ] Create `lib/src/core/theme/breakpoints.dart`
- [ ] Create `lib/src/core/widgets/layout/responsive_page_shell.dart`
- [ ] Update `BaseScaffold` to use shared breakpoints
- [ ] Update `AdminScaffold` for proper mobile support

### Phase 2: Scaffolds & Headers
- [ ] Verify `Header` responsive behavior (DONE)
- [ ] Verify `ParticipantScaffold` (inherits from BaseScaffold)
- [ ] Verify `ResearcherScaffold` (inherits from BaseScaffold)
- [ ] Verify `HcpScaffold` (inherits from BaseScaffold)

### Phase 3: Data Tables
- [ ] `user_management_page.dart` - Add horizontal scroll to table
- [ ] `database_viewer_page.dart` - Add horizontal scroll to schema view

### Phase 4: Forms & Dialogs
- [ ] `login_card.dart` - Use Breakpoints constant
- [ ] `logout_page.dart` - Use Breakpoints constant
- [ ] `user_management_page.dart` dialog - Make responsive

### Phase 5: Dashboard Cards
- [ ] `participant_dashboard_page.dart` - Remove hard-coded widths
- [ ] Consider creating `ResponsiveCardsGrid` widget

---

## Testing Checklist

After all fixes, test at these widths:
- [ ] 320px (small phone)
- [ ] 375px (iPhone SE/standard)
- [ ] 414px (iPhone Plus/Max)
- [ ] 768px (tablet portrait)
- [ ] 1024px (tablet landscape)
- [ ] 1280px (laptop)
- [ ] 1920px (desktop)

Verify:
1. No yellow/black overflow warning strips
2. All buttons remain accessible (not scrolled away)
3. Tables scroll horizontally when needed
4. Localized text (especially French) fits without overflow
5. Action buttons wrap or stack on narrow screens

---

## Files Summary

| Priority | File | Issue | Cascades To |
|----------|------|-------|-------------|
| P1 | `breakpoints.dart` | NEW - shared constants | All files |
| P1 | `responsive_page_shell.dart` | NEW - reusable shell | All pages |
| P1 | `base_scaffold.dart` | Use shared breakpoints | All non-admin pages |
| P1 | `admin_scaffold.dart` | Mobile drawer, max-width | All admin pages |
| P2 | `header.dart` | DONE - responsive nav | All pages with header |
| P3 | `user_management_page.dart` | Table scroll, dialog | Admin user mgmt |
| P3 | `database_viewer_page.dart` | Schema table scroll | Admin database |
| P4 | `login_card.dart` | Use Breakpoints | Login page |
| P4 | `logout_page.dart` | Use Breakpoints | Logout page |
| P4 | `participant_dashboard_page.dart` | Remove fixed widths | Participant dashboard |
| P5 | `dev_nav_button.dart` | Fixed width | Dev tools only |
| P5 | `dev_hub_page.dart` | Fixed card width | Dev tools only |
