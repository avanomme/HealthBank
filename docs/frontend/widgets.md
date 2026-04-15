<!-- Created with the Assistance of Codex -->
# HealthBank Widget Reference

> **Rule #1**: If a widget exists here, use it. Never build a one-off equivalent inline.
> **Rule #2**: All user-facing strings go through `context.l10n`. No hardcoded display text.
> **Rule #3**: All colours and typography come from `AppTheme`. No raw `Color(0xFF...)` or `TextStyle(fontSize: ...)` in pages.

---

## Table of Contents

1. [Consistency Rules](#1-consistency-rules)
2. [Layout & Scaffolds](#2-layout--scaffolds)
3. [Typography](#3-typography)
4. [Buttons](#4-buttons)
5. [Form Inputs](#5-form-inputs)
6. [Feedback & State](#6-feedback--state)
7. [Data Display](#7-data-display)
8. [Micro / Utility](#8-micro--utility)
9. [Feature Widgets](#9-feature-widgets)
10. [Remaining TODOs](#10-remaining-todos)

---

## 1. Consistency Rules

### Accessibility ownership

- Accessibility semantics are required for widgets that create user meaning: form controls, custom interactive widgets, status surfaces, charts, and repeated layout regions.
- Shared widgets own semantics when the shared widget owns the meaning. Do not patch the same semantics wrapper into multiple pages when the fix belongs in `frontend/lib/src/core/widgets`.
- Feature widgets must supply contextual semantic text when the shared widget cannot know the item-specific meaning by itself, such as icon-only actions for a specific row or card.
- Semantics QA is not complete because a `Semantics` widget exists. The behavior must be verified in tests and, for web shell behavior, by checking actual route/title/keyboard flow where feasible.
- Generated localization files are not the source of truth during accessibility work. Update ARB/source localization files and regenerate `app_localizations*.dart` instead of hand-merging generated output.

### Import pattern

Every page imports from the barrel files — never individual widget paths:

```dart
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/core/widgets/forms/forms.dart';
import 'package:frontend/src/core/widgets/micro/micro.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
```

### Page structure template

Every page in the app follows this skeleton:

```dart
class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    // watch providers here

    return RoleScaffold(                       // see §2 — pick the right scaffold
      currentRoute: AppRoutes.myRoute,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(title: l10n.pageTitle),
          // content
        ],
      ),
    );
  }
}
```

### Colour rules

| Use case | Token |
|----------|-------|
| Primary brand | `AppTheme.primary` |
| Success / positive | `AppTheme.success` |
| Warning / caution | `AppTheme.caution` |
| Error / destructive | `AppTheme.error` |
| Informational | `AppTheme.info` |
| Page background | `AppTheme.backgroundMuted` |
| Card / surface | `AppTheme.white` |
| Border lines | `AppTheme.gray` |
| Primary text | `AppTheme.textPrimary` |
| Secondary / muted text | `AppTheme.textMuted` |
| Text on coloured backgrounds | `AppTheme.textContrast` |

### Typography rules

Always use `AppText` (or `AppTheme.*` text styles) — never a raw `Text()` with manual font sizes:

```dart
// CORRECT
AppText(l10n.title, variant: AppTextVariant.headlineSmall, fontWeight: FontWeight.w600)
Text(name, style: AppTheme.body.copyWith(fontWeight: FontWeight.w500))

// WRONG
Text('Title', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
```

### Loading / error / empty pattern

Every `FutureProvider` / `AsyncValue` must handle all three states:

```dart
dataAsync.when(
  loading: () => const AppLoadingIndicator(),
  error: (_, __) => AppEmptyState.error(
    title: l10n.genericError,
    action: AppOutlinedButton(label: l10n.retry, onPressed: () => ref.invalidate(myProvider)),
  ),
  data: (items) => items.isEmpty
      ? AppEmptyState(icon: Icons.inbox_outlined, title: l10n.noItems)
      : _buildList(items),
);
```

### Form validation

Wrap all inputs in a `Form` with a `GlobalKey<FormState>`:

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(children: [
    AppTextInput(label: l10n.name, controller: _nameCtrl, isRequired: true),
    AppEmailInput(label: l10n.email, controller: _emailCtrl),
    AppFilledButton(
      label: l10n.submit,
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) _submit();
      },
    ),
  ]),
)
```

After a successful submit, always call `_formKey.currentState?.reset()` before clearing controllers.

### Input-purpose metadata

- Personal-data fields must expose the correct `autofillHints` when the purpose is known.
- Shared widgets should own common hints such as email, phone number, current password, and new password.
- Generic inputs such as `AppTextInput` should receive caller-provided `autofillHints` for purposes like given name, family name, username, or birthday.
- Raw `TextField` and `TextFormField` usage in auth, request-account, profile, and password flows must not omit input-purpose metadata by default.

---

## 2. Layout & Scaffolds

### `BaseScaffold`

**File**: `core/widgets/layout/base_scaffold.dart`

The root layout for all pages. Provides header, scrollable content well, footer, and cookie banner. Use a role scaffold instead of this directly — `BaseScaffold` is their shared foundation.

| Param | Type | Default | Notes |
|-------|------|---------|-------|
| `child` | `Widget` | required | Page content |
| `header` | `PreferredSizeWidget?` | `null` | Injected by role scaffolds |
| `showHeader` | `bool` | `true` | |
| `showFooter` | `bool` | `true` | |
| `padding` | `EdgeInsets` | `all(24)` | Content padding |
| `scrollable` | `bool` | `true` | |
| `floatingActionButton` | `Widget?` | `null` | |
| `maxWidth` | `double` | `Breakpoints.maxContent` | Content column constraint |

---

### Role Scaffolds

Never use `Scaffold` directly in a page. Always use the scaffold for the current user's role:

| Role | Widget | File |
|------|--------|------|
| Participant | `ParticipantScaffold` | `features/participant/widgets/participant_scaffold.dart` |
| Admin | `AdminScaffold` | `features/admin/widgets/admin_scaffold.dart` |
| HCP | `HcpScaffold` | `features/hcp_clients/widgets/hcp_scaffold.dart` |
| Researcher | `ResearcherScaffold` | `features/researcher/widgets/researcher_scaffold.dart` |

All four share the same core params:

| Param | Type | Default | Notes |
|-------|------|---------|-------|
| `currentRoute` | `String` | required | Highlights active nav item — use `AppRoutes.*` |
| `child` | `Widget` | required | Page content |
| `scrollable` | `bool` | varies | Participant: `true`; HCP/Researcher: `false` |
| `showFooter` | `bool` | varies | Participant: `true`; HCP/Researcher: `false` |
| `padding` | `EdgeInsets` | varies | Participant: `all(24)`; HCP/Researcher: `zero` |
| `floatingActionButton` | `Widget?` | `null` | |
| `hasNotifications` | `bool` | `false` | Lights up the notification icon |
| `onNotificationsTap` | `VoidCallback?` | `null` | |
| `onProfileTap` | `VoidCallback?` | `null` | |
| `userName` | `String?` | `null` | Displayed in header |
| `maxWidth` | `double` | `double.infinity` | |

**`AdminScaffold`** adds:

| Param | Type | Default |
|-------|------|---------|
| `userName` | `String` | `'Admin'` |
| `messageCount` | `int` | `0` |

```dart
// Participant page
return ParticipantScaffold(
  currentRoute: AppRoutes.tasks,
  child: _buildContent(),
);

// Admin page
return AdminScaffold(
  currentRoute: AppRoutes.adminDashboard,
  messageCount: ref.watch(accountRequestCountProvider).valueOrNull ?? 0,
  child: _buildContent(),
);
```

---

### `AdminViewAsBanner`

**File**: `features/admin/widgets/admin_view_as_banner.dart`

Zero-param banner. Injected automatically by `AdminScaffold` when an admin is viewing as another role. Do not place it manually.

---

## 3. Typography

### `AppText`

**File**: `core/widgets/micro/app_text.dart`

| Param | Type | Default |
|-------|------|---------|
| `text` | `String` | required |
| `variant` | `AppTextVariant` | `bodyMedium` |
| `color` | `Color?` | `null` (inherits theme) |
| `textAlign` | `TextAlign?` | `null` |
| `maxLines` | `int?` | `null` |
| `overflow` | `TextOverflow?` | `null` |
| `softWrap` | `bool?` | `null` |
| `fontWeight` | `FontWeight?` | `null` |
| `fontStyle` | `FontStyle?` | `null` |

`AppTextVariant` values (responsive — sizes scale with breakpoint):

| Variant | Typical use |
|---------|-------------|
| `displayLarge / Medium / Small` | Hero headings |
| `headlineMedium / Small` | Page and section headings |
| `bodyLarge` | Sub-headings, card titles |
| `bodyMedium` | Default body copy |
| `bodySmall` | Labels, captions, helper text |

```dart
AppText(l10n.pageTitle, variant: AppTextVariant.headlineSmall, fontWeight: FontWeight.w600)
AppText(l10n.description, variant: AppTextVariant.bodyMedium, color: AppTheme.textMuted)
```

---

### `AppRichText`

**File**: `core/widgets/micro/app_rich_text.dart`

Same as `AppText` but accepts a `TextSpan` for inline mixed styles.

| Param | Type | Default |
|-------|------|---------|
| `text` | `TextSpan` | required |
| `variant` | `AppTextVariant` | `bodyMedium` |
| `textAlign` | `TextAlign?` | `null` |
| `maxLines` | `int?` | `null` |
| `overflow` | `TextOverflow?` | `null` |

---

### `AppSectionHeader`

**File**: `core/widgets/micro/app_section_header.dart`

Standardised section title with built-in vertical spacing. Use at the start of every logical section in a page.

| Param | Type | Default |
|-------|------|---------|
| `title` | `String` | required |
| `variant` | `AppTextVariant` | `bodyLarge` |
| `color` | `Color?` | `AppTheme.primary` |
| `fontWeight` | `FontWeight` | `w600` |
| `topSpacing` | `double` | `24` |
| `bottomSpacing` | `double` | `12` |
| `trailing` | `Widget?` | `null` |

```dart
AppSectionHeader(title: l10n.incomingRequests)
AppSectionHeader(title: l10n.results, trailing: AppBadge(label: '${items.length}'))
```

---

## 4. Buttons

All buttons accept `onPressed: null` to enter a disabled state automatically.

### `AppFilledButton`

**File**: `core/widgets/buttons/app_filled_button.dart`

Primary action. Filled background.

| Param | Type | Default |
|-------|------|---------|
| `label` | `String` | required |
| `onPressed` | `VoidCallback?` | `null` |
| `backgroundColor` | `Color?` | `AppTheme.primary` |
| `textColor` | `Color?` | `AppTheme.white` |
| `padding` | `EdgeInsets?` | `null` |
| `textStyle` | `TextStyle?` | `null` |

---

### `AppLongButton`

**File**: `core/widgets/buttons/app_long_button.dart`

`AppFilledButton` at `width: double.infinity`. Use for the sole primary CTA at the bottom of a form or card.

Same params as `AppFilledButton`.

---

### `AppOutlinedButton`

**File**: `core/widgets/buttons/app_outlined_button.dart`

Secondary action with border. Use for cancel/retry/back alongside a filled primary.

| Param | Type | Default |
|-------|------|---------|
| `label` | `String` | required |
| `onPressed` | `VoidCallback?` | `null` |
| `icon` | `IconData?` | `null` |
| `borderColor` | `Color?` | `AppTheme.primary` |
| `foregroundColor` | `Color?` | `AppTheme.primary` |
| `padding` | `EdgeInsets?` | `null` |
| `textStyle` | `TextStyle?` | `null` |

---

### `AppTextButton`

**File**: `core/widgets/buttons/app_text_button.dart`

Tertiary / inline action. No background or border.

| Param | Type | Default |
|-------|------|---------|
| `label` | `String` | required |
| `onPressed` | `VoidCallback?` | `null` |
| `textStyle` | `TextStyle?` | `null` |
| `textColor` | `Color?` | `AppTheme.primary` |
| `padding` | `EdgeInsets?` | `null` |

---

### `AppTabButton`

**File**: `core/widgets/buttons/app_tab_button.dart`

Toggle button for filter rows (e.g. Pending / Active / Rejected).

| Param | Type | Default |
|-------|------|---------|
| `label` | `String` | required |
| `isSelected` | `bool` | required |
| `onTap` | `VoidCallback` | required |

```dart
Row(children: [
  for (final status in ['pending', 'active', 'rejected'])
    AppTabButton(
      label: status,
      isSelected: _filter == status,
      onTap: () => setState(() => _filter = status),
    ),
])
```

---

### Button hierarchy

```
Primary action   →  AppFilledButton / AppLongButton
Secondary action →  AppOutlinedButton
Tertiary/inline  →  AppTextButton
Filter toggle    →  AppTabButton
Popup menu item  →  appPopupMenuItem() / appPopupMenuItemDestructive()
```

---

## 5. Form Inputs

All inputs integrate with Flutter's `Form` + `FormField` validation system. Wrap in `Form(key: _formKey, child: ...)`.

### `AppTextInput`

**File**: `core/widgets/forms/app_text_input.dart`

Single-line freeform text.

| Param | Type | Default |
|-------|------|---------|
| `label` | `String` | required |
| `controller` | `TextEditingController?` | `null` |
| `initialValue` | `String?` | `null` |
| `hintText` | `String?` | `null` |
| `enabled` | `bool` | `true` |
| `isRequired` | `bool` | `true` |
| `validator` | `AppStringValidator?` | `null` |
| `onChanged` | `ValueChanged<String>?` | `null` |
| `onSubmitted` | `ValueChanged<String>?` | `null` |
| `focusNode` | `FocusNode?` | `null` |
| `autofillHints` | `Iterable<String>?` | `null` |
| `textInputAction` | `TextInputAction?` | `null` |
| `autovalidateMode` | `AutovalidateMode` | `onUserInteraction` |

---

### `AppEmailInput`

**File**: `core/widgets/forms/app_email_input.dart`

Email field with built-in format validation. Same params as `AppTextInput` minus `onSubmitted`, `textInputAction`, `autofillHints`.

---

### `AppPasswordInput`

**File**: `core/widgets/forms/app_password_input.dart`

Obscured field with show/hide toggle. Always required.

| Param | Type | Default |
|-------|------|---------|
| `label` | `String` | required |
| `controller` | `TextEditingController?` | `null` |
| `hintText` | `String?` | `null` |
| `enabled` | `bool` | `true` |
| `validator` | `AppStringValidator?` | `null` |
| `onChanged` | `ValueChanged<String>?` | `null` |
| `autofillHints` | `Iterable<String>` | `[AutofillHints.password]` |
| `autovalidateMode` | `AutovalidateMode` | `onUserInteraction` |

---

### `AppCreatePasswordInput`

**File**: `core/widgets/forms/app_create_password_input.dart`

Password creation field with live validation rules (min length, uppercase, lowercase, digit, special char — 7 rules total). Use on registration / change-password screens.

Same params as `AppPasswordInput` (minus `autofillHints`).

---

### `AppConfirmPasswordInput`

**File**: `core/widgets/forms/app_confirm_password_input.dart`

Confirms a password matches `AppCreatePasswordInput`. Link via `createPasswordController`.

| Param | Type | Default |
|-------|------|---------|
| `label` | `String` | `'Confirm Password'` |
| `controller` | `TextEditingController?` | `null` |
| `createPasswordController` | `TextEditingController?` | `null` |
| `createPasswordValue` | `String?` | `null` |
| `hintText` | `String?` | `null` |
| `validator` | `AppStringValidator?` | `null` |
| `onChanged` | `ValueChanged<String>?` | `null` |
| `autovalidateMode` | `AutovalidateMode` | `onUserInteraction` |

---

### `AppParagraphInput`

**File**: `core/widgets/forms/app_paragraph_input.dart`

Multi-line text area.

| Param | Type | Default |
|-------|------|---------|
| `label` | `String` | required |
| `minLines` | `int` | `3` |
| `maxLines` | `int` | `8` |
| `fixedHeight` | `double?` | `null` |
| *(+ shared params)* | | |

---

### `AppDropdownInput<T>`

**File**: `core/widgets/forms/app_dropdown_input.dart`

Form-style dropdown with validation support.

| Param | Type | Default |
|-------|------|---------|
| `label` | `String` | required |
| `options` | `List<AppDropdownInputOption<T>>` | required |
| `value` | `T?` | `null` |
| `onChanged` | `ValueChanged<T?>?` | `null` |
| `hintText` | `String?` | `null` |
| `enabled` | `bool` | `true` |
| `isRequired` | `bool` | `true` |
| `validator` | `AppValueValidator<T>?` | `null` |
| `autovalidateMode` | `AutovalidateMode` | `onUserInteraction` |

```dart
AppDropdownInput<String>(
  label: l10n.role,
  options: [
    AppDropdownInputOption(value: 'hcp', label: l10n.roleHcp),
    AppDropdownInputOption(value: 'participant', label: l10n.roleParticipant),
  ],
  value: _selectedRole,
  onChanged: (v) => setState(() => _selectedRole = v),
)
```

---

### `AppDateInput`

**File**: `core/widgets/forms/app_date_input.dart`

Date picker backed by `showDatePicker`.

| Param | Type | Default |
|-------|------|---------|
| `label` | `String` | required |
| `value` | `DateTime?` | `null` |
| `onChanged` | `ValueChanged<DateTime?>?` | `null` |
| `firstDate` | `DateTime?` | `null` |
| `lastDate` | `DateTime?` | `null` |
| `allowManualEntry` | `bool` | `false` |
| *(+ shared params)* | | |

---

### `AppTimeInput`

**File**: `core/widgets/forms/app_time_input.dart`

Time picker backed by `showTimePicker`. Same params as `AppDateInput` with `TimeOfDay` instead of `DateTime`.

---

### `AppPhoneInput`

**File**: `core/widgets/forms/app_phone_input.dart`

Country-code selector + phone number input.

| Param | Type | Default |
|-------|------|---------|
| `label` | `String` | required |
| `countries` | `List<AppPhoneCountry>` | `commonCountries` |
| `initialCountry` | `AppPhoneCountry?` | `null` |
| `onCountryChanged` | `ValueChanged<AppPhoneCountry>?` | `null` |
| `onNormalizedChanged` | `ValueChanged<String>?` | `null` (outputs `+1XXXXXXXXXX`) |
| *(+ shared params)* | | |

---

### `AppSearchBar`

**File**: `core/widgets/forms/app_search_bar.dart`

Search input with clear button. Not a `FormField` — use standalone for live filtering.

| Param | Type | Default |
|-------|------|---------|
| `controller` | `TextEditingController?` | `null` |
| `hintText` | `String?` | `null` |
| `onChanged` | `ValueChanged<String>?` | `null` |
| `onSubmitted` | `ValueChanged<String>?` | `null` |
| `focusNode` | `FocusNode?` | `null` |
| `autofocus` | `bool` | `false` |

---

### `AppSecuredModal`

**File**: `core/widgets/forms/app_secured_modal.dart`

Password-gate dialog for destructive or sensitive actions.

| Param | Type | Default |
|-------|------|---------|
| `title` | `String` | required |
| `body` | `String` | required |
| `verifyPassword` | `Future<bool> Function(String)` | required |
| `onBack` | `VoidCallback` | required |
| `onVerificationSuccess` | `Future<void> Function(String)?` | `null` |
| `onVerificationFailure` | `Future<void> Function(String)?` | `null` |
| `confirmLabel` | `String` | `'Confirm'` |
| `backLabel` | `String` | `'Back'` |

---

### Selection inputs (`AppCheckbox`, `AppRadio<T>`)

**Files**: `core/widgets/micro/app_checkbox.dart`, `core/widgets/micro/app_radio.dart`

Both support controlled (`value` / `groupValue`) and uncontrolled (`initialValue` / `initialGroupValue`) modes.

`AppCheckbox` params:

| Param | Type | Default |
|-------|------|---------|
| `value` | `bool?` | `null` (controlled) |
| `initialValue` | `bool` | `false` (uncontrolled) |
| `onChanged` | `ValueChanged<bool?>?` | `null` |
| `tristate` | `bool` | `false` |
| `enabled` | `bool` | `true` |

---

## 6. Feedback & State

### `AppLoadingIndicator`

**File**: `core/widgets/feedback/app_loading_indicator.dart`

| Constructor | Use |
|-------------|-----|
| `AppLoadingIndicator()` | Centered spinner for full content areas |
| `AppLoadingIndicator.inline()` | Small spinner inside buttons or table cells |

| Param | Type | Default |
|-------|------|---------|
| `size` | `double` | `36` (inline: `16`) |
| `strokeWidth` | `double` | `4` (inline: `2`) |
| `color` | `Color?` | `AppTheme.primary` |
| `centered` | `bool` | `true` (inline: `false`) |

---

### `AppEmptyState`

**File**: `core/widgets/feedback/app_empty_state.dart`

| Constructor | Use |
|-------------|-----|
| `AppEmptyState(icon:, title:, ...)` | No data available |
| `AppEmptyState.error(title:, ...)` | Load failed |

| Param | Type | Default |
|-------|------|---------|
| `icon` | `IconData` | required |
| `title` | `String` | required |
| `subtitle` | `String?` | `null` |
| `action` | `Widget?` | `null` |
| `iconSize` | `double` | `64` |
| `iconColor` | `Color?` | `null` |

```dart
AppEmptyState(
  icon: Icons.assignment_outlined,
  title: l10n.noTasks,
  subtitle: l10n.noTasksDetail,
  action: AppOutlinedButton(label: l10n.refresh, onPressed: () => ref.invalidate(tasksProvider)),
)
```

---

### `AppAnnouncement`

**File**: `core/widgets/feedback/app_announcement.dart`

Full-width inline banner. Use for persistent in-page alerts (consent required, profile incomplete). Supports `onTap` to navigate.

| Param | Type | Default |
|-------|------|---------|
| `message` | `String` | required |
| `icon` | `Widget?` | `null` |
| `onTap` | `VoidCallback?` | `null` |
| `backgroundColor` | `Color?` | `AppTheme.info` |
| `textColor` | `Color?` | `AppTheme.textContrast` |
| `borderColor` | `Color?` | `null` |
| `padding` | `EdgeInsets?` | `null` |

```dart
AppAnnouncement(
  message: l10n.todoConsentRequired,
  icon: const AppIcon(Icons.assignment_outlined),
  backgroundColor: AppTheme.error,
  textColor: AppTheme.textContrast,
  onTap: () => context.go(AppRoutes.consent),
)
```

---

### `AppInfoBanner`

**File**: `core/widgets/feedback/app_info_banner.dart`

Lighter, bordered informational banner. Use for tips, notices, non-critical warnings.

| Param | Type | Default |
|-------|------|---------|
| `icon` | `IconData` | required |
| `message` | `String` | required |
| `color` | `Color` | `AppTheme.caution` |
| `backgroundAlpha` | `double` | `0.08` |
| `borderAlpha` | `double` | `0.3` |
| `showBorder` | `bool` | `true` |
| `radius` | `double` | `8` |
| `trailing` | `Widget?` | `null` |

---

### `AppToast` (static methods)

**File**: `core/widgets/feedback/app_toasts.dart`

Never instantiate directly. Call the static `show*` methods from any widget with a `BuildContext`:

```dart
AppToast.showSuccess(context, message: l10n.saved);
AppToast.showError(context, message: l10n.saveFailed);
AppToast.showInfo(context, message: l10n.sessionExpiringSoon);
AppToast.showCaution(context, message: l10n.unsavedChanges);
```

Toasts auto-dismiss. The optional `onClose` callback fires when the user taps the close button.

---

### `AppConfirmDialog`

**File**: `core/widgets/feedback/app_confirm_dialog.dart`

Use `AppConfirmDialog.show()` — returns `Future<bool>`:

```dart
final confirmed = await AppConfirmDialog.show(
  context,
  title: l10n.deleteTitle,
  content: l10n.deleteConfirm,
  confirmLabel: l10n.delete,
  isDangerous: true,
);
if (confirmed) _delete();
```

| Param | Type | Default |
|-------|------|---------|
| `title` | `String` | required |
| `content` | `String` | required |
| `confirmLabel` | `String` | required |
| `cancelLabel` | `String` | `'Cancel'` |
| `onConfirm` | `VoidCallback?` | `null` |
| `confirmColor` | `Color?` | `null` |
| `isDangerous` | `bool` | `false` (red confirm button when `true`) |

---

### `AppPopover`

**File**: `core/widgets/feedback/app_popover.dart`

Contextual tooltip/popover bubble with directional arrow.

| Param | Type | Default |
|-------|------|---------|
| `message` | `String` | required |
| `icon` | `Widget?` | `null` |
| `backgroundColor` | `Color?` | `null` |
| `textColor` | `Color?` | `null` |
| `arrowOnTop` | `bool` | `true` |
| `arrowSize` | `double` | `8` |
| `arrowOffset` | `double?` | `null` |

---

## 7. Data Display

### `AppTable`

**File**: `core/widgets/data_display/app_table.dart`

Generic tabular data display.

| Param | Type | Default |
|-------|------|---------|
| `columns` | `List<AppTableColumn>` | required |
| `rows` | `List<Map<String, dynamic>>` | required |
| `emptyMessage` | `String?` | `null` |

`AppTableColumn` fields:

| Field | Type | Notes |
|-------|------|-------|
| `key` | `String` | Map key to read from each row |
| `label` | `String` | Header text |
| `flex` | `int` | Column proportional width (default `1`) |
| `builder` | `Widget Function(dynamic value)?` | Custom cell renderer |

```dart
AppTable(
  columns: [
    AppTableColumn(key: 'name', label: l10n.name, flex: 2),
    AppTableColumn(key: 'status', label: l10n.status,
      builder: (v) => AppBadge(label: v as String)),
    AppTableColumn(key: 'date', label: l10n.date),
  ],
  rows: items.map((i) => {'name': i.name, 'status': i.status, 'date': i.date}).toList(),
  emptyMessage: l10n.noResults,
)
```

---

### `AppStatCard`

**File**: `core/widgets/data_display/app_stat_card.dart`

Single metric display card.

| Param | Type | Default |
|-------|------|---------|
| `label` | `String` | required |
| `value` | `String` | required |
| `icon` | `IconData?` | `null` |
| `color` | `Color` | `AppTheme.primary` |
| `subtitle` | `String?` | `null` |

```dart
AppStatCard(label: l10n.totalParticipants, value: '${count}', icon: Icons.people)
```

---

### `AppProgressBar`

**File**: `core/widgets/data_display/app_progress_bar.dart`

| Param | Type | Default |
|-------|------|---------|
| `progress` | `double` | required (0.0–1.0) |
| `backgroundColor` | `Color?` | `AppTheme.gray` |
| `progressColor` | `Color?` | `AppTheme.success` |
| `height` | `double?` | `null` |
| `borderRadius` | `BorderRadius?` | `null` |
| `semanticLabel` | `String?` | `null` |

---

### `AppCardTask`

**File**: `core/widgets/data_display/app_card_task.dart`

Task card with due date and action button.

| Param | Type | Default |
|-------|------|---------|
| `title` | `String` | required |
| `dueText` | `String` | required |
| `actionLabel` | `String` | required |
| `repeatText` | `String?` | `null` |
| `onAction` | `VoidCallback?` | `null` |
| `actionColor` | `Color?` | `null` |
| `actionTextColor` | `Color?` | `null` |
| `padding` | `EdgeInsets?` | `null` |

---

### Chart widgets

All charts use `fl_chart`. Always wrap in `AppGraphRenderer` for consistent card styling.

| Widget | File | Required params |
|--------|------|-----------------|
| `AppBarChart` | `app_bar_chart.dart` | `title`, `data: Map<String, double>` |
| `AppPieChart` | `app_pie_chart.dart` | `title`, `data: Map<String, double>` |
| `AppLineChart` | `app_line_chart.dart` | `title`, `series: List<LineSeries>` |
| `SurveyChartSwitcher` | `survey_chart_switcher.dart` | `title`, `data`, `defaultType: SurveyChartType` |

`AppGraphRenderer` — container for any chart:

| Param | Type | Default |
|-------|------|---------|
| `title` | `String` | required |
| `child` | `Widget?` | `null` |
| `placeholderText` | `String?` | `null` |
| `height` | `double?` | `null` |
| `backgroundColor` | `Color?` | `null` |

```dart
AppGraphRenderer(
  title: l10n.responseDistribution,
  child: AppBarChart(title: '', data: chartData),
)
```

`SurveyChartType` values: `bar`, `pie`, `line`.

---

## 8. Micro / Utility

### `AppIcon`

**File**: `core/widgets/micro/app_icon.dart`

Responsive-sized icon. Always use instead of raw `Icon()`.

| Param | Type | Default |
|-------|------|---------|
| `icon` | `IconData` | required |
| `size` | `double?` | breakpoint-responsive |
| `color` | `Color?` | inherited |
| `semanticLabel` | `String?` | `null` |

---

### `AppBadge`

**File**: `core/widgets/micro/app_badge.dart`

Pill label for roles, statuses, counts.

| Param | Type | Default |
|-------|------|---------|
| `label` | `String` | required |
| `variant` | `AppBadgeVariant` | `neutral` |
| `size` | `AppBadgeSize` | `medium` |
| `leading` | `Widget?` | `null` |
| `trailing` | `Widget?` | `null` |

`AppBadgeVariant`: `neutral` `primary` `secondary` `success` `caution` `error` `info`

```dart
AppBadge(label: 'Active', variant: AppBadgeVariant.success)
AppBadge(label: 'HCP', variant: AppBadgeVariant.primary)
```

---

### `AppColoredTag`

**File**: `core/widgets/micro/app_colored_tag.dart`

Freeform coloured label (when `AppBadge` variants don't fit).

| Param | Type | Default |
|-------|------|---------|
| `label` | `String` | required |
| `color` | `Color` | required |
| `alpha` | `double` | `0.1` |
| `radius` | `double` | `4` |
| `fontSize` | `double?` | `null` |
| `padding` | `EdgeInsets?` | `null` |

---

### `AppUserAvatar`

**File**: `core/widgets/micro/app_user_avatar.dart`

Circular avatar showing user initial.

| Param | Type | Default |
|-------|------|---------|
| `name` | `String` | required |
| `radius` | `double` | `18` |
| `backgroundColor` | `Color?` | `null` |
| `foregroundColor` | `Color?` | `null` |
| `fontSize` | `double?` | `null` |

---

### `AppIconBadge`

**File**: `core/widgets/micro/app_icon_badge.dart`

Icon in a rounded coloured tile (for feature/category icons in dashboards).

| Param | Type | Default |
|-------|------|---------|
| `icon` | `IconData` | required |
| `color` | `Color` | `AppTheme.primary` |
| `size` | `double` | `48` |
| `iconSize` | `double?` | `null` |
| `radius` | `double` | `8` |
| `alpha` | `double` | `0.1` |
| `child` | `Widget?` | `null` |

---

### `AppStatusDot`

**File**: `core/widgets/micro/app_status_dot.dart`

Notification indicator overlay on an icon.

| Param | Type | Default |
|-------|------|---------|
| `icon` | `Widget` | required |
| `hasNotification` | `bool` | `false` |
| `indicatorColor` | `Color?` | `AppTheme.error` |
| `indicatorSize` | `double?` | `null` |
| `notificationCount` | `int?` | `null` (shows dot; if >0 shows count) |

---

### `AppDivider`

**File**: `core/widgets/micro/app_divider.dart`

| Param | Type | Default |
|-------|------|---------|
| `thickness` | `double?` | `null` |
| `spacing` | `double?` | responsive |
| `color` | `Color?` | `AppTheme.gray` |
| `indent` | `double` | `0` |
| `endIndent` | `double` | `0` |

---

### `AppYourAnswerRow`

**File**: `core/widgets/micro/app_your_answer_row.dart`

Displays a labelled answer value row in survey results / charts.

| Param | Type | Default |
|-------|------|---------|
| `label` | `String` | required |
| `value` | `String` | required |
| `color` | `Color` | `AppTheme.primary` |

---

### `AppBottomSheetHandle`

**File**: `core/widgets/micro/app_bottom_sheet_handle.dart`

Place at the top of any `showModalBottomSheet` content:

```dart
showModalBottomSheet(context: context, builder: (_) => Column(children: [
  const AppBottomSheetHandle(),
  // content
]));
```

| Param | Type | Default |
|-------|------|---------|
| `color` | `Color?` | `AppTheme.gray` |
| `width` | `double` | `40` |
| `height` | `double` | `4` |
| `padding` | `EdgeInsets` | `symmetric(vertical: 8)` |

---

### Popup menu helpers

**File**: `core/widgets/micro/app_popup_menu_item.dart`

Top-level functions (not a class):

```dart
// Standard
appPopupMenuItem<String>(value: 'edit', icon: Icons.edit, label: l10n.edit)

// Destructive (renders in red)
appPopupMenuItemDestructive<String>(value: 'delete', icon: Icons.delete, label: l10n.delete)
```

---

### Navigation widgets

| Widget | File | Notes |
|--------|------|-------|
| `AppBreadcrumbs` | `core/widgets/basics/app_breadcrumbs.dart` | Pass `List<AppBreadcrumbItem>` |
| `AppDropdownMenu<T>` | `core/widgets/basics/app_dropdown_menu.dart` | Non-form quick dropdown |
| `AppSectionNavbar` | `core/widgets/basics/app_section_navbar.dart` | Collapsible sidebar nav |
| `Header` | `core/widgets/basics/header.dart` | Injected by role scaffolds |
| `Footer` | `core/widgets/basics/footer.dart` | Injected by `BaseScaffold` |
| `CookieBanner` | `core/widgets/basics/cookie_banner.dart` | Injected by `BaseScaffold` |
| `HealthBankLogo` | `core/widgets/basics/healthbank_logo.dart` | `size:` small/medium/large |

---

### `AppCard`

**File**: `core/widgets/basics/app_card.dart`

Generic white card container.

| Param | Type | Default |
|-------|------|---------|
| `child` | `Widget` | required |
| `padding` | `EdgeInsets?` | `all(16)` |
| `radius` | `double` | `8` |
| `backgroundColor` | `Color?` | `AppTheme.white` |
| `borderColor` | `Color?` | `AppTheme.gray` |
| `shadow` | `List<BoxShadow>?` | `null` |
| `onTap` | `VoidCallback?` | `null` (ripple when set) |
| `width` | `double?` | `null` |

---

### `AppAccordion`

**File**: `core/widgets/basics/app_accordion.dart`

| Param | Type | Default |
|-------|------|---------|
| `title` | `String` | required |
| `body` | `String` | required |
| `leadingIcon` | `Widget?` | `null` |
| `iconColor` | `Color?` | `null` |
| `initiallyExpanded` | `bool` | `false` |
| `onChanged` | `ValueChanged<bool>?` | `null` |

---

### `AppModal` / `AppOverlay`

**Files**: `core/widgets/basics/app_modal.dart`, `core/widgets/basics/app_overlay.dart`

For custom modal content, compose `AppOverlay` + your content. For simple confirm/deny use `AppConfirmDialog.show()` instead.

---

## 9. Feature Widgets

These widgets are **not global** — they live inside a specific feature and must only be used within that feature.

### Auth

| Widget | File | Notes |
|--------|------|-------|
| `ProvisioningQrCard` | `features/auth/widgets/provisioning_qr_card.dart` | 2FA setup QR — requires `provisioningUri` |

### Admin

| Widget | File | Notes |
|--------|------|-------|
| `AdminSidebar` | `features/admin/widgets/admin_sidebar.dart` | Injected by `AdminScaffold` — do not use directly |
| `AdminScaffold` | `features/admin/widgets/admin_scaffold.dart` | Use on every admin page |
| `AdminViewAsBanner` | `features/admin/widgets/admin_view_as_banner.dart` | Injected by `AdminScaffold` — do not use directly |

### Participant

| Widget | File | Notes |
|--------|------|-------|
| `ParticipantScaffold` | `features/participant/widgets/participant_scaffold.dart` | Use on every participant page |
| `WelcomeBanner` | `features/participant/widgets/welcome_banner.dart` | Dashboard only — requires `firstName` |
| `GraphCard` | `features/participant/widgets/graph_card.dart` | Wraps chart widgets — requires `title` |

### HCP

| Widget | File | Notes |
|--------|------|-------|
| `HcpScaffold` | `features/hcp_clients/widgets/hcp_scaffold.dart` | Use on every HCP page |

### Researcher

| Widget | File | Notes |
|--------|------|-------|
| `ResearcherScaffold` | `features/researcher/widgets/researcher_scaffold.dart` | Use on every researcher page |

### Surveys / Question Bank

| Widget | File | Notes |
|--------|------|-------|
| `QuestionBankFormDialog` | `features/question_bank/widgets/question_bank_form_dialog.dart` | `QuestionBankFormDialog.show(context, question: q)` returns `Future<Question?>` |
| `SingleChoiceWidget` | `features/surveys/widgets/question_types/single_choice_widget.dart` | Radio list for survey render |
| `MultiChoiceWidget` | `features/surveys/widgets/question_types/multi_choice_widget.dart` | Checkbox list for survey render |
| `ScaleQuestionWidget` | `features/surveys/widgets/question_types/scale_question_widget.dart` | Slider for scale questions |
| `NumberQuestionWidget` | `features/surveys/widgets/question_types/number_question_widget.dart` | Numeric input for survey render |

---

## 10. Remaining TODOs

These gaps should be addressed before the next milestone:

| # | Gap | Recommended approach |
|---|-----|----------------------|
| 1 | `core/widgets/survey/survey.dart` is an empty barrel file | Implement `SurveyRenderer` widget that takes a `Survey` model and renders all question type widgets in order |
| 2 | `AppTextBox` (`core/widgets/micro/app_text_box.dart`) is an empty file | Either implement a read-only styled text container or delete the file |
| 3 | No `OpenendedQuestionWidget` content confirmed | Verify `features/surveys/widgets/question_types/openended_question_widget.dart` renders an `AppParagraphInput` correctly |
| 4 | Chart widgets have no loading/error states | Wrap in a `FutureBuilder`/`.when()` pattern and show `AppLoadingIndicator` + `AppEmptyState.error()` |
| 5 | `AppDataTable` vs `AppTable` overlap | Audit usage — consolidate into one or document distinct roles clearly |

---

*Last updated: 2026-03-09*
