// Created with the Assistance of Claude Code
// frontend/lib/src/core/l10n/app_strings.dart
/// Centralized strings for the HealthBank app.
///
/// All user-facing text should be defined here to enable easy translation.
/// Organized by feature/section for maintainability.
///
/// Usage:
/// ```dart
/// Text(AppStrings.common.submit)
/// Text(AppStrings.auth.loginTitle)
/// Text(AppStrings.participant.dashboard)
/// ```
library;

class AppStrings {
  AppStrings._();

  static const common = CommonStrings._();
  static const auth = AuthStrings._();
  static const navigation = NavigationStrings._();
  static const footer = FooterStrings._();
  static const participant = ParticipantStrings._();
  static const researcher = ResearcherStrings._();
  static const hcp = HcpStrings._();
  static const admin = AdminStrings._();
}

/// Common strings used across the app
class CommonStrings {
  const CommonStrings._();

  // Common actions
  String get submit => 'Submit';
  String get cancel => 'Cancel';
  String get save => 'Save';
  String get delete => 'Delete';
  String get edit => 'Edit';
  String get close => 'Close';
  String get back => 'Back';
  String get next => 'Next';
  String get done => 'Done';
  String get confirm => 'Confirm';
  String get retry => 'Retry';
  String get loading => 'Loading...';
  String get search => 'Search';
  String get filter => 'Filter';
  String get clear => 'Clear';
  String get viewAll => 'View All';
  String get seeMore => 'See More';
  String get refresh => 'Refresh';

  // Common labels
  String get email => 'Email';
  String get password => 'Password';
  String get name => 'Name';
  String get date => 'Date';
  String get time => 'Time';
  String get status => 'Status';
  String get description => 'Description';
  String get title => 'Title';
  String get type => 'Type';
  String get actions => 'Actions';

  // Status labels
  String get active => 'Active';
  String get inactive => 'Inactive';
  String get pending => 'Pending';
  String get completed => 'Completed';
  String get inProgress => 'In Progress';

  // Footer
  String get copyright => '© 2025 HealthBank. All rights reserved.';
  String get privacyPolicy => 'Privacy Policy';
  String get termsOfService => 'Terms of Service';
  String get contactUs => 'Contact Us';

  // Errors
  String get errorGeneric => 'Something went wrong. Please try again.';
  String get errorNetwork => 'Network error. Please check your connection.';
  String get errorNotFound => 'Not found.';
  String get errorUnauthorized => 'You are not authorized to perform this action.';

  // Validation
  String get required => 'This field is required';
  String get invalidEmail => 'Please enter a valid email address';
  String get invalidPassword => 'Password must be at least 8 characters';

  // Confirmations
  String get confirmDelete => 'Are you sure you want to delete this?';
  String get confirmCancel => 'Are you sure you want to cancel?';
  String get unsavedChanges => 'You have unsaved changes. Are you sure you want to leave?';
}

/// Authentication related strings
class AuthStrings {
  const AuthStrings._();

  // Login
  String get welcomeTo => 'Welcome to HealthBank.';
  String get pleaseLogIn => 'Please log in to continue.';
  String get loginTitle => 'Log In';
  String get loginSubtitle => 'Enter your credentials to access your account';
  String get loginButton => 'Log In';
  String get loginEmail => 'Email';
  String get loginPassword => 'Password';
  String get loginRememberMe => 'Remember me';
  String get loginForgotPassword => 'Forgot Password?';
  String get loginNoAccount => "Don't have an account?";
  String get loginSignUp => 'Sign Up';
  String get loginError => 'Invalid email or password';
  String get newHereRequestAccount => 'New Here? Request An Account';

  // Validation
  String get emailRequired => 'Email is required';
  String get emailInvalid => 'Please enter a valid email';
  String get passwordRequired => 'Password is required';

  // Logout
  String get loggingOut => 'Logging Out...';
  String get logoutTitle => 'Logout Successful';
  String get logoutMessage => 'You have been successfully logged out.\nPlease click the Return button to\nreturn to the Log In page.';
  String get logoutReturn => 'Return';
  String get logoutReturnToLogin => 'Return to Login';

  // Register
  String get registerTitle => 'Create Account';
  String get registerSubtitle => 'Enter your details to create an account';
  String get registerButton => 'Create Account';
  String get registerFirstName => 'First Name';
  String get registerLastName => 'Last Name';
  String get registerConfirmPassword => 'Confirm Password';
  String get registerHaveAccount => 'Already have an account?';
  String get registerLogin => 'Log In';
  String get registerPasswordMismatch => 'Passwords do not match';

  // Forgot password
  String get forgotPasswordTitle => 'Forgot Password';
  String get forgotPasswordSubtitle => 'Enter your email to receive a password reset link';
  String get forgotPasswordButton => 'Send Reset Link';
  String get forgotPasswordSuccess => 'Password reset link sent to your email';
  String get forgotPasswordBackToLogin => 'Back to Login';

  // Reset password
  String get resetPasswordTitle => 'Reset Password';
  String get resetPasswordSubtitle => 'Enter your new password';
  String get resetPasswordButton => 'Reset Password';
  String get resetPasswordNewPassword => 'New Password';
  String get resetPasswordConfirmPassword => 'Confirm New Password';
  String get resetPasswordSuccess => 'Password reset successful';
  String get resetPasswordSuccessTitle => 'Password Reset Successful';
  String get resetPasswordSuccessMessage => 'Your password has been successfully reset.';

  // Profile menu
  String get profile => 'Profile';
  String get settings => 'Settings';
  String get logout => 'Logout';
  String get notifications => 'Notifications';
}

/// Footer strings
class FooterStrings {
  const FooterStrings._();

  // Section titles
  String get helpAndServices => 'Help & Services';
  String get legal => 'Legal';

  // Help & Services links
  String get howToUse => 'How to Use HealthBank';

  // Legal links
  String get termsOfUse => 'Terms of Use';
  String get privacy => 'Privacy';
}

/// Navigation strings
class NavigationStrings {
  const NavigationStrings._();

  // Common navigation
  String get dashboard => 'Dashboard';
  String get home => 'Home';
  String get surveys => 'Surveys';
  String get results => 'Results';
  String get tasks => 'To-Do';
  String get messages => 'Messages';
  String get reports => 'Reports';

  // Participant navigation
  String get participantDashboard => 'Dashboard';
  String get participantTasks => 'To-Do';
  String get participantSurveys => 'Surveys';
  String get participantResults => 'Results';

  // Researcher navigation
  String get researcherDashboard => 'Dashboard';
  String get researcherParticipants => 'Participants';
  String get researcherSurveys => 'Surveys';
  String get researcherReports => 'Reports';

  // HCP navigation
  String get hcpDashboard => 'Dashboard';
  String get hcpClients => 'Clients';
  String get hcpSurveys => 'Surveys';
  String get hcpReports => 'Reports';

  // Admin navigation
  String get adminUserManagement => 'User Management';
  String get adminDatabase => 'Database';
  String get adminTickets => 'Tickets';
  String get adminMessages => 'Messages';
  String get adminAuditLog => 'Audit Log';
}

/// Participant-specific strings
class ParticipantStrings {
  const ParticipantStrings._();

  // Dashboard
  String welcomeMessage(String name) => 'Welcome, $name. How are you today?';
  String get dashboardDescription => 'Description of graphs/diagrams below...';

  // Notifications
  String newMessagesNotification(int count) =>
      'You have $count new message${count == 1 ? '' : 's'}.\nClick to here to view.';
  String get clickToViewMessages => 'Click to view';

  // Tasks
  String get yourTaskProgress => 'Your Task Progress:';
  String get taskProgress => 'Task Progress';
  String tasksCompleted(int completed, int total) =>
      '$completed out of $total tasks completed';
  String taskProgressLabel(int completed, int total) =>
      '$completed of $total tasks completed';
  String remainingTasksForToday(int count) =>
      'Remaining tasks for today: $count';
  String remainingTasks(int count) =>
      '$count Remaining Task${count == 1 ? '' : 's'}';
  String get doTask => 'Do Task';
  String get viewAllTasks => 'View All Tasks';
  String get dueToday => 'Due today';
  String repeatsEvery(int days) => 'Repeats every $days days';
  String get myTasks => 'My Tasks';
  String get placeholder => '(Placeholder)';

  // Surveys
  String get mySurveys => 'My Surveys';
  String get availableSurveys => 'Available Surveys';
  String get completedSurveys => 'Completed Surveys';
  String get startSurvey => 'Start Survey';
  String get continueSurvey => 'Continue Survey';
  String get viewResults => 'View Results';

  // Results
  String get myResults => 'My Results';
  String get downloadResults => 'Download Results';
  String get noResultsYet => 'No results available yet';

  // Graph placeholders
  String get graphTitle1 => 'Graph Title 1';
  String get graphTitle2 => 'Graph Title 2';
  String get graphPlaceholder => 'Graph placeholder';
}

/// Researcher-specific strings
class ResearcherStrings {
  const ResearcherStrings._();

  // Dashboard
  String get welcomeBack => 'Welcome Back';
  String get recentActivity => 'Recent Activity';
  String get quickActions => 'Quick Actions';

  // Participants
  String get participants => 'Participants';
  String get addParticipant => 'Add Participant';
  String get participantDetails => 'Participant Details';
  String get participantList => 'Participant List';
  String get enrolledParticipants => 'Enrolled Participants';
  String get pendingInvitations => 'Pending Invitations';

  // Surveys
  String get createSurvey => 'Create Survey';
  String get editSurvey => 'Edit Survey';
  String get surveyDetails => 'Survey Details';
  String get surveyList => 'Survey List';
  String get activeSurveys => 'Active Surveys';
  String get draftSurveys => 'Draft Surveys';
  String get closedSurveys => 'Closed Surveys';
  String get assignSurvey => 'Assign Survey';
  String get surveyResponses => 'Survey Responses';

  // Reports
  String get generateReport => 'Generate Report';
  String get exportData => 'Export Data';
  String get dataAnalytics => 'Data Analytics';
}

/// HCP (Healthcare Provider) specific strings
class HcpStrings {
  const HcpStrings._();

  // Dashboard
  String get welcomeBack => 'Welcome Back';
  String get todaySchedule => "Today's Schedule";
  String get upcomingAppointments => 'Upcoming Appointments';

  // Clients
  String get clients => 'Clients';
  String get addClient => 'Add Client';
  String get clientDetails => 'Client Details';
  String get clientList => 'Client List';
  String get activeClients => 'Active Clients';

  // Surveys
  String get assignSurvey => 'Assign Survey';
  String get clientSurveys => 'Client Surveys';
  String get surveyHistory => 'Survey History';

  // Reports
  String get clientReports => 'Client Reports';
  String get generateReport => 'Generate Report';
  String get healthSummary => 'Health Summary';
}

/// Admin-specific strings
class AdminStrings {
  const AdminStrings._();

  // Sidebar
  String get loggedInAsLabel => 'Logged in as:';
  String loggedInAs(String name) => 'Logged in as: $name';

  // User Management
  String get userManagement => 'User Management';
  String get addUser => 'Add User';
  String get editUser => 'Edit User';
  String get deleteUser => 'Delete User';
  String get userList => 'User List';
  String get userDetails => 'User Details';
  String get userRole => 'User Role';
  String get accountStatus => 'Account Status';
  String get resetPassword => 'Reset Password';
  String get enableAccount => 'Enable Account';
  String get disableAccount => 'Disable Account';

  // Database
  String get database => 'Database';
  String get databaseStatus => 'Database Status';
  String get backupDatabase => 'Backup Database';
  String get restoreDatabase => 'Restore Database';

  // Tickets
  String get tickets => 'Tickets';
  String get openTickets => 'Open Tickets';
  String get closedTickets => 'Closed Tickets';
  String get ticketDetails => 'Ticket Details';
  String get assignTicket => 'Assign Ticket';
  String get closeTicket => 'Close Ticket';

  // Messages
  String get messages => 'Messages';
  String get inbox => 'Inbox';
  String get sent => 'Sent';
  String get compose => 'Compose';

  // Audit Log
  String get auditLog => 'Audit Log';
  String get viewLogs => 'View Logs';
  String get exportLogs => 'Export Logs';
  String get filterByDate => 'Filter by Date';
  String get filterByUser => 'Filter by User';
  String get filterByAction => 'Filter by Action';

  // Language
  String get language => 'Language';
  String get english => 'EN';
}
