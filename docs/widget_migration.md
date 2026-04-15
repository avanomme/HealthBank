# Widget Migration Guide

**Date:** 2026-03-07
**Source:** `docs/audit/01_global_widgets.md`

This guide shows exactly how to replace every inline anti-pattern with the correct global widget. Work through each section file by file.

---

## Quick Import Reference

```dart
// Buttons
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
// → AppFilledButton, AppLongButton, AppTextButton, AppOutlinedButton

// Basics
import 'package:frontend/src/core/widgets/basics/basics.dart';
// → AppCard, AppModal, AppAccordion, AppDropdownMenu, etc.

// Micro
import 'package:frontend/src/core/widgets/micro/micro.dart';
// → AppBadge, AppUserAvatar, AppBottomSheetHandle, AppText, AppIcon, etc.

// Feedback
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
// → AppToast, AppAnnouncement, AppPopover

// Data Display
import 'package:frontend/src/core/widgets/data_display/data_display.dart';
// → AppDataTable, DataTable, DataTableCell
```

---

## 1. ElevatedButton → AppFilledButton / AppLongButton

**30+ files affected.** This is the biggest migration.

### Before:
```dart
ElevatedButton(
  onPressed: () { ... },
  style: ElevatedButton.styleFrom(
    backgroundColor: AppTheme.primary,
    foregroundColor: AppTheme.textContrast,
  ),
  child: Text('Save'),
)
```

### After:
```dart
AppFilledButton(
  label: 'Save',
  onPressed: () { ... },
)
```

### Full-width variant (was `SizedBox(width: double.infinity, child: ElevatedButton(...))`):
```dart
AppLongButton(
  label: 'Submit Request',
  onPressed: () { ... },
)
```

### With custom color:
```dart
AppFilledButton(
  label: 'Delete',
  onPressed: () { ... },
  backgroundColor: AppTheme.error,
)
```

### Files to migrate:

| File | Lines |
|------|-------|
| `messaging/pages/messaging_inbox_page.dart` | 1105, 1610 |
| `messaging/pages/friend_request_page.dart` | 170 (use `AppLongButton`) |
| `messaging/pages/new_conversation_page.dart` | 378 |
| `participant/pages/participant_surveys_page.dart` | 194 |
| `auth/widgets/login_card.dart` | 99 |
| `auth/widgets/login_form.dart` | 169 |
| `auth/pages/change_password_page.dart` | 253 |
| `auth/pages/request_account_page.dart` | 311, 378 |
| `auth/pages/forgot_password_page.dart` | 170, 237 |
| `auth/pages/reset_password_page.dart` | 233, 299, 343 |
| `auth/pages/two_factor_page.dart` | 264, 330 |
| `auth/pages/logout_page.dart` | 109, 128 |
| `auth/pages/consent_page.dart` | 282 |
| `auth/pages/profile_completion_page.dart` | 215 |
| `admin/pages/messages_page.dart` | 335, 366, 431 |
| `admin/pages/user_management_page.dart` | 909, 1155 |
| `admin/widgets/reset_password_modal.dart` | 359 |
| `hcp_clients/pages/hcp_client_list_page.dart` | 71, 404 |
| `participant/pages/participant_tasks_page.dart` | 90, 309 |
| `participant/widgets/task_card.dart` | 81 |
| `participant/widgets/view_all_tasks_button.dart` | 23 |
| `question_bank/pages/question_bank_page.dart` | 459 |
| `question_bank/widgets/question_bank_form_dialog.dart` | 330 |
| `surveys/pages/survey_list_page.dart` | 469, 511, 550 |
| `surveys/pages/survey_builder_page.dart` | 166 |
| `surveys/widgets/question_types/yesno_question_widget.dart` | 56, 73 |
| `surveys/widgets/survey_preview_dialog.dart` | 353 |
| `surveys/widgets/question_bank_import_dialog.dart` | 234 |
| `templates/pages/template_list_page.dart` | 363 |
| `templates/widgets/template_preview_dialog.dart` | 407 |
| `settings/pages/settings_page.dart` | 188 |

---

## 2. TextButton → AppTextButton

### Before:
```dart
TextButton(
  onPressed: () { ... },
  style: TextButton.styleFrom(
    foregroundColor: AppTheme.primary,
  ),
  child: Text('Cancel'),
)
```

### After:
```dart
AppTextButton(
  label: 'Cancel',
  onPressed: () { ... },
)
```

### With custom color:
```dart
AppTextButton(
  label: 'Delete',
  onPressed: () { ... },
  textColor: AppTheme.error,
)
```

### Files to migrate:

| File | Lines |
|------|-------|
| `messaging/pages/messaging_inbox_page.dart` | 424, 628, 1187, 1194 |
| `messaging/pages/friend_request_page.dart` | 285, 295 |
| `auth/widgets/login_form.dart` | 157 |
| `auth/pages/request_account_page.dart` | 342 |
| `auth/pages/forgot_password_page.dart` | 201 |
| `auth/pages/reset_password_page.dart` | 263, 361 |
| `hcp_clients/pages/hcp_client_list_page.dart` | 290 |
| `question_bank/widgets/question_bank_form_dialog.dart` | 409 |
| `surveys/widgets/survey_question_card.dart` | 464 |
| `admin/pages/audit_log_page.dart` | 217 |
| `researcher/pages/researcher_pull_data_page.dart` | 190, 886 |

---

## 3. OutlinedButton → AppOutlinedButton (NEW)

### Before:
```dart
OutlinedButton.icon(
  onPressed: _retry,
  icon: Icon(Icons.refresh),
  label: Text('Retry'),
)
```

### After:
```dart
AppOutlinedButton(
  label: 'Retry',
  icon: Icons.refresh,
  onPressed: _retry,
)
```

### With custom colors:
```dart
AppOutlinedButton(
  label: 'Cancel',
  onPressed: () { ... },
  foregroundColor: AppTheme.error,
  borderColor: AppTheme.error,
)
```

### Files to migrate:

| File | Lines |
|------|-------|
| `participant/pages/participant_surveys_page.dart` | 90 |
| `admin/pages/database_viewer_page.dart` | 58, 136, 579 |
| `researcher/pages/researcher_pull_data_page.dart` | multiple retry/download buttons |

---

## 4. SnackBar → AppToast

**20+ files affected.**

### Before:
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('User created successfully'),
    backgroundColor: AppTheme.success,
  ),
);
```

### After:
```dart
AppToast.showSuccess(context, message: 'User created successfully');
```

### Variants:
```dart
AppToast.showSuccess(context, message: '...');
AppToast.showError(context, message: '...');
AppToast.showInfo(context, message: '...');
AppToast.showCaution(context, message: '...');
```

### Files to migrate:

| File | Count |
|------|-------|
| `messaging/pages/messaging_inbox_page.dart` | 4 |
| `messaging/pages/friend_request_page.dart` | 2 |
| `messaging/pages/new_conversation_page.dart` | 1 |
| `messaging/pages/conversation_page.dart` | 1 |
| `participant/pages/participant_surveys_page.dart` | 2 |
| `participant/pages/participant_tasks_page.dart` | 1 |
| `surveys/pages/survey_list_page.dart` | 3+ |
| `surveys/pages/survey_builder_page.dart` | 1 |
| `hcp_clients/pages/hcp_client_list_page.dart` | 1 |
| `admin/pages/user_management_page.dart` | 2 |
| `admin/pages/messages_page.dart` | 1 |
| `templates/pages/template_builder_page.dart` | 1 |
| `templates/pages/template_list_page.dart` | 1 |
| `question_bank/pages/question_bank_page.dart` | 1 |
| `auth/pages/login_page.dart` | 1 |
| `admin/widgets/impersonation_banner.dart` | 1 |
| `admin/widgets/reset_password_modal.dart` | 1 |
| `surveys/widgets/survey_assignment_modal.dart` | 1 |
| `researcher/pages/researcher_pull_data_page.dart` | 1 |

---

## 5. CircleAvatar initials → AppUserAvatar (NEW)

### Before:
```dart
CircleAvatar(
  backgroundColor: AppTheme.primary.withAlpha(26),
  radius: 18,
  child: Text(
    name.isNotEmpty ? name[0].toUpperCase() : '?',
    style: const TextStyle(
      color: AppTheme.primary,
      fontWeight: FontWeight.bold,
    ),
  ),
)
```

### After:
```dart
AppUserAvatar(name: name)
```

### With custom size/color:
```dart
AppUserAvatar(
  name: name,
  radius: 24,
  backgroundColor: AppTheme.info.withValues(alpha: 0.1),
  foregroundColor: AppTheme.info,
)
```

### Files to migrate:

| File | Lines |
|------|-------|
| `messaging/pages/messaging_inbox_page.dart` | 588, 772, 1166 |
| `messaging/pages/friend_request_page.dart` | 267 |
| `admin/widgets/reset_password_modal.dart` | 159 |

---

## 6. Container card surface → AppCard (NEW)

### Before:
```dart
Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: AppTheme.white,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: AppTheme.gray),
  ),
  child: ...,
)
```

### After:
```dart
AppCard(
  padding: const EdgeInsets.all(20),
  child: ...,
)
```

### Interactive card:
```dart
AppCard(
  onTap: () { ... },
  child: ...,
)
```

### Files to migrate:

| File | Lines | Notes |
|------|-------|-------|
| `messaging/pages/friend_request_page.dart` | 113-119, 256-264 | Send request section, FriendRequestTile |
| `messaging/pages/new_conversation_page.dart` | 414-420 | RecipientTile |
| `messaging/pages/messaging_inbox_page.dart` | 760-824, 1647-1653 | ConversationTile, SheetRecipientTile |
| `admin/pages/database_viewer_page.dart` | 173-178, 346-351, 598-630, 625-631 | Multiple panels |

---

## 7. Inline drag handle → AppBottomSheetHandle (NEW)

### Before:
```dart
Padding(
  padding: const EdgeInsets.only(top: 12, bottom: 4),
  child: Container(
    width: 40,
    height: 4,
    decoration: BoxDecoration(
      color: AppTheme.textMuted.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(2),
    ),
  ),
)
```

### After:
```dart
const AppBottomSheetHandle()
```

### Files to migrate:

| File | Lines |
|------|-------|
| `participant/pages/participant_surveys_page.dart` | 386-394 |
| `messaging/pages/messaging_inbox_page.dart` | multiple sheet headers |

---

## 8. Status chips → AppBadge (EXISTING but underused)

### Before:
```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  decoration: BoxDecoration(
    color: statusColor.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(4),
  ),
  child: Text(
    'Completed',
    style: TextStyle(color: statusColor, fontWeight: FontWeight.w500),
  ),
)
```

### After:
```dart
AppBadge(
  label: 'Completed',
  variant: AppBadgeVariant.success,
  size: AppBadgeSize.small,
)
```

### Variant mapping:
| Color | Variant |
|-------|---------|
| `AppTheme.primary` (navy) | `AppBadgeVariant.primary` |
| `AppTheme.success` (green) | `AppBadgeVariant.success` |
| `AppTheme.caution` (orange) | `AppBadgeVariant.caution` |
| `AppTheme.error` (red) | `AppBadgeVariant.error` |
| `AppTheme.info` (blue) | `AppBadgeVariant.info` |

### Files to migrate:

| File | Description |
|------|-------------|
| `participant/pages/participant_surveys_page.dart` | Survey status chips (pending/completed/expired) |
| `admin/pages/database_viewer_page.dart` | Constraint chips (PK/FK/NN), count pills |
| `admin/pages/user_management_page.dart` | User role and status chips |
| `hcp_clients/pages/hcp_client_list_page.dart` | Link status chips |
| `surveys/pages/survey_list_page.dart` | Survey status chips |
| `researcher/pages/researcher_pull_data_page.dart` | Data type labels |

---

## 9. Inline banners → AppAnnouncement (EXISTING but underused)

### Before:
```dart
Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: AppTheme.success.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(6),
    border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
  ),
  child: Row(
    children: [
      Icon(Icons.check_circle, color: AppTheme.success),
      const SizedBox(width: 8),
      Expanded(child: Text('Request sent successfully')),
    ],
  ),
)
```

### After:
```dart
AppAnnouncement(
  message: 'Request sent successfully',
  icon: Icons.check_circle,
  backgroundColor: AppTheme.success.withValues(alpha: 0.1),
  textColor: AppTheme.success,
  borderColor: AppTheme.success.withValues(alpha: 0.3),
)
```

### Files to migrate:

| File | Lines |
|------|-------|
| `messaging/pages/friend_request_page.dart` | 141-166 |
| `participant/pages/participant_surveys_page.dart` | 477-498 |
| `admin/pages/database_viewer_page.dart` | error states |

---

## 10. DropdownButtonFormField → AppDropdownMenu

### Before:
```dart
DropdownButtonFormField<String>(
  initialValue: _selected,
  isExpanded: true,
  decoration: InputDecoration(
    labelText: 'Filter',
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
  ),
  items: [
    DropdownMenuItem(value: 'a', child: Text('Option A')),
    DropdownMenuItem(value: 'b', child: Text('Option B')),
  ],
  onChanged: (v) { ... },
)
```

### After:
```dart
AppDropdownMenu<String>(
  hintText: 'Filter',
  initialValue: _selected,
  options: [
    AppDropdownOption(value: 'a', label: 'Option A'),
    AppDropdownOption(value: 'b', label: 'Option B'),
  ],
  onChanged: (v) { ... },
)
```

### Files to migrate:

| File | Lines |
|------|-------|
| `admin/pages/database_viewer_page.dart` | 188-222, 267-302 |

---

## 11. Raw TextField → AppSearchBar / AppTextInput

### Before:
```dart
TextField(
  decoration: InputDecoration(
    hintText: 'Search...',
    prefixIcon: Icon(Icons.search),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  ),
  onChanged: (v) { ... },
)
```

### After:
```dart
AppSearchBar(
  hintText: 'Search...',
  onChanged: (v) { ... },
)
```

### For general text inputs:
```dart
AppTextInput(
  controller: _controller,
  label: context.l10n.accountIdLabel,  // Always localized!
)
```

### Files to migrate:

| File | Lines | Notes |
|------|-------|-------|
| `new_conversation_page.dart` | 305-315 | Use `AppSearchBar` |
| `new_conversation_page.dart` | 365-375 | Use `AppTextInput` + add l10n for 'Account ID' |

---

## 12. Duplicated Widgets to Deduplicate

### `_RecipientTile` / `_SheetRecipientTile`

These two private widgets are identical across two files:
- `messaging/pages/new_conversation_page.dart` lines 396-438
- `messaging/pages/messaging_inbox_page.dart` lines 1628-1671

**Action:** Extract to `messaging/widgets/recipient_tile.dart` and import in both pages.

---

## Migration Order (Recommended)

Work in this order to get the highest impact with the least risk:

### Phase 1: Low-risk, high-count (buttons + toasts)
1. `ElevatedButton` → `AppFilledButton` / `AppLongButton` (30+ sites)
2. `TextButton` → `AppTextButton` (11 files)
3. `OutlinedButton` → `AppOutlinedButton` (3 files)
4. `SnackBar` → `AppToast` (20+ sites)

### Phase 2: New widget adoption
5. `CircleAvatar` initials → `AppUserAvatar` (5 sites)
6. `Container` card surface → `AppCard` (10+ sites)
7. Drag handle → `AppBottomSheetHandle` (3+ sites)

### Phase 3: Underused existing widgets
8. Status chips → `AppBadge` (6 files)
9. Inline banners → `AppAnnouncement` (3 files)
10. `DropdownButtonFormField` → `AppDropdownMenu` (1 file)
11. Raw `TextField` → `AppSearchBar` / `AppTextInput` (1 file)

### Phase 4: Cleanup
12. Deduplicate `_RecipientTile` into shared widget
13. Add missing l10n keys for any hardcoded strings found during migration

---

## Checklist Per File

For each file you migrate:

- [ ] Add correct import for the global widget
- [ ] Replace all instances of the anti-pattern
- [ ] Remove unused imports (e.g. if `AppTheme` was only used for button styling)
- [ ] Run `flutter analyze` — no new warnings
- [ ] Verify l10n: no hardcoded user-facing strings
- [ ] Visual spot-check: widget looks the same after migration
