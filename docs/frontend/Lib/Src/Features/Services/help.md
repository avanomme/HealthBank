# HelpPage

## Overview

`HelpPage` is a role-aware help/how-to-use screen that renders the appropriate header navigation based on the authenticated user’s role and displays help content as accordion sections. It uses Riverpod to read authentication state and to manage accordion expansion state.

This page:

* Chooses a header for **participant**, **researcher**, **hcp**, **admin**, or **unauthenticated/unknown** users
* Displays a title (`footerHowToUse`) and a set of expandable help sections using `AppAccordion`
* Persists accordion open/closed state in a `StateNotifier` (`_AccordionStateNotifier`)

File: (not provided in snippet)

## Architecture / Design

* **Widget type:** `ConsumerWidget` (Riverpod-aware stateless UI)
* **Layout wrapper:** `BaseScaffold` with:

  * `header`: determined by the user’s role
  * `showFooter: true`
  * `scrollable: true`
* **Role-based header selection:**

  * `participant` → `ParticipantHeader(currentRoute: '/help')`
  * `researcher` → `ResearcherHeader(currentRoute: '/help')`
  * `hcp` → `HcpHeader(currentRoute: '/help')`
  * `admin` → base `Header` with no nav items
  * default/unauthenticated → base `Header` with Home/Privacy/Terms nav items
* **Help content:** A list of `AppAccordion` widgets (currently placeholder sections) with expansion state managed via `_accordionStateProvider`.

## Configuration

`HelpPage` has no constructor parameters beyond `key`.

Key dependencies:

* `authProvider` (from `frontend/src/features/auth/state/auth_providers.dart`) for `user.role`
* `ParticipantHeader`, `ResearcherHeader`, `HcpHeader` for role navigation
* `AppAccordion` for expandable help sections
* `AppTheme` and `context.l10n` for styling and localization

## API Reference

## `class HelpPage extends ConsumerWidget`

Build steps:

1. Read localization: `final l10n = context.l10n;`
2. Read auth state: `final authState = ref.watch(authProvider);`
3. Determine role: `final role = authState.user?.role;`
4. Choose `PreferredSizeWidget header` via `switch (role)`
5. Build `accordionSections`:

   * Generates 3 `AppAccordion` entries
   * Each uses `initiallyExpanded: ref.watch(_accordionStateProvider)[i]`
   * Uses `onChanged` to call `toggle(i)` on notifier
6. Return `BaseScaffold` containing a title and the accordions

## Accordion state

### `_accordionStateProvider : StateNotifierProvider<_AccordionStateNotifier, List<bool>>`

Stores which accordion indices are expanded. Default state is `[false, false, false]`.

### `_AccordionStateNotifier extends StateNotifier<List<bool>>`

* `toggle(int index)` flips the boolean at the given index and leaves others unchanged.

## Error Handling

* No explicit error handling.
* Assumes:

  * `authProvider` returns an object where `user?.role` is a string matching the expected role keys
  * `_accordionStateProvider` list length matches the generated accordion count (3). If these diverge, indexing errors may occur.

## Usage Examples

### Route usage

```
GoRoute(
  path: '/help',
  builder: (context, state) => const HelpPage(),
)
```

### Modifying accordion count

If you increase the number of sections, ensure `_AccordionStateNotifier` initializes with the same length as the generated list.

## Related Files

* `frontend/src/core/widgets/layout/base_scaffold.dart` — Page layout wrapper
* `frontend/src/core/widgets/basics/header.dart` — Base header used for admin/default
* `frontend/src/features/participant/widgets/participant_header.dart`
* `frontend/src/features/researcher/widgets/researcher_header.dart`
* `frontend/src/features/hcp_clients/widgets/hcp_header.dart`
* `frontend/src/features/auth/state/auth_providers.dart` — `authProvider` role source
* `frontend/src/core/widgets/basics/app_accordion.dart` — Accordion component used for help sections
* `frontend/src/core/theme/theme.dart` — `AppTheme` styles
* `frontend/src/core/l10n/l10n.dart` — Localization strings (e.g., `footerHowToUse`, nav labels)
