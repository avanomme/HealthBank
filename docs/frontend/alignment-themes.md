# Alignment Themes

Frontend page shells now use semantic alignment themes instead of page-local `EdgeInsets` and ad hoc max-width constraints.

## Alignment Theme System

Shared alignment behavior is implemented by these core files:

| File | Purpose |
|------|---------|
| `frontend/lib/src/core/theme/page_alignment.dart` | Defines `AppPageAlignment`, `AppPageAlignmentSpec`, and the breakpoint-resolved theme extension |
| `frontend/lib/src/core/widgets/layout/page_shell.dart` | Defines `AppPageBodyBehavior`, `AppPageAlignmentScope`, `AppPageAlignedContent`, and the `BuildContext` helpers |
| `frontend/lib/src/core/widgets/layout/base_scaffold.dart` | Applies the resolved shell padding and width constraints for non-admin page scaffolds |

The alignment theme is attached to `ThemeData` and resolved per breakpoint, so pages choose a semantic category and let the scaffold own the shell metrics.

## Core Types

### `AppPageAlignment`

Semantic shell categories used by scaffolds and page shells.

#### Location

`frontend/lib/src/core/theme/page_alignment.dart`

#### Values

| Value | Description |
|------|-------------|
| `AppPageAlignment.regular` | Standard shell spacing for normal content pages |
| `AppPageAlignment.compact` | Denser shell spacing for data-dense pages |
| `AppPageAlignment.wide` | Readable content column for creation, completion, public, and legal pages |
| `AppPageAlignment.sidebarRegular` | Comfortable spacing for sidebar layouts |
| `AppPageAlignment.sidebarCompact` | Denser spacing for operational sidebar layouts |

### `AppPageBodyBehavior`

Controls whether the scaffold applies the resolved shell padding directly.

#### Location

`frontend/lib/src/core/widgets/layout/page_shell.dart`

#### Values

| Value | Description |
|------|-------------|
| `AppPageBodyBehavior.padded` | Scaffold applies resolved padding and content width directly |
| `AppPageBodyBehavior.edgeToEdge` | Scaffold keeps the alignment scope, but the page is responsible for applying aligned sections itself |

### `AppPageAlignedContent`

Reusable wrapper for centered constrained sections on full-bleed pages. It resolves the current alignment from `AppPageAlignmentScope` unless an explicit alignment is passed.

#### Location

`frontend/lib/src/core/widgets/layout/page_shell.dart`

## Breakpoint Metrics

Resolved alignment specs are defined in `AppPageAlignmentTheme.forBreakpoint`.

### Compact Breakpoint

| Alignment | Horizontal | Top | Bottom | Max Width |
|------|------|------|------|------|
| `regular` | `16` | `20` | `24` | `Breakpoints.maxContent` |
| `compact` | `12` | `16` | `20` | `double.infinity` |
| `wide` | `16` | `20` | `24` | `880` |
| `sidebarRegular` | `16` | `16` | `20` | `double.infinity` |
| `sidebarCompact` | `12` | `16` | `20` | `double.infinity` |

### Medium Breakpoint

| Alignment | Horizontal | Top | Bottom | Max Width |
|------|------|------|------|------|
| `regular` | `20` | `24` | `28` | `Breakpoints.maxContent` |
| `compact` | `16` | `20` | `24` | `double.infinity` |
| `wide` | `20` | `24` | `28` | `920` |
| `sidebarRegular` | `20` | `20` | `24` | `double.infinity` |
| `sidebarCompact` | `16` | `20` | `24` | `double.infinity` |

### Expanded Breakpoint

| Alignment | Horizontal | Top | Bottom | Max Width |
|------|------|------|------|------|
| `regular` | `24` | `24` | `32` | `Breakpoints.maxContent` |
| `compact` | `20` | `20` | `24` | `double.infinity` |
| `wide` | `32` | `24` | `32` | `960` |
| `sidebarRegular` | `24` | `20` | `24` | `double.infinity` |
| `sidebarCompact` | `20` | `20` | `24` | `double.infinity` |

## Scaffold Integration

The following scaffolds accept semantic `alignment` and `bodyBehavior`:

| Scaffold | Notes |
|------|---------|
| `BaseScaffold` | Shared non-admin shell |
| `ParticipantScaffold` | Participant shell wrapper |
| `ResearcherScaffold` | Researcher shell wrapper |
| `HcpScaffold` | HCP shell wrapper |
| `MessagingScaffold` | Messaging shell wrapper |
| `AdminScaffold` | Admin shell with sidebar layout handling |

### Standard Usage

Use the default padded shell when the entire page body should inherit shared shell spacing.

```dart
return ParticipantScaffold(
  currentRoute: '/participant/results',
  alignment: AppPageAlignment.regular,
  child: YourContent(),
);
```

### Edge-to-Edge Usage

Use `edgeToEdge` when the page needs full-bleed layout regions, split panes, or a flush sidebar/rail.

```dart
return ResearcherScaffold(
  currentRoute: '/researcher/dashboard',
  alignment: AppPageAlignment.sidebarCompact,
  bodyBehavior: AppPageBodyBehavior.edgeToEdge,
  scrollable: false,
  child: Row(
    children: [
      const DashboardSidebar(),
      Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: context.resolvePageAlignment().bodyPadding,
            child: const DashboardContent(),
          ),
        ),
      ),
    ],
  ),
);
```

### Centered Sections on Full-Bleed Pages

Use `AppPageAlignedContent` when only part of the page should be constrained.

```dart
return BaseScaffold(
  header: header,
  alignment: AppPageAlignment.regular,
  bodyBehavior: AppPageBodyBehavior.edgeToEdge,
  scrollable: false,
  child: Column(
    children: [
      const FullBleedToolbar(),
      AppPageAlignedContent(
        child: YourConstrainedSection(),
      ),
    ],
  ),
);
```

## Ownership Rules

1. Scaffolds choose the semantic alignment category.
2. `padded` shells own outer page padding and max-width behavior directly.
3. `edgeToEdge` shells keep the alignment scope, but the page must place `Padding` or `AppPageAlignedContent` where needed.
4. Cards and inner widgets should keep internal spacing only and should not reintroduce shell gutters.
5. Raw `padding` and `maxWidth` overrides are escape hatches, not the default path.

## Current Conventions

### Public and Legal Pages

Help, Contact Us, Privacy Policy, and Terms of Use should use `AppPageAlignment.wide`.

### Sidebar Dashboards

Pages with a flush sidebar or rail should use `AppPageBodyBehavior.edgeToEdge` and apply the resolved alignment padding only to the main content pane.

### Dense Operational Screens

Data-heavy list, table, and management views should generally prefer `compact` or `sidebarCompact`, depending on whether the page includes a persistent side rail.

## Migration Guidance

When updating an older page:

1. Replace hard-coded shell `Padding` and page-level max-width wrappers with a semantic scaffold `alignment`.
2. Keep `bodyBehavior: padded` unless the page truly needs full-bleed regions.
3. If the page has a flush sidebar, split pane, or toolbar that should ignore shell gutters, switch to `edgeToEdge`.
4. Use `context.resolvePageAlignment()` inside edge-to-edge pages when you need the resolved `bodyPadding` or `maxContentWidth`.
5. Keep local padding for cards, form groups, and inner layout only.
