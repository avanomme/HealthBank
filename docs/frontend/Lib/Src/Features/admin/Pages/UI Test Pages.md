# UiTestPage (`ui_test_page.dart`)

## Overview

`UiTestPage` is an interactive widget catalogue used to preview and validate the project’s reusable UI components in one place. It provides:
- A structured list of “showcase cards” for widgets across categories (Micro Widgets, Buttons, Feedback, Data Display, Basics).
- Live previews for each widget.
- Optional property controls (dropdowns, sliders, switches, text inputs) to change widget parameters in real time.
- An expandable “Show Code” panel per widget with copy-to-clipboard.

This page is intended for internal development/testing rather than end-user workflows.

## Architecture / Design

### High-level layout

- The page is wrapped in `AdminScaffold` with:
  - `currentRoute: '/admin/ui-test'`
- The page body is a vertically stacked `Column` containing:
  - Title + subtitle
  - Section headers (`_SectionHeader`)
  - A sequence of `_WidgetShowcase` blocks, each rendering:
    - Header (title, description, code toggle)
    - Live preview (`child`)
    - Optional controls panel (`controls`)
    - Optional code panel (`code`), shown when toggled

This is a “component gallery” design where each component has:
- a representative usage example,
- interactive controls (for parameters most likely to be tweaked),
- and an easily copyable code snippet.

### Page state

`UiTestPage` is a `StatefulWidget`. `_UiTestPageState` maintains state for:
- currently selected enum values (variants/sizes),
- colors,
- toggles (booleans),
- numeric values (sliders),
- text input contents via `TextEditingController`,
- DataTable expanded row index for demo expansion.

The state is localized to this page; no providers are used.

### Widget showcase system

The showcase system is implemented by two private widgets:

- `_WidgetShowcase`
  - A card container for a single widget demo.
  - Accepts:
    - `title`, `description`, `code`, `child`, optional `controls`
  - Maintains local state `_showCode` to toggle the code display.
  - Includes copy-to-clipboard action using `Clipboard.setData`.
  - Uses a horizontal `SingleChildScrollView` for code blocks to prevent overflow.

- `_SectionHeader`
  - Renders a section title with a primary-colored accent bar.

### Control helpers

The page includes private helper methods to standardize control creation:

- `_control(label, input)`
  - Small inline label + widget row.

- `_enumDropdown<T>(value, items, onChanged)`
  - Generic dropdown for enum-like selections.

- `_colorDropdown(value, onChanged)`
  - Dropdown showing a colored dot + name.
  - Uses `_colorOptions` map to constrain allowed choices.

- `_toggle(value, onChanged)`
  - Compact switch control.

- `_textField(controller, onChanged)`
  - Small fixed-size text field used in controls panels.

Additionally, helper methods translate selected values into code-friendly strings for the code snippet panel:

- `_colorName(Color)`
- `_weightName(FontWeight)`
- `_fitName(BoxFit)`
- `_fitName` relies on `_fitOptions` mapping.

### Sections and showcased components

The page groups demos into categories. Based on the file contents, it demonstrates:

**Micro Widgets**
- `AppText` (variant/color/weight + editable text)
- `AppRichText` (variant selector; demonstrates inline spans)
- `AppBadge` (label/variant/size)
- `AppIcon` (icon selector + color)
- `AppStatusDot` (notification toggle + count)
- `AppDivider` (thickness + spacing sliders)
- `AppCheckbox` (tristate + enabled toggles)
- `AppRadio` (enabled toggle; group selection in preview)

**Buttons**
- `AppFilledButton` (color + disabled toggle)
- `AppTextButton` (color + disabled toggle)
- `AppLongButton` (color + disabled toggle)

**Feedback**
- `AppAnnouncement` (message, background, text color, icon toggle)
- `AppPopover` (message, background/text colors, icon toggle, arrow placement)
  - Uses `_showPopover()` to open a dialog containing `AppPopover`.
- `AppToast` (buttons triggering `AppToast.showSuccess/showError/showCaution/showInfo`)

**Data Display**
- `AppCardTask`
- `AppGraphRenderer` (with an example “bar” layout using containers)
- `AppProgressBar` (progress + height sliders, track/fill colors)
- Custom `DataTable` demo with expandable rows and `DataTableCell` usage
- `DataTableCell` “typed factories” demo (text/badge/status/date/avatar)
- `AppStatCard` (color/icon/subtitle toggles)
- `AppBarChart` (color + value label toggle)
- `AppPieChart` (legend toggle)

**Basics**
- `HealthBankLogo` (size + tagline toggle)
- `AppAccordion` (initially expanded toggle)
- `AppBreadcrumbs` (active breadcrumb index selector)
- `AppDropdownMenu` (selection state)
- `AppModal` (dialog modal demo)
- `AppImage` (aspect ratio/fit, optional width/height, radius toggle, semantics)
- `AppPlaceholderGraphic` (asset/ratio/fit/radius/semantics)

### Accessibility and semantics

Two showcased widgets explicitly expose semantics controls:
- `AppImage`:
  - `semanticLabel` via controller
  - `excludeFromSemantics` toggle
- `AppPlaceholderGraphic`:
  - `semanticLabel` via controller
  - `excludeFromSemantics` toggle

This page therefore doubles as a quick manual validation tool for semantic labeling behavior.

## Configuration

No external configuration is required, but the page depends on the presence of many internal widget libraries and assets.

Required assets (inferred from usage):
- `assets/example_image.jpg`
- `assets/placeholder_image.jpg`

These must be declared in `pubspec.yaml` under `flutter/assets`.

Dependencies expected to exist in the codebase (imports in this file):
- `AdminScaffold` from `frontend/src/features/admin/widgets/widgets.dart`
- Theme tokens from `frontend/src/core/theme/theme.dart`
- Numerous component libraries under:
  - `frontend/src/core/widgets/basics/*`
  - `frontend/src/core/widgets/buttons/*`
  - `frontend/src/core/widgets/data_display/*`
  - `frontend/src/core/widgets/feedback/*`
  - `frontend/src/core/widgets/micro/*`

Flutter services dependency:
- Uses `Clipboard` (`package:flutter/services.dart`) for code copy action.

## API Reference

## `UiTestPage`

Interactive UI widget catalogue page.

### Constructor

`const UiTestPage({Key? key})`

#### Parameters
- `key` (`Key?`): Optional Flutter widget key.

#### Returns
- An instance of `UiTestPage`.

### Public Members

#### `createState() -> State<UiTestPage>`

Returns:
- `_UiTestPageState`

---

## `_UiTestPageState`

Maintains demo configuration state and renders the catalogue.

### Lifecycle

#### `initState() -> void`

Initializes `TextEditingController` instances used by demo controls:
- `_textContentCtrl`
- `_badgeLabelCtrl`
- `_announcementMsgCtrl`
- `_popoverMsgCtrl`
- `_toastMsgCtrl`
- `_appImageSemanticLabelCtrl`
- `_placeholderSemanticLabelCtrl`

#### `dispose() -> void`

Disposes all controllers created in `initState()`.

### Rendering

#### `build(BuildContext context) -> Widget`

Builds the UI catalogue screen:
- Header (title + subtitle)
- Sections (`_SectionHeader`)
- Many `_WidgetShowcase` cards with live previews and controls

### Helpers

#### `_colorName(Color c) -> String`

Maps a `Color` instance to a string resembling `AppTheme.<name>` based on `_colorOptions`.

Returns:
- `String`: A best-effort theme token name; defaults to `AppTheme.primary` if not found.

#### `_weightName(FontWeight w) -> String`

Maps a `FontWeight` instance to a `FontWeight.<name>` string based on `_fontWeights`.

Returns:
- `String`: A best-effort weight name; defaults to `FontWeight.normal` if not found.

#### `_fitName(BoxFit fit) -> String`

Maps a `BoxFit` instance to a string resembling `BoxFit.<name>` based on `_fitOptions`.

Returns:
- `String`: A best-effort fit name; defaults to `BoxFit.cover` if not found.

#### `_showPopover(BuildContext context) -> void`

Opens a dialog containing an `AppPopover`.

Dialog characteristics:
- `barrierDismissible: true`
- `barrierColor: Colors.black` with low alpha
- Transparent dialog background

Popover configuration:
- Uses current state values for message/background/text/icon/arrow placement.

#### `_control(String label, Widget input) -> Widget`

Creates a labeled inline control row used in properties panels.

#### `_enumDropdown<T>(T value, Map<T, String> items, ValueChanged<T> onChanged) -> Widget`

Generic dropdown for selecting values (commonly enums).

Parameters:
- `value` (`T`)
- `items` (`Map<T, String>`)
- `onChanged` (`ValueChanged<T>`)

#### `_colorDropdown(Color value, ValueChanged<Color> onChanged) -> Widget`

Dropdown for selecting theme colors from `_colorOptions`. Displays a color dot and label.

#### `_toggle(bool value, ValueChanged<bool> onChanged) -> Widget`

Compact switch control.

#### `_textField(TextEditingController controller, VoidCallback onChanged) -> Widget`

Compact text field used in controls panels.

#### `_cellDemo(String label, Widget cell) -> Widget`

Small helper to render labeled DataTableCell previews with a border.

---

## `_SectionHeader`

Section header with accent bar.

### Constructor

`const _SectionHeader({required String title})`

#### Parameters
- `title` (`String`): Section title text.

#### Returns
- An instance of `_SectionHeader`.

### Public Members

#### `build(BuildContext context) -> Widget`

Renders:
- Vertical accent bar (primary color)
- Section title text styled from `headlineSmall`

---

## `_WidgetShowcase`

Showcase card component for a single widget demo, with optional controls and expandable code.

### Constructor

`const _WidgetShowcase({required String title, required String description, required String code, required Widget child, Widget? controls})`

#### Parameters
- `title` (`String`): Widget name.
- `description` (`String`): Brief explanation.
- `code` (`String`): Code snippet shown in the “Show Code” panel.
- `child` (`Widget`): Live preview widget.
- `controls` (`Widget?`): Optional properties panel UI.

#### Returns
- An instance of `_WidgetShowcase`.

### Public Members

#### `createState() -> State<_WidgetShowcase>`

Returns:
- `_WidgetShowcaseState`

---

## `_WidgetShowcaseState`

Manages the show/hide state of the code panel.

### State
- `_showCode` (`bool`): Whether the code panel is visible.

### Public Members

#### `build(BuildContext context) -> Widget`

Renders the showcase card:
- Title/description header
- Code toggle button
- Live preview
- Optional properties panel
- Optional code panel:
  - Horizontally scrollable
  - `SelectableText` with monospace styling
  - Copy-to-clipboard button
  - Snackbar confirmation (“Code copied to clipboard”)

## Error Handling

This page is primarily static and does not fetch remote data. Error handling is limited to safe usage patterns:

- Controller lifecycle:
  - All `TextEditingController` instances are disposed to prevent leaks.

- Dialog presentation:
  - Popover and modal examples use `showDialog` with appropriate `dialogContext` scoping for `Navigator.pop`.

Potential runtime considerations (dependent on surrounding project setup):
- Asset loading failures (for `AppImage` / `AppPlaceholderGraphic`) if asset paths are not present or not declared in `pubspec.yaml`.
- Clipboard behavior depends on platform support; failure would typically be handled by the framework, but this page assumes clipboard availability.

## Usage Examples

### Route registration

```dart
routes: {
  '/admin/ui-test': (_) => const UiTestPage(),
}