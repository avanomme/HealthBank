import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// No description provided for @commonActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get commonActions;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonClear;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get commonContactUs;

  /// No description provided for @commonCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2025 HealthBank. All rights reserved.'**
  String get commonCopyright;

  /// No description provided for @commonDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get commonDate;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get commonDescription;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get commonEmail;

  /// No description provided for @commonEndDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get commonEndDate;

  /// No description provided for @commonErrorWithDetail.
  ///
  /// In en, this message translates to:
  /// **'Error: {detail}'**
  String commonErrorWithDetail(String detail);

  /// No description provided for @commonFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get commonFilter;

  /// No description provided for @commonHidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get commonHidePassword;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @commonName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get commonName;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get commonOff;

  /// No description provided for @commonOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get commonOn;

  /// No description provided for @commonPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get commonPassword;

  /// No description provided for @commonPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get commonPrivacyPolicy;

  /// No description provided for @commonRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get commonRefresh;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get commonSaving;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonSeeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get commonSeeMore;

  /// No description provided for @commonShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get commonShowPassword;

  /// No description provided for @commonStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get commonStartDate;

  /// No description provided for @commonStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get commonStatus;

  /// No description provided for @commonSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get commonSubmit;

  /// No description provided for @commonTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get commonTermsOfService;

  /// No description provided for @commonTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get commonTime;

  /// No description provided for @commonTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get commonTitle;

  /// No description provided for @commonType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get commonType;

  /// No description provided for @commonViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get commonViewAll;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get statusInactive;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgress;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get errorNetwork;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found.'**
  String get errorNotFound;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'You are not authorized to perform this action.'**
  String get errorUnauthorized;

  /// No description provided for @formConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get formConfirmPasswordLabel;

  /// No description provided for @formConfirmPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords must match exactly.'**
  String get formConfirmPasswordMismatch;

  /// No description provided for @formConfirmPasswordMustMatch.
  ///
  /// In en, this message translates to:
  /// **'Confirmed password must exactly match Create Password.'**
  String get formConfirmPasswordMustMatch;

  /// No description provided for @formCreatePasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Create Password'**
  String get formCreatePasswordLabel;

  /// No description provided for @formDateValidationError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid date in YYYY-MM-DD format (e.g. 2024-01-15).'**
  String get formDateValidationError;

  /// No description provided for @formEmailValidationError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address (e.g. name@example.com).'**
  String get formEmailValidationError;

  /// No description provided for @formPasswordCheckTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Check'**
  String get formPasswordCheckTitle;

  /// No description provided for @formPasswordRuleAscii.
  ///
  /// In en, this message translates to:
  /// **'Use ASCII letters, digits, and common symbols only.'**
  String get formPasswordRuleAscii;

  /// No description provided for @formPasswordRuleLowercase.
  ///
  /// In en, this message translates to:
  /// **'At least one lowercase letter.'**
  String get formPasswordRuleLowercase;

  /// No description provided for @formPasswordRuleMax32.
  ///
  /// In en, this message translates to:
  /// **'Maximum 32 characters.'**
  String get formPasswordRuleMax32;

  /// No description provided for @formPasswordRuleMin8.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters.'**
  String get formPasswordRuleMin8;

  /// No description provided for @formPasswordRuleNoEmail.
  ///
  /// In en, this message translates to:
  /// **'Must not contain email-like fragments (for example, local@domain.com).'**
  String get formPasswordRuleNoEmail;

  /// No description provided for @formPasswordRuleNumberOrSymbol.
  ///
  /// In en, this message translates to:
  /// **'At least one number or symbol.'**
  String get formPasswordRuleNumberOrSymbol;

  /// No description provided for @formPasswordRulesError.
  ///
  /// In en, this message translates to:
  /// **'Password does not meet the required rules.'**
  String get formPasswordRulesError;

  /// No description provided for @formPasswordRulesHelper.
  ///
  /// In en, this message translates to:
  /// **'Your password must meet all of the following requirements:'**
  String get formPasswordRulesHelper;

  /// No description provided for @formPasswordRuleUppercase.
  ///
  /// In en, this message translates to:
  /// **'At least one uppercase letter.'**
  String get formPasswordRuleUppercase;

  /// No description provided for @formPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get formPhoneHint;

  /// No description provided for @formPhoneValidationError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number including country code.'**
  String get formPhoneValidationError;

  /// No description provided for @formSecuredPasswordVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Password verification failed.'**
  String get formSecuredPasswordVerificationFailed;

  /// No description provided for @formTimeValidationError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid time in HH:MM format (e.g. 09:30).'**
  String get formTimeValidationError;

  /// No description provided for @validationInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address (e.g. name@example.com).'**
  String get validationInvalidEmail;

  /// No description provided for @validationInvalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get validationInvalidPassword;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required. Please enter a value.'**
  String get validationRequired;

  /// No description provided for @confirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel?'**
  String get confirmCancel;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this?'**
  String get confirmDelete;

  /// No description provided for @confirmUnsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Are you sure you want to leave?'**
  String get confirmUnsavedChanges;

  /// No description provided for @aboutPageBody.
  ///
  /// In en, this message translates to:
  /// **'HealthBank is a secure personal health data platform developed at the University of Prince Edward Island (UPEI). It connects participants, healthcare professionals, and researchers in a privacy-compliant environment for approved health research.\n\nParticipants can complete health surveys and contribute data to research projects they have consented to. Healthcare professionals can monitor the participation and health data of patients under their care. Researchers access only aggregated, de-identified results — individual participant data is never exposed in research outputs.\n\nAll data collection is governed by informed consent and conducted in accordance with Canadian federal and applicable provincial privacy legislation, including PIPEDA and PHIPA. HealthBank is an academic initiative committed to advancing health research for the benefit of all Canadians.'**
  String get aboutPageBody;

  /// No description provided for @aboutPageTitle.
  ///
  /// In en, this message translates to:
  /// **'About HealthBank'**
  String get aboutPageTitle;

  /// No description provided for @contactSupportEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Support Email'**
  String get contactSupportEmailLabel;

  /// No description provided for @contactSupportHoursLabel.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get contactSupportHoursLabel;

  /// No description provided for @contactSupportHoursValue.
  ///
  /// In en, this message translates to:
  /// **'Monday to Friday, 9:00 AM - 5:00 PM (ET)'**
  String get contactSupportHoursValue;

  /// No description provided for @contactSupportIntro.
  ///
  /// In en, this message translates to:
  /// **'Reach our support team for account help, technical issues, or general questions about HealthBank.'**
  String get contactSupportIntro;

  /// No description provided for @contactSupportNote.
  ///
  /// In en, this message translates to:
  /// **'Include your account email and a short summary of the issue so we can respond faster.'**
  String get contactSupportNote;

  /// No description provided for @footerHelpAndServices.
  ///
  /// In en, this message translates to:
  /// **'Help & Services'**
  String get footerHelpAndServices;

  /// No description provided for @footerHowToUse.
  ///
  /// In en, this message translates to:
  /// **'How to Use HealthBank'**
  String get footerHowToUse;

  /// No description provided for @footerLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get footerLegal;

  /// No description provided for @footerPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get footerPrivacy;

  /// No description provided for @footerTermsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get footerTermsOfUse;

  /// No description provided for @helpFaq1Body.
  ///
  /// In en, this message translates to:
  /// **'Accounts are created by a HealthBank administrator or healthcare professional. If you believe you should have access, contact your healthcare provider or the research coordinator overseeing your study. You will receive an email with instructions to set up your password and complete your profile.'**
  String get helpFaq1Body;

  /// No description provided for @helpFaq1Title.
  ///
  /// In en, this message translates to:
  /// **'How do I create an account?'**
  String get helpFaq1Title;

  /// No description provided for @helpFaq2Body.
  ///
  /// In en, this message translates to:
  /// **'After signing in, navigate to the Surveys section from your dashboard. Select an available survey and follow the on-screen instructions. Your responses are saved automatically as you progress, and you can return to an incomplete survey at any time. Contact your study coordinator if you have questions about a specific survey.'**
  String get helpFaq2Body;

  /// No description provided for @helpFaq2Title.
  ///
  /// In en, this message translates to:
  /// **'How do I complete a health survey?'**
  String get helpFaq2Title;

  /// No description provided for @helpFaq3Body.
  ///
  /// In en, this message translates to:
  /// **'Your personal health data is strictly confidential. Only your assigned healthcare professional and authorized administrators can view your individual responses. Researchers access only aggregated, de-identified data — your name and personal details are never visible in research results. See our Privacy Policy for full details.'**
  String get helpFaq3Body;

  /// No description provided for @helpFaq3Title.
  ///
  /// In en, this message translates to:
  /// **'Who can see my data?'**
  String get helpFaq3Title;

  /// No description provided for @homePagePlaceHolderText.
  ///
  /// In en, this message translates to:
  /// **'HealthBank is a secure, privacy-first platform for personal health data collection and research. Participants complete surveys and share health data to support meaningful research. Healthcare professionals monitor patient participation. Researchers access aggregated, de-identified results — never individual records.\n\nAll data is collected under informed consent and protected in accordance with Canadian privacy law (PIPEDA). Sign in to access your dashboard, or request an account to join the HealthBank community.'**
  String get homePagePlaceHolderText;

  /// No description provided for @a11ySkipToContent.
  ///
  /// In en, this message translates to:
  /// **'Skip to main content'**
  String get a11ySkipToContent;

  /// No description provided for @accessibilitySkipToMain.
  ///
  /// In en, this message translates to:
  /// **'Skip to main content'**
  String get accessibilitySkipToMain;

  /// No description provided for @changePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordButton;

  /// No description provided for @changePasswordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get changePasswordConfirm;

  /// No description provided for @changePasswordCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get changePasswordCurrent;

  /// No description provided for @changePasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get changePasswordMinLength;

  /// No description provided for @changePasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get changePasswordMismatch;

  /// No description provided for @changePasswordNew.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get changePasswordNew;

  /// No description provided for @changePasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get changePasswordRequired;

  /// No description provided for @changePasswordSameAsOld.
  ///
  /// In en, this message translates to:
  /// **'New password must be different from current password'**
  String get changePasswordSameAsOld;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You must change your password before continuing'**
  String get changePasswordSubtitle;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get changePasswordSuccess;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @chartNoData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get chartNoData;

  /// No description provided for @chartTableCount.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get chartTableCount;

  /// No description provided for @chartTableLabel.
  ///
  /// In en, this message translates to:
  /// **'{title} — data table'**
  String chartTableLabel(String title);

  /// No description provided for @chartTableOption.
  ///
  /// In en, this message translates to:
  /// **'Option'**
  String get chartTableOption;

  /// No description provided for @chartTablePercent.
  ///
  /// In en, this message translates to:
  /// **'Percent'**
  String get chartTablePercent;

  /// No description provided for @cookieAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get cookieAccept;

  /// No description provided for @cookieBody.
  ///
  /// In en, this message translates to:
  /// **'This website uses essential cookies to maintain secure login sessions. By continuing to use the site you agree to the use of these cookies.'**
  String get cookieBody;

  /// No description provided for @cookieTitle.
  ///
  /// In en, this message translates to:
  /// **'Cookies'**
  String get cookieTitle;

  /// No description provided for @dashboardGraphClearSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get dashboardGraphClearSelection;

  /// No description provided for @dashboardGraphMyResults.
  ///
  /// In en, this message translates to:
  /// **'My Results'**
  String get dashboardGraphMyResults;

  /// No description provided for @dashboardGraphNoCompletedSurveys.
  ///
  /// In en, this message translates to:
  /// **'No completed surveys yet. Complete a survey to see your data here.'**
  String get dashboardGraphNoCompletedSurveys;

  /// No description provided for @dashboardGraphNoSelection.
  ///
  /// In en, this message translates to:
  /// **'Select a survey and question to view your data'**
  String get dashboardGraphNoSelection;

  /// No description provided for @dashboardGraphQuestionLabel.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get dashboardGraphQuestionLabel;

  /// No description provided for @dashboardGraphSelectQuestion.
  ///
  /// In en, this message translates to:
  /// **'Select a Question'**
  String get dashboardGraphSelectQuestion;

  /// No description provided for @dashboardGraphSelectSurvey.
  ///
  /// In en, this message translates to:
  /// **'Select a Survey'**
  String get dashboardGraphSelectSurvey;

  /// No description provided for @dashboardGraphSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Chart Settings'**
  String get dashboardGraphSettingsTitle;

  /// No description provided for @dashboardGraphSurveyLabel.
  ///
  /// In en, this message translates to:
  /// **'Survey'**
  String get dashboardGraphSurveyLabel;

  /// No description provided for @deactivatedNoticeMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deactivated. If you believe this is a mistake, please contact support.'**
  String get deactivatedNoticeMessage;

  /// No description provided for @deactivatedNoticeReturnToLogin.
  ///
  /// In en, this message translates to:
  /// **'Return to Login'**
  String get deactivatedNoticeReturnToLogin;

  /// No description provided for @deactivatedNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Deactivated'**
  String get deactivatedNoticeTitle;

  /// No description provided for @headerMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get headerMenu;

  /// No description provided for @headerUnreadNotifications.
  ///
  /// In en, this message translates to:
  /// **'Unread notifications'**
  String get headerUnreadNotifications;

  /// No description provided for @maintenanceBannerMessage.
  ///
  /// In en, this message translates to:
  /// **'The System is Currently Down for Maintenance which is expected to be completed by {time}. We apologize for any inconvenience.'**
  String maintenanceBannerMessage(String time);

  /// No description provided for @maintenanceBannerMessageNoTime.
  ///
  /// In en, this message translates to:
  /// **'The System is Currently Down for Maintenance. We apologize for any inconvenience.'**
  String get maintenanceBannerMessageNoTime;

  /// No description provided for @maintenanceBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'System Under Maintenance'**
  String get maintenanceBannerTitle;

  /// No description provided for @notFound404Heading.
  ///
  /// In en, this message translates to:
  /// **'404 - Page Not Found'**
  String get notFound404Heading;

  /// No description provided for @notFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'The page you are looking for does not exist.'**
  String get notFoundDescription;

  /// No description provided for @notFoundPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Page Not Found'**
  String get notFoundPageTitle;

  /// No description provided for @paginationPageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String paginationPageOf(int current, int total);

  /// No description provided for @reorderMoveDown.
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get reorderMoveDown;

  /// No description provided for @reorderMoveUp.
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get reorderMoveUp;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleHcp.
  ///
  /// In en, this message translates to:
  /// **'Healthcare Professional'**
  String get roleHcp;

  /// No description provided for @roleParticipant.
  ///
  /// In en, this message translates to:
  /// **'Participant'**
  String get roleParticipant;

  /// No description provided for @roleResearcher.
  ///
  /// In en, this message translates to:
  /// **'Researcher'**
  String get roleResearcher;

  /// No description provided for @semanticLogoNavigate.
  ///
  /// In en, this message translates to:
  /// **'HealthBank logo, navigate to dashboard'**
  String get semanticLogoNavigate;

  /// No description provided for @sessionExpiryExtend.
  ///
  /// In en, this message translates to:
  /// **'Stay Logged In'**
  String get sessionExpiryExtend;

  /// No description provided for @sessionExpiryExtended.
  ///
  /// In en, this message translates to:
  /// **'Session extended.'**
  String get sessionExpiryExtended;

  /// No description provided for @sessionExpiryLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get sessionExpiryLogout;

  /// No description provided for @sessionExpiryMessage.
  ///
  /// In en, this message translates to:
  /// **'Your session will expire in 5 minutes. Would you like to stay logged in?'**
  String get sessionExpiryMessage;

  /// No description provided for @sessionExpiryTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Expiring Soon'**
  String get sessionExpiryTitle;

  /// No description provided for @themePresetClassicCream.
  ///
  /// In en, this message translates to:
  /// **'Classic Cream'**
  String get themePresetClassicCream;

  /// No description provided for @themePresetClassicCreamDesc.
  ///
  /// In en, this message translates to:
  /// **'Warm ivory chrome'**
  String get themePresetClassicCreamDesc;

  /// No description provided for @themePresetClassicGrey.
  ///
  /// In en, this message translates to:
  /// **'Classic Grey'**
  String get themePresetClassicGrey;

  /// No description provided for @themePresetClassicGreyDesc.
  ///
  /// In en, this message translates to:
  /// **'Cool grey chrome'**
  String get themePresetClassicGreyDesc;

  /// No description provided for @themePresetDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themePresetDark;

  /// No description provided for @themePresetDarkDesc.
  ///
  /// In en, this message translates to:
  /// **'Modern dark mode'**
  String get themePresetDarkDesc;

  /// No description provided for @themePresetModern.
  ///
  /// In en, this message translates to:
  /// **'Modern'**
  String get themePresetModern;

  /// No description provided for @themePresetModernDesc.
  ///
  /// In en, this message translates to:
  /// **'Clean flat light'**
  String get themePresetModernDesc;

  /// No description provided for @tooltipBarChart.
  ///
  /// In en, this message translates to:
  /// **'Bar chart'**
  String get tooltipBarChart;

  /// No description provided for @tooltipClearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear filter'**
  String get tooltipClearFilter;

  /// No description provided for @tooltipClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get tooltipClearSearch;

  /// No description provided for @tooltipClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get tooltipClose;

  /// No description provided for @tooltipCloseModal.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get tooltipCloseModal;

  /// No description provided for @tooltipCollapseSidebar.
  ///
  /// In en, this message translates to:
  /// **'Collapse sidebar'**
  String get tooltipCollapseSidebar;

  /// No description provided for @tooltipDismissNotification.
  ///
  /// In en, this message translates to:
  /// **'Dismiss notification'**
  String get tooltipDismissNotification;

  /// No description provided for @tooltipExpandSidebar.
  ///
  /// In en, this message translates to:
  /// **'Expand sidebar'**
  String get tooltipExpandSidebar;

  /// No description provided for @tooltipGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get tooltipGoBack;

  /// No description provided for @tooltipLineChart.
  ///
  /// In en, this message translates to:
  /// **'Line chart'**
  String get tooltipLineChart;

  /// No description provided for @tooltipNextPage.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get tooltipNextPage;

  /// No description provided for @tooltipPickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick date'**
  String get tooltipPickDate;

  /// No description provided for @tooltipPickTime.
  ///
  /// In en, this message translates to:
  /// **'Pick time'**
  String get tooltipPickTime;

  /// No description provided for @tooltipPieChart.
  ///
  /// In en, this message translates to:
  /// **'Pie chart'**
  String get tooltipPieChart;

  /// No description provided for @tooltipPreviousPage.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get tooltipPreviousPage;

  /// No description provided for @tooltipRemoveOption.
  ///
  /// In en, this message translates to:
  /// **'Remove option'**
  String get tooltipRemoveOption;

  /// No description provided for @tooltipTableView.
  ///
  /// In en, this message translates to:
  /// **'Table view'**
  String get tooltipTableView;

  /// No description provided for @tooltipTogglePasswordVisibility.
  ///
  /// In en, this message translates to:
  /// **'Toggle password visibility'**
  String get tooltipTogglePasswordVisibility;

  /// No description provided for @auth2faCodeHint.
  ///
  /// In en, this message translates to:
  /// **'123456'**
  String get auth2faCodeHint;

  /// No description provided for @auth2faConfirm2fa.
  ///
  /// In en, this message translates to:
  /// **'Confirm 2FA'**
  String get auth2faConfirm2fa;

  /// No description provided for @auth2faEnrollAndRetrieveProvisioningUri.
  ///
  /// In en, this message translates to:
  /// **'Enroll your account and retrieve the provisioning URI (used for QR code).'**
  String get auth2faEnrollAndRetrieveProvisioningUri;

  /// No description provided for @auth2faEnrollApi.
  ///
  /// In en, this message translates to:
  /// **'Enroll'**
  String get auth2faEnrollApi;

  /// No description provided for @auth2faEnterCodeFromAuthenticator.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code from your authenticator app'**
  String get auth2faEnterCodeFromAuthenticator;

  /// No description provided for @auth2faEnterCodeToFinishSignin.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code to finish signing in.'**
  String get auth2faEnterCodeToFinishSignin;

  /// No description provided for @auth2faErrorEnrollFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to enroll 2FA. Please try again.'**
  String get auth2faErrorEnrollFailed;

  /// No description provided for @auth2faErrorVerifyFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to verify 2FA. Please try again.'**
  String get auth2faErrorVerifyFailed;

  /// No description provided for @auth2faPleaseLoginFirstToEnroll.
  ///
  /// In en, this message translates to:
  /// **'Please log in first to enroll 2FA.'**
  String get auth2faPleaseLoginFirstToEnroll;

  /// No description provided for @auth2faTitle.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication (2FA)'**
  String get auth2faTitle;

  /// No description provided for @auth2faVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get auth2faVerify;

  /// No description provided for @authEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get authEmailInvalid;

  /// No description provided for @authEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address.'**
  String get authEmailRequired;

  /// No description provided for @authForgotPasswordBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get authForgotPasswordBackToLogin;

  /// No description provided for @authForgotPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get authForgotPasswordButton;

  /// No description provided for @authForgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a password reset link'**
  String get authForgotPasswordSubtitle;

  /// No description provided for @authForgotPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to your email'**
  String get authForgotPasswordSuccess;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get authForgotPasswordTitle;

  /// No description provided for @authLoggingIn.
  ///
  /// In en, this message translates to:
  /// **'Logging In...'**
  String get authLoggingIn;

  /// No description provided for @authLoggingOut.
  ///
  /// In en, this message translates to:
  /// **'Logging Out...'**
  String get authLoggingOut;

  /// No description provided for @authLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get authLoginButton;

  /// No description provided for @authLoginEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authLoginEmail;

  /// No description provided for @authLoginError.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get authLoginError;

  /// No description provided for @authLoginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authLoginForgotPassword;

  /// No description provided for @authLoginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authLoginNoAccount;

  /// No description provided for @authLoginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authLoginPassword;

  /// No description provided for @authLoginRememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get authLoginRememberMe;

  /// No description provided for @authLoginSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authLoginSignUp;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your credentials to access your account'**
  String get authLoginSubtitle;

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get authLoginTitle;

  /// No description provided for @authLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get authLogout;

  /// No description provided for @authLogoutMessage.
  ///
  /// In en, this message translates to:
  /// **'You have been successfully logged out.\nPlease click the Return button to\nreturn to the Log In page.'**
  String get authLogoutMessage;

  /// No description provided for @authLogoutReturn.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get authLogoutReturn;

  /// No description provided for @authLogoutReturnToLogin.
  ///
  /// In en, this message translates to:
  /// **'Return to Login'**
  String get authLogoutReturnToLogin;

  /// No description provided for @authLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout Successful'**
  String get authLogoutTitle;

  /// No description provided for @authMaintenanceModeAdminNote.
  ///
  /// In en, this message translates to:
  /// **'Administrator accounts may still log in.'**
  String get authMaintenanceModeAdminNote;

  /// No description provided for @authMaintenanceModeDefaultMessage.
  ///
  /// In en, this message translates to:
  /// **'The system is temporarily unavailable for scheduled maintenance.'**
  String get authMaintenanceModeDefaultMessage;

  /// No description provided for @authMaintenanceModeLoginError.
  ///
  /// In en, this message translates to:
  /// **'System is under maintenance. Only administrators can log in at this time.'**
  String get authMaintenanceModeLoginError;

  /// No description provided for @authMaintenanceModeTitle.
  ///
  /// In en, this message translates to:
  /// **'System Maintenance'**
  String get authMaintenanceModeTitle;

  /// No description provided for @authNewHereRequestAccount.
  ///
  /// In en, this message translates to:
  /// **'New Here? Request An Account'**
  String get authNewHereRequestAccount;

  /// No description provided for @authNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get authNotifications;

  /// No description provided for @authPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get authPasswordRequired;

  /// No description provided for @authPleaseLogIn.
  ///
  /// In en, this message translates to:
  /// **'Please log in to continue.'**
  String get authPleaseLogIn;

  /// No description provided for @authProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get authProfile;

  /// No description provided for @authRegisterButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authRegisterButton;

  /// No description provided for @authRegisterConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authRegisterConfirmPassword;

  /// No description provided for @authRegisterFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get authRegisterFirstName;

  /// No description provided for @authRegisterHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authRegisterHaveAccount;

  /// No description provided for @authRegisterLastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get authRegisterLastName;

  /// No description provided for @authRegisterLogin.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get authRegisterLogin;

  /// No description provided for @authRegisterPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authRegisterPasswordMismatch;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your details to create an account'**
  String get authRegisterSubtitle;

  /// No description provided for @authRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authRegisterTitle;

  /// No description provided for @authResetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetPasswordButton;

  /// No description provided for @authResetPasswordConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get authResetPasswordConfirmPassword;

  /// No description provided for @authResetPasswordConfirmRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get authResetPasswordConfirmRequired;

  /// No description provided for @authResetPasswordInvalidLinkMessage.
  ///
  /// In en, this message translates to:
  /// **'This password reset link is invalid or has expired. Please request a new one.'**
  String get authResetPasswordInvalidLinkMessage;

  /// No description provided for @authResetPasswordInvalidLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Invalid Reset Link'**
  String get authResetPasswordInvalidLinkTitle;

  /// No description provided for @authResetPasswordNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get authResetPasswordNewPassword;

  /// No description provided for @authResetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get authResetPasswordSubtitle;

  /// No description provided for @authResetPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successful'**
  String get authResetPasswordSuccess;

  /// No description provided for @authResetPasswordSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your password has been successfully reset.'**
  String get authResetPasswordSuccessMessage;

  /// No description provided for @authResetPasswordSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Reset Successful'**
  String get authResetPasswordSuccessTitle;

  /// No description provided for @authResetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetPasswordTitle;

  /// No description provided for @authSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get authSettings;

  /// No description provided for @authWelcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welcome to HealthBank.'**
  String get authWelcomeTo;

  /// No description provided for @accountEditError404.
  ///
  /// In en, this message translates to:
  /// **'Account not found. It may have been deleted.'**
  String get accountEditError404;

  /// No description provided for @accountEditError409.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use by another account.'**
  String get accountEditError409;

  /// No description provided for @accountEditError422.
  ///
  /// In en, this message translates to:
  /// **'Invalid data. Please check all fields.'**
  String get accountEditError422;

  /// No description provided for @accountEditErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get accountEditErrorNetwork;

  /// No description provided for @accountEditErrorServer.
  ///
  /// In en, this message translates to:
  /// **'A server error occurred. Please try again.'**
  String get accountEditErrorServer;

  /// No description provided for @accountEditSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get accountEditSaving;

  /// No description provided for @accountEditSuccess.
  ///
  /// In en, this message translates to:
  /// **'User updated successfully.'**
  String get accountEditSuccess;

  /// No description provided for @accountEditValidationEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get accountEditValidationEmail;

  /// No description provided for @accountEditValidationName.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty.'**
  String get accountEditValidationName;

  /// No description provided for @requestAccountBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get requestAccountBackToLogin;

  /// No description provided for @requestAccountBirthdate.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get requestAccountBirthdate;

  /// No description provided for @requestAccountDuplicateEmail.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists'**
  String get requestAccountDuplicateEmail;

  /// No description provided for @requestAccountDuplicatePending.
  ///
  /// In en, this message translates to:
  /// **'A request for this email is already pending'**
  String get requestAccountDuplicatePending;

  /// No description provided for @requestAccountEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get requestAccountEmail;

  /// No description provided for @requestAccountEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get requestAccountEmailRequired;

  /// No description provided for @requestAccountError.
  ///
  /// In en, this message translates to:
  /// **'Unable to submit request. Please try again.'**
  String get requestAccountError;

  /// No description provided for @requestAccountFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get requestAccountFirstName;

  /// No description provided for @requestAccountFirstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get requestAccountFirstNameRequired;

  /// No description provided for @requestAccountGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get requestAccountGender;

  /// No description provided for @requestAccountGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get requestAccountGenderFemale;

  /// No description provided for @requestAccountGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get requestAccountGenderMale;

  /// No description provided for @requestAccountGenderNonBinary.
  ///
  /// In en, this message translates to:
  /// **'Non-Binary'**
  String get requestAccountGenderNonBinary;

  /// No description provided for @requestAccountGenderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get requestAccountGenderOther;

  /// No description provided for @requestAccountGenderOtherSpecify.
  ///
  /// In en, this message translates to:
  /// **'Please specify'**
  String get requestAccountGenderOtherSpecify;

  /// No description provided for @requestAccountGenderPreferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer Not to Say'**
  String get requestAccountGenderPreferNotToSay;

  /// No description provided for @requestAccountLastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get requestAccountLastName;

  /// No description provided for @requestAccountLastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get requestAccountLastNameRequired;

  /// No description provided for @requestAccountRole.
  ///
  /// In en, this message translates to:
  /// **'Select Role'**
  String get requestAccountRole;

  /// No description provided for @requestAccountRoleHcp.
  ///
  /// In en, this message translates to:
  /// **'Healthcare Provider'**
  String get requestAccountRoleHcp;

  /// No description provided for @requestAccountRoleParticipant.
  ///
  /// In en, this message translates to:
  /// **'Participant'**
  String get requestAccountRoleParticipant;

  /// No description provided for @requestAccountRoleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a role'**
  String get requestAccountRoleRequired;

  /// No description provided for @requestAccountRoleResearcher.
  ///
  /// In en, this message translates to:
  /// **'Researcher'**
  String get requestAccountRoleResearcher;

  /// No description provided for @requestAccountSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get requestAccountSubmit;

  /// No description provided for @requestAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fill out this form to request an account'**
  String get requestAccountSubtitle;

  /// No description provided for @requestAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your request has been submitted. You will receive an email when your account is approved.'**
  String get requestAccountSuccess;

  /// No description provided for @requestAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Account'**
  String get requestAccountTitle;

  /// No description provided for @requestAccountTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please try again later.'**
  String get requestAccountTooManyRequests;

  /// No description provided for @resetPasswordCopied.
  ///
  /// In en, this message translates to:
  /// **'Password copied to clipboard'**
  String get resetPasswordCopied;

  /// No description provided for @resetPasswordCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get resetPasswordCopy;

  /// No description provided for @resetPasswordEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get resetPasswordEmailAddress;

  /// No description provided for @resetPasswordEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter alternate email'**
  String get resetPasswordEmailHint;

  /// No description provided for @resetPasswordEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get resetPasswordEmailInvalid;

  /// No description provided for @resetPasswordEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get resetPasswordEmailRequired;

  /// No description provided for @resetPasswordEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Email the temporary password to the user'**
  String get resetPasswordEmailSubtitle;

  /// No description provided for @resetPasswordGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate random password'**
  String get resetPasswordGenerate;

  /// No description provided for @resetPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter password or generate'**
  String get resetPasswordHint;

  /// No description provided for @resetPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get resetPasswordMinLength;

  /// No description provided for @resetPasswordModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordModalTitle;

  /// No description provided for @resetPasswordNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get resetPasswordNewPassword;

  /// No description provided for @resetPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get resetPasswordRequired;

  /// No description provided for @resetPasswordResetting.
  ///
  /// In en, this message translates to:
  /// **'Resetting...'**
  String get resetPasswordResetting;

  /// No description provided for @resetPasswordSendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send email notification'**
  String get resetPasswordSendEmail;

  /// No description provided for @resetPasswordSuccessEmail.
  ///
  /// In en, this message translates to:
  /// **'Password reset and email sent successfully'**
  String get resetPasswordSuccessEmail;

  /// No description provided for @resetPasswordSuccessNoEmail.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully'**
  String get resetPasswordSuccessNoEmail;

  /// No description provided for @resetPasswordUseAlternate.
  ///
  /// In en, this message translates to:
  /// **'Use alternate email'**
  String get resetPasswordUseAlternate;

  /// No description provided for @profileBirthdate.
  ///
  /// In en, this message translates to:
  /// **'Birthdate'**
  String get profileBirthdate;

  /// No description provided for @profileCompletionBirthdate.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get profileCompletionBirthdate;

  /// No description provided for @profileCompletionBirthdateRequired.
  ///
  /// In en, this message translates to:
  /// **'Date of birth is required'**
  String get profileCompletionBirthdateRequired;

  /// No description provided for @profileCompletionError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile. Please try again.'**
  String get profileCompletionError;

  /// No description provided for @profileCompletionGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get profileCompletionGender;

  /// No description provided for @profileCompletionGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get profileCompletionGenderFemale;

  /// No description provided for @profileCompletionGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get profileCompletionGenderMale;

  /// No description provided for @profileCompletionGenderNonBinary.
  ///
  /// In en, this message translates to:
  /// **'Non-Binary'**
  String get profileCompletionGenderNonBinary;

  /// No description provided for @profileCompletionGenderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get profileCompletionGenderOther;

  /// No description provided for @profileCompletionGenderPreferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer Not to Say'**
  String get profileCompletionGenderPreferNotToSay;

  /// No description provided for @profileCompletionGenderRequired.
  ///
  /// In en, this message translates to:
  /// **'Gender selection is required'**
  String get profileCompletionGenderRequired;

  /// No description provided for @profileCompletionSubmit.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get profileCompletionSubmit;

  /// No description provided for @profileCompletionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please provide the following information to complete your account setup.'**
  String get profileCompletionSubtitle;

  /// No description provided for @profileCompletionTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile'**
  String get profileCompletionTitle;

  /// No description provided for @profileEditInformation.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get profileEditInformation;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profileEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get profileEmailInvalid;

  /// No description provided for @profileEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get profileEmailRequired;

  /// No description provided for @profileFirstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get profileFirstName;

  /// No description provided for @profileFirstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get profileFirstNameRequired;

  /// No description provided for @profileGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get profileGender;

  /// No description provided for @profileLastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get profileLastName;

  /// No description provided for @profileLastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get profileLastNameRequired;

  /// No description provided for @profileLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile.'**
  String get profileLoadError;

  /// No description provided for @profileRole.
  ///
  /// In en, this message translates to:
  /// **'Role: {role}'**
  String profileRole(String role);

  /// No description provided for @profileSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get profileSaveChanges;

  /// No description provided for @profileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your personal account information'**
  String get profileSubtitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile.'**
  String get profileUpdateError;

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully.'**
  String get profileUpdateSuccess;

  /// No description provided for @navAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get navAbout;

  /// No description provided for @navAccountRequests.
  ///
  /// In en, this message translates to:
  /// **'Account Requests'**
  String get navAccountRequests;

  /// No description provided for @navAuditLog.
  ///
  /// In en, this message translates to:
  /// **'Audit Log'**
  String get navAuditLog;

  /// No description provided for @navBackup.
  ///
  /// In en, this message translates to:
  /// **'Database Backups'**
  String get navBackup;

  /// No description provided for @navChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get navChangePassword;

  /// No description provided for @navClients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get navClients;

  /// No description provided for @navCompleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete Profile'**
  String get navCompleteProfile;

  /// No description provided for @navConsent.
  ///
  /// In en, this message translates to:
  /// **'Consent'**
  String get navConsent;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navDashboardV2.
  ///
  /// In en, this message translates to:
  /// **'Dashboard v2'**
  String get navDashboardV2;

  /// No description provided for @navData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get navData;

  /// No description provided for @navDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get navDatabase;

  /// No description provided for @navDatabaseViewer.
  ///
  /// In en, this message translates to:
  /// **'Database Viewer'**
  String get navDatabaseViewer;

  /// No description provided for @navDeletionQueue.
  ///
  /// In en, this message translates to:
  /// **'Deletion Queue'**
  String get navDeletionQueue;

  /// No description provided for @navErrorPage.
  ///
  /// In en, this message translates to:
  /// **'Error Page'**
  String get navErrorPage;

  /// No description provided for @navForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get navForgotPassword;

  /// No description provided for @navFriends.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get navFriends;

  /// No description provided for @navHealthTracking.
  ///
  /// In en, this message translates to:
  /// **'Health Tracking'**
  String get navHealthTracking;

  /// No description provided for @navHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get navHelp;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get navLogin;

  /// No description provided for @navMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get navMessages;

  /// No description provided for @navMySurveys.
  ///
  /// In en, this message translates to:
  /// **'My Surveys'**
  String get navMySurveys;

  /// No description provided for @navNewMessage.
  ///
  /// In en, this message translates to:
  /// **'New Message'**
  String get navNewMessage;

  /// No description provided for @navNewSurvey.
  ///
  /// In en, this message translates to:
  /// **'New Survey'**
  String get navNewSurvey;

  /// No description provided for @navNewTemplate.
  ///
  /// In en, this message translates to:
  /// **'New Template'**
  String get navNewTemplate;

  /// No description provided for @navPageNavigator.
  ///
  /// In en, this message translates to:
  /// **'Page Navigator'**
  String get navPageNavigator;

  /// No description provided for @navParticipants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get navParticipants;

  /// No description provided for @navQuestionBank.
  ///
  /// In en, this message translates to:
  /// **'Question Bank'**
  String get navQuestionBank;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @navRequestAccount.
  ///
  /// In en, this message translates to:
  /// **'Request Account'**
  String get navRequestAccount;

  /// No description provided for @navResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get navResetPassword;

  /// No description provided for @navResults.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get navResults;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navSurveys.
  ///
  /// In en, this message translates to:
  /// **'Surveys'**
  String get navSurveys;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'To-Do'**
  String get navTasks;

  /// No description provided for @navTemplates.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get navTemplates;

  /// No description provided for @navTickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get navTickets;

  /// No description provided for @navUiTest.
  ///
  /// In en, this message translates to:
  /// **'UI Test'**
  String get navUiTest;

  /// No description provided for @navUserManagement.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get navUserManagement;

  /// No description provided for @consentCheckboxLabel.
  ///
  /// In en, this message translates to:
  /// **'I have read, understand, and agree to the terms of this consent form.'**
  String get consentCheckboxLabel;

  /// No description provided for @consentDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get consentDateLabel;

  /// No description provided for @consentDocumentHcp.
  ///
  /// In en, this message translates to:
  /// **'HEALTHCARE PROFESSIONAL DATA ACCESS AND CONFIDENTIALITY AGREEMENT\n\nPlatform: HealthBank — Personal Health Data Collection and Research Platform\n\n1. PROFESSIONAL OBLIGATIONS\n\nAs a Healthcare Professional (HCP) accessing the HealthBank platform, you acknowledge that you are bound by both this agreement and the professional standards and regulations governing your practice, including those of your regulatory college or association. Your obligations under this agreement are in addition to, and do not replace, your existing professional duties of confidentiality.\n\n2. DATA ACCESS LIMITATIONS\n\nYour access to participant data through HealthBank is strictly limited to:\n- Data directly relevant to the care of patients under your supervision\n- Aggregated research data as authorized by your institutional agreement\n- Information necessary for clinical decision-making within your scope of practice\n\nYou must not access data for patients who are not under your care, or for purposes unrelated to authorized clinical or research activities.\n\n3. CONFIDENTIALITY DUTY\n\nYou agree to maintain absolute confidentiality regarding all participant data accessed through this platform. This duty of confidentiality:\n- Is in addition to your professional obligations under your regulatory body\n- Continues indefinitely, even after you cease using the platform\n- Extends to all forms of data, whether digital, verbal, or written\n- Applies in all contexts, including conversations with colleagues not involved in the participant\'s care\n\n4. BREACH REPORTING\n\nYou are legally and professionally obligated to immediately report any suspected or actual data breach, including:\n- Unauthorized access to patient data\n- Accidental disclosure of identifiable health information\n- Loss or theft of devices used to access the platform\n- Suspicious activity observed on the platform\n\nReports must be made to the HealthBank Privacy Officer within 24 hours of discovery. Failure to report a breach is itself a violation of this agreement and may constitute professional misconduct.\n\n5. LIABILITY ACKNOWLEDGMENT\n\nYou acknowledge that:\n- You are personally liable for any unauthorized access or disclosure of participant data\n- Your institution may also bear liability for breaches occurring within their systems\n- Insurance coverage may not apply to intentional or grossly negligent breaches\n- Participants have the right to seek damages for unauthorized disclosure of their health information\n\n6. REGULATORY COMPLIANCE\n\nYou confirm that you will comply with all applicable privacy and health information legislation, including:\n- PHIPA (Personal Health Information Protection Act)\n- PIPEDA (Personal Information Protection and Electronic Documents Act)\n- Professional standards of your regulatory college\n- Institutional privacy and data handling policies\n\n7. DISCLOSURE EXCEPTIONS\n\nYou may disclose participant information without consent only where required or permitted by law, including:\n- Where required by court order or subpoena\n- To prevent imminent harm to the participant or others\n- Where required by mandatory reporting legislation (e.g., child protection)\n- As required by your professional regulatory body during an investigation\n\nIn all such cases, you must document the disclosure and notify the HealthBank Privacy Officer.\n\n8. CONSEQUENCES OF VIOLATION\n\nViolation of this agreement may result in:\n- Immediate revocation of platform access\n- Reporting to your professional regulatory body\n- Disciplinary proceedings which may include suspension or revocation of licensure\n- Civil liability for damages to affected participants\n- Penalties under PHIPA/PIPEDA (fines up to \$100,000 per violation)\n- Criminal prosecution in cases of willful or malicious breach\n\nBy checking the agreement box below, you confirm that you have read, understood, and agree to all terms of this confidentiality agreement.'**
  String get consentDocumentHcp;

  /// No description provided for @consentDocumentParticipant.
  ///
  /// In en, this message translates to:
  /// **'PARTICIPANT INFORMED CONSENT FORM\n\nStudy Title: HealthBank — Personal Health Data Collection and Research Platform\n\n1. PURPOSE OF THIS STUDY\n\nYou are being invited to participate in a research study conducted through the HealthBank platform. The purpose of this study is to collect personal health information from participants to support health research, data analysis, and the improvement of healthcare outcomes. Your participation is entirely voluntary.\n\n2. TYPES OF DATA COLLECTED\n\nAs a participant, the following types of information may be collected from you:\n- Demographic information (name, date of birth, gender)\n- Health survey responses (physical health, mental health, lifestyle, symptoms)\n- Survey completion data (timestamps, response patterns)\n- Technical data (IP address, browser information) for security purposes\n\n3. HOW YOUR DATA WILL BE USED\n\nYour data will be used for the following purposes:\n- Health research conducted by authorized researchers\n- Statistical analysis and aggregation to identify health trends\n- Improvement of healthcare services and outcomes\n- Academic publication (only aggregated, de-identified data)\n\nYour individual responses will never be published or shared in a way that could identify you. All research outputs use aggregated data with a minimum of 5 respondents (k-anonymity) to prevent identification.\n\n4. WHO HAS ACCESS TO YOUR DATA\n\nAccess to your data is strictly controlled:\n- Researchers: Access only to aggregated, de-identified data through the research portal\n- Healthcare Professionals (HCPs): Access limited to data relevant to your care\n- System Administrators: Technical access for platform maintenance only\n- No third parties will receive your individual data without your explicit consent\n\n5. DATA RETENTION\n\nYour data will be retained for the duration of the research program. After the program concludes, data will be securely archived or destroyed in accordance with institutional data retention policies. You may request information about data retention timelines at any time.\n\n6. YOUR RIGHT TO WITHDRAW\n\nYou have the right to withdraw your consent at any time without penalty or loss of benefits. To withdraw, contact the Privacy Officer at the contact information provided below. Upon withdrawal:\n- No new data will be collected from you\n- Your account will be deactivated\n- However, data that has already been included in completed analyses or published research cannot be removed, as it has been aggregated and de-identified\n\n7. DATA PERSISTENCE AFTER WITHDRAWAL\n\nPlease be aware that while we will cease collecting new data upon withdrawal, any data that has already been shared with researchers in aggregated form cannot be recalled or removed from completed analyses. This is a necessary limitation of research data that has already been processed.\n\n8. RISKS AND SAFEGUARDS\n\nWhile every effort is made to protect your data, no system is completely without risk. Potential risks include:\n- Unauthorized access despite security measures\n- Re-identification through combination with external data sources\n\nTo mitigate these risks, we employ:\n- Industry-standard encryption for data in transit and at rest\n- Role-based access controls limiting who can see what data\n- K-anonymity thresholds (minimum 5 respondents) for all research outputs\n- Regular security audits and monitoring\n- Secure session management with automatic expiration\n\n9. CONFIDENTIALITY MEASURES\n\nYour information is protected by:\n- Encrypted data storage and transmission\n- Strict access controls based on role and need\n- Audit logging of all data access\n- Compliance with PIPEDA (Personal Information Protection and Electronic Documents Act) and PHIPA (Personal Health Information Protection Act)\n- Adherence to TCPS 2 (Tri-Council Policy Statement: Ethical Conduct for Research Involving Humans)\n\n10. CONTACT INFORMATION\n\nIf you have questions about this study, your rights as a participant, or wish to withdraw your consent, please contact:\n\nHealthBank Privacy Officer\nEmail: privacy@healthbank.ca\n\n11. ELECTRONIC SIGNATURE\n\nBy checking the agreement box below, you confirm that:\n- You have read and understood this consent form\n- You voluntarily agree to participate in this study\n- You understand your right to withdraw at any time\n- You acknowledge that your electronic agreement constitutes a legally binding signature pursuant to the Uniform Electronic Commerce Act (UECA)'**
  String get consentDocumentParticipant;

  /// No description provided for @consentDocumentResearcher.
  ///
  /// In en, this message translates to:
  /// **'RESEARCHER DATA USE AND CONFIDENTIALITY AGREEMENT\n\nPlatform: HealthBank — Personal Health Data Collection and Research Platform\n\n1. DATA CONFIDENTIALITY OBLIGATIONS\n\nAs an authorized researcher on the HealthBank platform, you agree to maintain the strictest confidentiality regarding all participant data accessed through this platform. You acknowledge that participant data is collected under informed consent and is protected by Canadian privacy legislation including PIPEDA and PHIPA.\n\n2. PERMITTED USES\n\nYou may use data accessed through HealthBank solely for:\n- Approved research projects as defined in your research protocol\n- Statistical analysis using aggregated, de-identified data\n- Academic publications using only aggregated results\n- Quality improvement of research methodologies\n\nAny use beyond these purposes requires separate approval from the HealthBank administration and relevant ethics boards.\n\n3. DISCLOSURE LIMITATIONS\n\nYou agree that you will NOT:\n- Share individual participant data with any unauthorized person\n- Attempt to re-identify or de-anonymize any participant\n- Transfer data outside the HealthBank platform without written authorization\n- Use data for commercial purposes without explicit approval\n- Discuss individual participant responses outside the authorized research team\n\n4. CONSEQUENCES OF BREACH\n\nViolation of this agreement may result in:\n- Immediate revocation of platform access\n- Disciplinary action by your institution\n- Legal liability under PIPEDA and PHIPA (fines up to \$100,000 per violation)\n- Professional sanctions from relevant regulatory bodies\n- Civil liability for damages caused to participants\n\n5. DATA HANDLING AND SECURITY\n\nYou agree to:\n- Access data only through the authorized HealthBank platform interface\n- Not download or store individual participant data on personal devices\n- Use only institutional, password-protected devices for research access\n- Report any suspected data breach immediately to the HealthBank Privacy Officer\n- Follow all institutional data security policies and procedures\n\n6. PUBLICATION RESTRICTIONS\n\nWhen publishing research based on HealthBank data, you must:\n- Use only aggregated, de-identified results\n- Ensure no individual participant can be identified through published data\n- Acknowledge the HealthBank platform as the data source\n- Submit publications for review before submission if required by your research agreement\n\n7. BREACH REPORTING\n\nYou are legally obligated to immediately report any suspected or actual data breach, including:\n- Unauthorized access to participant data\n- Accidental disclosure of identifiable information\n- Loss or theft of devices containing research data\n- Any suspicious activity on the platform\n\nReports must be made to the HealthBank Privacy Officer within 24 hours of discovery.\n\n8. DURATION OF OBLIGATIONS\n\nYour confidentiality obligations under this agreement continue indefinitely, even after:\n- Your research project concludes\n- Your access to the platform is terminated\n- Your employment or affiliation with your institution ends\n\n9. DATA RETURN AND DESTRUCTION\n\nUpon completion of your research or termination of access, you agree to:\n- Delete all locally stored research data derived from HealthBank\n- Certify in writing that all data has been destroyed\n- Return any physical materials containing participant information\n\nBy checking the agreement box below, you confirm that you have read, understood, and agree to all terms of this confidentiality agreement.'**
  String get consentDocumentResearcher;

  /// No description provided for @consentElectronicSignatureNotice.
  ///
  /// In en, this message translates to:
  /// **'By typing your name in the signature field and checking the agreement box, you acknowledge that your electronic signature has the same legal effect as a handwritten signature pursuant to the Uniform Electronic Commerce Act (UECA).'**
  String get consentElectronicSignatureNotice;

  /// No description provided for @consentErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit consent. Please try again.'**
  String get consentErrorGeneric;

  /// No description provided for @consentHcpTitle.
  ///
  /// In en, this message translates to:
  /// **'Healthcare Professional Confidentiality Agreement'**
  String get consentHcpTitle;

  /// No description provided for @consentPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please review and agree to the consent form to continue.'**
  String get consentPageSubtitle;

  /// No description provided for @consentPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Consent Form'**
  String get consentPageTitle;

  /// No description provided for @consentParticipantTitle.
  ///
  /// In en, this message translates to:
  /// **'Participant Informed Consent'**
  String get consentParticipantTitle;

  /// No description provided for @consentRecordDocumentLanguage.
  ///
  /// In en, this message translates to:
  /// **'Document Language'**
  String get consentRecordDocumentLanguage;

  /// No description provided for @consentRecordIpAddress.
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get consentRecordIpAddress;

  /// No description provided for @consentRecordSignatureName.
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get consentRecordSignatureName;

  /// No description provided for @consentRecordSignedAt.
  ///
  /// In en, this message translates to:
  /// **'Signed At'**
  String get consentRecordSignedAt;

  /// No description provided for @consentRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Consent Record Details'**
  String get consentRecordTitle;

  /// No description provided for @consentRecordUserAgent.
  ///
  /// In en, this message translates to:
  /// **'User Agent'**
  String get consentRecordUserAgent;

  /// No description provided for @consentResearcherTitle.
  ///
  /// In en, this message translates to:
  /// **'Researcher Confidentiality Agreement'**
  String get consentResearcherTitle;

  /// No description provided for @consentRestoreHcpAccess.
  ///
  /// In en, this message translates to:
  /// **'Restore HCP Access'**
  String get consentRestoreHcpAccess;

  /// No description provided for @consentRestoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'HCP access restored'**
  String get consentRestoreSuccess;

  /// No description provided for @consentRevokeConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will prevent {hcpName} from viewing your health data. You can restore access later.'**
  String consentRevokeConfirmBody(String hcpName);

  /// No description provided for @consentRevokeConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Revoke HCP Access?'**
  String get consentRevokeConfirmTitle;

  /// No description provided for @consentRevokeError.
  ///
  /// In en, this message translates to:
  /// **'Failed to update consent. Please try again.'**
  String get consentRevokeError;

  /// No description provided for @consentRevokeHcpAccess.
  ///
  /// In en, this message translates to:
  /// **'Revoke HCP Access'**
  String get consentRevokeHcpAccess;

  /// No description provided for @consentRevokeSuccess.
  ///
  /// In en, this message translates to:
  /// **'HCP access revoked'**
  String get consentRevokeSuccess;

  /// No description provided for @consentSignatureDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'By typing your full legal name in the signature field, you confirm that this constitutes your electronic signature and has the same legal force and effect as a handwritten signature pursuant to the Uniform Electronic Commerce Act (UECA) and applicable Canadian provincial legislation. This electronic signature is legally binding and enforceable under the Personal Information Protection and Electronic Documents Act (PIPEDA).'**
  String get consentSignatureDisclaimer;

  /// No description provided for @consentSignatureHint.
  ///
  /// In en, this message translates to:
  /// **'Type your full legal name'**
  String get consentSignatureHint;

  /// No description provided for @consentSignatureLabel.
  ///
  /// In en, this message translates to:
  /// **'Electronic Signature'**
  String get consentSignatureLabel;

  /// No description provided for @consentStatusNotSigned.
  ///
  /// In en, this message translates to:
  /// **'Consent Not Signed'**
  String get consentStatusNotSigned;

  /// No description provided for @consentStatusSigned.
  ///
  /// In en, this message translates to:
  /// **'Consent Signed'**
  String get consentStatusSigned;

  /// No description provided for @consentStatusSignedAt.
  ///
  /// In en, this message translates to:
  /// **'Signed: {date}'**
  String consentStatusSignedAt(String date);

  /// No description provided for @consentStatusVersion.
  ///
  /// In en, this message translates to:
  /// **'Version: {version}'**
  String consentStatusVersion(String version);

  /// No description provided for @consentSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'I Agree and Submit'**
  String get consentSubmitButton;

  /// No description provided for @consentViewRecord.
  ///
  /// In en, this message translates to:
  /// **'View Consent Record'**
  String get consentViewRecord;

  /// No description provided for @participantAvailableSurveys.
  ///
  /// In en, this message translates to:
  /// **'Available Surveys'**
  String get participantAvailableSurveys;

  /// No description provided for @participantCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get participantCategoryLabel;

  /// No description provided for @participantChartDistribution.
  ///
  /// In en, this message translates to:
  /// **'Distribution'**
  String get participantChartDistribution;

  /// No description provided for @participantChartError.
  ///
  /// In en, this message translates to:
  /// **'Could not load chart data.'**
  String get participantChartError;

  /// No description provided for @participantChartLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading charts...'**
  String get participantChartLoading;

  /// No description provided for @participantChartMean.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get participantChartMean;

  /// No description provided for @participantChartMedian.
  ///
  /// In en, this message translates to:
  /// **'Median'**
  String get participantChartMedian;

  /// No description provided for @participantChartNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get participantChartNo;

  /// No description provided for @participantChartNoData.
  ///
  /// In en, this message translates to:
  /// **'No chart data available.'**
  String get participantChartNoData;

  /// No description provided for @participantChartSuppressed.
  ///
  /// In en, this message translates to:
  /// **'Aggregate data hidden for privacy (fewer than 5 respondents).'**
  String get participantChartSuppressed;

  /// No description provided for @participantChartToggle.
  ///
  /// In en, this message translates to:
  /// **'Show charts'**
  String get participantChartToggle;

  /// No description provided for @participantChartYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get participantChartYes;

  /// No description provided for @participantChartYourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your answer'**
  String get participantChartYourAnswer;

  /// No description provided for @participantChartYourValue.
  ///
  /// In en, this message translates to:
  /// **'Your Value'**
  String get participantChartYourValue;

  /// No description provided for @participantClickToView.
  ///
  /// In en, this message translates to:
  /// **'Click to view'**
  String get participantClickToView;

  /// No description provided for @participantCollapseSurvey.
  ///
  /// In en, this message translates to:
  /// **'Hide details'**
  String get participantCollapseSurvey;

  /// No description provided for @participantCompareAggregate.
  ///
  /// In en, this message translates to:
  /// **'Aggregate'**
  String get participantCompareAggregate;

  /// No description provided for @participantCompareError.
  ///
  /// In en, this message translates to:
  /// **'Could not load comparison data.'**
  String get participantCompareError;

  /// No description provided for @participantCompareLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading comparison...'**
  String get participantCompareLoading;

  /// No description provided for @participantCompareMostCommon.
  ///
  /// In en, this message translates to:
  /// **'Most common'**
  String get participantCompareMostCommon;

  /// No description provided for @participantCompareNoData.
  ///
  /// In en, this message translates to:
  /// **'No comparison data available.'**
  String get participantCompareNoData;

  /// No description provided for @participantCompareToggle.
  ///
  /// In en, this message translates to:
  /// **'Compare to aggregate'**
  String get participantCompareToggle;

  /// No description provided for @participantCompletedOn.
  ///
  /// In en, this message translates to:
  /// **'Completed {date}'**
  String participantCompletedOn(Object date);

  /// No description provided for @participantCompletedSurveys.
  ///
  /// In en, this message translates to:
  /// **'Completed Surveys'**
  String get participantCompletedSurveys;

  /// No description provided for @participantCompletedThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Completed this week'**
  String get participantCompletedThisWeek;

  /// No description provided for @participantContinueSurvey.
  ///
  /// In en, this message translates to:
  /// **'Continue Survey'**
  String get participantContinueSurvey;

  /// No description provided for @participantDashboardDescription.
  ///
  /// In en, this message translates to:
  /// **'Review your graphs and diagrams.'**
  String get participantDashboardDescription;

  /// No description provided for @participantDoTask.
  ///
  /// In en, this message translates to:
  /// **'Do Task'**
  String get participantDoTask;

  /// No description provided for @participantDownloadResults.
  ///
  /// In en, this message translates to:
  /// **'Download Results'**
  String get participantDownloadResults;

  /// No description provided for @participantDueOn.
  ///
  /// In en, this message translates to:
  /// **'Due on {date}'**
  String participantDueOn(String date);

  /// No description provided for @participantDueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get participantDueToday;

  /// No description provided for @participantDueTodayAt.
  ///
  /// In en, this message translates to:
  /// **'Due today at {time}'**
  String participantDueTodayAt(String time);

  /// No description provided for @participantExpandSurvey.
  ///
  /// In en, this message translates to:
  /// **'Show details'**
  String get participantExpandSurvey;

  /// No description provided for @participantGraphPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Graph placeholder'**
  String get participantGraphPlaceholder;

  /// No description provided for @participantGraphTitle1.
  ///
  /// In en, this message translates to:
  /// **'Graph Title 1'**
  String get participantGraphTitle1;

  /// No description provided for @participantGraphTitle2.
  ///
  /// In en, this message translates to:
  /// **'Graph Title 2'**
  String get participantGraphTitle2;

  /// No description provided for @participantLinkedHcps.
  ///
  /// In en, this message translates to:
  /// **'Linked Health Care Providers'**
  String get participantLinkedHcps;

  /// No description provided for @participantLoadingResults.
  ///
  /// In en, this message translates to:
  /// **'Loading your data...'**
  String get participantLoadingResults;

  /// No description provided for @participantMyResults.
  ///
  /// In en, this message translates to:
  /// **'My Results'**
  String get participantMyResults;

  /// No description provided for @participantMySurveys.
  ///
  /// In en, this message translates to:
  /// **'My Surveys'**
  String get participantMySurveys;

  /// No description provided for @participantMyTasks.
  ///
  /// In en, this message translates to:
  /// **'My Tasks'**
  String get participantMyTasks;

  /// No description provided for @participantNewMessages.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{You have 1 new message.\nClick to here to view.} other{You have {count} new messages.\nClick to here to view.}}'**
  String participantNewMessages(int count);

  /// No description provided for @participantNoDueDate.
  ///
  /// In en, this message translates to:
  /// **'No deadline'**
  String get participantNoDueDate;

  /// No description provided for @participantNoResults.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t completed any surveys yet.'**
  String get participantNoResults;

  /// No description provided for @participantNoResultsYet.
  ///
  /// In en, this message translates to:
  /// **'No results available yet'**
  String get participantNoResultsYet;

  /// No description provided for @participantNoSurveys.
  ///
  /// In en, this message translates to:
  /// **'No surveys assigned to you yet.'**
  String get participantNoSurveys;

  /// No description provided for @participantNoSurveysSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review assigned surveys and continue any saved drafts here.'**
  String get participantNoSurveysSubtitle;

  /// No description provided for @participantNoTasksDueToday.
  ///
  /// In en, this message translates to:
  /// **'No tasks due today'**
  String get participantNoTasksDueToday;

  /// No description provided for @participantNotificationMessage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{You have 1 new message.\nClick to here to view.} other{You have {count} new messages.\nClick to here to view.}}'**
  String participantNotificationMessage(int count);

  /// No description provided for @participantOverdueSince.
  ///
  /// In en, this message translates to:
  /// **'Overdue since {date}'**
  String participantOverdueSince(String date);

  /// No description provided for @participantOverdueTasksSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 task is overdue} other{{count} tasks are overdue}}'**
  String participantOverdueTasksSummary(int count);

  /// No description provided for @participantPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'(Placeholder)'**
  String get participantPlaceholder;

  /// No description provided for @participantQuestionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 question} other{{count} questions}}'**
  String participantQuestionCount(int count);

  /// No description provided for @participantQuickInsightsCaughtUpBadge.
  ///
  /// In en, this message translates to:
  /// **'You’re all caught up'**
  String get participantQuickInsightsCaughtUpBadge;

  /// No description provided for @participantQuickInsightsCaughtUpMessage.
  ///
  /// In en, this message translates to:
  /// **'You’re all caught up. No surveys are waiting right now.'**
  String get participantQuickInsightsCaughtUpMessage;

  /// No description provided for @participantQuickInsightsCompletedOn.
  ///
  /// In en, this message translates to:
  /// **'Completed on {date}'**
  String participantQuickInsightsCompletedOn(String date);

  /// No description provided for @participantQuickInsightsMostRecentTitle.
  ///
  /// In en, this message translates to:
  /// **'Most recent survey completed'**
  String get participantQuickInsightsMostRecentTitle;

  /// No description provided for @participantQuickInsightsNoCompletedYet.
  ///
  /// In en, this message translates to:
  /// **'No completed surveys yet. Once you finish one, it will appear here.'**
  String get participantQuickInsightsNoCompletedYet;

  /// No description provided for @participantQuickInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Insights'**
  String get participantQuickInsightsTitle;

  /// No description provided for @participantQuickInsightsViewInResults.
  ///
  /// In en, this message translates to:
  /// **'View in Results'**
  String get participantQuickInsightsViewInResults;

  /// No description provided for @participantRemainingTasks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Remaining Task} other{{count} Remaining Tasks}}'**
  String participantRemainingTasks(int count);

  /// No description provided for @participantRemainingTasksForToday.
  ///
  /// In en, this message translates to:
  /// **'Remaining tasks for today: {count}'**
  String participantRemainingTasksForToday(int count);

  /// No description provided for @participantRepeatsEvery.
  ///
  /// In en, this message translates to:
  /// **'Repeats every {days} days'**
  String participantRepeatsEvery(int days);

  /// No description provided for @participantResponseLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Response'**
  String get participantResponseLabel;

  /// No description provided for @participantResultsError.
  ///
  /// In en, this message translates to:
  /// **'Could not load your data. Please try again.'**
  String get participantResultsError;

  /// No description provided for @participantResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Data'**
  String get participantResultsTitle;

  /// No description provided for @participantResumeSurvey.
  ///
  /// In en, this message translates to:
  /// **'Resume Survey'**
  String get participantResumeSurvey;

  /// No description provided for @participantRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get participantRetry;

  /// No description provided for @participantStartSurvey.
  ///
  /// In en, this message translates to:
  /// **'Start Survey'**
  String get participantStartSurvey;

  /// No description provided for @participantSurveyCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get participantSurveyCompleted;

  /// No description provided for @participantSurveyDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due: {date}'**
  String participantSurveyDueDate(String date);

  /// No description provided for @participantSurveyLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load surveys. Please try again.'**
  String get participantSurveyLoadError;

  /// No description provided for @participantSurveyStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get participantSurveyStatusCompleted;

  /// No description provided for @participantSurveyStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get participantSurveyStatusExpired;

  /// No description provided for @participantSurveyStatusIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Incomplete'**
  String get participantSurveyStatusIncomplete;

  /// No description provided for @participantSurveyStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get participantSurveyStatusPending;

  /// No description provided for @participantTaskProgress.
  ///
  /// In en, this message translates to:
  /// **'Task Progress'**
  String get participantTaskProgress;

  /// No description provided for @participantTaskProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Task Progress:'**
  String get participantTaskProgressLabel;

  /// No description provided for @participantTasksCompleted.
  ///
  /// In en, this message translates to:
  /// **'{completed} out of {total} tasks completed'**
  String participantTasksCompleted(int completed, int total);

  /// No description provided for @participantTasksCompletedLabel.
  ///
  /// In en, this message translates to:
  /// **'{completed} out of {total} tasks completed'**
  String participantTasksCompletedLabel(int completed, int total);

  /// No description provided for @participantTasksCompletedThisWeekSummary.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} current tasks completed this week'**
  String participantTasksCompletedThisWeekSummary(int completed, int total);

  /// No description provided for @participantUnknownSurvey.
  ///
  /// In en, this message translates to:
  /// **'Survey'**
  String get participantUnknownSurvey;

  /// No description provided for @participantViewAllTasks.
  ///
  /// In en, this message translates to:
  /// **'View All Tasks'**
  String get participantViewAllTasks;

  /// No description provided for @participantViewResults.
  ///
  /// In en, this message translates to:
  /// **'View Results'**
  String get participantViewResults;

  /// No description provided for @participantWelcomeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}. How are you today?'**
  String participantWelcomeGreeting(String name);

  /// No description provided for @participantWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}. How are you today?'**
  String participantWelcomeMessage(String name);

  /// No description provided for @participantYourTaskProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Task Progress:'**
  String get participantYourTaskProgress;

  /// No description provided for @todoAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Action Required'**
  String get todoAlertsTitle;

  /// No description provided for @todoCompletedSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get todoCompletedSummaryTitle;

  /// No description provided for @todoConsentRequired.
  ///
  /// In en, this message translates to:
  /// **'Your consent needs to be renewed. Please review and sign.'**
  String get todoConsentRequired;

  /// No description provided for @todoDueSoonLabel.
  ///
  /// In en, this message translates to:
  /// **'Due soon'**
  String get todoDueSoonLabel;

  /// No description provided for @todoHcpAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get todoHcpAccept;

  /// No description provided for @todoHcpDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get todoHcpDecline;

  /// No description provided for @todoHcpLinkAccepted.
  ///
  /// In en, this message translates to:
  /// **'Connection accepted'**
  String get todoHcpLinkAccepted;

  /// No description provided for @todoHcpLinkDeclined.
  ///
  /// In en, this message translates to:
  /// **'Connection declined'**
  String get todoHcpLinkDeclined;

  /// No description provided for @todoHcpLinkError.
  ///
  /// In en, this message translates to:
  /// **'Failed to respond. Please try again.'**
  String get todoHcpLinkError;

  /// No description provided for @todoHcpLinkRequest.
  ///
  /// In en, this message translates to:
  /// **'{hcpName} has requested to track your health data.'**
  String todoHcpLinkRequest(String hcpName);

  /// No description provided for @todoNoTasks.
  ///
  /// In en, this message translates to:
  /// **'You have no pending tasks.'**
  String get todoNoTasks;

  /// No description provided for @todoOverdueLabel.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get todoOverdueLabel;

  /// No description provided for @todoPageTitle.
  ///
  /// In en, this message translates to:
  /// **'My Tasks'**
  String get todoPageTitle;

  /// No description provided for @todoPendingSurveysTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending Surveys'**
  String get todoPendingSurveysTitle;

  /// No description provided for @todoProfileIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Your profile is incomplete. Please add your name.'**
  String get todoProfileIncomplete;

  /// No description provided for @todoRefreshing.
  ///
  /// In en, this message translates to:
  /// **'Refreshing...'**
  String get todoRefreshing;

  /// No description provided for @todoStartSurvey.
  ///
  /// In en, this message translates to:
  /// **'Start Survey'**
  String get todoStartSurvey;

  /// No description provided for @todoViewResults.
  ///
  /// In en, this message translates to:
  /// **'View Results'**
  String get todoViewResults;

  /// No description provided for @healthCheckInTaskAction.
  ///
  /// In en, this message translates to:
  /// **'Start Check-in'**
  String get healthCheckInTaskAction;

  /// No description provided for @healthCheckInTaskCompletedToday.
  ///
  /// In en, this message translates to:
  /// **'Completed today'**
  String get healthCheckInTaskCompletedToday;

  /// No description provided for @healthCheckInTaskDueText.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get healthCheckInTaskDueText;

  /// No description provided for @healthCheckInTaskProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} questions answered'**
  String healthCheckInTaskProgress(int completed, int total);

  /// No description provided for @healthCheckInTaskRepeat.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get healthCheckInTaskRepeat;

  /// No description provided for @healthCheckInTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Health Check-in'**
  String get healthCheckInTaskTitle;

  /// No description provided for @healthTrackingAggregateUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Population comparison unavailable (insufficient data).'**
  String get healthTrackingAggregateUnavailable;

  /// No description provided for @healthTrackingAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get healthTrackingAllCategories;

  /// No description provided for @healthTrackingAverageLabel.
  ///
  /// In en, this message translates to:
  /// **'Avg'**
  String get healthTrackingAverageLabel;

  /// No description provided for @healthTrackingAverageTitle.
  ///
  /// In en, this message translates to:
  /// **'Average Value Over Time'**
  String get healthTrackingAverageTitle;

  /// No description provided for @healthTrackingAvgValue.
  ///
  /// In en, this message translates to:
  /// **'Avg Value'**
  String get healthTrackingAvgValue;

  /// No description provided for @healthTrackingBaselineBanner.
  ///
  /// In en, this message translates to:
  /// **'Record your starting point — fill in today\'s values as your health baseline.'**
  String get healthTrackingBaselineBanner;

  /// No description provided for @healthTrackingCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get healthTrackingCategory;

  /// No description provided for @healthTrackingChartBar.
  ///
  /// In en, this message translates to:
  /// **'Bar chart'**
  String get healthTrackingChartBar;

  /// No description provided for @healthTrackingChartEntries.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} entry} other{{count} entries}}'**
  String healthTrackingChartEntries(int count);

  /// No description provided for @healthTrackingChartError.
  ///
  /// In en, this message translates to:
  /// **'Could not load chart data.'**
  String get healthTrackingChartError;

  /// No description provided for @healthTrackingChartLine.
  ///
  /// In en, this message translates to:
  /// **'Line chart'**
  String get healthTrackingChartLine;

  /// No description provided for @healthTrackingChartPie.
  ///
  /// In en, this message translates to:
  /// **'Pie chart'**
  String get healthTrackingChartPie;

  /// No description provided for @healthTrackingCharts.
  ///
  /// In en, this message translates to:
  /// **'Charts'**
  String get healthTrackingCharts;

  /// No description provided for @healthTrackingChartTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Chart type'**
  String get healthTrackingChartTypeLabel;

  /// No description provided for @healthTrackingChartYesNoHint.
  ///
  /// In en, this message translates to:
  /// **'Yes = 1 / No = 0'**
  String get healthTrackingChartYesNoHint;

  /// No description provided for @healthTrackingClearAllMetrics.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get healthTrackingClearAllMetrics;

  /// No description provided for @healthTrackingClearSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get healthTrackingClearSelection;

  /// No description provided for @healthTrackingCollapseCategory.
  ///
  /// In en, this message translates to:
  /// **'Collapse category'**
  String get healthTrackingCollapseCategory;

  /// No description provided for @healthTrackingCompareToAggregate.
  ///
  /// In en, this message translates to:
  /// **'Compare to Aggregate'**
  String get healthTrackingCompareToAggregate;

  /// No description provided for @healthTrackingDraftHint.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} answer filled} other{{count} answers filled}}'**
  String healthTrackingDraftHint(int count);

  /// No description provided for @healthTrackingEnterText.
  ///
  /// In en, this message translates to:
  /// **'Enter your response'**
  String get healthTrackingEnterText;

  /// No description provided for @healthTrackingEnterValue.
  ///
  /// In en, this message translates to:
  /// **'Enter value'**
  String get healthTrackingEnterValue;

  /// No description provided for @healthTrackingExpandCategory.
  ///
  /// In en, this message translates to:
  /// **'Expand category'**
  String get healthTrackingExpandCategory;

  /// No description provided for @healthTrackingExportError.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String healthTrackingExportError(String error);

  /// No description provided for @healthTrackingExportFiltered.
  ///
  /// In en, this message translates to:
  /// **'Export Filtered Data'**
  String get healthTrackingExportFiltered;

  /// No description provided for @healthTrackingExporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting…'**
  String get healthTrackingExporting;

  /// No description provided for @healthTrackingExportOwnData.
  ///
  /// In en, this message translates to:
  /// **'Export My Data (CSV)'**
  String get healthTrackingExportOwnData;

  /// No description provided for @healthTrackingFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get healthTrackingFilters;

  /// No description provided for @healthTrackingGranularityDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get healthTrackingGranularityDaily;

  /// No description provided for @healthTrackingGranularityLabel.
  ///
  /// In en, this message translates to:
  /// **'Granularity'**
  String get healthTrackingGranularityLabel;

  /// No description provided for @healthTrackingGranularityMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get healthTrackingGranularityMonthly;

  /// No description provided for @healthTrackingGranularityWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get healthTrackingGranularityWeekly;

  /// No description provided for @healthTrackingHideFilters.
  ///
  /// In en, this message translates to:
  /// **'Hide filters'**
  String get healthTrackingHideFilters;

  /// No description provided for @healthTrackingHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get healthTrackingHistory;

  /// No description provided for @healthTrackingHistoryAll.
  ///
  /// In en, this message translates to:
  /// **'All Entries'**
  String get healthTrackingHistoryAll;

  /// No description provided for @healthTrackingHistoryByCategory.
  ///
  /// In en, this message translates to:
  /// **'By Category'**
  String get healthTrackingHistoryByCategory;

  /// No description provided for @healthTrackingHistoryByMetric.
  ///
  /// In en, this message translates to:
  /// **'By Metric'**
  String get healthTrackingHistoryByMetric;

  /// No description provided for @healthTrackingHistoryDateFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get healthTrackingHistoryDateFrom;

  /// No description provided for @healthTrackingHistoryDateTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get healthTrackingHistoryDateTo;

  /// No description provided for @healthTrackingHistoryModeLabel.
  ///
  /// In en, this message translates to:
  /// **'History view mode'**
  String get healthTrackingHistoryModeLabel;

  /// No description provided for @healthTrackingHistoryNoEntries.
  ///
  /// In en, this message translates to:
  /// **'No entries found for the selected period.'**
  String get healthTrackingHistoryNoEntries;

  /// No description provided for @healthTrackingHistoryTruncated.
  ///
  /// In en, this message translates to:
  /// **'Showing 100 most recent entries.'**
  String get healthTrackingHistoryTruncated;

  /// No description provided for @healthTrackingLoadChart.
  ///
  /// In en, this message translates to:
  /// **'Load Chart'**
  String get healthTrackingLoadChart;

  /// No description provided for @healthTrackingLogToday.
  ///
  /// In en, this message translates to:
  /// **'Log Today'**
  String get healthTrackingLogToday;

  /// No description provided for @healthTrackingMetric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get healthTrackingMetric;

  /// No description provided for @healthTrackingMetricsError.
  ///
  /// In en, this message translates to:
  /// **'Could not load metrics.'**
  String get healthTrackingMetricsError;

  /// No description provided for @healthTrackingMonthlySection.
  ///
  /// In en, this message translates to:
  /// **'MONTHLY CHECK-IN'**
  String get healthTrackingMonthlySection;

  /// No description provided for @healthTrackingMultiChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Average Values Over Time'**
  String get healthTrackingMultiChartTitle;

  /// No description provided for @healthTrackingMyDataOnly.
  ///
  /// In en, this message translates to:
  /// **'My Data Only'**
  String get healthTrackingMyDataOnly;

  /// No description provided for @healthTrackingNMetricsSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String healthTrackingNMetricsSelected(int count);

  /// No description provided for @healthTrackingNoData.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get healthTrackingNoData;

  /// No description provided for @healthTrackingNoMetrics.
  ///
  /// In en, this message translates to:
  /// **'No metrics available.'**
  String get healthTrackingNoMetrics;

  /// No description provided for @healthTrackingParticipants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get healthTrackingParticipants;

  /// No description provided for @healthTrackingRecentEntries.
  ///
  /// In en, this message translates to:
  /// **'Recent entries'**
  String get healthTrackingRecentEntries;

  /// No description provided for @healthTrackingResearchCategories.
  ///
  /// In en, this message translates to:
  /// **'Category Overview'**
  String get healthTrackingResearchCategories;

  /// No description provided for @healthTrackingResearchDeepDive.
  ///
  /// In en, this message translates to:
  /// **'Metric Deep-Dive'**
  String get healthTrackingResearchDeepDive;

  /// No description provided for @healthTrackingResearchExport.
  ///
  /// In en, this message translates to:
  /// **'Export Health Tracking CSV'**
  String get healthTrackingResearchExport;

  /// No description provided for @healthTrackingResearchNoData.
  ///
  /// In en, this message translates to:
  /// **'No data available for the selected filters.'**
  String get healthTrackingResearchNoData;

  /// No description provided for @healthTrackingResearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Tracking Analytics'**
  String get healthTrackingResearchTitle;

  /// No description provided for @healthTrackingResultsViewLabel.
  ///
  /// In en, this message translates to:
  /// **'View results as table or chart'**
  String get healthTrackingResultsViewLabel;

  /// No description provided for @healthTrackingSave.
  ///
  /// In en, this message translates to:
  /// **'Save Entries'**
  String get healthTrackingSave;

  /// No description provided for @healthTrackingSaveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save entries. Please try again.'**
  String get healthTrackingSaveError;

  /// No description provided for @healthTrackingSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Entries saved successfully.'**
  String get healthTrackingSaveSuccess;

  /// No description provided for @healthTrackingSelectAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get healthTrackingSelectAll;

  /// No description provided for @healthTrackingSelectAllMetrics.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get healthTrackingSelectAllMetrics;

  /// No description provided for @healthTrackingSelectCategoryAll.
  ///
  /// In en, this message translates to:
  /// **'Select all in category'**
  String get healthTrackingSelectCategoryAll;

  /// No description provided for @healthTrackingSelectMetric.
  ///
  /// In en, this message translates to:
  /// **'Select a metric'**
  String get healthTrackingSelectMetric;

  /// No description provided for @healthTrackingSelectMetrics.
  ///
  /// In en, this message translates to:
  /// **'Select Metrics'**
  String get healthTrackingSelectMetrics;

  /// No description provided for @healthTrackingSelectMetricsHint.
  ///
  /// In en, this message translates to:
  /// **'Select at least one metric to load the chart'**
  String get healthTrackingSelectMetricsHint;

  /// No description provided for @healthTrackingSelectMetricTooltip.
  ///
  /// In en, this message translates to:
  /// **'Select a metric to load chart data'**
  String get healthTrackingSelectMetricTooltip;

  /// No description provided for @healthTrackingShowFilters.
  ///
  /// In en, this message translates to:
  /// **'Show filters'**
  String get healthTrackingShowFilters;

  /// No description provided for @healthTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Tracking'**
  String get healthTrackingTitle;

  /// No description provided for @healthTrackingValueColumn.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get healthTrackingValueColumn;

  /// No description provided for @healthTrackingViewChart.
  ///
  /// In en, this message translates to:
  /// **'Chart view'**
  String get healthTrackingViewChart;

  /// No description provided for @healthTrackingViewModeLabel.
  ///
  /// In en, this message translates to:
  /// **'View mode: log today or history'**
  String get healthTrackingViewModeLabel;

  /// No description provided for @healthTrackingViewTable.
  ///
  /// In en, this message translates to:
  /// **'Table view'**
  String get healthTrackingViewTable;

  /// No description provided for @healthTrackingWeeklySection.
  ///
  /// In en, this message translates to:
  /// **'WEEKLY CHECK-IN'**
  String get healthTrackingWeeklySection;

  /// No description provided for @healthTrackingXofYMetrics.
  ///
  /// In en, this message translates to:
  /// **'{selected} of {total} metrics'**
  String healthTrackingXofYMetrics(int selected, int total);

  /// No description provided for @surveyAssignAge3044.
  ///
  /// In en, this message translates to:
  /// **'30–44'**
  String get surveyAssignAge3044;

  /// No description provided for @surveyAssignAge4559.
  ///
  /// In en, this message translates to:
  /// **'45–59'**
  String get surveyAssignAge4559;

  /// No description provided for @surveyAssignAge60Plus.
  ///
  /// In en, this message translates to:
  /// **'60 and over'**
  String get surveyAssignAge60Plus;

  /// No description provided for @surveyAssignAgeAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get surveyAssignAgeAny;

  /// No description provided for @surveyAssignAgeMaxLabel.
  ///
  /// In en, this message translates to:
  /// **'Age Max'**
  String get surveyAssignAgeMaxLabel;

  /// No description provided for @surveyAssignAgeMinLabel.
  ///
  /// In en, this message translates to:
  /// **'Age Min'**
  String get surveyAssignAgeMinLabel;

  /// No description provided for @surveyAssignAgeRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Age Range'**
  String get surveyAssignAgeRangeLabel;

  /// No description provided for @surveyAssignAgeUnder30.
  ///
  /// In en, this message translates to:
  /// **'Under 30'**
  String get surveyAssignAgeUnder30;

  /// No description provided for @surveyAssignAgeValidationInteger.
  ///
  /// In en, this message translates to:
  /// **'Age must be an integer.'**
  String get surveyAssignAgeValidationInteger;

  /// No description provided for @surveyAssignAgeValidationNonNegative.
  ///
  /// In en, this message translates to:
  /// **'Age cannot be negative.'**
  String get surveyAssignAgeValidationNonNegative;

  /// No description provided for @surveyAssignAgeValidationRange.
  ///
  /// In en, this message translates to:
  /// **'Minimum age must be less than or equal to maximum age.'**
  String get surveyAssignAgeValidationRange;

  /// No description provided for @surveyAssignAgeValidationRequired.
  ///
  /// In en, this message translates to:
  /// **'Age is required.'**
  String get surveyAssignAgeValidationRequired;

  /// No description provided for @surveyAssignAgeValidationUpperBound.
  ///
  /// In en, this message translates to:
  /// **'Age must be {max} or less.'**
  String surveyAssignAgeValidationUpperBound(int max);

  /// No description provided for @surveyAssignBulkResult.
  ///
  /// In en, this message translates to:
  /// **'Targeted: {totalTargeted} • Assigned: {assigned} • Skipped: {skipped}'**
  String surveyAssignBulkResult(int totalTargeted, int assigned, int skipped);

  /// No description provided for @surveyAssignBulkSuccess.
  ///
  /// In en, this message translates to:
  /// **'Survey assigned successfully'**
  String get surveyAssignBulkSuccess;

  /// No description provided for @surveyAssignButton.
  ///
  /// In en, this message translates to:
  /// **'Assign Now'**
  String get surveyAssignButton;

  /// No description provided for @surveyAssignClearDueDate.
  ///
  /// In en, this message translates to:
  /// **'Clear due date'**
  String get surveyAssignClearDueDate;

  /// No description provided for @surveyAssignDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date (optional)'**
  String get surveyAssignDueDate;

  /// No description provided for @surveyAssignErrorAlready.
  ///
  /// In en, this message translates to:
  /// **'This participant is already assigned.'**
  String get surveyAssignErrorAlready;

  /// No description provided for @surveyAssignErrorGeneral.
  ///
  /// In en, this message translates to:
  /// **'Failed to assign survey.'**
  String get surveyAssignErrorGeneral;

  /// No description provided for @surveyAssignErrorLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load assignments.'**
  String get surveyAssignErrorLoad;

  /// No description provided for @surveyAssignErrorNotPublished.
  ///
  /// In en, this message translates to:
  /// **'Only published surveys can be assigned.'**
  String get surveyAssignErrorNotPublished;

  /// No description provided for @surveyAssignGenderAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get surveyAssignGenderAll;

  /// No description provided for @surveyAssignGenderAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get surveyAssignGenderAny;

  /// No description provided for @surveyAssignGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get surveyAssignGenderFemale;

  /// No description provided for @surveyAssignGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get surveyAssignGenderLabel;

  /// No description provided for @surveyAssignGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get surveyAssignGenderMale;

  /// No description provided for @surveyAssignGenderNonBinary.
  ///
  /// In en, this message translates to:
  /// **'Non-binary'**
  String get surveyAssignGenderNonBinary;

  /// No description provided for @surveyAssignGenderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get surveyAssignGenderOther;

  /// No description provided for @surveyAssignGenderUnspecified.
  ///
  /// In en, this message translates to:
  /// **'Unspecified'**
  String get surveyAssignGenderUnspecified;

  /// No description provided for @surveyAssignLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading assignments...'**
  String get surveyAssignLoading;

  /// No description provided for @surveyAssignmentDelete.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get surveyAssignmentDelete;

  /// No description provided for @surveyAssignmentDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this assignment?'**
  String get surveyAssignmentDeleteConfirm;

  /// No description provided for @surveyAssignmentDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove assignment.'**
  String get surveyAssignmentDeleteError;

  /// No description provided for @surveyAssignmentDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Assignment removed.'**
  String get surveyAssignmentDeleteSuccess;

  /// No description provided for @surveyAssignmentDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due: {date}'**
  String surveyAssignmentDueDate(String date);

  /// No description provided for @surveyAssignments.
  ///
  /// In en, this message translates to:
  /// **'Current Assignments'**
  String get surveyAssignments;

  /// No description provided for @surveyAssignmentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No participants assigned yet.'**
  String get surveyAssignmentsEmpty;

  /// No description provided for @surveyAssignmentStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get surveyAssignmentStatusCompleted;

  /// No description provided for @surveyAssignmentStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get surveyAssignmentStatusExpired;

  /// No description provided for @surveyAssignmentStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get surveyAssignmentStatusPending;

  /// No description provided for @surveyAssignSuccess.
  ///
  /// In en, this message translates to:
  /// **'Survey assigned successfully'**
  String get surveyAssignSuccess;

  /// No description provided for @surveyAssignSummaryCompleted.
  ///
  /// In en, this message translates to:
  /// **'{count} completed'**
  String surveyAssignSummaryCompleted(int count);

  /// No description provided for @surveyAssignSummaryExpired.
  ///
  /// In en, this message translates to:
  /// **'{count} expired'**
  String surveyAssignSummaryExpired(int count);

  /// No description provided for @surveyAssignSummaryNone.
  ///
  /// In en, this message translates to:
  /// **'No assignments yet'**
  String get surveyAssignSummaryNone;

  /// No description provided for @surveyAssignSummaryPending.
  ///
  /// In en, this message translates to:
  /// **'{count} pending'**
  String surveyAssignSummaryPending(int count);

  /// No description provided for @surveyAssignSummaryTotal.
  ///
  /// In en, this message translates to:
  /// **'{count} assigned'**
  String surveyAssignSummaryTotal(int count);

  /// No description provided for @surveyAssignTargetAll.
  ///
  /// In en, this message translates to:
  /// **'All Participants'**
  String get surveyAssignTargetAll;

  /// No description provided for @surveyAssignTargetDemographic.
  ///
  /// In en, this message translates to:
  /// **'By Demographic'**
  String get surveyAssignTargetDemographic;

  /// No description provided for @surveyAssignTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Assign To'**
  String get surveyAssignTargetLabel;

  /// No description provided for @surveyAssignTitle.
  ///
  /// In en, this message translates to:
  /// **'Assign Survey'**
  String get surveyAssignTitle;

  /// No description provided for @surveyBuilderAddNewQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add New Question'**
  String get surveyBuilderAddNewQuestion;

  /// No description provided for @surveyBuilderAddQuestions.
  ///
  /// In en, this message translates to:
  /// **'Add Questions'**
  String get surveyBuilderAddQuestions;

  /// No description provided for @surveyBuilderAddQuestionsFirst.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one question before publishing'**
  String get surveyBuilderAddQuestionsFirst;

  /// No description provided for @surveyBuilderAutoSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get surveyBuilderAutoSaveFailed;

  /// No description provided for @surveyBuilderAutoSaveRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get surveyBuilderAutoSaveRetry;

  /// No description provided for @surveyBuilderAutoSaveSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get surveyBuilderAutoSaveSaved;

  /// No description provided for @surveyBuilderAutoSaveSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get surveyBuilderAutoSaveSaving;

  /// No description provided for @surveyBuilderAutoSaveUnsaved.
  ///
  /// In en, this message translates to:
  /// **'Unsaved'**
  String get surveyBuilderAutoSaveUnsaved;

  /// No description provided for @surveyBuilderBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get surveyBuilderBack;

  /// No description provided for @surveyBuilderDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the purpose of this survey'**
  String get surveyBuilderDescriptionHint;

  /// No description provided for @surveyBuilderDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get surveyBuilderDescriptionLabel;

  /// No description provided for @surveyBuilderDragToReorder.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder'**
  String get surveyBuilderDragToReorder;

  /// No description provided for @surveyBuilderEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Survey'**
  String get surveyBuilderEditTitle;

  /// No description provided for @surveyBuilderEmptyStateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add questions to build your survey'**
  String get surveyBuilderEmptyStateSubtitle;

  /// No description provided for @surveyBuilderEmptyStateTitle.
  ///
  /// In en, this message translates to:
  /// **'No questions yet'**
  String get surveyBuilderEmptyStateTitle;

  /// No description provided for @surveyBuilderEndDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get surveyBuilderEndDate;

  /// No description provided for @surveyBuilderFailedToLoadQuestions.
  ///
  /// In en, this message translates to:
  /// **'Failed to load questions'**
  String get surveyBuilderFailedToLoadQuestions;

  /// No description provided for @surveyBuilderHideQuestionBank.
  ///
  /// In en, this message translates to:
  /// **'Hide Question Bank'**
  String get surveyBuilderHideQuestionBank;

  /// No description provided for @surveyBuilderImportDialogAddSelected.
  ///
  /// In en, this message translates to:
  /// **'Add Selected ({count})'**
  String surveyBuilderImportDialogAddSelected(int count);

  /// No description provided for @surveyBuilderImportDialogAlreadyAdded.
  ///
  /// In en, this message translates to:
  /// **'Already added'**
  String get surveyBuilderImportDialogAlreadyAdded;

  /// No description provided for @surveyBuilderImportDialogSearch.
  ///
  /// In en, this message translates to:
  /// **'Search questions...'**
  String get surveyBuilderImportDialogSearch;

  /// No description provided for @surveyBuilderImportDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Import from Question Bank'**
  String get surveyBuilderImportDialogTitle;

  /// No description provided for @surveyBuilderImportFromBank.
  ///
  /// In en, this message translates to:
  /// **'Import from Question Bank'**
  String get surveyBuilderImportFromBank;

  /// No description provided for @surveyBuilderNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New Survey'**
  String get surveyBuilderNewTitle;

  /// No description provided for @surveyBuilderNoQuestions.
  ///
  /// In en, this message translates to:
  /// **'No questions added yet'**
  String get surveyBuilderNoQuestions;

  /// No description provided for @surveyBuilderNoQuestionsInBank.
  ///
  /// In en, this message translates to:
  /// **'No questions in bank yet'**
  String get surveyBuilderNoQuestionsInBank;

  /// No description provided for @surveyBuilderPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview Survey'**
  String get surveyBuilderPreview;

  /// No description provided for @surveyBuilderPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get surveyBuilderPublish;

  /// No description provided for @surveyBuilderPublishConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Once published, the survey will be available for assignment to participants. Are you sure you want to publish?'**
  String get surveyBuilderPublishConfirmMessage;

  /// No description provided for @surveyBuilderPublishedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Survey published successfully'**
  String get surveyBuilderPublishedSuccess;

  /// No description provided for @surveyBuilderQuestionAdded.
  ///
  /// In en, this message translates to:
  /// **'Added: {title}'**
  String surveyBuilderQuestionAdded(String title);

  /// No description provided for @surveyBuilderQuestionBank.
  ///
  /// In en, this message translates to:
  /// **'Question Bank'**
  String get surveyBuilderQuestionBank;

  /// No description provided for @surveyBuilderQuestionCardCancelEdit.
  ///
  /// In en, this message translates to:
  /// **'Cancel edit'**
  String get surveyBuilderQuestionCardCancelEdit;

  /// No description provided for @surveyBuilderQuestionCardConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm question'**
  String get surveyBuilderQuestionCardConfirm;

  /// No description provided for @surveyBuilderQuestionCardCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create question'**
  String get surveyBuilderQuestionCardCreateFailed;

  /// No description provided for @surveyBuilderQuestionCardEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit question'**
  String get surveyBuilderQuestionCardEdit;

  /// No description provided for @surveyBuilderQuestionCardPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Type your question here'**
  String get surveyBuilderQuestionCardPlaceholder;

  /// No description provided for @surveyBuilderQuestionCardSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get surveyBuilderQuestionCardSave;

  /// No description provided for @surveyBuilderQuestionCardUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update question'**
  String get surveyBuilderQuestionCardUpdateFailed;

  /// No description provided for @surveyBuilderQuestionsCount.
  ///
  /// In en, this message translates to:
  /// **'Questions ({count})'**
  String surveyBuilderQuestionsCount(int count);

  /// No description provided for @surveyBuilderQuestionsImported.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 question imported} other{{count} questions imported}}'**
  String surveyBuilderQuestionsImported(int count);

  /// No description provided for @surveyBuilderRemoveQuestion.
  ///
  /// In en, this message translates to:
  /// **'Remove question'**
  String get surveyBuilderRemoveQuestion;

  /// No description provided for @surveyBuilderSavedAsDraft.
  ///
  /// In en, this message translates to:
  /// **'Survey saved as draft'**
  String get surveyBuilderSavedAsDraft;

  /// No description provided for @surveyBuilderSaveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save Draft'**
  String get surveyBuilderSaveDraft;

  /// No description provided for @surveyBuilderSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get surveyBuilderSelectDate;

  /// No description provided for @surveyBuilderSelectFromPanel.
  ///
  /// In en, this message translates to:
  /// **'Select questions from the available question list'**
  String get surveyBuilderSelectFromPanel;

  /// No description provided for @surveyBuilderShowQuestionBank.
  ///
  /// In en, this message translates to:
  /// **'Show Question Bank'**
  String get surveyBuilderShowQuestionBank;

  /// No description provided for @surveyBuilderStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get surveyBuilderStartDate;

  /// No description provided for @surveyBuilderStartFromTemplate.
  ///
  /// In en, this message translates to:
  /// **'Start from Template'**
  String get surveyBuilderStartFromTemplate;

  /// No description provided for @surveyBuilderTapToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add Questions\" to select from the question bank'**
  String get surveyBuilderTapToAdd;

  /// No description provided for @surveyBuilderTapToAddQuestion.
  ///
  /// In en, this message translates to:
  /// **'Tap a question to add it to your survey'**
  String get surveyBuilderTapToAddQuestion;

  /// No description provided for @surveyBuilderTemplateLoaded.
  ///
  /// In en, this message translates to:
  /// **'Loaded template: {title}'**
  String surveyBuilderTemplateLoaded(String title);

  /// No description provided for @surveyBuilderTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a descriptive title'**
  String get surveyBuilderTitleHint;

  /// No description provided for @surveyBuilderTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Survey Title *'**
  String get surveyBuilderTitleLabel;

  /// No description provided for @surveyBuilderTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get surveyBuilderTitleRequired;

  /// No description provided for @surveyBuilderUntitledSurvey.
  ///
  /// In en, this message translates to:
  /// **'Untitled Survey'**
  String get surveyBuilderUntitledSurvey;

  /// No description provided for @surveyBuilderUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Survey updated successfully'**
  String get surveyBuilderUpdatedSuccess;

  /// No description provided for @surveyBuilderUpdateSurvey.
  ///
  /// In en, this message translates to:
  /// **'Update Survey'**
  String get surveyBuilderUpdateSurvey;

  /// No description provided for @surveyCardAssign.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get surveyCardAssign;

  /// No description provided for @surveyCardClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get surveyCardClose;

  /// No description provided for @surveyCardDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get surveyCardDelete;

  /// No description provided for @surveyCardEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get surveyCardEdit;

  /// No description provided for @surveyCardPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get surveyCardPublish;

  /// No description provided for @surveyCardViewStatus.
  ///
  /// In en, this message translates to:
  /// **'View Survey Status'**
  String get surveyCardViewStatus;

  /// No description provided for @surveyCloseButton.
  ///
  /// In en, this message translates to:
  /// **'Close Survey'**
  String get surveyCloseButton;

  /// No description provided for @surveyClosedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Survey closed'**
  String get surveyClosedSuccess;

  /// No description provided for @surveyCloseFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to close survey: {error}'**
  String surveyCloseFailed(String error);

  /// No description provided for @surveyCloseMessage.
  ///
  /// In en, this message translates to:
  /// **'Closing the survey will prevent new responses. Are you sure you want to close it?'**
  String get surveyCloseMessage;

  /// No description provided for @surveyCloseTitle.
  ///
  /// In en, this message translates to:
  /// **'Close Survey'**
  String get surveyCloseTitle;

  /// No description provided for @surveyDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?\n\nExisting responses will be preserved for research purposes. This action cannot be undone.'**
  String surveyDeleteConfirm(String title);

  /// No description provided for @surveyDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Survey deleted'**
  String get surveyDeletedSuccess;

  /// No description provided for @surveyDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete: {error}'**
  String surveyDeleteFailed(String error);

  /// No description provided for @surveyDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Survey'**
  String get surveyDeleteTitle;

  /// No description provided for @surveyListAllSurveys.
  ///
  /// In en, this message translates to:
  /// **'All Surveys'**
  String get surveyListAllSurveys;

  /// No description provided for @surveyListClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get surveyListClearAll;

  /// No description provided for @surveyListClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get surveyListClosed;

  /// No description provided for @surveyListCreateSurvey.
  ///
  /// In en, this message translates to:
  /// **'Create Survey'**
  String get surveyListCreateSurvey;

  /// No description provided for @surveyListDateFrom.
  ///
  /// In en, this message translates to:
  /// **'From {date}'**
  String surveyListDateFrom(String date);

  /// No description provided for @surveyListDateUntil.
  ///
  /// In en, this message translates to:
  /// **'Until {date}'**
  String surveyListDateUntil(String date);

  /// No description provided for @surveyListDrafts.
  ///
  /// In en, this message translates to:
  /// **'Drafts'**
  String get surveyListDrafts;

  /// No description provided for @surveyListFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load surveys'**
  String get surveyListFailedToLoad;

  /// No description provided for @surveyListFiltersLabel.
  ///
  /// In en, this message translates to:
  /// **'Filters: '**
  String get surveyListFiltersLabel;

  /// No description provided for @surveyListNewSurvey.
  ///
  /// In en, this message translates to:
  /// **'New Survey'**
  String get surveyListNewSurvey;

  /// No description provided for @surveyListNoMatchFilters.
  ///
  /// In en, this message translates to:
  /// **'No surveys match your filters'**
  String get surveyListNoMatchFilters;

  /// No description provided for @surveyListNoSurveys.
  ///
  /// In en, this message translates to:
  /// **'No surveys yet'**
  String get surveyListNoSurveys;

  /// No description provided for @surveyListPublished.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get surveyListPublished;

  /// No description provided for @surveyListQuestionCount.
  ///
  /// In en, this message translates to:
  /// **'{count} questions'**
  String surveyListQuestionCount(int count);

  /// No description provided for @surveyListSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search surveys...'**
  String get surveyListSearchPlaceholder;

  /// No description provided for @surveyListStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get surveyListStatus;

  /// No description provided for @surveyListStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String surveyListStatusLabel(String status);

  /// No description provided for @surveyListTitle.
  ///
  /// In en, this message translates to:
  /// **'Surveys'**
  String get surveyListTitle;

  /// No description provided for @surveyNumberQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a number'**
  String get surveyNumberQuestionHint;

  /// No description provided for @surveyOpenEndedHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your response'**
  String get surveyOpenEndedHint;

  /// No description provided for @surveyPreviewAddQuestions.
  ///
  /// In en, this message translates to:
  /// **'Add questions to see how your survey will look'**
  String get surveyPreviewAddQuestions;

  /// No description provided for @surveyPreviewFooterNote.
  ///
  /// In en, this message translates to:
  /// **'This is a preview. Responses are not saved.'**
  String get surveyPreviewFooterNote;

  /// No description provided for @surveyPreviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Survey Preview'**
  String get surveyPreviewLabel;

  /// No description provided for @surveyPreviewNoQuestions.
  ///
  /// In en, this message translates to:
  /// **'No questions in this survey'**
  String get surveyPreviewNoQuestions;

  /// No description provided for @surveyPreviewNote.
  ///
  /// In en, this message translates to:
  /// **'This is a preview. Responses are not saved.'**
  String get surveyPreviewNote;

  /// No description provided for @surveyPreviewQuestionNumber.
  ///
  /// In en, this message translates to:
  /// **'Question {number}'**
  String surveyPreviewQuestionNumber(int number);

  /// No description provided for @surveyPreviewScaleHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get surveyPreviewScaleHigh;

  /// No description provided for @surveyPreviewScaleLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get surveyPreviewScaleLow;

  /// No description provided for @surveyPreviewUnsupportedType.
  ///
  /// In en, this message translates to:
  /// **'Unsupported question type: {type}'**
  String surveyPreviewUnsupportedType(String type);

  /// No description provided for @surveyPublishButton.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get surveyPublishButton;

  /// No description provided for @surveyPublishedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Survey published successfully'**
  String get surveyPublishedSuccess;

  /// No description provided for @surveyPublishFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to publish: {error}'**
  String surveyPublishFailed(String error);

  /// No description provided for @surveyPublishMessage.
  ///
  /// In en, this message translates to:
  /// **'Once published, the survey will be available for assignment. Are you sure you want to publish?'**
  String get surveyPublishMessage;

  /// No description provided for @surveyPublishTitle.
  ///
  /// In en, this message translates to:
  /// **'Publish Survey'**
  String get surveyPublishTitle;

  /// No description provided for @surveyStatusAssignedTotal.
  ///
  /// In en, this message translates to:
  /// **'Assigned Total'**
  String get surveyStatusAssignedTotal;

  /// No description provided for @surveyStatusAssignmentAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Assignment Analytics'**
  String get surveyStatusAssignmentAnalytics;

  /// No description provided for @surveyStatusChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Assignment Status Breakdown'**
  String get surveyStatusChartTitle;

  /// No description provided for @surveyStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get surveyStatusClosed;

  /// No description provided for @surveyStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get surveyStatusDraft;

  /// No description provided for @surveyStatusEndDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get surveyStatusEndDate;

  /// No description provided for @surveyStatusNoDate.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get surveyStatusNoDate;

  /// No description provided for @surveyStatusPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Survey Status'**
  String get surveyStatusPageTitle;

  /// No description provided for @surveyStatusPublished.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get surveyStatusPublished;

  /// No description provided for @surveyStatusStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get surveyStatusStartDate;

  /// No description provided for @surveySubmitErrorAlreadySubmitted.
  ///
  /// In en, this message translates to:
  /// **'You have already completed this survey.'**
  String get surveySubmitErrorAlreadySubmitted;

  /// No description provided for @surveySubmitErrorExpired.
  ///
  /// In en, this message translates to:
  /// **'This survey has expired and can no longer be submitted.'**
  String get surveySubmitErrorExpired;

  /// No description provided for @surveySubmitErrorGeneral.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit survey. Please try again.'**
  String get surveySubmitErrorGeneral;

  /// No description provided for @surveySubmitErrorNotAssigned.
  ///
  /// In en, this message translates to:
  /// **'You are not assigned to this survey.'**
  String get surveySubmitErrorNotAssigned;

  /// No description provided for @surveySubmitErrorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Survey not found.'**
  String get surveySubmitErrorNotFound;

  /// No description provided for @surveySubmitErrorNotPublished.
  ///
  /// In en, this message translates to:
  /// **'This survey is no longer accepting responses.'**
  String get surveySubmitErrorNotPublished;

  /// No description provided for @surveySubmitErrorServer.
  ///
  /// In en, this message translates to:
  /// **'A server error occurred. Please try again later.'**
  String get surveySubmitErrorServer;

  /// No description provided for @surveySubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Survey submitted successfully!'**
  String get surveySubmitSuccess;

  /// No description provided for @surveyTakingBackToSurveys.
  ///
  /// In en, this message translates to:
  /// **'Back to surveys'**
  String get surveyTakingBackToSurveys;

  /// No description provided for @surveyTakingCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get surveyTakingCancel;

  /// No description provided for @surveyTakingClosed.
  ///
  /// In en, this message translates to:
  /// **'This survey is no longer accepting responses.'**
  String get surveyTakingClosed;

  /// No description provided for @surveyTakingConfirmSubmitMessage.
  ///
  /// In en, this message translates to:
  /// **'You will not be able to edit your answers after submission.'**
  String get surveyTakingConfirmSubmitMessage;

  /// No description provided for @surveyTakingConfirmSubmitTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit survey?'**
  String get surveyTakingConfirmSubmitTitle;

  /// No description provided for @surveyTakingExpired.
  ///
  /// In en, this message translates to:
  /// **'This survey has expired.'**
  String get surveyTakingExpired;

  /// No description provided for @surveyTakingLoadingQuestions.
  ///
  /// In en, this message translates to:
  /// **'Loading questions...'**
  String get surveyTakingLoadingQuestions;

  /// No description provided for @surveyTakingNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection and retry.'**
  String get surveyTakingNetworkError;

  /// No description provided for @surveyTakingProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String surveyTakingProgress(int current, int total);

  /// No description provided for @surveyTakingQuestionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 question} other{{count} questions}}'**
  String surveyTakingQuestionCount(int count);

  /// No description provided for @surveyTakingRequired.
  ///
  /// In en, this message translates to:
  /// **'* Required'**
  String get surveyTakingRequired;

  /// No description provided for @surveyTakingRequiredError.
  ///
  /// In en, this message translates to:
  /// **'This question is required.'**
  String get surveyTakingRequiredError;

  /// No description provided for @surveyTakingRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get surveyTakingRetry;

  /// No description provided for @surveyTakingSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get surveyTakingSubmit;

  /// No description provided for @surveyTakingSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get surveyTakingSubmitting;

  /// No description provided for @surveyTakingTitle.
  ///
  /// In en, this message translates to:
  /// **'Take Survey'**
  String get surveyTakingTitle;

  /// No description provided for @surveyTakingValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please answer all required questions before submitting.'**
  String get surveyTakingValidationError;

  /// No description provided for @questionBankAddCount.
  ///
  /// In en, this message translates to:
  /// **'Add ({count})'**
  String questionBankAddCount(int count);

  /// No description provided for @questionBankAddQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add Question'**
  String get questionBankAddQuestion;

  /// No description provided for @questionBankAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get questionBankAllCategories;

  /// No description provided for @questionBankAllTypes.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get questionBankAllTypes;

  /// No description provided for @questionBankCategoryDemographics.
  ///
  /// In en, this message translates to:
  /// **'Demographics'**
  String get questionBankCategoryDemographics;

  /// No description provided for @questionBankCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category: {category}'**
  String questionBankCategoryLabel(String category);

  /// No description provided for @questionBankCategoryLifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get questionBankCategoryLifestyle;

  /// No description provided for @questionBankCategoryMentalHealth.
  ///
  /// In en, this message translates to:
  /// **'Mental Health'**
  String get questionBankCategoryMentalHealth;

  /// No description provided for @questionBankCategoryPhysicalHealth.
  ///
  /// In en, this message translates to:
  /// **'Physical Health'**
  String get questionBankCategoryPhysicalHealth;

  /// No description provided for @questionBankCategorySymptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get questionBankCategorySymptoms;

  /// No description provided for @questionBankClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get questionBankClearAll;

  /// No description provided for @questionBankClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get questionBankClearFilters;

  /// No description provided for @questionBankDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?\n\nThis action cannot be undone.'**
  String questionBankDeleteConfirm(String title);

  /// No description provided for @questionBankDeleted.
  ///
  /// In en, this message translates to:
  /// **'Question deleted'**
  String get questionBankDeleted;

  /// No description provided for @questionBankDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Question'**
  String get questionBankDeleteTitle;

  /// No description provided for @questionBankFailedToDelete.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete: {error}'**
  String questionBankFailedToDelete(String error);

  /// No description provided for @questionBankFailedToDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Failed to duplicate: {error}'**
  String questionBankFailedToDuplicate(String error);

  /// No description provided for @questionBankFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load questions'**
  String get questionBankFailedToLoad;

  /// No description provided for @questionBankFilterCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get questionBankFilterCategory;

  /// No description provided for @questionBankFiltersLabel.
  ///
  /// In en, this message translates to:
  /// **'Filters: '**
  String get questionBankFiltersLabel;

  /// No description provided for @questionBankFilterType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get questionBankFilterType;

  /// No description provided for @questionBankNewQuestion.
  ///
  /// In en, this message translates to:
  /// **'New Question'**
  String get questionBankNewQuestion;

  /// No description provided for @questionBankNoMatchFilters.
  ///
  /// In en, this message translates to:
  /// **'No questions match your filters'**
  String get questionBankNoMatchFilters;

  /// No description provided for @questionBankNoQuestions.
  ///
  /// In en, this message translates to:
  /// **'No questions yet'**
  String get questionBankNoQuestions;

  /// No description provided for @questionBankQuestionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Question deleted'**
  String get questionBankQuestionDeleted;

  /// No description provided for @questionBankQuestionDuplicated.
  ///
  /// In en, this message translates to:
  /// **'Question duplicated'**
  String get questionBankQuestionDuplicated;

  /// No description provided for @questionBankSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search: \"{query}\"'**
  String questionBankSearchLabel(String query);

  /// No description provided for @questionBankSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search questions...'**
  String get questionBankSearchPlaceholder;

  /// No description provided for @questionBankSelectQuestions.
  ///
  /// In en, this message translates to:
  /// **'Select Questions'**
  String get questionBankSelectQuestions;

  /// No description provided for @questionBankTitle.
  ///
  /// In en, this message translates to:
  /// **'Question Bank'**
  String get questionBankTitle;

  /// No description provided for @questionBankTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String questionBankTypeLabel(String type);

  /// No description provided for @questionCardDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get questionCardDelete;

  /// No description provided for @questionCardDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get questionCardDuplicate;

  /// No description provided for @questionCardEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get questionCardEdit;

  /// No description provided for @questionCardRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get questionCardRequired;

  /// No description provided for @questionCategoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get questionCategoryGeneral;

  /// No description provided for @questionCategoryLifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get questionCategoryLifestyle;

  /// No description provided for @questionCategoryMentalHealth.
  ///
  /// In en, this message translates to:
  /// **'Mental Health'**
  String get questionCategoryMentalHealth;

  /// No description provided for @questionCategoryNutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get questionCategoryNutrition;

  /// No description provided for @questionCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get questionCategoryOther;

  /// No description provided for @questionCategoryPhysicalHealth.
  ///
  /// In en, this message translates to:
  /// **'Physical Health'**
  String get questionCategoryPhysicalHealth;

  /// No description provided for @questionFormAddOption.
  ///
  /// In en, this message translates to:
  /// **'Add Option'**
  String get questionFormAddOption;

  /// No description provided for @questionFormCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Health, Lifestyle, Demographics'**
  String get questionFormCategoryHint;

  /// No description provided for @questionFormCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category (optional)'**
  String get questionFormCategoryLabel;

  /// No description provided for @questionFormCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get questionFormCreate;

  /// No description provided for @questionFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Question'**
  String get questionFormEditTitle;

  /// No description provided for @questionFormMinOptionsRequired.
  ///
  /// In en, this message translates to:
  /// **'Minimum 2 options required'**
  String get questionFormMinOptionsRequired;

  /// No description provided for @questionFormNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New Question'**
  String get questionFormNewTitle;

  /// No description provided for @questionFormOptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Option {number}'**
  String questionFormOptionLabel(int number);

  /// No description provided for @questionFormOptionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Options *'**
  String get questionFormOptionsLabel;

  /// No description provided for @questionFormProvideOptions.
  ///
  /// In en, this message translates to:
  /// **'Please provide at least 2 options'**
  String get questionFormProvideOptions;

  /// No description provided for @questionFormQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the question text'**
  String get questionFormQuestionHint;

  /// No description provided for @questionFormQuestionLabel.
  ///
  /// In en, this message translates to:
  /// **'Question *'**
  String get questionFormQuestionLabel;

  /// No description provided for @questionFormQuestionRequired.
  ///
  /// In en, this message translates to:
  /// **'Question text is required'**
  String get questionFormQuestionRequired;

  /// No description provided for @questionFormRemoveOption.
  ///
  /// In en, this message translates to:
  /// **'Remove option'**
  String get questionFormRemoveOption;

  /// No description provided for @questionFormRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get questionFormRequiredLabel;

  /// No description provided for @questionFormRequiredSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Participants must answer this question'**
  String get questionFormRequiredSubtitle;

  /// No description provided for @questionFormScaleMax.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get questionFormScaleMax;

  /// No description provided for @questionFormScaleMin.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get questionFormScaleMin;

  /// No description provided for @questionFormScaleRange.
  ///
  /// In en, this message translates to:
  /// **'Scale Range'**
  String get questionFormScaleRange;

  /// No description provided for @questionFormTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Short descriptive title'**
  String get questionFormTitleHint;

  /// No description provided for @questionFormTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title (optional)'**
  String get questionFormTitleLabel;

  /// No description provided for @questionFormTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Question Type *'**
  String get questionFormTypeLabel;

  /// No description provided for @questionNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get questionNo;

  /// No description provided for @questionTypeMultiChoice.
  ///
  /// In en, this message translates to:
  /// **'Multiple Choice'**
  String get questionTypeMultiChoice;

  /// No description provided for @questionTypeNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get questionTypeNumber;

  /// No description provided for @questionTypeOpenEnded.
  ///
  /// In en, this message translates to:
  /// **'Open Ended'**
  String get questionTypeOpenEnded;

  /// No description provided for @questionTypeScale.
  ///
  /// In en, this message translates to:
  /// **'Scale'**
  String get questionTypeScale;

  /// No description provided for @questionTypeSingleChoice.
  ///
  /// In en, this message translates to:
  /// **'Single Choice'**
  String get questionTypeSingleChoice;

  /// No description provided for @questionTypeText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get questionTypeText;

  /// No description provided for @questionTypeYesNo.
  ///
  /// In en, this message translates to:
  /// **'Yes/No'**
  String get questionTypeYesNo;

  /// No description provided for @questionYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get questionYes;

  /// No description provided for @templateBuilderAddQuestions.
  ///
  /// In en, this message translates to:
  /// **'Add Questions'**
  String get templateBuilderAddQuestions;

  /// No description provided for @templateBuilderAddQuestionsHint.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add Questions\" to select from the question bank'**
  String get templateBuilderAddQuestionsHint;

  /// No description provided for @templateBuilderBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get templateBuilderBack;

  /// No description provided for @templateBuilderCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Template created successfully'**
  String get templateBuilderCreatedSuccess;

  /// No description provided for @templateBuilderDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the purpose of this template'**
  String get templateBuilderDescriptionHint;

  /// No description provided for @templateBuilderDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get templateBuilderDescriptionLabel;

  /// No description provided for @templateBuilderEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Template'**
  String get templateBuilderEditTitle;

  /// No description provided for @templateBuilderNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New Template'**
  String get templateBuilderNewTitle;

  /// No description provided for @templateBuilderNoQuestions.
  ///
  /// In en, this message translates to:
  /// **'No questions added yet'**
  String get templateBuilderNoQuestions;

  /// No description provided for @templateBuilderPublicLabel.
  ///
  /// In en, this message translates to:
  /// **'Public Template'**
  String get templateBuilderPublicLabel;

  /// No description provided for @templateBuilderPublicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow other researchers to use this template'**
  String get templateBuilderPublicSubtitle;

  /// No description provided for @templateBuilderQuestionOptionalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This question will be optional in surveys created from this template.'**
  String get templateBuilderQuestionOptionalSubtitle;

  /// No description provided for @templateBuilderQuestionRequiredSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This question must be answered in surveys created from this template.'**
  String get templateBuilderQuestionRequiredSubtitle;

  /// No description provided for @templateBuilderQuestionsCount.
  ///
  /// In en, this message translates to:
  /// **'Questions ({count})'**
  String templateBuilderQuestionsCount(int count);

  /// No description provided for @templateBuilderRemoveQuestion.
  ///
  /// In en, this message translates to:
  /// **'Remove question'**
  String get templateBuilderRemoveQuestion;

  /// No description provided for @templateBuilderSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get templateBuilderSave;

  /// No description provided for @templateBuilderTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a descriptive title'**
  String get templateBuilderTitleHint;

  /// No description provided for @templateBuilderTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Template Title *'**
  String get templateBuilderTitleLabel;

  /// No description provided for @templateBuilderTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get templateBuilderTitleRequired;

  /// No description provided for @templateBuilderUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Template updated successfully'**
  String get templateBuilderUpdatedSuccess;

  /// No description provided for @templateCardCreateSurvey.
  ///
  /// In en, this message translates to:
  /// **'Create Survey'**
  String get templateCardCreateSurvey;

  /// No description provided for @templateCardDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get templateCardDelete;

  /// No description provided for @templateCardDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get templateCardDuplicate;

  /// No description provided for @templateCardEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get templateCardEdit;

  /// No description provided for @templateCardPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get templateCardPreview;

  /// No description provided for @templateCardQuestionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 question} other{{count} questions}}'**
  String templateCardQuestionCount(int count);

  /// No description provided for @templateListAllTemplates.
  ///
  /// In en, this message translates to:
  /// **'All Templates'**
  String get templateListAllTemplates;

  /// No description provided for @templateListClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get templateListClearAll;

  /// No description provided for @templateListCreateSurveyFrom.
  ///
  /// In en, this message translates to:
  /// **'Create survey from: {title}'**
  String templateListCreateSurveyFrom(String title);

  /// No description provided for @templateListCreateTemplate.
  ///
  /// In en, this message translates to:
  /// **'Create Template'**
  String get templateListCreateTemplate;

  /// No description provided for @templateListDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?\n\nThis action cannot be undone.'**
  String templateListDeleteConfirm(String title);

  /// No description provided for @templateListDeleted.
  ///
  /// In en, this message translates to:
  /// **'Template deleted'**
  String get templateListDeleted;

  /// No description provided for @templateListDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Template'**
  String get templateListDeleteTitle;

  /// No description provided for @templateListDuplicated.
  ///
  /// In en, this message translates to:
  /// **'Template duplicated'**
  String get templateListDuplicated;

  /// No description provided for @templateListFailedToDelete.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete: {error}'**
  String templateListFailedToDelete(String error);

  /// No description provided for @templateListFailedToDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Failed to duplicate: {error}'**
  String templateListFailedToDuplicate(String error);

  /// No description provided for @templateListFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load templates'**
  String get templateListFailedToLoad;

  /// No description provided for @templateListFailedToLoadTemplate.
  ///
  /// In en, this message translates to:
  /// **'Failed to load template: {error}'**
  String templateListFailedToLoadTemplate(String error);

  /// No description provided for @templateListFiltersLabel.
  ///
  /// In en, this message translates to:
  /// **'Filters: '**
  String get templateListFiltersLabel;

  /// No description provided for @templateListNewTemplate.
  ///
  /// In en, this message translates to:
  /// **'New Template'**
  String get templateListNewTemplate;

  /// No description provided for @templateListNoMatchFilters.
  ///
  /// In en, this message translates to:
  /// **'No templates match your filters'**
  String get templateListNoMatchFilters;

  /// No description provided for @templateListNoTemplates.
  ///
  /// In en, this message translates to:
  /// **'No templates yet'**
  String get templateListNoTemplates;

  /// No description provided for @templateListPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get templateListPrivate;

  /// No description provided for @templateListPublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get templateListPublic;

  /// No description provided for @templateListSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search templates...'**
  String get templateListSearchPlaceholder;

  /// No description provided for @templateListSelectTemplate.
  ///
  /// In en, this message translates to:
  /// **'Select Template'**
  String get templateListSelectTemplate;

  /// No description provided for @templateListTitle.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get templateListTitle;

  /// No description provided for @templateListVisibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get templateListVisibility;

  /// No description provided for @templateListVisibilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Visibility: {visibility}'**
  String templateListVisibilityLabel(String visibility);

  /// No description provided for @templatePreviewClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get templatePreviewClose;

  /// No description provided for @templatePreviewFooterNote.
  ///
  /// In en, this message translates to:
  /// **'This is a preview. Responses are not saved.'**
  String get templatePreviewFooterNote;

  /// No description provided for @templatePreviewNoQuestions.
  ///
  /// In en, this message translates to:
  /// **'No questions in this template'**
  String get templatePreviewNoQuestions;

  /// No description provided for @templatePreviewQuestionNumber.
  ///
  /// In en, this message translates to:
  /// **'Question {number}'**
  String templatePreviewQuestionNumber(int number);

  /// No description provided for @templatePreviewScaleHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get templatePreviewScaleHigh;

  /// No description provided for @templatePreviewScaleLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get templatePreviewScaleLow;

  /// No description provided for @templatePreviewSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get templatePreviewSelectDate;

  /// No description provided for @templatePreviewSelectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get templatePreviewSelectTime;

  /// No description provided for @templatePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get templatePreviewTitle;

  /// No description provided for @templatePreviewUnsupportedType.
  ///
  /// In en, this message translates to:
  /// **'Unsupported question type: {type}'**
  String templatePreviewUnsupportedType(String type);

  /// No description provided for @researchAddFields.
  ///
  /// In en, this message translates to:
  /// **'Add Fields'**
  String get researchAddFields;

  /// No description provided for @researchAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get researchAllCategories;

  /// No description provided for @researchAllTypes.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get researchAllTypes;

  /// No description provided for @researchAvailableQuestions.
  ///
  /// In en, this message translates to:
  /// **'Available Data Fields'**
  String get researchAvailableQuestions;

  /// No description provided for @researchCompletionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion Rate'**
  String get researchCompletionRate;

  /// No description provided for @researchCrossAvgCompletion.
  ///
  /// In en, this message translates to:
  /// **'Avg Completion'**
  String get researchCrossAvgCompletion;

  /// No description provided for @researchCrossDateFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get researchCrossDateFrom;

  /// No description provided for @researchCrossDateTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get researchCrossDateTo;

  /// No description provided for @researchCrossNoSurveysSelected.
  ///
  /// In en, this message translates to:
  /// **'Use + Add Fields to select data, or filter by survey to browse'**
  String get researchCrossNoSurveysSelected;

  /// No description provided for @researchCrossSelectSurveys.
  ///
  /// In en, this message translates to:
  /// **'Select surveys to pull data from'**
  String get researchCrossSelectSurveys;

  /// No description provided for @researchCrossSuppressedSurveys.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 survey} other{{count} surveys}} excluded (fewer than 5 respondents)'**
  String researchCrossSuppressedSurveys(int count);

  /// No description provided for @researchCrossSurveyColumn.
  ///
  /// In en, this message translates to:
  /// **'Survey'**
  String get researchCrossSurveyColumn;

  /// No description provided for @researchCrossSurveysCount.
  ///
  /// In en, this message translates to:
  /// **'Surveys'**
  String get researchCrossSurveysCount;

  /// No description provided for @researchCrossTotalQuestions.
  ///
  /// In en, this message translates to:
  /// **'Total Questions'**
  String get researchCrossTotalQuestions;

  /// No description provided for @researchCrossTotalRespondents.
  ///
  /// In en, this message translates to:
  /// **'Total Respondents'**
  String get researchCrossTotalRespondents;

  /// No description provided for @researchDataBankAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get researchDataBankAnalysis;

  /// No description provided for @researchDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Research Data'**
  String get researchDataTitle;

  /// No description provided for @researchDistribution.
  ///
  /// In en, this message translates to:
  /// **'Distribution'**
  String get researchDistribution;

  /// No description provided for @researcherActiveSurveys.
  ///
  /// In en, this message translates to:
  /// **'Active Surveys'**
  String get researcherActiveSurveys;

  /// No description provided for @researcherAddParticipant.
  ///
  /// In en, this message translates to:
  /// **'Add Participant'**
  String get researcherAddParticipant;

  /// No description provided for @researcherAssignSurvey.
  ///
  /// In en, this message translates to:
  /// **'Assign Survey'**
  String get researcherAssignSurvey;

  /// No description provided for @researcherClosedSurveys.
  ///
  /// In en, this message translates to:
  /// **'Closed Surveys'**
  String get researcherClosedSurveys;

  /// No description provided for @researcherCreateSurvey.
  ///
  /// In en, this message translates to:
  /// **'Create Survey'**
  String get researcherCreateSurvey;

  /// No description provided for @researcherDashboardChartTitle1.
  ///
  /// In en, this message translates to:
  /// **'Recent Surveys'**
  String get researcherDashboardChartTitle1;

  /// No description provided for @researcherDashboardChartTitle2.
  ///
  /// In en, this message translates to:
  /// **'Chart Title 2'**
  String get researcherDashboardChartTitle2;

  /// No description provided for @researcherDashboardChartTitle3.
  ///
  /// In en, this message translates to:
  /// **'Chart Title 3'**
  String get researcherDashboardChartTitle3;

  /// No description provided for @researcherDashboardChartTitle4.
  ///
  /// In en, this message translates to:
  /// **'Chart Title 4'**
  String get researcherDashboardChartTitle4;

  /// No description provided for @researcherDashboardGraphPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Graph placeholder'**
  String get researcherDashboardGraphPlaceholder;

  /// No description provided for @researcherDashboardGraphTitle1.
  ///
  /// In en, this message translates to:
  /// **'Survey Response counts'**
  String get researcherDashboardGraphTitle1;

  /// No description provided for @researcherDashboardGraphTitle2.
  ///
  /// In en, this message translates to:
  /// **'Survey Status Percentages'**
  String get researcherDashboardGraphTitle2;

  /// No description provided for @researcherDashboardKpiActiveSurveys.
  ///
  /// In en, this message translates to:
  /// **'Active surveys'**
  String get researcherDashboardKpiActiveSurveys;

  /// No description provided for @researcherDashboardKpiAvgCompletion.
  ///
  /// In en, this message translates to:
  /// **'Avg completion'**
  String get researcherDashboardKpiAvgCompletion;

  /// No description provided for @researcherDashboardKpiCompletedSurveys.
  ///
  /// In en, this message translates to:
  /// **'Completed surveys'**
  String get researcherDashboardKpiCompletedSurveys;

  /// No description provided for @researcherDashboardKpiTotalRespondents.
  ///
  /// In en, this message translates to:
  /// **'Total respondents'**
  String get researcherDashboardKpiTotalRespondents;

  /// No description provided for @researcherDashboardPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Researcher Dashboard\n(Placeholder)'**
  String get researcherDashboardPlaceholder;

  /// No description provided for @researcherDashboardSectionTitle1.
  ///
  /// In en, this message translates to:
  /// **'Survey Statistics Overview'**
  String get researcherDashboardSectionTitle1;

  /// No description provided for @researcherDashboardSectionTitle2.
  ///
  /// In en, this message translates to:
  /// **'Section Title 2'**
  String get researcherDashboardSectionTitle2;

  /// No description provided for @researcherDataAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Data Analytics'**
  String get researcherDataAnalytics;

  /// No description provided for @researcherDraftSurveys.
  ///
  /// In en, this message translates to:
  /// **'Draft Surveys'**
  String get researcherDraftSurveys;

  /// No description provided for @researcherEditSurvey.
  ///
  /// In en, this message translates to:
  /// **'Edit Survey'**
  String get researcherEditSurvey;

  /// No description provided for @researcherEnrolledParticipants.
  ///
  /// In en, this message translates to:
  /// **'Enrolled Participants'**
  String get researcherEnrolledParticipants;

  /// No description provided for @researcherExportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get researcherExportData;

  /// No description provided for @researcherGenerateReport.
  ///
  /// In en, this message translates to:
  /// **'Generate Report'**
  String get researcherGenerateReport;

  /// No description provided for @researcherParticipantDetails.
  ///
  /// In en, this message translates to:
  /// **'Participant Details'**
  String get researcherParticipantDetails;

  /// No description provided for @researcherParticipantList.
  ///
  /// In en, this message translates to:
  /// **'Participant List'**
  String get researcherParticipantList;

  /// No description provided for @researcherParticipants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get researcherParticipants;

  /// No description provided for @researcherPendingInvitations.
  ///
  /// In en, this message translates to:
  /// **'Pending Invitations'**
  String get researcherPendingInvitations;

  /// No description provided for @researcherQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get researcherQuickActions;

  /// No description provided for @researcherRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get researcherRecentActivity;

  /// No description provided for @researcherSurveyDetails.
  ///
  /// In en, this message translates to:
  /// **'Survey Details'**
  String get researcherSurveyDetails;

  /// No description provided for @researcherSurveyList.
  ///
  /// In en, this message translates to:
  /// **'Survey List'**
  String get researcherSurveyList;

  /// No description provided for @researcherSurveyResponses.
  ///
  /// In en, this message translates to:
  /// **'Survey Responses'**
  String get researcherSurveyResponses;

  /// No description provided for @researcherWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get researcherWelcomeBack;

  /// No description provided for @researchExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get researchExportCsv;

  /// No description provided for @researchFilterCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get researchFilterCategory;

  /// No description provided for @researchFilterResponseType.
  ///
  /// In en, this message translates to:
  /// **'Response Type'**
  String get researchFilterResponseType;

  /// No description provided for @researchHistogram.
  ///
  /// In en, this message translates to:
  /// **'Histogram'**
  String get researchHistogram;

  /// No description provided for @researchMean.
  ///
  /// In en, this message translates to:
  /// **'Mean'**
  String get researchMean;

  /// No description provided for @researchMedian.
  ///
  /// In en, this message translates to:
  /// **'Median'**
  String get researchMedian;

  /// No description provided for @researchModeCrossSurvey.
  ///
  /// In en, this message translates to:
  /// **'Data Bank'**
  String get researchModeCrossSurvey;

  /// No description provided for @researchModeHealthTracking.
  ///
  /// In en, this message translates to:
  /// **'Health Tracking'**
  String get researchModeHealthTracking;

  /// No description provided for @researchModeSingleSurvey.
  ///
  /// In en, this message translates to:
  /// **'By Survey'**
  String get researchModeSingleSurvey;

  /// No description provided for @researchNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get researchNo;

  /// No description provided for @researchNoData.
  ///
  /// In en, this message translates to:
  /// **'No response data available for this survey'**
  String get researchNoData;

  /// No description provided for @researchNoSurveys.
  ///
  /// In en, this message translates to:
  /// **'No surveys available'**
  String get researchNoSurveys;

  /// No description provided for @researchOpenEndedNote.
  ///
  /// In en, this message translates to:
  /// **'Open-ended responses are not displayed for privacy'**
  String get researchOpenEndedNote;

  /// No description provided for @researchOptionCounts.
  ///
  /// In en, this message translates to:
  /// **'Option Counts'**
  String get researchOptionCounts;

  /// No description provided for @researchQuestions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get researchQuestions;

  /// No description provided for @researchRange.
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get researchRange;

  /// No description provided for @researchRespondents.
  ///
  /// In en, this message translates to:
  /// **'Respondents'**
  String get researchRespondents;

  /// No description provided for @researchResponses.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 response} other{{count} responses}}'**
  String researchResponses(int count);

  /// No description provided for @researchSearchQuestions.
  ///
  /// In en, this message translates to:
  /// **'Search fields...'**
  String get researchSearchQuestions;

  /// No description provided for @researchSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get researchSelectAll;

  /// No description provided for @researchSelectedFields.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 field selected} other{{count} fields selected}}'**
  String researchSelectedFields(int count);

  /// No description provided for @researchSelectSurvey.
  ///
  /// In en, this message translates to:
  /// **'Select a survey'**
  String get researchSelectSurvey;

  /// No description provided for @researchStdDev.
  ///
  /// In en, this message translates to:
  /// **'Std Dev'**
  String get researchStdDev;

  /// No description provided for @researchSuppressed.
  ///
  /// In en, this message translates to:
  /// **'Insufficient responses (minimum {count} required)'**
  String researchSuppressed(int count);

  /// No description provided for @researchTabAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get researchTabAnalysis;

  /// No description provided for @researchTabDataTable.
  ///
  /// In en, this message translates to:
  /// **'Data Table'**
  String get researchTabDataTable;

  /// No description provided for @researchYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get researchYes;

  /// No description provided for @hcpActiveClients.
  ///
  /// In en, this message translates to:
  /// **'Active Clients'**
  String get hcpActiveClients;

  /// No description provided for @hcpAddClient.
  ///
  /// In en, this message translates to:
  /// **'Add Client'**
  String get hcpAddClient;

  /// No description provided for @hcpAllPatients.
  ///
  /// In en, this message translates to:
  /// **'All Patients'**
  String get hcpAllPatients;

  /// No description provided for @hcpAssignSurvey.
  ///
  /// In en, this message translates to:
  /// **'Assign Survey'**
  String get hcpAssignSurvey;

  /// No description provided for @hcpClientDetails.
  ///
  /// In en, this message translates to:
  /// **'Client Details'**
  String get hcpClientDetails;

  /// No description provided for @hcpClientList.
  ///
  /// In en, this message translates to:
  /// **'Client List'**
  String get hcpClientList;

  /// No description provided for @hcpClientReports.
  ///
  /// In en, this message translates to:
  /// **'Client Reports'**
  String get hcpClientReports;

  /// No description provided for @hcpClients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get hcpClients;

  /// No description provided for @hcpClientSurveys.
  ///
  /// In en, this message translates to:
  /// **'Client Surveys'**
  String get hcpClientSurveys;

  /// No description provided for @hcpDashboardLinkedPatients.
  ///
  /// In en, this message translates to:
  /// **'Linked Patients'**
  String get hcpDashboardLinkedPatients;

  /// No description provided for @hcpDashboardNoActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity.'**
  String get hcpDashboardNoActivity;

  /// No description provided for @hcpDashboardPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Requests'**
  String get hcpDashboardPendingRequests;

  /// No description provided for @hcpDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'HCP Dashboard'**
  String get hcpDashboardTitle;

  /// No description provided for @hcpDashboardWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String hcpDashboardWelcome(String name);

  /// No description provided for @hcpGenerateReport.
  ///
  /// In en, this message translates to:
  /// **'Generate Report'**
  String get hcpGenerateReport;

  /// No description provided for @hcpHealthSummary.
  ///
  /// In en, this message translates to:
  /// **'Health Summary'**
  String get hcpHealthSummary;

  /// No description provided for @hcpHtAggregateSeries.
  ///
  /// In en, this message translates to:
  /// **'Population avg.'**
  String get hcpHtAggregateSeries;

  /// No description provided for @hcpHtAggregateUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Population comparison unavailable (insufficient data).'**
  String get hcpHtAggregateUnavailable;

  /// No description provided for @hcpHtChartTypeBar.
  ///
  /// In en, this message translates to:
  /// **'Bar'**
  String get hcpHtChartTypeBar;

  /// No description provided for @hcpHtChartTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Chart type'**
  String get hcpHtChartTypeLabel;

  /// No description provided for @hcpHtChartTypeLine.
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get hcpHtChartTypeLine;

  /// No description provided for @hcpHtChartTypePie.
  ///
  /// In en, this message translates to:
  /// **'Pie'**
  String get hcpHtChartTypePie;

  /// No description provided for @hcpHtClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get hcpHtClearAll;

  /// No description provided for @hcpHtExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export Patient Data (CSV)'**
  String get hcpHtExportCsv;

  /// No description provided for @hcpHtFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get hcpHtFilters;

  /// No description provided for @hcpHtHideFilters.
  ///
  /// In en, this message translates to:
  /// **'Hide filters'**
  String get hcpHtHideFilters;

  /// No description provided for @hcpHtLoadCharts.
  ///
  /// In en, this message translates to:
  /// **'Load Charts'**
  String get hcpHtLoadCharts;

  /// No description provided for @hcpHtLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load health tracking data.'**
  String get hcpHtLoadError;

  /// No description provided for @hcpHtNMetricsSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String hcpHtNMetricsSelected(int count);

  /// No description provided for @hcpHtNoEntries.
  ///
  /// In en, this message translates to:
  /// **'This patient has no health tracking entries for the selected filters.'**
  String get hcpHtNoEntries;

  /// No description provided for @hcpHtNoEntriesForMetric.
  ///
  /// In en, this message translates to:
  /// **'No entries recorded for this metric in the selected period.'**
  String get hcpHtNoEntriesForMetric;

  /// No description provided for @hcpHtNoMetrics.
  ///
  /// In en, this message translates to:
  /// **'No health tracking metrics are configured.'**
  String get hcpHtNoMetrics;

  /// No description provided for @hcpHtPatientSeries.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get hcpHtPatientSeries;

  /// No description provided for @hcpHtSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get hcpHtSelectAll;

  /// No description provided for @hcpHtSelectMetrics.
  ///
  /// In en, this message translates to:
  /// **'Select metrics'**
  String get hcpHtSelectMetrics;

  /// No description provided for @hcpHtSelectMetricsHint.
  ///
  /// In en, this message translates to:
  /// **'Select at least one metric to load charts.'**
  String get hcpHtSelectMetricsHint;

  /// No description provided for @hcpHtSelectPatientFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a patient above to view their health tracking data.'**
  String get hcpHtSelectPatientFirst;

  /// No description provided for @hcpHtShowFilters.
  ///
  /// In en, this message translates to:
  /// **'Show filters'**
  String get hcpHtShowFilters;

  /// No description provided for @hcpHtViewComparison.
  ///
  /// In en, this message translates to:
  /// **'Comparison'**
  String get hcpHtViewComparison;

  /// No description provided for @hcpHtViewMode.
  ///
  /// In en, this message translates to:
  /// **'View mode'**
  String get hcpHtViewMode;

  /// No description provided for @hcpHtViewModeLabel.
  ///
  /// In en, this message translates to:
  /// **'View mode: patient only or comparison with population'**
  String get hcpHtViewModeLabel;

  /// No description provided for @hcpHtViewPatient.
  ///
  /// In en, this message translates to:
  /// **'Patient Only'**
  String get hcpHtViewPatient;

  /// No description provided for @hcpLinkEnterPatientEmail.
  ///
  /// In en, this message translates to:
  /// **'Patient email address'**
  String get hcpLinkEnterPatientEmail;

  /// No description provided for @hcpLinkEnterPatientId.
  ///
  /// In en, this message translates to:
  /// **'Enter Patient Account ID'**
  String get hcpLinkEnterPatientId;

  /// No description provided for @hcpLinkErrorDuplicate.
  ///
  /// In en, this message translates to:
  /// **'A link request already exists for this patient.'**
  String get hcpLinkErrorDuplicate;

  /// No description provided for @hcpLinkErrorGeneral.
  ///
  /// In en, this message translates to:
  /// **'Failed to send request. Please try again.'**
  String get hcpLinkErrorGeneral;

  /// No description provided for @hcpLinkErrorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Patient account not found.'**
  String get hcpLinkErrorNotFound;

  /// No description provided for @hcpLinkLinkedSince.
  ///
  /// In en, this message translates to:
  /// **'Linked since {date}'**
  String hcpLinkLinkedSince(String date);

  /// No description provided for @hcpLinkMyPatients.
  ///
  /// In en, this message translates to:
  /// **'Linked Patients'**
  String get hcpLinkMyPatients;

  /// No description provided for @hcpLinkNoPatients.
  ///
  /// In en, this message translates to:
  /// **'No linked patients yet.'**
  String get hcpLinkNoPatients;

  /// No description provided for @hcpLinkNoPending.
  ///
  /// In en, this message translates to:
  /// **'No pending requests.'**
  String get hcpLinkNoPending;

  /// No description provided for @hcpLinkPageTitle.
  ///
  /// In en, this message translates to:
  /// **'My Patients'**
  String get hcpLinkPageTitle;

  /// No description provided for @hcpLinkPatientEmailHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. john.smith@email.com'**
  String get hcpLinkPatientEmailHint;

  /// No description provided for @hcpLinkPendingFrom.
  ///
  /// In en, this message translates to:
  /// **'Requested {date}'**
  String hcpLinkPendingFrom(String date);

  /// No description provided for @hcpLinkPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Requests'**
  String get hcpLinkPendingRequests;

  /// No description provided for @hcpLinkRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get hcpLinkRemove;

  /// No description provided for @hcpLinkRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this patient link?'**
  String get hcpLinkRemoveConfirm;

  /// No description provided for @hcpLinkRequestPatient.
  ///
  /// In en, this message translates to:
  /// **'Request Patient Link'**
  String get hcpLinkRequestPatient;

  /// No description provided for @hcpLinkRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Link request sent'**
  String get hcpLinkRequestSent;

  /// No description provided for @hcpPatientConsentRevoked.
  ///
  /// In en, this message translates to:
  /// **'Consent Revoked'**
  String get hcpPatientConsentRevoked;

  /// No description provided for @hcpPatientLinkedSince.
  ///
  /// In en, this message translates to:
  /// **'Linked since {date}'**
  String hcpPatientLinkedSince(String date);

  /// No description provided for @hcpPatientNoSurveys.
  ///
  /// In en, this message translates to:
  /// **'No completed surveys.'**
  String get hcpPatientNoSurveys;

  /// No description provided for @hcpPatientSurveysTitle.
  ///
  /// In en, this message translates to:
  /// **'Completed Surveys'**
  String get hcpPatientSurveysTitle;

  /// No description provided for @hcpPatientViewSurveys.
  ///
  /// In en, this message translates to:
  /// **'View Surveys'**
  String get hcpPatientViewSurveys;

  /// No description provided for @hcpReportsError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load report data.'**
  String get hcpReportsError;

  /// No description provided for @hcpReportsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading report...'**
  String get hcpReportsLoading;

  /// No description provided for @hcpReportsNoPatients.
  ///
  /// In en, this message translates to:
  /// **'No linked patients to report on.'**
  String get hcpReportsNoPatients;

  /// No description provided for @hcpReportsNoSelection.
  ///
  /// In en, this message translates to:
  /// **'Select a patient and survey to view the report.'**
  String get hcpReportsNoSelection;

  /// No description provided for @hcpReportsNoSurveys.
  ///
  /// In en, this message translates to:
  /// **'This patient has no completed surveys.'**
  String get hcpReportsNoSurveys;

  /// No description provided for @hcpReportsSelectPatient.
  ///
  /// In en, this message translates to:
  /// **'Select a Patient'**
  String get hcpReportsSelectPatient;

  /// No description provided for @hcpReportsSelectSurvey.
  ///
  /// In en, this message translates to:
  /// **'Select a Survey'**
  String get hcpReportsSelectSurvey;

  /// No description provided for @hcpReportsTabHealthTracking.
  ///
  /// In en, this message translates to:
  /// **'Health Tracking'**
  String get hcpReportsTabHealthTracking;

  /// No description provided for @hcpReportsTabSurveys.
  ///
  /// In en, this message translates to:
  /// **'Surveys'**
  String get hcpReportsTabSurveys;

  /// No description provided for @hcpReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Patient Reports'**
  String get hcpReportsTitle;

  /// No description provided for @hcpSurveyChartAggregate.
  ///
  /// In en, this message translates to:
  /// **'Population avg.'**
  String get hcpSurveyChartAggregate;

  /// No description provided for @hcpSurveyChartAggUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Population comparison unavailable (insufficient data).'**
  String get hcpSurveyChartAggUnavailable;

  /// No description provided for @hcpSurveyChartComparison.
  ///
  /// In en, this message translates to:
  /// **'Comparison'**
  String get hcpSurveyChartComparison;

  /// No description provided for @hcpSurveyChartComparisonModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Chart comparison mode'**
  String get hcpSurveyChartComparisonModeLabel;

  /// No description provided for @hcpSurveyChartNoNumeric.
  ///
  /// In en, this message translates to:
  /// **'No numeric or scale questions in this survey to chart.'**
  String get hcpSurveyChartNoNumeric;

  /// No description provided for @hcpSurveyChartPatient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get hcpSurveyChartPatient;

  /// No description provided for @hcpSurveyChartPatientOnly.
  ///
  /// In en, this message translates to:
  /// **'Patient Only'**
  String get hcpSurveyChartPatientOnly;

  /// No description provided for @hcpSurveyChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Survey Results — {surveyTitle}'**
  String hcpSurveyChartTitle(String surveyTitle);

  /// No description provided for @hcpSurveyHistory.
  ///
  /// In en, this message translates to:
  /// **'Survey History'**
  String get hcpSurveyHistory;

  /// No description provided for @hcpSurveyViewChart.
  ///
  /// In en, this message translates to:
  /// **'Charts'**
  String get hcpSurveyViewChart;

  /// No description provided for @hcpSurveyViewModeLabel.
  ///
  /// In en, this message translates to:
  /// **'View mode: responses table or charts'**
  String get hcpSurveyViewModeLabel;

  /// No description provided for @hcpSurveyViewTable.
  ///
  /// In en, this message translates to:
  /// **'Responses'**
  String get hcpSurveyViewTable;

  /// No description provided for @hcpTodaySchedule.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get hcpTodaySchedule;

  /// No description provided for @hcpUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown HCP'**
  String get hcpUnknown;

  /// No description provided for @hcpUpcomingAppointments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointments'**
  String get hcpUpcomingAppointments;

  /// No description provided for @hcpWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get hcpWelcomeBack;

  /// No description provided for @messagesComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Messages management coming soon...'**
  String get messagesComingSoon;

  /// No description provided for @messagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesTitle;

  /// No description provided for @messagingAcceptRequest.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get messagingAcceptRequest;

  /// No description provided for @messagingAddColleague.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get messagingAddColleague;

  /// No description provided for @messagingAdminAccountIdHint.
  ///
  /// In en, this message translates to:
  /// **'Enter numeric account ID'**
  String get messagingAdminAccountIdHint;

  /// No description provided for @messagingAdminAccountIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Account ID'**
  String get messagingAdminAccountIdLabel;

  /// No description provided for @messagingBrowseColleagues.
  ///
  /// In en, this message translates to:
  /// **'Browse Colleagues'**
  String get messagingBrowseColleagues;

  /// No description provided for @messagingBrowseColleaguesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add researchers from your institution'**
  String get messagingBrowseColleaguesSubtitle;

  /// No description provided for @messagingColleagueAdded.
  ///
  /// In en, this message translates to:
  /// **'Contact request sent'**
  String get messagingColleagueAdded;

  /// No description provided for @messagingColleagueAddError.
  ///
  /// In en, this message translates to:
  /// **'Could not send request'**
  String get messagingColleagueAddError;

  /// No description provided for @messagingColleagueRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Request sent'**
  String get messagingColleagueRequestSent;

  /// No description provided for @messagingContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get messagingContacts;

  /// No description provided for @messagingContactsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Contacts'**
  String get messagingContactsTitle;

  /// No description provided for @messagingConversationTitle.
  ///
  /// In en, this message translates to:
  /// **'Conversation'**
  String get messagingConversationTitle;

  /// No description provided for @messagingDeleteContact.
  ///
  /// In en, this message translates to:
  /// **'Delete contact'**
  String get messagingDeleteContact;

  /// No description provided for @messagingDeleteContactConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this contact? You can re-add them later.'**
  String get messagingDeleteContactConfirm;

  /// No description provided for @messagingDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete message'**
  String get messagingDeleteMessage;

  /// No description provided for @messagingDeleteMessageConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this message?'**
  String get messagingDeleteMessageConfirm;

  /// No description provided for @messagingEditContact.
  ///
  /// In en, this message translates to:
  /// **'Edit contact'**
  String get messagingEditContact;

  /// No description provided for @messagingEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter email address to start a conversation'**
  String get messagingEmailHint;

  /// No description provided for @messagingEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get messagingEmailLabel;

  /// No description provided for @messagingEmailNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found for that email'**
  String get messagingEmailNotFound;

  /// No description provided for @messagingEmailPermission.
  ///
  /// In en, this message translates to:
  /// **'You are not allowed to message this user'**
  String get messagingEmailPermission;

  /// No description provided for @messagingError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load messages.'**
  String get messagingError;

  /// No description provided for @messagingFriendAccepted.
  ///
  /// In en, this message translates to:
  /// **'Contact request accepted'**
  String get messagingFriendAccepted;

  /// No description provided for @messagingFriendDeclined.
  ///
  /// In en, this message translates to:
  /// **'Contact request declined'**
  String get messagingFriendDeclined;

  /// No description provided for @messagingFriendEmailHint.
  ///
  /// In en, this message translates to:
  /// **'contact@example.com'**
  String get messagingFriendEmailHint;

  /// No description provided for @messagingFriendRequestEmail.
  ///
  /// In en, this message translates to:
  /// **'Contact\'s email address'**
  String get messagingFriendRequestEmail;

  /// No description provided for @messagingFriendRequestError.
  ///
  /// In en, this message translates to:
  /// **'Failed to send request. Please try again.'**
  String get messagingFriendRequestError;

  /// No description provided for @messagingFriendRequestSend.
  ///
  /// In en, this message translates to:
  /// **'Send Contact Request'**
  String get messagingFriendRequestSend;

  /// No description provided for @messagingFriendRequestSent.
  ///
  /// In en, this message translates to:
  /// **'If this user exists, a contact request will be sent.'**
  String get messagingFriendRequestSent;

  /// No description provided for @messagingFriendRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a Contact'**
  String get messagingFriendRequestTitle;

  /// No description provided for @messagingInboxTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagingInboxTitle;

  /// No description provided for @messagingIncomingRequests.
  ///
  /// In en, this message translates to:
  /// **'Contact Requests'**
  String get messagingIncomingRequests;

  /// No description provided for @messagingJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get messagingJustNow;

  /// No description provided for @messagingLastMessage.
  ///
  /// In en, this message translates to:
  /// **'Last message'**
  String get messagingLastMessage;

  /// No description provided for @messagingLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading messages...'**
  String get messagingLoading;

  /// No description provided for @messagingMessagePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get messagingMessagePlaceholder;

  /// No description provided for @messagingNewConversationTitle.
  ///
  /// In en, this message translates to:
  /// **'New Conversation'**
  String get messagingNewConversationTitle;

  /// No description provided for @messagingNoColleaguesFound.
  ///
  /// In en, this message translates to:
  /// **'No researchers found'**
  String get messagingNoColleaguesFound;

  /// No description provided for @messagingNoContacts.
  ///
  /// In en, this message translates to:
  /// **'No contacts yet. Add a contact to start messaging.'**
  String get messagingNoContacts;

  /// No description provided for @messagingNoConversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet.'**
  String get messagingNoConversations;

  /// No description provided for @messagingNoIncomingRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending contact requests.'**
  String get messagingNoIncomingRequests;

  /// No description provided for @messagingNoMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet. Say hello!'**
  String get messagingNoMessages;

  /// No description provided for @messagingNoRecipients.
  ///
  /// In en, this message translates to:
  /// **'No available recipients.'**
  String get messagingNoRecipients;

  /// No description provided for @messagingOpenConversationWith.
  ///
  /// In en, this message translates to:
  /// **'Open conversation with {name}'**
  String messagingOpenConversationWith(String name);

  /// No description provided for @messagingOrPickFromContacts.
  ///
  /// In en, this message translates to:
  /// **'Or pick from your contacts'**
  String get messagingOrPickFromContacts;

  /// No description provided for @messagingOrPickFromPatients.
  ///
  /// In en, this message translates to:
  /// **'Or pick from your patients'**
  String get messagingOrPickFromPatients;

  /// No description provided for @messagingRecipientFriend.
  ///
  /// In en, this message translates to:
  /// **'My Contacts'**
  String get messagingRecipientFriend;

  /// No description provided for @messagingRecipientHcp.
  ///
  /// In en, this message translates to:
  /// **'My Healthcare Provider'**
  String get messagingRecipientHcp;

  /// No description provided for @messagingRecipientPatient.
  ///
  /// In en, this message translates to:
  /// **'A Patient'**
  String get messagingRecipientPatient;

  /// No description provided for @messagingRecipientResearcher.
  ///
  /// In en, this message translates to:
  /// **'Researchers'**
  String get messagingRecipientResearcher;

  /// No description provided for @messagingRejectRequest.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get messagingRejectRequest;

  /// No description provided for @messagingSearchColleagues.
  ///
  /// In en, this message translates to:
  /// **'Search by name...'**
  String get messagingSearchColleagues;

  /// No description provided for @messagingSearchMinChars.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 2 characters to search.'**
  String get messagingSearchMinChars;

  /// No description provided for @messagingSearchResearchers.
  ///
  /// In en, this message translates to:
  /// **'Search researchers...'**
  String get messagingSearchResearchers;

  /// No description provided for @messagingSelectConversation.
  ///
  /// In en, this message translates to:
  /// **'Select a conversation to start messaging'**
  String get messagingSelectConversation;

  /// No description provided for @messagingSelectRecipient.
  ///
  /// In en, this message translates to:
  /// **'Select a recipient'**
  String get messagingSelectRecipient;

  /// No description provided for @messagingSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get messagingSend;

  /// No description provided for @messagingSendError.
  ///
  /// In en, this message translates to:
  /// **'Failed to send message. Please try again.'**
  String get messagingSendError;

  /// No description provided for @messagingSending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get messagingSending;

  /// No description provided for @messagingStartConversation.
  ///
  /// In en, this message translates to:
  /// **'New Message'**
  String get messagingStartConversation;

  /// No description provided for @messagingUnreadBadge.
  ///
  /// In en, this message translates to:
  /// **'{count} unread'**
  String messagingUnreadBadge(int count);

  /// No description provided for @messagingYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get messagingYou;

  /// No description provided for @ticketPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get ticketPriorityHigh;

  /// No description provided for @ticketPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get ticketPriorityLow;

  /// No description provided for @ticketPriorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get ticketPriorityMedium;

  /// No description provided for @ticketsColumnCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get ticketsColumnCreated;

  /// No description provided for @ticketsColumnId.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get ticketsColumnId;

  /// No description provided for @ticketsColumnPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get ticketsColumnPriority;

  /// No description provided for @ticketsColumnStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get ticketsColumnStatus;

  /// No description provided for @ticketsColumnSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get ticketsColumnSubject;

  /// No description provided for @ticketStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get ticketStatusClosed;

  /// No description provided for @ticketStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get ticketStatusOpen;

  /// No description provided for @ticketStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get ticketStatusPending;

  /// No description provided for @ticketsTitle.
  ///
  /// In en, this message translates to:
  /// **'Support Tickets'**
  String get ticketsTitle;

  /// No description provided for @adminAccountRequests.
  ///
  /// In en, this message translates to:
  /// **'Account Requests'**
  String get adminAccountRequests;

  /// No description provided for @adminAccountRequestsApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get adminAccountRequestsApprove;

  /// No description provided for @adminAccountRequestsApproveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to approve this account request? An account will be created and the user will receive an email with their login credentials.'**
  String get adminAccountRequestsApproveConfirm;

  /// No description provided for @adminAccountRequestsApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get adminAccountRequestsApproved;

  /// No description provided for @adminAccountRequestsApproved_msg.
  ///
  /// In en, this message translates to:
  /// **'Account request approved successfully'**
  String get adminAccountRequestsApproved_msg;

  /// No description provided for @adminAccountRequestsDate.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get adminAccountRequestsDate;

  /// No description provided for @adminAccountRequestsEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get adminAccountRequestsEmail;

  /// No description provided for @adminAccountRequestsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No account requests found'**
  String get adminAccountRequestsEmpty;

  /// No description provided for @adminAccountRequestsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading account requests'**
  String get adminAccountRequestsLoadError;

  /// No description provided for @adminAccountRequestsName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get adminAccountRequestsName;

  /// No description provided for @adminAccountRequestsPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get adminAccountRequestsPending;

  /// No description provided for @adminAccountRequestsReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get adminAccountRequestsReject;

  /// No description provided for @adminAccountRequestsRejectConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject this account request?'**
  String get adminAccountRequestsRejectConfirm;

  /// No description provided for @adminAccountRequestsRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get adminAccountRequestsRejected;

  /// No description provided for @adminAccountRequestsRejected_msg.
  ///
  /// In en, this message translates to:
  /// **'Account request rejected'**
  String get adminAccountRequestsRejected_msg;

  /// No description provided for @adminAccountRequestsRejectNotes.
  ///
  /// In en, this message translates to:
  /// **'Rejection notes (optional)'**
  String get adminAccountRequestsRejectNotes;

  /// No description provided for @adminAccountRequestsRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get adminAccountRequestsRole;

  /// No description provided for @adminAccountStatus.
  ///
  /// In en, this message translates to:
  /// **'Account Status'**
  String get adminAccountStatus;

  /// No description provided for @adminAddUser.
  ///
  /// In en, this message translates to:
  /// **'Add User'**
  String get adminAddUser;

  /// No description provided for @adminAddUserDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth (optional)'**
  String get adminAddUserDateOfBirth;

  /// No description provided for @adminAddUserGender.
  ///
  /// In en, this message translates to:
  /// **'Gender (optional)'**
  String get adminAddUserGender;

  /// No description provided for @adminAddUserParticipantOptionals.
  ///
  /// In en, this message translates to:
  /// **'Participant details (optional)'**
  String get adminAddUserParticipantOptionals;

  /// No description provided for @adminAddUserSendSetupEmail.
  ///
  /// In en, this message translates to:
  /// **'Send account setup email'**
  String get adminAddUserSendSetupEmail;

  /// No description provided for @adminAddUserSendSetupEmailHint.
  ///
  /// In en, this message translates to:
  /// **'A temporary password will be generated and emailed to the user'**
  String get adminAddUserSendSetupEmailHint;

  /// No description provided for @adminAssignTicket.
  ///
  /// In en, this message translates to:
  /// **'Assign Ticket'**
  String get adminAssignTicket;

  /// No description provided for @adminAuditLog.
  ///
  /// In en, this message translates to:
  /// **'Audit Log'**
  String get adminAuditLog;

  /// No description provided for @adminBackToAdmin.
  ///
  /// In en, this message translates to:
  /// **'Back to Admin'**
  String get adminBackToAdmin;

  /// No description provided for @adminBackupDatabase.
  ///
  /// In en, this message translates to:
  /// **'Backup Database'**
  String get adminBackupDatabase;

  /// No description provided for @adminClosedTickets.
  ///
  /// In en, this message translates to:
  /// **'Closed Tickets'**
  String get adminClosedTickets;

  /// No description provided for @adminCloseTicket.
  ///
  /// In en, this message translates to:
  /// **'Close Ticket'**
  String get adminCloseTicket;

  /// No description provided for @adminCompose.
  ///
  /// In en, this message translates to:
  /// **'Compose'**
  String get adminCompose;

  /// No description provided for @adminDashboardAccountRequests.
  ///
  /// In en, this message translates to:
  /// **'Account Requests'**
  String get adminDashboardAccountRequests;

  /// No description provided for @adminDashboardActiveUsersDetail.
  ///
  /// In en, this message translates to:
  /// **'{count} active users'**
  String adminDashboardActiveUsersDetail(int count);

  /// No description provided for @adminDashboardAdminV2Preview.
  ///
  /// In en, this message translates to:
  /// **'Admin v2 Preview'**
  String get adminDashboardAdminV2Preview;

  /// No description provided for @adminDashboardAuditLog.
  ///
  /// In en, this message translates to:
  /// **'Audit Log'**
  String get adminDashboardAuditLog;

  /// No description provided for @adminDashboardBackupAgo.
  ///
  /// In en, this message translates to:
  /// **'ago'**
  String get adminDashboardBackupAgo;

  /// No description provided for @adminDashboardBackupNone.
  ///
  /// In en, this message translates to:
  /// **'No backups'**
  String get adminDashboardBackupNone;

  /// No description provided for @adminDashboardDatabaseViewer.
  ///
  /// In en, this message translates to:
  /// **'Database Viewer'**
  String get adminDashboardDatabaseViewer;

  /// No description provided for @adminDashboardDraftCount.
  ///
  /// In en, this message translates to:
  /// **'{count} drafts'**
  String adminDashboardDraftCount(int count);

  /// No description provided for @adminDashboardFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load dashboard'**
  String get adminDashboardFailedToLoad;

  /// No description provided for @adminDashboardKpiActiveSurveys.
  ///
  /// In en, this message translates to:
  /// **'Active Surveys'**
  String get adminDashboardKpiActiveSurveys;

  /// No description provided for @adminDashboardKpiDraftSurveys.
  ///
  /// In en, this message translates to:
  /// **'Draft Surveys'**
  String get adminDashboardKpiDraftSurveys;

  /// No description provided for @adminDashboardKpiLatestBackup.
  ///
  /// In en, this message translates to:
  /// **'Latest Backup'**
  String get adminDashboardKpiLatestBackup;

  /// No description provided for @adminDashboardKpiNew30d.
  ///
  /// In en, this message translates to:
  /// **'New (30 days)'**
  String get adminDashboardKpiNew30d;

  /// No description provided for @adminDashboardKpiPendingDeletions.
  ///
  /// In en, this message translates to:
  /// **'Pending Deletions'**
  String get adminDashboardKpiPendingDeletions;

  /// No description provided for @adminDashboardKpiPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Requests'**
  String get adminDashboardKpiPendingRequests;

  /// No description provided for @adminDashboardKpiResponses.
  ///
  /// In en, this message translates to:
  /// **'Responses'**
  String get adminDashboardKpiResponses;

  /// No description provided for @adminDashboardKpiTotalResponses.
  ///
  /// In en, this message translates to:
  /// **'Total Responses'**
  String get adminDashboardKpiTotalResponses;

  /// No description provided for @adminDashboardKpiTotalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get adminDashboardKpiTotalUsers;

  /// No description provided for @adminDashboardManageUsers.
  ///
  /// In en, this message translates to:
  /// **'Manage Users'**
  String get adminDashboardManageUsers;

  /// No description provided for @adminDashboardNewIn30Days.
  ///
  /// In en, this message translates to:
  /// **'{count} new in 30 days'**
  String adminDashboardNewIn30Days(int count);

  /// No description provided for @adminDashboardNoActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get adminDashboardNoActivity;

  /// No description provided for @adminDashboardNoPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending requests'**
  String get adminDashboardNoPendingRequests;

  /// No description provided for @adminDashboardNoUsers.
  ///
  /// In en, this message translates to:
  /// **'No users yet'**
  String get adminDashboardNoUsers;

  /// No description provided for @adminDashboardPendingAccountAlert.
  ///
  /// In en, this message translates to:
  /// **'{count} pending account requests awaiting approval'**
  String adminDashboardPendingAccountAlert(int count);

  /// No description provided for @adminDashboardPendingAccountRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Account Requests'**
  String get adminDashboardPendingAccountRequests;

  /// No description provided for @adminDashboardPendingDeletionAlert.
  ///
  /// In en, this message translates to:
  /// **'{count} pending deletion requests'**
  String adminDashboardPendingDeletionAlert(int count);

  /// No description provided for @adminDashboardPendingDeletionRequests.
  ///
  /// In en, this message translates to:
  /// **'Pending Deletion Requests'**
  String get adminDashboardPendingDeletionRequests;

  /// No description provided for @adminDashboardQuickLinks.
  ///
  /// In en, this message translates to:
  /// **'Quick Links'**
  String get adminDashboardQuickLinks;

  /// No description provided for @adminDashboardRecentLogins.
  ///
  /// In en, this message translates to:
  /// **'Recent Logins'**
  String get adminDashboardRecentLogins;

  /// No description provided for @adminDashboardRequestsPending.
  ///
  /// In en, this message translates to:
  /// **'{count} requests pending'**
  String adminDashboardRequestsPending(int count);

  /// No description provided for @adminDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboardTitle;

  /// No description provided for @adminDashboardTotalSurveysSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{total} total'**
  String adminDashboardTotalSurveysSubtitle(int total);

  /// No description provided for @adminDashboardTotalUsersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{total} total (incl. inactive)'**
  String adminDashboardTotalUsersSubtitle(int total);

  /// No description provided for @adminDashboardUiTestPage.
  ///
  /// In en, this message translates to:
  /// **'UI Test Page'**
  String get adminDashboardUiTestPage;

  /// No description provided for @adminDashboardUserDistribution.
  ///
  /// In en, this message translates to:
  /// **'User Distribution'**
  String get adminDashboardUserDistribution;

  /// No description provided for @adminDashboardUserDistributionByRole.
  ///
  /// In en, this message translates to:
  /// **'User Distribution by Role'**
  String get adminDashboardUserDistributionByRole;

  /// No description provided for @adminDashboardUserRoles.
  ///
  /// In en, this message translates to:
  /// **'User Roles'**
  String get adminDashboardUserRoles;

  /// No description provided for @adminDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get adminDatabase;

  /// No description provided for @adminDatabaseStatus.
  ///
  /// In en, this message translates to:
  /// **'Database Status'**
  String get adminDatabaseStatus;

  /// No description provided for @adminDeleteUser.
  ///
  /// In en, this message translates to:
  /// **'Delete User'**
  String get adminDeleteUser;

  /// No description provided for @adminDeletionConfirmContent.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete {name}\'s account. Their survey response data will be retained anonymously. This action cannot be undone.'**
  String adminDeletionConfirmContent(String name);

  /// No description provided for @adminDeletionConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account Permanently'**
  String get adminDeletionConfirmTitle;

  /// No description provided for @adminDeletionError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account: {error}'**
  String adminDeletionError(String error);

  /// No description provided for @adminDeletionNoUsers.
  ///
  /// In en, this message translates to:
  /// **'No users found.'**
  String get adminDeletionNoUsers;

  /// No description provided for @adminDeletionRequestsApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve Deletion'**
  String get adminDeletionRequestsApprove;

  /// No description provided for @adminDeletionRequestsApproveConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete the user\'s account. Their survey data will be retained anonymously. This cannot be undone.'**
  String get adminDeletionRequestsApproveConfirm;

  /// No description provided for @adminDeletionRequestsApproved_msg.
  ///
  /// In en, this message translates to:
  /// **'Account permanently deleted.'**
  String get adminDeletionRequestsApproved_msg;

  /// No description provided for @adminDeletionRequestsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No deletion requests found.'**
  String get adminDeletionRequestsEmpty;

  /// No description provided for @adminDeletionRequestsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading deletion requests'**
  String get adminDeletionRequestsLoadError;

  /// No description provided for @adminDeletionRequestsPendingAlert.
  ///
  /// In en, this message translates to:
  /// **'{count} account deletion {count, plural, =1{request} other{requests}} awaiting review'**
  String adminDeletionRequestsPendingAlert(int count);

  /// No description provided for @adminDeletionRequestsReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get adminDeletionRequestsReject;

  /// No description provided for @adminDeletionRequestsRejectConfirm.
  ///
  /// In en, this message translates to:
  /// **'The deletion request will be rejected and the account will be reactivated.'**
  String get adminDeletionRequestsRejectConfirm;

  /// No description provided for @adminDeletionRequestsRejected_msg.
  ///
  /// In en, this message translates to:
  /// **'Deletion request rejected — account reactivated.'**
  String get adminDeletionRequestsRejected_msg;

  /// No description provided for @adminDeletionRequestsRejectNotes.
  ///
  /// In en, this message translates to:
  /// **'Reason for rejection (optional)'**
  String get adminDeletionRequestsRejectNotes;

  /// No description provided for @adminDeletionRequestsRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get adminDeletionRequestsRequested;

  /// No description provided for @adminDeletionRequestsTab.
  ///
  /// In en, this message translates to:
  /// **'Deletion Requests'**
  String get adminDeletionRequestsTab;

  /// No description provided for @adminDeletionSelfForbidden.
  ///
  /// In en, this message translates to:
  /// **'You cannot delete your own account.'**
  String get adminDeletionSelfForbidden;

  /// No description provided for @adminDeletionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete user accounts. Survey response data is preserved anonymously.'**
  String get adminDeletionSubtitle;

  /// No description provided for @adminDeletionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully.'**
  String get adminDeletionSuccess;

  /// No description provided for @adminDeletionTitle.
  ///
  /// In en, this message translates to:
  /// **'User Deletion'**
  String get adminDeletionTitle;

  /// No description provided for @adminDisableAccount.
  ///
  /// In en, this message translates to:
  /// **'Disable Account'**
  String get adminDisableAccount;

  /// No description provided for @adminEditUser.
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get adminEditUser;

  /// No description provided for @adminEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get adminEmailLabel;

  /// No description provided for @adminEnableAccount.
  ///
  /// In en, this message translates to:
  /// **'Enable Account'**
  String get adminEnableAccount;

  /// No description provided for @adminEndViewAsError.
  ///
  /// In en, this message translates to:
  /// **'Failed to end view-as'**
  String get adminEndViewAsError;

  /// No description provided for @adminEnglish.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get adminEnglish;

  /// No description provided for @adminExportLogs.
  ///
  /// In en, this message translates to:
  /// **'Export Logs'**
  String get adminExportLogs;

  /// No description provided for @adminFilterByAction.
  ///
  /// In en, this message translates to:
  /// **'Filter by Action'**
  String get adminFilterByAction;

  /// No description provided for @adminFilterByDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by Date'**
  String get adminFilterByDate;

  /// No description provided for @adminFilterByRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Filter by Role'**
  String get adminFilterByRoleLabel;

  /// No description provided for @adminFilterByUser.
  ///
  /// In en, this message translates to:
  /// **'Filter by User'**
  String get adminFilterByUser;

  /// No description provided for @adminFirstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get adminFirstNameLabel;

  /// No description provided for @adminFrench.
  ///
  /// In en, this message translates to:
  /// **'FR'**
  String get adminFrench;

  /// No description provided for @adminHealthTrackingActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get adminHealthTrackingActiveLabel;

  /// No description provided for @adminHealthTrackingAddCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get adminHealthTrackingAddCategory;

  /// No description provided for @adminHealthTrackingAddMetric.
  ///
  /// In en, this message translates to:
  /// **'Add Metric'**
  String get adminHealthTrackingAddMetric;

  /// No description provided for @adminHealthTrackingAddOption.
  ///
  /// In en, this message translates to:
  /// **'Add Option'**
  String get adminHealthTrackingAddOption;

  /// No description provided for @adminHealthTrackingBaselineBadge.
  ///
  /// In en, this message translates to:
  /// **'Baseline'**
  String get adminHealthTrackingBaselineBadge;

  /// No description provided for @adminHealthTrackingBaselineLabel.
  ///
  /// In en, this message translates to:
  /// **'Include in baseline snapshot'**
  String get adminHealthTrackingBaselineLabel;

  /// No description provided for @adminHealthTrackingCategoriesSection.
  ///
  /// In en, this message translates to:
  /// **'Categories & Metrics'**
  String get adminHealthTrackingCategoriesSection;

  /// No description provided for @adminHealthTrackingChoiceOptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Option {index}'**
  String adminHealthTrackingChoiceOptionLabel(int index);

  /// No description provided for @adminHealthTrackingChoiceOptionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Choice Options'**
  String get adminHealthTrackingChoiceOptionsLabel;

  /// No description provided for @adminHealthTrackingDeleteCategoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this category and all its metrics? This cannot be undone.'**
  String get adminHealthTrackingDeleteCategoryConfirm;

  /// No description provided for @adminHealthTrackingDeleteCategoryMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\" and all its metrics? Existing participant data is preserved.'**
  String adminHealthTrackingDeleteCategoryMessage(String name);

  /// No description provided for @adminHealthTrackingDeleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Category'**
  String get adminHealthTrackingDeleteCategoryTitle;

  /// No description provided for @adminHealthTrackingDeleteMetricConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this metric? This cannot be undone.'**
  String get adminHealthTrackingDeleteMetricConfirm;

  /// No description provided for @adminHealthTrackingDeleteMetricMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\"? Existing participant data is preserved.'**
  String adminHealthTrackingDeleteMetricMessage(String name);

  /// No description provided for @adminHealthTrackingDeleteMetricTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Metric'**
  String get adminHealthTrackingDeleteMetricTitle;

  /// No description provided for @adminHealthTrackingDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get adminHealthTrackingDescriptionLabel;

  /// No description provided for @adminHealthTrackingDragToReorder.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder'**
  String get adminHealthTrackingDragToReorder;

  /// No description provided for @adminHealthTrackingEditCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get adminHealthTrackingEditCategory;

  /// No description provided for @adminHealthTrackingEditMetric.
  ///
  /// In en, this message translates to:
  /// **'Edit Metric'**
  String get adminHealthTrackingEditMetric;

  /// No description provided for @adminHealthTrackingFreqAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get adminHealthTrackingFreqAny;

  /// No description provided for @adminHealthTrackingFreqDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get adminHealthTrackingFreqDaily;

  /// No description provided for @adminHealthTrackingFreqMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get adminHealthTrackingFreqMonthly;

  /// No description provided for @adminHealthTrackingFrequencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get adminHealthTrackingFrequencyLabel;

  /// No description provided for @adminHealthTrackingFreqWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get adminHealthTrackingFreqWeekly;

  /// No description provided for @adminHealthTrackingInactiveCategories.
  ///
  /// In en, this message translates to:
  /// **'Inactive Categories ({count})'**
  String adminHealthTrackingInactiveCategories(int count);

  /// No description provided for @adminHealthTrackingInactiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get adminHealthTrackingInactiveLabel;

  /// No description provided for @adminHealthTrackingInactiveMetrics.
  ///
  /// In en, this message translates to:
  /// **'Inactive Questions ({count})'**
  String adminHealthTrackingInactiveMetrics(int count);

  /// No description provided for @adminHealthTrackingNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get adminHealthTrackingNameLabel;

  /// No description provided for @adminHealthTrackingNoCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories configured yet.'**
  String get adminHealthTrackingNoCategories;

  /// No description provided for @adminHealthTrackingNoMetrics.
  ///
  /// In en, this message translates to:
  /// **'No metrics in this category.'**
  String get adminHealthTrackingNoMetrics;

  /// No description provided for @adminHealthTrackingRemovedCategories.
  ///
  /// In en, this message translates to:
  /// **'Removed Categories ({count})'**
  String adminHealthTrackingRemovedCategories(int count);

  /// No description provided for @adminHealthTrackingRemovedMetrics.
  ///
  /// In en, this message translates to:
  /// **'Removed Questions ({count})'**
  String adminHealthTrackingRemovedMetrics(int count);

  /// No description provided for @adminHealthTrackingRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get adminHealthTrackingRestore;

  /// No description provided for @adminHealthTrackingSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully.'**
  String get adminHealthTrackingSaved;

  /// No description provided for @adminHealthTrackingSaveError.
  ///
  /// In en, this message translates to:
  /// **'Save failed: {error}'**
  String adminHealthTrackingSaveError(String error);

  /// No description provided for @adminHealthTrackingScaleMaxLabel.
  ///
  /// In en, this message translates to:
  /// **'Scale Max'**
  String get adminHealthTrackingScaleMaxLabel;

  /// No description provided for @adminHealthTrackingScaleMinLabel.
  ///
  /// In en, this message translates to:
  /// **'Scale Min'**
  String get adminHealthTrackingScaleMinLabel;

  /// No description provided for @adminHealthTrackingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure the categories and metrics that participants track daily.'**
  String get adminHealthTrackingSubtitle;

  /// No description provided for @adminHealthTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Tracking Settings'**
  String get adminHealthTrackingTitle;

  /// No description provided for @adminHealthTrackingToggleCategoryActive.
  ///
  /// In en, this message translates to:
  /// **'Toggle category active/inactive'**
  String get adminHealthTrackingToggleCategoryActive;

  /// No description provided for @adminHealthTrackingTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Metric Type'**
  String get adminHealthTrackingTypeLabel;

  /// No description provided for @adminHealthTrackingTypeNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get adminHealthTrackingTypeNumber;

  /// No description provided for @adminHealthTrackingTypeScale.
  ///
  /// In en, this message translates to:
  /// **'Scale'**
  String get adminHealthTrackingTypeScale;

  /// No description provided for @adminHealthTrackingTypeSingleChoice.
  ///
  /// In en, this message translates to:
  /// **'Single Choice'**
  String get adminHealthTrackingTypeSingleChoice;

  /// No description provided for @adminHealthTrackingTypeText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get adminHealthTrackingTypeText;

  /// No description provided for @adminHealthTrackingTypeYesno.
  ///
  /// In en, this message translates to:
  /// **'Yes / No'**
  String get adminHealthTrackingTypeYesno;

  /// No description provided for @adminHealthTrackingUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit (optional)'**
  String get adminHealthTrackingUnitLabel;

  /// No description provided for @adminInbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get adminInbox;

  /// No description provided for @adminLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get adminLanguage;

  /// No description provided for @adminLastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get adminLastNameLabel;

  /// No description provided for @adminLoggedInAs.
  ///
  /// In en, this message translates to:
  /// **'Logged in as: {name}'**
  String adminLoggedInAs(String name);

  /// No description provided for @adminLoggedInAsLabel.
  ///
  /// In en, this message translates to:
  /// **'Logged in as:'**
  String get adminLoggedInAsLabel;

  /// No description provided for @adminMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get adminMessages;

  /// No description provided for @adminNavGroupAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminNavGroupAdmin;

  /// No description provided for @adminNavGroupHealthcareProvider.
  ///
  /// In en, this message translates to:
  /// **'Healthcare Provider'**
  String get adminNavGroupHealthcareProvider;

  /// No description provided for @adminNavGroupParticipant.
  ///
  /// In en, this message translates to:
  /// **'Participant'**
  String get adminNavGroupParticipant;

  /// No description provided for @adminNavGroupPublicAuth.
  ///
  /// In en, this message translates to:
  /// **'Public / Auth'**
  String get adminNavGroupPublicAuth;

  /// No description provided for @adminNavGroupResearcher.
  ///
  /// In en, this message translates to:
  /// **'Researcher'**
  String get adminNavGroupResearcher;

  /// No description provided for @adminNavGroupShared.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get adminNavGroupShared;

  /// No description provided for @adminNavHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Navigate to any page in the application'**
  String get adminNavHubSubtitle;

  /// No description provided for @adminNavHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Page Navigator'**
  String get adminNavHubTitle;

  /// No description provided for @adminNewAccountRequestsTab.
  ///
  /// In en, this message translates to:
  /// **'New Account Requests'**
  String get adminNewAccountRequestsTab;

  /// No description provided for @adminOpenTickets.
  ///
  /// In en, this message translates to:
  /// **'Open Tickets'**
  String get adminOpenTickets;

  /// No description provided for @adminPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get adminPasswordLabel;

  /// No description provided for @adminResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get adminResetPassword;

  /// No description provided for @adminRestoreDatabase.
  ///
  /// In en, this message translates to:
  /// **'Restore Database'**
  String get adminRestoreDatabase;

  /// No description provided for @adminReturnedToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Returned to admin dashboard'**
  String get adminReturnedToDashboard;

  /// No description provided for @adminReturning.
  ///
  /// In en, this message translates to:
  /// **'Returning...'**
  String get adminReturning;

  /// No description provided for @adminRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get adminRoleLabel;

  /// No description provided for @adminSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get adminSent;

  /// No description provided for @adminSettingsConsentRequiredDescription.
  ///
  /// In en, this message translates to:
  /// **'When on, users must sign the consent form before accessing the app. Disable only if consent is not required in your deployment jurisdiction.'**
  String get adminSettingsConsentRequiredDescription;

  /// No description provided for @adminSettingsConsentRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Require User Consent'**
  String get adminSettingsConsentRequiredLabel;

  /// No description provided for @adminSettingsDefaultBadge.
  ///
  /// In en, this message translates to:
  /// **'Default: {value}'**
  String adminSettingsDefaultBadge(String value);

  /// No description provided for @adminSettingsKDescription.
  ///
  /// In en, this message translates to:
  /// **'Minimum distinct respondents required before survey data is exposed to researchers. Set to 1 to allow any data. Default: 5.'**
  String get adminSettingsKDescription;

  /// No description provided for @adminSettingsKFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Minimum Respondents (K)'**
  String get adminSettingsKFieldLabel;

  /// No description provided for @adminSettingsKHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5'**
  String get adminSettingsKHint;

  /// No description provided for @adminSettingsKLabel.
  ///
  /// In en, this message translates to:
  /// **'K-Anonymity Threshold'**
  String get adminSettingsKLabel;

  /// No description provided for @adminSettingsLockoutDescription.
  ///
  /// In en, this message translates to:
  /// **'How long an account stays locked after exceeding the failed-login limit. Default: 30 minutes.'**
  String get adminSettingsLockoutDescription;

  /// No description provided for @adminSettingsLockoutFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Lockout Duration (min)'**
  String get adminSettingsLockoutFieldLabel;

  /// No description provided for @adminSettingsLockoutHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 30'**
  String get adminSettingsLockoutHint;

  /// No description provided for @adminSettingsLockoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Lockout Duration (minutes)'**
  String get adminSettingsLockoutLabel;

  /// No description provided for @adminSettingsMaintenanceCompletionDescription.
  ///
  /// In en, this message translates to:
  /// **'Estimated time when the system will be back online. Shown in the maintenance banner on all pages.'**
  String get adminSettingsMaintenanceCompletionDescription;

  /// No description provided for @adminSettingsMaintenanceCompletionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5:00 PM EST'**
  String get adminSettingsMaintenanceCompletionHint;

  /// No description provided for @adminSettingsMaintenanceCompletionLabel.
  ///
  /// In en, this message translates to:
  /// **'Expected Completion Time'**
  String get adminSettingsMaintenanceCompletionLabel;

  /// No description provided for @adminSettingsMaintenanceDescription.
  ///
  /// In en, this message translates to:
  /// **'When on, non-admin users cannot log in. A banner is shown on the login page. Admins can still log in and access the dashboard.'**
  String get adminSettingsMaintenanceDescription;

  /// No description provided for @adminSettingsMaintenanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Mode'**
  String get adminSettingsMaintenanceLabel;

  /// No description provided for @adminSettingsMaintenanceMessageDescription.
  ///
  /// In en, this message translates to:
  /// **'Optional message shown in the login banner during maintenance. Include expected return time.'**
  String get adminSettingsMaintenanceMessageDescription;

  /// No description provided for @adminSettingsMaintenanceMessageHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Back online by 5:00 PM EST'**
  String get adminSettingsMaintenanceMessageHint;

  /// No description provided for @adminSettingsMaintenanceMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Message'**
  String get adminSettingsMaintenanceMessageLabel;

  /// No description provided for @adminSettingsMaxAttemptsDescription.
  ///
  /// In en, this message translates to:
  /// **'Consecutive failed logins before the account is temporarily locked. Set to 0 for no limit. Default: 10.'**
  String get adminSettingsMaxAttemptsDescription;

  /// No description provided for @adminSettingsMaxAttemptsFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Max Attempts (0 = unlimited)'**
  String get adminSettingsMaxAttemptsFieldLabel;

  /// No description provided for @adminSettingsMaxAttemptsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 10'**
  String get adminSettingsMaxAttemptsHint;

  /// No description provided for @adminSettingsMaxAttemptsLabel.
  ///
  /// In en, this message translates to:
  /// **'Max Failed Login Attempts'**
  String get adminSettingsMaxAttemptsLabel;

  /// No description provided for @adminSettingsRegistrationDescription.
  ///
  /// In en, this message translates to:
  /// **'When off, new account requests are blocked. Useful during enrollment freezes.'**
  String get adminSettingsRegistrationDescription;

  /// No description provided for @adminSettingsRegistrationLabel.
  ///
  /// In en, this message translates to:
  /// **'Registration Open'**
  String get adminSettingsRegistrationLabel;

  /// No description provided for @adminSettingsResetToDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to Default'**
  String get adminSettingsResetToDefault;

  /// No description provided for @adminSettingsSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get adminSettingsSaveButton;

  /// No description provided for @adminSettingsSaveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save settings.'**
  String get adminSettingsSaveError;

  /// No description provided for @adminSettingsSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully.'**
  String get adminSettingsSaveSuccess;

  /// No description provided for @adminSettingsSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get adminSettingsSaving;

  /// No description provided for @adminSettingsSectionPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data Privacy'**
  String get adminSettingsSectionPrivacy;

  /// No description provided for @adminSettingsSectionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Login Security'**
  String get adminSettingsSectionSecurity;

  /// No description provided for @adminSettingsSectionSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get adminSettingsSectionSystem;

  /// No description provided for @adminSettingsSidebarLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get adminSettingsSidebarLabel;

  /// No description provided for @adminSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'System Settings'**
  String get adminSettingsTitle;

  /// No description provided for @adminSettingsValidationNonNegative.
  ///
  /// In en, this message translates to:
  /// **'Must be 0 or greater.'**
  String get adminSettingsValidationNonNegative;

  /// No description provided for @adminSettingsValidationPositive.
  ///
  /// In en, this message translates to:
  /// **'Must be a positive whole number.'**
  String get adminSettingsValidationPositive;

  /// No description provided for @adminSpanish.
  ///
  /// In en, this message translates to:
  /// **'ES'**
  String get adminSpanish;

  /// No description provided for @adminTicketDetails.
  ///
  /// In en, this message translates to:
  /// **'Ticket Details'**
  String get adminTicketDetails;

  /// No description provided for @adminTickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get adminTickets;

  /// No description provided for @adminUiTestSectionBasics.
  ///
  /// In en, this message translates to:
  /// **'Basics'**
  String get adminUiTestSectionBasics;

  /// No description provided for @adminUiTestSectionButtons.
  ///
  /// In en, this message translates to:
  /// **'Buttons'**
  String get adminUiTestSectionButtons;

  /// No description provided for @adminUiTestSectionDataDisplay.
  ///
  /// In en, this message translates to:
  /// **'Data Display'**
  String get adminUiTestSectionDataDisplay;

  /// No description provided for @adminUiTestSectionFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get adminUiTestSectionFeedback;

  /// No description provided for @adminUiTestSectionForms.
  ///
  /// In en, this message translates to:
  /// **'Forms and Input'**
  String get adminUiTestSectionForms;

  /// No description provided for @adminUiTestSectionMicroWidgets.
  ///
  /// In en, this message translates to:
  /// **'Micro Widgets'**
  String get adminUiTestSectionMicroWidgets;

  /// No description provided for @adminUserDetails.
  ///
  /// In en, this message translates to:
  /// **'User Details'**
  String get adminUserDetails;

  /// No description provided for @adminUserList.
  ///
  /// In en, this message translates to:
  /// **'User List'**
  String get adminUserList;

  /// No description provided for @adminUserManagement.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get adminUserManagement;

  /// No description provided for @adminUserRole.
  ///
  /// In en, this message translates to:
  /// **'User Role'**
  String get adminUserRole;

  /// No description provided for @adminV2LatestSignIns.
  ///
  /// In en, this message translates to:
  /// **'Latest sign-ins across the system'**
  String get adminV2LatestSignIns;

  /// No description provided for @adminV2NoUserData.
  ///
  /// In en, this message translates to:
  /// **'No user data available yet.'**
  String get adminV2NoUserData;

  /// No description provided for @adminV2OpenClassicAdmin.
  ///
  /// In en, this message translates to:
  /// **'Open classic admin'**
  String get adminV2OpenClassicAdmin;

  /// No description provided for @adminV2QuickAuditLog.
  ///
  /// In en, this message translates to:
  /// **'Audit Log'**
  String get adminV2QuickAuditLog;

  /// No description provided for @adminV2QuickDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get adminV2QuickDatabase;

  /// No description provided for @adminV2QuickLinks.
  ///
  /// In en, this message translates to:
  /// **'Quick links'**
  String get adminV2QuickLinks;

  /// No description provided for @adminV2QuickNavigator.
  ///
  /// In en, this message translates to:
  /// **'Navigator'**
  String get adminV2QuickNavigator;

  /// No description provided for @adminV2QuickRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get adminV2QuickRequests;

  /// No description provided for @adminV2QuickUiTest.
  ///
  /// In en, this message translates to:
  /// **'UI Test'**
  String get adminV2QuickUiTest;

  /// No description provided for @adminV2QuickUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get adminV2QuickUsers;

  /// No description provided for @adminV2RecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get adminV2RecentActivity;

  /// No description provided for @adminV2RoleDistributionTitle.
  ///
  /// In en, this message translates to:
  /// **'User distribution'**
  String get adminV2RoleDistributionTitle;

  /// No description provided for @adminV2RoleMixSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Role mix across the platform'**
  String get adminV2RoleMixSubtitle;

  /// No description provided for @adminV2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'A quieter, flatter dashboard preview based on the new design direction. The existing admin remains unchanged.'**
  String get adminV2Subtitle;

  /// No description provided for @adminV2Title.
  ///
  /// In en, this message translates to:
  /// **'Admin v2'**
  String get adminV2Title;

  /// No description provided for @adminViewAsLabel.
  ///
  /// In en, this message translates to:
  /// **'View As'**
  String get adminViewAsLabel;

  /// No description provided for @adminViewingAsRole.
  ///
  /// In en, this message translates to:
  /// **'Viewing as {role}'**
  String adminViewingAsRole(String role);

  /// No description provided for @adminViewingAsUser.
  ///
  /// In en, this message translates to:
  /// **'Viewing as {name} ({email})'**
  String adminViewingAsUser(String name, String email);

  /// No description provided for @adminViewLogs.
  ///
  /// In en, this message translates to:
  /// **'View Logs'**
  String get adminViewLogs;

  /// No description provided for @adminWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the admin dashboard. Select an option from the sidebar.'**
  String get adminWelcomeMessage;

  /// No description provided for @auditLogAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get auditLogAction;

  /// No description provided for @auditLogActorId.
  ///
  /// In en, this message translates to:
  /// **'Actor ID'**
  String get auditLogActorId;

  /// No description provided for @auditLogActorType.
  ///
  /// In en, this message translates to:
  /// **'Actor Type'**
  String get auditLogActorType;

  /// No description provided for @auditLogAllActions.
  ///
  /// In en, this message translates to:
  /// **'All Actions'**
  String get auditLogAllActions;

  /// No description provided for @auditLogAllMethods.
  ///
  /// In en, this message translates to:
  /// **'All Methods'**
  String get auditLogAllMethods;

  /// No description provided for @auditLogAllResources.
  ///
  /// In en, this message translates to:
  /// **'All Resources'**
  String get auditLogAllResources;

  /// No description provided for @auditLogAllStatuses.
  ///
  /// In en, this message translates to:
  /// **'All Statuses'**
  String get auditLogAllStatuses;

  /// No description provided for @auditLogColumnAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get auditLogColumnAction;

  /// No description provided for @auditLogColumnActor.
  ///
  /// In en, this message translates to:
  /// **'Actor'**
  String get auditLogColumnActor;

  /// No description provided for @auditLogColumnMethod.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get auditLogColumnMethod;

  /// No description provided for @auditLogColumnPath.
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get auditLogColumnPath;

  /// No description provided for @auditLogColumnStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get auditLogColumnStatus;

  /// No description provided for @auditLogColumnTimestamp.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get auditLogColumnTimestamp;

  /// No description provided for @auditLogDenied.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get auditLogDenied;

  /// No description provided for @auditLogErrorCode.
  ///
  /// In en, this message translates to:
  /// **'Error Code'**
  String get auditLogErrorCode;

  /// No description provided for @auditLogEventId.
  ///
  /// In en, this message translates to:
  /// **'Event ID'**
  String get auditLogEventId;

  /// No description provided for @auditLogExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export as CSV'**
  String get auditLogExportCsv;

  /// No description provided for @auditLogFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load audit logs'**
  String get auditLogFailedToLoad;

  /// No description provided for @auditLogFailure.
  ///
  /// In en, this message translates to:
  /// **'Failure'**
  String get auditLogFailure;

  /// No description provided for @auditLogHttpMethod.
  ///
  /// In en, this message translates to:
  /// **'HTTP Method'**
  String get auditLogHttpMethod;

  /// No description provided for @auditLogHttpStatus.
  ///
  /// In en, this message translates to:
  /// **'HTTP Status'**
  String get auditLogHttpStatus;

  /// No description provided for @auditLogIpAddress.
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get auditLogIpAddress;

  /// No description provided for @auditLogMetadata.
  ///
  /// In en, this message translates to:
  /// **'Metadata'**
  String get auditLogMetadata;

  /// No description provided for @auditLogNextPage.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get auditLogNextPage;

  /// No description provided for @auditLogNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No audit events found'**
  String get auditLogNoEvents;

  /// No description provided for @auditLogPageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String auditLogPageOf(int current, int total);

  /// No description provided for @auditLogPreviousPage.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get auditLogPreviousPage;

  /// No description provided for @auditLogRequestId.
  ///
  /// In en, this message translates to:
  /// **'Request ID'**
  String get auditLogRequestId;

  /// No description provided for @auditLogResourceId.
  ///
  /// In en, this message translates to:
  /// **'Resource ID'**
  String get auditLogResourceId;

  /// No description provided for @auditLogResourceType.
  ///
  /// In en, this message translates to:
  /// **'Resource Type'**
  String get auditLogResourceType;

  /// No description provided for @auditLogSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search paths or actions...'**
  String get auditLogSearchPlaceholder;

  /// No description provided for @auditLogShowingEvents.
  ///
  /// In en, this message translates to:
  /// **'Showing {start}-{end} of {total} events'**
  String auditLogShowingEvents(int start, int end, int total);

  /// No description provided for @auditLogSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get auditLogSuccess;

  /// No description provided for @auditLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Audit Log'**
  String get auditLogTitle;

  /// No description provided for @auditLogUserAgent.
  ///
  /// In en, this message translates to:
  /// **'User Agent'**
  String get auditLogUserAgent;

  /// No description provided for @dbPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Database Management'**
  String get dbPageTitle;

  /// No description provided for @dbTableDescAccount2FA.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication settings per account'**
  String get dbTableDescAccount2FA;

  /// No description provided for @dbTableDescAccountData.
  ///
  /// In en, this message translates to:
  /// **'User account information and profile details'**
  String get dbTableDescAccountData;

  /// No description provided for @dbTableDescAccountRequest.
  ///
  /// In en, this message translates to:
  /// **'Pending account creation requests awaiting approval'**
  String get dbTableDescAccountRequest;

  /// No description provided for @dbTableDescAuditEvent.
  ///
  /// In en, this message translates to:
  /// **'Audit log of security-relevant events'**
  String get dbTableDescAuditEvent;

  /// No description provided for @dbTableDescAuth.
  ///
  /// In en, this message translates to:
  /// **'Password hashes for user authentication (sensitive columns hidden)'**
  String get dbTableDescAuth;

  /// No description provided for @dbTableDescConsentRecord.
  ///
  /// In en, this message translates to:
  /// **'Records of participants signing the consent document'**
  String get dbTableDescConsentRecord;

  /// No description provided for @dbTableDescConversationParticipants.
  ///
  /// In en, this message translates to:
  /// **'Maps accounts to conversations (many-to-many)'**
  String get dbTableDescConversationParticipants;

  /// No description provided for @dbTableDescConversations.
  ///
  /// In en, this message translates to:
  /// **'Messaging conversations between users'**
  String get dbTableDescConversations;

  /// No description provided for @dbTableDescDataTypes.
  ///
  /// In en, this message translates to:
  /// **'Categories for health data collected by questions'**
  String get dbTableDescDataTypes;

  /// No description provided for @dbTableDescFriendRequests.
  ///
  /// In en, this message translates to:
  /// **'Friend/connection requests between participant accounts'**
  String get dbTableDescFriendRequests;

  /// No description provided for @dbTableDescHcpPatientLink.
  ///
  /// In en, this message translates to:
  /// **'Links between HCP providers and their patients'**
  String get dbTableDescHcpPatientLink;

  /// No description provided for @dbTableDescMessages.
  ///
  /// In en, this message translates to:
  /// **'Individual messages sent within conversations'**
  String get dbTableDescMessages;

  /// No description provided for @dbTableDescMfaChallenges.
  ///
  /// In en, this message translates to:
  /// **'One-time MFA token challenges (sensitive columns hidden)'**
  String get dbTableDescMfaChallenges;

  /// No description provided for @dbTableDescPasswordResetTokens.
  ///
  /// In en, this message translates to:
  /// **'Password reset tokens for account recovery'**
  String get dbTableDescPasswordResetTokens;

  /// No description provided for @dbTableDescQuestionBank.
  ///
  /// In en, this message translates to:
  /// **'Reusable questions that can be added to surveys'**
  String get dbTableDescQuestionBank;

  /// No description provided for @dbTableDescQuestionCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories for organizing survey questions'**
  String get dbTableDescQuestionCategories;

  /// No description provided for @dbTableDescQuestionList.
  ///
  /// In en, this message translates to:
  /// **'Links questions to surveys (many-to-many)'**
  String get dbTableDescQuestionList;

  /// No description provided for @dbTableDescQuestionOptions.
  ///
  /// In en, this message translates to:
  /// **'Options for single_choice and multi_choice questions'**
  String get dbTableDescQuestionOptions;

  /// No description provided for @dbTableDescResponses.
  ///
  /// In en, this message translates to:
  /// **'Participant answers to survey questions'**
  String get dbTableDescResponses;

  /// No description provided for @dbTableDescRoles.
  ///
  /// In en, this message translates to:
  /// **'User roles defining access permissions'**
  String get dbTableDescRoles;

  /// No description provided for @dbTableDescSessions.
  ///
  /// In en, this message translates to:
  /// **'Active user login sessions (sensitive columns hidden)'**
  String get dbTableDescSessions;

  /// No description provided for @dbTableDescSurvey.
  ///
  /// In en, this message translates to:
  /// **'Survey definitions created by researchers'**
  String get dbTableDescSurvey;

  /// No description provided for @dbTableDescSurveyAssignment.
  ///
  /// In en, this message translates to:
  /// **'Tracks which surveys are assigned to which participants'**
  String get dbTableDescSurveyAssignment;

  /// No description provided for @dbTableDescSurveyTemplate.
  ///
  /// In en, this message translates to:
  /// **'Reusable survey templates created by researchers'**
  String get dbTableDescSurveyTemplate;

  /// No description provided for @dbTableDescSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'System configuration settings and application preferences'**
  String get dbTableDescSystemSettings;

  /// No description provided for @dbTableDescTemplateQuestions.
  ///
  /// In en, this message translates to:
  /// **'Links questions to survey templates (many-to-many)'**
  String get dbTableDescTemplateQuestions;

  /// No description provided for @dbUtilitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Database Utilities'**
  String get dbUtilitiesTitle;

  /// No description provided for @dbViewerColumnHeader.
  ///
  /// In en, this message translates to:
  /// **'Column'**
  String get dbViewerColumnHeader;

  /// No description provided for @dbViewerColumnsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} columns'**
  String dbViewerColumnsCount(int count);

  /// No description provided for @dbViewerConstraintsHeader.
  ///
  /// In en, this message translates to:
  /// **'Constraints'**
  String get dbViewerConstraintsHeader;

  /// No description provided for @dbViewerData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get dbViewerData;

  /// No description provided for @dbViewerFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load database tables'**
  String get dbViewerFailedToLoad;

  /// No description provided for @dbViewerFailedToLoadData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load table data: {error}'**
  String dbViewerFailedToLoadData(String error);

  /// No description provided for @dbViewerForeignKey.
  ///
  /// In en, this message translates to:
  /// **'Foreign Key'**
  String get dbViewerForeignKey;

  /// No description provided for @dbViewerNoData.
  ///
  /// In en, this message translates to:
  /// **'No data in table'**
  String get dbViewerNoData;

  /// No description provided for @dbViewerNotNull.
  ///
  /// In en, this message translates to:
  /// **'Not Null'**
  String get dbViewerNotNull;

  /// No description provided for @dbViewerNull.
  ///
  /// In en, this message translates to:
  /// **'NULL'**
  String get dbViewerNull;

  /// No description provided for @dbViewerNullable.
  ///
  /// In en, this message translates to:
  /// **'Nullable'**
  String get dbViewerNullable;

  /// No description provided for @dbViewerPageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String dbViewerPageOf(int current, int total);

  /// No description provided for @dbViewerPrimaryKey.
  ///
  /// In en, this message translates to:
  /// **'Primary Key'**
  String get dbViewerPrimaryKey;

  /// No description provided for @dbViewerReferenceHeader.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get dbViewerReferenceHeader;

  /// No description provided for @dbViewerRowsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} rows'**
  String dbViewerRowsCount(int count);

  /// No description provided for @dbViewerRowsTotal.
  ///
  /// In en, this message translates to:
  /// **'{count} rows total'**
  String dbViewerRowsTotal(int count);

  /// No description provided for @dbViewerSchema.
  ///
  /// In en, this message translates to:
  /// **'Schema'**
  String get dbViewerSchema;

  /// No description provided for @dbViewerSelectATable.
  ///
  /// In en, this message translates to:
  /// **'Select a table'**
  String get dbViewerSelectATable;

  /// No description provided for @dbViewerSelectTable.
  ///
  /// In en, this message translates to:
  /// **'Select Table'**
  String get dbViewerSelectTable;

  /// No description provided for @dbViewerShowing.
  ///
  /// In en, this message translates to:
  /// **'Showing {start}-{end} of {total}'**
  String dbViewerShowing(int start, int end, int total);

  /// No description provided for @dbViewerTableData.
  ///
  /// In en, this message translates to:
  /// **'{name} Data'**
  String dbViewerTableData(String name);

  /// No description provided for @dbViewerTablesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} tables in database'**
  String dbViewerTablesCount(int count);

  /// No description provided for @dbViewerTitle.
  ///
  /// In en, this message translates to:
  /// **'Database Viewer'**
  String get dbViewerTitle;

  /// No description provided for @dbViewerTypeHeader.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get dbViewerTypeHeader;

  /// No description provided for @dbViewerViewModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Toggle between schema and data view'**
  String get dbViewerViewModeLabel;

  /// No description provided for @backupCreatedError.
  ///
  /// In en, this message translates to:
  /// **'Backup failed. Check server logs.'**
  String get backupCreatedError;

  /// No description provided for @backupCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup created ({size})'**
  String backupCreatedSuccess(String size);

  /// No description provided for @backupCreateManual.
  ///
  /// In en, this message translates to:
  /// **'Create Backup Now'**
  String get backupCreateManual;

  /// No description provided for @backupCreating.
  ///
  /// In en, this message translates to:
  /// **'Creating…'**
  String get backupCreating;

  /// No description provided for @backupDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete {filename}. This action cannot be undone.'**
  String backupDeleteConfirmBody(String filename);

  /// No description provided for @backupDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Backup?'**
  String get backupDeleteConfirmTitle;

  /// No description provided for @backupDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Could not delete backup. Please try again.'**
  String get backupDeleteError;

  /// No description provided for @backupDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup deleted.'**
  String get backupDeleteSuccess;

  /// No description provided for @backupDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete this backup'**
  String get backupDeleteTooltip;

  /// No description provided for @backupDownloadError.
  ///
  /// In en, this message translates to:
  /// **'Download failed. Please try again.'**
  String get backupDownloadError;

  /// No description provided for @backupDownloadStarted.
  ///
  /// In en, this message translates to:
  /// **'Download started.'**
  String get backupDownloadStarted;

  /// No description provided for @backupDownloadTooltip.
  ///
  /// In en, this message translates to:
  /// **'Download backup file'**
  String get backupDownloadTooltip;

  /// No description provided for @backupLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest Backup'**
  String get backupLatest;

  /// No description provided for @backupLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load backup list'**
  String get backupLoadError;

  /// No description provided for @backupNoneFound.
  ///
  /// In en, this message translates to:
  /// **'No backups found'**
  String get backupNoneFound;

  /// No description provided for @backupNoneFoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No backup files exist yet. Create a manual backup or wait for the scheduled backup to run.'**
  String get backupNoneFoundSubtitle;

  /// No description provided for @backupNoRecent.
  ///
  /// In en, this message translates to:
  /// **'No backups yet — create one now.'**
  String get backupNoRecent;

  /// No description provided for @backupPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automated backups run daily at 2 AM, weekly on Sundays, and monthly on the 1st. Manual backups are kept for the last 10 runs.'**
  String get backupPageSubtitle;

  /// No description provided for @backupPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Database Backups'**
  String get backupPageTitle;

  /// No description provided for @backupRestoreAction.
  ///
  /// In en, this message translates to:
  /// **'Restore Database'**
  String get backupRestoreAction;

  /// No description provided for @backupRestoreConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will replace ALL current data with the contents of {filename}.\n\nA pre-restore backup will be created automatically before the restore begins.\n\nThis action cannot be undone.'**
  String backupRestoreConfirmBody(String filename);

  /// No description provided for @backupRestoreConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore Database?'**
  String get backupRestoreConfirmTitle;

  /// No description provided for @backupRestoreError.
  ///
  /// In en, this message translates to:
  /// **'Restore failed. Please try again or contact support.'**
  String get backupRestoreError;

  /// No description provided for @backupRestoreSelectHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a backup to restore…'**
  String get backupRestoreSelectHint;

  /// No description provided for @backupRestoreSelectLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Backup'**
  String get backupRestoreSelectLabel;

  /// No description provided for @backupRestoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Database restored. Pre-restore backup saved ({size}). {migrations} migration(s) applied.'**
  String backupRestoreSuccess(String size, int migrations);

  /// No description provided for @backupRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore from Backup'**
  String get backupRestoreTitle;

  /// No description provided for @backupRestoreTooltip.
  ///
  /// In en, this message translates to:
  /// **'Restore database from this backup'**
  String get backupRestoreTooltip;

  /// No description provided for @backupRestoring.
  ///
  /// In en, this message translates to:
  /// **'Restoring…'**
  String get backupRestoring;

  /// No description provided for @backupSavedTo.
  ///
  /// In en, this message translates to:
  /// **'Saved to {path}'**
  String backupSavedTo(String path);

  /// No description provided for @backupSectionCollapse.
  ///
  /// In en, this message translates to:
  /// **'Hide backups'**
  String get backupSectionCollapse;

  /// No description provided for @backupSectionExpand.
  ///
  /// In en, this message translates to:
  /// **'Show backups'**
  String get backupSectionExpand;

  /// No description provided for @backupTypeDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get backupTypeDaily;

  /// No description provided for @backupTypeManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get backupTypeManual;

  /// No description provided for @backupTypeMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get backupTypeMonthly;

  /// No description provided for @backupTypeWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get backupTypeWeekly;

  /// No description provided for @backupViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All Backups'**
  String get backupViewAll;

  /// No description provided for @userManagementActivate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get userManagementActivate;

  /// No description provided for @userManagementActivatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'User activated'**
  String get userManagementActivatedSuccess;

  /// No description provided for @userManagementActiveOnly.
  ///
  /// In en, this message translates to:
  /// **'Active only'**
  String get userManagementActiveOnly;

  /// No description provided for @userManagementAddNewUser.
  ///
  /// In en, this message translates to:
  /// **'Add New User'**
  String get userManagementAddNewUser;

  /// No description provided for @userManagementAddUser.
  ///
  /// In en, this message translates to:
  /// **'Add User'**
  String get userManagementAddUser;

  /// No description provided for @userManagementAdminConsentExempt.
  ///
  /// In en, this message translates to:
  /// **'Admin — Consent Exempt'**
  String get userManagementAdminConsentExempt;

  /// No description provided for @userManagementAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get userManagementAll;

  /// No description provided for @userManagementAllRoles.
  ///
  /// In en, this message translates to:
  /// **'All Roles'**
  String get userManagementAllRoles;

  /// No description provided for @userManagementCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get userManagementCopy;

  /// No description provided for @userManagementCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'User created successfully'**
  String get userManagementCreatedSuccess;

  /// No description provided for @userManagementDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get userManagementDeactivate;

  /// No description provided for @userManagementDeactivatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'User deactivated'**
  String get userManagementDeactivatedSuccess;

  /// No description provided for @userManagementDeleteUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete User'**
  String get userManagementDeleteUserTitle;

  /// No description provided for @userManagementDeleteUserTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete user'**
  String get userManagementDeleteUserTooltip;

  /// No description provided for @userManagementEditUser.
  ///
  /// In en, this message translates to:
  /// **'Edit user'**
  String get userManagementEditUser;

  /// No description provided for @userManagementEditUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get userManagementEditUserTitle;

  /// No description provided for @userManagementEditUserTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit user'**
  String get userManagementEditUserTooltip;

  /// No description provided for @userManagementFailedToImpersonate.
  ///
  /// In en, this message translates to:
  /// **'Failed to impersonate user'**
  String get userManagementFailedToImpersonate;

  /// No description provided for @userManagementFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load users'**
  String get userManagementFailedToLoad;

  /// No description provided for @userManagementFilterByRole.
  ///
  /// In en, this message translates to:
  /// **'Filter by Role'**
  String get userManagementFilterByRole;

  /// No description provided for @userManagementFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get userManagementFirstName;

  /// No description provided for @userManagementGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get userManagementGenerate;

  /// No description provided for @userManagementLastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get userManagementLastName;

  /// No description provided for @userManagementNoUsers.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get userManagementNoUsers;

  /// No description provided for @userManagementNowViewingAs.
  ///
  /// In en, this message translates to:
  /// **'Now viewing as {name}'**
  String userManagementNowViewingAs(String name);

  /// No description provided for @userManagementPasswordCopied.
  ///
  /// In en, this message translates to:
  /// **'Password copied to clipboard'**
  String get userManagementPasswordCopied;

  /// No description provided for @userManagementResetPasswordTooltip.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get userManagementResetPasswordTooltip;

  /// No description provided for @userManagementRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get userManagementRole;

  /// No description provided for @userManagementRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get userManagementRoleLabel;

  /// No description provided for @userManagementSearchByEmail.
  ///
  /// In en, this message translates to:
  /// **'Search by name or email...'**
  String get userManagementSearchByEmail;

  /// No description provided for @userManagementSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by name or email...'**
  String get userManagementSearchPlaceholder;

  /// No description provided for @userManagementSearchShort.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get userManagementSearchShort;

  /// No description provided for @userManagementTableActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get userManagementTableActions;

  /// No description provided for @userManagementTableEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get userManagementTableEmail;

  /// No description provided for @userManagementTableLastLogin.
  ///
  /// In en, this message translates to:
  /// **'Last Login'**
  String get userManagementTableLastLogin;

  /// No description provided for @userManagementTableName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get userManagementTableName;

  /// No description provided for @userManagementTableRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get userManagementTableRole;

  /// No description provided for @userManagementTableStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get userManagementTableStatus;

  /// No description provided for @userManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagementTitle;

  /// No description provided for @userManagementTotalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total: {count} users'**
  String userManagementTotalUsers(int count);

  /// No description provided for @userManagementUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'User updated successfully'**
  String get userManagementUpdatedSuccess;

  /// No description provided for @userManagementUserDeleted.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted'**
  String userManagementUserDeleted(String name);

  /// No description provided for @userManagementUsersShown.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 user shown} other{{count} users shown}}'**
  String userManagementUsersShown(int count);

  /// No description provided for @userManagementViewAsUser.
  ///
  /// In en, this message translates to:
  /// **'View as User'**
  String get userManagementViewAsUser;

  /// No description provided for @userRoleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get userRoleAdmin;

  /// No description provided for @userRoleHcp.
  ///
  /// In en, this message translates to:
  /// **'Healthcare Professional'**
  String get userRoleHcp;

  /// No description provided for @userRoleHcpShort.
  ///
  /// In en, this message translates to:
  /// **'HCP'**
  String get userRoleHcpShort;

  /// No description provided for @userRoleParticipant.
  ///
  /// In en, this message translates to:
  /// **'Participant'**
  String get userRoleParticipant;

  /// No description provided for @userRoleResearcher.
  ///
  /// In en, this message translates to:
  /// **'Researcher'**
  String get userRoleResearcher;

  /// No description provided for @userRoleUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get userRoleUnknown;

  /// No description provided for @settings2faDisabledSuccess.
  ///
  /// In en, this message translates to:
  /// **'2FA disabled'**
  String get settings2faDisabledSuccess;

  /// No description provided for @settings2faListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set up or confirm 2FA for your account'**
  String get settings2faListSubtitle;

  /// No description provided for @settingsAppearanceApplied.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get settingsAppearanceApplied;

  /// No description provided for @settingsAppearanceApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get settingsAppearanceApply;

  /// No description provided for @settingsAppearanceReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get settingsAppearanceReset;

  /// No description provided for @settingsAppearanceSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceSectionTitle;

  /// No description provided for @settingsAppearanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a visual style for your account.'**
  String get settingsAppearanceSubtitle;

  /// No description provided for @settingsAppearanceUpdated.
  ///
  /// In en, this message translates to:
  /// **'Appearance updated.'**
  String get settingsAppearanceUpdated;

  /// No description provided for @settingsChangePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your account password'**
  String get settingsChangePasswordSubtitle;

  /// No description provided for @settingsDeleteAccountCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsDeleteAccountCancel;

  /// No description provided for @settingsDeleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get settingsDeleteAccountConfirm;

  /// No description provided for @settingsDeleteAccountDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Your account will be deactivated immediately and a deletion request will be sent to an administrator for review. You will be logged out.'**
  String get settingsDeleteAccountDialogBody;

  /// No description provided for @settingsDeleteAccountDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Account Deletion?'**
  String get settingsDeleteAccountDialogTitle;

  /// No description provided for @settingsDeleteAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit deletion request. Please try again.'**
  String get settingsDeleteAccountFailed;

  /// No description provided for @settingsDeleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Request permanent removal of your account'**
  String get settingsDeleteAccountSubtitle;

  /// No description provided for @settingsDeleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteAccountTitle;

  /// No description provided for @settingsDisable2faDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This will reduce the security of your account. You can re-enable it later.'**
  String get settingsDisable2faDialogBody;

  /// No description provided for @settingsDisable2faDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsDisable2faDialogCancel;

  /// No description provided for @settingsDisable2faDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get settingsDisable2faDialogConfirm;

  /// No description provided for @settingsDisable2faDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Disable 2FA?'**
  String get settingsDisable2faDialogTitle;

  /// No description provided for @settingsDisable2faFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to disable 2FA. Please try again.'**
  String get settingsDisable2faFailed;

  /// No description provided for @settingsDisable2faSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remove 2FA from your account'**
  String get settingsDisable2faSubtitle;

  /// No description provided for @settingsDisable2faTitle.
  ///
  /// In en, this message translates to:
  /// **'Disable 2FA'**
  String get settingsDisable2faTitle;

  /// No description provided for @settingsManageAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your account settings.'**
  String get settingsManageAccountSubtitle;

  /// No description provided for @settingsSecuritySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecuritySectionTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @uiClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get uiClearAll;

  /// No description provided for @uiClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get uiClearFilters;

  /// No description provided for @uiFiltersLabel.
  ///
  /// In en, this message translates to:
  /// **'Filters: '**
  String get uiFiltersLabel;

  /// No description provided for @uiNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get uiNever;

  /// No description provided for @uiSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search: \"{query}\"'**
  String uiSearchLabel(String query);

  /// No description provided for @uiTestControlActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get uiTestControlActive;

  /// No description provided for @uiTestControlArrowTop.
  ///
  /// In en, this message translates to:
  /// **'Arrow Top'**
  String get uiTestControlArrowTop;

  /// No description provided for @uiTestControlAspect.
  ///
  /// In en, this message translates to:
  /// **'Aspect'**
  String get uiTestControlAspect;

  /// No description provided for @uiTestControlAsset.
  ///
  /// In en, this message translates to:
  /// **'Asset'**
  String get uiTestControlAsset;

  /// No description provided for @uiTestControlBackground.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get uiTestControlBackground;

  /// No description provided for @uiTestControlColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get uiTestControlColor;

  /// No description provided for @uiTestControlCreateEnabled.
  ///
  /// In en, this message translates to:
  /// **'Create Enabled'**
  String get uiTestControlCreateEnabled;

  /// No description provided for @uiTestControlDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get uiTestControlDisabled;

  /// No description provided for @uiTestControlEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get uiTestControlEnabled;

  /// No description provided for @uiTestControlFill.
  ///
  /// In en, this message translates to:
  /// **'Fill'**
  String get uiTestControlFill;

  /// No description provided for @uiTestControlFit.
  ///
  /// In en, this message translates to:
  /// **'Fit'**
  String get uiTestControlFit;

  /// No description provided for @uiTestControlHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get uiTestControlHeight;

  /// No description provided for @uiTestControlHeightPx.
  ///
  /// In en, this message translates to:
  /// **'Height: {value}px'**
  String uiTestControlHeightPx(String value);

  /// No description provided for @uiTestControlIcon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get uiTestControlIcon;

  /// No description provided for @uiTestControlLabel.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get uiTestControlLabel;

  /// No description provided for @uiTestControlLegend.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get uiTestControlLegend;

  /// No description provided for @uiTestControlMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get uiTestControlMessage;

  /// No description provided for @uiTestControlNotification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get uiTestControlNotification;

  /// No description provided for @uiTestControlProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress: {value}%'**
  String uiTestControlProgress(String value);

  /// No description provided for @uiTestControlRadius.
  ///
  /// In en, this message translates to:
  /// **'Radius'**
  String get uiTestControlRadius;

  /// No description provided for @uiTestControlRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get uiTestControlRequired;

  /// No description provided for @uiTestControlSemantics.
  ///
  /// In en, this message translates to:
  /// **'Semantics'**
  String get uiTestControlSemantics;

  /// No description provided for @uiTestControlSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get uiTestControlSize;

  /// No description provided for @uiTestControlSpacing.
  ///
  /// In en, this message translates to:
  /// **'Spacing: {value}'**
  String uiTestControlSpacing(String value);

  /// No description provided for @uiTestControlStartExpanded.
  ///
  /// In en, this message translates to:
  /// **'Start Expanded'**
  String get uiTestControlStartExpanded;

  /// No description provided for @uiTestControlSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Subtitle'**
  String get uiTestControlSubtitle;

  /// No description provided for @uiTestControlTagline.
  ///
  /// In en, this message translates to:
  /// **'Tagline'**
  String get uiTestControlTagline;

  /// No description provided for @uiTestControlText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get uiTestControlText;

  /// No description provided for @uiTestControlThickness.
  ///
  /// In en, this message translates to:
  /// **'Thickness: {value}'**
  String uiTestControlThickness(String value);

  /// No description provided for @uiTestControlTrack.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get uiTestControlTrack;

  /// No description provided for @uiTestControlTristate.
  ///
  /// In en, this message translates to:
  /// **'Tristate'**
  String get uiTestControlTristate;

  /// No description provided for @uiTestControlValues.
  ///
  /// In en, this message translates to:
  /// **'Values'**
  String get uiTestControlValues;

  /// No description provided for @uiTestControlVariant.
  ///
  /// In en, this message translates to:
  /// **'Variant'**
  String get uiTestControlVariant;

  /// No description provided for @uiTestControlWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get uiTestControlWeight;

  /// No description provided for @uiTestControlWidth.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get uiTestControlWidth;

  /// No description provided for @uiTestControlWidthPx.
  ///
  /// In en, this message translates to:
  /// **'Width: {value}px'**
  String uiTestControlWidthPx(String value);

  /// No description provided for @uiTestDemoAboveDivider.
  ///
  /// In en, this message translates to:
  /// **'Above divider'**
  String get uiTestDemoAboveDivider;

  /// No description provided for @uiTestDemoAdminPassword.
  ///
  /// In en, this message translates to:
  /// **'Admin Password'**
  String get uiTestDemoAdminPassword;

  /// No description provided for @uiTestDemoAliceCarter.
  ///
  /// In en, this message translates to:
  /// **'Alice Carter'**
  String get uiTestDemoAliceCarter;

  /// No description provided for @uiTestDemoAppointmentTime.
  ///
  /// In en, this message translates to:
  /// **'Appointment Time'**
  String get uiTestDemoAppointmentTime;

  /// No description provided for @uiTestDemoBadge.
  ///
  /// In en, this message translates to:
  /// **'Badge'**
  String get uiTestDemoBadge;

  /// No description provided for @uiTestDemoBelowDivider.
  ///
  /// In en, this message translates to:
  /// **'Below divider'**
  String get uiTestDemoBelowDivider;

  /// No description provided for @uiTestDemoCaution.
  ///
  /// In en, this message translates to:
  /// **'Caution'**
  String get uiTestDemoCaution;

  /// No description provided for @uiTestDemoClickMe.
  ///
  /// In en, this message translates to:
  /// **'Click Me'**
  String get uiTestDemoClickMe;

  /// No description provided for @uiTestDemoCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied to clipboard'**
  String get uiTestDemoCodeCopied;

  /// No description provided for @uiTestDemoCompletionPrefix.
  ///
  /// In en, this message translates to:
  /// **'Completion: {value}%'**
  String uiTestDemoCompletionPrefix(String value);

  /// No description provided for @uiTestDemoConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get uiTestDemoConfirm;

  /// No description provided for @uiTestDemoConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm action'**
  String get uiTestDemoConfirmAction;

  /// No description provided for @uiTestDemoConfirmActionBody.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get uiTestDemoConfirmActionBody;

  /// No description provided for @uiTestDemoContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get uiTestDemoContinue;

  /// No description provided for @uiTestDemoCriticalActionBody.
  ///
  /// In en, this message translates to:
  /// **'This is a secured action. Enter your password before confirmation.'**
  String get uiTestDemoCriticalActionBody;

  /// No description provided for @uiTestDemoCriticalActionTitle.
  ///
  /// In en, this message translates to:
  /// **'Critical Action Confirmation'**
  String get uiTestDemoCriticalActionTitle;

  /// No description provided for @uiTestDemoCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get uiTestDemoCurrentPassword;

  /// No description provided for @uiTestDemoDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get uiTestDemoDateOfBirth;

  /// No description provided for @uiTestDemoDefaultPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Default placeholder'**
  String get uiTestDemoDefaultPlaceholder;

  /// No description provided for @uiTestDemoDemographics.
  ///
  /// In en, this message translates to:
  /// **'Demographics'**
  String get uiTestDemoDemographics;

  /// No description provided for @uiTestDemoEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get uiTestDemoEmail;

  /// No description provided for @uiTestDemoEnrollment.
  ///
  /// In en, this message translates to:
  /// **'Enrollment'**
  String get uiTestDemoEnrollment;

  /// No description provided for @uiTestDemoError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get uiTestDemoError;

  /// No description provided for @uiTestDemoExampleImage.
  ///
  /// In en, this message translates to:
  /// **'Example image'**
  String get uiTestDemoExampleImage;

  /// No description provided for @uiTestDemoFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get uiTestDemoFullName;

  /// No description provided for @uiTestDemoHelloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World'**
  String get uiTestDemoHelloWorld;

  /// No description provided for @uiTestDemoInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get uiTestDemoInfo;

  /// No description provided for @uiTestDemoInvalidPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Demo password is \"Admin123!\".'**
  String get uiTestDemoInvalidPasswordMessage;

  /// No description provided for @uiTestDemoKpiTrends.
  ///
  /// In en, this message translates to:
  /// **'KPI Trends'**
  String get uiTestDemoKpiTrends;

  /// No description provided for @uiTestDemoLearnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get uiTestDemoLearnMore;

  /// No description provided for @uiTestDemoNormalizedPrefix.
  ///
  /// In en, this message translates to:
  /// **'Normalized: {value}'**
  String uiTestDemoNormalizedPrefix(String value);

  /// No description provided for @uiTestDemoNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get uiTestDemoNotes;

  /// No description provided for @uiTestDemoNullIndeterminate.
  ///
  /// In en, this message translates to:
  /// **'null (indeterminate)'**
  String get uiTestDemoNullIndeterminate;

  /// No description provided for @uiTestDemoOpenModal.
  ///
  /// In en, this message translates to:
  /// **'Open modal'**
  String get uiTestDemoOpenModal;

  /// No description provided for @uiTestDemoOpenSecuredModal.
  ///
  /// In en, this message translates to:
  /// **'Open secured modal'**
  String get uiTestDemoOpenSecuredModal;

  /// No description provided for @uiTestDemoOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get uiTestDemoOverview;

  /// No description provided for @uiTestDemoParticipants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get uiTestDemoParticipants;

  /// No description provided for @uiTestDemoPasswordVerified.
  ///
  /// In en, this message translates to:
  /// **'Password verified. Action confirmed.'**
  String get uiTestDemoPasswordVerified;

  /// No description provided for @uiTestDemoPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get uiTestDemoPhoneNumber;

  /// No description provided for @uiTestDemoPlaceholderGraphic.
  ///
  /// In en, this message translates to:
  /// **'Placeholder graphic'**
  String get uiTestDemoPlaceholderGraphic;

  /// No description provided for @uiTestDemoPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get uiTestDemoPriority;

  /// No description provided for @uiTestDemoQueryEmpty.
  ///
  /// In en, this message translates to:
  /// **'(empty)'**
  String get uiTestDemoQueryEmpty;

  /// No description provided for @uiTestDemoQueryNone.
  ///
  /// In en, this message translates to:
  /// **'(none)'**
  String get uiTestDemoQueryNone;

  /// No description provided for @uiTestDemoQueryPrefix.
  ///
  /// In en, this message translates to:
  /// **'Query: {value}'**
  String uiTestDemoQueryPrefix(String value);

  /// No description provided for @uiTestDemoRespondents.
  ///
  /// In en, this message translates to:
  /// **'Respondents'**
  String get uiTestDemoRespondents;

  /// No description provided for @uiTestDemoSearchWidgets.
  ///
  /// In en, this message translates to:
  /// **'Search widgets...'**
  String get uiTestDemoSearchWidgets;

  /// No description provided for @uiTestDemoShowPopover.
  ///
  /// In en, this message translates to:
  /// **'Show popover'**
  String get uiTestDemoShowPopover;

  /// No description provided for @uiTestDemoSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get uiTestDemoSuccess;

  /// No description provided for @uiTestDemoSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get uiTestDemoSummary;

  /// No description provided for @uiTestDemoTaskCompletion.
  ///
  /// In en, this message translates to:
  /// **'Task completion'**
  String get uiTestDemoTaskCompletion;

  /// No description provided for @uiTestDemoThisWeek.
  ///
  /// In en, this message translates to:
  /// **'+12 this week'**
  String get uiTestDemoThisWeek;

  /// No description provided for @uiTestDemoValuePrefix.
  ///
  /// In en, this message translates to:
  /// **'Value: {value}'**
  String uiTestDemoValuePrefix(String value);

  /// No description provided for @uiTestDemoVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed.'**
  String get uiTestDemoVerificationFailed;

  /// No description provided for @uiTestEnterValue.
  ///
  /// In en, this message translates to:
  /// **'Enter value'**
  String get uiTestEnterValue;

  /// No description provided for @uiTestPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Interactive previews with live customization for all reusable widgets.'**
  String get uiTestPageSubtitle;

  /// No description provided for @uiTestPageTitle.
  ///
  /// In en, this message translates to:
  /// **'UI Widget Catalogue'**
  String get uiTestPageTitle;

  /// No description provided for @uiTestSectionBasics.
  ///
  /// In en, this message translates to:
  /// **'Basics'**
  String get uiTestSectionBasics;

  /// No description provided for @uiTestSectionButtons.
  ///
  /// In en, this message translates to:
  /// **'Buttons'**
  String get uiTestSectionButtons;

  /// No description provided for @uiTestSectionDataDisplay.
  ///
  /// In en, this message translates to:
  /// **'Data Display'**
  String get uiTestSectionDataDisplay;

  /// No description provided for @uiTestSectionFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get uiTestSectionFeedback;

  /// No description provided for @uiTestSectionForms.
  ///
  /// In en, this message translates to:
  /// **'Forms and Input'**
  String get uiTestSectionForms;

  /// No description provided for @uiTestSectionMicro.
  ///
  /// In en, this message translates to:
  /// **'Micro Widgets'**
  String get uiTestSectionMicro;

  /// No description provided for @uiTestSectionNavbarActiveDestination.
  ///
  /// In en, this message translates to:
  /// **'Active destination: {label}'**
  String uiTestSectionNavbarActiveDestination(String label);

  /// No description provided for @uiTestSectionNavbarActiveNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get uiTestSectionNavbarActiveNone;

  /// No description provided for @uiTestSectionNavbarAddSection.
  ///
  /// In en, this message translates to:
  /// **'Add Section'**
  String get uiTestSectionNavbarAddSection;

  /// No description provided for @uiTestSectionNavbarAddSubsection.
  ///
  /// In en, this message translates to:
  /// **'Add Subsection'**
  String get uiTestSectionNavbarAddSubsection;

  /// No description provided for @uiTestSectionNavbarContainedTitle.
  ///
  /// In en, this message translates to:
  /// **'Contained Scrollable Page'**
  String get uiTestSectionNavbarContainedTitle;

  /// No description provided for @uiTestSectionNavbarHideCode.
  ///
  /// In en, this message translates to:
  /// **'Hide Code'**
  String get uiTestSectionNavbarHideCode;

  /// No description provided for @uiTestSectionNavbarInitiallyExpanded.
  ///
  /// In en, this message translates to:
  /// **'Initially expanded'**
  String get uiTestSectionNavbarInitiallyExpanded;

  /// No description provided for @uiTestSectionNavbarNoSections.
  ///
  /// In en, this message translates to:
  /// **'No sections configured. Add at least one section in PROPERTIES.'**
  String get uiTestSectionNavbarNoSections;

  /// No description provided for @uiTestSectionNavbarProperties.
  ///
  /// In en, this message translates to:
  /// **'PROPERTIES'**
  String get uiTestSectionNavbarProperties;

  /// No description provided for @uiTestSectionNavbarRemoveSection.
  ///
  /// In en, this message translates to:
  /// **'Remove section'**
  String get uiTestSectionNavbarRemoveSection;

  /// No description provided for @uiTestSectionNavbarRemoveSubsection.
  ///
  /// In en, this message translates to:
  /// **'Remove subsection'**
  String get uiTestSectionNavbarRemoveSubsection;

  /// No description provided for @uiTestSectionNavbarReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get uiTestSectionNavbarReset;

  /// No description provided for @uiTestSectionNavbarScrollHint.
  ///
  /// In en, this message translates to:
  /// **'Scroll this panel or click a destination to jump.'**
  String get uiTestSectionNavbarScrollHint;

  /// No description provided for @uiTestSectionNavbarSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Section label'**
  String get uiTestSectionNavbarSectionLabel;

  /// No description provided for @uiTestSectionNavbarSectionN.
  ///
  /// In en, this message translates to:
  /// **'Section {n}'**
  String uiTestSectionNavbarSectionN(String n);

  /// No description provided for @uiTestSectionNavbarShowCode.
  ///
  /// In en, this message translates to:
  /// **'Show Code'**
  String get uiTestSectionNavbarShowCode;

  /// No description provided for @uiTestSectionNavbarSubsection1.
  ///
  /// In en, this message translates to:
  /// **'Subsection 1'**
  String get uiTestSectionNavbarSubsection1;

  /// No description provided for @uiTestSectionNavbarSubsectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Subsection label'**
  String get uiTestSectionNavbarSubsectionLabel;

  /// No description provided for @uiTestSectionNavbarSubsectionN.
  ///
  /// In en, this message translates to:
  /// **'Subsection {n}'**
  String uiTestSectionNavbarSubsectionN(String n);

  /// No description provided for @uiTestSectionNavbarUntitledSection.
  ///
  /// In en, this message translates to:
  /// **'Untitled Section'**
  String get uiTestSectionNavbarUntitledSection;

  /// No description provided for @uiTestSectionNavbarUntitledSubsection.
  ///
  /// In en, this message translates to:
  /// **'Untitled Subsection'**
  String get uiTestSectionNavbarUntitledSubsection;

  /// No description provided for @uiTestWidgetAppAccordion.
  ///
  /// In en, this message translates to:
  /// **'AppAccordion'**
  String get uiTestWidgetAppAccordion;

  /// No description provided for @uiTestWidgetAppAccordionDesc.
  ///
  /// In en, this message translates to:
  /// **'Expandable panel for showing and hiding details.'**
  String get uiTestWidgetAppAccordionDesc;

  /// No description provided for @uiTestWidgetAppAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'AppAnnouncement'**
  String get uiTestWidgetAppAnnouncement;

  /// No description provided for @uiTestWidgetAppAnnouncementDesc.
  ///
  /// In en, this message translates to:
  /// **'Inline banner for important announcements.'**
  String get uiTestWidgetAppAnnouncementDesc;

  /// No description provided for @uiTestWidgetAppBadge.
  ///
  /// In en, this message translates to:
  /// **'AppBadge'**
  String get uiTestWidgetAppBadge;

  /// No description provided for @uiTestWidgetAppBadgeDesc.
  ///
  /// In en, this message translates to:
  /// **'Semantic pill labels for status, roles, and categories.'**
  String get uiTestWidgetAppBadgeDesc;

  /// No description provided for @uiTestWidgetAppBarChart.
  ///
  /// In en, this message translates to:
  /// **'AppBarChart'**
  String get uiTestWidgetAppBarChart;

  /// No description provided for @uiTestWidgetAppBarChartDesc.
  ///
  /// In en, this message translates to:
  /// **'Bar chart with fl_chart, axis labels, and hover tooltips.'**
  String get uiTestWidgetAppBarChartDesc;

  /// No description provided for @uiTestWidgetAppBreadcrumbs.
  ///
  /// In en, this message translates to:
  /// **'AppBreadcrumbs'**
  String get uiTestWidgetAppBreadcrumbs;

  /// No description provided for @uiTestWidgetAppBreadcrumbsDesc.
  ///
  /// In en, this message translates to:
  /// **'Breadcrumb trail for navigation hierarchy.'**
  String get uiTestWidgetAppBreadcrumbsDesc;

  /// No description provided for @uiTestWidgetAppCardTask.
  ///
  /// In en, this message translates to:
  /// **'AppCardTask'**
  String get uiTestWidgetAppCardTask;

  /// No description provided for @uiTestWidgetAppCardTaskDesc.
  ///
  /// In en, this message translates to:
  /// **'Actionable task card with due text, optional repeat text, and CTA.'**
  String get uiTestWidgetAppCardTaskDesc;

  /// No description provided for @uiTestWidgetAppCheckbox.
  ///
  /// In en, this message translates to:
  /// **'AppCheckbox'**
  String get uiTestWidgetAppCheckbox;

  /// No description provided for @uiTestWidgetAppCheckboxDesc.
  ///
  /// In en, this message translates to:
  /// **'Theme-aware checkbox with controlled and uncontrolled modes.'**
  String get uiTestWidgetAppCheckboxDesc;

  /// No description provided for @uiTestWidgetAppCreateConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'AppCreatePasswordInput + AppConfirmPasswordInput'**
  String get uiTestWidgetAppCreateConfirmPassword;

  /// No description provided for @uiTestWidgetAppCreateConfirmPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Create/confirm password pair with live rule checks.'**
  String get uiTestWidgetAppCreateConfirmPasswordDesc;

  /// No description provided for @uiTestWidgetAppDateInput.
  ///
  /// In en, this message translates to:
  /// **'AppDateInput'**
  String get uiTestWidgetAppDateInput;

  /// No description provided for @uiTestWidgetAppDateInputDesc.
  ///
  /// In en, this message translates to:
  /// **'Date picker input with required validation.'**
  String get uiTestWidgetAppDateInputDesc;

  /// No description provided for @uiTestWidgetAppDivider.
  ///
  /// In en, this message translates to:
  /// **'AppDivider'**
  String get uiTestWidgetAppDivider;

  /// No description provided for @uiTestWidgetAppDividerDesc.
  ///
  /// In en, this message translates to:
  /// **'Visual separator with configurable thickness and spacing.'**
  String get uiTestWidgetAppDividerDesc;

  /// No description provided for @uiTestWidgetAppDropdownInput.
  ///
  /// In en, this message translates to:
  /// **'AppDropdownInput'**
  String get uiTestWidgetAppDropdownInput;

  /// No description provided for @uiTestWidgetAppDropdownInputDesc.
  ///
  /// In en, this message translates to:
  /// **'Form dropdown with required and error behavior.'**
  String get uiTestWidgetAppDropdownInputDesc;

  /// No description provided for @uiTestWidgetAppDropdownMenu.
  ///
  /// In en, this message translates to:
  /// **'AppDropdownMenu'**
  String get uiTestWidgetAppDropdownMenu;

  /// No description provided for @uiTestWidgetAppDropdownMenuDesc.
  ///
  /// In en, this message translates to:
  /// **'Theme-aware dropdown for choosing from options.'**
  String get uiTestWidgetAppDropdownMenuDesc;

  /// No description provided for @uiTestWidgetAppEmailInput.
  ///
  /// In en, this message translates to:
  /// **'AppEmailInput'**
  String get uiTestWidgetAppEmailInput;

  /// No description provided for @uiTestWidgetAppEmailInputDesc.
  ///
  /// In en, this message translates to:
  /// **'Email input with structure validation and autofill.'**
  String get uiTestWidgetAppEmailInputDesc;

  /// No description provided for @uiTestWidgetAppFilledButton.
  ///
  /// In en, this message translates to:
  /// **'AppFilledButton'**
  String get uiTestWidgetAppFilledButton;

  /// No description provided for @uiTestWidgetAppFilledButtonDesc.
  ///
  /// In en, this message translates to:
  /// **'Primary action button with filled background.'**
  String get uiTestWidgetAppFilledButtonDesc;

  /// No description provided for @uiTestWidgetAppGraphRenderer.
  ///
  /// In en, this message translates to:
  /// **'AppGraphRenderer'**
  String get uiTestWidgetAppGraphRenderer;

  /// No description provided for @uiTestWidgetAppGraphRendererDesc.
  ///
  /// In en, this message translates to:
  /// **'Responsive graph container with title and optional custom chart content.'**
  String get uiTestWidgetAppGraphRendererDesc;

  /// No description provided for @uiTestWidgetAppIcon.
  ///
  /// In en, this message translates to:
  /// **'AppIcon'**
  String get uiTestWidgetAppIcon;

  /// No description provided for @uiTestWidgetAppIconDesc.
  ///
  /// In en, this message translates to:
  /// **'Theme-aware icon wrapper with responsive sizing.'**
  String get uiTestWidgetAppIconDesc;

  /// No description provided for @uiTestWidgetAppImage.
  ///
  /// In en, this message translates to:
  /// **'AppImage'**
  String get uiTestWidgetAppImage;

  /// No description provided for @uiTestWidgetAppImageDesc.
  ///
  /// In en, this message translates to:
  /// **'Responsive image with aspect ratio support.'**
  String get uiTestWidgetAppImageDesc;

  /// No description provided for @uiTestWidgetAppLongButton.
  ///
  /// In en, this message translates to:
  /// **'AppLongButton'**
  String get uiTestWidgetAppLongButton;

  /// No description provided for @uiTestWidgetAppLongButtonDesc.
  ///
  /// In en, this message translates to:
  /// **'Full-width button for prominent actions.'**
  String get uiTestWidgetAppLongButtonDesc;

  /// No description provided for @uiTestWidgetAppModalOverlay.
  ///
  /// In en, this message translates to:
  /// **'AppModal + AppOverlay'**
  String get uiTestWidgetAppModalOverlay;

  /// No description provided for @uiTestWidgetAppModalOverlayDesc.
  ///
  /// In en, this message translates to:
  /// **'Button-triggered modal with overlay barrier.'**
  String get uiTestWidgetAppModalOverlayDesc;

  /// No description provided for @uiTestWidgetAppParagraphInput.
  ///
  /// In en, this message translates to:
  /// **'AppParagraphInput'**
  String get uiTestWidgetAppParagraphInput;

  /// No description provided for @uiTestWidgetAppParagraphInputDesc.
  ///
  /// In en, this message translates to:
  /// **'Multi-line text input with controlled line sizing.'**
  String get uiTestWidgetAppParagraphInputDesc;

  /// No description provided for @uiTestWidgetAppPasswordInput.
  ///
  /// In en, this message translates to:
  /// **'AppPasswordInput'**
  String get uiTestWidgetAppPasswordInput;

  /// No description provided for @uiTestWidgetAppPasswordInputDesc.
  ///
  /// In en, this message translates to:
  /// **'Password input with eye toggle and required checks.'**
  String get uiTestWidgetAppPasswordInputDesc;

  /// No description provided for @uiTestWidgetAppPhoneInput.
  ///
  /// In en, this message translates to:
  /// **'AppPhoneInput'**
  String get uiTestWidgetAppPhoneInput;

  /// No description provided for @uiTestWidgetAppPhoneInputDesc.
  ///
  /// In en, this message translates to:
  /// **'Phone input with country selector and normalized output.'**
  String get uiTestWidgetAppPhoneInputDesc;

  /// No description provided for @uiTestWidgetAppPieChart.
  ///
  /// In en, this message translates to:
  /// **'AppPieChart'**
  String get uiTestWidgetAppPieChart;

  /// No description provided for @uiTestWidgetAppPieChartDesc.
  ///
  /// In en, this message translates to:
  /// **'Pie chart with legend, percentage labels, and touch interaction.'**
  String get uiTestWidgetAppPieChartDesc;

  /// No description provided for @uiTestWidgetAppPlaceholderGraphic.
  ///
  /// In en, this message translates to:
  /// **'AppPlaceholderGraphic'**
  String get uiTestWidgetAppPlaceholderGraphic;

  /// No description provided for @uiTestWidgetAppPlaceholderGraphicDesc.
  ///
  /// In en, this message translates to:
  /// **'Theme-aware placeholder graphic for empty states.'**
  String get uiTestWidgetAppPlaceholderGraphicDesc;

  /// No description provided for @uiTestWidgetAppPopover.
  ///
  /// In en, this message translates to:
  /// **'AppPopover'**
  String get uiTestWidgetAppPopover;

  /// No description provided for @uiTestWidgetAppPopoverDesc.
  ///
  /// In en, this message translates to:
  /// **'Context-anchored inline feedback.'**
  String get uiTestWidgetAppPopoverDesc;

  /// No description provided for @uiTestWidgetAppProgressBar.
  ///
  /// In en, this message translates to:
  /// **'AppProgressBar'**
  String get uiTestWidgetAppProgressBar;

  /// No description provided for @uiTestWidgetAppProgressBarDesc.
  ///
  /// In en, this message translates to:
  /// **'Theme-aware progress indicator for completion and status tracking.'**
  String get uiTestWidgetAppProgressBarDesc;

  /// No description provided for @uiTestWidgetAppRadio.
  ///
  /// In en, this message translates to:
  /// **'AppRadio'**
  String get uiTestWidgetAppRadio;

  /// No description provided for @uiTestWidgetAppRadioDesc.
  ///
  /// In en, this message translates to:
  /// **'Theme-aware radio button with controlled and uncontrolled modes.'**
  String get uiTestWidgetAppRadioDesc;

  /// No description provided for @uiTestWidgetAppRichText.
  ///
  /// In en, this message translates to:
  /// **'AppRichText'**
  String get uiTestWidgetAppRichText;

  /// No description provided for @uiTestWidgetAppRichTextDesc.
  ///
  /// In en, this message translates to:
  /// **'Inline formatting with bold, italic, and mixed styles.'**
  String get uiTestWidgetAppRichTextDesc;

  /// No description provided for @uiTestWidgetAppSearchBar.
  ///
  /// In en, this message translates to:
  /// **'AppSearchBar'**
  String get uiTestWidgetAppSearchBar;

  /// No description provided for @uiTestWidgetAppSearchBarDesc.
  ///
  /// In en, this message translates to:
  /// **'Search input with leading icon and clear action.'**
  String get uiTestWidgetAppSearchBarDesc;

  /// No description provided for @uiTestWidgetAppSectionNavbar.
  ///
  /// In en, this message translates to:
  /// **'AppSectionNavbar'**
  String get uiTestWidgetAppSectionNavbar;

  /// No description provided for @uiTestWidgetAppSectionNavbarDesc.
  ///
  /// In en, this message translates to:
  /// **'Section navigation with collapsible groups and active destination highlighting.'**
  String get uiTestWidgetAppSectionNavbarDesc;

  /// No description provided for @uiTestWidgetAppSecuredModal.
  ///
  /// In en, this message translates to:
  /// **'AppSecuredModal'**
  String get uiTestWidgetAppSecuredModal;

  /// No description provided for @uiTestWidgetAppSecuredModalDesc.
  ///
  /// In en, this message translates to:
  /// **'Critical-action confirmation modal requiring password verification.'**
  String get uiTestWidgetAppSecuredModalDesc;

  /// No description provided for @uiTestWidgetAppStatCard.
  ///
  /// In en, this message translates to:
  /// **'AppStatCard'**
  String get uiTestWidgetAppStatCard;

  /// No description provided for @uiTestWidgetAppStatCardDesc.
  ///
  /// In en, this message translates to:
  /// **'Stat card with icon, label, big value, optional subtitle, and accent top border.'**
  String get uiTestWidgetAppStatCardDesc;

  /// No description provided for @uiTestWidgetAppStatusDot.
  ///
  /// In en, this message translates to:
  /// **'AppStatusDot'**
  String get uiTestWidgetAppStatusDot;

  /// No description provided for @uiTestWidgetAppStatusDotDesc.
  ///
  /// In en, this message translates to:
  /// **'Notification indicator overlay on any icon.'**
  String get uiTestWidgetAppStatusDotDesc;

  /// No description provided for @uiTestWidgetAppText.
  ///
  /// In en, this message translates to:
  /// **'AppText'**
  String get uiTestWidgetAppText;

  /// No description provided for @uiTestWidgetAppTextButton.
  ///
  /// In en, this message translates to:
  /// **'AppTextButton'**
  String get uiTestWidgetAppTextButton;

  /// No description provided for @uiTestWidgetAppTextButtonDesc.
  ///
  /// In en, this message translates to:
  /// **'Text-only button for secondary actions.'**
  String get uiTestWidgetAppTextButtonDesc;

  /// No description provided for @uiTestWidgetAppTextDesc.
  ///
  /// In en, this message translates to:
  /// **'Theme-aware text with responsive typography variants.'**
  String get uiTestWidgetAppTextDesc;

  /// No description provided for @uiTestWidgetAppTextInput.
  ///
  /// In en, this message translates to:
  /// **'AppTextInput'**
  String get uiTestWidgetAppTextInput;

  /// No description provided for @uiTestWidgetAppTextInputDesc.
  ///
  /// In en, this message translates to:
  /// **'Single-line text input with label and validation.'**
  String get uiTestWidgetAppTextInputDesc;

  /// No description provided for @uiTestWidgetAppTimeInput.
  ///
  /// In en, this message translates to:
  /// **'AppTimeInput'**
  String get uiTestWidgetAppTimeInput;

  /// No description provided for @uiTestWidgetAppTimeInputDesc.
  ///
  /// In en, this message translates to:
  /// **'Time picker input with required validation.'**
  String get uiTestWidgetAppTimeInputDesc;

  /// No description provided for @uiTestWidgetAppToast.
  ///
  /// In en, this message translates to:
  /// **'AppToast'**
  String get uiTestWidgetAppToast;

  /// No description provided for @uiTestWidgetAppToastDesc.
  ///
  /// In en, this message translates to:
  /// **'Transient overlay notifications with auto-dismiss.'**
  String get uiTestWidgetAppToastDesc;

  /// No description provided for @uiTestWidgetDataTable.
  ///
  /// In en, this message translates to:
  /// **'DataTable'**
  String get uiTestWidgetDataTable;

  /// No description provided for @uiTestWidgetDataTableCell.
  ///
  /// In en, this message translates to:
  /// **'DataTableCell'**
  String get uiTestWidgetDataTableCell;

  /// No description provided for @uiTestWidgetDataTableCellDesc.
  ///
  /// In en, this message translates to:
  /// **'Typed cell factories for consistent table cell styling.'**
  String get uiTestWidgetDataTableCellDesc;

  /// No description provided for @uiTestWidgetDataTableDesc.
  ///
  /// In en, this message translates to:
  /// **'Sortable table with expandable rows, sticky headers, and horizontal scroll.'**
  String get uiTestWidgetDataTableDesc;

  /// No description provided for @uiTestWidgetHealthBankLogo.
  ///
  /// In en, this message translates to:
  /// **'HealthBankLogo'**
  String get uiTestWidgetHealthBankLogo;

  /// No description provided for @uiTestWidgetHealthBankLogoDesc.
  ///
  /// In en, this message translates to:
  /// **'Brand logo with optional tagline and size variants.'**
  String get uiTestWidgetHealthBankLogoDesc;

  /// No description provided for @privacyPolicySection1Body.
  ///
  /// In en, this message translates to:
  /// **'HealthBank collects personal information that you provide when creating your account, including your name, email address, date of birth, and gender. When you complete health surveys, we collect the health data and responses you choose to submit. We also collect technical information such as login timestamps and session activity to maintain platform security.\n\nWe collect only the information necessary to operate the platform and facilitate approved research. You are never required to provide information beyond what is needed to participate in your specific research program.'**
  String get privacyPolicySection1Body;

  /// No description provided for @privacyPolicySection1Title.
  ///
  /// In en, this message translates to:
  /// **'Information We Collect'**
  String get privacyPolicySection1Title;

  /// No description provided for @privacyPolicySection2Body.
  ///
  /// In en, this message translates to:
  /// **'Your personal information is used solely to operate the HealthBank platform and facilitate approved health research. Specifically, we use your data to: authenticate your identity and manage your account; deliver surveys and collect your health responses; allow your assigned healthcare professional to monitor your participation; and provide researchers with aggregated, de-identified results for analysis.\n\nWe do not use your personal information for marketing, advertising, or any commercial purpose. Your data is never sold to third parties.'**
  String get privacyPolicySection2Body;

  /// No description provided for @privacyPolicySection2Title.
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Information'**
  String get privacyPolicySection2Title;

  /// No description provided for @privacyPolicySection3Body.
  ///
  /// In en, this message translates to:
  /// **'Your individual health data is shared only with authorized parties directly involved in your care or your approved research study. Researchers on the platform receive only aggregated, de-identified data — individual responses cannot be linked to your identity in research outputs.\n\nWe may be required to disclose information where mandated by Canadian law, court order, or where disclosure is necessary to prevent serious harm. In all such cases, we disclose only the minimum information required and document every disclosure.'**
  String get privacyPolicySection3Body;

  /// No description provided for @privacyPolicySection3Title.
  ///
  /// In en, this message translates to:
  /// **'How We Share Your Data'**
  String get privacyPolicySection3Title;

  /// No description provided for @privacyPolicySection4Body.
  ///
  /// In en, this message translates to:
  /// **'HealthBank uses industry-standard security measures to protect your personal information, including encrypted data transmission (HTTPS), password hashing, session management, and restricted access controls. The platform is operated on secure servers with access limited to authorized personnel only.\n\nYour data is retained for as long as you are an active participant in a HealthBank research program. You may request deletion of your account and associated data at any time by contacting the HealthBank Privacy Officer. Some data may be retained in aggregated, de-identified form for research continuity after account removal.'**
  String get privacyPolicySection4Body;

  /// No description provided for @privacyPolicySection4Title.
  ///
  /// In en, this message translates to:
  /// **'Data Security and Retention'**
  String get privacyPolicySection4Title;

  /// No description provided for @privacyPolicySection5Body.
  ///
  /// In en, this message translates to:
  /// **'Under PIPEDA and applicable provincial legislation, you have the right to: access the personal information we hold about you; request corrections to inaccurate information; withdraw your consent and request deletion of your data; and receive an explanation of how your data is used.\n\nTo exercise any of these rights, or if you have questions or concerns about your privacy, please contact the HealthBank Privacy Officer at your institution. We are committed to responding to all privacy inquiries within 30 days.'**
  String get privacyPolicySection5Body;

  /// No description provided for @privacyPolicySection5Title.
  ///
  /// In en, this message translates to:
  /// **'Your Rights and Contact'**
  String get privacyPolicySection5Title;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicyTocTitle.
  ///
  /// In en, this message translates to:
  /// **'Table of Contents'**
  String get privacyPolicyTocTitle;

  /// No description provided for @tosSection1Body.
  ///
  /// In en, this message translates to:
  /// **'By creating an account or accessing the HealthBank platform, you agree to be bound by these Terms of Service and our Privacy Policy. If you do not agree to these terms, you must not use the platform. These terms may be updated periodically; continued use of the platform following notice of any changes constitutes your acceptance of the revised terms.'**
  String get tosSection1Body;

  /// No description provided for @tosSection1Title.
  ///
  /// In en, this message translates to:
  /// **'Acceptance of Terms'**
  String get tosSection1Title;

  /// No description provided for @tosSection2Body.
  ///
  /// In en, this message translates to:
  /// **'Access to HealthBank is by invitation only. Participant accounts are created by authorized administrators or healthcare professionals. You must be at least 18 years of age, or have the consent of a parent or guardian if under 18. You are responsible for maintaining the confidentiality of your login credentials and for all activity that occurs under your account.'**
  String get tosSection2Body;

  /// No description provided for @tosSection2Title.
  ///
  /// In en, this message translates to:
  /// **'Eligible Users'**
  String get tosSection2Title;

  /// No description provided for @tosSection3Body.
  ///
  /// In en, this message translates to:
  /// **'You agree to use HealthBank solely for its intended purpose — participating in approved health research and managing your personal health data. You must not attempt to access data belonging to other users; tamper with, reverse-engineer, or disrupt the platform; submit false or misleading information; or use the platform for any unlawful purpose. Violation of these responsibilities may result in immediate account suspension.'**
  String get tosSection3Body;

  /// No description provided for @tosSection3Title.
  ///
  /// In en, this message translates to:
  /// **'User Responsibilities'**
  String get tosSection3Title;

  /// No description provided for @tosSection4Body.
  ///
  /// In en, this message translates to:
  /// **'Your use of HealthBank involves the collection and use of personal health data as described in our Privacy Policy. By using the platform, you consent to this collection for the purposes of approved health research. You may withdraw your consent at any time by contacting your study coordinator or the HealthBank Privacy Officer, which will result in the deactivation of your account. HealthBank is operated in compliance with Canadian privacy legislation.'**
  String get tosSection4Body;

  /// No description provided for @tosSection4Title.
  ///
  /// In en, this message translates to:
  /// **'Data and Privacy'**
  String get tosSection4Title;

  /// No description provided for @tosSection5Body.
  ///
  /// In en, this message translates to:
  /// **'HealthBank is provided as an academic research platform on an \"as is\" basis. While we take all reasonable precautions to maintain security and data integrity, the University of Prince Edward Island and the HealthBank project team shall not be liable for indirect, incidental, or consequential damages arising from your use of the platform. Nothing in these terms limits liability for gross negligence, wilful misconduct, or as required by applicable law.'**
  String get tosSection5Body;

  /// No description provided for @tosSection5Title.
  ///
  /// In en, this message translates to:
  /// **'Limitation of Liability'**
  String get tosSection5Title;

  /// No description provided for @tosTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get tosTitle;

  /// No description provided for @tosTocTitle.
  ///
  /// In en, this message translates to:
  /// **'Contents'**
  String get tosTocTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
