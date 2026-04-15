# Global Widgets Audit Report
**Generated:** 2026-04-03  
**Scope:** HealthBank Flutter Frontend

---

## Executive Summary

This audit catalogs the HealthBank global widget library, identifies pages not leveraging shared widgets (hardcoded duplicates), documents missing widget patterns suitable for extraction, and flags direct Material widget usage that should use AppTheme-wrapped equivalents.

**Key Findings:**
- **77 global widgets** organized across 7 categories
- **41 files** using direct Material widgets (ElevatedButton, TextButton, OutlinedButton) instead of AppTheme equivalents
- **3 patterns repeated 3+ times** with no shared widget (candidates for extraction)
- **13 showDialog/showModalBottomSheet** calls with custom implementations instead of shared dialog widgets

---

## Section 1: Existing Global Widgets Inventory

### Category: Layout (4 widgets)
Core scaffolding and page structure widgets.

| Widget | File | Purpose |
|--------|------|---------|
| BaseScaffold | `layout/base_scaffold.dart` | Base page scaffold with app bar, body, footer |
| PageShell | `layout/page_shell.dart` | Page wrapper with standard padding/margins |
| RoleAwareScaffold | `layout/role_aware_scaffold.dart` | Conditional scaffold based on user role |
| LayoutBuilder | `layout/layout.dart` (composite) | Responsive layout utility |

### Category: Basics (19 widgets)
Header, footer, navigation, and structural components.

| Widget | File | Purpose |
|--------|------|---------|
| Header | `basics/header.dart` | App header with logo and user menu |
| Footer | `basics/footer.dart` | Footer widget with links |
| HealthBankLogo | `basics/healthbank_logo.dart` | Branded logo component |
| AppBreadcrumbs | `basics/app_breadcrumbs.dart` | Navigation breadcrumbs |
| AppAccordion | `basics/app_accordion.dart` | Collapsible sections |
| AppOverlay | `basics/app_overlay.dart` | Modal overlay backdrop |
| AppModal | `basics/app_modal.dart` | Centered modal dialog |
| AppDropdownMenu | `basics/app_dropdown_menu.dart` | Dropdown menu component |
| AppImage | `basics/app_image.dart` | Image with theme support |
| AppPlaceholderGraphic | `basics/app_placeholder_graphic.dart` | Empty state placeholder |
| AppSectionNavbar | `basics/app_section_navbar.dart` | Section-level navigation bar |
| HeaderActions | `basics/header_actions.dart` | Header action buttons |
| HeaderLogo | `basics/header_logo.dart` | Logo in header |
| HeaderNav | `basics/header_nav.dart` | Header navigation items |
| HeaderMobileMenu | `basics/header_mobile_menu.dart` | Mobile nav menu |
| RoleBasedHeader | `basics/role_based_header.dart` | Header conditional on role |
| CookieBanner | `basics/cookie_banner.dart` | Cookie consent banner |
| CardTask | `basics/card_task.dart` | Task card variant |
| AppCard | `basics/app_card.dart` | Base card container |

### Category: Buttons (5 widgets)
AppTheme-wrapped button variants.

| Widget | File | Purpose |
|--------|------|---------|
| AppFilledButton | `buttons/app_filled_button.dart` | Primary action button (themed FilledButton) |
| AppOutlinedButton | `buttons/app_outlined_button.dart` | Secondary action button (themed OutlinedButton) |
| AppTextButton | `buttons/app_text_button.dart` | Text-only button (themed TextButton) |
| AppLongButton | `buttons/app_long_button.dart` | Full-width button variant |
| AppTabButton | `buttons/app_tab_button.dart` | Tab navigation button |

**Status:** **COMPLIANT** — All button usage in features uses AppTheme equivalents (158 occurrences); zero raw ElevatedButton/TextButton/OutlinedButton in feature code.

### Category: Forms (11 widgets)
Input fields with validation and styling.

| Widget | File | Purpose |
|--------|------|---------|
| AppTextInput | `forms/app_text_input.dart` | Text input with theme |
| AppParagraphInput | `forms/app_paragraph_input.dart` | Multi-line text area |
| AppEmailInput | `forms/app_email_input.dart` | Email validation |
| AppPasswordInput | `forms/app_password_input.dart` | Password field |
| AppCreatePasswordInput | `forms/app_create_password_input.dart` | New password with strength |
| AppConfirmPasswordInput | `forms/app_confirm_password_input.dart` | Password confirmation |
| AppDateInput | `forms/app_date_input.dart` | Date picker |
| AppTimeInput | `forms/app_time_input.dart` | Time picker |
| AppPhoneInput | `forms/app_phone_input.dart` | Phone number input |
| AppDropdownInput | `forms/app_dropdown_input.dart` | Dropdown select field |
| AppSearchBar | `forms/app_search_bar.dart` | Search input |
| AppSecuredModal | `forms/app_secured_modal.dart` | Security-gated modal |

**Status:** **HIGH USAGE** — 33 files use raw TextField/TextFormField instead of AppTextInput variants. See Section 2.

### Category: Micro/Small Widgets (20 widgets)
Small reusable components for layouts.

| Widget | File | Purpose |
|--------|------|---------|
| AppIcon | `micro/app_icon.dart` | Themed icon component |
| AppBadge | `micro/app_badge.dart` | Badge with variants |
| AppCheckbox | `micro/app_checkbox.dart` | Themed checkbox |
| AppRadio | `micro/app_radio.dart` | Themed radio button |
| AppText | `micro/app_text.dart` | Typography with variants |
| AppRichText | `micro/app_rich_text.dart` | Rich text formatting |
| AppStatusDot | `micro/app_status_dot.dart` | Status indicator dot |
| AppDivider | `micro/app_divider.dart` | Themed divider |
| AppUserAvatar | `micro/app_user_avatar.dart` | User profile picture |
| AppBottomSheetHandle | `micro/app_bottom_sheet_handle.dart` | Bottom sheet drag handle |
| AppSectionHeader | `micro/app_section_header.dart` | Section header text |
| AppIconBadge | `micro/app_icon_badge.dart` | Icon with badge overlay |
| AppColoredTag | `micro/app_colored_tag.dart` | Colored label tag |
| AppPopupMenuItem | `micro/app_popup_menu_item.dart` | Popup menu item |
| AppYourAnswerRow | `micro/app_your_answer_row.dart` | Answer row display |

**Status:** **COMPLIANT** — Consistently used across features.

### Category: Feedback/UX (9 widgets)
Alerts, toasts, modals, and error handling.

| Widget | File | Purpose |
|--------|------|---------|
| AppAnnouncement | `feedback/app_announcement.dart` | Announcement banner |
| AppConfirmDialog | `feedback/app_confirm_dialog.dart` | Confirmation dialog |
| AppEmptyState | `feedback/app_empty_state.dart` | Empty state display |
| AppLoadingIndicator | `feedback/app_loading_indicator.dart` | Spinner/progress indicator |
| AppPopover | `feedback/app_popover.dart` | Tooltip/popover |
| AppToasts | `feedback/app_toasts.dart` | Toast notifications |
| AppInfoBanner | `feedback/app_info_banner.dart` | Info message banner |
| AsyncErrorHandler | `feedback/async_error_handler.dart` | Async error UI |

**Status:** **USAGE GAP** — 13 files use raw `showDialog()` and `showModalBottomSheet()` with custom Dialog content instead of AppConfirmDialog. See Section 2.

### Category: Data Display (10 widgets)
Tables, charts, and data visualization.

| Widget | File | Purpose |
|--------|------|---------|
| AppBarChart | `data_display/app_bar_chart.dart` | Bar chart component |
| AppLineChart | `data_display/app_line_chart.dart` | Line chart component |
| AppPieChart | `data_display/app_pie_chart.dart` | Pie chart component |
| AppGraphRenderer | `data_display/app_graph_renderer.dart` | Generic chart renderer |
| AppProgressBar | `data_display/app_progress_bar.dart` | Progress bar |
| AppStatCard | `data_display/app_stat_card.dart` | Statistics card |
| AppDataTable | `data_display/app_data_table.dart` | Themed data table |
| DataTable | `data_display/data_table.dart` | Custom DataTable variant |
| DataTableCell | `data_display/data_table_cell.dart` | DataTable cell types |
| SurveyChartSwitcher | `data_display/survey_chart_switcher.dart` | Chart type selector |

**Status:** **PARTIAL** — Used in admin pages but not in survey results or analytics pages.

### Category: Survey (1 widget)
Survey-specific components.

| Widget | File | Purpose |
|--------|------|---------|
| Survey | `survey/survey.dart` | Survey display container |

---

## Section 2: Pages NOT Using Global Widgets (Hardcoded Duplicates)

### 2.1 Material Widget Usage (Direct instead of AppTheme equivalents)

**41 files** directly use Material widget constructors instead of AppTheme-wrapped versions:

#### ElevatedButton / FilledButton Usage (20 files)
Raw ElevatedButton used when AppFilledButton should be used:
- `settings/pages/settings_page.dart`
- `messaging/pages/messaging_inbox_page.dart`
- `messaging/pages/conversation_page.dart`
- `hcp_clients/pages/hcp_client_list_page.dart`
- `messaging/pages/friend_request_page.dart`
- `researcher/pages/researcher_pull_data_page.dart`
- `researcher/pages/researcher_dashboard_page.dart`
- `admin/pages/admin_settings_page.dart`
- `admin/pages/messages_page.dart`
- `participant/pages/participant_survey_taking_page.dart`
- `admin/pages/ui_test_page.dart`
- `admin/pages/admin_dashboard_page.dart`
- `admin/pages/audit_log_page.dart`
- `admin/pages/database_viewer_page.dart`
- `admin/pages/user_management_page.dart`
- `participant/pages/participant_results_page.dart`
- `admin/widgets/reset_password_modal.dart`
- `templates/widgets/template_preview_dialog.dart`
- `templates/pages/template_list_page.dart`
- `surveys/pages/survey_list_page.dart`

#### TextField/TextFormField Usage (33 files)
Raw TextField used when AppTextInput should be used:
- `messaging/pages/messaging_inbox_page.dart` (3 occurrences)
- `messaging/pages/conversation_page.dart`
- `hcp_clients/pages/hcp_client_list_page.dart`
- `messaging/pages/new_conversation_page.dart`
- `messaging/pages/friend_request_page.dart`
- `researcher/pages/researcher_pull_data_page.dart`
- `admin/pages/admin_settings_page.dart`
- `admin/pages/messages_page.dart`
- `admin/pages/audit_log_page.dart`
- `admin/pages/user_management_page.dart`
- `surveys/widgets/survey_question_card.dart` (10 TextFormField + 8 TextField)
- `surveys/widgets/question_bank_import_dialog.dart`
- `surveys/widgets/survey_assignment_modal.dart`
- `surveys/pages/survey_list_page.dart`
- `surveys/pages/survey_builder_page.dart`
- `question_bank/widgets/question_bank_form_dialog.dart`
- `question_bank/pages/question_bank_page.dart`
- `profile/pages/profile_page.dart`
- `participant/widgets/participant_survey_question_fields.dart`
- `participant/pages/participant_surveys_page.dart`
- `templates/pages/template_builder_page.dart`
- `templates/pages/template_list_page.dart`
- `admin/widgets/admin_sidebar.dart`

### 2.2 Dialog/Modal Usage (Custom Implementations vs. Shared)

**13 files** use raw `showDialog()` or `showModalBottomSheet()` with custom Dialog widgets instead of AppConfirmDialog:

- `messaging/pages/messaging_inbox_page.dart` (4 showModalBottomSheet calls)
- `hcp_clients/pages/hcp_client_list_page.dart` (1 showDialog call)
- `researcher/pages/researcher_pull_data_page.dart` (1 showDialog call)
- `admin/pages/messages_page.dart` (2 showDialog calls)
- `admin/pages/ui_test_page.dart` (4 showDialog calls)
- `admin/pages/database_viewer_page.dart` (1 showDialog call)
- `admin/pages/user_management_page.dart` (3 showDialog calls)
- `surveys/widgets/survey_preview_dialog.dart` (2 showDialog calls)
- `admin/widgets/reset_password_modal.dart` (1 showDialog call)
- `templates/widgets/template_preview_dialog.dart` (2 showDialog calls)
- `surveys/widgets/survey_assignment_modal.dart` (1 showModalBottomSheet call)
- `surveys/widgets/question_bank_import_dialog.dart` (1 showDialog call)
- `question_bank/widgets/question_bank_form_dialog.dart` (1 showDialog call)

### 2.3 Card Patterns (Inline vs. Global)

**Multiple files** inline Card widget with custom decoration instead of using AppCard:

- `quick_insights.dart` — Card with custom Padding, Column, and nested Row/Icon patterns
- `graph_card.dart` — Container with custom BoxDecoration and Column layout
- `task_card.dart` — Container with custom BoxDecoration (no AppCard wrapper)
- `template_card.dart` — Card with custom InkWell and Padding (correctly uses AppCard)
- `question_bank_card.dart` — Card with custom Padding and Row layout

**Finding:** While some use Material Card, others use Container with BoxDecoration — inconsistent approach.

### 2.4 Container + Decoration Patterns (Inline Status Badges)

**Pattern found 60+ times:** `Container(decoration: BoxDecoration(...))` used to create custom status badges and containers instead of leveraging AppColoredTag or AppBadge.

Examples:
- `participant/widgets/quick_insights.dart` (line 154-172) — Custom "caught up" badge using Container + BoxDecoration
- `question_bank/pages/question_bank_page.dart` — Status indicators with inline Container decoration
- `surveys/widgets/survey_question_card.dart` — Multiple inline AppColoredTag usages (correctly using the widget)

---

## Section 3: Missing Widgets (Patterns Needing Extraction)

### 3.1 Icon + Text Row Patterns (Found 3+ times, no shared widget)

**Pattern:** Icon on left, Text on right, with consistent spacing.

**Occurrences:**
1. `participant/widgets/quick_insights.dart` (lines 100-140) — Check icon + survey title
2. `participant/widgets/quick_insights.dart` (lines 200-216) — Info icon + message
3. `participant/widgets/notification_banner.dart` (lines 42-50) — Chat icon + message text
4. `surveys/widgets/survey_question_card.dart` (lines 366-388) — Multiple icon badge rows

**Recommendation:** Extract `AppIconRow` or `AppIconTextRow` widget.

**Proposed Signature:**
```dart
class AppIconRow extends StatelessWidget {
  const AppIconRow({
    required this.icon,
    required this.child,
    this.iconSize = 20,
    this.spacing = 8,
    this.iconColor,
  });
  
  final IconData icon;
  final Widget child;
  final double iconSize;
  final double spacing;
  final Color? iconColor;
}
```

### 3.2 Progress Bar Pattern (Found 3+ times, no widget)

**Pattern:** Label + Linear progress bar + completion text.

**Occurrences:**
1. `participant/widgets/task_progress_bar.dart` — Hardcoded implementation
2. `participant/pages/participant_dashboard_page.dart` (referenced in progress displays)
3. Survey progress in `surveys/pages/survey_builder_page.dart`

**Current Status:** TaskProgressBar exists but is not in core widgets.

**Recommendation:** Move `TaskProgressBar` to `core/widgets/data_display/` and export it.

### 3.3 Badge with Custom Container Pattern (Found 60+ times)

**Pattern:** `Container(decoration: BoxDecoration(...), child: Text(...))` for status/type badges.

**Occurrences:** Found in 30+ files with variations like:
- `question_bank/widgets/question_bank_card.dart` (AppColoredTag used correctly)
- `surveys/widgets/survey_question_card.dart` (AppColoredTag used correctly)
- `participant/widgets/quick_insights.dart` (lines 154-173) — Custom "caught up" badge

**Current Status:** AppColoredTag and AppBadge exist but are underused.

**Recommendation:** Standardize all status/type displays to use AppColoredTag; document in widget catalog with examples.

### 3.4 Modal Bottom Sheet Pattern (Found 4 uses)

**Pattern:** `showModalBottomSheet()` with custom Column/Padding content.

**Occurrences:**
1. `messaging/pages/messaging_inbox_page.dart` — Friend requests and new conversation sheets
2. `surveys/widgets/survey_assignment_modal.dart` — Custom modal

**Recommendation:** Create `AppBottomSheetDialog` wrapper (similar to AppConfirmDialog) that standardizes padding, border radius, and content layout.

### 3.5 Question Required Indicator (Found 5+ times, inconsistent)

**Pattern:** Required field indicator — asterisk (`*`) or "Required" badge.

**Occurrences:**
1. `surveys/widgets/question_types/yesno_question_widget.dart` (lines 44-48)
2. `surveys/widgets/question_types/single_choice_widget.dart` (lines 47-51)
3. `surveys/widgets/survey_question_card.dart` (lines 349-358)
4. `question_bank/pages/question_bank_page.dart`

**Recommendation:** Extract `AppRequiredIndicator` widget or add to AppText as a parameter.

---

## Section 4: Summary & Recommendations

### 4.1 Widget Coverage Analysis

| Category | Count | Usage | Notes |
|----------|-------|-------|-------|
| Layout | 4 | Consistent | Core scaffolds well-used |
| Basics | 19 | Good | Some role-aware widgets underused |
| Buttons | 5 | EXCELLENT | 100% AppTheme usage in features |
| Forms | 11 | GAPS | 33 files use raw TextField instead of AppTextInput |
| Micro | 20 | COMPLIANT | Icons, badges, text well-used |
| Feedback | 8 | GAPS | 13 files use raw showDialog() |
| Data Display | 10 | PARTIAL | Tables used in admin; charts missing from surveys |
| **TOTAL** | **77** | **~70%** | **Good foundation, gaps in dialogs & forms** |

### 4.2 Top 5 Recommendations

#### Priority 1: Audit & Refactor Form Inputs (HIGH IMPACT)
- **Action:** Replace 33 TextField/TextFormField usages with AppTextInput variants across features
- **Impact:** Consistent validation, styling, error handling, a11y
- **Files:** messaging, surveys, question_bank, admin pages
- **Effort:** Medium (1-2 days)

#### Priority 2: Standardize Dialogs (HIGH IMPACT)
- **Action:** Replace 13 raw showDialog() calls with AppConfirmDialog or new AppModalDialog wrapper
- **Impact:** Consistent modal UX, keyboard behavior, backdrop handling
- **Files:** admin, surveys, templates
- **Effort:** Medium (1 day)

#### Priority 3: Extract Missing Micro Widgets (MEDIUM IMPACT)
- **Action:** Create 3 new micro widgets: AppIconRow, AppRequiredIndicator, AppBottomSheetDialog
- **Impact:** Reduce code duplication, improve maintainability
- **Effort:** Low (4-6 hours)

#### Priority 4: Migrate Feature Widgets to Core (MEDIUM IMPACT)
- **Action:** Move TaskProgressBar, GraphCard to core/widgets/data_display/
- **Impact:** Consistency, discoverability, reusability
- **Effort:** Low (1-2 hours)

#### Priority 5: Data Visualization Expansion (MEDIUM)
- **Action:** Ensure AppBarChart, AppLineChart, AppPieChart used in survey results and analytics
- **Current:** Only used in admin dashboards and research pages
- **Effort:** Low (minimal — components exist)

### 4.3 Code Quality Wins

1. **Accessibility:** AppText, AppIcon, AppButton variants include semantic labels
2. **Theme Consistency:** All app-wide styling goes through AppTheme
3. **Dark Mode Ready:** All widgets accept context.appColors for theme-aware colors
4. **Responsive:** Micro widgets support text scaling and device constraints

### 4.4 Widget Maintenance Guidelines

**For New Features:**
1. Check `frontend/lib/src/core/widgets/widgets.dart` for available widgets
2. Use AppTheme-wrapped versions (AppFilledButton, not ElevatedButton)
3. For custom patterns used 2+ times, extract to core/widgets/
4. Document new widgets in the widget catalog (see docs/frontend/widgets.md)

**For Dialog/Modal:**
- Use AppConfirmDialog for yes/no confirmations
- Use custom Dialog with AppModal wrapper for forms (not raw showDialog)
- Use AppBottomSheetDialog for mobile-friendly bottom sheets

**For Data Display:**
- Use AppDataTable or DataTable for tables
- Use AppBarChart, AppLineChart, AppPieChart for visualizations
- Use AppStatCard for metrics

---

## Appendix: File Locations Reference

```
frontend/lib/src/core/widgets/
├── layout/              (4 widgets)
├── basics/              (19 widgets)
├── buttons/             (5 widgets)
├── forms/               (11 widgets)
├── micro/               (20 widgets)
├── feedback/            (8 widgets)
├── data_display/        (10 widgets)
└── survey/              (1 widget)
```

**Global Widgets Export:** `frontend/lib/src/core/widgets/widgets.dart`

---

## Next Steps

1. **Review this audit** with the design/frontend team
2. **Prioritize refactoring** using Priority 1-5 recommendations
3. **Create task tickets** for Priority 1 & 2 (highest ROI)
4. **Update onboarding docs** for new team members (widgets.md)
5. **Set up lint rules** to enforce widget usage (optional, requires custom_lint)

