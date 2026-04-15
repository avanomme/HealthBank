// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonActions => 'Actions';

  @override
  String get commonBack => 'Back';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonClear => 'Clear';

  @override
  String get commonClose => 'Close';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonContactUs => 'Contact Us';

  @override
  String get commonCopyright => '© 2025 HealthBank. All rights reserved.';

  @override
  String get commonDate => 'Date';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonDescription => 'Description';

  @override
  String get commonDone => 'Done';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonEmail => 'Email';

  @override
  String get commonEndDate => 'End date';

  @override
  String commonErrorWithDetail(String detail) {
    return 'Error: $detail';
  }

  @override
  String get commonFilter => 'Filter';

  @override
  String get commonHidePassword => 'Hide password';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonName => 'Name';

  @override
  String get commonNext => 'Next';

  @override
  String get commonNo => 'No';

  @override
  String get commonOff => 'Off';

  @override
  String get commonOn => 'On';

  @override
  String get commonPassword => 'Password';

  @override
  String get commonPrivacyPolicy => 'Privacy Policy';

  @override
  String get commonRefresh => 'Refresh';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSave => 'Save';

  @override
  String get commonSaving => 'Saving…';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonSeeMore => 'See More';

  @override
  String get commonShowPassword => 'Show password';

  @override
  String get commonStartDate => 'Start date';

  @override
  String get commonStatus => 'Status';

  @override
  String get commonSubmit => 'Submit';

  @override
  String get commonTermsOfService => 'Terms of Service';

  @override
  String get commonTime => 'Time';

  @override
  String get commonTitle => 'Title';

  @override
  String get commonType => 'Type';

  @override
  String get commonViewAll => 'View All';

  @override
  String get commonYes => 'Yes';

  @override
  String get statusActive => 'Active';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusInactive => 'Inactive';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusPending => 'Pending';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork => 'Network error. Please check your connection.';

  @override
  String get errorNotFound => 'Not found.';

  @override
  String get errorUnauthorized =>
      'You are not authorized to perform this action.';

  @override
  String get formConfirmPasswordLabel => 'Confirm Password';

  @override
  String get formConfirmPasswordMismatch => 'Passwords must match exactly.';

  @override
  String get formConfirmPasswordMustMatch =>
      'Confirmed password must exactly match Create Password.';

  @override
  String get formCreatePasswordLabel => 'Create Password';

  @override
  String get formDateValidationError =>
      'Enter a valid date in YYYY-MM-DD format (e.g. 2024-01-15).';

  @override
  String get formEmailValidationError =>
      'Enter a valid email address (e.g. name@example.com).';

  @override
  String get formPasswordCheckTitle => 'Password Check';

  @override
  String get formPasswordRuleAscii =>
      'Use ASCII letters, digits, and common symbols only.';

  @override
  String get formPasswordRuleLowercase => 'At least one lowercase letter.';

  @override
  String get formPasswordRuleMax32 => 'Maximum 32 characters.';

  @override
  String get formPasswordRuleMin8 => 'Minimum 8 characters.';

  @override
  String get formPasswordRuleNoEmail =>
      'Must not contain email-like fragments (for example, local@domain.com).';

  @override
  String get formPasswordRuleNumberOrSymbol => 'At least one number or symbol.';

  @override
  String get formPasswordRulesError =>
      'Password does not meet the required rules.';

  @override
  String get formPasswordRulesHelper =>
      'Your password must meet all of the following requirements:';

  @override
  String get formPasswordRuleUppercase => 'At least one uppercase letter.';

  @override
  String get formPhoneHint => 'Phone number';

  @override
  String get formPhoneValidationError =>
      'Enter a valid phone number including country code.';

  @override
  String get formSecuredPasswordVerificationFailed =>
      'Password verification failed.';

  @override
  String get formTimeValidationError =>
      'Enter a valid time in HH:MM format (e.g. 09:30).';

  @override
  String get validationInvalidEmail =>
      'Enter a valid email address (e.g. name@example.com).';

  @override
  String get validationInvalidPassword =>
      'Password must be at least 8 characters.';

  @override
  String get validationRequired =>
      'This field is required. Please enter a value.';

  @override
  String get confirmCancel => 'Are you sure you want to cancel?';

  @override
  String get confirmDelete => 'Are you sure you want to delete this?';

  @override
  String get confirmUnsavedChanges =>
      'You have unsaved changes. Are you sure you want to leave?';

  @override
  String get aboutPageBody =>
      'HealthBank is a secure personal health data platform developed at the University of Prince Edward Island (UPEI). It connects participants, healthcare professionals, and researchers in a privacy-compliant environment for approved health research.\n\nParticipants can complete health surveys and contribute data to research projects they have consented to. Healthcare professionals can monitor the participation and health data of patients under their care. Researchers access only aggregated, de-identified results — individual participant data is never exposed in research outputs.\n\nAll data collection is governed by informed consent and conducted in accordance with Canadian federal and applicable provincial privacy legislation, including PIPEDA and PHIPA. HealthBank is an academic initiative committed to advancing health research for the benefit of all Canadians.';

  @override
  String get aboutPageTitle => 'About HealthBank';

  @override
  String get contactSupportEmailLabel => 'Support Email';

  @override
  String get contactSupportHoursLabel => 'Hours';

  @override
  String get contactSupportHoursValue =>
      'Monday to Friday, 9:00 AM - 5:00 PM (ET)';

  @override
  String get contactSupportIntro =>
      'Reach our support team for account help, technical issues, or general questions about HealthBank.';

  @override
  String get contactSupportNote =>
      'Include your account email and a short summary of the issue so we can respond faster.';

  @override
  String get footerHelpAndServices => 'Help & Services';

  @override
  String get footerHowToUse => 'How to Use HealthBank';

  @override
  String get footerLegal => 'Legal';

  @override
  String get footerPrivacy => 'Privacy';

  @override
  String get footerTermsOfUse => 'Terms of Use';

  @override
  String get helpFaq1Body =>
      'Accounts are created by a HealthBank administrator or healthcare professional. If you believe you should have access, contact your healthcare provider or the research coordinator overseeing your study. You will receive an email with instructions to set up your password and complete your profile.';

  @override
  String get helpFaq1Title => 'How do I create an account?';

  @override
  String get helpFaq2Body =>
      'After signing in, navigate to the Surveys section from your dashboard. Select an available survey and follow the on-screen instructions. Your responses are saved automatically as you progress, and you can return to an incomplete survey at any time. Contact your study coordinator if you have questions about a specific survey.';

  @override
  String get helpFaq2Title => 'How do I complete a health survey?';

  @override
  String get helpFaq3Body =>
      'Your personal health data is strictly confidential. Only your assigned healthcare professional and authorized administrators can view your individual responses. Researchers access only aggregated, de-identified data — your name and personal details are never visible in research results. See our Privacy Policy for full details.';

  @override
  String get helpFaq3Title => 'Who can see my data?';

  @override
  String get homePagePlaceHolderText =>
      'HealthBank is a secure, privacy-first platform for personal health data collection and research. Participants complete surveys and share health data to support meaningful research. Healthcare professionals monitor patient participation. Researchers access aggregated, de-identified results — never individual records.\n\nAll data is collected under informed consent and protected in accordance with Canadian privacy law (PIPEDA). Sign in to access your dashboard, or request an account to join the HealthBank community.';

  @override
  String get a11ySkipToContent => 'Skip to main content';

  @override
  String get accessibilitySkipToMain => 'Skip to main content';

  @override
  String get changePasswordButton => 'Change Password';

  @override
  String get changePasswordConfirm => 'Confirm New Password';

  @override
  String get changePasswordCurrent => 'Current Password';

  @override
  String get changePasswordMinLength =>
      'Password must be at least 8 characters';

  @override
  String get changePasswordMismatch => 'Passwords do not match';

  @override
  String get changePasswordNew => 'New Password';

  @override
  String get changePasswordRequired => 'This field is required';

  @override
  String get changePasswordSameAsOld =>
      'New password must be different from current password';

  @override
  String get changePasswordSubtitle =>
      'You must change your password before continuing';

  @override
  String get changePasswordSuccess => 'Password changed successfully';

  @override
  String get changePasswordTitle => 'Change Password';

  @override
  String get chartNoData => 'No data available';

  @override
  String get chartTableCount => 'Count';

  @override
  String chartTableLabel(String title) {
    return '$title — data table';
  }

  @override
  String get chartTableOption => 'Option';

  @override
  String get chartTablePercent => 'Percent';

  @override
  String get cookieAccept => 'Accept';

  @override
  String get cookieBody =>
      'This website uses essential cookies to maintain secure login sessions. By continuing to use the site you agree to the use of these cookies.';

  @override
  String get cookieTitle => 'Cookies';

  @override
  String get dashboardGraphClearSelection => 'Clear';

  @override
  String get dashboardGraphMyResults => 'My Results';

  @override
  String get dashboardGraphNoCompletedSurveys =>
      'No completed surveys yet. Complete a survey to see your data here.';

  @override
  String get dashboardGraphNoSelection =>
      'Select a survey and question to view your data';

  @override
  String get dashboardGraphQuestionLabel => 'Question';

  @override
  String get dashboardGraphSelectQuestion => 'Select a Question';

  @override
  String get dashboardGraphSelectSurvey => 'Select a Survey';

  @override
  String get dashboardGraphSettingsTitle => 'Chart Settings';

  @override
  String get dashboardGraphSurveyLabel => 'Survey';

  @override
  String get deactivatedNoticeMessage =>
      'Your account has been deactivated. If you believe this is a mistake, please contact support.';

  @override
  String get deactivatedNoticeReturnToLogin => 'Return to Login';

  @override
  String get deactivatedNoticeTitle => 'Account Deactivated';

  @override
  String get headerMenu => 'Menu';

  @override
  String get headerUnreadNotifications => 'Unread notifications';

  @override
  String maintenanceBannerMessage(String time) {
    return 'The System is Currently Down for Maintenance which is expected to be completed by $time. We apologize for any inconvenience.';
  }

  @override
  String get maintenanceBannerMessageNoTime =>
      'The System is Currently Down for Maintenance. We apologize for any inconvenience.';

  @override
  String get maintenanceBannerTitle => 'System Under Maintenance';

  @override
  String get notFound404Heading => '404 - Page Not Found';

  @override
  String get notFoundDescription =>
      'The page you are looking for does not exist.';

  @override
  String get notFoundPageTitle => 'Page Not Found';

  @override
  String paginationPageOf(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get reorderMoveDown => 'Move down';

  @override
  String get reorderMoveUp => 'Move up';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleHcp => 'Healthcare Professional';

  @override
  String get roleParticipant => 'Participant';

  @override
  String get roleResearcher => 'Researcher';

  @override
  String get semanticLogoNavigate => 'HealthBank logo, navigate to dashboard';

  @override
  String get sessionExpiryExtend => 'Stay Logged In';

  @override
  String get sessionExpiryExtended => 'Session extended.';

  @override
  String get sessionExpiryLogout => 'Log Out';

  @override
  String get sessionExpiryMessage =>
      'Your session will expire in 5 minutes. Would you like to stay logged in?';

  @override
  String get sessionExpiryTitle => 'Session Expiring Soon';

  @override
  String get themePresetClassicCream => 'Classic Cream';

  @override
  String get themePresetClassicCreamDesc => 'Warm ivory chrome';

  @override
  String get themePresetClassicGrey => 'Classic Grey';

  @override
  String get themePresetClassicGreyDesc => 'Cool grey chrome';

  @override
  String get themePresetDark => 'Dark';

  @override
  String get themePresetDarkDesc => 'Modern dark mode';

  @override
  String get themePresetModern => 'Modern';

  @override
  String get themePresetModernDesc => 'Clean flat light';

  @override
  String get tooltipBarChart => 'Bar chart';

  @override
  String get tooltipClearFilter => 'Clear filter';

  @override
  String get tooltipClearSearch => 'Clear search';

  @override
  String get tooltipClose => 'Close';

  @override
  String get tooltipCloseModal => 'Close';

  @override
  String get tooltipCollapseSidebar => 'Collapse sidebar';

  @override
  String get tooltipDismissNotification => 'Dismiss notification';

  @override
  String get tooltipExpandSidebar => 'Expand sidebar';

  @override
  String get tooltipGoBack => 'Go back';

  @override
  String get tooltipLineChart => 'Line chart';

  @override
  String get tooltipNextPage => 'Next page';

  @override
  String get tooltipPickDate => 'Pick date';

  @override
  String get tooltipPickTime => 'Pick time';

  @override
  String get tooltipPieChart => 'Pie chart';

  @override
  String get tooltipPreviousPage => 'Previous page';

  @override
  String get tooltipRemoveOption => 'Remove option';

  @override
  String get tooltipTableView => 'Table view';

  @override
  String get tooltipTogglePasswordVisibility => 'Toggle password visibility';

  @override
  String get auth2faCodeHint => '123456';

  @override
  String get auth2faConfirm2fa => 'Confirm 2FA';

  @override
  String get auth2faEnrollAndRetrieveProvisioningUri =>
      'Enroll your account and retrieve the provisioning URI (used for QR code).';

  @override
  String get auth2faEnrollApi => 'Enroll';

  @override
  String get auth2faEnterCodeFromAuthenticator =>
      'Enter the 6-digit code from your authenticator app';

  @override
  String get auth2faEnterCodeToFinishSignin =>
      'Enter the 6-digit code to finish signing in.';

  @override
  String get auth2faErrorEnrollFailed =>
      'Failed to enroll 2FA. Please try again.';

  @override
  String get auth2faErrorVerifyFailed =>
      'Failed to verify 2FA. Please try again.';

  @override
  String get auth2faPleaseLoginFirstToEnroll =>
      'Please log in first to enroll 2FA.';

  @override
  String get auth2faTitle => 'Two-Factor Authentication (2FA)';

  @override
  String get auth2faVerify => 'Verify';

  @override
  String get authEmailInvalid => 'Please enter a valid email';

  @override
  String get authEmailRequired => 'Enter your email address.';

  @override
  String get authForgotPasswordBackToLogin => 'Back to Login';

  @override
  String get authForgotPasswordButton => 'Send Reset Link';

  @override
  String get authForgotPasswordSubtitle =>
      'Enter your email to receive a password reset link';

  @override
  String get authForgotPasswordSuccess =>
      'Password reset link sent to your email';

  @override
  String get authForgotPasswordTitle => 'Forgot Password';

  @override
  String get authLoggingIn => 'Logging In...';

  @override
  String get authLoggingOut => 'Logging Out...';

  @override
  String get authLoginButton => 'Log In';

  @override
  String get authLoginEmail => 'Email';

  @override
  String get authLoginError => 'Invalid email or password';

  @override
  String get authLoginForgotPassword => 'Forgot Password?';

  @override
  String get authLoginNoAccount => 'Don\'t have an account?';

  @override
  String get authLoginPassword => 'Password';

  @override
  String get authLoginRememberMe => 'Remember me';

  @override
  String get authLoginSignUp => 'Sign Up';

  @override
  String get authLoginSubtitle =>
      'Enter your credentials to access your account';

  @override
  String get authLoginTitle => 'Log In';

  @override
  String get authLogout => 'Logout';

  @override
  String get authLogoutMessage =>
      'You have been successfully logged out.\nPlease click the Return button to\nreturn to the Log In page.';

  @override
  String get authLogoutReturn => 'Return';

  @override
  String get authLogoutReturnToLogin => 'Return to Login';

  @override
  String get authLogoutTitle => 'Logout Successful';

  @override
  String get authMaintenanceModeAdminNote =>
      'Administrator accounts may still log in.';

  @override
  String get authMaintenanceModeDefaultMessage =>
      'The system is temporarily unavailable for scheduled maintenance.';

  @override
  String get authMaintenanceModeLoginError =>
      'System is under maintenance. Only administrators can log in at this time.';

  @override
  String get authMaintenanceModeTitle => 'System Maintenance';

  @override
  String get authNewHereRequestAccount => 'New Here? Request An Account';

  @override
  String get authNotifications => 'Notifications';

  @override
  String get authPasswordRequired => 'Enter your password.';

  @override
  String get authPleaseLogIn => 'Please log in to continue.';

  @override
  String get authProfile => 'Profile';

  @override
  String get authRegisterButton => 'Create Account';

  @override
  String get authRegisterConfirmPassword => 'Confirm Password';

  @override
  String get authRegisterFirstName => 'First Name';

  @override
  String get authRegisterHaveAccount => 'Already have an account?';

  @override
  String get authRegisterLastName => 'Last Name';

  @override
  String get authRegisterLogin => 'Log In';

  @override
  String get authRegisterPasswordMismatch => 'Passwords do not match';

  @override
  String get authRegisterSubtitle => 'Enter your details to create an account';

  @override
  String get authRegisterTitle => 'Create Account';

  @override
  String get authResetPasswordButton => 'Reset Password';

  @override
  String get authResetPasswordConfirmPassword => 'Confirm New Password';

  @override
  String get authResetPasswordConfirmRequired => 'Please confirm your password';

  @override
  String get authResetPasswordInvalidLinkMessage =>
      'This password reset link is invalid or has expired. Please request a new one.';

  @override
  String get authResetPasswordInvalidLinkTitle => 'Invalid Reset Link';

  @override
  String get authResetPasswordNewPassword => 'New Password';

  @override
  String get authResetPasswordSubtitle => 'Enter your new password';

  @override
  String get authResetPasswordSuccess => 'Password reset successful';

  @override
  String get authResetPasswordSuccessMessage =>
      'Your password has been successfully reset.';

  @override
  String get authResetPasswordSuccessTitle => 'Password Reset Successful';

  @override
  String get authResetPasswordTitle => 'Reset Password';

  @override
  String get authSettings => 'Settings';

  @override
  String get authWelcomeTo => 'Welcome to HealthBank.';

  @override
  String get accountEditError404 =>
      'Account not found. It may have been deleted.';

  @override
  String get accountEditError409 =>
      'This email is already in use by another account.';

  @override
  String get accountEditError422 => 'Invalid data. Please check all fields.';

  @override
  String get accountEditErrorNetwork =>
      'Network error. Please check your connection.';

  @override
  String get accountEditErrorServer =>
      'A server error occurred. Please try again.';

  @override
  String get accountEditSaving => 'Saving...';

  @override
  String get accountEditSuccess => 'User updated successfully.';

  @override
  String get accountEditValidationEmail =>
      'Please enter a valid email address.';

  @override
  String get accountEditValidationName => 'Name cannot be empty.';

  @override
  String get requestAccountBackToLogin => 'Back to Login';

  @override
  String get requestAccountBirthdate => 'Date of Birth';

  @override
  String get requestAccountDuplicateEmail =>
      'An account with this email already exists';

  @override
  String get requestAccountDuplicatePending =>
      'A request for this email is already pending';

  @override
  String get requestAccountEmail => 'Email';

  @override
  String get requestAccountEmailRequired => 'Email is required';

  @override
  String get requestAccountError =>
      'Unable to submit request. Please try again.';

  @override
  String get requestAccountFirstName => 'First Name';

  @override
  String get requestAccountFirstNameRequired => 'First name is required';

  @override
  String get requestAccountGender => 'Gender';

  @override
  String get requestAccountGenderFemale => 'Female';

  @override
  String get requestAccountGenderMale => 'Male';

  @override
  String get requestAccountGenderNonBinary => 'Non-Binary';

  @override
  String get requestAccountGenderOther => 'Other';

  @override
  String get requestAccountGenderOtherSpecify => 'Please specify';

  @override
  String get requestAccountGenderPreferNotToSay => 'Prefer Not to Say';

  @override
  String get requestAccountLastName => 'Last Name';

  @override
  String get requestAccountLastNameRequired => 'Last name is required';

  @override
  String get requestAccountRole => 'Select Role';

  @override
  String get requestAccountRoleHcp => 'Healthcare Provider';

  @override
  String get requestAccountRoleParticipant => 'Participant';

  @override
  String get requestAccountRoleRequired => 'Please select a role';

  @override
  String get requestAccountRoleResearcher => 'Researcher';

  @override
  String get requestAccountSubmit => 'Submit Request';

  @override
  String get requestAccountSubtitle =>
      'Fill out this form to request an account';

  @override
  String get requestAccountSuccess =>
      'Your request has been submitted. You will receive an email when your account is approved.';

  @override
  String get requestAccountTitle => 'Request Account';

  @override
  String get requestAccountTooManyRequests =>
      'Too many requests. Please try again later.';

  @override
  String get resetPasswordCopied => 'Password copied to clipboard';

  @override
  String get resetPasswordCopy => 'Copy to clipboard';

  @override
  String get resetPasswordEmailAddress => 'Email Address';

  @override
  String get resetPasswordEmailHint => 'Enter alternate email';

  @override
  String get resetPasswordEmailInvalid => 'Enter a valid email address';

  @override
  String get resetPasswordEmailRequired => 'Email is required';

  @override
  String get resetPasswordEmailSubtitle =>
      'Email the temporary password to the user';

  @override
  String get resetPasswordGenerate => 'Generate random password';

  @override
  String get resetPasswordHint => 'Enter password or generate';

  @override
  String get resetPasswordMinLength => 'Password must be at least 8 characters';

  @override
  String get resetPasswordModalTitle => 'Reset Password';

  @override
  String get resetPasswordNewPassword => 'New Password';

  @override
  String get resetPasswordRequired => 'Password is required';

  @override
  String get resetPasswordResetting => 'Resetting...';

  @override
  String get resetPasswordSendEmail => 'Send email notification';

  @override
  String get resetPasswordSuccessEmail =>
      'Password reset and email sent successfully';

  @override
  String get resetPasswordSuccessNoEmail => 'Password reset successfully';

  @override
  String get resetPasswordUseAlternate => 'Use alternate email';

  @override
  String get profileBirthdate => 'Birthdate';

  @override
  String get profileCompletionBirthdate => 'Date of Birth';

  @override
  String get profileCompletionBirthdateRequired => 'Date of birth is required';

  @override
  String get profileCompletionError =>
      'Failed to save profile. Please try again.';

  @override
  String get profileCompletionGender => 'Gender';

  @override
  String get profileCompletionGenderFemale => 'Female';

  @override
  String get profileCompletionGenderMale => 'Male';

  @override
  String get profileCompletionGenderNonBinary => 'Non-Binary';

  @override
  String get profileCompletionGenderOther => 'Other';

  @override
  String get profileCompletionGenderPreferNotToSay => 'Prefer Not to Say';

  @override
  String get profileCompletionGenderRequired => 'Gender selection is required';

  @override
  String get profileCompletionSubmit => 'Continue';

  @override
  String get profileCompletionSubtitle =>
      'Please provide the following information to complete your account setup.';

  @override
  String get profileCompletionTitle => 'Complete Your Profile';

  @override
  String get profileEditInformation => 'Edit';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileEmailInvalid => 'Enter a valid email';

  @override
  String get profileEmailRequired => 'Email is required';

  @override
  String get profileFirstName => 'First name';

  @override
  String get profileFirstNameRequired => 'First name is required';

  @override
  String get profileGender => 'Gender';

  @override
  String get profileLastName => 'Last name';

  @override
  String get profileLastNameRequired => 'Last name is required';

  @override
  String get profileLoadError => 'Failed to load profile.';

  @override
  String profileRole(String role) {
    return 'Role: $role';
  }

  @override
  String get profileSaveChanges => 'Save changes';

  @override
  String get profileSubtitle => 'Manage your personal account information';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileUpdateError => 'Failed to update profile.';

  @override
  String get profileUpdateSuccess => 'Profile updated successfully.';

  @override
  String get navAbout => 'About';

  @override
  String get navAccountRequests => 'Account Requests';

  @override
  String get navAuditLog => 'Audit Log';

  @override
  String get navBackup => 'Database Backups';

  @override
  String get navChangePassword => 'Change Password';

  @override
  String get navClients => 'Clients';

  @override
  String get navCompleteProfile => 'Complete Profile';

  @override
  String get navConsent => 'Consent';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navDashboardV2 => 'Dashboard v2';

  @override
  String get navData => 'Data';

  @override
  String get navDatabase => 'Database';

  @override
  String get navDatabaseViewer => 'Database Viewer';

  @override
  String get navDeletionQueue => 'Deletion Queue';

  @override
  String get navErrorPage => 'Error Page';

  @override
  String get navForgotPassword => 'Forgot Password';

  @override
  String get navFriends => 'Contacts';

  @override
  String get navHealthTracking => 'Health Tracking';

  @override
  String get navHelp => 'Help';

  @override
  String get navHome => 'Home';

  @override
  String get navLogin => 'Login';

  @override
  String get navMessages => 'Messages';

  @override
  String get navMySurveys => 'My Surveys';

  @override
  String get navNewMessage => 'New Message';

  @override
  String get navNewSurvey => 'New Survey';

  @override
  String get navNewTemplate => 'New Template';

  @override
  String get navPageNavigator => 'Page Navigator';

  @override
  String get navParticipants => 'Participants';

  @override
  String get navQuestionBank => 'Question Bank';

  @override
  String get navReports => 'Reports';

  @override
  String get navRequestAccount => 'Request Account';

  @override
  String get navResetPassword => 'Reset Password';

  @override
  String get navResults => 'Results';

  @override
  String get navSettings => 'Settings';

  @override
  String get navSurveys => 'Surveys';

  @override
  String get navTasks => 'To-Do';

  @override
  String get navTemplates => 'Templates';

  @override
  String get navTickets => 'Tickets';

  @override
  String get navUiTest => 'UI Test';

  @override
  String get navUserManagement => 'User Management';

  @override
  String get consentCheckboxLabel =>
      'I have read, understand, and agree to the terms of this consent form.';

  @override
  String get consentDateLabel => 'Date';

  @override
  String get consentDocumentHcp =>
      'HEALTHCARE PROFESSIONAL DATA ACCESS AND CONFIDENTIALITY AGREEMENT\n\nPlatform: HealthBank — Personal Health Data Collection and Research Platform\n\n1. PROFESSIONAL OBLIGATIONS\n\nAs a Healthcare Professional (HCP) accessing the HealthBank platform, you acknowledge that you are bound by both this agreement and the professional standards and regulations governing your practice, including those of your regulatory college or association. Your obligations under this agreement are in addition to, and do not replace, your existing professional duties of confidentiality.\n\n2. DATA ACCESS LIMITATIONS\n\nYour access to participant data through HealthBank is strictly limited to:\n- Data directly relevant to the care of patients under your supervision\n- Aggregated research data as authorized by your institutional agreement\n- Information necessary for clinical decision-making within your scope of practice\n\nYou must not access data for patients who are not under your care, or for purposes unrelated to authorized clinical or research activities.\n\n3. CONFIDENTIALITY DUTY\n\nYou agree to maintain absolute confidentiality regarding all participant data accessed through this platform. This duty of confidentiality:\n- Is in addition to your professional obligations under your regulatory body\n- Continues indefinitely, even after you cease using the platform\n- Extends to all forms of data, whether digital, verbal, or written\n- Applies in all contexts, including conversations with colleagues not involved in the participant\'s care\n\n4. BREACH REPORTING\n\nYou are legally and professionally obligated to immediately report any suspected or actual data breach, including:\n- Unauthorized access to patient data\n- Accidental disclosure of identifiable health information\n- Loss or theft of devices used to access the platform\n- Suspicious activity observed on the platform\n\nReports must be made to the HealthBank Privacy Officer within 24 hours of discovery. Failure to report a breach is itself a violation of this agreement and may constitute professional misconduct.\n\n5. LIABILITY ACKNOWLEDGMENT\n\nYou acknowledge that:\n- You are personally liable for any unauthorized access or disclosure of participant data\n- Your institution may also bear liability for breaches occurring within their systems\n- Insurance coverage may not apply to intentional or grossly negligent breaches\n- Participants have the right to seek damages for unauthorized disclosure of their health information\n\n6. REGULATORY COMPLIANCE\n\nYou confirm that you will comply with all applicable privacy and health information legislation, including:\n- PHIPA (Personal Health Information Protection Act)\n- PIPEDA (Personal Information Protection and Electronic Documents Act)\n- Professional standards of your regulatory college\n- Institutional privacy and data handling policies\n\n7. DISCLOSURE EXCEPTIONS\n\nYou may disclose participant information without consent only where required or permitted by law, including:\n- Where required by court order or subpoena\n- To prevent imminent harm to the participant or others\n- Where required by mandatory reporting legislation (e.g., child protection)\n- As required by your professional regulatory body during an investigation\n\nIn all such cases, you must document the disclosure and notify the HealthBank Privacy Officer.\n\n8. CONSEQUENCES OF VIOLATION\n\nViolation of this agreement may result in:\n- Immediate revocation of platform access\n- Reporting to your professional regulatory body\n- Disciplinary proceedings which may include suspension or revocation of licensure\n- Civil liability for damages to affected participants\n- Penalties under PHIPA/PIPEDA (fines up to \$100,000 per violation)\n- Criminal prosecution in cases of willful or malicious breach\n\nBy checking the agreement box below, you confirm that you have read, understood, and agree to all terms of this confidentiality agreement.';

  @override
  String get consentDocumentParticipant =>
      'PARTICIPANT INFORMED CONSENT FORM\n\nStudy Title: HealthBank — Personal Health Data Collection and Research Platform\n\n1. PURPOSE OF THIS STUDY\n\nYou are being invited to participate in a research study conducted through the HealthBank platform. The purpose of this study is to collect personal health information from participants to support health research, data analysis, and the improvement of healthcare outcomes. Your participation is entirely voluntary.\n\n2. TYPES OF DATA COLLECTED\n\nAs a participant, the following types of information may be collected from you:\n- Demographic information (name, date of birth, gender)\n- Health survey responses (physical health, mental health, lifestyle, symptoms)\n- Survey completion data (timestamps, response patterns)\n- Technical data (IP address, browser information) for security purposes\n\n3. HOW YOUR DATA WILL BE USED\n\nYour data will be used for the following purposes:\n- Health research conducted by authorized researchers\n- Statistical analysis and aggregation to identify health trends\n- Improvement of healthcare services and outcomes\n- Academic publication (only aggregated, de-identified data)\n\nYour individual responses will never be published or shared in a way that could identify you. All research outputs use aggregated data with a minimum of 5 respondents (k-anonymity) to prevent identification.\n\n4. WHO HAS ACCESS TO YOUR DATA\n\nAccess to your data is strictly controlled:\n- Researchers: Access only to aggregated, de-identified data through the research portal\n- Healthcare Professionals (HCPs): Access limited to data relevant to your care\n- System Administrators: Technical access for platform maintenance only\n- No third parties will receive your individual data without your explicit consent\n\n5. DATA RETENTION\n\nYour data will be retained for the duration of the research program. After the program concludes, data will be securely archived or destroyed in accordance with institutional data retention policies. You may request information about data retention timelines at any time.\n\n6. YOUR RIGHT TO WITHDRAW\n\nYou have the right to withdraw your consent at any time without penalty or loss of benefits. To withdraw, contact the Privacy Officer at the contact information provided below. Upon withdrawal:\n- No new data will be collected from you\n- Your account will be deactivated\n- However, data that has already been included in completed analyses or published research cannot be removed, as it has been aggregated and de-identified\n\n7. DATA PERSISTENCE AFTER WITHDRAWAL\n\nPlease be aware that while we will cease collecting new data upon withdrawal, any data that has already been shared with researchers in aggregated form cannot be recalled or removed from completed analyses. This is a necessary limitation of research data that has already been processed.\n\n8. RISKS AND SAFEGUARDS\n\nWhile every effort is made to protect your data, no system is completely without risk. Potential risks include:\n- Unauthorized access despite security measures\n- Re-identification through combination with external data sources\n\nTo mitigate these risks, we employ:\n- Industry-standard encryption for data in transit and at rest\n- Role-based access controls limiting who can see what data\n- K-anonymity thresholds (minimum 5 respondents) for all research outputs\n- Regular security audits and monitoring\n- Secure session management with automatic expiration\n\n9. CONFIDENTIALITY MEASURES\n\nYour information is protected by:\n- Encrypted data storage and transmission\n- Strict access controls based on role and need\n- Audit logging of all data access\n- Compliance with PIPEDA (Personal Information Protection and Electronic Documents Act) and PHIPA (Personal Health Information Protection Act)\n- Adherence to TCPS 2 (Tri-Council Policy Statement: Ethical Conduct for Research Involving Humans)\n\n10. CONTACT INFORMATION\n\nIf you have questions about this study, your rights as a participant, or wish to withdraw your consent, please contact:\n\nHealthBank Privacy Officer\nEmail: privacy@healthbank.ca\n\n11. ELECTRONIC SIGNATURE\n\nBy checking the agreement box below, you confirm that:\n- You have read and understood this consent form\n- You voluntarily agree to participate in this study\n- You understand your right to withdraw at any time\n- You acknowledge that your electronic agreement constitutes a legally binding signature pursuant to the Uniform Electronic Commerce Act (UECA)';

  @override
  String get consentDocumentResearcher =>
      'RESEARCHER DATA USE AND CONFIDENTIALITY AGREEMENT\n\nPlatform: HealthBank — Personal Health Data Collection and Research Platform\n\n1. DATA CONFIDENTIALITY OBLIGATIONS\n\nAs an authorized researcher on the HealthBank platform, you agree to maintain the strictest confidentiality regarding all participant data accessed through this platform. You acknowledge that participant data is collected under informed consent and is protected by Canadian privacy legislation including PIPEDA and PHIPA.\n\n2. PERMITTED USES\n\nYou may use data accessed through HealthBank solely for:\n- Approved research projects as defined in your research protocol\n- Statistical analysis using aggregated, de-identified data\n- Academic publications using only aggregated results\n- Quality improvement of research methodologies\n\nAny use beyond these purposes requires separate approval from the HealthBank administration and relevant ethics boards.\n\n3. DISCLOSURE LIMITATIONS\n\nYou agree that you will NOT:\n- Share individual participant data with any unauthorized person\n- Attempt to re-identify or de-anonymize any participant\n- Transfer data outside the HealthBank platform without written authorization\n- Use data for commercial purposes without explicit approval\n- Discuss individual participant responses outside the authorized research team\n\n4. CONSEQUENCES OF BREACH\n\nViolation of this agreement may result in:\n- Immediate revocation of platform access\n- Disciplinary action by your institution\n- Legal liability under PIPEDA and PHIPA (fines up to \$100,000 per violation)\n- Professional sanctions from relevant regulatory bodies\n- Civil liability for damages caused to participants\n\n5. DATA HANDLING AND SECURITY\n\nYou agree to:\n- Access data only through the authorized HealthBank platform interface\n- Not download or store individual participant data on personal devices\n- Use only institutional, password-protected devices for research access\n- Report any suspected data breach immediately to the HealthBank Privacy Officer\n- Follow all institutional data security policies and procedures\n\n6. PUBLICATION RESTRICTIONS\n\nWhen publishing research based on HealthBank data, you must:\n- Use only aggregated, de-identified results\n- Ensure no individual participant can be identified through published data\n- Acknowledge the HealthBank platform as the data source\n- Submit publications for review before submission if required by your research agreement\n\n7. BREACH REPORTING\n\nYou are legally obligated to immediately report any suspected or actual data breach, including:\n- Unauthorized access to participant data\n- Accidental disclosure of identifiable information\n- Loss or theft of devices containing research data\n- Any suspicious activity on the platform\n\nReports must be made to the HealthBank Privacy Officer within 24 hours of discovery.\n\n8. DURATION OF OBLIGATIONS\n\nYour confidentiality obligations under this agreement continue indefinitely, even after:\n- Your research project concludes\n- Your access to the platform is terminated\n- Your employment or affiliation with your institution ends\n\n9. DATA RETURN AND DESTRUCTION\n\nUpon completion of your research or termination of access, you agree to:\n- Delete all locally stored research data derived from HealthBank\n- Certify in writing that all data has been destroyed\n- Return any physical materials containing participant information\n\nBy checking the agreement box below, you confirm that you have read, understood, and agree to all terms of this confidentiality agreement.';

  @override
  String get consentElectronicSignatureNotice =>
      'By typing your name in the signature field and checking the agreement box, you acknowledge that your electronic signature has the same legal effect as a handwritten signature pursuant to the Uniform Electronic Commerce Act (UECA).';

  @override
  String get consentErrorGeneric =>
      'Failed to submit consent. Please try again.';

  @override
  String get consentHcpTitle =>
      'Healthcare Professional Confidentiality Agreement';

  @override
  String get consentPageSubtitle =>
      'Please review and agree to the consent form to continue.';

  @override
  String get consentPageTitle => 'Consent Form';

  @override
  String get consentParticipantTitle => 'Participant Informed Consent';

  @override
  String get consentRecordDocumentLanguage => 'Document Language';

  @override
  String get consentRecordIpAddress => 'IP Address';

  @override
  String get consentRecordSignatureName => 'Signature';

  @override
  String get consentRecordSignedAt => 'Signed At';

  @override
  String get consentRecordTitle => 'Consent Record Details';

  @override
  String get consentRecordUserAgent => 'User Agent';

  @override
  String get consentResearcherTitle => 'Researcher Confidentiality Agreement';

  @override
  String get consentRestoreHcpAccess => 'Restore HCP Access';

  @override
  String get consentRestoreSuccess => 'HCP access restored';

  @override
  String consentRevokeConfirmBody(String hcpName) {
    return 'This will prevent $hcpName from viewing your health data. You can restore access later.';
  }

  @override
  String get consentRevokeConfirmTitle => 'Revoke HCP Access?';

  @override
  String get consentRevokeError =>
      'Failed to update consent. Please try again.';

  @override
  String get consentRevokeHcpAccess => 'Revoke HCP Access';

  @override
  String get consentRevokeSuccess => 'HCP access revoked';

  @override
  String get consentSignatureDisclaimer =>
      'By typing your full legal name in the signature field, you confirm that this constitutes your electronic signature and has the same legal force and effect as a handwritten signature pursuant to the Uniform Electronic Commerce Act (UECA) and applicable Canadian provincial legislation. This electronic signature is legally binding and enforceable under the Personal Information Protection and Electronic Documents Act (PIPEDA).';

  @override
  String get consentSignatureHint => 'Type your full legal name';

  @override
  String get consentSignatureLabel => 'Electronic Signature';

  @override
  String get consentStatusNotSigned => 'Consent Not Signed';

  @override
  String get consentStatusSigned => 'Consent Signed';

  @override
  String consentStatusSignedAt(String date) {
    return 'Signed: $date';
  }

  @override
  String consentStatusVersion(String version) {
    return 'Version: $version';
  }

  @override
  String get consentSubmitButton => 'I Agree and Submit';

  @override
  String get consentViewRecord => 'View Consent Record';

  @override
  String get participantAvailableSurveys => 'Available Surveys';

  @override
  String get participantCategoryLabel => 'Category';

  @override
  String get participantChartDistribution => 'Distribution';

  @override
  String get participantChartError => 'Could not load chart data.';

  @override
  String get participantChartLoading => 'Loading charts...';

  @override
  String get participantChartMean => 'Average';

  @override
  String get participantChartMedian => 'Median';

  @override
  String get participantChartNo => 'No';

  @override
  String get participantChartNoData => 'No chart data available.';

  @override
  String get participantChartSuppressed =>
      'Aggregate data hidden for privacy (fewer than 5 respondents).';

  @override
  String get participantChartToggle => 'Show charts';

  @override
  String get participantChartYes => 'Yes';

  @override
  String get participantChartYourAnswer => 'Your answer';

  @override
  String get participantChartYourValue => 'Your Value';

  @override
  String get participantClickToView => 'Click to view';

  @override
  String get participantCollapseSurvey => 'Hide details';

  @override
  String get participantCompareAggregate => 'Aggregate';

  @override
  String get participantCompareError => 'Could not load comparison data.';

  @override
  String get participantCompareLoading => 'Loading comparison...';

  @override
  String get participantCompareMostCommon => 'Most common';

  @override
  String get participantCompareNoData => 'No comparison data available.';

  @override
  String get participantCompareToggle => 'Compare to aggregate';

  @override
  String participantCompletedOn(Object date) {
    return 'Completed $date';
  }

  @override
  String get participantCompletedSurveys => 'Completed Surveys';

  @override
  String get participantCompletedThisWeek => 'Completed this week';

  @override
  String get participantContinueSurvey => 'Continue Survey';

  @override
  String get participantDashboardDescription =>
      'Review your graphs and diagrams.';

  @override
  String get participantDoTask => 'Do Task';

  @override
  String get participantDownloadResults => 'Download Results';

  @override
  String participantDueOn(String date) {
    return 'Due on $date';
  }

  @override
  String get participantDueToday => 'Due today';

  @override
  String participantDueTodayAt(String time) {
    return 'Due today at $time';
  }

  @override
  String get participantExpandSurvey => 'Show details';

  @override
  String get participantGraphPlaceholder => 'Graph placeholder';

  @override
  String get participantGraphTitle1 => 'Graph Title 1';

  @override
  String get participantGraphTitle2 => 'Graph Title 2';

  @override
  String get participantLinkedHcps => 'Linked Health Care Providers';

  @override
  String get participantLoadingResults => 'Loading your data...';

  @override
  String get participantMyResults => 'My Results';

  @override
  String get participantMySurveys => 'My Surveys';

  @override
  String get participantMyTasks => 'My Tasks';

  @override
  String participantNewMessages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You have $count new messages.\nClick to here to view.',
      one: 'You have 1 new message.\nClick to here to view.',
    );
    return '$_temp0';
  }

  @override
  String get participantNoDueDate => 'No deadline';

  @override
  String get participantNoResults => 'You haven\'t completed any surveys yet.';

  @override
  String get participantNoResultsYet => 'No results available yet';

  @override
  String get participantNoSurveys => 'No surveys assigned to you yet.';

  @override
  String get participantNoSurveysSubtitle =>
      'Review assigned surveys and continue any saved drafts here.';

  @override
  String get participantNoTasksDueToday => 'No tasks due today';

  @override
  String participantNotificationMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You have $count new messages.\nClick to here to view.',
      one: 'You have 1 new message.\nClick to here to view.',
    );
    return '$_temp0';
  }

  @override
  String participantOverdueSince(String date) {
    return 'Overdue since $date';
  }

  @override
  String participantOverdueTasksSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks are overdue',
      one: '1 task is overdue',
    );
    return '$_temp0';
  }

  @override
  String get participantPlaceholder => '(Placeholder)';

  @override
  String participantQuestionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
    );
    return '$_temp0';
  }

  @override
  String get participantQuickInsightsCaughtUpBadge => 'You’re all caught up';

  @override
  String get participantQuickInsightsCaughtUpMessage =>
      'You’re all caught up. No surveys are waiting right now.';

  @override
  String participantQuickInsightsCompletedOn(String date) {
    return 'Completed on $date';
  }

  @override
  String get participantQuickInsightsMostRecentTitle =>
      'Most recent survey completed';

  @override
  String get participantQuickInsightsNoCompletedYet =>
      'No completed surveys yet. Once you finish one, it will appear here.';

  @override
  String get participantQuickInsightsTitle => 'Quick Insights';

  @override
  String get participantQuickInsightsViewInResults => 'View in Results';

  @override
  String participantRemainingTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Remaining Tasks',
      one: '1 Remaining Task',
    );
    return '$_temp0';
  }

  @override
  String participantRemainingTasksForToday(int count) {
    return 'Remaining tasks for today: $count';
  }

  @override
  String participantRepeatsEvery(int days) {
    return 'Repeats every $days days';
  }

  @override
  String get participantResponseLabel => 'Your Response';

  @override
  String get participantResultsError =>
      'Could not load your data. Please try again.';

  @override
  String get participantResultsTitle => 'My Data';

  @override
  String get participantResumeSurvey => 'Resume Survey';

  @override
  String get participantRetry => 'Retry';

  @override
  String get participantStartSurvey => 'Start Survey';

  @override
  String get participantSurveyCompleted => 'Completed';

  @override
  String participantSurveyDueDate(String date) {
    return 'Due: $date';
  }

  @override
  String get participantSurveyLoadError =>
      'Could not load surveys. Please try again.';

  @override
  String get participantSurveyStatusCompleted => 'Completed';

  @override
  String get participantSurveyStatusExpired => 'Expired';

  @override
  String get participantSurveyStatusIncomplete => 'Incomplete';

  @override
  String get participantSurveyStatusPending => 'Pending';

  @override
  String get participantTaskProgress => 'Task Progress';

  @override
  String get participantTaskProgressLabel => 'Your Task Progress:';

  @override
  String participantTasksCompleted(int completed, int total) {
    return '$completed out of $total tasks completed';
  }

  @override
  String participantTasksCompletedLabel(int completed, int total) {
    return '$completed out of $total tasks completed';
  }

  @override
  String participantTasksCompletedThisWeekSummary(int completed, int total) {
    return '$completed of $total current tasks completed this week';
  }

  @override
  String get participantUnknownSurvey => 'Survey';

  @override
  String get participantViewAllTasks => 'View All Tasks';

  @override
  String get participantViewResults => 'View Results';

  @override
  String participantWelcomeGreeting(String name) {
    return 'Welcome, $name. How are you today?';
  }

  @override
  String participantWelcomeMessage(String name) {
    return 'Welcome, $name. How are you today?';
  }

  @override
  String get participantYourTaskProgress => 'Your Task Progress:';

  @override
  String get todoAlertsTitle => 'Action Required';

  @override
  String get todoCompletedSummaryTitle => 'Your Progress';

  @override
  String get todoConsentRequired =>
      'Your consent needs to be renewed. Please review and sign.';

  @override
  String get todoDueSoonLabel => 'Due soon';

  @override
  String get todoHcpAccept => 'Accept';

  @override
  String get todoHcpDecline => 'Decline';

  @override
  String get todoHcpLinkAccepted => 'Connection accepted';

  @override
  String get todoHcpLinkDeclined => 'Connection declined';

  @override
  String get todoHcpLinkError => 'Failed to respond. Please try again.';

  @override
  String todoHcpLinkRequest(String hcpName) {
    return '$hcpName has requested to track your health data.';
  }

  @override
  String get todoNoTasks => 'You have no pending tasks.';

  @override
  String get todoOverdueLabel => 'Overdue';

  @override
  String get todoPageTitle => 'My Tasks';

  @override
  String get todoPendingSurveysTitle => 'Pending Surveys';

  @override
  String get todoProfileIncomplete =>
      'Your profile is incomplete. Please add your name.';

  @override
  String get todoRefreshing => 'Refreshing...';

  @override
  String get todoStartSurvey => 'Start Survey';

  @override
  String get todoViewResults => 'View Results';

  @override
  String get healthCheckInTaskAction => 'Start Check-in';

  @override
  String get healthCheckInTaskCompletedToday => 'Completed today';

  @override
  String get healthCheckInTaskDueText => 'Due today';

  @override
  String healthCheckInTaskProgress(int completed, int total) {
    return '$completed/$total questions answered';
  }

  @override
  String get healthCheckInTaskRepeat => 'Daily';

  @override
  String get healthCheckInTaskTitle => 'Daily Health Check-in';

  @override
  String get healthTrackingAggregateUnavailable =>
      'Population comparison unavailable (insufficient data).';

  @override
  String get healthTrackingAllCategories => 'All categories';

  @override
  String get healthTrackingAverageLabel => 'Avg';

  @override
  String get healthTrackingAverageTitle => 'Average Value Over Time';

  @override
  String get healthTrackingAvgValue => 'Avg Value';

  @override
  String get healthTrackingBaselineBanner =>
      'Record your starting point — fill in today\'s values as your health baseline.';

  @override
  String get healthTrackingCategory => 'Category';

  @override
  String get healthTrackingChartBar => 'Bar chart';

  @override
  String healthTrackingChartEntries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries',
      one: '$count entry',
    );
    return '$_temp0';
  }

  @override
  String get healthTrackingChartError => 'Could not load chart data.';

  @override
  String get healthTrackingChartLine => 'Line chart';

  @override
  String get healthTrackingChartPie => 'Pie chart';

  @override
  String get healthTrackingCharts => 'Charts';

  @override
  String get healthTrackingChartTypeLabel => 'Chart type';

  @override
  String get healthTrackingChartYesNoHint => 'Yes = 1 / No = 0';

  @override
  String get healthTrackingClearAllMetrics => 'Clear all';

  @override
  String get healthTrackingClearSelection => 'Clear';

  @override
  String get healthTrackingCollapseCategory => 'Collapse category';

  @override
  String get healthTrackingCompareToAggregate => 'Compare to Aggregate';

  @override
  String healthTrackingDraftHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count answers filled',
      one: '$count answer filled',
    );
    return '$_temp0';
  }

  @override
  String get healthTrackingEnterText => 'Enter your response';

  @override
  String get healthTrackingEnterValue => 'Enter value';

  @override
  String get healthTrackingExpandCategory => 'Expand category';

  @override
  String healthTrackingExportError(String error) {
    return 'Export failed: $error';
  }

  @override
  String get healthTrackingExportFiltered => 'Export Filtered Data';

  @override
  String get healthTrackingExporting => 'Exporting…';

  @override
  String get healthTrackingExportOwnData => 'Export My Data (CSV)';

  @override
  String get healthTrackingFilters => 'Filters';

  @override
  String get healthTrackingGranularityDaily => 'Daily';

  @override
  String get healthTrackingGranularityLabel => 'Granularity';

  @override
  String get healthTrackingGranularityMonthly => 'Monthly';

  @override
  String get healthTrackingGranularityWeekly => 'Weekly';

  @override
  String get healthTrackingHideFilters => 'Hide filters';

  @override
  String get healthTrackingHistory => 'History';

  @override
  String get healthTrackingHistoryAll => 'All Entries';

  @override
  String get healthTrackingHistoryByCategory => 'By Category';

  @override
  String get healthTrackingHistoryByMetric => 'By Metric';

  @override
  String get healthTrackingHistoryDateFrom => 'From';

  @override
  String get healthTrackingHistoryDateTo => 'To';

  @override
  String get healthTrackingHistoryModeLabel => 'History view mode';

  @override
  String get healthTrackingHistoryNoEntries =>
      'No entries found for the selected period.';

  @override
  String get healthTrackingHistoryTruncated =>
      'Showing 100 most recent entries.';

  @override
  String get healthTrackingLoadChart => 'Load Chart';

  @override
  String get healthTrackingLogToday => 'Log Today';

  @override
  String get healthTrackingMetric => 'Metric';

  @override
  String get healthTrackingMetricsError => 'Could not load metrics.';

  @override
  String get healthTrackingMonthlySection => 'MONTHLY CHECK-IN';

  @override
  String get healthTrackingMultiChartTitle => 'Average Values Over Time';

  @override
  String get healthTrackingMyDataOnly => 'My Data Only';

  @override
  String healthTrackingNMetricsSelected(int count) {
    return '$count selected';
  }

  @override
  String get healthTrackingNoData => 'No data yet';

  @override
  String get healthTrackingNoMetrics => 'No metrics available.';

  @override
  String get healthTrackingParticipants => 'Participants';

  @override
  String get healthTrackingRecentEntries => 'Recent entries';

  @override
  String get healthTrackingResearchCategories => 'Category Overview';

  @override
  String get healthTrackingResearchDeepDive => 'Metric Deep-Dive';

  @override
  String get healthTrackingResearchExport => 'Export Health Tracking CSV';

  @override
  String get healthTrackingResearchNoData =>
      'No data available for the selected filters.';

  @override
  String get healthTrackingResearchTitle => 'Health Tracking Analytics';

  @override
  String get healthTrackingResultsViewLabel => 'View results as table or chart';

  @override
  String get healthTrackingSave => 'Save Entries';

  @override
  String get healthTrackingSaveError =>
      'Failed to save entries. Please try again.';

  @override
  String get healthTrackingSaveSuccess => 'Entries saved successfully.';

  @override
  String get healthTrackingSelectAll => 'All';

  @override
  String get healthTrackingSelectAllMetrics => 'Select all';

  @override
  String get healthTrackingSelectCategoryAll => 'Select all in category';

  @override
  String get healthTrackingSelectMetric => 'Select a metric';

  @override
  String get healthTrackingSelectMetrics => 'Select Metrics';

  @override
  String get healthTrackingSelectMetricsHint =>
      'Select at least one metric to load the chart';

  @override
  String get healthTrackingSelectMetricTooltip =>
      'Select a metric to load chart data';

  @override
  String get healthTrackingShowFilters => 'Show filters';

  @override
  String get healthTrackingTitle => 'Health Tracking';

  @override
  String get healthTrackingValueColumn => 'Value';

  @override
  String get healthTrackingViewChart => 'Chart view';

  @override
  String get healthTrackingViewModeLabel => 'View mode: log today or history';

  @override
  String get healthTrackingViewTable => 'Table view';

  @override
  String get healthTrackingWeeklySection => 'WEEKLY CHECK-IN';

  @override
  String healthTrackingXofYMetrics(int selected, int total) {
    return '$selected of $total metrics';
  }

  @override
  String get surveyAssignAge3044 => '30–44';

  @override
  String get surveyAssignAge4559 => '45–59';

  @override
  String get surveyAssignAge60Plus => '60 and over';

  @override
  String get surveyAssignAgeAny => 'Any';

  @override
  String get surveyAssignAgeMaxLabel => 'Age Max';

  @override
  String get surveyAssignAgeMinLabel => 'Age Min';

  @override
  String get surveyAssignAgeRangeLabel => 'Age Range';

  @override
  String get surveyAssignAgeUnder30 => 'Under 30';

  @override
  String get surveyAssignAgeValidationInteger => 'Age must be an integer.';

  @override
  String get surveyAssignAgeValidationNonNegative => 'Age cannot be negative.';

  @override
  String get surveyAssignAgeValidationRange =>
      'Minimum age must be less than or equal to maximum age.';

  @override
  String get surveyAssignAgeValidationRequired => 'Age is required.';

  @override
  String surveyAssignAgeValidationUpperBound(int max) {
    return 'Age must be $max or less.';
  }

  @override
  String surveyAssignBulkResult(int totalTargeted, int assigned, int skipped) {
    return 'Targeted: $totalTargeted • Assigned: $assigned • Skipped: $skipped';
  }

  @override
  String get surveyAssignBulkSuccess => 'Survey assigned successfully';

  @override
  String get surveyAssignButton => 'Assign Now';

  @override
  String get surveyAssignClearDueDate => 'Clear due date';

  @override
  String get surveyAssignDueDate => 'Due date (optional)';

  @override
  String get surveyAssignErrorAlready =>
      'This participant is already assigned.';

  @override
  String get surveyAssignErrorGeneral => 'Failed to assign survey.';

  @override
  String get surveyAssignErrorLoad => 'Could not load assignments.';

  @override
  String get surveyAssignErrorNotPublished =>
      'Only published surveys can be assigned.';

  @override
  String get surveyAssignGenderAll => 'All';

  @override
  String get surveyAssignGenderAny => 'Any';

  @override
  String get surveyAssignGenderFemale => 'Female';

  @override
  String get surveyAssignGenderLabel => 'Gender';

  @override
  String get surveyAssignGenderMale => 'Male';

  @override
  String get surveyAssignGenderNonBinary => 'Non-binary';

  @override
  String get surveyAssignGenderOther => 'Other';

  @override
  String get surveyAssignGenderUnspecified => 'Unspecified';

  @override
  String get surveyAssignLoading => 'Loading assignments...';

  @override
  String get surveyAssignmentDelete => 'Remove';

  @override
  String get surveyAssignmentDeleteConfirm => 'Remove this assignment?';

  @override
  String get surveyAssignmentDeleteError => 'Failed to remove assignment.';

  @override
  String get surveyAssignmentDeleteSuccess => 'Assignment removed.';

  @override
  String surveyAssignmentDueDate(String date) {
    return 'Due: $date';
  }

  @override
  String get surveyAssignments => 'Current Assignments';

  @override
  String get surveyAssignmentsEmpty => 'No participants assigned yet.';

  @override
  String get surveyAssignmentStatusCompleted => 'Completed';

  @override
  String get surveyAssignmentStatusExpired => 'Expired';

  @override
  String get surveyAssignmentStatusPending => 'Pending';

  @override
  String get surveyAssignSuccess => 'Survey assigned successfully';

  @override
  String surveyAssignSummaryCompleted(int count) {
    return '$count completed';
  }

  @override
  String surveyAssignSummaryExpired(int count) {
    return '$count expired';
  }

  @override
  String get surveyAssignSummaryNone => 'No assignments yet';

  @override
  String surveyAssignSummaryPending(int count) {
    return '$count pending';
  }

  @override
  String surveyAssignSummaryTotal(int count) {
    return '$count assigned';
  }

  @override
  String get surveyAssignTargetAll => 'All Participants';

  @override
  String get surveyAssignTargetDemographic => 'By Demographic';

  @override
  String get surveyAssignTargetLabel => 'Assign To';

  @override
  String get surveyAssignTitle => 'Assign Survey';

  @override
  String get surveyBuilderAddNewQuestion => 'Add New Question';

  @override
  String get surveyBuilderAddQuestions => 'Add Questions';

  @override
  String get surveyBuilderAddQuestionsFirst =>
      'Please add at least one question before publishing';

  @override
  String get surveyBuilderAutoSaveFailed => 'Save failed';

  @override
  String get surveyBuilderAutoSaveRetry => 'Retry';

  @override
  String get surveyBuilderAutoSaveSaved => 'Saved';

  @override
  String get surveyBuilderAutoSaveSaving => 'Saving...';

  @override
  String get surveyBuilderAutoSaveUnsaved => 'Unsaved';

  @override
  String get surveyBuilderBack => 'Back';

  @override
  String get surveyBuilderDescriptionHint =>
      'Describe the purpose of this survey';

  @override
  String get surveyBuilderDescriptionLabel => 'Description (optional)';

  @override
  String get surveyBuilderDragToReorder => 'Drag to reorder';

  @override
  String get surveyBuilderEditTitle => 'Edit Survey';

  @override
  String get surveyBuilderEmptyStateSubtitle =>
      'Add questions to build your survey';

  @override
  String get surveyBuilderEmptyStateTitle => 'No questions yet';

  @override
  String get surveyBuilderEndDate => 'End Date';

  @override
  String get surveyBuilderFailedToLoadQuestions => 'Failed to load questions';

  @override
  String get surveyBuilderHideQuestionBank => 'Hide Question Bank';

  @override
  String surveyBuilderImportDialogAddSelected(int count) {
    return 'Add Selected ($count)';
  }

  @override
  String get surveyBuilderImportDialogAlreadyAdded => 'Already added';

  @override
  String get surveyBuilderImportDialogSearch => 'Search questions...';

  @override
  String get surveyBuilderImportDialogTitle => 'Import from Question Bank';

  @override
  String get surveyBuilderImportFromBank => 'Import from Question Bank';

  @override
  String get surveyBuilderNewTitle => 'New Survey';

  @override
  String get surveyBuilderNoQuestions => 'No questions added yet';

  @override
  String get surveyBuilderNoQuestionsInBank => 'No questions in bank yet';

  @override
  String get surveyBuilderPreview => 'Preview Survey';

  @override
  String get surveyBuilderPublish => 'Publish';

  @override
  String get surveyBuilderPublishConfirmMessage =>
      'Once published, the survey will be available for assignment to participants. Are you sure you want to publish?';

  @override
  String get surveyBuilderPublishedSuccess => 'Survey published successfully';

  @override
  String surveyBuilderQuestionAdded(String title) {
    return 'Added: $title';
  }

  @override
  String get surveyBuilderQuestionBank => 'Question Bank';

  @override
  String get surveyBuilderQuestionCardCancelEdit => 'Cancel edit';

  @override
  String get surveyBuilderQuestionCardConfirm => 'Confirm question';

  @override
  String get surveyBuilderQuestionCardCreateFailed =>
      'Failed to create question';

  @override
  String get surveyBuilderQuestionCardEdit => 'Edit question';

  @override
  String get surveyBuilderQuestionCardPlaceholder => 'Type your question here';

  @override
  String get surveyBuilderQuestionCardSave => 'Save changes';

  @override
  String get surveyBuilderQuestionCardUpdateFailed =>
      'Failed to update question';

  @override
  String surveyBuilderQuestionsCount(int count) {
    return 'Questions ($count)';
  }

  @override
  String surveyBuilderQuestionsImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions imported',
      one: '1 question imported',
    );
    return '$_temp0';
  }

  @override
  String get surveyBuilderRemoveQuestion => 'Remove question';

  @override
  String get surveyBuilderSavedAsDraft => 'Survey saved as draft';

  @override
  String get surveyBuilderSaveDraft => 'Save Draft';

  @override
  String get surveyBuilderSelectDate => 'Select date';

  @override
  String get surveyBuilderSelectFromPanel =>
      'Select questions from the available question list';

  @override
  String get surveyBuilderShowQuestionBank => 'Show Question Bank';

  @override
  String get surveyBuilderStartDate => 'Start Date';

  @override
  String get surveyBuilderStartFromTemplate => 'Start from Template';

  @override
  String get surveyBuilderTapToAdd =>
      'Tap \"Add Questions\" to select from the question bank';

  @override
  String get surveyBuilderTapToAddQuestion =>
      'Tap a question to add it to your survey';

  @override
  String surveyBuilderTemplateLoaded(String title) {
    return 'Loaded template: $title';
  }

  @override
  String get surveyBuilderTitleHint => 'Enter a descriptive title';

  @override
  String get surveyBuilderTitleLabel => 'Survey Title *';

  @override
  String get surveyBuilderTitleRequired => 'Title is required';

  @override
  String get surveyBuilderUntitledSurvey => 'Untitled Survey';

  @override
  String get surveyBuilderUpdatedSuccess => 'Survey updated successfully';

  @override
  String get surveyBuilderUpdateSurvey => 'Update Survey';

  @override
  String get surveyCardAssign => 'Assign';

  @override
  String get surveyCardClose => 'Close';

  @override
  String get surveyCardDelete => 'Delete';

  @override
  String get surveyCardEdit => 'Edit';

  @override
  String get surveyCardPublish => 'Publish';

  @override
  String get surveyCardViewStatus => 'View Survey Status';

  @override
  String get surveyCloseButton => 'Close Survey';

  @override
  String get surveyClosedSuccess => 'Survey closed';

  @override
  String surveyCloseFailed(String error) {
    return 'Failed to close survey: $error';
  }

  @override
  String get surveyCloseMessage =>
      'Closing the survey will prevent new responses. Are you sure you want to close it?';

  @override
  String get surveyCloseTitle => 'Close Survey';

  @override
  String surveyDeleteConfirm(String title) {
    return 'Are you sure you want to delete \"$title\"?\n\nExisting responses will be preserved for research purposes. This action cannot be undone.';
  }

  @override
  String get surveyDeletedSuccess => 'Survey deleted';

  @override
  String surveyDeleteFailed(String error) {
    return 'Failed to delete: $error';
  }

  @override
  String get surveyDeleteTitle => 'Delete Survey';

  @override
  String get surveyListAllSurveys => 'All Surveys';

  @override
  String get surveyListClearAll => 'Clear All';

  @override
  String get surveyListClosed => 'Closed';

  @override
  String get surveyListCreateSurvey => 'Create Survey';

  @override
  String surveyListDateFrom(String date) {
    return 'From $date';
  }

  @override
  String surveyListDateUntil(String date) {
    return 'Until $date';
  }

  @override
  String get surveyListDrafts => 'Drafts';

  @override
  String get surveyListFailedToLoad => 'Failed to load surveys';

  @override
  String get surveyListFiltersLabel => 'Filters: ';

  @override
  String get surveyListNewSurvey => 'New Survey';

  @override
  String get surveyListNoMatchFilters => 'No surveys match your filters';

  @override
  String get surveyListNoSurveys => 'No surveys yet';

  @override
  String get surveyListPublished => 'Published';

  @override
  String surveyListQuestionCount(int count) {
    return '$count questions';
  }

  @override
  String get surveyListSearchPlaceholder => 'Search surveys...';

  @override
  String get surveyListStatus => 'Status';

  @override
  String surveyListStatusLabel(String status) {
    return 'Status: $status';
  }

  @override
  String get surveyListTitle => 'Surveys';

  @override
  String get surveyNumberQuestionHint => 'Enter a number';

  @override
  String get surveyOpenEndedHint => 'Enter your response';

  @override
  String get surveyPreviewAddQuestions =>
      'Add questions to see how your survey will look';

  @override
  String get surveyPreviewFooterNote =>
      'This is a preview. Responses are not saved.';

  @override
  String get surveyPreviewLabel => 'Survey Preview';

  @override
  String get surveyPreviewNoQuestions => 'No questions in this survey';

  @override
  String get surveyPreviewNote => 'This is a preview. Responses are not saved.';

  @override
  String surveyPreviewQuestionNumber(int number) {
    return 'Question $number';
  }

  @override
  String get surveyPreviewScaleHigh => 'High';

  @override
  String get surveyPreviewScaleLow => 'Low';

  @override
  String surveyPreviewUnsupportedType(String type) {
    return 'Unsupported question type: $type';
  }

  @override
  String get surveyPublishButton => 'Publish';

  @override
  String get surveyPublishedSuccess => 'Survey published successfully';

  @override
  String surveyPublishFailed(String error) {
    return 'Failed to publish: $error';
  }

  @override
  String get surveyPublishMessage =>
      'Once published, the survey will be available for assignment. Are you sure you want to publish?';

  @override
  String get surveyPublishTitle => 'Publish Survey';

  @override
  String get surveyStatusAssignedTotal => 'Assigned Total';

  @override
  String get surveyStatusAssignmentAnalytics => 'Assignment Analytics';

  @override
  String get surveyStatusChartTitle => 'Assignment Status Breakdown';

  @override
  String get surveyStatusClosed => 'Closed';

  @override
  String get surveyStatusDraft => 'Draft';

  @override
  String get surveyStatusEndDate => 'End Date';

  @override
  String get surveyStatusNoDate => 'Not set';

  @override
  String get surveyStatusPageTitle => 'Survey Status';

  @override
  String get surveyStatusPublished => 'Published';

  @override
  String get surveyStatusStartDate => 'Start Date';

  @override
  String get surveySubmitErrorAlreadySubmitted =>
      'You have already completed this survey.';

  @override
  String get surveySubmitErrorExpired =>
      'This survey has expired and can no longer be submitted.';

  @override
  String get surveySubmitErrorGeneral =>
      'Failed to submit survey. Please try again.';

  @override
  String get surveySubmitErrorNotAssigned =>
      'You are not assigned to this survey.';

  @override
  String get surveySubmitErrorNotFound => 'Survey not found.';

  @override
  String get surveySubmitErrorNotPublished =>
      'This survey is no longer accepting responses.';

  @override
  String get surveySubmitErrorServer =>
      'A server error occurred. Please try again later.';

  @override
  String get surveySubmitSuccess => 'Survey submitted successfully!';

  @override
  String get surveyTakingBackToSurveys => 'Back to surveys';

  @override
  String get surveyTakingCancel => 'Cancel';

  @override
  String get surveyTakingClosed =>
      'This survey is no longer accepting responses.';

  @override
  String get surveyTakingConfirmSubmitMessage =>
      'You will not be able to edit your answers after submission.';

  @override
  String get surveyTakingConfirmSubmitTitle => 'Submit survey?';

  @override
  String get surveyTakingExpired => 'This survey has expired.';

  @override
  String get surveyTakingLoadingQuestions => 'Loading questions...';

  @override
  String get surveyTakingNetworkError =>
      'Network error. Please check your connection and retry.';

  @override
  String surveyTakingProgress(int current, int total) {
    return '$current of $total';
  }

  @override
  String surveyTakingQuestionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
    );
    return '$_temp0';
  }

  @override
  String get surveyTakingRequired => '* Required';

  @override
  String get surveyTakingRequiredError => 'This question is required.';

  @override
  String get surveyTakingRetry => 'Retry';

  @override
  String get surveyTakingSubmit => 'Submit';

  @override
  String get surveyTakingSubmitting => 'Submitting...';

  @override
  String get surveyTakingTitle => 'Take Survey';

  @override
  String get surveyTakingValidationError =>
      'Please answer all required questions before submitting.';

  @override
  String questionBankAddCount(int count) {
    return 'Add ($count)';
  }

  @override
  String get questionBankAddQuestion => 'Add Question';

  @override
  String get questionBankAllCategories => 'All Categories';

  @override
  String get questionBankAllTypes => 'All Types';

  @override
  String get questionBankCategoryDemographics => 'Demographics';

  @override
  String questionBankCategoryLabel(String category) {
    return 'Category: $category';
  }

  @override
  String get questionBankCategoryLifestyle => 'Lifestyle';

  @override
  String get questionBankCategoryMentalHealth => 'Mental Health';

  @override
  String get questionBankCategoryPhysicalHealth => 'Physical Health';

  @override
  String get questionBankCategorySymptoms => 'Symptoms';

  @override
  String get questionBankClearAll => 'Clear All';

  @override
  String get questionBankClearFilters => 'Clear Filters';

  @override
  String questionBankDeleteConfirm(String title) {
    return 'Are you sure you want to delete \"$title\"?\n\nThis action cannot be undone.';
  }

  @override
  String get questionBankDeleted => 'Question deleted';

  @override
  String get questionBankDeleteTitle => 'Delete Question';

  @override
  String questionBankFailedToDelete(String error) {
    return 'Failed to delete: $error';
  }

  @override
  String questionBankFailedToDuplicate(String error) {
    return 'Failed to duplicate: $error';
  }

  @override
  String get questionBankFailedToLoad => 'Failed to load questions';

  @override
  String get questionBankFilterCategory => 'Category';

  @override
  String get questionBankFiltersLabel => 'Filters: ';

  @override
  String get questionBankFilterType => 'Type';

  @override
  String get questionBankNewQuestion => 'New Question';

  @override
  String get questionBankNoMatchFilters => 'No questions match your filters';

  @override
  String get questionBankNoQuestions => 'No questions yet';

  @override
  String get questionBankQuestionDeleted => 'Question deleted';

  @override
  String get questionBankQuestionDuplicated => 'Question duplicated';

  @override
  String questionBankSearchLabel(String query) {
    return 'Search: \"$query\"';
  }

  @override
  String get questionBankSearchPlaceholder => 'Search questions...';

  @override
  String get questionBankSelectQuestions => 'Select Questions';

  @override
  String get questionBankTitle => 'Question Bank';

  @override
  String questionBankTypeLabel(String type) {
    return 'Type: $type';
  }

  @override
  String get questionCardDelete => 'Delete';

  @override
  String get questionCardDuplicate => 'Duplicate';

  @override
  String get questionCardEdit => 'Edit';

  @override
  String get questionCardRequired => 'Required';

  @override
  String get questionCategoryGeneral => 'General';

  @override
  String get questionCategoryLifestyle => 'Lifestyle';

  @override
  String get questionCategoryMentalHealth => 'Mental Health';

  @override
  String get questionCategoryNutrition => 'Nutrition';

  @override
  String get questionCategoryOther => 'Other';

  @override
  String get questionCategoryPhysicalHealth => 'Physical Health';

  @override
  String get questionFormAddOption => 'Add Option';

  @override
  String get questionFormCategoryHint =>
      'e.g., Health, Lifestyle, Demographics';

  @override
  String get questionFormCategoryLabel => 'Category (optional)';

  @override
  String get questionFormCreate => 'Create';

  @override
  String get questionFormEditTitle => 'Edit Question';

  @override
  String get questionFormMinOptionsRequired => 'Minimum 2 options required';

  @override
  String get questionFormNewTitle => 'New Question';

  @override
  String questionFormOptionLabel(int number) {
    return 'Option $number';
  }

  @override
  String get questionFormOptionsLabel => 'Options *';

  @override
  String get questionFormProvideOptions => 'Please provide at least 2 options';

  @override
  String get questionFormQuestionHint => 'Enter the question text';

  @override
  String get questionFormQuestionLabel => 'Question *';

  @override
  String get questionFormQuestionRequired => 'Question text is required';

  @override
  String get questionFormRemoveOption => 'Remove option';

  @override
  String get questionFormRequiredLabel => 'Required';

  @override
  String get questionFormRequiredSubtitle =>
      'Participants must answer this question';

  @override
  String get questionFormScaleMax => 'Max';

  @override
  String get questionFormScaleMin => 'Min';

  @override
  String get questionFormScaleRange => 'Scale Range';

  @override
  String get questionFormTitleHint => 'Short descriptive title';

  @override
  String get questionFormTitleLabel => 'Title (optional)';

  @override
  String get questionFormTypeLabel => 'Question Type *';

  @override
  String get questionNo => 'No';

  @override
  String get questionTypeMultiChoice => 'Multiple Choice';

  @override
  String get questionTypeNumber => 'Number';

  @override
  String get questionTypeOpenEnded => 'Open Ended';

  @override
  String get questionTypeScale => 'Scale';

  @override
  String get questionTypeSingleChoice => 'Single Choice';

  @override
  String get questionTypeText => 'Text';

  @override
  String get questionTypeYesNo => 'Yes/No';

  @override
  String get questionYes => 'Yes';

  @override
  String get templateBuilderAddQuestions => 'Add Questions';

  @override
  String get templateBuilderAddQuestionsHint =>
      'Tap \"Add Questions\" to select from the question bank';

  @override
  String get templateBuilderBack => 'Back';

  @override
  String get templateBuilderCreatedSuccess => 'Template created successfully';

  @override
  String get templateBuilderDescriptionHint =>
      'Describe the purpose of this template';

  @override
  String get templateBuilderDescriptionLabel => 'Description (optional)';

  @override
  String get templateBuilderEditTitle => 'Edit Template';

  @override
  String get templateBuilderNewTitle => 'New Template';

  @override
  String get templateBuilderNoQuestions => 'No questions added yet';

  @override
  String get templateBuilderPublicLabel => 'Public Template';

  @override
  String get templateBuilderPublicSubtitle =>
      'Allow other researchers to use this template';

  @override
  String get templateBuilderQuestionOptionalSubtitle =>
      'This question will be optional in surveys created from this template.';

  @override
  String get templateBuilderQuestionRequiredSubtitle =>
      'This question must be answered in surveys created from this template.';

  @override
  String templateBuilderQuestionsCount(int count) {
    return 'Questions ($count)';
  }

  @override
  String get templateBuilderRemoveQuestion => 'Remove question';

  @override
  String get templateBuilderSave => 'Save';

  @override
  String get templateBuilderTitleHint => 'Enter a descriptive title';

  @override
  String get templateBuilderTitleLabel => 'Template Title *';

  @override
  String get templateBuilderTitleRequired => 'Title is required';

  @override
  String get templateBuilderUpdatedSuccess => 'Template updated successfully';

  @override
  String get templateCardCreateSurvey => 'Create Survey';

  @override
  String get templateCardDelete => 'Delete';

  @override
  String get templateCardDuplicate => 'Duplicate';

  @override
  String get templateCardEdit => 'Edit';

  @override
  String get templateCardPreview => 'Preview';

  @override
  String templateCardQuestionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
    );
    return '$_temp0';
  }

  @override
  String get templateListAllTemplates => 'All Templates';

  @override
  String get templateListClearAll => 'Clear All';

  @override
  String templateListCreateSurveyFrom(String title) {
    return 'Create survey from: $title';
  }

  @override
  String get templateListCreateTemplate => 'Create Template';

  @override
  String templateListDeleteConfirm(String title) {
    return 'Are you sure you want to delete \"$title\"?\n\nThis action cannot be undone.';
  }

  @override
  String get templateListDeleted => 'Template deleted';

  @override
  String get templateListDeleteTitle => 'Delete Template';

  @override
  String get templateListDuplicated => 'Template duplicated';

  @override
  String templateListFailedToDelete(String error) {
    return 'Failed to delete: $error';
  }

  @override
  String templateListFailedToDuplicate(String error) {
    return 'Failed to duplicate: $error';
  }

  @override
  String get templateListFailedToLoad => 'Failed to load templates';

  @override
  String templateListFailedToLoadTemplate(String error) {
    return 'Failed to load template: $error';
  }

  @override
  String get templateListFiltersLabel => 'Filters: ';

  @override
  String get templateListNewTemplate => 'New Template';

  @override
  String get templateListNoMatchFilters => 'No templates match your filters';

  @override
  String get templateListNoTemplates => 'No templates yet';

  @override
  String get templateListPrivate => 'Private';

  @override
  String get templateListPublic => 'Public';

  @override
  String get templateListSearchPlaceholder => 'Search templates...';

  @override
  String get templateListSelectTemplate => 'Select Template';

  @override
  String get templateListTitle => 'Templates';

  @override
  String get templateListVisibility => 'Visibility';

  @override
  String templateListVisibilityLabel(String visibility) {
    return 'Visibility: $visibility';
  }

  @override
  String get templatePreviewClose => 'Close';

  @override
  String get templatePreviewFooterNote =>
      'This is a preview. Responses are not saved.';

  @override
  String get templatePreviewNoQuestions => 'No questions in this template';

  @override
  String templatePreviewQuestionNumber(int number) {
    return 'Question $number';
  }

  @override
  String get templatePreviewScaleHigh => 'High';

  @override
  String get templatePreviewScaleLow => 'Low';

  @override
  String get templatePreviewSelectDate => 'Select date';

  @override
  String get templatePreviewSelectTime => 'Select time';

  @override
  String get templatePreviewTitle => 'Preview';

  @override
  String templatePreviewUnsupportedType(String type) {
    return 'Unsupported question type: $type';
  }

  @override
  String get researchAddFields => 'Add Fields';

  @override
  String get researchAllCategories => 'All Categories';

  @override
  String get researchAllTypes => 'All Types';

  @override
  String get researchAvailableQuestions => 'Available Data Fields';

  @override
  String get researchCompletionRate => 'Completion Rate';

  @override
  String get researchCrossAvgCompletion => 'Avg Completion';

  @override
  String get researchCrossDateFrom => 'From';

  @override
  String get researchCrossDateTo => 'To';

  @override
  String get researchCrossNoSurveysSelected =>
      'Use + Add Fields to select data, or filter by survey to browse';

  @override
  String get researchCrossSelectSurveys => 'Select surveys to pull data from';

  @override
  String researchCrossSuppressedSurveys(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count surveys',
      one: '1 survey',
    );
    return '$_temp0 excluded (fewer than 5 respondents)';
  }

  @override
  String get researchCrossSurveyColumn => 'Survey';

  @override
  String get researchCrossSurveysCount => 'Surveys';

  @override
  String get researchCrossTotalQuestions => 'Total Questions';

  @override
  String get researchCrossTotalRespondents => 'Total Respondents';

  @override
  String get researchDataBankAnalysis => 'Analysis';

  @override
  String get researchDataTitle => 'Research Data';

  @override
  String get researchDistribution => 'Distribution';

  @override
  String get researcherActiveSurveys => 'Active Surveys';

  @override
  String get researcherAddParticipant => 'Add Participant';

  @override
  String get researcherAssignSurvey => 'Assign Survey';

  @override
  String get researcherClosedSurveys => 'Closed Surveys';

  @override
  String get researcherCreateSurvey => 'Create Survey';

  @override
  String get researcherDashboardChartTitle1 => 'Recent Surveys';

  @override
  String get researcherDashboardChartTitle2 => 'Chart Title 2';

  @override
  String get researcherDashboardChartTitle3 => 'Chart Title 3';

  @override
  String get researcherDashboardChartTitle4 => 'Chart Title 4';

  @override
  String get researcherDashboardGraphPlaceholder => 'Graph placeholder';

  @override
  String get researcherDashboardGraphTitle1 => 'Survey Response counts';

  @override
  String get researcherDashboardGraphTitle2 => 'Survey Status Percentages';

  @override
  String get researcherDashboardKpiActiveSurveys => 'Active surveys';

  @override
  String get researcherDashboardKpiAvgCompletion => 'Avg completion';

  @override
  String get researcherDashboardKpiCompletedSurveys => 'Completed surveys';

  @override
  String get researcherDashboardKpiTotalRespondents => 'Total respondents';

  @override
  String get researcherDashboardPlaceholder =>
      'Researcher Dashboard\n(Placeholder)';

  @override
  String get researcherDashboardSectionTitle1 => 'Survey Statistics Overview';

  @override
  String get researcherDashboardSectionTitle2 => 'Section Title 2';

  @override
  String get researcherDataAnalytics => 'Data Analytics';

  @override
  String get researcherDraftSurveys => 'Draft Surveys';

  @override
  String get researcherEditSurvey => 'Edit Survey';

  @override
  String get researcherEnrolledParticipants => 'Enrolled Participants';

  @override
  String get researcherExportData => 'Export Data';

  @override
  String get researcherGenerateReport => 'Generate Report';

  @override
  String get researcherParticipantDetails => 'Participant Details';

  @override
  String get researcherParticipantList => 'Participant List';

  @override
  String get researcherParticipants => 'Participants';

  @override
  String get researcherPendingInvitations => 'Pending Invitations';

  @override
  String get researcherQuickActions => 'Quick Actions';

  @override
  String get researcherRecentActivity => 'Recent Activity';

  @override
  String get researcherSurveyDetails => 'Survey Details';

  @override
  String get researcherSurveyList => 'Survey List';

  @override
  String get researcherSurveyResponses => 'Survey Responses';

  @override
  String get researcherWelcomeBack => 'Welcome Back';

  @override
  String get researchExportCsv => 'Export CSV';

  @override
  String get researchFilterCategory => 'Category';

  @override
  String get researchFilterResponseType => 'Response Type';

  @override
  String get researchHistogram => 'Histogram';

  @override
  String get researchMean => 'Mean';

  @override
  String get researchMedian => 'Median';

  @override
  String get researchModeCrossSurvey => 'Data Bank';

  @override
  String get researchModeHealthTracking => 'Health Tracking';

  @override
  String get researchModeSingleSurvey => 'By Survey';

  @override
  String get researchNo => 'No';

  @override
  String get researchNoData => 'No response data available for this survey';

  @override
  String get researchNoSurveys => 'No surveys available';

  @override
  String get researchOpenEndedNote =>
      'Open-ended responses are not displayed for privacy';

  @override
  String get researchOptionCounts => 'Option Counts';

  @override
  String get researchQuestions => 'Questions';

  @override
  String get researchRange => 'Range';

  @override
  String get researchRespondents => 'Respondents';

  @override
  String researchResponses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count responses',
      one: '1 response',
    );
    return '$_temp0';
  }

  @override
  String get researchSearchQuestions => 'Search fields...';

  @override
  String get researchSelectAll => 'Select All';

  @override
  String researchSelectedFields(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fields selected',
      one: '1 field selected',
    );
    return '$_temp0';
  }

  @override
  String get researchSelectSurvey => 'Select a survey';

  @override
  String get researchStdDev => 'Std Dev';

  @override
  String researchSuppressed(int count) {
    return 'Insufficient responses (minimum $count required)';
  }

  @override
  String get researchTabAnalysis => 'Analysis';

  @override
  String get researchTabDataTable => 'Data Table';

  @override
  String get researchYes => 'Yes';

  @override
  String get hcpActiveClients => 'Active Clients';

  @override
  String get hcpAddClient => 'Add Client';

  @override
  String get hcpAllPatients => 'All Patients';

  @override
  String get hcpAssignSurvey => 'Assign Survey';

  @override
  String get hcpClientDetails => 'Client Details';

  @override
  String get hcpClientList => 'Client List';

  @override
  String get hcpClientReports => 'Client Reports';

  @override
  String get hcpClients => 'Clients';

  @override
  String get hcpClientSurveys => 'Client Surveys';

  @override
  String get hcpDashboardLinkedPatients => 'Linked Patients';

  @override
  String get hcpDashboardNoActivity => 'No recent activity.';

  @override
  String get hcpDashboardPendingRequests => 'Pending Requests';

  @override
  String get hcpDashboardTitle => 'HCP Dashboard';

  @override
  String hcpDashboardWelcome(String name) {
    return 'Welcome, $name';
  }

  @override
  String get hcpGenerateReport => 'Generate Report';

  @override
  String get hcpHealthSummary => 'Health Summary';

  @override
  String get hcpHtAggregateSeries => 'Population avg.';

  @override
  String get hcpHtAggregateUnavailable =>
      'Population comparison unavailable (insufficient data).';

  @override
  String get hcpHtChartTypeBar => 'Bar';

  @override
  String get hcpHtChartTypeLabel => 'Chart type';

  @override
  String get hcpHtChartTypeLine => 'Line';

  @override
  String get hcpHtChartTypePie => 'Pie';

  @override
  String get hcpHtClearAll => 'Clear all';

  @override
  String get hcpHtExportCsv => 'Export Patient Data (CSV)';

  @override
  String get hcpHtFilters => 'Filters';

  @override
  String get hcpHtHideFilters => 'Hide filters';

  @override
  String get hcpHtLoadCharts => 'Load Charts';

  @override
  String get hcpHtLoadError => 'Failed to load health tracking data.';

  @override
  String hcpHtNMetricsSelected(int count) {
    return '$count selected';
  }

  @override
  String get hcpHtNoEntries =>
      'This patient has no health tracking entries for the selected filters.';

  @override
  String get hcpHtNoEntriesForMetric =>
      'No entries recorded for this metric in the selected period.';

  @override
  String get hcpHtNoMetrics => 'No health tracking metrics are configured.';

  @override
  String get hcpHtPatientSeries => 'Patient';

  @override
  String get hcpHtSelectAll => 'Select all';

  @override
  String get hcpHtSelectMetrics => 'Select metrics';

  @override
  String get hcpHtSelectMetricsHint =>
      'Select at least one metric to load charts.';

  @override
  String get hcpHtSelectPatientFirst =>
      'Select a patient above to view their health tracking data.';

  @override
  String get hcpHtShowFilters => 'Show filters';

  @override
  String get hcpHtViewComparison => 'Comparison';

  @override
  String get hcpHtViewMode => 'View mode';

  @override
  String get hcpHtViewModeLabel =>
      'View mode: patient only or comparison with population';

  @override
  String get hcpHtViewPatient => 'Patient Only';

  @override
  String get hcpLinkEnterPatientEmail => 'Patient email address';

  @override
  String get hcpLinkEnterPatientId => 'Enter Patient Account ID';

  @override
  String get hcpLinkErrorDuplicate =>
      'A link request already exists for this patient.';

  @override
  String get hcpLinkErrorGeneral => 'Failed to send request. Please try again.';

  @override
  String get hcpLinkErrorNotFound => 'Patient account not found.';

  @override
  String hcpLinkLinkedSince(String date) {
    return 'Linked since $date';
  }

  @override
  String get hcpLinkMyPatients => 'Linked Patients';

  @override
  String get hcpLinkNoPatients => 'No linked patients yet.';

  @override
  String get hcpLinkNoPending => 'No pending requests.';

  @override
  String get hcpLinkPageTitle => 'My Patients';

  @override
  String get hcpLinkPatientEmailHint => 'e.g. john.smith@email.com';

  @override
  String hcpLinkPendingFrom(String date) {
    return 'Requested $date';
  }

  @override
  String get hcpLinkPendingRequests => 'Pending Requests';

  @override
  String get hcpLinkRemove => 'Remove';

  @override
  String get hcpLinkRemoveConfirm => 'Remove this patient link?';

  @override
  String get hcpLinkRequestPatient => 'Request Patient Link';

  @override
  String get hcpLinkRequestSent => 'Link request sent';

  @override
  String get hcpPatientConsentRevoked => 'Consent Revoked';

  @override
  String hcpPatientLinkedSince(String date) {
    return 'Linked since $date';
  }

  @override
  String get hcpPatientNoSurveys => 'No completed surveys.';

  @override
  String get hcpPatientSurveysTitle => 'Completed Surveys';

  @override
  String get hcpPatientViewSurveys => 'View Surveys';

  @override
  String get hcpReportsError => 'Failed to load report data.';

  @override
  String get hcpReportsLoading => 'Loading report...';

  @override
  String get hcpReportsNoPatients => 'No linked patients to report on.';

  @override
  String get hcpReportsNoSelection =>
      'Select a patient and survey to view the report.';

  @override
  String get hcpReportsNoSurveys => 'This patient has no completed surveys.';

  @override
  String get hcpReportsSelectPatient => 'Select a Patient';

  @override
  String get hcpReportsSelectSurvey => 'Select a Survey';

  @override
  String get hcpReportsTabHealthTracking => 'Health Tracking';

  @override
  String get hcpReportsTabSurveys => 'Surveys';

  @override
  String get hcpReportsTitle => 'Patient Reports';

  @override
  String get hcpSurveyChartAggregate => 'Population avg.';

  @override
  String get hcpSurveyChartAggUnavailable =>
      'Population comparison unavailable (insufficient data).';

  @override
  String get hcpSurveyChartComparison => 'Comparison';

  @override
  String get hcpSurveyChartComparisonModeLabel => 'Chart comparison mode';

  @override
  String get hcpSurveyChartNoNumeric =>
      'No numeric or scale questions in this survey to chart.';

  @override
  String get hcpSurveyChartPatient => 'Patient';

  @override
  String get hcpSurveyChartPatientOnly => 'Patient Only';

  @override
  String hcpSurveyChartTitle(String surveyTitle) {
    return 'Survey Results — $surveyTitle';
  }

  @override
  String get hcpSurveyHistory => 'Survey History';

  @override
  String get hcpSurveyViewChart => 'Charts';

  @override
  String get hcpSurveyViewModeLabel => 'View mode: responses table or charts';

  @override
  String get hcpSurveyViewTable => 'Responses';

  @override
  String get hcpTodaySchedule => 'Today\'s Schedule';

  @override
  String get hcpUnknown => 'Unknown HCP';

  @override
  String get hcpUpcomingAppointments => 'Upcoming Appointments';

  @override
  String get hcpWelcomeBack => 'Welcome Back';

  @override
  String get messagesComingSoon => 'Messages management coming soon...';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get messagingAcceptRequest => 'Accept';

  @override
  String get messagingAddColleague => 'Add';

  @override
  String get messagingAdminAccountIdHint => 'Enter numeric account ID';

  @override
  String get messagingAdminAccountIdLabel => 'Account ID';

  @override
  String get messagingBrowseColleagues => 'Browse Colleagues';

  @override
  String get messagingBrowseColleaguesSubtitle =>
      'Add researchers from your institution';

  @override
  String get messagingColleagueAdded => 'Contact request sent';

  @override
  String get messagingColleagueAddError => 'Could not send request';

  @override
  String get messagingColleagueRequestSent => 'Request sent';

  @override
  String get messagingContacts => 'Contacts';

  @override
  String get messagingContactsTitle => 'My Contacts';

  @override
  String get messagingConversationTitle => 'Conversation';

  @override
  String get messagingDeleteContact => 'Delete contact';

  @override
  String get messagingDeleteContactConfirm =>
      'Remove this contact? You can re-add them later.';

  @override
  String get messagingDeleteMessage => 'Delete message';

  @override
  String get messagingDeleteMessageConfirm =>
      'Are you sure you want to delete this message?';

  @override
  String get messagingEditContact => 'Edit contact';

  @override
  String get messagingEmailHint =>
      'Enter email address to start a conversation';

  @override
  String get messagingEmailLabel => 'Email address';

  @override
  String get messagingEmailNotFound => 'No account found for that email';

  @override
  String get messagingEmailPermission =>
      'You are not allowed to message this user';

  @override
  String get messagingError => 'Failed to load messages.';

  @override
  String get messagingFriendAccepted => 'Contact request accepted';

  @override
  String get messagingFriendDeclined => 'Contact request declined';

  @override
  String get messagingFriendEmailHint => 'contact@example.com';

  @override
  String get messagingFriendRequestEmail => 'Contact\'s email address';

  @override
  String get messagingFriendRequestError =>
      'Failed to send request. Please try again.';

  @override
  String get messagingFriendRequestSend => 'Send Contact Request';

  @override
  String get messagingFriendRequestSent =>
      'If this user exists, a contact request will be sent.';

  @override
  String get messagingFriendRequestTitle => 'Add a Contact';

  @override
  String get messagingInboxTitle => 'Messages';

  @override
  String get messagingIncomingRequests => 'Contact Requests';

  @override
  String get messagingJustNow => 'Just now';

  @override
  String get messagingLastMessage => 'Last message';

  @override
  String get messagingLoading => 'Loading messages...';

  @override
  String get messagingMessagePlaceholder => 'Type a message...';

  @override
  String get messagingNewConversationTitle => 'New Conversation';

  @override
  String get messagingNoColleaguesFound => 'No researchers found';

  @override
  String get messagingNoContacts =>
      'No contacts yet. Add a contact to start messaging.';

  @override
  String get messagingNoConversations => 'No conversations yet.';

  @override
  String get messagingNoIncomingRequests => 'No pending contact requests.';

  @override
  String get messagingNoMessages => 'No messages yet. Say hello!';

  @override
  String get messagingNoRecipients => 'No available recipients.';

  @override
  String messagingOpenConversationWith(String name) {
    return 'Open conversation with $name';
  }

  @override
  String get messagingOrPickFromContacts => 'Or pick from your contacts';

  @override
  String get messagingOrPickFromPatients => 'Or pick from your patients';

  @override
  String get messagingRecipientFriend => 'My Contacts';

  @override
  String get messagingRecipientHcp => 'My Healthcare Provider';

  @override
  String get messagingRecipientPatient => 'A Patient';

  @override
  String get messagingRecipientResearcher => 'Researchers';

  @override
  String get messagingRejectRequest => 'Decline';

  @override
  String get messagingSearchColleagues => 'Search by name...';

  @override
  String get messagingSearchMinChars =>
      'Enter at least 2 characters to search.';

  @override
  String get messagingSearchResearchers => 'Search researchers...';

  @override
  String get messagingSelectConversation =>
      'Select a conversation to start messaging';

  @override
  String get messagingSelectRecipient => 'Select a recipient';

  @override
  String get messagingSend => 'Send';

  @override
  String get messagingSendError => 'Failed to send message. Please try again.';

  @override
  String get messagingSending => 'Sending...';

  @override
  String get messagingStartConversation => 'New Message';

  @override
  String messagingUnreadBadge(int count) {
    return '$count unread';
  }

  @override
  String get messagingYou => 'You';

  @override
  String get ticketPriorityHigh => 'High';

  @override
  String get ticketPriorityLow => 'Low';

  @override
  String get ticketPriorityMedium => 'Medium';

  @override
  String get ticketsColumnCreated => 'Created';

  @override
  String get ticketsColumnId => 'ID';

  @override
  String get ticketsColumnPriority => 'Priority';

  @override
  String get ticketsColumnStatus => 'Status';

  @override
  String get ticketsColumnSubject => 'Subject';

  @override
  String get ticketStatusClosed => 'Closed';

  @override
  String get ticketStatusOpen => 'Open';

  @override
  String get ticketStatusPending => 'Pending';

  @override
  String get ticketsTitle => 'Support Tickets';

  @override
  String get adminAccountRequests => 'Account Requests';

  @override
  String get adminAccountRequestsApprove => 'Approve';

  @override
  String get adminAccountRequestsApproveConfirm =>
      'Are you sure you want to approve this account request? An account will be created and the user will receive an email with their login credentials.';

  @override
  String get adminAccountRequestsApproved => 'Approved';

  @override
  String get adminAccountRequestsApproved_msg =>
      'Account request approved successfully';

  @override
  String get adminAccountRequestsDate => 'Submitted';

  @override
  String get adminAccountRequestsEmail => 'Email';

  @override
  String get adminAccountRequestsEmpty => 'No account requests found';

  @override
  String get adminAccountRequestsLoadError => 'Error loading account requests';

  @override
  String get adminAccountRequestsName => 'Name';

  @override
  String get adminAccountRequestsPending => 'Pending';

  @override
  String get adminAccountRequestsReject => 'Reject';

  @override
  String get adminAccountRequestsRejectConfirm =>
      'Are you sure you want to reject this account request?';

  @override
  String get adminAccountRequestsRejected => 'Rejected';

  @override
  String get adminAccountRequestsRejected_msg => 'Account request rejected';

  @override
  String get adminAccountRequestsRejectNotes => 'Rejection notes (optional)';

  @override
  String get adminAccountRequestsRole => 'Role';

  @override
  String get adminAccountStatus => 'Account Status';

  @override
  String get adminAddUser => 'Add User';

  @override
  String get adminAddUserDateOfBirth => 'Date of Birth (optional)';

  @override
  String get adminAddUserGender => 'Gender (optional)';

  @override
  String get adminAddUserParticipantOptionals =>
      'Participant details (optional)';

  @override
  String get adminAddUserSendSetupEmail => 'Send account setup email';

  @override
  String get adminAddUserSendSetupEmailHint =>
      'A temporary password will be generated and emailed to the user';

  @override
  String get adminAssignTicket => 'Assign Ticket';

  @override
  String get adminAuditLog => 'Audit Log';

  @override
  String get adminBackToAdmin => 'Back to Admin';

  @override
  String get adminBackupDatabase => 'Backup Database';

  @override
  String get adminClosedTickets => 'Closed Tickets';

  @override
  String get adminCloseTicket => 'Close Ticket';

  @override
  String get adminCompose => 'Compose';

  @override
  String get adminDashboardAccountRequests => 'Account Requests';

  @override
  String adminDashboardActiveUsersDetail(int count) {
    return '$count active users';
  }

  @override
  String get adminDashboardAdminV2Preview => 'Admin v2 Preview';

  @override
  String get adminDashboardAuditLog => 'Audit Log';

  @override
  String get adminDashboardBackupAgo => 'ago';

  @override
  String get adminDashboardBackupNone => 'No backups';

  @override
  String get adminDashboardDatabaseViewer => 'Database Viewer';

  @override
  String adminDashboardDraftCount(int count) {
    return '$count drafts';
  }

  @override
  String get adminDashboardFailedToLoad => 'Failed to load dashboard';

  @override
  String get adminDashboardKpiActiveSurveys => 'Active Surveys';

  @override
  String get adminDashboardKpiDraftSurveys => 'Draft Surveys';

  @override
  String get adminDashboardKpiLatestBackup => 'Latest Backup';

  @override
  String get adminDashboardKpiNew30d => 'New (30 days)';

  @override
  String get adminDashboardKpiPendingDeletions => 'Pending Deletions';

  @override
  String get adminDashboardKpiPendingRequests => 'Pending Requests';

  @override
  String get adminDashboardKpiResponses => 'Responses';

  @override
  String get adminDashboardKpiTotalResponses => 'Total Responses';

  @override
  String get adminDashboardKpiTotalUsers => 'Total Users';

  @override
  String get adminDashboardManageUsers => 'Manage Users';

  @override
  String adminDashboardNewIn30Days(int count) {
    return '$count new in 30 days';
  }

  @override
  String get adminDashboardNoActivity => 'No recent activity';

  @override
  String get adminDashboardNoPendingRequests => 'No pending requests';

  @override
  String get adminDashboardNoUsers => 'No users yet';

  @override
  String adminDashboardPendingAccountAlert(int count) {
    return '$count pending account requests awaiting approval';
  }

  @override
  String get adminDashboardPendingAccountRequests => 'Pending Account Requests';

  @override
  String adminDashboardPendingDeletionAlert(int count) {
    return '$count pending deletion requests';
  }

  @override
  String get adminDashboardPendingDeletionRequests =>
      'Pending Deletion Requests';

  @override
  String get adminDashboardQuickLinks => 'Quick Links';

  @override
  String get adminDashboardRecentLogins => 'Recent Logins';

  @override
  String adminDashboardRequestsPending(int count) {
    return '$count requests pending';
  }

  @override
  String get adminDashboardTitle => 'Admin Dashboard';

  @override
  String adminDashboardTotalSurveysSubtitle(int total) {
    return '$total total';
  }

  @override
  String adminDashboardTotalUsersSubtitle(int total) {
    return '$total total (incl. inactive)';
  }

  @override
  String get adminDashboardUiTestPage => 'UI Test Page';

  @override
  String get adminDashboardUserDistribution => 'User Distribution';

  @override
  String get adminDashboardUserDistributionByRole =>
      'User Distribution by Role';

  @override
  String get adminDashboardUserRoles => 'User Roles';

  @override
  String get adminDatabase => 'Database';

  @override
  String get adminDatabaseStatus => 'Database Status';

  @override
  String get adminDeleteUser => 'Delete User';

  @override
  String adminDeletionConfirmContent(String name) {
    return 'This will permanently delete $name\'s account. Their survey response data will be retained anonymously. This action cannot be undone.';
  }

  @override
  String get adminDeletionConfirmTitle => 'Delete Account Permanently';

  @override
  String adminDeletionError(String error) {
    return 'Failed to delete account: $error';
  }

  @override
  String get adminDeletionNoUsers => 'No users found.';

  @override
  String get adminDeletionRequestsApprove => 'Approve Deletion';

  @override
  String get adminDeletionRequestsApproveConfirm =>
      'This will permanently delete the user\'s account. Their survey data will be retained anonymously. This cannot be undone.';

  @override
  String get adminDeletionRequestsApproved_msg =>
      'Account permanently deleted.';

  @override
  String get adminDeletionRequestsEmpty => 'No deletion requests found.';

  @override
  String get adminDeletionRequestsLoadError =>
      'Error loading deletion requests';

  @override
  String adminDeletionRequestsPendingAlert(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'requests',
      one: 'request',
    );
    return '$count account deletion $_temp0 awaiting review';
  }

  @override
  String get adminDeletionRequestsReject => 'Reject';

  @override
  String get adminDeletionRequestsRejectConfirm =>
      'The deletion request will be rejected and the account will be reactivated.';

  @override
  String get adminDeletionRequestsRejected_msg =>
      'Deletion request rejected — account reactivated.';

  @override
  String get adminDeletionRequestsRejectNotes =>
      'Reason for rejection (optional)';

  @override
  String get adminDeletionRequestsRequested => 'Requested';

  @override
  String get adminDeletionRequestsTab => 'Deletion Requests';

  @override
  String get adminDeletionSelfForbidden =>
      'You cannot delete your own account.';

  @override
  String get adminDeletionSubtitle =>
      'Permanently delete user accounts. Survey response data is preserved anonymously.';

  @override
  String get adminDeletionSuccess => 'Account deleted successfully.';

  @override
  String get adminDeletionTitle => 'User Deletion';

  @override
  String get adminDisableAccount => 'Disable Account';

  @override
  String get adminEditUser => 'Edit User';

  @override
  String get adminEmailLabel => 'Email';

  @override
  String get adminEnableAccount => 'Enable Account';

  @override
  String get adminEndViewAsError => 'Failed to end view-as';

  @override
  String get adminEnglish => 'EN';

  @override
  String get adminExportLogs => 'Export Logs';

  @override
  String get adminFilterByAction => 'Filter by Action';

  @override
  String get adminFilterByDate => 'Filter by Date';

  @override
  String get adminFilterByRoleLabel => 'Filter by Role';

  @override
  String get adminFilterByUser => 'Filter by User';

  @override
  String get adminFirstNameLabel => 'First Name';

  @override
  String get adminFrench => 'FR';

  @override
  String get adminHealthTrackingActiveLabel => 'Active';

  @override
  String get adminHealthTrackingAddCategory => 'Add Category';

  @override
  String get adminHealthTrackingAddMetric => 'Add Metric';

  @override
  String get adminHealthTrackingAddOption => 'Add Option';

  @override
  String get adminHealthTrackingBaselineBadge => 'Baseline';

  @override
  String get adminHealthTrackingBaselineLabel => 'Include in baseline snapshot';

  @override
  String get adminHealthTrackingCategoriesSection => 'Categories & Metrics';

  @override
  String adminHealthTrackingChoiceOptionLabel(int index) {
    return 'Option $index';
  }

  @override
  String get adminHealthTrackingChoiceOptionsLabel => 'Choice Options';

  @override
  String get adminHealthTrackingDeleteCategoryConfirm =>
      'Delete this category and all its metrics? This cannot be undone.';

  @override
  String adminHealthTrackingDeleteCategoryMessage(String name) {
    return 'Remove \"$name\" and all its metrics? Existing participant data is preserved.';
  }

  @override
  String get adminHealthTrackingDeleteCategoryTitle => 'Remove Category';

  @override
  String get adminHealthTrackingDeleteMetricConfirm =>
      'Delete this metric? This cannot be undone.';

  @override
  String adminHealthTrackingDeleteMetricMessage(String name) {
    return 'Remove \"$name\"? Existing participant data is preserved.';
  }

  @override
  String get adminHealthTrackingDeleteMetricTitle => 'Remove Metric';

  @override
  String get adminHealthTrackingDescriptionLabel => 'Description';

  @override
  String get adminHealthTrackingDragToReorder => 'Drag to reorder';

  @override
  String get adminHealthTrackingEditCategory => 'Edit Category';

  @override
  String get adminHealthTrackingEditMetric => 'Edit Metric';

  @override
  String get adminHealthTrackingFreqAny => 'Any';

  @override
  String get adminHealthTrackingFreqDaily => 'Daily';

  @override
  String get adminHealthTrackingFreqMonthly => 'Monthly';

  @override
  String get adminHealthTrackingFrequencyLabel => 'Frequency';

  @override
  String get adminHealthTrackingFreqWeekly => 'Weekly';

  @override
  String adminHealthTrackingInactiveCategories(int count) {
    return 'Inactive Categories ($count)';
  }

  @override
  String get adminHealthTrackingInactiveLabel => 'Inactive';

  @override
  String adminHealthTrackingInactiveMetrics(int count) {
    return 'Inactive Questions ($count)';
  }

  @override
  String get adminHealthTrackingNameLabel => 'Name';

  @override
  String get adminHealthTrackingNoCategories => 'No categories configured yet.';

  @override
  String get adminHealthTrackingNoMetrics => 'No metrics in this category.';

  @override
  String adminHealthTrackingRemovedCategories(int count) {
    return 'Removed Categories ($count)';
  }

  @override
  String adminHealthTrackingRemovedMetrics(int count) {
    return 'Removed Questions ($count)';
  }

  @override
  String get adminHealthTrackingRestore => 'Restore';

  @override
  String get adminHealthTrackingSaved => 'Saved successfully.';

  @override
  String adminHealthTrackingSaveError(String error) {
    return 'Save failed: $error';
  }

  @override
  String get adminHealthTrackingScaleMaxLabel => 'Scale Max';

  @override
  String get adminHealthTrackingScaleMinLabel => 'Scale Min';

  @override
  String get adminHealthTrackingSubtitle =>
      'Configure the categories and metrics that participants track daily.';

  @override
  String get adminHealthTrackingTitle => 'Health Tracking Settings';

  @override
  String get adminHealthTrackingToggleCategoryActive =>
      'Toggle category active/inactive';

  @override
  String get adminHealthTrackingTypeLabel => 'Metric Type';

  @override
  String get adminHealthTrackingTypeNumber => 'Number';

  @override
  String get adminHealthTrackingTypeScale => 'Scale';

  @override
  String get adminHealthTrackingTypeSingleChoice => 'Single Choice';

  @override
  String get adminHealthTrackingTypeText => 'Text';

  @override
  String get adminHealthTrackingTypeYesno => 'Yes / No';

  @override
  String get adminHealthTrackingUnitLabel => 'Unit (optional)';

  @override
  String get adminInbox => 'Inbox';

  @override
  String get adminLanguage => 'Language';

  @override
  String get adminLastNameLabel => 'Last Name';

  @override
  String adminLoggedInAs(String name) {
    return 'Logged in as: $name';
  }

  @override
  String get adminLoggedInAsLabel => 'Logged in as:';

  @override
  String get adminMessages => 'Messages';

  @override
  String get adminNavGroupAdmin => 'Admin';

  @override
  String get adminNavGroupHealthcareProvider => 'Healthcare Provider';

  @override
  String get adminNavGroupParticipant => 'Participant';

  @override
  String get adminNavGroupPublicAuth => 'Public / Auth';

  @override
  String get adminNavGroupResearcher => 'Researcher';

  @override
  String get adminNavGroupShared => 'Shared';

  @override
  String get adminNavHubSubtitle => 'Navigate to any page in the application';

  @override
  String get adminNavHubTitle => 'Page Navigator';

  @override
  String get adminNewAccountRequestsTab => 'New Account Requests';

  @override
  String get adminOpenTickets => 'Open Tickets';

  @override
  String get adminPasswordLabel => 'Password';

  @override
  String get adminResetPassword => 'Reset Password';

  @override
  String get adminRestoreDatabase => 'Restore Database';

  @override
  String get adminReturnedToDashboard => 'Returned to admin dashboard';

  @override
  String get adminReturning => 'Returning...';

  @override
  String get adminRoleLabel => 'Role';

  @override
  String get adminSent => 'Sent';

  @override
  String get adminSettingsConsentRequiredDescription =>
      'When on, users must sign the consent form before accessing the app. Disable only if consent is not required in your deployment jurisdiction.';

  @override
  String get adminSettingsConsentRequiredLabel => 'Require User Consent';

  @override
  String adminSettingsDefaultBadge(String value) {
    return 'Default: $value';
  }

  @override
  String get adminSettingsKDescription =>
      'Minimum distinct respondents required before survey data is exposed to researchers. Set to 1 to allow any data. Default: 5.';

  @override
  String get adminSettingsKFieldLabel => 'Minimum Respondents (K)';

  @override
  String get adminSettingsKHint => 'e.g. 5';

  @override
  String get adminSettingsKLabel => 'K-Anonymity Threshold';

  @override
  String get adminSettingsLockoutDescription =>
      'How long an account stays locked after exceeding the failed-login limit. Default: 30 minutes.';

  @override
  String get adminSettingsLockoutFieldLabel => 'Lockout Duration (min)';

  @override
  String get adminSettingsLockoutHint => 'e.g. 30';

  @override
  String get adminSettingsLockoutLabel => 'Lockout Duration (minutes)';

  @override
  String get adminSettingsMaintenanceCompletionDescription =>
      'Estimated time when the system will be back online. Shown in the maintenance banner on all pages.';

  @override
  String get adminSettingsMaintenanceCompletionHint => 'e.g. 5:00 PM EST';

  @override
  String get adminSettingsMaintenanceCompletionLabel =>
      'Expected Completion Time';

  @override
  String get adminSettingsMaintenanceDescription =>
      'When on, non-admin users cannot log in. A banner is shown on the login page. Admins can still log in and access the dashboard.';

  @override
  String get adminSettingsMaintenanceLabel => 'Maintenance Mode';

  @override
  String get adminSettingsMaintenanceMessageDescription =>
      'Optional message shown in the login banner during maintenance. Include expected return time.';

  @override
  String get adminSettingsMaintenanceMessageHint =>
      'e.g. Back online by 5:00 PM EST';

  @override
  String get adminSettingsMaintenanceMessageLabel => 'Maintenance Message';

  @override
  String get adminSettingsMaxAttemptsDescription =>
      'Consecutive failed logins before the account is temporarily locked. Set to 0 for no limit. Default: 10.';

  @override
  String get adminSettingsMaxAttemptsFieldLabel =>
      'Max Attempts (0 = unlimited)';

  @override
  String get adminSettingsMaxAttemptsHint => 'e.g. 10';

  @override
  String get adminSettingsMaxAttemptsLabel => 'Max Failed Login Attempts';

  @override
  String get adminSettingsRegistrationDescription =>
      'When off, new account requests are blocked. Useful during enrollment freezes.';

  @override
  String get adminSettingsRegistrationLabel => 'Registration Open';

  @override
  String get adminSettingsResetToDefault => 'Reset to Default';

  @override
  String get adminSettingsSaveButton => 'Save Changes';

  @override
  String get adminSettingsSaveError => 'Failed to save settings.';

  @override
  String get adminSettingsSaveSuccess => 'Settings saved successfully.';

  @override
  String get adminSettingsSaving => 'Saving…';

  @override
  String get adminSettingsSectionPrivacy => 'Data Privacy';

  @override
  String get adminSettingsSectionSecurity => 'Login Security';

  @override
  String get adminSettingsSectionSystem => 'System';

  @override
  String get adminSettingsSidebarLabel => 'Settings';

  @override
  String get adminSettingsTitle => 'System Settings';

  @override
  String get adminSettingsValidationNonNegative => 'Must be 0 or greater.';

  @override
  String get adminSettingsValidationPositive =>
      'Must be a positive whole number.';

  @override
  String get adminSpanish => 'ES';

  @override
  String get adminTicketDetails => 'Ticket Details';

  @override
  String get adminTickets => 'Tickets';

  @override
  String get adminUiTestSectionBasics => 'Basics';

  @override
  String get adminUiTestSectionButtons => 'Buttons';

  @override
  String get adminUiTestSectionDataDisplay => 'Data Display';

  @override
  String get adminUiTestSectionFeedback => 'Feedback';

  @override
  String get adminUiTestSectionForms => 'Forms and Input';

  @override
  String get adminUiTestSectionMicroWidgets => 'Micro Widgets';

  @override
  String get adminUserDetails => 'User Details';

  @override
  String get adminUserList => 'User List';

  @override
  String get adminUserManagement => 'User Management';

  @override
  String get adminUserRole => 'User Role';

  @override
  String get adminV2LatestSignIns => 'Latest sign-ins across the system';

  @override
  String get adminV2NoUserData => 'No user data available yet.';

  @override
  String get adminV2OpenClassicAdmin => 'Open classic admin';

  @override
  String get adminV2QuickAuditLog => 'Audit Log';

  @override
  String get adminV2QuickDatabase => 'Database';

  @override
  String get adminV2QuickLinks => 'Quick links';

  @override
  String get adminV2QuickNavigator => 'Navigator';

  @override
  String get adminV2QuickRequests => 'Requests';

  @override
  String get adminV2QuickUiTest => 'UI Test';

  @override
  String get adminV2QuickUsers => 'Users';

  @override
  String get adminV2RecentActivity => 'Recent activity';

  @override
  String get adminV2RoleDistributionTitle => 'User distribution';

  @override
  String get adminV2RoleMixSubtitle => 'Role mix across the platform';

  @override
  String get adminV2Subtitle =>
      'A quieter, flatter dashboard preview based on the new design direction. The existing admin remains unchanged.';

  @override
  String get adminV2Title => 'Admin v2';

  @override
  String get adminViewAsLabel => 'View As';

  @override
  String adminViewingAsRole(String role) {
    return 'Viewing as $role';
  }

  @override
  String adminViewingAsUser(String name, String email) {
    return 'Viewing as $name ($email)';
  }

  @override
  String get adminViewLogs => 'View Logs';

  @override
  String get adminWelcomeMessage =>
      'Welcome to the admin dashboard. Select an option from the sidebar.';

  @override
  String get auditLogAction => 'Action';

  @override
  String get auditLogActorId => 'Actor ID';

  @override
  String get auditLogActorType => 'Actor Type';

  @override
  String get auditLogAllActions => 'All Actions';

  @override
  String get auditLogAllMethods => 'All Methods';

  @override
  String get auditLogAllResources => 'All Resources';

  @override
  String get auditLogAllStatuses => 'All Statuses';

  @override
  String get auditLogColumnAction => 'Action';

  @override
  String get auditLogColumnActor => 'Actor';

  @override
  String get auditLogColumnMethod => 'Method';

  @override
  String get auditLogColumnPath => 'Path';

  @override
  String get auditLogColumnStatus => 'Status';

  @override
  String get auditLogColumnTimestamp => 'Timestamp';

  @override
  String get auditLogDenied => 'Denied';

  @override
  String get auditLogErrorCode => 'Error Code';

  @override
  String get auditLogEventId => 'Event ID';

  @override
  String get auditLogExportCsv => 'Export as CSV';

  @override
  String get auditLogFailedToLoad => 'Failed to load audit logs';

  @override
  String get auditLogFailure => 'Failure';

  @override
  String get auditLogHttpMethod => 'HTTP Method';

  @override
  String get auditLogHttpStatus => 'HTTP Status';

  @override
  String get auditLogIpAddress => 'IP Address';

  @override
  String get auditLogMetadata => 'Metadata';

  @override
  String get auditLogNextPage => 'Next page';

  @override
  String get auditLogNoEvents => 'No audit events found';

  @override
  String auditLogPageOf(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get auditLogPreviousPage => 'Previous page';

  @override
  String get auditLogRequestId => 'Request ID';

  @override
  String get auditLogResourceId => 'Resource ID';

  @override
  String get auditLogResourceType => 'Resource Type';

  @override
  String get auditLogSearchPlaceholder => 'Search paths or actions...';

  @override
  String auditLogShowingEvents(int start, int end, int total) {
    return 'Showing $start-$end of $total events';
  }

  @override
  String get auditLogSuccess => 'Success';

  @override
  String get auditLogTitle => 'Audit Log';

  @override
  String get auditLogUserAgent => 'User Agent';

  @override
  String get dbPageTitle => 'Database Management';

  @override
  String get dbTableDescAccount2FA =>
      'Two-factor authentication settings per account';

  @override
  String get dbTableDescAccountData =>
      'User account information and profile details';

  @override
  String get dbTableDescAccountRequest =>
      'Pending account creation requests awaiting approval';

  @override
  String get dbTableDescAuditEvent => 'Audit log of security-relevant events';

  @override
  String get dbTableDescAuth =>
      'Password hashes for user authentication (sensitive columns hidden)';

  @override
  String get dbTableDescConsentRecord =>
      'Records of participants signing the consent document';

  @override
  String get dbTableDescConversationParticipants =>
      'Maps accounts to conversations (many-to-many)';

  @override
  String get dbTableDescConversations =>
      'Messaging conversations between users';

  @override
  String get dbTableDescDataTypes =>
      'Categories for health data collected by questions';

  @override
  String get dbTableDescFriendRequests =>
      'Friend/connection requests between participant accounts';

  @override
  String get dbTableDescHcpPatientLink =>
      'Links between HCP providers and their patients';

  @override
  String get dbTableDescMessages =>
      'Individual messages sent within conversations';

  @override
  String get dbTableDescMfaChallenges =>
      'One-time MFA token challenges (sensitive columns hidden)';

  @override
  String get dbTableDescPasswordResetTokens =>
      'Password reset tokens for account recovery';

  @override
  String get dbTableDescQuestionBank =>
      'Reusable questions that can be added to surveys';

  @override
  String get dbTableDescQuestionCategories =>
      'Categories for organizing survey questions';

  @override
  String get dbTableDescQuestionList =>
      'Links questions to surveys (many-to-many)';

  @override
  String get dbTableDescQuestionOptions =>
      'Options for single_choice and multi_choice questions';

  @override
  String get dbTableDescResponses => 'Participant answers to survey questions';

  @override
  String get dbTableDescRoles => 'User roles defining access permissions';

  @override
  String get dbTableDescSessions =>
      'Active user login sessions (sensitive columns hidden)';

  @override
  String get dbTableDescSurvey => 'Survey definitions created by researchers';

  @override
  String get dbTableDescSurveyAssignment =>
      'Tracks which surveys are assigned to which participants';

  @override
  String get dbTableDescSurveyTemplate =>
      'Reusable survey templates created by researchers';

  @override
  String get dbTableDescSystemSettings =>
      'System configuration settings and application preferences';

  @override
  String get dbTableDescTemplateQuestions =>
      'Links questions to survey templates (many-to-many)';

  @override
  String get dbUtilitiesTitle => 'Database Utilities';

  @override
  String get dbViewerColumnHeader => 'Column';

  @override
  String dbViewerColumnsCount(int count) {
    return '$count columns';
  }

  @override
  String get dbViewerConstraintsHeader => 'Constraints';

  @override
  String get dbViewerData => 'Data';

  @override
  String get dbViewerFailedToLoad => 'Failed to load database tables';

  @override
  String dbViewerFailedToLoadData(String error) {
    return 'Failed to load table data: $error';
  }

  @override
  String get dbViewerForeignKey => 'Foreign Key';

  @override
  String get dbViewerNoData => 'No data in table';

  @override
  String get dbViewerNotNull => 'Not Null';

  @override
  String get dbViewerNull => 'NULL';

  @override
  String get dbViewerNullable => 'Nullable';

  @override
  String dbViewerPageOf(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get dbViewerPrimaryKey => 'Primary Key';

  @override
  String get dbViewerReferenceHeader => 'Reference';

  @override
  String dbViewerRowsCount(int count) {
    return '$count rows';
  }

  @override
  String dbViewerRowsTotal(int count) {
    return '$count rows total';
  }

  @override
  String get dbViewerSchema => 'Schema';

  @override
  String get dbViewerSelectATable => 'Select a table';

  @override
  String get dbViewerSelectTable => 'Select Table';

  @override
  String dbViewerShowing(int start, int end, int total) {
    return 'Showing $start-$end of $total';
  }

  @override
  String dbViewerTableData(String name) {
    return '$name Data';
  }

  @override
  String dbViewerTablesCount(int count) {
    return '$count tables in database';
  }

  @override
  String get dbViewerTitle => 'Database Viewer';

  @override
  String get dbViewerTypeHeader => 'Type';

  @override
  String get dbViewerViewModeLabel => 'Toggle between schema and data view';

  @override
  String get backupCreatedError => 'Backup failed. Check server logs.';

  @override
  String backupCreatedSuccess(String size) {
    return 'Backup created ($size)';
  }

  @override
  String get backupCreateManual => 'Create Backup Now';

  @override
  String get backupCreating => 'Creating…';

  @override
  String backupDeleteConfirmBody(String filename) {
    return 'This will permanently delete $filename. This action cannot be undone.';
  }

  @override
  String get backupDeleteConfirmTitle => 'Delete Backup?';

  @override
  String get backupDeleteError => 'Could not delete backup. Please try again.';

  @override
  String get backupDeleteSuccess => 'Backup deleted.';

  @override
  String get backupDeleteTooltip => 'Delete this backup';

  @override
  String get backupDownloadError => 'Download failed. Please try again.';

  @override
  String get backupDownloadStarted => 'Download started.';

  @override
  String get backupDownloadTooltip => 'Download backup file';

  @override
  String get backupLatest => 'Latest Backup';

  @override
  String get backupLoadError => 'Could not load backup list';

  @override
  String get backupNoneFound => 'No backups found';

  @override
  String get backupNoneFoundSubtitle =>
      'No backup files exist yet. Create a manual backup or wait for the scheduled backup to run.';

  @override
  String get backupNoRecent => 'No backups yet — create one now.';

  @override
  String get backupPageSubtitle =>
      'Automated backups run daily at 2 AM, weekly on Sundays, and monthly on the 1st. Manual backups are kept for the last 10 runs.';

  @override
  String get backupPageTitle => 'Database Backups';

  @override
  String get backupRestoreAction => 'Restore Database';

  @override
  String backupRestoreConfirmBody(String filename) {
    return 'This will replace ALL current data with the contents of $filename.\n\nA pre-restore backup will be created automatically before the restore begins.\n\nThis action cannot be undone.';
  }

  @override
  String get backupRestoreConfirmTitle => 'Restore Database?';

  @override
  String get backupRestoreError =>
      'Restore failed. Please try again or contact support.';

  @override
  String get backupRestoreSelectHint => 'Choose a backup to restore…';

  @override
  String get backupRestoreSelectLabel => 'Select Backup';

  @override
  String backupRestoreSuccess(String size, int migrations) {
    return 'Database restored. Pre-restore backup saved ($size). $migrations migration(s) applied.';
  }

  @override
  String get backupRestoreTitle => 'Restore from Backup';

  @override
  String get backupRestoreTooltip => 'Restore database from this backup';

  @override
  String get backupRestoring => 'Restoring…';

  @override
  String backupSavedTo(String path) {
    return 'Saved to $path';
  }

  @override
  String get backupSectionCollapse => 'Hide backups';

  @override
  String get backupSectionExpand => 'Show backups';

  @override
  String get backupTypeDaily => 'Daily';

  @override
  String get backupTypeManual => 'Manual';

  @override
  String get backupTypeMonthly => 'Monthly';

  @override
  String get backupTypeWeekly => 'Weekly';

  @override
  String get backupViewAll => 'View All Backups';

  @override
  String get userManagementActivate => 'Activate';

  @override
  String get userManagementActivatedSuccess => 'User activated';

  @override
  String get userManagementActiveOnly => 'Active only';

  @override
  String get userManagementAddNewUser => 'Add New User';

  @override
  String get userManagementAddUser => 'Add User';

  @override
  String get userManagementAdminConsentExempt => 'Admin — Consent Exempt';

  @override
  String get userManagementAll => 'All';

  @override
  String get userManagementAllRoles => 'All Roles';

  @override
  String get userManagementCopy => 'Copy';

  @override
  String get userManagementCreatedSuccess => 'User created successfully';

  @override
  String get userManagementDeactivate => 'Deactivate';

  @override
  String get userManagementDeactivatedSuccess => 'User deactivated';

  @override
  String get userManagementDeleteUserTitle => 'Delete User';

  @override
  String get userManagementDeleteUserTooltip => 'Delete user';

  @override
  String get userManagementEditUser => 'Edit user';

  @override
  String get userManagementEditUserTitle => 'Edit User';

  @override
  String get userManagementEditUserTooltip => 'Edit user';

  @override
  String get userManagementFailedToImpersonate => 'Failed to impersonate user';

  @override
  String get userManagementFailedToLoad => 'Failed to load users';

  @override
  String get userManagementFilterByRole => 'Filter by Role';

  @override
  String get userManagementFirstName => 'First Name';

  @override
  String get userManagementGenerate => 'Generate';

  @override
  String get userManagementLastName => 'Last Name';

  @override
  String get userManagementNoUsers => 'No users found';

  @override
  String userManagementNowViewingAs(String name) {
    return 'Now viewing as $name';
  }

  @override
  String get userManagementPasswordCopied => 'Password copied to clipboard';

  @override
  String get userManagementResetPasswordTooltip => 'Reset Password';

  @override
  String get userManagementRole => 'Role';

  @override
  String get userManagementRoleLabel => 'Role';

  @override
  String get userManagementSearchByEmail => 'Search by name or email...';

  @override
  String get userManagementSearchPlaceholder => 'Search by name or email...';

  @override
  String get userManagementSearchShort => 'Search...';

  @override
  String get userManagementTableActions => 'Actions';

  @override
  String get userManagementTableEmail => 'Email';

  @override
  String get userManagementTableLastLogin => 'Last Login';

  @override
  String get userManagementTableName => 'Name';

  @override
  String get userManagementTableRole => 'Role';

  @override
  String get userManagementTableStatus => 'Status';

  @override
  String get userManagementTitle => 'User Management';

  @override
  String userManagementTotalUsers(int count) {
    return 'Total: $count users';
  }

  @override
  String get userManagementUpdatedSuccess => 'User updated successfully';

  @override
  String userManagementUserDeleted(String name) {
    return '$name deleted';
  }

  @override
  String userManagementUsersShown(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count users shown',
      one: '1 user shown',
    );
    return '$_temp0';
  }

  @override
  String get userManagementViewAsUser => 'View as User';

  @override
  String get userRoleAdmin => 'Admin';

  @override
  String get userRoleHcp => 'Healthcare Professional';

  @override
  String get userRoleHcpShort => 'HCP';

  @override
  String get userRoleParticipant => 'Participant';

  @override
  String get userRoleResearcher => 'Researcher';

  @override
  String get userRoleUnknown => 'Unknown';

  @override
  String get settings2faDisabledSuccess => '2FA disabled';

  @override
  String get settings2faListSubtitle =>
      'Set up or confirm 2FA for your account';

  @override
  String get settingsAppearanceApplied => 'Applied';

  @override
  String get settingsAppearanceApply => 'Apply';

  @override
  String get settingsAppearanceReset => 'Reset';

  @override
  String get settingsAppearanceSectionTitle => 'Appearance';

  @override
  String get settingsAppearanceSubtitle =>
      'Choose a visual style for your account.';

  @override
  String get settingsAppearanceUpdated => 'Appearance updated.';

  @override
  String get settingsChangePasswordSubtitle => 'Update your account password';

  @override
  String get settingsDeleteAccountCancel => 'Cancel';

  @override
  String get settingsDeleteAccountConfirm => 'Submit Request';

  @override
  String get settingsDeleteAccountDialogBody =>
      'Your account will be deactivated immediately and a deletion request will be sent to an administrator for review. You will be logged out.';

  @override
  String get settingsDeleteAccountDialogTitle => 'Request Account Deletion?';

  @override
  String get settingsDeleteAccountFailed =>
      'Failed to submit deletion request. Please try again.';

  @override
  String get settingsDeleteAccountSubtitle =>
      'Request permanent removal of your account';

  @override
  String get settingsDeleteAccountTitle => 'Delete Account';

  @override
  String get settingsDisable2faDialogBody =>
      'This will reduce the security of your account. You can re-enable it later.';

  @override
  String get settingsDisable2faDialogCancel => 'Cancel';

  @override
  String get settingsDisable2faDialogConfirm => 'Disable';

  @override
  String get settingsDisable2faDialogTitle => 'Disable 2FA?';

  @override
  String get settingsDisable2faFailed =>
      'Failed to disable 2FA. Please try again.';

  @override
  String get settingsDisable2faSubtitle => 'Remove 2FA from your account';

  @override
  String get settingsDisable2faTitle => 'Disable 2FA';

  @override
  String get settingsManageAccountSubtitle => 'Manage your account settings.';

  @override
  String get settingsSecuritySectionTitle => 'Security';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get uiClearAll => 'Clear All';

  @override
  String get uiClearFilters => 'Clear Filters';

  @override
  String get uiFiltersLabel => 'Filters: ';

  @override
  String get uiNever => 'Never';

  @override
  String uiSearchLabel(String query) {
    return 'Search: \"$query\"';
  }

  @override
  String get uiTestControlActive => 'Active';

  @override
  String get uiTestControlArrowTop => 'Arrow Top';

  @override
  String get uiTestControlAspect => 'Aspect';

  @override
  String get uiTestControlAsset => 'Asset';

  @override
  String get uiTestControlBackground => 'Background';

  @override
  String get uiTestControlColor => 'Color';

  @override
  String get uiTestControlCreateEnabled => 'Create Enabled';

  @override
  String get uiTestControlDisabled => 'Disabled';

  @override
  String get uiTestControlEnabled => 'Enabled';

  @override
  String get uiTestControlFill => 'Fill';

  @override
  String get uiTestControlFit => 'Fit';

  @override
  String get uiTestControlHeight => 'Height';

  @override
  String uiTestControlHeightPx(String value) {
    return 'Height: ${value}px';
  }

  @override
  String get uiTestControlIcon => 'Icon';

  @override
  String get uiTestControlLabel => 'Label';

  @override
  String get uiTestControlLegend => 'Legend';

  @override
  String get uiTestControlMessage => 'Message';

  @override
  String get uiTestControlNotification => 'Notification';

  @override
  String uiTestControlProgress(String value) {
    return 'Progress: $value%';
  }

  @override
  String get uiTestControlRadius => 'Radius';

  @override
  String get uiTestControlRequired => 'Required';

  @override
  String get uiTestControlSemantics => 'Semantics';

  @override
  String get uiTestControlSize => 'Size';

  @override
  String uiTestControlSpacing(String value) {
    return 'Spacing: $value';
  }

  @override
  String get uiTestControlStartExpanded => 'Start Expanded';

  @override
  String get uiTestControlSubtitle => 'Subtitle';

  @override
  String get uiTestControlTagline => 'Tagline';

  @override
  String get uiTestControlText => 'Text';

  @override
  String uiTestControlThickness(String value) {
    return 'Thickness: $value';
  }

  @override
  String get uiTestControlTrack => 'Track';

  @override
  String get uiTestControlTristate => 'Tristate';

  @override
  String get uiTestControlValues => 'Values';

  @override
  String get uiTestControlVariant => 'Variant';

  @override
  String get uiTestControlWeight => 'Weight';

  @override
  String get uiTestControlWidth => 'Width';

  @override
  String uiTestControlWidthPx(String value) {
    return 'Width: ${value}px';
  }

  @override
  String get uiTestDemoAboveDivider => 'Above divider';

  @override
  String get uiTestDemoAdminPassword => 'Admin Password';

  @override
  String get uiTestDemoAliceCarter => 'Alice Carter';

  @override
  String get uiTestDemoAppointmentTime => 'Appointment Time';

  @override
  String get uiTestDemoBadge => 'Badge';

  @override
  String get uiTestDemoBelowDivider => 'Below divider';

  @override
  String get uiTestDemoCaution => 'Caution';

  @override
  String get uiTestDemoClickMe => 'Click Me';

  @override
  String get uiTestDemoCodeCopied => 'Code copied to clipboard';

  @override
  String uiTestDemoCompletionPrefix(String value) {
    return 'Completion: $value%';
  }

  @override
  String get uiTestDemoConfirm => 'Confirm';

  @override
  String get uiTestDemoConfirmAction => 'Confirm action';

  @override
  String get uiTestDemoConfirmActionBody => 'This action cannot be undone.';

  @override
  String get uiTestDemoContinue => 'Continue';

  @override
  String get uiTestDemoCriticalActionBody =>
      'This is a secured action. Enter your password before confirmation.';

  @override
  String get uiTestDemoCriticalActionTitle => 'Critical Action Confirmation';

  @override
  String get uiTestDemoCurrentPassword => 'Current Password';

  @override
  String get uiTestDemoDateOfBirth => 'Date of Birth';

  @override
  String get uiTestDemoDefaultPlaceholder => 'Default placeholder';

  @override
  String get uiTestDemoDemographics => 'Demographics';

  @override
  String get uiTestDemoEmail => 'Email';

  @override
  String get uiTestDemoEnrollment => 'Enrollment';

  @override
  String get uiTestDemoError => 'Error';

  @override
  String get uiTestDemoExampleImage => 'Example image';

  @override
  String get uiTestDemoFullName => 'Full Name';

  @override
  String get uiTestDemoHelloWorld => 'Hello World';

  @override
  String get uiTestDemoInfo => 'Info';

  @override
  String get uiTestDemoInvalidPasswordMessage =>
      'Incorrect password. Demo password is \"Admin123!\".';

  @override
  String get uiTestDemoKpiTrends => 'KPI Trends';

  @override
  String get uiTestDemoLearnMore => 'Learn more';

  @override
  String uiTestDemoNormalizedPrefix(String value) {
    return 'Normalized: $value';
  }

  @override
  String get uiTestDemoNotes => 'Notes';

  @override
  String get uiTestDemoNullIndeterminate => 'null (indeterminate)';

  @override
  String get uiTestDemoOpenModal => 'Open modal';

  @override
  String get uiTestDemoOpenSecuredModal => 'Open secured modal';

  @override
  String get uiTestDemoOverview => 'Overview';

  @override
  String get uiTestDemoParticipants => 'Participants';

  @override
  String get uiTestDemoPasswordVerified =>
      'Password verified. Action confirmed.';

  @override
  String get uiTestDemoPhoneNumber => 'Phone Number';

  @override
  String get uiTestDemoPlaceholderGraphic => 'Placeholder graphic';

  @override
  String get uiTestDemoPriority => 'Priority';

  @override
  String get uiTestDemoQueryEmpty => '(empty)';

  @override
  String get uiTestDemoQueryNone => '(none)';

  @override
  String uiTestDemoQueryPrefix(String value) {
    return 'Query: $value';
  }

  @override
  String get uiTestDemoRespondents => 'Respondents';

  @override
  String get uiTestDemoSearchWidgets => 'Search widgets...';

  @override
  String get uiTestDemoShowPopover => 'Show popover';

  @override
  String get uiTestDemoSuccess => 'Success';

  @override
  String get uiTestDemoSummary => 'Summary';

  @override
  String get uiTestDemoTaskCompletion => 'Task completion';

  @override
  String get uiTestDemoThisWeek => '+12 this week';

  @override
  String uiTestDemoValuePrefix(String value) {
    return 'Value: $value';
  }

  @override
  String get uiTestDemoVerificationFailed => 'Verification failed.';

  @override
  String get uiTestEnterValue => 'Enter value';

  @override
  String get uiTestPageSubtitle =>
      'Interactive previews with live customization for all reusable widgets.';

  @override
  String get uiTestPageTitle => 'UI Widget Catalogue';

  @override
  String get uiTestSectionBasics => 'Basics';

  @override
  String get uiTestSectionButtons => 'Buttons';

  @override
  String get uiTestSectionDataDisplay => 'Data Display';

  @override
  String get uiTestSectionFeedback => 'Feedback';

  @override
  String get uiTestSectionForms => 'Forms and Input';

  @override
  String get uiTestSectionMicro => 'Micro Widgets';

  @override
  String uiTestSectionNavbarActiveDestination(String label) {
    return 'Active destination: $label';
  }

  @override
  String get uiTestSectionNavbarActiveNone => 'None';

  @override
  String get uiTestSectionNavbarAddSection => 'Add Section';

  @override
  String get uiTestSectionNavbarAddSubsection => 'Add Subsection';

  @override
  String get uiTestSectionNavbarContainedTitle => 'Contained Scrollable Page';

  @override
  String get uiTestSectionNavbarHideCode => 'Hide Code';

  @override
  String get uiTestSectionNavbarInitiallyExpanded => 'Initially expanded';

  @override
  String get uiTestSectionNavbarNoSections =>
      'No sections configured. Add at least one section in PROPERTIES.';

  @override
  String get uiTestSectionNavbarProperties => 'PROPERTIES';

  @override
  String get uiTestSectionNavbarRemoveSection => 'Remove section';

  @override
  String get uiTestSectionNavbarRemoveSubsection => 'Remove subsection';

  @override
  String get uiTestSectionNavbarReset => 'Reset';

  @override
  String get uiTestSectionNavbarScrollHint =>
      'Scroll this panel or click a destination to jump.';

  @override
  String get uiTestSectionNavbarSectionLabel => 'Section label';

  @override
  String uiTestSectionNavbarSectionN(String n) {
    return 'Section $n';
  }

  @override
  String get uiTestSectionNavbarShowCode => 'Show Code';

  @override
  String get uiTestSectionNavbarSubsection1 => 'Subsection 1';

  @override
  String get uiTestSectionNavbarSubsectionLabel => 'Subsection label';

  @override
  String uiTestSectionNavbarSubsectionN(String n) {
    return 'Subsection $n';
  }

  @override
  String get uiTestSectionNavbarUntitledSection => 'Untitled Section';

  @override
  String get uiTestSectionNavbarUntitledSubsection => 'Untitled Subsection';

  @override
  String get uiTestWidgetAppAccordion => 'AppAccordion';

  @override
  String get uiTestWidgetAppAccordionDesc =>
      'Expandable panel for showing and hiding details.';

  @override
  String get uiTestWidgetAppAnnouncement => 'AppAnnouncement';

  @override
  String get uiTestWidgetAppAnnouncementDesc =>
      'Inline banner for important announcements.';

  @override
  String get uiTestWidgetAppBadge => 'AppBadge';

  @override
  String get uiTestWidgetAppBadgeDesc =>
      'Semantic pill labels for status, roles, and categories.';

  @override
  String get uiTestWidgetAppBarChart => 'AppBarChart';

  @override
  String get uiTestWidgetAppBarChartDesc =>
      'Bar chart with fl_chart, axis labels, and hover tooltips.';

  @override
  String get uiTestWidgetAppBreadcrumbs => 'AppBreadcrumbs';

  @override
  String get uiTestWidgetAppBreadcrumbsDesc =>
      'Breadcrumb trail for navigation hierarchy.';

  @override
  String get uiTestWidgetAppCardTask => 'AppCardTask';

  @override
  String get uiTestWidgetAppCardTaskDesc =>
      'Actionable task card with due text, optional repeat text, and CTA.';

  @override
  String get uiTestWidgetAppCheckbox => 'AppCheckbox';

  @override
  String get uiTestWidgetAppCheckboxDesc =>
      'Theme-aware checkbox with controlled and uncontrolled modes.';

  @override
  String get uiTestWidgetAppCreateConfirmPassword =>
      'AppCreatePasswordInput + AppConfirmPasswordInput';

  @override
  String get uiTestWidgetAppCreateConfirmPasswordDesc =>
      'Create/confirm password pair with live rule checks.';

  @override
  String get uiTestWidgetAppDateInput => 'AppDateInput';

  @override
  String get uiTestWidgetAppDateInputDesc =>
      'Date picker input with required validation.';

  @override
  String get uiTestWidgetAppDivider => 'AppDivider';

  @override
  String get uiTestWidgetAppDividerDesc =>
      'Visual separator with configurable thickness and spacing.';

  @override
  String get uiTestWidgetAppDropdownInput => 'AppDropdownInput';

  @override
  String get uiTestWidgetAppDropdownInputDesc =>
      'Form dropdown with required and error behavior.';

  @override
  String get uiTestWidgetAppDropdownMenu => 'AppDropdownMenu';

  @override
  String get uiTestWidgetAppDropdownMenuDesc =>
      'Theme-aware dropdown for choosing from options.';

  @override
  String get uiTestWidgetAppEmailInput => 'AppEmailInput';

  @override
  String get uiTestWidgetAppEmailInputDesc =>
      'Email input with structure validation and autofill.';

  @override
  String get uiTestWidgetAppFilledButton => 'AppFilledButton';

  @override
  String get uiTestWidgetAppFilledButtonDesc =>
      'Primary action button with filled background.';

  @override
  String get uiTestWidgetAppGraphRenderer => 'AppGraphRenderer';

  @override
  String get uiTestWidgetAppGraphRendererDesc =>
      'Responsive graph container with title and optional custom chart content.';

  @override
  String get uiTestWidgetAppIcon => 'AppIcon';

  @override
  String get uiTestWidgetAppIconDesc =>
      'Theme-aware icon wrapper with responsive sizing.';

  @override
  String get uiTestWidgetAppImage => 'AppImage';

  @override
  String get uiTestWidgetAppImageDesc =>
      'Responsive image with aspect ratio support.';

  @override
  String get uiTestWidgetAppLongButton => 'AppLongButton';

  @override
  String get uiTestWidgetAppLongButtonDesc =>
      'Full-width button for prominent actions.';

  @override
  String get uiTestWidgetAppModalOverlay => 'AppModal + AppOverlay';

  @override
  String get uiTestWidgetAppModalOverlayDesc =>
      'Button-triggered modal with overlay barrier.';

  @override
  String get uiTestWidgetAppParagraphInput => 'AppParagraphInput';

  @override
  String get uiTestWidgetAppParagraphInputDesc =>
      'Multi-line text input with controlled line sizing.';

  @override
  String get uiTestWidgetAppPasswordInput => 'AppPasswordInput';

  @override
  String get uiTestWidgetAppPasswordInputDesc =>
      'Password input with eye toggle and required checks.';

  @override
  String get uiTestWidgetAppPhoneInput => 'AppPhoneInput';

  @override
  String get uiTestWidgetAppPhoneInputDesc =>
      'Phone input with country selector and normalized output.';

  @override
  String get uiTestWidgetAppPieChart => 'AppPieChart';

  @override
  String get uiTestWidgetAppPieChartDesc =>
      'Pie chart with legend, percentage labels, and touch interaction.';

  @override
  String get uiTestWidgetAppPlaceholderGraphic => 'AppPlaceholderGraphic';

  @override
  String get uiTestWidgetAppPlaceholderGraphicDesc =>
      'Theme-aware placeholder graphic for empty states.';

  @override
  String get uiTestWidgetAppPopover => 'AppPopover';

  @override
  String get uiTestWidgetAppPopoverDesc => 'Context-anchored inline feedback.';

  @override
  String get uiTestWidgetAppProgressBar => 'AppProgressBar';

  @override
  String get uiTestWidgetAppProgressBarDesc =>
      'Theme-aware progress indicator for completion and status tracking.';

  @override
  String get uiTestWidgetAppRadio => 'AppRadio';

  @override
  String get uiTestWidgetAppRadioDesc =>
      'Theme-aware radio button with controlled and uncontrolled modes.';

  @override
  String get uiTestWidgetAppRichText => 'AppRichText';

  @override
  String get uiTestWidgetAppRichTextDesc =>
      'Inline formatting with bold, italic, and mixed styles.';

  @override
  String get uiTestWidgetAppSearchBar => 'AppSearchBar';

  @override
  String get uiTestWidgetAppSearchBarDesc =>
      'Search input with leading icon and clear action.';

  @override
  String get uiTestWidgetAppSectionNavbar => 'AppSectionNavbar';

  @override
  String get uiTestWidgetAppSectionNavbarDesc =>
      'Section navigation with collapsible groups and active destination highlighting.';

  @override
  String get uiTestWidgetAppSecuredModal => 'AppSecuredModal';

  @override
  String get uiTestWidgetAppSecuredModalDesc =>
      'Critical-action confirmation modal requiring password verification.';

  @override
  String get uiTestWidgetAppStatCard => 'AppStatCard';

  @override
  String get uiTestWidgetAppStatCardDesc =>
      'Stat card with icon, label, big value, optional subtitle, and accent top border.';

  @override
  String get uiTestWidgetAppStatusDot => 'AppStatusDot';

  @override
  String get uiTestWidgetAppStatusDotDesc =>
      'Notification indicator overlay on any icon.';

  @override
  String get uiTestWidgetAppText => 'AppText';

  @override
  String get uiTestWidgetAppTextButton => 'AppTextButton';

  @override
  String get uiTestWidgetAppTextButtonDesc =>
      'Text-only button for secondary actions.';

  @override
  String get uiTestWidgetAppTextDesc =>
      'Theme-aware text with responsive typography variants.';

  @override
  String get uiTestWidgetAppTextInput => 'AppTextInput';

  @override
  String get uiTestWidgetAppTextInputDesc =>
      'Single-line text input with label and validation.';

  @override
  String get uiTestWidgetAppTimeInput => 'AppTimeInput';

  @override
  String get uiTestWidgetAppTimeInputDesc =>
      'Time picker input with required validation.';

  @override
  String get uiTestWidgetAppToast => 'AppToast';

  @override
  String get uiTestWidgetAppToastDesc =>
      'Transient overlay notifications with auto-dismiss.';

  @override
  String get uiTestWidgetDataTable => 'DataTable';

  @override
  String get uiTestWidgetDataTableCell => 'DataTableCell';

  @override
  String get uiTestWidgetDataTableCellDesc =>
      'Typed cell factories for consistent table cell styling.';

  @override
  String get uiTestWidgetDataTableDesc =>
      'Sortable table with expandable rows, sticky headers, and horizontal scroll.';

  @override
  String get uiTestWidgetHealthBankLogo => 'HealthBankLogo';

  @override
  String get uiTestWidgetHealthBankLogoDesc =>
      'Brand logo with optional tagline and size variants.';

  @override
  String get privacyPolicySection1Body =>
      'HealthBank collects personal information that you provide when creating your account, including your name, email address, date of birth, and gender. When you complete health surveys, we collect the health data and responses you choose to submit. We also collect technical information such as login timestamps and session activity to maintain platform security.\n\nWe collect only the information necessary to operate the platform and facilitate approved research. You are never required to provide information beyond what is needed to participate in your specific research program.';

  @override
  String get privacyPolicySection1Title => 'Information We Collect';

  @override
  String get privacyPolicySection2Body =>
      'Your personal information is used solely to operate the HealthBank platform and facilitate approved health research. Specifically, we use your data to: authenticate your identity and manage your account; deliver surveys and collect your health responses; allow your assigned healthcare professional to monitor your participation; and provide researchers with aggregated, de-identified results for analysis.\n\nWe do not use your personal information for marketing, advertising, or any commercial purpose. Your data is never sold to third parties.';

  @override
  String get privacyPolicySection2Title => 'How We Use Your Information';

  @override
  String get privacyPolicySection3Body =>
      'Your individual health data is shared only with authorized parties directly involved in your care or your approved research study. Researchers on the platform receive only aggregated, de-identified data — individual responses cannot be linked to your identity in research outputs.\n\nWe may be required to disclose information where mandated by Canadian law, court order, or where disclosure is necessary to prevent serious harm. In all such cases, we disclose only the minimum information required and document every disclosure.';

  @override
  String get privacyPolicySection3Title => 'How We Share Your Data';

  @override
  String get privacyPolicySection4Body =>
      'HealthBank uses industry-standard security measures to protect your personal information, including encrypted data transmission (HTTPS), password hashing, session management, and restricted access controls. The platform is operated on secure servers with access limited to authorized personnel only.\n\nYour data is retained for as long as you are an active participant in a HealthBank research program. You may request deletion of your account and associated data at any time by contacting the HealthBank Privacy Officer. Some data may be retained in aggregated, de-identified form for research continuity after account removal.';

  @override
  String get privacyPolicySection4Title => 'Data Security and Retention';

  @override
  String get privacyPolicySection5Body =>
      'Under PIPEDA and applicable provincial legislation, you have the right to: access the personal information we hold about you; request corrections to inaccurate information; withdraw your consent and request deletion of your data; and receive an explanation of how your data is used.\n\nTo exercise any of these rights, or if you have questions or concerns about your privacy, please contact the HealthBank Privacy Officer at your institution. We are committed to responding to all privacy inquiries within 30 days.';

  @override
  String get privacyPolicySection5Title => 'Your Rights and Contact';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacyPolicyTocTitle => 'Table of Contents';

  @override
  String get tosSection1Body =>
      'By creating an account or accessing the HealthBank platform, you agree to be bound by these Terms of Service and our Privacy Policy. If you do not agree to these terms, you must not use the platform. These terms may be updated periodically; continued use of the platform following notice of any changes constitutes your acceptance of the revised terms.';

  @override
  String get tosSection1Title => 'Acceptance of Terms';

  @override
  String get tosSection2Body =>
      'Access to HealthBank is by invitation only. Participant accounts are created by authorized administrators or healthcare professionals. You must be at least 18 years of age, or have the consent of a parent or guardian if under 18. You are responsible for maintaining the confidentiality of your login credentials and for all activity that occurs under your account.';

  @override
  String get tosSection2Title => 'Eligible Users';

  @override
  String get tosSection3Body =>
      'You agree to use HealthBank solely for its intended purpose — participating in approved health research and managing your personal health data. You must not attempt to access data belonging to other users; tamper with, reverse-engineer, or disrupt the platform; submit false or misleading information; or use the platform for any unlawful purpose. Violation of these responsibilities may result in immediate account suspension.';

  @override
  String get tosSection3Title => 'User Responsibilities';

  @override
  String get tosSection4Body =>
      'Your use of HealthBank involves the collection and use of personal health data as described in our Privacy Policy. By using the platform, you consent to this collection for the purposes of approved health research. You may withdraw your consent at any time by contacting your study coordinator or the HealthBank Privacy Officer, which will result in the deactivation of your account. HealthBank is operated in compliance with Canadian privacy legislation.';

  @override
  String get tosSection4Title => 'Data and Privacy';

  @override
  String get tosSection5Body =>
      'HealthBank is provided as an academic research platform on an \"as is\" basis. While we take all reasonable precautions to maintain security and data integrity, the University of Prince Edward Island and the HealthBank project team shall not be liable for indirect, incidental, or consequential damages arising from your use of the platform. Nothing in these terms limits liability for gross negligence, wilful misconduct, or as required by applicable law.';

  @override
  String get tosSection5Title => 'Limitation of Liability';

  @override
  String get tosTitle => 'Terms of Service';

  @override
  String get tosTocTitle => 'Contents';
}
