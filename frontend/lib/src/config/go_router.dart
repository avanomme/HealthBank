// Created with the Assistance of Claude Code and Codex
// frontend/lib/src/config/go_router.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/features/Services/pages/help.dart';

// Feature barrels
import 'package:frontend/src/features/auth/auth.dart';
import 'package:frontend/src/features/participant/participant.dart';
import 'package:frontend/src/features/researcher/researcher.dart';
import 'package:frontend/src/features/hcp_clients/hcp.dart';
import 'package:frontend/src/features/admin/admin.dart';
import 'package:frontend/src/features/surveys/surveys.dart';
import 'package:frontend/src/features/templates/templates.dart';
import 'package:frontend/src/features/question_bank/question_bank.dart';
import 'package:frontend/src/features/legal/pages/terms_of_service_page.dart';
import 'package:frontend/src/features/legal/pages/privacy_policy.dart';
import 'package:frontend/src/features/settings/settings.dart';
import 'package:frontend/src/features/messaging/messaging.dart';
import 'package:frontend/src/features/public/public_pages.dart';
import 'package:frontend/src/features/auth/pages/deactivated_notice_page.dart';
import 'package:frontend/src/features/profile/profile.dart';

/// Centralized route path constants for the HealthBank app.
///
/// All navigation should use these constants rather than bare string literals
/// to keep route names consistent and enable compile-time refactoring.
class AppRoutes {
  static const home = '/';
  static const login = '/login';
  static const logout = '/logout';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const requestAccount = '/request-account';
  static const changePassword = '/change-password';
  static const consent = '/consent';
  static const completeProfile = '/complete-profile';
  static const about = '/about';
  static const contact = '/contact';
  static const twoFactor = '/two-factor';
  static const participantDashboard = '/participant/dashboard';
  static const participantSurveys = '/participant/surveys';
  static const participantSurvey = '/participant/surveys/:surveyId';
  static const participantResults = '/participant/results';
  static const participantTasks = '/participant/tasks';
  static const settings = '/settings';
  static const deactivatedNotice = '/deactivated-notice';
  static const profile = '/profile';
  // Researcher routes
  static const researcherDashboard = '/researcher/dashboard';
  static const surveys = '/surveys';
  static const surveyBuilder = '/surveys/new';
  static const surveyEdit = '/surveys/:id/edit';
  static const surveyStatus = '/surveys/:id/status';
  static const templates = '/templates';
  static const templateBuilder = '/templates/new';
  static const templateEdit = '/templates/:id/edit';
  static const questionBank = '/questions';
  static const researcherData = '/researcher/data';
  static const researcherHealthTracking = '/researcher/health-tracking';
  static const participantHealthTracking = '/participant/health-tracking';

  static String surveyStatusPath(int id) => '/surveys/$id/status';
  static String participantSurveyPath(int surveyId) =>
      '/participant/surveys/$surveyId';

  // HCP routes
  static const hcpDashboard = '/hcp/dashboard';
  static const hcpClients = '/hcp/clients';
  static const hcpReports = '/hcp/reports';

  // Admin routes
  static const admin = '/admin';
  static const adminUsers = '/admin/users';
  static const adminDatabase = '/admin/database';
  static const adminMessages = '/admin/messages';
  static const adminDeletionQueue = '/admin/deletion-queue';
  static const adminLogs = '/admin/logs';
  static const adminUiTest = '/admin/ui-test';
  static const adminNavHub = '/admin/nav-hub';
  static const adminSettings = '/admin/settings';
  static const adminHealthTracking = '/admin/health-tracking';
  static const help = '/help';

  // Messaging routes
  static const messagesInbox = '/messages';
  static const messagesNew = '/messages/new';
  static const messagesFriends = '/messages/friends';

  // Legal
  static const termsOfService = '/terms-of-service';
  static const privacyPolicy = '/privacy-policy';
}

/// Returns the browser title for the current route.
String routeTitleForUri(Uri uri) {
  final path = uri.path;
  final suffix = switch (path) {
    AppRoutes.home => 'Home',
    AppRoutes.login => 'Log In',
    AppRoutes.logout => 'Log Out',
    AppRoutes.forgotPassword => 'Forgot Password',
    AppRoutes.resetPassword => 'Reset Password',
    AppRoutes.requestAccount => 'Request Account',
    AppRoutes.changePassword => 'Change Password',
    AppRoutes.consent => 'Consent',
    AppRoutes.completeProfile => 'Complete Profile',
    AppRoutes.about => 'About',
    AppRoutes.contact => 'Contact',
    AppRoutes.twoFactor => 'Two-Factor Authentication',
    AppRoutes.participantDashboard => 'Participant Dashboard',
    AppRoutes.participantSurveys => 'My Surveys',
    AppRoutes.participantResults => 'Results',
    AppRoutes.participantTasks => 'Tasks',
    AppRoutes.settings => 'Settings',
    AppRoutes.deactivatedNotice => 'Account Notice',
    AppRoutes.profile => 'Profile',
    AppRoutes.researcherDashboard => 'Researcher Dashboard',
    AppRoutes.surveys => 'Surveys',
    AppRoutes.surveyBuilder => 'Survey Builder',
    AppRoutes.templates => 'Templates',
    AppRoutes.templateBuilder => 'Template Builder',
    AppRoutes.questionBank => 'Question Bank',
    AppRoutes.researcherData => 'Research Data',
    AppRoutes.hcpDashboard => 'HCP Dashboard',
    AppRoutes.hcpClients => 'Clients',
    AppRoutes.hcpReports => 'Reports',
    AppRoutes.admin => 'Admin Dashboard',
    AppRoutes.adminUsers => 'User Management',
    AppRoutes.adminDatabase => 'Database Viewer',
    AppRoutes.adminMessages => 'Messages',
    AppRoutes.adminDeletionQueue => 'Deletion Queue',
    AppRoutes.adminLogs => 'Audit Log',
    AppRoutes.adminUiTest => 'UI Test',
    AppRoutes.adminNavHub => 'Admin Navigation',
    AppRoutes.adminSettings => 'System Settings',
    AppRoutes.adminHealthTracking => 'Health Tracking Settings',
    AppRoutes.help => 'Help',
    AppRoutes.messagesInbox => 'Messages',
    AppRoutes.messagesNew => 'New Message',
    AppRoutes.messagesFriends => 'Friend Requests',
    AppRoutes.termsOfService => 'Terms of Service',
    AppRoutes.privacyPolicy => 'Privacy Policy',
    _ when path.startsWith('/participant/surveys/') => 'Take Survey',
    _ when path.startsWith('/messages/') => 'Conversation',
    _ when path.startsWith('/surveys/') && path.endsWith('/edit') =>
      'Edit Survey',
    _ when path.startsWith('/surveys/') && path.endsWith('/status') =>
      'Survey Status',
    _ when path.startsWith('/templates/') && path.endsWith('/edit') =>
      'Edit Template',
    _ => 'HealthBank',
  };

  return suffix == 'HealthBank' ? suffix : 'HealthBank | $suffix';
}

/// Custom page builder that removes transition animations (instant page load)
CustomTransitionPage<void> _noTransitionPage(
  Widget child,
  GoRouterState state,
) {
  final pageChild = kIsWeb ? SelectionArea(child: child) : child;

  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: pageChild,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        child,
  );
}

/// Routes that do not require authentication.
const _publicRoutes = [
  AppRoutes.home,
  AppRoutes.login,
  AppRoutes.logout,
  AppRoutes.forgotPassword,
  AppRoutes.resetPassword,
  AppRoutes.requestAccount,
  AppRoutes.twoFactor,
  AppRoutes.termsOfService,
  AppRoutes.help,
  AppRoutes.privacyPolicy,
  AppRoutes.contact,
  AppRoutes.deactivatedNotice,
];

/// Bridges Riverpod auth state to GoRouter's [Listenable]-based refresh.
///
/// Updated from [_MyAppState.build] via [ref.listen]. When auth state changes,
/// [notifyListeners] causes GoRouter to re-evaluate its [redirect] callback.
class AuthChangeNotifier extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _sessionReady = false;
  String? _role;
  bool _mustChangePassword = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get sessionReady => _sessionReady;
  String? get role => _role;
  bool get mustChangePassword => _mustChangePassword;

  void update({
    required bool isAuthenticated,
    required bool sessionReady,
    String? role,
    bool mustChangePassword = false,
  }) {
    if (_isAuthenticated != isAuthenticated ||
        _sessionReady != sessionReady ||
        _role != role ||
        _mustChangePassword != mustChangePassword) {
      _isAuthenticated = isAuthenticated;
      _sessionReady = sessionReady;
      _role = role;
      _mustChangePassword = mustChangePassword;
      notifyListeners();
    }
  }
}

/// Global instance used by [appRouter] and updated from [main.dart].
final authChangeNotifier = AuthChangeNotifier();

/// Route prefixes each role is allowed to access.
/// Admin is omitted — admins can access ALL routes.
const _roleAllowedPrefixes = <String, List<String>>{
  'participant': ['/participant', '/messages'],
  'researcher': [
    '/researcher',
    '/surveys',
    '/templates',
    '/questions',
    '/messages',
  ],
  'hcp': ['/hcp', '/messages'],
};

/// App router configuration
final GoRouter appRouter = GoRouter(
  //initialLocation: AppRoutes.home,
  refreshListenable: authChangeNotifier,
  redirect: (context, state) {
    // During session initialization we don't yet know whether the user
    // has a stored session, so allow all navigation (no redirects).
    if (!authChangeNotifier.sessionReady) return null;

    final path = state.uri.path;
    final legacySurveyId = int.tryParse(
      state.uri.queryParameters['surveyId'] ?? '',
    );

    if (path == AppRoutes.participantSurveys && legacySurveyId != null) {
      return AppRoutes.participantSurveyPath(legacySurveyId);
    }

    final isAuthenticated = authChangeNotifier.isAuthenticated;
    final role = authChangeNotifier.role;

    // Authenticated users on /login or / must go to their role dashboard.
    if (isAuthenticated &&
        (path == AppRoutes.login || path == AppRoutes.home)) {
      return getDashboardRouteForRole(role) ?? AppRoutes.login;
    }

    // Public routes are always accessible to unauthenticated users.
    if (_publicRoutes.contains(path)) return null;

    // All other routes require authentication.
    if (!isAuthenticated) return AppRoutes.login;

    // Safety: authenticated but role is unknown — force re-login.
    if (role == null) return AppRoutes.login;

    // Force password change before anything else.
    if (authChangeNotifier.mustChangePassword) {
      return path == AppRoutes.changePassword ? null : AppRoutes.changePassword;
    }

    // Onboarding/shared routes accessible by any authenticated role.
    if (path == AppRoutes.changePassword) return null;
    if (path == AppRoutes.completeProfile) return null;
    if (path == AppRoutes.consent) return null;
    if (path == AppRoutes.about) return null;
    if (path == AppRoutes.help) return null;
    if (path == AppRoutes.termsOfService) return null;
    if (path == AppRoutes.privacyPolicy) return null;
    if (path == AppRoutes.contact) return null;
    if (path == AppRoutes.settings) return null;
    if (path == AppRoutes.profile) return null;
    if (path.startsWith(AppRoutes.messagesInbox)) return null;

    // Role-based route guard — admins can access everything.
    if (role != 'admin') {
      final allowed = _roleAllowedPrefixes[role];
      if (allowed == null) {
        // Role exists but has no defined prefixes — send to login (safety net).
        return AppRoutes.login;
      }
      final permitted = allowed.any((prefix) => path.startsWith(prefix));
      if (!permitted) {
        return getDashboardRouteForRole(role) ?? AppRoutes.login;
      }
    }

    return null; // Authenticated + correct role — allow navigation.
  },
  routes: [
    // Home
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (context, state) =>
          _noTransitionPage(const HomePage(), state),
    ),

    // Legal (Terms of Service) route
    GoRoute(
      path: AppRoutes.termsOfService,
      pageBuilder: (context, state) =>
          _noTransitionPage(const TermsOfServicePage(), state),
    ),
    // Auth routes
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (context, state) =>
          _noTransitionPage(const LoginPage(), state),
    ),
    GoRoute(
      path: AppRoutes.logout,
      pageBuilder: (context, state) =>
          _noTransitionPage(const LogoutPage(), state),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      pageBuilder: (context, state) =>
          _noTransitionPage(const ForgotPasswordPage(), state),
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      pageBuilder: (context, state) {
        final token = state.uri.queryParameters['token'];
        return _noTransitionPage(ResetPasswordPage(token: token), state);
      },
    ),
    GoRoute(
      path: AppRoutes.twoFactor,
      pageBuilder: (context, state) {
        final returnTo = state.uri.queryParameters['returnTo'];
        return _noTransitionPage(TwoFactorPage(returnTo: returnTo), state);
      },
    ),
    GoRoute(
      path: AppRoutes.requestAccount,
      pageBuilder: (context, state) =>
          _noTransitionPage(const RequestAccountPage(), state),
    ),
    GoRoute(
      path: AppRoutes.changePassword,
      pageBuilder: (context, state) =>
          _noTransitionPage(const ChangePasswordPage(), state),
    ),
    GoRoute(
      path: AppRoutes.completeProfile,
      pageBuilder: (context, state) =>
          _noTransitionPage(const ProfileCompletionPage(), state),
    ),
    GoRoute(
      path: AppRoutes.consent,
      pageBuilder: (context, state) =>
          _noTransitionPage(const ConsentPage(), state),
    ),
    GoRoute(
      path: AppRoutes.about,
      pageBuilder: (context, state) =>
          _noTransitionPage(const AboutPage(), state),
    ),

    // Participant routes
    GoRoute(
      path: AppRoutes.participantDashboard,
      pageBuilder: (context, state) =>
          _noTransitionPage(const ParticipantDashboardPage(), state),
    ),
    GoRoute(
      path: AppRoutes.participantSurveys,
      pageBuilder: (context, state) =>
          _noTransitionPage(const ParticipantSurveysPage(), state),
    ),
    GoRoute(
      path: AppRoutes.participantSurvey,
      pageBuilder: (context, state) {
        final surveyId = int.parse(state.pathParameters['surveyId']!);
        return _noTransitionPage(
          ParticipantSurveyTakingPage(surveyId: surveyId),
          state,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.participantResults,
      pageBuilder: (context, state) {
        final surveyId = int.tryParse(
          state.uri.queryParameters['surveyId'] ?? '',
        );
        return _noTransitionPage(
          ParticipantResultsPage(highlightedSurveyId: surveyId),
          state,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.participantTasks,
      pageBuilder: (context, state) =>
          _noTransitionPage(const ParticipantTasksPage(), state),
    ),
    GoRoute(
      path: AppRoutes.participantHealthTracking,
      pageBuilder: (context, state) =>
          _noTransitionPage(const ParticipantHealthTrackingPage(), state),
    ),

    // Messaging routes — accessible by all authenticated roles
    GoRoute(
      path: AppRoutes.messagesInbox,
      pageBuilder: (context, state) =>
          _noTransitionPage(const MessagingInboxPage(), state),
    ),
    GoRoute(
      path: AppRoutes.messagesNew,
      pageBuilder: (context, state) =>
          _noTransitionPage(const NewConversationPage(), state),
    ),
    GoRoute(
      path: AppRoutes.messagesFriends,
      pageBuilder: (context, state) =>
          _noTransitionPage(const FriendRequestPage(), state),
    ),
    GoRoute(
      path: '/messages/:convId',
      pageBuilder: (context, state) {
        final convId = int.parse(state.pathParameters['convId']!);
        return _noTransitionPage(ConversationPage(convId: convId), state);
      },
    ),

    // Researcher routes
    GoRoute(
      path: AppRoutes.researcherDashboard,
      pageBuilder: (context, state) =>
          _noTransitionPage(const ResearcherDashboardPage(), state),
    ),

    // Surveys
    GoRoute(
      path: AppRoutes.surveys,
      pageBuilder: (context, state) =>
          _noTransitionPage(const SurveyListPage(), state),
    ),
    GoRoute(
      path: AppRoutes.surveyBuilder,
      pageBuilder: (context, state) {
        final templateId = int.tryParse(
          state.uri.queryParameters['templateId'] ?? '',
        );
        return _noTransitionPage(
          SurveyBuilderPage(templateId: templateId),
          state,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.surveyEdit,
      pageBuilder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return _noTransitionPage(SurveyBuilderPage(surveyId: id), state);
      },
    ),
    GoRoute(
      path: AppRoutes.surveyStatus,
      pageBuilder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return _noTransitionPage(SurveyStatusPage(surveyId: id), state);
      },
    ),

    // Templates
    GoRoute(
      path: AppRoutes.templates,
      pageBuilder: (context, state) =>
          _noTransitionPage(const TemplateListPage(), state),
    ),
    GoRoute(
      path: AppRoutes.templateBuilder,
      pageBuilder: (context, state) =>
          _noTransitionPage(const TemplateBuilderPage(), state),
    ),
    GoRoute(
      path: AppRoutes.templateEdit,
      pageBuilder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return _noTransitionPage(TemplateBuilderPage(templateId: id), state);
      },
    ),

    // Question Bank
    GoRoute(
      path: AppRoutes.questionBank,
      pageBuilder: (context, state) =>
          _noTransitionPage(const QuestionBankPage(), state),
    ),

    // Research Data
    GoRoute(
      path: AppRoutes.researcherData,
      pageBuilder: (context, state) =>
          _noTransitionPage(const ResearcherPullDataPage(), state),
    ),

    // Researcher Health Tracking Analytics
    GoRoute(
      path: AppRoutes.researcherHealthTracking,
      pageBuilder: (context, state) =>
          _noTransitionPage(const ResearcherHealthTrackingPage(), state),
    ),

    // HCP routes
    GoRoute(
      path: AppRoutes.hcpDashboard,
      pageBuilder: (context, state) =>
          _noTransitionPage(const HcpDashboardPage(), state),
    ),
    GoRoute(
      path: AppRoutes.hcpClients,
      pageBuilder: (context, state) =>
          _noTransitionPage(const HcpClientListPage(), state),
    ),
    GoRoute(
      path: AppRoutes.hcpReports,
      pageBuilder: (context, state) =>
          _noTransitionPage(const HcpReportsPage(), state),
    ),

    // Admin routes
    GoRoute(
      path: AppRoutes.admin,
      pageBuilder: (context, state) =>
          _noTransitionPage(const AdminDashboardPage(), state),
    ),
    GoRoute(
      path: AppRoutes.adminUsers,
      pageBuilder: (context, state) =>
          _noTransitionPage(const UserManagementPage(), state),
    ),
    GoRoute(
      path: AppRoutes.adminDatabase,
      pageBuilder: (context, state) =>
          _noTransitionPage(const DatabaseViewerPage(), state),
    ),
    GoRoute(
      path: AppRoutes.adminMessages,
      pageBuilder: (context, state) =>
          _noTransitionPage(const MessagesPage(), state),
    ),
    GoRoute(
      path: AppRoutes.adminDeletionQueue,
      pageBuilder: (context, state) =>
          _noTransitionPage(const DeletionQueuePage(), state),
    ),
    GoRoute(
      path: AppRoutes.adminLogs,
      pageBuilder: (context, state) =>
          _noTransitionPage(const AuditLogPage(), state),
    ),
    GoRoute(
      path: AppRoutes.adminUiTest,
      pageBuilder: (context, state) =>
          _noTransitionPage(const UiTestPage(), state),
    ),
    GoRoute(
      path: AppRoutes.adminNavHub,
      pageBuilder: (context, state) =>
          _noTransitionPage(const AdminNavHubPage(), state),
    ),
    GoRoute(
      path: AppRoutes.adminSettings,
      pageBuilder: (context, state) =>
          _noTransitionPage(const AdminSettingsPage(), state),
    ),
    GoRoute(
      path: AppRoutes.adminHealthTracking,
      pageBuilder: (context, state) =>
          _noTransitionPage(const AdminHealthTrackingSettingsPage(), state),
    ),
    GoRoute(
      path: AppRoutes.help,
      pageBuilder: (context, state) =>
          _noTransitionPage(const HelpPage(), state),
    ),
    GoRoute(
      path: AppRoutes.privacyPolicy,
      pageBuilder: (context, state) =>
          _noTransitionPage(const PrivacyPolicyPage(), state),
    ),
    GoRoute(
      path: AppRoutes.contact,
      pageBuilder: (context, state) =>
          _noTransitionPage(const ContactPage(), state),
    ),
    GoRoute(
      path: AppRoutes.settings,
      pageBuilder: (context, state) =>
          _noTransitionPage(const SettingsPage(), state),
    ),
    GoRoute(
      path: AppRoutes.deactivatedNotice,
      pageBuilder: (context, state) =>
          _noTransitionPage(const DeactivatedNoticePage(), state),
    ),
    GoRoute(
      path: AppRoutes.profile,
      pageBuilder: (context, state) =>
          _noTransitionPage(const ProfilePage(), state),
    ),
  ],
  errorPageBuilder: (context, state) {
    return _noTransitionPage(const NotFoundPage(), state);
  },
);
