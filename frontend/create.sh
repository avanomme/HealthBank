#!/usr/bin/env bash
set -e

echo "Scaffolding HealthBank frontend structure (features + tests)..."

########################################
# Helper
########################################

ensure_file() {
  local path="$1"
  if [ ! -f "$path" ]; then
    touch "$path"
    echo "  created: $path"
  else
    echo "  exists:  $path"
  fi
}

########################################
# Core app / config / shells
########################################

mkdir -p \
  lib/app/shell \
  lib/core/theme \
  lib/core/auth \
  lib/core/api \
  lib/config

# Main entry + router (empty; you’ll fill these)
ensure_file lib/main.dart
ensure_file lib/config/go_router.dart

# Role shells (empty for now)
ensure_file lib/app/shell/participant_shell.dart
ensure_file lib/app/shell/researcher_shell.dart
ensure_file lib/app/shell/hcp_shell.dart
ensure_file lib/app/shell/admin_shell.dart

########################################
# Feature modules
########################################

BASE="lib/features"

mkdir -p \
  $BASE/auth/{pages,state,services} \
  $BASE/account/{pages,state,services} \
  $BASE/surveys/{models,services,state,pages,widgets} \
  $BASE/compare/{pages,services,state,widgets} \
  $BASE/analytics/{pages,services,state,widgets} \
  $BASE/hcp_clients/{pages,services,state,widgets} \
  $BASE/admin/{pages,services,state,widgets} \
  $BASE/dashboard/pages

# AUTH pages
ensure_file $BASE/auth/pages/login_page.dart
ensure_file $BASE/auth/pages/logout_confirm_page.dart
ensure_file $BASE/auth/pages/forgot_password_page.dart
ensure_file $BASE/auth/pages/reset_password_page.dart

# ACCOUNT pages
ensure_file $BASE/account/pages/account_settings_page.dart
ensure_file $BASE/account/pages/privacy_settings_page.dart
ensure_file $BASE/account/pages/notification_settings_page.dart

# SURVEYS pages
ensure_file $BASE/surveys/pages/todo_surveys_page.dart
ensure_file $BASE/surveys/pages/survey_take_page.dart
ensure_file $BASE/surveys/pages/survey_thanks_page.dart
ensure_file $BASE/surveys/pages/survey_progress_page.dart
ensure_file $BASE/surveys/pages/survey_create_page.dart
ensure_file $BASE/surveys/pages/survey_builder_page.dart
ensure_file $BASE/surveys/pages/survey_preview_page.dart
ensure_file $BASE/surveys/pages/survey_manage_page.dart

# SURVEYS widgets
ensure_file $BASE/surveys/widgets/question_card_widget.dart
ensure_file $BASE/surveys/widgets/question_editor_widget.dart

# COMPARE pages
ensure_file $BASE/compare/pages/compare_page.dart

# ANALYTICS pages
ensure_file $BASE/analytics/pages/pull_data_page.dart
ensure_file $BASE/analytics/pages/export_page.dart

# HCP CLIENTS pages
ensure_file $BASE/hcp_clients/pages/hcp_client_list_page.dart
ensure_file $BASE/hcp_clients/pages/hcp_client_detail_page.dart

# ADMIN pages
ensure_file $BASE/admin/pages/admin_dashboard_page.dart
ensure_file $BASE/admin/pages/user_management_page.dart
ensure_file $BASE/admin/pages/database_management_page.dart
ensure_file $BASE/admin/pages/api_management_page.dart
ensure_file $BASE/admin/pages/page_management_page.dart
ensure_file $BASE/admin/pages/logs_page.dart

# DASHBOARD pages (per role)
ensure_file $BASE/dashboard/pages/participant_dashboard_page.dart
ensure_file $BASE/dashboard/pages/researcher_dashboard_page.dart
ensure_file $BASE/dashboard/pages/hcp_dashboard_page.dart

########################################
# Role barrels under lib/screens (admin.dart, etc.)
########################################

mkdir -p \
  lib/screens/admin \
  lib/screens/participant \
  lib/screens/researcher \
  lib/screens/hcp \
  lib/screens/auth

ensure_file lib/screens/admin/admin.dart
ensure_file lib/screens/participant/participant.dart
ensure_file lib/screens/researcher/researcher.dart
ensure_file lib/screens/hcp/hcp.dart
ensure_file lib/screens/auth/auth.dart

########################################
# Test structure
########################################

mkdir -p \
  test/router \
  test/features/auth \
  test/features/account \
  test/features/surveys \
  test/features/compare \
  test/features/analytics \
  test/features/hcp_clients \
  test/features/admin \
  test/features/dashboard

# Router test placeholder
ensure_file test/router/router_test.dart

# AUTH tests
ensure_file test/features/auth/login_page_test.dart
ensure_file test/features/auth/logout_confirm_page_test.dart
ensure_file test/features/auth/forgot_password_page_test.dart
ensure_file test/features/auth/reset_password_page_test.dart

# ACCOUNT tests
ensure_file test/features/account/account_settings_page_test.dart
ensure_file test/features/account/privacy_settings_page_test.dart
ensure_file test/features/account/notification_settings_page_test.dart

# SURVEYS tests
ensure_file test/features/surveys/todo_surveys_page_test.dart
ensure_file test/features/surveys/survey_take_page_test.dart
ensure_file test/features/surveys/survey_thanks_page_test.dart
ensure_file test/features/surveys/survey_progress_page_test.dart
ensure_file test/features/surveys/survey_create_page_test.dart
ensure_file test/features/surveys/survey_builder_page_test.dart
ensure_file test/features/surveys/survey_preview_page_test.dart
ensure_file test/features/surveys/survey_manage_page_test.dart

# COMPARE tests
ensure_file test/features/compare/compare_page_test.dart

# ANALYTICS tests
ensure_file test/features/analytics/pull_data_page_test.dart
ensure_file test/features/analytics/export_page_test.dart

# HCP CLIENTS tests
ensure_file test/features/hcp_clients/hcp_client_list_page_test.dart
ensure_file test/features/hcp_clients/hcp_client_detail_page_test.dart

# ADMIN tests
ensure_file test/features/admin/admin_dashboard_page_test.dart
ensure_file test/features/admin/user_management_page_test.dart
ensure_file test/features/admin/database_management_page_test.dart
ensure_file test/features/admin/api_management_page_test.dart
ensure_file test/features/admin/page_management_page_test.dart
ensure_file test/features/admin/logs_page_test.dart

# DASHBOARD tests
ensure_file test/features/dashboard/participant_dashboard_page_test.dart
ensure_file test/features/dashboard/researcher_dashboard_page_test.dart
ensure_file test/features/dashboard/hcp_dashboard_page_test.dart

########################################
# Optional: legacy cleanup (commented out for safety)
########################################
echo
echo "NOTE: Legacy screen folders still exist under lib/screens/..."
echo "You can remove old per-role dashboard/surveys dirs manually when ready."
echo "For example (AFTER migrating imports):"
echo "  rm -rf lib/screens/participant/dashboard"
echo "  rm -rf lib/screens/researcher/dashboard"
echo "  rm -rf lib/screens/hcp/dashboard"
echo "  rm -rf lib/screens/admin/{dashboard,surveys,settings,users}"

echo
echo "✅ Scaffolding complete. All required feature pages and matching test files now exist (empty)."