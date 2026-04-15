// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get commonActions => 'Actions';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonClear => 'Effacer';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonConfirm => 'Confirmer';

  @override
  String get commonContactUs => 'Nous joindre';

  @override
  String get commonCopyright => '© 2025 HealthBank. Tous droits réservés.';

  @override
  String get commonDate => 'Date';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonDescription => 'Description';

  @override
  String get commonDone => 'Terminé';

  @override
  String get commonEdit => 'Modifier';

  @override
  String get commonEmail => 'Courriel';

  @override
  String get commonEndDate => 'Date de fin';

  @override
  String commonErrorWithDetail(String detail) {
    return 'Erreur : $detail';
  }

  @override
  String get commonFilter => 'Filtrer';

  @override
  String get commonHidePassword => 'Masquer le mot de passe';

  @override
  String get commonLoading => 'Chargement...';

  @override
  String get commonName => 'Nom';

  @override
  String get commonNext => 'Suivant';

  @override
  String get commonNo => 'Non';

  @override
  String get commonOff => 'Désactivé';

  @override
  String get commonOn => 'Activé';

  @override
  String get commonPassword => 'Mot de passe';

  @override
  String get commonPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get commonRefresh => 'Actualiser';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonSaving => 'Enregistrement…';

  @override
  String get commonSearch => 'Rechercher';

  @override
  String get commonSeeMore => 'Voir plus';

  @override
  String get commonShowPassword => 'Afficher le mot de passe';

  @override
  String get commonStartDate => 'Date de début';

  @override
  String get commonStatus => 'État';

  @override
  String get commonSubmit => 'Soumettre';

  @override
  String get commonTermsOfService => 'Conditions d\'utilisation';

  @override
  String get commonTime => 'Heure';

  @override
  String get commonTitle => 'Titre';

  @override
  String get commonType => 'Type';

  @override
  String get commonViewAll => 'Voir tout';

  @override
  String get commonYes => 'Oui';

  @override
  String get statusActive => 'Actif';

  @override
  String get statusCompleted => 'Terminé';

  @override
  String get statusInactive => 'Inactif';

  @override
  String get statusInProgress => 'En cours';

  @override
  String get statusPending => 'En attente';

  @override
  String get errorGeneric => 'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get errorNetwork =>
      'Erreur de réseau. Veuillez vérifier votre connexion.';

  @override
  String get errorNotFound => 'Non trouvé.';

  @override
  String get errorUnauthorized =>
      'Vous n\'êtes pas autorisé à effectuer cette action.';

  @override
  String get formConfirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get formConfirmPasswordMismatch =>
      'Les mots de passe doivent correspondre exactement.';

  @override
  String get formConfirmPasswordMustMatch =>
      'Le mot de passe de confirmation doit correspondre exactement au mot de passe créé.';

  @override
  String get formCreatePasswordLabel => 'Créer un mot de passe';

  @override
  String get formDateValidationError =>
      'Entrez une date valide au format AAAA-MM-JJ (ex. 2024-01-15).';

  @override
  String get formEmailValidationError =>
      'Entrez une adresse courriel valide (ex. nom@exemple.com).';

  @override
  String get formPasswordCheckTitle => 'Vérification du mot de passe';

  @override
  String get formPasswordRuleAscii =>
      'Utilisez uniquement des lettres ASCII, des chiffres et des symboles courants.';

  @override
  String get formPasswordRuleLowercase => 'Au moins une lettre minuscule.';

  @override
  String get formPasswordRuleMax32 => 'Maximum 32 caractères.';

  @override
  String get formPasswordRuleMin8 => 'Minimum 8 caractères.';

  @override
  String get formPasswordRuleNoEmail =>
      'Ne doit pas contenir de fragments ressemblant à une adresse courriel (par exemple, local@domaine.com).';

  @override
  String get formPasswordRuleNumberOrSymbol =>
      'Au moins un chiffre ou un symbole.';

  @override
  String get formPasswordRulesError =>
      'Le mot de passe ne respecte pas les règles requises.';

  @override
  String get formPasswordRulesHelper =>
      'Votre mot de passe doit satisfaire toutes les exigences suivantes :';

  @override
  String get formPasswordRuleUppercase => 'Au moins une lettre majuscule.';

  @override
  String get formPhoneHint => 'Numéro de téléphone';

  @override
  String get formPhoneValidationError =>
      'Entrez un numéro de téléphone valide avec le code de pays.';

  @override
  String get formSecuredPasswordVerificationFailed =>
      'Échec de la vérification du mot de passe.';

  @override
  String get formTimeValidationError =>
      'Entrez une heure valide au format HH:MM (ex. 09:30).';

  @override
  String get validationInvalidEmail =>
      'Entrez une adresse courriel valide (ex. nom@exemple.com).';

  @override
  String get validationInvalidPassword =>
      'Le mot de passe doit comporter au moins 8 caractères.';

  @override
  String get validationRequired =>
      'Ce champ est obligatoire. Veuillez entrer une valeur.';

  @override
  String get confirmCancel => 'Voulez-vous vraiment annuler?';

  @override
  String get confirmDelete => 'Voulez-vous vraiment supprimer cet élément?';

  @override
  String get confirmUnsavedChanges =>
      'Vous avez des modifications non enregistrées. Voulez-vous vraiment quitter?';

  @override
  String get aboutPageBody =>
      'HealthBank est une plateforme sécurisée de données de santé personnelles développée à l\'Université de l\'Île-du-Prince-Édouard (UIPÉ). Elle met en relation les participants, les professionnels de la santé et les chercheurs dans un environnement conforme à la protection de la vie privée pour la recherche en santé approuvée.\n\nLes participants peuvent remplir des sondages sur la santé et contribuer des données à des projets de recherche auxquels ils ont consenti. Les professionnels de la santé peuvent surveiller la participation et les données de santé de leurs patients. Les chercheurs n\'accèdent qu\'aux résultats agrégés et dépersonnalisés — les données individuelles des participants ne sont jamais exposées dans les résultats de recherche.\n\nToute collecte de données est régie par le consentement éclairé et effectuée conformément à la législation canadienne applicable sur la protection de la vie privée, notamment la LPRPDE et la LPRPS. HealthBank est une initiative universitaire dédiée à l\'avancement de la recherche en santé pour le bénéfice de tous les Canadiens.';

  @override
  String get aboutPageTitle => 'À propos de HealthBank';

  @override
  String get contactSupportEmailLabel => 'Courriel du soutien';

  @override
  String get contactSupportHoursLabel => 'Heures';

  @override
  String get contactSupportHoursValue =>
      'Du lundi au vendredi, de 9 h à 17 h (HE)';

  @override
  String get contactSupportIntro =>
      'Contactez notre équipe de soutien pour de l\'aide avec votre compte, des problèmes techniques ou des questions générales au sujet de HealthBank.';

  @override
  String get contactSupportNote =>
      'Incluez le courriel de votre compte et un court résumé du problème afin que nous puissions répondre plus rapidement.';

  @override
  String get footerHelpAndServices => 'Aide et services';

  @override
  String get footerHowToUse => 'Comment utiliser HealthBank';

  @override
  String get footerLegal => 'Mentions légales';

  @override
  String get footerPrivacy => 'Confidentialité';

  @override
  String get footerTermsOfUse => 'Conditions d\'utilisation';

  @override
  String get helpFaq1Body =>
      'Les comptes sont créés par un administrateur ou un professionnel de la santé de HealthBank. Si vous pensez que vous devriez avoir accès, communiquez avec votre fournisseur de soins de santé ou le coordonnateur de recherche responsable de votre étude. Vous recevrez un courriel contenant des instructions pour configurer votre mot de passe et compléter votre profil.';

  @override
  String get helpFaq1Title => 'Comment créer un compte ?';

  @override
  String get helpFaq2Body =>
      'Après vous être connecté, accédez à la section Sondages depuis votre tableau de bord. Sélectionnez un sondage disponible et suivez les instructions à l\'écran. Vos réponses sont enregistrées automatiquement au fur et à mesure, et vous pouvez revenir à un sondage incomplet à tout moment. Communiquez avec votre coordonnateur d\'étude si vous avez des questions sur un sondage spécifique.';

  @override
  String get helpFaq2Title => 'Comment remplir un sondage sur la santé ?';

  @override
  String get helpFaq3Body =>
      'Vos données de santé personnelles sont strictement confidentielles. Seuls votre professionnel de la santé désigné et les administrateurs autorisés peuvent consulter vos réponses individuelles. Les chercheurs n\'accèdent qu\'aux données agrégées et dépersonnalisées — votre nom et vos coordonnées personnelles ne sont jamais visibles dans les résultats de recherche. Consultez notre politique de confidentialité pour tous les détails.';

  @override
  String get helpFaq3Title => 'Qui peut voir mes données ?';

  @override
  String get homePagePlaceHolderText =>
      'HealthBank est une plateforme sécurisée et axée sur la protection de la vie privée pour la collecte de données de santé personnelles et la recherche. Les participants remplissent des sondages et partagent leurs données de santé pour soutenir une recherche significative. Les professionnels de la santé surveillent la participation des patients. Les chercheurs accèdent à des résultats agrégés et dépersonnalisés, jamais à des dossiers individuels.\n\nToutes les données sont recueillies sous consentement éclairé et protégées conformément à la loi canadienne sur la protection de la vie privée (LPRPDE). Connectez-vous pour accéder à votre tableau de bord, ou demandez un compte pour rejoindre la communauté HealthBank.';

  @override
  String get a11ySkipToContent => 'Aller au contenu principal';

  @override
  String get accessibilitySkipToMain => 'Passer au contenu principal';

  @override
  String get changePasswordButton => 'Changer le mot de passe';

  @override
  String get changePasswordConfirm => 'Confirmer le nouveau mot de passe';

  @override
  String get changePasswordCurrent => 'Mot de passe actuel';

  @override
  String get changePasswordMinLength =>
      'Le mot de passe doit comporter au moins 8 caractères';

  @override
  String get changePasswordMismatch => 'Les mots de passe ne correspondent pas';

  @override
  String get changePasswordNew => 'Nouveau mot de passe';

  @override
  String get changePasswordRequired => 'Ce champ est requis';

  @override
  String get changePasswordSameAsOld =>
      'Le nouveau mot de passe doit être différent du mot de passe actuel';

  @override
  String get changePasswordSubtitle =>
      'Vous devez changer votre mot de passe avant de continuer';

  @override
  String get changePasswordSuccess => 'Mot de passe changé avec succès';

  @override
  String get changePasswordTitle => 'Changer le mot de passe';

  @override
  String get chartNoData => 'Aucune donnée disponible';

  @override
  String get chartTableCount => 'Nombre';

  @override
  String chartTableLabel(String title) {
    return '$title — tableau de données';
  }

  @override
  String get chartTableOption => 'Option';

  @override
  String get chartTablePercent => 'Pourcentage';

  @override
  String get cookieAccept => 'Accepter';

  @override
  String get cookieBody =>
      'Ce site utilise des cookies essentiels pour maintenir des sessions de connexion sécurisées. En continuant à utiliser le site, vous acceptez l\'utilisation de ces cookies.';

  @override
  String get cookieTitle => 'Cookies';

  @override
  String get dashboardGraphClearSelection => 'Effacer';

  @override
  String get dashboardGraphMyResults => 'Mes résultats';

  @override
  String get dashboardGraphNoCompletedSurveys =>
      'Aucun sondage complété pour l\'instant. Complétez un sondage pour voir vos données ici.';

  @override
  String get dashboardGraphNoSelection =>
      'Sélectionnez un sondage et une question pour afficher vos données';

  @override
  String get dashboardGraphQuestionLabel => 'Question';

  @override
  String get dashboardGraphSelectQuestion => 'Sélectionner une question';

  @override
  String get dashboardGraphSelectSurvey => 'Sélectionner un sondage';

  @override
  String get dashboardGraphSettingsTitle => 'Paramètres du graphique';

  @override
  String get dashboardGraphSurveyLabel => 'Sondage';

  @override
  String get deactivatedNoticeMessage =>
      'Votre compte a été désactivé. Si vous pensez qu\'il s\'agit d\'une erreur, veuillez contacter le support.';

  @override
  String get deactivatedNoticeReturnToLogin => 'Retour à la connexion';

  @override
  String get deactivatedNoticeTitle => 'Compte désactivé';

  @override
  String get headerMenu => 'Menu';

  @override
  String get headerUnreadNotifications => 'Notifications non lues';

  @override
  String maintenanceBannerMessage(String time) {
    return 'Le système est actuellement en maintenance et devrait être disponible d\'ici $time. Nous nous excusons pour tout inconvénient.';
  }

  @override
  String get maintenanceBannerMessageNoTime =>
      'Le système est actuellement en maintenance. Nous nous excusons pour tout inconvénient.';

  @override
  String get maintenanceBannerTitle => 'Système en maintenance';

  @override
  String get notFound404Heading => '404 - Page introuvable';

  @override
  String get notFoundDescription =>
      'La page que vous recherchez n\'existe pas.';

  @override
  String get notFoundPageTitle => 'Page introuvable';

  @override
  String paginationPageOf(int current, int total) {
    return 'Page $current de $total';
  }

  @override
  String get reorderMoveDown => 'Descendre';

  @override
  String get reorderMoveUp => 'Monter';

  @override
  String get roleAdmin => 'Administrateur';

  @override
  String get roleHcp => 'Professionnel de la santé';

  @override
  String get roleParticipant => 'Participant';

  @override
  String get roleResearcher => 'Chercheur';

  @override
  String get semanticLogoNavigate =>
      'Logo HealthBank, accéder au tableau de bord';

  @override
  String get sessionExpiryExtend => 'Rester connecté';

  @override
  String get sessionExpiryExtended => 'Session prolongée.';

  @override
  String get sessionExpiryLogout => 'Se déconnecter';

  @override
  String get sessionExpiryMessage =>
      'Votre session expirera dans 5 minutes. Souhaitez-vous rester connecté?';

  @override
  String get sessionExpiryTitle => 'Session bientôt expirée';

  @override
  String get themePresetClassicCream => 'Crème classique';

  @override
  String get themePresetClassicCreamDesc => 'Chrome ivoire chaleureux';

  @override
  String get themePresetClassicGrey => 'Gris classique';

  @override
  String get themePresetClassicGreyDesc => 'Chrome gris froid';

  @override
  String get themePresetDark => 'Sombre';

  @override
  String get themePresetDarkDesc => 'Mode sombre moderne';

  @override
  String get themePresetModern => 'Moderne';

  @override
  String get themePresetModernDesc => 'Surfaces plates épurées';

  @override
  String get tooltipBarChart => 'Diagramme en barres';

  @override
  String get tooltipClearFilter => 'Effacer le filtre';

  @override
  String get tooltipClearSearch => 'Effacer la recherche';

  @override
  String get tooltipClose => 'Fermer';

  @override
  String get tooltipCloseModal => 'Fermer';

  @override
  String get tooltipCollapseSidebar => 'Réduire la barre latérale';

  @override
  String get tooltipDismissNotification => 'Fermer la notification';

  @override
  String get tooltipExpandSidebar => 'Développer la barre latérale';

  @override
  String get tooltipGoBack => 'Retour';

  @override
  String get tooltipLineChart => 'Graphique en courbes';

  @override
  String get tooltipNextPage => 'Page suivante';

  @override
  String get tooltipPickDate => 'Choisir la date';

  @override
  String get tooltipPickTime => 'Choisir l\'heure';

  @override
  String get tooltipPieChart => 'Diagramme circulaire';

  @override
  String get tooltipPreviousPage => 'Page précédente';

  @override
  String get tooltipRemoveOption => 'Supprimer l\'option';

  @override
  String get tooltipTableView => 'Vue tableau';

  @override
  String get tooltipTogglePasswordVisibility =>
      'Afficher/masquer le mot de passe';

  @override
  String get auth2faCodeHint => '123456';

  @override
  String get auth2faConfirm2fa => 'Confirmer la 2FA';

  @override
  String get auth2faEnrollAndRetrieveProvisioningUri =>
      'Enrôlez votre compte et récupérez l’URI de provisionnement (utilisée pour le code QR).';

  @override
  String get auth2faEnrollApi => 'Enrôler';

  @override
  String get auth2faEnterCodeFromAuthenticator =>
      'Saisissez le code à 6 chiffres de votre application d’authentification';

  @override
  String get auth2faEnterCodeToFinishSignin =>
      'Saisissez le code à 6 chiffres pour terminer la connexion.';

  @override
  String get auth2faErrorEnrollFailed =>
      'Échec de l’activation de la 2FA. Veuillez réessayer.';

  @override
  String get auth2faErrorVerifyFailed =>
      'Échec de la vérification de la 2FA. Veuillez réessayer.';

  @override
  String get auth2faPleaseLoginFirstToEnroll =>
      'Veuillez d’abord vous connecter pour activer la 2FA.';

  @override
  String get auth2faTitle => 'Authentification à deux facteurs (2FA)';

  @override
  String get auth2faVerify => 'Vérifier';

  @override
  String get authEmailInvalid => 'Veuillez entrer un courriel valide';

  @override
  String get authEmailRequired => 'Entrez votre adresse courriel.';

  @override
  String get authForgotPasswordBackToLogin => 'Retour à la connexion';

  @override
  String get authForgotPasswordButton => 'Envoyer le lien de réinitialisation';

  @override
  String get authForgotPasswordSubtitle =>
      'Entrez votre courriel pour recevoir un lien de réinitialisation';

  @override
  String get authForgotPasswordSuccess =>
      'Lien de réinitialisation du mot de passe envoyé à votre courriel';

  @override
  String get authForgotPasswordTitle => 'Mot de passe oublié';

  @override
  String get authLoggingIn => 'Connexion en cours...';

  @override
  String get authLoggingOut => 'Fermeture de session...';

  @override
  String get authLoginButton => 'Ouvrir une session';

  @override
  String get authLoginEmail => 'Courriel';

  @override
  String get authLoginError => 'Courriel ou mot de passe invalide';

  @override
  String get authLoginForgotPassword => 'Mot de passe oublié?';

  @override
  String get authLoginNoAccount => 'Vous n\'avez pas de compte?';

  @override
  String get authLoginPassword => 'Mot de passe';

  @override
  String get authLoginRememberMe => 'Se souvenir de moi';

  @override
  String get authLoginSignUp => 'S\'inscrire';

  @override
  String get authLoginSubtitle =>
      'Entrez vos identifiants pour accéder à votre compte';

  @override
  String get authLoginTitle => 'Ouvrir une session';

  @override
  String get authLogout => 'Déconnexion';

  @override
  String get authLogoutMessage =>
      'Votre session a été fermée avec succès.\nVeuillez cliquer sur le bouton Retour pour\nrevenir à la page de connexion.';

  @override
  String get authLogoutReturn => 'Retour';

  @override
  String get authLogoutReturnToLogin => 'Retour à la connexion';

  @override
  String get authLogoutTitle => 'Déconnexion réussie';

  @override
  String get authMaintenanceModeAdminNote =>
      'Les comptes administrateurs peuvent toujours se connecter.';

  @override
  String get authMaintenanceModeDefaultMessage =>
      'Le système est temporairement indisponible pour une maintenance planifiée.';

  @override
  String get authMaintenanceModeLoginError =>
      'Le système est en maintenance. Seuls les administrateurs peuvent se connecter.';

  @override
  String get authMaintenanceModeTitle => 'Maintenance du système';

  @override
  String get authNewHereRequestAccount => 'Nouveau? Demander un compte';

  @override
  String get authNotifications => 'Notifications';

  @override
  String get authPasswordRequired => 'Entrez votre mot de passe.';

  @override
  String get authPleaseLogIn => 'Veuillez ouvrir une session pour continuer.';

  @override
  String get authProfile => 'Profil';

  @override
  String get authRegisterButton => 'Créer un compte';

  @override
  String get authRegisterConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get authRegisterFirstName => 'Prénom';

  @override
  String get authRegisterHaveAccount => 'Vous avez déjà un compte?';

  @override
  String get authRegisterLastName => 'Nom de famille';

  @override
  String get authRegisterLogin => 'Ouvrir une session';

  @override
  String get authRegisterPasswordMismatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get authRegisterSubtitle =>
      'Entrez vos renseignements pour créer un compte';

  @override
  String get authRegisterTitle => 'Créer un compte';

  @override
  String get authResetPasswordButton => 'Réinitialiser le mot de passe';

  @override
  String get authResetPasswordConfirmPassword =>
      'Confirmer le nouveau mot de passe';

  @override
  String get authResetPasswordConfirmRequired =>
      'Veuillez confirmer votre mot de passe';

  @override
  String get authResetPasswordInvalidLinkMessage =>
      'Ce lien de réinitialisation du mot de passe est invalide ou a expiré. Veuillez en demander un nouveau.';

  @override
  String get authResetPasswordInvalidLinkTitle =>
      'Lien de réinitialisation invalide';

  @override
  String get authResetPasswordNewPassword => 'Nouveau mot de passe';

  @override
  String get authResetPasswordSubtitle => 'Entrez votre nouveau mot de passe';

  @override
  String get authResetPasswordSuccess =>
      'Mot de passe réinitialisé avec succès';

  @override
  String get authResetPasswordSuccessMessage =>
      'Votre mot de passe a été réinitialisé avec succès.';

  @override
  String get authResetPasswordSuccessTitle => 'Mot de passe réinitialisé';

  @override
  String get authResetPasswordTitle => 'Réinitialiser le mot de passe';

  @override
  String get authSettings => 'Paramètres';

  @override
  String get authWelcomeTo => 'Bienvenue à HealthBank.';

  @override
  String get accountEditError404 =>
      'Compte introuvable. Il a peut-être été supprimé.';

  @override
  String get accountEditError409 =>
      'Cette adresse courriel est déjà utilisée par un autre compte.';

  @override
  String get accountEditError422 =>
      'Données invalides. Veuillez vérifier tous les champs.';

  @override
  String get accountEditErrorNetwork =>
      'Erreur réseau. Veuillez vérifier votre connexion.';

  @override
  String get accountEditErrorServer =>
      'Une erreur serveur s\'est produite. Veuillez réessayer.';

  @override
  String get accountEditSaving => 'Enregistrement...';

  @override
  String get accountEditSuccess => 'Utilisateur mis à jour avec succès.';

  @override
  String get accountEditValidationEmail =>
      'Veuillez entrer une adresse courriel valide.';

  @override
  String get accountEditValidationName => 'Le nom ne peut pas être vide.';

  @override
  String get requestAccountBackToLogin => 'Retour à la connexion';

  @override
  String get requestAccountBirthdate => 'Date de naissance';

  @override
  String get requestAccountDuplicateEmail =>
      'Un compte avec ce courriel existe déjà';

  @override
  String get requestAccountDuplicatePending =>
      'Une demande pour ce courriel est déjà en attente';

  @override
  String get requestAccountEmail => 'Courriel';

  @override
  String get requestAccountEmailRequired => 'Le courriel est requis';

  @override
  String get requestAccountError =>
      'Impossible de soumettre la demande. Veuillez réessayer.';

  @override
  String get requestAccountFirstName => 'Prénom';

  @override
  String get requestAccountFirstNameRequired => 'Le prénom est requis';

  @override
  String get requestAccountGender => 'Genre';

  @override
  String get requestAccountGenderFemale => 'Femme';

  @override
  String get requestAccountGenderMale => 'Homme';

  @override
  String get requestAccountGenderNonBinary => 'Non-binaire';

  @override
  String get requestAccountGenderOther => 'Autre';

  @override
  String get requestAccountGenderOtherSpecify => 'Veuillez préciser';

  @override
  String get requestAccountGenderPreferNotToSay => 'Préfère ne pas répondre';

  @override
  String get requestAccountLastName => 'Nom de famille';

  @override
  String get requestAccountLastNameRequired => 'Le nom de famille est requis';

  @override
  String get requestAccountRole => 'Sélectionner un rôle';

  @override
  String get requestAccountRoleHcp => 'Professionnel de la santé';

  @override
  String get requestAccountRoleParticipant => 'Participant';

  @override
  String get requestAccountRoleRequired => 'Veuillez sélectionner un rôle';

  @override
  String get requestAccountRoleResearcher => 'Chercheur';

  @override
  String get requestAccountSubmit => 'Soumettre la demande';

  @override
  String get requestAccountSubtitle =>
      'Remplissez ce formulaire pour demander un compte';

  @override
  String get requestAccountSuccess =>
      'Votre demande a été soumise. Vous recevrez un courriel lorsque votre compte sera approuvé.';

  @override
  String get requestAccountTitle => 'Demander un compte';

  @override
  String get requestAccountTooManyRequests =>
      'Trop de demandes. Veuillez réessayer plus tard.';

  @override
  String get resetPasswordCopied => 'Mot de passe copié dans le presse-papiers';

  @override
  String get resetPasswordCopy => 'Copier dans le presse-papiers';

  @override
  String get resetPasswordEmailAddress => 'Adresse courriel';

  @override
  String get resetPasswordEmailHint => 'Entrer une autre adresse courriel';

  @override
  String get resetPasswordEmailInvalid => 'Entrer une adresse courriel valide';

  @override
  String get resetPasswordEmailRequired => 'Le courriel est obligatoire';

  @override
  String get resetPasswordEmailSubtitle =>
      'Envoyer le mot de passe temporaire par courriel à l\'utilisateur';

  @override
  String get resetPasswordGenerate => 'Générer un mot de passe aléatoire';

  @override
  String get resetPasswordHint => 'Entrer un mot de passe ou en générer un';

  @override
  String get resetPasswordMinLength =>
      'Le mot de passe doit comporter au moins 8 caractères';

  @override
  String get resetPasswordModalTitle => 'Réinitialiser le mot de passe';

  @override
  String get resetPasswordNewPassword => 'Nouveau mot de passe';

  @override
  String get resetPasswordRequired => 'Le mot de passe est obligatoire';

  @override
  String get resetPasswordResetting => 'Réinitialisation en cours...';

  @override
  String get resetPasswordSendEmail => 'Envoyer une notification par courriel';

  @override
  String get resetPasswordSuccessEmail =>
      'Mot de passe réinitialisé et courriel envoyé avec succès';

  @override
  String get resetPasswordSuccessNoEmail =>
      'Mot de passe réinitialisé avec succès';

  @override
  String get resetPasswordUseAlternate => 'Utiliser un autre courriel';

  @override
  String get profileBirthdate => 'Date de naissance';

  @override
  String get profileCompletionBirthdate => 'Date de naissance';

  @override
  String get profileCompletionBirthdateRequired =>
      'La date de naissance est requise';

  @override
  String get profileCompletionError =>
      'Échec de la sauvegarde du profil. Veuillez réessayer.';

  @override
  String get profileCompletionGender => 'Genre';

  @override
  String get profileCompletionGenderFemale => 'Femme';

  @override
  String get profileCompletionGenderMale => 'Homme';

  @override
  String get profileCompletionGenderNonBinary => 'Non-binaire';

  @override
  String get profileCompletionGenderOther => 'Autre';

  @override
  String get profileCompletionGenderPreferNotToSay => 'Préfère ne pas répondre';

  @override
  String get profileCompletionGenderRequired =>
      'La sélection du genre est requise';

  @override
  String get profileCompletionSubmit => 'Continuer';

  @override
  String get profileCompletionSubtitle =>
      'Veuillez fournir les informations suivantes pour compléter la configuration de votre compte.';

  @override
  String get profileCompletionTitle => 'Complétez votre profil';

  @override
  String get profileEditInformation => 'Modifier';

  @override
  String get profileEmail => 'Courriel';

  @override
  String get profileEmailInvalid => 'Entrez un courriel valide';

  @override
  String get profileEmailRequired => 'Le courriel est requis';

  @override
  String get profileFirstName => 'Prénom';

  @override
  String get profileFirstNameRequired => 'Le prénom est requis';

  @override
  String get profileGender => 'Genre';

  @override
  String get profileLastName => 'Nom de famille';

  @override
  String get profileLastNameRequired => 'Le nom de famille est requis';

  @override
  String get profileLoadError => 'Échec du chargement du profil.';

  @override
  String profileRole(String role) {
    return 'Rôle : $role';
  }

  @override
  String get profileSaveChanges => 'Enregistrer';

  @override
  String get profileSubtitle => 'Gérez vos informations personnelles';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileUpdateError => 'Échec de la mise à jour du profil.';

  @override
  String get profileUpdateSuccess => 'Profil mis à jour avec succès.';

  @override
  String get navAbout => 'À propos';

  @override
  String get navAccountRequests => 'Demandes de compte';

  @override
  String get navAuditLog => 'Journal d\'audit';

  @override
  String get navBackup => 'Sauvegardes de la base de données';

  @override
  String get navChangePassword => 'Modifier le mot de passe';

  @override
  String get navClients => 'Clients';

  @override
  String get navCompleteProfile => 'Compléter le profil';

  @override
  String get navConsent => 'Consentement';

  @override
  String get navDashboard => 'Tableau de bord';

  @override
  String get navDashboardV2 => 'Tableau de bord v2';

  @override
  String get navData => 'Données';

  @override
  String get navDatabase => 'Base de données';

  @override
  String get navDatabaseViewer => 'Visionneuse de base de données';

  @override
  String get navDeletionQueue => 'File d\'attente de suppression';

  @override
  String get navErrorPage => 'Page d\'erreur';

  @override
  String get navForgotPassword => 'Mot de passe oublié';

  @override
  String get navFriends => 'Contacts';

  @override
  String get navHealthTracking => 'Suivi de santé';

  @override
  String get navHelp => 'Aide';

  @override
  String get navHome => 'Accueil';

  @override
  String get navLogin => 'Connexion';

  @override
  String get navMessages => 'Messages';

  @override
  String get navMySurveys => 'Mes sondages';

  @override
  String get navNewMessage => 'Nouveau message';

  @override
  String get navNewSurvey => 'Nouveau sondage';

  @override
  String get navNewTemplate => 'Nouveau modèle';

  @override
  String get navPageNavigator => 'Navigateur de pages';

  @override
  String get navParticipants => 'Participants';

  @override
  String get navQuestionBank => 'Banque de questions';

  @override
  String get navReports => 'Rapports';

  @override
  String get navRequestAccount => 'Demander un compte';

  @override
  String get navResetPassword => 'Réinitialiser le mot de passe';

  @override
  String get navResults => 'Résultats';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get navSurveys => 'Sondages';

  @override
  String get navTasks => 'À faire';

  @override
  String get navTemplates => 'Modèles';

  @override
  String get navTickets => 'Billets';

  @override
  String get navUiTest => 'Test d\'interface';

  @override
  String get navUserManagement => 'Gestion des utilisateurs';

  @override
  String get consentCheckboxLabel =>
      'J\'ai lu, compris et j\'accepte les termes de ce formulaire de consentement.';

  @override
  String get consentDateLabel => 'Date';

  @override
  String get consentDocumentHcp =>
      'ACCORD D\'ACCÈS AUX DONNÉES ET DE CONFIDENTIALITÉ DU PROFESSIONNEL DE LA SANTÉ\n\nPlateforme : HealthBank — Plateforme de collecte et de recherche de données de santé personnelles\n\n1. OBLIGATIONS PROFESSIONNELLES\n\nEn tant que professionnel de la santé (PS) accédant à la plateforme HealthBank, vous reconnaissez que vous êtes lié par cet accord et par les normes professionnelles et les règlements régissant votre pratique, y compris ceux de votre ordre professionnel ou association. Vos obligations en vertu de cet accord s\'ajoutent à vos devoirs professionnels existants de confidentialité et ne les remplacent pas.\n\n2. LIMITATIONS D\'ACCÈS AUX DONNÉES\n\nVotre accès aux données des participants via HealthBank est strictement limité à :\n- Les données directement pertinentes aux soins des patients sous votre supervision\n- Les données de recherche agrégées autorisées par votre accord institutionnel\n- Les informations nécessaires à la prise de décision clinique dans le cadre de votre champ de pratique\n\nVous ne devez pas accéder aux données de patients qui ne sont pas sous vos soins, ni à des fins sans rapport avec des activités cliniques ou de recherche autorisées.\n\n3. DEVOIR DE CONFIDENTIALITÉ\n\nVous acceptez de maintenir une confidentialité absolue concernant toutes les données des participants accessibles via cette plateforme. Ce devoir de confidentialité :\n- S\'ajoute à vos obligations professionnelles en vertu de votre organisme de réglementation\n- Se poursuit indéfiniment, même après que vous cessez d\'utiliser la plateforme\n- S\'étend à toutes les formes de données, qu\'elles soient numériques, verbales ou écrites\n- S\'applique dans tous les contextes, y compris les conversations avec des collègues non impliqués dans les soins du participant\n\n4. SIGNALEMENT DE VIOLATION\n\nVous êtes légalement et professionnellement tenu de signaler immédiatement toute violation de données soupçonnée ou réelle, y compris :\n- Accès non autorisé aux données des patients\n- Divulgation accidentelle de renseignements personnels sur la santé identifiables\n- Perte ou vol d\'appareils utilisés pour accéder à la plateforme\n- Activité suspecte observée sur la plateforme\n\nLes signalements doivent être faits au responsable de la protection de la vie privée de HealthBank dans les 24 heures suivant la découverte. Le défaut de signaler une violation constitue en soi une violation de cet accord et peut constituer une faute professionnelle.\n\n5. RECONNAISSANCE DE RESPONSABILITÉ\n\nVous reconnaissez que :\n- Vous êtes personnellement responsable de tout accès non autorisé ou divulgation de données de participants\n- Votre institution peut également être responsable des violations survenant au sein de ses systèmes\n- La couverture d\'assurance peut ne pas s\'appliquer aux violations intentionnelles ou d\'une négligence grave\n- Les participants ont le droit de demander des dommages-intérêts pour la divulgation non autorisée de leurs renseignements de santé\n\n6. CONFORMITÉ RÉGLEMENTAIRE\n\nVous confirmez que vous vous conformerez à toutes les lois applicables en matière de protection de la vie privée et de renseignements sur la santé, y compris :\n- La LPRPS (Loi sur la protection des renseignements personnels sur la santé)\n- La LPRPDE (Loi sur la protection des renseignements personnels et les documents électroniques)\n- Les normes professionnelles de votre ordre professionnel\n- Les politiques institutionnelles de confidentialité et de traitement des données\n\n7. EXCEPTIONS DE DIVULGATION\n\nVous pouvez divulguer des informations sur les participants sans consentement uniquement lorsque requis ou permis par la loi, y compris :\n- Lorsque requis par ordonnance du tribunal ou assignation à comparaître\n- Pour prévenir un préjudice imminent au participant ou à d\'autres personnes\n- Lorsque requis par la législation sur les signalements obligatoires (p. ex. protection de l\'enfance)\n- Tel que requis par votre organisme de réglementation professionnelle lors d\'une enquête\n\nDans tous ces cas, vous devez documenter la divulgation et en informer le responsable de la protection de la vie privée de HealthBank.\n\n8. CONSÉQUENCES D\'UNE VIOLATION\n\nLa violation de cet accord peut entraîner :\n- La révocation immédiate de l\'accès à la plateforme\n- Le signalement à votre organisme de réglementation professionnelle\n- Des procédures disciplinaires pouvant inclure la suspension ou la révocation du permis d\'exercice\n- Une responsabilité civile pour les dommages aux participants affectés\n- Des pénalités en vertu de la LPRPS/LPRPDE (amendes pouvant atteindre 100 000 \$ par violation)\n- Des poursuites criminelles en cas de violation volontaire ou malveillante\n\nEn cochant la case d\'accord ci-dessous, vous confirmez que vous avez lu, compris et acceptez tous les termes de cet accord de confidentialité.';

  @override
  String get consentDocumentParticipant =>
      'FORMULAIRE DE CONSENTEMENT ÉCLAIRÉ DU PARTICIPANT\n\nTitre de l\'étude : HealthBank — Plateforme de collecte et de recherche de données de santé personnelles\n\n1. OBJECTIF DE CETTE ÉTUDE\n\nVous êtes invité(e) à participer à une étude de recherche menée par l\'intermédiaire de la plateforme HealthBank. L\'objectif de cette étude est de recueillir des renseignements personnels sur la santé des participants afin de soutenir la recherche en santé, l\'analyse de données et l\'amélioration des résultats en matière de soins de santé. Votre participation est entièrement volontaire.\n\n2. TYPES DE DONNÉES RECUEILLIES\n\nEn tant que participant, les types d\'informations suivants peuvent être recueillis auprès de vous :\n- Informations démographiques (nom, date de naissance, sexe)\n- Réponses aux sondages de santé (santé physique, santé mentale, mode de vie, symptômes)\n- Données de complétion des sondages (horodatages, schémas de réponse)\n- Données techniques (adresse IP, informations du navigateur) à des fins de sécurité\n\n3. UTILISATION DE VOS DONNÉES\n\nVos données seront utilisées aux fins suivantes :\n- Recherche en santé menée par des chercheurs autorisés\n- Analyse statistique et agrégation pour identifier les tendances en santé\n- Amélioration des services et des résultats en matière de soins de santé\n- Publication académique (uniquement des données agrégées et dépersonnalisées)\n\nVos réponses individuelles ne seront jamais publiées ni partagées d\'une manière qui pourrait vous identifier. Tous les résultats de recherche utilisent des données agrégées avec un minimum de 5 répondants (k-anonymat) pour empêcher l\'identification.\n\n4. QUI A ACCÈS À VOS DONNÉES\n\nL\'accès à vos données est strictement contrôlé :\n- Chercheurs : Accès uniquement aux données agrégées et dépersonnalisées via le portail de recherche\n- Professionnels de la santé (PS) : Accès limité aux données pertinentes à vos soins\n- Administrateurs système : Accès technique pour la maintenance de la plateforme uniquement\n- Aucun tiers ne recevra vos données individuelles sans votre consentement explicite\n\n5. CONSERVATION DES DONNÉES\n\nVos données seront conservées pendant la durée du programme de recherche. Après la conclusion du programme, les données seront archivées de manière sécurisée ou détruites conformément aux politiques de conservation des données institutionnelles. Vous pouvez demander des informations sur les délais de conservation des données à tout moment.\n\n6. VOTRE DROIT DE RETRAIT\n\nVous avez le droit de retirer votre consentement à tout moment sans pénalité ni perte d\'avantages. Pour vous retirer, contactez le responsable de la protection de la vie privée aux coordonnées fournies ci-dessous. Lors du retrait :\n- Aucune nouvelle donnée ne sera recueillie auprès de vous\n- Votre compte sera désactivé\n- Cependant, les données déjà incluses dans des analyses complétées ou des recherches publiées ne peuvent être retirées, car elles ont été agrégées et dépersonnalisées\n\n7. PERSISTANCE DES DONNÉES APRÈS LE RETRAIT\n\nVeuillez noter que bien que nous cessions de recueillir de nouvelles données lors du retrait, toute donnée déjà partagée avec des chercheurs sous forme agrégée ne peut être rappelée ou retirée des analyses complétées. Il s\'agit d\'une limitation nécessaire des données de recherche déjà traitées.\n\n8. RISQUES ET MESURES DE PROTECTION\n\nBien que tous les efforts soient déployés pour protéger vos données, aucun système n\'est entièrement sans risque. Les risques potentiels comprennent :\n- Accès non autorisé malgré les mesures de sécurité\n- Réidentification par combinaison avec des sources de données externes\n\nPour atténuer ces risques, nous employons :\n- Chiffrement aux normes de l\'industrie pour les données en transit et au repos\n- Contrôles d\'accès basés sur les rôles limitant qui peut voir quelles données\n- Seuils de k-anonymat (minimum 5 répondants) pour tous les résultats de recherche\n- Audits de sécurité et surveillance réguliers\n- Gestion sécurisée des sessions avec expiration automatique\n\n9. MESURES DE CONFIDENTIALITÉ\n\nVos informations sont protégées par :\n- Stockage et transmission de données chiffrés\n- Contrôles d\'accès stricts basés sur le rôle et le besoin\n- Journalisation d\'audit de tous les accès aux données\n- Conformité à la LPRPDE (Loi sur la protection des renseignements personnels et les documents électroniques) et à la LPRPS (Loi sur la protection des renseignements personnels sur la santé)\n- Respect de l\'EPTC 2 (Énoncé de politique des trois Conseils : Éthique de la recherche avec des êtres humains)\n\n10. COORDONNÉES\n\nSi vous avez des questions au sujet de cette étude, de vos droits en tant que participant ou si vous souhaitez retirer votre consentement, veuillez contacter :\n\nResponsable de la protection de la vie privée de HealthBank\nCourriel : privacy@healthbank.ca\n\n11. SIGNATURE ÉLECTRONIQUE\n\nEn cochant la case d\'accord ci-dessous, vous confirmez que :\n- Vous avez lu et compris ce formulaire de consentement\n- Vous acceptez volontairement de participer à cette étude\n- Vous comprenez votre droit de vous retirer à tout moment\n- Vous reconnaissez que votre accord électronique constitue une signature juridiquement contraignante en vertu de la Loi uniforme sur le commerce électronique (LUCE)';

  @override
  String get consentDocumentResearcher =>
      'ACCORD D\'UTILISATION DES DONNÉES ET DE CONFIDENTIALITÉ DU CHERCHEUR\n\nPlateforme : HealthBank — Plateforme de collecte et de recherche de données de santé personnelles\n\n1. OBLIGATIONS DE CONFIDENTIALITÉ DES DONNÉES\n\nEn tant que chercheur autorisé sur la plateforme HealthBank, vous acceptez de maintenir la plus stricte confidentialité concernant toutes les données des participants accessibles via cette plateforme. Vous reconnaissez que les données des participants sont recueillies sous consentement éclairé et sont protégées par la législation canadienne sur la protection de la vie privée, y compris la LPRPDE et la LPRPS.\n\n2. UTILISATIONS PERMISES\n\nVous pouvez utiliser les données accessibles via HealthBank uniquement pour :\n- Les projets de recherche approuvés tels que définis dans votre protocole de recherche\n- L\'analyse statistique utilisant des données agrégées et dépersonnalisées\n- Les publications académiques utilisant uniquement des résultats agrégés\n- L\'amélioration de la qualité des méthodologies de recherche\n\nToute utilisation au-delà de ces fins nécessite une approbation séparée de l\'administration de HealthBank et des comités d\'éthique pertinents.\n\n3. LIMITATIONS DE DIVULGATION\n\nVous acceptez de NE PAS :\n- Partager les données individuelles des participants avec toute personne non autorisée\n- Tenter de réidentifier ou de désanonymiser tout participant\n- Transférer des données en dehors de la plateforme HealthBank sans autorisation écrite\n- Utiliser les données à des fins commerciales sans approbation explicite\n- Discuter des réponses individuelles des participants en dehors de l\'équipe de recherche autorisée\n\n4. CONSÉQUENCES D\'UNE VIOLATION\n\nLa violation de cet accord peut entraîner :\n- La révocation immédiate de l\'accès à la plateforme\n- Des mesures disciplinaires par votre institution\n- Une responsabilité juridique en vertu de la LPRPDE et de la LPRPS (amendes pouvant atteindre 100 000 \$ par violation)\n- Des sanctions professionnelles des organismes de réglementation pertinents\n- Une responsabilité civile pour les dommages causés aux participants\n\n5. TRAITEMENT ET SÉCURITÉ DES DONNÉES\n\nVous acceptez de :\n- Accéder aux données uniquement via l\'interface autorisée de la plateforme HealthBank\n- Ne pas télécharger ni stocker de données individuelles de participants sur des appareils personnels\n- Utiliser uniquement des appareils institutionnels protégés par mot de passe pour l\'accès à la recherche\n- Signaler immédiatement toute violation de données soupçonnée au responsable de la protection de la vie privée de HealthBank\n- Suivre toutes les politiques et procédures de sécurité des données institutionnelles\n\n6. RESTRICTIONS DE PUBLICATION\n\nLors de la publication de recherches basées sur les données de HealthBank, vous devez :\n- Utiliser uniquement des résultats agrégés et dépersonnalisés\n- Vous assurer qu\'aucun participant individuel ne peut être identifié par les données publiées\n- Reconnaître la plateforme HealthBank comme source de données\n- Soumettre les publications pour examen avant soumission si requis par votre accord de recherche\n\n7. SIGNALEMENT DE VIOLATION\n\nVous êtes légalement tenu de signaler immédiatement toute violation de données soupçonnée ou réelle, y compris :\n- Accès non autorisé aux données des participants\n- Divulgation accidentelle d\'informations identifiables\n- Perte ou vol d\'appareils contenant des données de recherche\n- Toute activité suspecte sur la plateforme\n\nLes signalements doivent être faits au responsable de la protection de la vie privée de HealthBank dans les 24 heures suivant la découverte.\n\n8. DURÉE DES OBLIGATIONS\n\nVos obligations de confidentialité en vertu de cet accord se poursuivent indéfiniment, même après :\n- La conclusion de votre projet de recherche\n- La résiliation de votre accès à la plateforme\n- La fin de votre emploi ou de votre affiliation avec votre institution\n\n9. RESTITUTION ET DESTRUCTION DES DONNÉES\n\nÀ la fin de votre recherche ou de la résiliation de votre accès, vous acceptez de :\n- Supprimer toutes les données de recherche stockées localement et dérivées de HealthBank\n- Certifier par écrit que toutes les données ont été détruites\n- Retourner tout matériel physique contenant des informations sur les participants\n\nEn cochant la case d\'accord ci-dessous, vous confirmez que vous avez lu, compris et acceptez tous les termes de cet accord de confidentialité.';

  @override
  String get consentElectronicSignatureNotice =>
      'En tapant votre nom dans le champ de signature et en cochant la case d\'acceptation, vous reconnaissez que votre signature électronique a la même valeur juridique qu\'une signature manuscrite en vertu de la Loi uniforme sur le commerce électronique (LUCE).';

  @override
  String get consentErrorGeneric =>
      'Échec de la soumission du consentement. Veuillez réessayer.';

  @override
  String get consentHcpTitle =>
      'Accord de confidentialité du professionnel de la santé';

  @override
  String get consentPageSubtitle =>
      'Veuillez consulter et accepter le formulaire de consentement pour continuer.';

  @override
  String get consentPageTitle => 'Formulaire de consentement';

  @override
  String get consentParticipantTitle => 'Consentement éclairé du participant';

  @override
  String get consentRecordDocumentLanguage => 'Langue du document';

  @override
  String get consentRecordIpAddress => 'Adresse IP';

  @override
  String get consentRecordSignatureName => 'Signature';

  @override
  String get consentRecordSignedAt => 'Signé le';

  @override
  String get consentRecordTitle => 'Détails du dossier de consentement';

  @override
  String get consentRecordUserAgent => 'Agent utilisateur';

  @override
  String get consentResearcherTitle => 'Accord de confidentialité du chercheur';

  @override
  String get consentRestoreHcpAccess => 'Rétablir l\'accès IPS';

  @override
  String get consentRestoreSuccess => 'Accès IPS rétabli';

  @override
  String consentRevokeConfirmBody(String hcpName) {
    return 'Cela empêchera $hcpName de consulter vos données de santé. Vous pouvez rétablir l\'accès ultérieurement.';
  }

  @override
  String get consentRevokeConfirmTitle => 'Révoquer l\'accès IPS ?';

  @override
  String get consentRevokeError =>
      'Échec de la mise à jour du consentement. Veuillez réessayer.';

  @override
  String get consentRevokeHcpAccess => 'Révoquer l\'accès IPS';

  @override
  String get consentRevokeSuccess => 'Accès IPS révoqué';

  @override
  String get consentSignatureDisclaimer =>
      'En tapant votre nom légal complet dans le champ de signature, vous confirmez que cela constitue votre signature électronique et a la même force juridique qu\'une signature manuscrite en vertu de la Loi uniforme sur le commerce électronique (LUCE) et de la législation provinciale canadienne applicable. Cette signature électronique est juridiquement contraignante et exécutoire en vertu de la Loi sur la protection des renseignements personnels et les documents électroniques (LPRPDE).';

  @override
  String get consentSignatureHint => 'Tapez votre nom légal complet';

  @override
  String get consentSignatureLabel => 'Signature électronique';

  @override
  String get consentStatusNotSigned => 'Consentement non signé';

  @override
  String get consentStatusSigned => 'Consentement signé';

  @override
  String consentStatusSignedAt(String date) {
    return 'Signé le : $date';
  }

  @override
  String consentStatusVersion(String version) {
    return 'Version : $version';
  }

  @override
  String get consentSubmitButton => 'J\'accepte et je soumets';

  @override
  String get consentViewRecord => 'Voir le dossier de consentement';

  @override
  String get participantAvailableSurveys => 'Sondages disponibles';

  @override
  String get participantCategoryLabel => 'Catégorie';

  @override
  String get participantChartDistribution => 'Distribution';

  @override
  String get participantChartError =>
      'Impossible de charger les données graphiques.';

  @override
  String get participantChartLoading => 'Chargement des graphiques...';

  @override
  String get participantChartMean => 'Moyenne';

  @override
  String get participantChartMedian => 'Médiane';

  @override
  String get participantChartNo => 'Non';

  @override
  String get participantChartNoData => 'Aucune donnée graphique disponible.';

  @override
  String get participantChartSuppressed =>
      'Données agrégées masquées pour la confidentialité (moins de 5 répondants).';

  @override
  String get participantChartToggle => 'Afficher les graphiques';

  @override
  String get participantChartYes => 'Oui';

  @override
  String get participantChartYourAnswer => 'Votre réponse';

  @override
  String get participantChartYourValue => 'Votre valeur';

  @override
  String get participantClickToView => 'Cliquez pour consulter';

  @override
  String get participantCollapseSurvey => 'Masquer les détails';

  @override
  String get participantCompareAggregate => 'Agrégat';

  @override
  String get participantCompareError =>
      'Impossible de charger les données de comparaison.';

  @override
  String get participantCompareLoading => 'Chargement de la comparaison...';

  @override
  String get participantCompareMostCommon => 'Le plus fréquent';

  @override
  String get participantCompareNoData =>
      'Aucune donnée de comparaison disponible.';

  @override
  String get participantCompareToggle => 'Comparer aux agrégats';

  @override
  String participantCompletedOn(Object date) {
    return 'Terminée le $date';
  }

  @override
  String get participantCompletedSurveys => 'Sondages terminés';

  @override
  String get participantCompletedThisWeek => 'Terminées cette semaine';

  @override
  String get participantContinueSurvey => 'Continuer le sondage';

  @override
  String get participantDashboardDescription =>
      'Consultez vos graphiques et diagrammes.';

  @override
  String get participantDoTask => 'Effectuer la tâche';

  @override
  String get participantDownloadResults => 'Télécharger les résultats';

  @override
  String participantDueOn(String date) {
    return 'Échéance le $date';
  }

  @override
  String get participantDueToday => 'Échéance aujourd\'hui';

  @override
  String participantDueTodayAt(String time) {
    return 'Échéance aujourd\'hui à $time';
  }

  @override
  String get participantExpandSurvey => 'Afficher les détails';

  @override
  String get participantGraphPlaceholder => 'Espace réservé pour graphique';

  @override
  String get participantGraphTitle1 => 'Titre du graphique 1';

  @override
  String get participantGraphTitle2 => 'Titre du graphique 2';

  @override
  String get participantLinkedHcps => 'Professionnels de santé liés';

  @override
  String get participantLoadingResults => 'Chargement de vos données...';

  @override
  String get participantMyResults => 'Mes résultats';

  @override
  String get participantMySurveys => 'Mes sondages';

  @override
  String get participantMyTasks => 'Mes tâches';

  @override
  String participantNewMessages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Vous avez $count nouveaux messages.\nCliquez ici pour les consulter.',
      one: 'Vous avez 1 nouveau message.\nCliquez ici pour le consulter.',
    );
    return '$_temp0';
  }

  @override
  String get participantNoDueDate => 'Aucune échéance';

  @override
  String get participantNoResults =>
      'Vous n\'avez encore complété aucun sondage.';

  @override
  String get participantNoResultsYet =>
      'Aucun résultat disponible pour le moment';

  @override
  String get participantNoSurveys =>
      'Aucun sondage ne vous a été assigné pour l\'instant.';

  @override
  String get participantNoSurveysSubtitle =>
      'Consultez vos sondages assignés et reprenez ici vos brouillons enregistrés.';

  @override
  String get participantNoTasksDueToday => 'Aucune tâche à rendre aujourd’hui';

  @override
  String participantNotificationMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Vous avez $count nouveaux messages.\nCliquez ici pour les consulter.',
      one: 'Vous avez 1 nouveau message.\nCliquez ici pour le consulter.',
    );
    return '$_temp0';
  }

  @override
  String participantOverdueSince(String date) {
    return 'En retard depuis le $date';
  }

  @override
  String participantOverdueTasksSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tâches sont en retard',
      one: '1 tâche est en retard',
    );
    return '$_temp0';
  }

  @override
  String get participantPlaceholder => '(Espace réservé)';

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
  String get participantQuickInsightsCaughtUpBadge => 'Vous êtes à jour';

  @override
  String get participantQuickInsightsCaughtUpMessage =>
      'Vous êtes à jour. Aucun sondage n’est en attente pour le moment.';

  @override
  String participantQuickInsightsCompletedOn(String date) {
    return 'Terminé le $date';
  }

  @override
  String get participantQuickInsightsMostRecentTitle =>
      'Sondage le plus récemment terminé';

  @override
  String get participantQuickInsightsNoCompletedYet =>
      'Aucun sondage terminé pour le moment. Une fois que vous en aurez terminé un, il apparaîtra ici.';

  @override
  String get participantQuickInsightsTitle => 'Aperçus rapides';

  @override
  String get participantQuickInsightsViewInResults => 'Voir dans les résultats';

  @override
  String participantRemainingTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tâches restantes',
      one: '1 tâche restante',
    );
    return '$_temp0';
  }

  @override
  String participantRemainingTasksForToday(int count) {
    return 'Tâches restantes pour aujourd\'hui : $count';
  }

  @override
  String participantRepeatsEvery(int days) {
    return 'Se répète tous les $days jours';
  }

  @override
  String get participantResponseLabel => 'Votre réponse';

  @override
  String get participantResultsError =>
      'Impossible de charger vos données. Veuillez réessayer.';

  @override
  String get participantResultsTitle => 'Mes données';

  @override
  String get participantResumeSurvey => 'Reprendre le sondage';

  @override
  String get participantRetry => 'Réessayer';

  @override
  String get participantStartSurvey => 'Commencer le sondage';

  @override
  String get participantSurveyCompleted => 'Complété';

  @override
  String participantSurveyDueDate(String date) {
    return 'Échéance: $date';
  }

  @override
  String get participantSurveyLoadError =>
      'Impossible de charger les sondages. Veuillez réessayer.';

  @override
  String get participantSurveyStatusCompleted => 'Complété';

  @override
  String get participantSurveyStatusExpired => 'Expiré';

  @override
  String get participantSurveyStatusIncomplete => 'Incomplet';

  @override
  String get participantSurveyStatusPending => 'En attente';

  @override
  String get participantTaskProgress => 'Progression des tâches';

  @override
  String get participantTaskProgressLabel => 'Votre progression des tâches :';

  @override
  String participantTasksCompleted(int completed, int total) {
    return '$completed sur $total tâches terminées';
  }

  @override
  String participantTasksCompletedLabel(int completed, int total) {
    return '$completed sur $total tâches terminées';
  }

  @override
  String participantTasksCompletedThisWeekSummary(int completed, int total) {
    return '$completed tâches actuelles sur $total terminées cette semaine';
  }

  @override
  String get participantUnknownSurvey => 'Sondage';

  @override
  String get participantViewAllTasks => 'Voir toutes les tâches';

  @override
  String get participantViewResults => 'Voir les résultats';

  @override
  String participantWelcomeGreeting(String name) {
    return 'Bienvenue, $name. Comment allez-vous aujourd\'hui?';
  }

  @override
  String participantWelcomeMessage(String name) {
    return 'Bienvenue, $name. Comment allez-vous aujourd\'hui?';
  }

  @override
  String get participantYourTaskProgress => 'Votre progression des tâches :';

  @override
  String get todoAlertsTitle => 'Action requise';

  @override
  String get todoCompletedSummaryTitle => 'Votre progrès';

  @override
  String get todoConsentRequired =>
      'Votre consentement doit être renouvelé. Veuillez le réviser et le signer.';

  @override
  String get todoDueSoonLabel => 'Bientôt dû';

  @override
  String get todoHcpAccept => 'Accepter';

  @override
  String get todoHcpDecline => 'Refuser';

  @override
  String get todoHcpLinkAccepted => 'Connexion acceptée';

  @override
  String get todoHcpLinkDeclined => 'Connexion refusée';

  @override
  String get todoHcpLinkError => 'Échec de la réponse. Veuillez réessayer.';

  @override
  String todoHcpLinkRequest(String hcpName) {
    return '$hcpName a demandé à suivre vos données de santé.';
  }

  @override
  String get todoNoTasks => 'Vous n\'avez aucune tâche en attente.';

  @override
  String get todoOverdueLabel => 'En retard';

  @override
  String get todoPageTitle => 'Mes tâches';

  @override
  String get todoPendingSurveysTitle => 'Sondages en attente';

  @override
  String get todoProfileIncomplete =>
      'Votre profil est incomplet. Veuillez ajouter votre nom.';

  @override
  String get todoRefreshing => 'Actualisation...';

  @override
  String get todoStartSurvey => 'Commencer le sondage';

  @override
  String get todoViewResults => 'Voir les résultats';

  @override
  String get healthCheckInTaskAction => 'Commencer le bilan';

  @override
  String get healthCheckInTaskCompletedToday => 'Complété aujourd\'hui';

  @override
  String get healthCheckInTaskDueText => 'À faire aujourd\'hui';

  @override
  String healthCheckInTaskProgress(int completed, int total) {
    return '$completed/$total questions répondues';
  }

  @override
  String get healthCheckInTaskRepeat => 'Quotidien';

  @override
  String get healthCheckInTaskTitle => 'Bilan de santé quotidien';

  @override
  String get healthTrackingAggregateUnavailable =>
      'Comparaison de population non disponible (données insuffisantes).';

  @override
  String get healthTrackingAllCategories => 'Toutes les catégories';

  @override
  String get healthTrackingAverageLabel => 'Moy';

  @override
  String get healthTrackingAverageTitle => 'Valeur moyenne dans le temps';

  @override
  String get healthTrackingAvgValue => 'Valeur moy.';

  @override
  String get healthTrackingBaselineBanner =>
      'Enregistrez votre point de départ — remplissez les valeurs d\'aujourd\'hui comme référence de santé.';

  @override
  String get healthTrackingCategory => 'Catégorie';

  @override
  String get healthTrackingChartBar => 'Graphique en barres';

  @override
  String healthTrackingChartEntries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entrées',
      one: '$count entrée',
    );
    return '$_temp0';
  }

  @override
  String get healthTrackingChartError =>
      'Impossible de charger les données du graphique.';

  @override
  String get healthTrackingChartLine => 'Graphique en courbes';

  @override
  String get healthTrackingChartPie => 'Graphique circulaire';

  @override
  String get healthTrackingCharts => 'Graphiques';

  @override
  String get healthTrackingChartTypeLabel => 'Type de graphique';

  @override
  String get healthTrackingChartYesNoHint => 'Oui = 1 / Non = 0';

  @override
  String get healthTrackingClearAllMetrics => 'Tout effacer';

  @override
  String get healthTrackingClearSelection => 'Effacer';

  @override
  String get healthTrackingCollapseCategory => 'Réduire la catégorie';

  @override
  String get healthTrackingCompareToAggregate => 'Comparer à l\'agrégat';

  @override
  String healthTrackingDraftHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count réponses remplies',
      one: '$count réponse remplie',
    );
    return '$_temp0';
  }

  @override
  String get healthTrackingEnterText => 'Entrez votre réponse';

  @override
  String get healthTrackingEnterValue => 'Entrez une valeur';

  @override
  String get healthTrackingExpandCategory => 'Développer la catégorie';

  @override
  String healthTrackingExportError(String error) {
    return 'Échec de l\'exportation : $error';
  }

  @override
  String get healthTrackingExportFiltered => 'Exporter les données filtrées';

  @override
  String get healthTrackingExporting => 'Exportation…';

  @override
  String get healthTrackingExportOwnData => 'Exporter mes données (CSV)';

  @override
  String get healthTrackingFilters => 'Filtres';

  @override
  String get healthTrackingGranularityDaily => 'Quotidien';

  @override
  String get healthTrackingGranularityLabel => 'Granularité';

  @override
  String get healthTrackingGranularityMonthly => 'Mensuel';

  @override
  String get healthTrackingGranularityWeekly => 'Hebdomadaire';

  @override
  String get healthTrackingHideFilters => 'Masquer les filtres';

  @override
  String get healthTrackingHistory => 'Historique';

  @override
  String get healthTrackingHistoryAll => 'Toutes les entrées';

  @override
  String get healthTrackingHistoryByCategory => 'Par catégorie';

  @override
  String get healthTrackingHistoryByMetric => 'Par métrique';

  @override
  String get healthTrackingHistoryDateFrom => 'Du';

  @override
  String get healthTrackingHistoryDateTo => 'Au';

  @override
  String get healthTrackingHistoryModeLabel =>
      'Mode d\'affichage de l\'historique';

  @override
  String get healthTrackingHistoryNoEntries =>
      'Aucune entrée trouvée pour la période sélectionnée.';

  @override
  String get healthTrackingHistoryTruncated =>
      'Affichage des 100 entrées les plus récentes.';

  @override
  String get healthTrackingLoadChart => 'Charger le graphique';

  @override
  String get healthTrackingLogToday => 'Journaliser aujourd\'hui';

  @override
  String get healthTrackingMetric => 'Métrique';

  @override
  String get healthTrackingMetricsError =>
      'Impossible de charger les métriques.';

  @override
  String get healthTrackingMonthlySection => 'BILAN MENSUEL';

  @override
  String get healthTrackingMultiChartTitle => 'Valeurs moyennes dans le temps';

  @override
  String get healthTrackingMyDataOnly => 'Mes données uniquement';

  @override
  String healthTrackingNMetricsSelected(int count) {
    return '$count sélectionnée(s)';
  }

  @override
  String get healthTrackingNoData => 'Aucune donnée pour l\'instant';

  @override
  String get healthTrackingNoMetrics => 'Aucune mesure disponible.';

  @override
  String get healthTrackingParticipants => 'Participants';

  @override
  String get healthTrackingRecentEntries => 'Entrées récentes';

  @override
  String get healthTrackingResearchCategories => 'Aperçu des catégories';

  @override
  String get healthTrackingResearchDeepDive =>
      'Analyse approfondie des métriques';

  @override
  String get healthTrackingResearchExport =>
      'Exporter le CSV du suivi de santé';

  @override
  String get healthTrackingResearchNoData =>
      'Aucune donnée disponible pour les filtres sélectionnés.';

  @override
  String get healthTrackingResearchTitle => 'Analyse du suivi de santé';

  @override
  String get healthTrackingResultsViewLabel =>
      'Afficher les résultats sous forme de tableau ou de graphique';

  @override
  String get healthTrackingSave => 'Enregistrer';

  @override
  String get healthTrackingSaveError =>
      'Échec de l\'enregistrement des entrées. Veuillez réessayer.';

  @override
  String get healthTrackingSaveSuccess => 'Entrées enregistrées avec succès.';

  @override
  String get healthTrackingSelectAll => 'Tout';

  @override
  String get healthTrackingSelectAllMetrics => 'Tout sélectionner';

  @override
  String get healthTrackingSelectCategoryAll =>
      'Tout sélectionner dans la catégorie';

  @override
  String get healthTrackingSelectMetric => 'Sélectionner une métrique';

  @override
  String get healthTrackingSelectMetrics => 'Sélectionner les métriques';

  @override
  String get healthTrackingSelectMetricsHint =>
      'Sélectionnez au moins une métrique pour charger le graphique';

  @override
  String get healthTrackingSelectMetricTooltip =>
      'Sélectionnez une métrique pour charger les données';

  @override
  String get healthTrackingShowFilters => 'Afficher les filtres';

  @override
  String get healthTrackingTitle => 'Suivi de santé';

  @override
  String get healthTrackingValueColumn => 'Valeur';

  @override
  String get healthTrackingViewChart => 'Vue graphique';

  @override
  String get healthTrackingViewModeLabel =>
      'Mode d\'affichage : enregistrer aujourd\'hui ou historique';

  @override
  String get healthTrackingViewTable => 'Vue tableau';

  @override
  String get healthTrackingWeeklySection => 'BILAN HEBDOMADAIRE';

  @override
  String healthTrackingXofYMetrics(int selected, int total) {
    return '$selected sur $total métriques';
  }

  @override
  String get surveyAssignAge3044 => '30–44 ans';

  @override
  String get surveyAssignAge4559 => '45–59 ans';

  @override
  String get surveyAssignAge60Plus => '60 ans et plus';

  @override
  String get surveyAssignAgeAny => 'Tous';

  @override
  String get surveyAssignAgeMaxLabel => 'Âge maximum';

  @override
  String get surveyAssignAgeMinLabel => 'Âge minimum';

  @override
  String get surveyAssignAgeRangeLabel => 'Tranche d\'âge';

  @override
  String get surveyAssignAgeUnder30 => 'Moins de 30 ans';

  @override
  String get surveyAssignAgeValidationInteger =>
      'L\'âge doit être un nombre entier.';

  @override
  String get surveyAssignAgeValidationNonNegative =>
      'L\'âge ne peut pas être négatif.';

  @override
  String get surveyAssignAgeValidationRange =>
      'L\'âge minimum doit être inférieur ou égal à l\'âge maximum.';

  @override
  String get surveyAssignAgeValidationRequired => 'L\'âge est requis.';

  @override
  String surveyAssignAgeValidationUpperBound(int max) {
    return 'L\'âge doit être inférieur ou égal à $max.';
  }

  @override
  String surveyAssignBulkResult(int totalTargeted, int assigned, int skipped) {
    return 'Ciblés : $totalTargeted • Assignés : $assigned • Ignorés : $skipped';
  }

  @override
  String get surveyAssignBulkSuccess => 'Sondage assigné avec succès';

  @override
  String get surveyAssignButton => 'Assigner maintenant';

  @override
  String get surveyAssignClearDueDate => 'Effacer la date limite';

  @override
  String get surveyAssignDueDate => 'Date limite (optionnel)';

  @override
  String get surveyAssignErrorAlready => 'Ce participant est déjà assigné.';

  @override
  String get surveyAssignErrorGeneral => 'Échec de l\'assignation du sondage.';

  @override
  String get surveyAssignErrorLoad => 'Impossible de charger les assignations.';

  @override
  String get surveyAssignErrorNotPublished =>
      'Seuls les sondages publiés peuvent être assignés.';

  @override
  String get surveyAssignGenderAll => 'Tous';

  @override
  String get surveyAssignGenderAny => 'Tous';

  @override
  String get surveyAssignGenderFemale => 'Femme';

  @override
  String get surveyAssignGenderLabel => 'Genre';

  @override
  String get surveyAssignGenderMale => 'Homme';

  @override
  String get surveyAssignGenderNonBinary => 'Non-binaire';

  @override
  String get surveyAssignGenderOther => 'Autre';

  @override
  String get surveyAssignGenderUnspecified => 'Non précisé';

  @override
  String get surveyAssignLoading => 'Chargement des assignations...';

  @override
  String get surveyAssignmentDelete => 'Retirer';

  @override
  String get surveyAssignmentDeleteConfirm => 'Retirer cette assignation?';

  @override
  String get surveyAssignmentDeleteError =>
      'Impossible de retirer l\'assignation.';

  @override
  String get surveyAssignmentDeleteSuccess => 'Assignation retirée.';

  @override
  String surveyAssignmentDueDate(String date) {
    return 'Échéance: $date';
  }

  @override
  String get surveyAssignments => 'Assignations actuelles';

  @override
  String get surveyAssignmentsEmpty =>
      'Aucun participant assigné pour l\'instant.';

  @override
  String get surveyAssignmentStatusCompleted => 'Complété';

  @override
  String get surveyAssignmentStatusExpired => 'Expiré';

  @override
  String get surveyAssignmentStatusPending => 'En attente';

  @override
  String get surveyAssignSuccess => 'Sondage assigné avec succès';

  @override
  String surveyAssignSummaryCompleted(int count) {
    return '$count complété(s)';
  }

  @override
  String surveyAssignSummaryExpired(int count) {
    return '$count expiré(s)';
  }

  @override
  String get surveyAssignSummaryNone => 'Aucune assignation pour le moment';

  @override
  String surveyAssignSummaryPending(int count) {
    return '$count en attente';
  }

  @override
  String surveyAssignSummaryTotal(int count) {
    return '$count assigné(s)';
  }

  @override
  String get surveyAssignTargetAll => 'Tous les participants';

  @override
  String get surveyAssignTargetDemographic => 'Par démographie';

  @override
  String get surveyAssignTargetLabel => 'Assigner À';

  @override
  String get surveyAssignTitle => 'Assigner le sondage';

  @override
  String get surveyBuilderAddNewQuestion => 'Ajouter une nouvelle question';

  @override
  String get surveyBuilderAddQuestions => 'Ajouter des questions';

  @override
  String get surveyBuilderAddQuestionsFirst =>
      'Veuillez ajouter au moins une question avant de publier';

  @override
  String get surveyBuilderAutoSaveFailed => 'Échec de l\'enregistrement';

  @override
  String get surveyBuilderAutoSaveRetry => 'Réessayer';

  @override
  String get surveyBuilderAutoSaveSaved => 'Enregistré';

  @override
  String get surveyBuilderAutoSaveSaving => 'Enregistrement...';

  @override
  String get surveyBuilderAutoSaveUnsaved => 'Non enregistré';

  @override
  String get surveyBuilderBack => 'Retour';

  @override
  String get surveyBuilderDescriptionHint =>
      'Décrivez l\'objectif de ce sondage';

  @override
  String get surveyBuilderDescriptionLabel => 'Description (facultatif)';

  @override
  String get surveyBuilderDragToReorder => 'Glisser pour réorganiser';

  @override
  String get surveyBuilderEditTitle => 'Modifier le sondage';

  @override
  String get surveyBuilderEmptyStateSubtitle =>
      'Ajoutez des questions pour créer votre sondage';

  @override
  String get surveyBuilderEmptyStateTitle => 'Aucune question pour le moment';

  @override
  String get surveyBuilderEndDate => 'Date de fin';

  @override
  String get surveyBuilderFailedToLoadQuestions =>
      'Échec du chargement des questions';

  @override
  String get surveyBuilderHideQuestionBank => 'Masquer la banque de questions';

  @override
  String surveyBuilderImportDialogAddSelected(int count) {
    return 'Ajouter la sélection ($count)';
  }

  @override
  String get surveyBuilderImportDialogAlreadyAdded => 'Déjà ajoutée';

  @override
  String get surveyBuilderImportDialogSearch => 'Rechercher des questions...';

  @override
  String get surveyBuilderImportDialogTitle =>
      'Importer de la banque de questions';

  @override
  String get surveyBuilderImportFromBank =>
      'Importer de la banque de questions';

  @override
  String get surveyBuilderNewTitle => 'Nouveau sondage';

  @override
  String get surveyBuilderNoQuestions =>
      'Aucune question ajoutée pour le moment';

  @override
  String get surveyBuilderNoQuestionsInBank =>
      'Aucune question dans la banque pour le moment';

  @override
  String get surveyBuilderPreview => 'Aperçu du sondage';

  @override
  String get surveyBuilderPublish => 'Publier';

  @override
  String get surveyBuilderPublishConfirmMessage =>
      'Une fois publié, le sondage sera disponible pour attribution aux participants. Voulez-vous vraiment publier?';

  @override
  String get surveyBuilderPublishedSuccess => 'Sondage publié avec succès';

  @override
  String surveyBuilderQuestionAdded(String title) {
    return 'Ajouté : $title';
  }

  @override
  String get surveyBuilderQuestionBank => 'Banque de questions';

  @override
  String get surveyBuilderQuestionCardCancelEdit => 'Annuler la modification';

  @override
  String get surveyBuilderQuestionCardConfirm => 'Confirmer la question';

  @override
  String get surveyBuilderQuestionCardCreateFailed =>
      'Échec de la création de la question';

  @override
  String get surveyBuilderQuestionCardEdit => 'Modifier la question';

  @override
  String get surveyBuilderQuestionCardPlaceholder => 'Tapez votre question ici';

  @override
  String get surveyBuilderQuestionCardSave => 'Enregistrer les modifications';

  @override
  String get surveyBuilderQuestionCardUpdateFailed =>
      'Échec de la mise à jour de la question';

  @override
  String surveyBuilderQuestionsCount(int count) {
    return 'Questions ($count)';
  }

  @override
  String surveyBuilderQuestionsImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions importées',
      one: '1 question importée',
    );
    return '$_temp0';
  }

  @override
  String get surveyBuilderRemoveQuestion => 'Supprimer la question';

  @override
  String get surveyBuilderSavedAsDraft => 'Sondage enregistré comme ébauche';

  @override
  String get surveyBuilderSaveDraft => 'Enregistrer l\'ébauche';

  @override
  String get surveyBuilderSelectDate => 'Sélectionner une date';

  @override
  String get surveyBuilderSelectFromPanel =>
      'Sélectionnez des questions dans la liste de questions disponible';

  @override
  String get surveyBuilderShowQuestionBank => 'Afficher la banque de questions';

  @override
  String get surveyBuilderStartDate => 'Date de début';

  @override
  String get surveyBuilderStartFromTemplate =>
      'Commencer à partir d\'un modèle';

  @override
  String get surveyBuilderTapToAdd =>
      'Appuyez sur « Ajouter des questions » pour sélectionner dans la banque de questions';

  @override
  String get surveyBuilderTapToAddQuestion =>
      'Appuyez sur une question pour l\'ajouter à votre sondage';

  @override
  String surveyBuilderTemplateLoaded(String title) {
    return 'Modèle chargé : $title';
  }

  @override
  String get surveyBuilderTitleHint => 'Entrez un titre descriptif';

  @override
  String get surveyBuilderTitleLabel => 'Titre du sondage *';

  @override
  String get surveyBuilderTitleRequired => 'Le titre est obligatoire';

  @override
  String get surveyBuilderUntitledSurvey => 'Sondage sans titre';

  @override
  String get surveyBuilderUpdatedSuccess => 'Sondage mis à jour avec succès';

  @override
  String get surveyBuilderUpdateSurvey => 'Mettre à jour le sondage';

  @override
  String get surveyCardAssign => 'Assigner';

  @override
  String get surveyCardClose => 'Fermer';

  @override
  String get surveyCardDelete => 'Supprimer';

  @override
  String get surveyCardEdit => 'Modifier';

  @override
  String get surveyCardPublish => 'Publier';

  @override
  String get surveyCardViewStatus => 'Voir l\'état du sondage';

  @override
  String get surveyCloseButton => 'Fermer le sondage';

  @override
  String get surveyClosedSuccess => 'Sondage fermé';

  @override
  String surveyCloseFailed(String error) {
    return 'Échec de la fermeture du sondage : $error';
  }

  @override
  String get surveyCloseMessage =>
      'La fermeture du sondage empêchera de nouvelles réponses. Voulez-vous vraiment le fermer?';

  @override
  String get surveyCloseTitle => 'Fermer le sondage';

  @override
  String surveyDeleteConfirm(String title) {
    return 'Voulez-vous vraiment supprimer « $title »?\n\nLes réponses existantes seront conservées à des fins de recherche. Cette action est irréversible.';
  }

  @override
  String get surveyDeletedSuccess => 'Sondage supprimé';

  @override
  String surveyDeleteFailed(String error) {
    return 'Échec de la suppression : $error';
  }

  @override
  String get surveyDeleteTitle => 'Supprimer le sondage';

  @override
  String get surveyListAllSurveys => 'Tous les sondages';

  @override
  String get surveyListClearAll => 'Tout effacer';

  @override
  String get surveyListClosed => 'Fermés';

  @override
  String get surveyListCreateSurvey => 'Créer un sondage';

  @override
  String surveyListDateFrom(String date) {
    return 'Du $date';
  }

  @override
  String surveyListDateUntil(String date) {
    return 'Jusqu\'au $date';
  }

  @override
  String get surveyListDrafts => 'Ébauches';

  @override
  String get surveyListFailedToLoad => 'Échec du chargement des sondages';

  @override
  String get surveyListFiltersLabel => 'Filtres : ';

  @override
  String get surveyListNewSurvey => 'Nouveau sondage';

  @override
  String get surveyListNoMatchFilters =>
      'Aucun sondage ne correspond à vos filtres';

  @override
  String get surveyListNoSurveys => 'Aucun sondage pour le moment';

  @override
  String get surveyListPublished => 'Publiés';

  @override
  String surveyListQuestionCount(int count) {
    return '$count questions';
  }

  @override
  String get surveyListSearchPlaceholder => 'Rechercher des sondages...';

  @override
  String get surveyListStatus => 'État';

  @override
  String surveyListStatusLabel(String status) {
    return 'État : $status';
  }

  @override
  String get surveyListTitle => 'Sondages';

  @override
  String get surveyNumberQuestionHint => 'Entrez un nombre';

  @override
  String get surveyOpenEndedHint => 'Entrez votre réponse';

  @override
  String get surveyPreviewAddQuestions =>
      'Ajouter des questions pour voir l\'apparence de votre sondage';

  @override
  String get surveyPreviewFooterNote =>
      'Ceci est un aperçu. Les réponses ne sont pas enregistrées.';

  @override
  String get surveyPreviewLabel => 'Aperçu du sondage';

  @override
  String get surveyPreviewNoQuestions => 'Aucune question dans ce sondage';

  @override
  String get surveyPreviewNote =>
      'Ceci est un aperçu. Les réponses ne sont pas enregistrées.';

  @override
  String surveyPreviewQuestionNumber(int number) {
    return 'Question $number';
  }

  @override
  String get surveyPreviewScaleHigh => 'Élevé';

  @override
  String get surveyPreviewScaleLow => 'Faible';

  @override
  String surveyPreviewUnsupportedType(String type) {
    return 'Type de question non pris en charge : $type';
  }

  @override
  String get surveyPublishButton => 'Publier';

  @override
  String get surveyPublishedSuccess => 'Sondage publié avec succès';

  @override
  String surveyPublishFailed(String error) {
    return 'Échec de la publication : $error';
  }

  @override
  String get surveyPublishMessage =>
      'Une fois publié, le sondage sera disponible pour attribution. Voulez-vous vraiment publier?';

  @override
  String get surveyPublishTitle => 'Publier le sondage';

  @override
  String get surveyStatusAssignedTotal => 'Total assigné';

  @override
  String get surveyStatusAssignmentAnalytics => 'Analytique des assignations';

  @override
  String get surveyStatusChartTitle => 'Répartition des états d\'assignation';

  @override
  String get surveyStatusClosed => 'Fermé';

  @override
  String get surveyStatusDraft => 'Ébauche';

  @override
  String get surveyStatusEndDate => 'Date de fin';

  @override
  String get surveyStatusNoDate => 'Non définie';

  @override
  String get surveyStatusPageTitle => 'État du sondage';

  @override
  String get surveyStatusPublished => 'Publié';

  @override
  String get surveyStatusStartDate => 'Date de début';

  @override
  String get surveySubmitErrorAlreadySubmitted =>
      'Vous avez déjà complété ce sondage.';

  @override
  String get surveySubmitErrorExpired =>
      'Ce sondage a expiré et ne peut plus être soumis.';

  @override
  String get surveySubmitErrorGeneral =>
      'Échec de la soumission du sondage. Veuillez réessayer.';

  @override
  String get surveySubmitErrorNotAssigned =>
      'Vous n\'êtes pas assigné à ce sondage.';

  @override
  String get surveySubmitErrorNotFound => 'Sondage introuvable.';

  @override
  String get surveySubmitErrorNotPublished =>
      'Ce sondage n\'accepte plus de réponses.';

  @override
  String get surveySubmitErrorServer =>
      'Une erreur serveur s\'est produite. Veuillez réessayer plus tard.';

  @override
  String get surveySubmitSuccess => 'Sondage soumis avec succès!';

  @override
  String get surveyTakingBackToSurveys => 'Retour aux sondages';

  @override
  String get surveyTakingCancel => 'Annuler';

  @override
  String get surveyTakingClosed => 'Ce sondage n\'accepte plus de réponses.';

  @override
  String get surveyTakingConfirmSubmitMessage =>
      'Vous ne pourrez plus modifier vos réponses après la soumission.';

  @override
  String get surveyTakingConfirmSubmitTitle => 'Soumettre le sondage ?';

  @override
  String get surveyTakingExpired => 'Ce sondage a expiré.';

  @override
  String get surveyTakingLoadingQuestions => 'Chargement des questions...';

  @override
  String get surveyTakingNetworkError =>
      'Erreur réseau. Vérifiez votre connexion et réessayez.';

  @override
  String surveyTakingProgress(int current, int total) {
    return '$current sur $total';
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
  String get surveyTakingRequired => '* Obligatoire';

  @override
  String get surveyTakingRequiredError => 'Cette question est obligatoire.';

  @override
  String get surveyTakingRetry => 'Réessayer';

  @override
  String get surveyTakingSubmit => 'Soumettre';

  @override
  String get surveyTakingSubmitting => 'Envoi en cours...';

  @override
  String get surveyTakingTitle => 'Répondre au sondage';

  @override
  String get surveyTakingValidationError =>
      'Veuillez répondre à toutes les questions obligatoires avant de soumettre.';

  @override
  String questionBankAddCount(int count) {
    return 'Ajouter ($count)';
  }

  @override
  String get questionBankAddQuestion => 'Ajouter une question';

  @override
  String get questionBankAllCategories => 'Toutes les catégories';

  @override
  String get questionBankAllTypes => 'Tous les types';

  @override
  String get questionBankCategoryDemographics => 'Données démographiques';

  @override
  String questionBankCategoryLabel(String category) {
    return 'Catégorie : $category';
  }

  @override
  String get questionBankCategoryLifestyle => 'Mode de vie';

  @override
  String get questionBankCategoryMentalHealth => 'Santé mentale';

  @override
  String get questionBankCategoryPhysicalHealth => 'Santé physique';

  @override
  String get questionBankCategorySymptoms => 'Symptômes';

  @override
  String get questionBankClearAll => 'Tout effacer';

  @override
  String get questionBankClearFilters => 'Effacer les filtres';

  @override
  String questionBankDeleteConfirm(String title) {
    return 'Voulez-vous vraiment supprimer « $title »?\n\nCette action est irréversible.';
  }

  @override
  String get questionBankDeleted => 'Question supprimée';

  @override
  String get questionBankDeleteTitle => 'Supprimer la question';

  @override
  String questionBankFailedToDelete(String error) {
    return 'Échec de la suppression : $error';
  }

  @override
  String questionBankFailedToDuplicate(String error) {
    return 'Échec de la duplication : $error';
  }

  @override
  String get questionBankFailedToLoad => 'Échec du chargement des questions';

  @override
  String get questionBankFilterCategory => 'Catégorie';

  @override
  String get questionBankFiltersLabel => 'Filtres : ';

  @override
  String get questionBankFilterType => 'Type';

  @override
  String get questionBankNewQuestion => 'Nouvelle question';

  @override
  String get questionBankNoMatchFilters =>
      'Aucune question ne correspond à vos filtres';

  @override
  String get questionBankNoQuestions => 'Aucune question pour le moment';

  @override
  String get questionBankQuestionDeleted => 'Question supprimée';

  @override
  String get questionBankQuestionDuplicated => 'Question dupliquée';

  @override
  String questionBankSearchLabel(String query) {
    return 'Recherche : « $query »';
  }

  @override
  String get questionBankSearchPlaceholder => 'Rechercher des questions...';

  @override
  String get questionBankSelectQuestions => 'Sélectionner des questions';

  @override
  String get questionBankTitle => 'Banque de questions';

  @override
  String questionBankTypeLabel(String type) {
    return 'Type : $type';
  }

  @override
  String get questionCardDelete => 'Supprimer';

  @override
  String get questionCardDuplicate => 'Dupliquer';

  @override
  String get questionCardEdit => 'Modifier';

  @override
  String get questionCardRequired => 'Obligatoire';

  @override
  String get questionCategoryGeneral => 'Général';

  @override
  String get questionCategoryLifestyle => 'Mode de vie';

  @override
  String get questionCategoryMentalHealth => 'Santé mentale';

  @override
  String get questionCategoryNutrition => 'Nutrition';

  @override
  String get questionCategoryOther => 'Autre';

  @override
  String get questionCategoryPhysicalHealth => 'Santé physique';

  @override
  String get questionFormAddOption => 'Ajouter une option';

  @override
  String get questionFormCategoryHint =>
      'p. ex., Santé, Mode de vie, Données démographiques';

  @override
  String get questionFormCategoryLabel => 'Catégorie (facultatif)';

  @override
  String get questionFormCreate => 'Créer';

  @override
  String get questionFormEditTitle => 'Modifier la question';

  @override
  String get questionFormMinOptionsRequired =>
      'Au moins 2 options sont requises';

  @override
  String get questionFormNewTitle => 'Nouvelle question';

  @override
  String questionFormOptionLabel(int number) {
    return 'Option $number';
  }

  @override
  String get questionFormOptionsLabel => 'Options *';

  @override
  String get questionFormProvideOptions =>
      'Veuillez fournir au moins 2 options';

  @override
  String get questionFormQuestionHint => 'Entrez le texte de la question';

  @override
  String get questionFormQuestionLabel => 'Question *';

  @override
  String get questionFormQuestionRequired =>
      'Le texte de la question est obligatoire';

  @override
  String get questionFormRemoveOption => 'Supprimer l\'option';

  @override
  String get questionFormRequiredLabel => 'Obligatoire';

  @override
  String get questionFormRequiredSubtitle =>
      'Les participants doivent répondre à cette question';

  @override
  String get questionFormScaleMax => 'Max';

  @override
  String get questionFormScaleMin => 'Min';

  @override
  String get questionFormScaleRange => 'Plage de l\'échelle';

  @override
  String get questionFormTitleHint => 'Titre descriptif court';

  @override
  String get questionFormTitleLabel => 'Titre (facultatif)';

  @override
  String get questionFormTypeLabel => 'Type de question *';

  @override
  String get questionNo => 'Non';

  @override
  String get questionTypeMultiChoice => 'Choix multiple';

  @override
  String get questionTypeNumber => 'Nombre';

  @override
  String get questionTypeOpenEnded => 'Réponse libre';

  @override
  String get questionTypeScale => 'Échelle';

  @override
  String get questionTypeSingleChoice => 'Choix unique';

  @override
  String get questionTypeText => 'Texte';

  @override
  String get questionTypeYesNo => 'Oui / Non';

  @override
  String get questionYes => 'Oui';

  @override
  String get templateBuilderAddQuestions => 'Ajouter des questions';

  @override
  String get templateBuilderAddQuestionsHint =>
      'Appuyez sur « Ajouter des questions » pour sélectionner dans la banque de questions';

  @override
  String get templateBuilderBack => 'Retour';

  @override
  String get templateBuilderCreatedSuccess => 'Modèle créé avec succès';

  @override
  String get templateBuilderDescriptionHint =>
      'Décrivez l\'objectif de ce modèle';

  @override
  String get templateBuilderDescriptionLabel => 'Description (facultatif)';

  @override
  String get templateBuilderEditTitle => 'Modifier le modèle';

  @override
  String get templateBuilderNewTitle => 'Nouveau modèle';

  @override
  String get templateBuilderNoQuestions =>
      'Aucune question ajoutée pour le moment';

  @override
  String get templateBuilderPublicLabel => 'Modèle public';

  @override
  String get templateBuilderPublicSubtitle =>
      'Permettre à d\'autres chercheurs d\'utiliser ce modèle';

  @override
  String get templateBuilderQuestionOptionalSubtitle =>
      'Cette question sera facultative dans les sondages créés à partir de ce modèle.';

  @override
  String get templateBuilderQuestionRequiredSubtitle =>
      'Cette question devra être répondue dans les sondages créés à partir de ce modèle.';

  @override
  String templateBuilderQuestionsCount(int count) {
    return 'Questions ($count)';
  }

  @override
  String get templateBuilderRemoveQuestion => 'Supprimer la question';

  @override
  String get templateBuilderSave => 'Enregistrer';

  @override
  String get templateBuilderTitleHint => 'Entrez un titre descriptif';

  @override
  String get templateBuilderTitleLabel => 'Titre du modèle *';

  @override
  String get templateBuilderTitleRequired => 'Le titre est obligatoire';

  @override
  String get templateBuilderUpdatedSuccess => 'Modèle mis à jour avec succès';

  @override
  String get templateCardCreateSurvey => 'Créer un sondage';

  @override
  String get templateCardDelete => 'Supprimer';

  @override
  String get templateCardDuplicate => 'Dupliquer';

  @override
  String get templateCardEdit => 'Modifier';

  @override
  String get templateCardPreview => 'Aperçu';

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
  String get templateListAllTemplates => 'Tous les modèles';

  @override
  String get templateListClearAll => 'Tout effacer';

  @override
  String templateListCreateSurveyFrom(String title) {
    return 'Créer un sondage à partir de : $title';
  }

  @override
  String get templateListCreateTemplate => 'Créer un modèle';

  @override
  String templateListDeleteConfirm(String title) {
    return 'Voulez-vous vraiment supprimer « $title »?\n\nCette action est irréversible.';
  }

  @override
  String get templateListDeleted => 'Modèle supprimé';

  @override
  String get templateListDeleteTitle => 'Supprimer le modèle';

  @override
  String get templateListDuplicated => 'Modèle dupliqué';

  @override
  String templateListFailedToDelete(String error) {
    return 'Échec de la suppression : $error';
  }

  @override
  String templateListFailedToDuplicate(String error) {
    return 'Échec de la duplication : $error';
  }

  @override
  String get templateListFailedToLoad => 'Échec du chargement des modèles';

  @override
  String templateListFailedToLoadTemplate(String error) {
    return 'Échec du chargement du modèle : $error';
  }

  @override
  String get templateListFiltersLabel => 'Filtres : ';

  @override
  String get templateListNewTemplate => 'Nouveau modèle';

  @override
  String get templateListNoMatchFilters =>
      'Aucun modèle ne correspond à vos filtres';

  @override
  String get templateListNoTemplates => 'Aucun modèle pour le moment';

  @override
  String get templateListPrivate => 'Privé';

  @override
  String get templateListPublic => 'Public';

  @override
  String get templateListSearchPlaceholder => 'Rechercher des modèles...';

  @override
  String get templateListSelectTemplate => 'Sélectionner un modèle';

  @override
  String get templateListTitle => 'Modèles';

  @override
  String get templateListVisibility => 'Visibilité';

  @override
  String templateListVisibilityLabel(String visibility) {
    return 'Visibilité : $visibility';
  }

  @override
  String get templatePreviewClose => 'Fermer';

  @override
  String get templatePreviewFooterNote =>
      'Ceci est un aperçu. Les réponses ne sont pas enregistrées.';

  @override
  String get templatePreviewNoQuestions => 'Aucune question dans ce modèle';

  @override
  String templatePreviewQuestionNumber(int number) {
    return 'Question $number';
  }

  @override
  String get templatePreviewScaleHigh => 'Élevé';

  @override
  String get templatePreviewScaleLow => 'Faible';

  @override
  String get templatePreviewSelectDate => 'Sélectionner une date';

  @override
  String get templatePreviewSelectTime => 'Sélectionner une heure';

  @override
  String get templatePreviewTitle => 'Aperçu';

  @override
  String templatePreviewUnsupportedType(String type) {
    return 'Type de question non pris en charge : $type';
  }

  @override
  String get researchAddFields => 'Ajouter des champs';

  @override
  String get researchAllCategories => 'Toutes les catégories';

  @override
  String get researchAllTypes => 'Tous les types';

  @override
  String get researchAvailableQuestions => 'Champs de données disponibles';

  @override
  String get researchCompletionRate => 'Taux de complétion';

  @override
  String get researchCrossAvgCompletion => 'Achèvement moy.';

  @override
  String get researchCrossDateFrom => 'Du';

  @override
  String get researchCrossDateTo => 'Au';

  @override
  String get researchCrossNoSurveysSelected =>
      'Utilisez + Ajouter des champs pour sélectionner des données, ou filtrez par sondage';

  @override
  String get researchCrossSelectSurveys =>
      'Sélectionner les sondages à extraire';

  @override
  String researchCrossSuppressedSurveys(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sondages',
      one: '1 sondage',
    );
    return '$_temp0 exclu(s) (moins de 5 répondants)';
  }

  @override
  String get researchCrossSurveyColumn => 'Sondage';

  @override
  String get researchCrossSurveysCount => 'Sondages';

  @override
  String get researchCrossTotalQuestions => 'Total questions';

  @override
  String get researchCrossTotalRespondents => 'Total répondants';

  @override
  String get researchDataBankAnalysis => 'Analyse';

  @override
  String get researchDataTitle => 'Données de recherche';

  @override
  String get researchDistribution => 'Distribution';

  @override
  String get researcherActiveSurveys => 'Sondages actifs';

  @override
  String get researcherAddParticipant => 'Ajouter un participant';

  @override
  String get researcherAssignSurvey => 'Attribuer un sondage';

  @override
  String get researcherClosedSurveys => 'Sondages fermés';

  @override
  String get researcherCreateSurvey => 'Créer un sondage';

  @override
  String get researcherDashboardChartTitle1 => 'Sondages récents';

  @override
  String get researcherDashboardChartTitle2 => 'Titre du diagramme 2';

  @override
  String get researcherDashboardChartTitle3 => 'Titre du diagramme 3';

  @override
  String get researcherDashboardChartTitle4 => 'Titre du diagramme 4';

  @override
  String get researcherDashboardGraphPlaceholder =>
      'Espace réservé pour graphique';

  @override
  String get researcherDashboardGraphTitle1 => 'Nombre de réponses par sondage';

  @override
  String get researcherDashboardGraphTitle2 =>
      'Pourcentages d\'état des sondages';

  @override
  String get researcherDashboardKpiActiveSurveys => 'Sondages actifs';

  @override
  String get researcherDashboardKpiAvgCompletion => 'Taux moyen de complétion';

  @override
  String get researcherDashboardKpiCompletedSurveys => 'Sondages terminés';

  @override
  String get researcherDashboardKpiTotalRespondents => 'Total des répondants';

  @override
  String get researcherDashboardPlaceholder =>
      'Tableau de bord du chercheur\n(Espace réservé)';

  @override
  String get researcherDashboardSectionTitle1 =>
      'Aperçu des statistiques des sondages';

  @override
  String get researcherDashboardSectionTitle2 => 'Titre de section 2';

  @override
  String get researcherDataAnalytics => 'Analyse des données';

  @override
  String get researcherDraftSurveys => 'Ébauches de sondages';

  @override
  String get researcherEditSurvey => 'Modifier le sondage';

  @override
  String get researcherEnrolledParticipants => 'Participants inscrits';

  @override
  String get researcherExportData => 'Exporter les données';

  @override
  String get researcherGenerateReport => 'Générer un rapport';

  @override
  String get researcherParticipantDetails => 'Détails du participant';

  @override
  String get researcherParticipantList => 'Liste des participants';

  @override
  String get researcherParticipants => 'Participants';

  @override
  String get researcherPendingInvitations => 'Invitations en attente';

  @override
  String get researcherQuickActions => 'Actions rapides';

  @override
  String get researcherRecentActivity => 'Activité récente';

  @override
  String get researcherSurveyDetails => 'Détails du sondage';

  @override
  String get researcherSurveyList => 'Liste des sondages';

  @override
  String get researcherSurveyResponses => 'Réponses au sondage';

  @override
  String get researcherWelcomeBack => 'Bon retour';

  @override
  String get researchExportCsv => 'Exporter en CSV';

  @override
  String get researchFilterCategory => 'Catégorie';

  @override
  String get researchFilterResponseType => 'Type de réponse';

  @override
  String get researchHistogram => 'Histogramme';

  @override
  String get researchMean => 'Moyenne';

  @override
  String get researchMedian => 'Médiane';

  @override
  String get researchModeCrossSurvey => 'Banque de données';

  @override
  String get researchModeHealthTracking => 'Suivi de santé';

  @override
  String get researchModeSingleSurvey => 'Par sondage';

  @override
  String get researchNo => 'Non';

  @override
  String get researchNoData =>
      'Aucune donnée de réponse disponible pour ce sondage';

  @override
  String get researchNoSurveys => 'Aucun sondage disponible';

  @override
  String get researchOpenEndedNote =>
      'Les réponses ouvertes ne sont pas affichées pour des raisons de confidentialité';

  @override
  String get researchOptionCounts => 'Décompte des options';

  @override
  String get researchQuestions => 'Questions';

  @override
  String get researchRange => 'Étendue';

  @override
  String get researchRespondents => 'Répondants';

  @override
  String researchResponses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count réponses',
      one: '1 réponse',
    );
    return '$_temp0';
  }

  @override
  String get researchSearchQuestions => 'Rechercher des champs...';

  @override
  String get researchSelectAll => 'Tout sélectionner';

  @override
  String researchSelectedFields(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count champs sélectionnés',
      one: '1 champ sélectionné',
    );
    return '$_temp0';
  }

  @override
  String get researchSelectSurvey => 'Sélectionner un sondage';

  @override
  String get researchStdDev => 'Écart-type';

  @override
  String researchSuppressed(int count) {
    return 'Réponses insuffisantes (minimum $count requis)';
  }

  @override
  String get researchTabAnalysis => 'Analyse';

  @override
  String get researchTabDataTable => 'Tableau de données';

  @override
  String get researchYes => 'Oui';

  @override
  String get hcpActiveClients => 'Clients actifs';

  @override
  String get hcpAddClient => 'Ajouter un client';

  @override
  String get hcpAllPatients => 'Tous les patients';

  @override
  String get hcpAssignSurvey => 'Attribuer un sondage';

  @override
  String get hcpClientDetails => 'Détails du client';

  @override
  String get hcpClientList => 'Liste des clients';

  @override
  String get hcpClientReports => 'Rapports des clients';

  @override
  String get hcpClients => 'Clients';

  @override
  String get hcpClientSurveys => 'Sondages du client';

  @override
  String get hcpDashboardLinkedPatients => 'Patients liés';

  @override
  String get hcpDashboardNoActivity => 'Aucune activité récente.';

  @override
  String get hcpDashboardPendingRequests => 'Demandes en attente';

  @override
  String get hcpDashboardTitle => 'Tableau de bord IPS';

  @override
  String hcpDashboardWelcome(String name) {
    return 'Bienvenue, $name';
  }

  @override
  String get hcpGenerateReport => 'Générer un rapport';

  @override
  String get hcpHealthSummary => 'Résumé de santé';

  @override
  String get hcpHtAggregateSeries => 'Moy. population';

  @override
  String get hcpHtAggregateUnavailable =>
      'Comparaison de population indisponible (données insuffisantes).';

  @override
  String get hcpHtChartTypeBar => 'Barres';

  @override
  String get hcpHtChartTypeLabel => 'Type de graphique';

  @override
  String get hcpHtChartTypeLine => 'Courbe';

  @override
  String get hcpHtChartTypePie => 'Secteurs';

  @override
  String get hcpHtClearAll => 'Tout effacer';

  @override
  String get hcpHtExportCsv => 'Exporter les données du patient (CSV)';

  @override
  String get hcpHtFilters => 'Filtres';

  @override
  String get hcpHtHideFilters => 'Masquer les filtres';

  @override
  String get hcpHtLoadCharts => 'Charger les graphiques';

  @override
  String get hcpHtLoadError =>
      'Échec du chargement des données de suivi de santé.';

  @override
  String hcpHtNMetricsSelected(int count) {
    return '$count sélectionnée(s)';
  }

  @override
  String get hcpHtNoEntries =>
      'Ce patient n\'a aucune entrée de suivi de santé pour les filtres sélectionnés.';

  @override
  String get hcpHtNoEntriesForMetric =>
      'Aucune entrée enregistrée pour cette métrique sur la période sélectionnée.';

  @override
  String get hcpHtNoMetrics => 'Aucune métrique de suivi de santé configurée.';

  @override
  String get hcpHtPatientSeries => 'Patient';

  @override
  String get hcpHtSelectAll => 'Tout sélectionner';

  @override
  String get hcpHtSelectMetrics => 'Sélectionner des métriques';

  @override
  String get hcpHtSelectMetricsHint =>
      'Sélectionnez au moins une métrique pour charger les graphiques.';

  @override
  String get hcpHtSelectPatientFirst =>
      'Sélectionnez un patient ci-dessus pour afficher ses données de suivi de santé.';

  @override
  String get hcpHtShowFilters => 'Afficher les filtres';

  @override
  String get hcpHtViewComparison => 'Comparaison';

  @override
  String get hcpHtViewMode => 'Mode d\'affichage';

  @override
  String get hcpHtViewModeLabel =>
      'Mode d\'affichage : patient uniquement ou comparaison avec la population';

  @override
  String get hcpHtViewPatient => 'Patient uniquement';

  @override
  String get hcpLinkEnterPatientEmail => 'Adresse courriel du patient';

  @override
  String get hcpLinkEnterPatientId => 'Entrer l\'identifiant du compte patient';

  @override
  String get hcpLinkErrorDuplicate =>
      'Une demande de lien existe déjà pour ce patient.';

  @override
  String get hcpLinkErrorGeneral =>
      'Échec de l\'envoi de la demande. Veuillez réessayer.';

  @override
  String get hcpLinkErrorNotFound => 'Compte patient introuvable.';

  @override
  String hcpLinkLinkedSince(String date) {
    return 'Lié depuis le $date';
  }

  @override
  String get hcpLinkMyPatients => 'Patients liés';

  @override
  String get hcpLinkNoPatients => 'Aucun patient lié pour l\'instant.';

  @override
  String get hcpLinkNoPending => 'Aucune demande en attente.';

  @override
  String get hcpLinkPageTitle => 'Mes patients';

  @override
  String get hcpLinkPatientEmailHint => 'ex. jean.smith@courriel.com';

  @override
  String hcpLinkPendingFrom(String date) {
    return 'Demandé le $date';
  }

  @override
  String get hcpLinkPendingRequests => 'Demandes en attente';

  @override
  String get hcpLinkRemove => 'Supprimer';

  @override
  String get hcpLinkRemoveConfirm => 'Supprimer ce lien patient?';

  @override
  String get hcpLinkRequestPatient => 'Demander un lien patient';

  @override
  String get hcpLinkRequestSent => 'Demande de lien envoyée';

  @override
  String get hcpPatientConsentRevoked => 'Consentement révoqué';

  @override
  String hcpPatientLinkedSince(String date) {
    return 'Lié depuis $date';
  }

  @override
  String get hcpPatientNoSurveys => 'Aucun sondage complété.';

  @override
  String get hcpPatientSurveysTitle => 'Sondages complétés';

  @override
  String get hcpPatientViewSurveys => 'Voir les sondages';

  @override
  String get hcpReportsError => 'Échec du chargement des données du rapport.';

  @override
  String get hcpReportsLoading => 'Chargement du rapport...';

  @override
  String get hcpReportsNoPatients => 'Aucun patient lié pour le rapport.';

  @override
  String get hcpReportsNoSelection =>
      'Sélectionnez un patient et un sondage pour voir le rapport.';

  @override
  String get hcpReportsNoSurveys =>
      'Ce patient n\'a pas de sondages complétés.';

  @override
  String get hcpReportsSelectPatient => 'Sélectionner un patient';

  @override
  String get hcpReportsSelectSurvey => 'Sélectionner un sondage';

  @override
  String get hcpReportsTabHealthTracking => 'Suivi de santé';

  @override
  String get hcpReportsTabSurveys => 'Sondages';

  @override
  String get hcpReportsTitle => 'Rapports patients';

  @override
  String get hcpSurveyChartAggregate => 'Moy. population';

  @override
  String get hcpSurveyChartAggUnavailable =>
      'Comparaison de population indisponible (données insuffisantes).';

  @override
  String get hcpSurveyChartComparison => 'Comparaison';

  @override
  String get hcpSurveyChartComparisonModeLabel =>
      'Mode de comparaison des graphiques';

  @override
  String get hcpSurveyChartNoNumeric =>
      'Aucune question numérique ou d\'échelle dans ce sondage à représenter.';

  @override
  String get hcpSurveyChartPatient => 'Patient';

  @override
  String get hcpSurveyChartPatientOnly => 'Patient uniquement';

  @override
  String hcpSurveyChartTitle(String surveyTitle) {
    return 'Résultats du sondage — $surveyTitle';
  }

  @override
  String get hcpSurveyHistory => 'Historique des sondages';

  @override
  String get hcpSurveyViewChart => 'Graphiques';

  @override
  String get hcpSurveyViewModeLabel =>
      'Mode d\'affichage : tableau des réponses ou graphiques';

  @override
  String get hcpSurveyViewTable => 'Réponses';

  @override
  String get hcpTodaySchedule => 'Horaire du jour';

  @override
  String get hcpUnknown => 'Professionnel de santé inconnu';

  @override
  String get hcpUpcomingAppointments => 'Rendez-vous à venir';

  @override
  String get hcpWelcomeBack => 'Bon retour';

  @override
  String get messagesComingSoon => 'Gestion des messages à venir...';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get messagingAcceptRequest => 'Accepter';

  @override
  String get messagingAddColleague => 'Ajouter';

  @override
  String get messagingAdminAccountIdHint => 'Entrez l\'ID numérique du compte';

  @override
  String get messagingAdminAccountIdLabel => 'ID du compte';

  @override
  String get messagingBrowseColleagues => 'Parcourir les collègues';

  @override
  String get messagingBrowseColleaguesSubtitle =>
      'Ajouter des chercheurs de votre institution';

  @override
  String get messagingColleagueAdded => 'Demande de contact envoyée';

  @override
  String get messagingColleagueAddError => 'Impossible d\'envoyer la demande';

  @override
  String get messagingColleagueRequestSent => 'Demande envoyée';

  @override
  String get messagingContacts => 'Contacts';

  @override
  String get messagingContactsTitle => 'Mes contacts';

  @override
  String get messagingConversationTitle => 'Conversation';

  @override
  String get messagingDeleteContact => 'Supprimer le contact';

  @override
  String get messagingDeleteContactConfirm =>
      'Supprimer ce contact ? Vous pourrez le rajouter plus tard.';

  @override
  String get messagingDeleteMessage => 'Supprimer le message';

  @override
  String get messagingDeleteMessageConfirm =>
      'Voulez-vous vraiment supprimer ce message ?';

  @override
  String get messagingEditContact => 'Modifier le contact';

  @override
  String get messagingEmailHint =>
      'Entrez une adresse courriel pour démarrer une conversation';

  @override
  String get messagingEmailLabel => 'Adresse courriel';

  @override
  String get messagingEmailNotFound => 'Aucun compte trouvé pour ce courriel';

  @override
  String get messagingEmailPermission =>
      'Vous n\'êtes pas autorisé à envoyer un message à cet utilisateur';

  @override
  String get messagingError => 'Échec du chargement des messages.';

  @override
  String get messagingFriendAccepted => 'Demande de contact acceptée';

  @override
  String get messagingFriendDeclined => 'Demande de contact refusée';

  @override
  String get messagingFriendEmailHint => 'contact@exemple.com';

  @override
  String get messagingFriendRequestEmail => 'Adresse courriel du contact';

  @override
  String get messagingFriendRequestError =>
      'Échec de l\'envoi de la demande. Veuillez réessayer.';

  @override
  String get messagingFriendRequestSend => 'Envoyer une demande de contact';

  @override
  String get messagingFriendRequestSent =>
      'Si cet utilisateur existe, une demande de contact sera envoyée.';

  @override
  String get messagingFriendRequestTitle => 'Ajouter un contact';

  @override
  String get messagingInboxTitle => 'Messages';

  @override
  String get messagingIncomingRequests => 'Demandes de contact';

  @override
  String get messagingJustNow => 'À l\'instant';

  @override
  String get messagingLastMessage => 'Dernier message';

  @override
  String get messagingLoading => 'Chargement des messages...';

  @override
  String get messagingMessagePlaceholder => 'Écrivez un message...';

  @override
  String get messagingNewConversationTitle => 'Nouvelle conversation';

  @override
  String get messagingNoColleaguesFound => 'Aucun chercheur trouvé';

  @override
  String get messagingNoContacts =>
      'Aucun contact. Ajoutez un contact pour commencer à envoyer des messages.';

  @override
  String get messagingNoConversations => 'Aucune conversation pour l\'instant.';

  @override
  String get messagingNoIncomingRequests =>
      'Aucune demande de contact en attente.';

  @override
  String get messagingNoMessages => 'Aucun message. Dites bonjour !';

  @override
  String get messagingNoRecipients => 'Aucun destinataire disponible.';

  @override
  String messagingOpenConversationWith(String name) {
    return 'Ouvrir la conversation avec $name';
  }

  @override
  String get messagingOrPickFromContacts => 'Ou choisissez parmi vos contacts';

  @override
  String get messagingOrPickFromPatients => 'Ou choisissez parmi vos patients';

  @override
  String get messagingRecipientFriend => 'Mes contacts';

  @override
  String get messagingRecipientHcp => 'Mon professionnel de santé';

  @override
  String get messagingRecipientPatient => 'Un patient';

  @override
  String get messagingRecipientResearcher => 'Chercheurs';

  @override
  String get messagingRejectRequest => 'Refuser';

  @override
  String get messagingSearchColleagues => 'Rechercher par nom...';

  @override
  String get messagingSearchMinChars =>
      'Entrez au moins 2 caractères pour rechercher.';

  @override
  String get messagingSearchResearchers => 'Rechercher des chercheurs...';

  @override
  String get messagingSelectConversation =>
      'Sélectionnez une conversation pour commencer à écrire';

  @override
  String get messagingSelectRecipient => 'Sélectionner un destinataire';

  @override
  String get messagingSend => 'Envoyer';

  @override
  String get messagingSendError => 'Échec de l\'envoi. Veuillez réessayer.';

  @override
  String get messagingSending => 'Envoi...';

  @override
  String get messagingStartConversation => 'Nouveau message';

  @override
  String messagingUnreadBadge(int count) {
    return '$count non lu(s)';
  }

  @override
  String get messagingYou => 'Vous';

  @override
  String get ticketPriorityHigh => 'Élevée';

  @override
  String get ticketPriorityLow => 'Faible';

  @override
  String get ticketPriorityMedium => 'Moyenne';

  @override
  String get ticketsColumnCreated => 'Créé';

  @override
  String get ticketsColumnId => 'ID';

  @override
  String get ticketsColumnPriority => 'Priorité';

  @override
  String get ticketsColumnStatus => 'État';

  @override
  String get ticketsColumnSubject => 'Sujet';

  @override
  String get ticketStatusClosed => 'Fermé';

  @override
  String get ticketStatusOpen => 'Ouvert';

  @override
  String get ticketStatusPending => 'En attente';

  @override
  String get ticketsTitle => 'Billets de soutien';

  @override
  String get adminAccountRequests => 'Demandes de compte';

  @override
  String get adminAccountRequestsApprove => 'Approuver';

  @override
  String get adminAccountRequestsApproveConfirm =>
      'Êtes-vous sûr de vouloir approuver cette demande de compte ? Un compte sera créé et l\'utilisateur recevra un courriel avec ses identifiants.';

  @override
  String get adminAccountRequestsApproved => 'Approuvées';

  @override
  String get adminAccountRequestsApproved_msg =>
      'Demande de compte approuvée avec succès';

  @override
  String get adminAccountRequestsDate => 'Soumis';

  @override
  String get adminAccountRequestsEmail => 'Courriel';

  @override
  String get adminAccountRequestsEmpty => 'Aucune demande de compte trouvée';

  @override
  String get adminAccountRequestsLoadError =>
      'Erreur lors du chargement des demandes de compte';

  @override
  String get adminAccountRequestsName => 'Nom';

  @override
  String get adminAccountRequestsPending => 'En attente';

  @override
  String get adminAccountRequestsReject => 'Refuser';

  @override
  String get adminAccountRequestsRejectConfirm =>
      'Êtes-vous sûr de vouloir refuser cette demande de compte ?';

  @override
  String get adminAccountRequestsRejected => 'Refusées';

  @override
  String get adminAccountRequestsRejected_msg => 'Demande de compte refusée';

  @override
  String get adminAccountRequestsRejectNotes => 'Notes de refus (facultatif)';

  @override
  String get adminAccountRequestsRole => 'Rôle';

  @override
  String get adminAccountStatus => 'État du compte';

  @override
  String get adminAddUser => 'Ajouter un utilisateur';

  @override
  String get adminAddUserDateOfBirth => 'Date de naissance (optionnel)';

  @override
  String get adminAddUserGender => 'Genre (optionnel)';

  @override
  String get adminAddUserParticipantOptionals =>
      'Détails du participant (optionnel)';

  @override
  String get adminAddUserSendSetupEmail =>
      'Envoyer un courriel de configuration du compte';

  @override
  String get adminAddUserSendSetupEmailHint =>
      'Un mot de passe temporaire sera généré et envoyé par courriel à l\'utilisateur';

  @override
  String get adminAssignTicket => 'Attribuer le billet';

  @override
  String get adminAuditLog => 'Journal d\'audit';

  @override
  String get adminBackToAdmin => 'Retour à l\'administration';

  @override
  String get adminBackupDatabase => 'Sauvegarder la base de données';

  @override
  String get adminClosedTickets => 'Billets fermés';

  @override
  String get adminCloseTicket => 'Fermer le billet';

  @override
  String get adminCompose => 'Rédiger';

  @override
  String get adminDashboardAccountRequests => 'Demandes de compte';

  @override
  String adminDashboardActiveUsersDetail(int count) {
    return '$count utilisateurs actifs';
  }

  @override
  String get adminDashboardAdminV2Preview => 'Aperçu administration v2';

  @override
  String get adminDashboardAuditLog => 'Journal d\'audit';

  @override
  String get adminDashboardBackupAgo => 'il y a';

  @override
  String get adminDashboardBackupNone => 'Aucune sauvegarde';

  @override
  String get adminDashboardDatabaseViewer => 'Visualiseur de base de données';

  @override
  String adminDashboardDraftCount(int count) {
    return '$count brouillons';
  }

  @override
  String get adminDashboardFailedToLoad =>
      'Échec du chargement du tableau de bord';

  @override
  String get adminDashboardKpiActiveSurveys => 'Sondages actifs';

  @override
  String get adminDashboardKpiDraftSurveys => 'Sondages brouillons';

  @override
  String get adminDashboardKpiLatestBackup => 'Dernière sauvegarde';

  @override
  String get adminDashboardKpiNew30d => 'Nouveaux (30 jours)';

  @override
  String get adminDashboardKpiPendingDeletions => 'Suppressions en attente';

  @override
  String get adminDashboardKpiPendingRequests => 'Demandes en attente';

  @override
  String get adminDashboardKpiResponses => 'Réponses';

  @override
  String get adminDashboardKpiTotalResponses => 'Réponses totales';

  @override
  String get adminDashboardKpiTotalUsers => 'Utilisateurs totaux';

  @override
  String get adminDashboardManageUsers => 'Gérer les utilisateurs';

  @override
  String adminDashboardNewIn30Days(int count) {
    return '$count nouveaux en 30 jours';
  }

  @override
  String get adminDashboardNoActivity => 'Aucune activité récente';

  @override
  String get adminDashboardNoPendingRequests => 'Aucune demande en attente';

  @override
  String get adminDashboardNoUsers => 'Aucun utilisateur pour l\'instant';

  @override
  String adminDashboardPendingAccountAlert(int count) {
    return '$count demandes de compte en attente d\'approbation';
  }

  @override
  String get adminDashboardPendingAccountRequests =>
      'Demandes de compte en attente';

  @override
  String adminDashboardPendingDeletionAlert(int count) {
    return '$count demandes de suppression en attente';
  }

  @override
  String get adminDashboardPendingDeletionRequests =>
      'Demandes de suppression en attente';

  @override
  String get adminDashboardQuickLinks => 'Liens rapides';

  @override
  String get adminDashboardRecentLogins => 'Connexions récentes';

  @override
  String adminDashboardRequestsPending(int count) {
    return '$count demandes en attente';
  }

  @override
  String get adminDashboardTitle => 'Tableau de bord administrateur';

  @override
  String adminDashboardTotalSurveysSubtitle(int total) {
    return '$total au total';
  }

  @override
  String adminDashboardTotalUsersSubtitle(int total) {
    return '$total au total (y compris inactifs)';
  }

  @override
  String get adminDashboardUiTestPage => 'Page de test de l\'interface';

  @override
  String get adminDashboardUserDistribution => 'Répartition des utilisateurs';

  @override
  String get adminDashboardUserDistributionByRole =>
      'Répartition des utilisateurs par rôle';

  @override
  String get adminDashboardUserRoles => 'Rôles des utilisateurs';

  @override
  String get adminDatabase => 'Base de données';

  @override
  String get adminDatabaseStatus => 'État de la base de données';

  @override
  String get adminDeleteUser => 'Supprimer l\'utilisateur';

  @override
  String adminDeletionConfirmContent(String name) {
    return 'Cette action supprimera définitivement le compte de $name. Les données de réponses aux sondages seront conservées de façon anonyme. Cette action est irréversible.';
  }

  @override
  String get adminDeletionConfirmTitle => 'Supprimer le compte définitivement';

  @override
  String adminDeletionError(String error) {
    return 'Échec de la suppression du compte : $error';
  }

  @override
  String get adminDeletionNoUsers => 'Aucun utilisateur trouvé.';

  @override
  String get adminDeletionRequestsApprove => 'Approuver la suppression';

  @override
  String get adminDeletionRequestsApproveConfirm =>
      'Cela supprimera définitivement le compte de l\'utilisateur. Ses données de sondage seront conservées anonymement. Cette action est irréversible.';

  @override
  String get adminDeletionRequestsApproved_msg =>
      'Compte supprimé définitivement.';

  @override
  String get adminDeletionRequestsEmpty =>
      'Aucune demande de suppression trouvée.';

  @override
  String get adminDeletionRequestsLoadError =>
      'Erreur lors du chargement des demandes de suppression';

  @override
  String adminDeletionRequestsPendingAlert(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count demande$_temp0 de suppression de compte en attente de révision';
  }

  @override
  String get adminDeletionRequestsReject => 'Rejeter';

  @override
  String get adminDeletionRequestsRejectConfirm =>
      'La demande de suppression sera rejetée et le compte sera réactivé.';

  @override
  String get adminDeletionRequestsRejected_msg =>
      'Demande de suppression rejetée — compte réactivé.';

  @override
  String get adminDeletionRequestsRejectNotes => 'Motif du rejet (optionnel)';

  @override
  String get adminDeletionRequestsRequested => 'Demandé le';

  @override
  String get adminDeletionRequestsTab => 'Demandes de suppression';

  @override
  String get adminDeletionSelfForbidden =>
      'Vous ne pouvez pas supprimer votre propre compte.';

  @override
  String get adminDeletionSubtitle =>
      'Supprimer définitivement des comptes utilisateurs. Les données de réponses aux sondages sont conservées de façon anonyme.';

  @override
  String get adminDeletionSuccess => 'Compte supprimé avec succès.';

  @override
  String get adminDeletionTitle => 'Suppression d\'utilisateurs';

  @override
  String get adminDisableAccount => 'Désactiver le compte';

  @override
  String get adminEditUser => 'Modifier l\'utilisateur';

  @override
  String get adminEmailLabel => 'Courriel';

  @override
  String get adminEnableAccount => 'Activer le compte';

  @override
  String get adminEndViewAsError => 'Échec de la fin de la visualisation';

  @override
  String get adminEnglish => 'EN';

  @override
  String get adminExportLogs => 'Exporter les journaux';

  @override
  String get adminFilterByAction => 'Filtrer par action';

  @override
  String get adminFilterByDate => 'Filtrer par date';

  @override
  String get adminFilterByRoleLabel => 'Filtrer par rôle';

  @override
  String get adminFilterByUser => 'Filtrer par utilisateur';

  @override
  String get adminFirstNameLabel => 'Prénom';

  @override
  String get adminFrench => 'FR';

  @override
  String get adminHealthTrackingActiveLabel => 'Actif';

  @override
  String get adminHealthTrackingAddCategory => 'Ajouter une catégorie';

  @override
  String get adminHealthTrackingAddMetric => 'Ajouter une métrique';

  @override
  String get adminHealthTrackingAddOption => 'Ajouter une option';

  @override
  String get adminHealthTrackingBaselineBadge => 'Référence';

  @override
  String get adminHealthTrackingBaselineLabel =>
      'Inclure dans le snapshot de référence';

  @override
  String get adminHealthTrackingCategoriesSection => 'Catégories et métriques';

  @override
  String adminHealthTrackingChoiceOptionLabel(int index) {
    return 'Option $index';
  }

  @override
  String get adminHealthTrackingChoiceOptionsLabel => 'Options de choix';

  @override
  String get adminHealthTrackingDeleteCategoryConfirm =>
      'Supprimer cette catégorie et toutes ses métriques ? Cette action est irréversible.';

  @override
  String adminHealthTrackingDeleteCategoryMessage(String name) {
    return 'Supprimer « $name » et toutes ses métriques ? Les données des participants sont conservées.';
  }

  @override
  String get adminHealthTrackingDeleteCategoryTitle => 'Supprimer la catégorie';

  @override
  String get adminHealthTrackingDeleteMetricConfirm =>
      'Supprimer cette métrique ? Cette action est irréversible.';

  @override
  String adminHealthTrackingDeleteMetricMessage(String name) {
    return 'Supprimer « $name » ? Les données des participants sont conservées.';
  }

  @override
  String get adminHealthTrackingDeleteMetricTitle => 'Supprimer la métrique';

  @override
  String get adminHealthTrackingDescriptionLabel => 'Description';

  @override
  String get adminHealthTrackingDragToReorder => 'Glisser pour réorganiser';

  @override
  String get adminHealthTrackingEditCategory => 'Modifier la catégorie';

  @override
  String get adminHealthTrackingEditMetric => 'Modifier la métrique';

  @override
  String get adminHealthTrackingFreqAny => 'Quelconque';

  @override
  String get adminHealthTrackingFreqDaily => 'Quotidien';

  @override
  String get adminHealthTrackingFreqMonthly => 'Mensuel';

  @override
  String get adminHealthTrackingFrequencyLabel => 'Fréquence';

  @override
  String get adminHealthTrackingFreqWeekly => 'Hebdomadaire';

  @override
  String adminHealthTrackingInactiveCategories(int count) {
    return 'Catégories inactives ($count)';
  }

  @override
  String get adminHealthTrackingInactiveLabel => 'Inactif';

  @override
  String adminHealthTrackingInactiveMetrics(int count) {
    return 'Questions inactives ($count)';
  }

  @override
  String get adminHealthTrackingNameLabel => 'Nom';

  @override
  String get adminHealthTrackingNoCategories => 'Aucune catégorie configurée.';

  @override
  String get adminHealthTrackingNoMetrics =>
      'Aucune métrique dans cette catégorie.';

  @override
  String adminHealthTrackingRemovedCategories(int count) {
    return 'Catégories supprimées ($count)';
  }

  @override
  String adminHealthTrackingRemovedMetrics(int count) {
    return 'Questions supprimées ($count)';
  }

  @override
  String get adminHealthTrackingRestore => 'Restaurer';

  @override
  String get adminHealthTrackingSaved => 'Enregistré avec succès.';

  @override
  String adminHealthTrackingSaveError(String error) {
    return 'Échec de l\'enregistrement : $error';
  }

  @override
  String get adminHealthTrackingScaleMaxLabel => 'Échelle max';

  @override
  String get adminHealthTrackingScaleMinLabel => 'Échelle min';

  @override
  String get adminHealthTrackingSubtitle =>
      'Configurez les catégories et métriques que les participants suivent quotidiennement.';

  @override
  String get adminHealthTrackingTitle => 'Paramètres de suivi de santé';

  @override
  String get adminHealthTrackingToggleCategoryActive =>
      'Activer/désactiver la catégorie';

  @override
  String get adminHealthTrackingTypeLabel => 'Type de métrique';

  @override
  String get adminHealthTrackingTypeNumber => 'Nombre';

  @override
  String get adminHealthTrackingTypeScale => 'Échelle';

  @override
  String get adminHealthTrackingTypeSingleChoice => 'Choix unique';

  @override
  String get adminHealthTrackingTypeText => 'Texte';

  @override
  String get adminHealthTrackingTypeYesno => 'Oui / Non';

  @override
  String get adminHealthTrackingUnitLabel => 'Unité (optionnel)';

  @override
  String get adminInbox => 'Boîte de réception';

  @override
  String get adminLanguage => 'Langue';

  @override
  String get adminLastNameLabel => 'Nom de famille';

  @override
  String adminLoggedInAs(String name) {
    return 'Connecté en tant que : $name';
  }

  @override
  String get adminLoggedInAsLabel => 'Connecté en tant que :';

  @override
  String get adminMessages => 'Messages';

  @override
  String get adminNavGroupAdmin => 'Administrateur';

  @override
  String get adminNavGroupHealthcareProvider => 'Fournisseur de soins de santé';

  @override
  String get adminNavGroupParticipant => 'Participant';

  @override
  String get adminNavGroupPublicAuth => 'Public / Auth';

  @override
  String get adminNavGroupResearcher => 'Chercheur';

  @override
  String get adminNavGroupShared => 'Partagé';

  @override
  String get adminNavHubSubtitle =>
      'Accédez à n\'importe quelle page de l\'application';

  @override
  String get adminNavHubTitle => 'Navigateur de pages';

  @override
  String get adminNewAccountRequestsTab => 'Nouvelles demandes de compte';

  @override
  String get adminOpenTickets => 'Billets ouverts';

  @override
  String get adminPasswordLabel => 'Mot de passe';

  @override
  String get adminResetPassword => 'Réinitialiser le mot de passe';

  @override
  String get adminRestoreDatabase => 'Restaurer la base de données';

  @override
  String get adminReturnedToDashboard =>
      'Retour au tableau de bord administrateur';

  @override
  String get adminReturning => 'Retour en cours...';

  @override
  String get adminRoleLabel => 'Rôle';

  @override
  String get adminSent => 'Envoyés';

  @override
  String get adminSettingsConsentRequiredDescription =>
      'Lorsqu\'activé, les utilisateurs doivent signer le formulaire de consentement avant d\'accéder à l\'application. Désactiver uniquement si le consentement n\'est pas requis dans votre juridiction.';

  @override
  String get adminSettingsConsentRequiredLabel =>
      'Exiger le consentement des utilisateurs';

  @override
  String adminSettingsDefaultBadge(String value) {
    return 'Défaut : $value';
  }

  @override
  String get adminSettingsKDescription =>
      'Nombre minimum de répondants distincts requis avant que les données soient exposées aux chercheurs. Défaut : 5.';

  @override
  String get adminSettingsKFieldLabel => 'Nombre minimum de répondants (K)';

  @override
  String get adminSettingsKHint => 'ex. 5';

  @override
  String get adminSettingsKLabel => 'Seuil d\'anonymat K';

  @override
  String get adminSettingsLockoutDescription =>
      'Durée pendant laquelle un compte reste verrouillé. Défaut : 30 minutes.';

  @override
  String get adminSettingsLockoutFieldLabel => 'Durée de verrouillage (min)';

  @override
  String get adminSettingsLockoutHint => 'ex. 30';

  @override
  String get adminSettingsLockoutLabel => 'Durée de verrouillage (minutes)';

  @override
  String get adminSettingsMaintenanceCompletionDescription =>
      'Heure estimée à laquelle le système sera de nouveau en ligne. Affichée dans la bannière de maintenance sur toutes les pages.';

  @override
  String get adminSettingsMaintenanceCompletionHint => 'Ex. : 17h00 HNE';

  @override
  String get adminSettingsMaintenanceCompletionLabel => 'Heure de fin prévue';

  @override
  String get adminSettingsMaintenanceDescription =>
      'Lorsqu\'activé, les utilisateurs non administrateurs ne peuvent pas se connecter. Une bannière s\'affiche sur la page de connexion.';

  @override
  String get adminSettingsMaintenanceLabel => 'Mode maintenance';

  @override
  String get adminSettingsMaintenanceMessageDescription =>
      'Message optionnel affiché dans la bannière de connexion. Indiquez l\'heure de retour prévue.';

  @override
  String get adminSettingsMaintenanceMessageHint =>
      'Ex. : Retour en ligne à 17h00 HNE';

  @override
  String get adminSettingsMaintenanceMessageLabel => 'Message de maintenance';

  @override
  String get adminSettingsMaxAttemptsDescription =>
      'Connexions échouées consécutives avant verrouillage temporaire du compte. 0 = illimité. Défaut : 10.';

  @override
  String get adminSettingsMaxAttemptsFieldLabel =>
      'Tentatives max. (0 = illimité)';

  @override
  String get adminSettingsMaxAttemptsHint => 'ex. 10';

  @override
  String get adminSettingsMaxAttemptsLabel =>
      'Tentatives de connexion échouées max.';

  @override
  String get adminSettingsRegistrationDescription =>
      'Lorsque désactivé, les nouvelles demandes de compte sont bloquées.';

  @override
  String get adminSettingsRegistrationLabel => 'Inscription ouverte';

  @override
  String get adminSettingsResetToDefault => 'Rétablir les valeurs par défaut';

  @override
  String get adminSettingsSaveButton => 'Enregistrer les modifications';

  @override
  String get adminSettingsSaveError =>
      'Échec de l\'enregistrement des paramètres.';

  @override
  String get adminSettingsSaveSuccess => 'Paramètres enregistrés avec succès.';

  @override
  String get adminSettingsSaving => 'Enregistrement…';

  @override
  String get adminSettingsSectionPrivacy => 'Confidentialité des données';

  @override
  String get adminSettingsSectionSecurity => 'Sécurité de connexion';

  @override
  String get adminSettingsSectionSystem => 'Système';

  @override
  String get adminSettingsSidebarLabel => 'Paramètres';

  @override
  String get adminSettingsTitle => 'Paramètres système';

  @override
  String get adminSettingsValidationNonNegative => 'Doit être 0 ou plus.';

  @override
  String get adminSettingsValidationPositive => 'Doit être un entier positif.';

  @override
  String get adminSpanish => 'ES';

  @override
  String get adminTicketDetails => 'Détails du billet';

  @override
  String get adminTickets => 'Billets';

  @override
  String get adminUiTestSectionBasics => 'Éléments de base';

  @override
  String get adminUiTestSectionButtons => 'Boutons';

  @override
  String get adminUiTestSectionDataDisplay => 'Affichage des données';

  @override
  String get adminUiTestSectionFeedback => 'Rétroaction';

  @override
  String get adminUiTestSectionForms => 'Formulaires et saisie';

  @override
  String get adminUiTestSectionMicroWidgets => 'Micro-composants';

  @override
  String get adminUserDetails => 'Détails de l\'utilisateur';

  @override
  String get adminUserList => 'Liste des utilisateurs';

  @override
  String get adminUserManagement => 'Gestion des utilisateurs';

  @override
  String get adminUserRole => 'Rôle de l\'utilisateur';

  @override
  String get adminV2LatestSignIns => 'Dernières connexions sur le système';

  @override
  String get adminV2NoUserData =>
      'Aucune donnée utilisateur disponible pour l\'instant.';

  @override
  String get adminV2OpenClassicAdmin => 'Ouvrir l\'administration classique';

  @override
  String get adminV2QuickAuditLog => 'Journal d\'audit';

  @override
  String get adminV2QuickDatabase => 'Base de données';

  @override
  String get adminV2QuickLinks => 'Liens rapides';

  @override
  String get adminV2QuickNavigator => 'Navigateur';

  @override
  String get adminV2QuickRequests => 'Demandes';

  @override
  String get adminV2QuickUiTest => 'Test de l\'interface';

  @override
  String get adminV2QuickUsers => 'Utilisateurs';

  @override
  String get adminV2RecentActivity => 'Activité récente';

  @override
  String get adminV2RoleDistributionTitle => 'Répartition des utilisateurs';

  @override
  String get adminV2RoleMixSubtitle =>
      'Répartition des rôles sur la plateforme';

  @override
  String get adminV2Subtitle =>
      'Un aperçu de tableau de bord plus épuré, fondé sur la nouvelle orientation de conception. L\'administration existante reste inchangée.';

  @override
  String get adminV2Title => 'Administration v2';

  @override
  String get adminViewAsLabel => 'Voir en tant que';

  @override
  String adminViewingAsRole(String role) {
    return 'Affiché en tant que $role';
  }

  @override
  String adminViewingAsUser(String name, String email) {
    return 'Affiché en tant que $name ($email)';
  }

  @override
  String get adminViewLogs => 'Consulter les journaux';

  @override
  String get adminWelcomeMessage =>
      'Bienvenue sur le tableau de bord administrateur. Sélectionnez une option dans la barre latérale.';

  @override
  String get auditLogAction => 'Action';

  @override
  String get auditLogActorId => 'ID de l\'auteur';

  @override
  String get auditLogActorType => 'Type d\'auteur';

  @override
  String get auditLogAllActions => 'Toutes les actions';

  @override
  String get auditLogAllMethods => 'Toutes les méthodes';

  @override
  String get auditLogAllResources => 'Toutes les ressources';

  @override
  String get auditLogAllStatuses => 'Tous les états';

  @override
  String get auditLogColumnAction => 'Action';

  @override
  String get auditLogColumnActor => 'Auteur';

  @override
  String get auditLogColumnMethod => 'Méthode';

  @override
  String get auditLogColumnPath => 'Chemin';

  @override
  String get auditLogColumnStatus => 'État';

  @override
  String get auditLogColumnTimestamp => 'Horodatage';

  @override
  String get auditLogDenied => 'Refusé';

  @override
  String get auditLogErrorCode => 'Code d\'erreur';

  @override
  String get auditLogEventId => 'ID de l\'événement';

  @override
  String get auditLogExportCsv => 'Exporter en CSV';

  @override
  String get auditLogFailedToLoad =>
      'Échec du chargement du journal de vérification';

  @override
  String get auditLogFailure => 'Échec';

  @override
  String get auditLogHttpMethod => 'Méthode HTTP';

  @override
  String get auditLogHttpStatus => 'État HTTP';

  @override
  String get auditLogIpAddress => 'Adresse IP';

  @override
  String get auditLogMetadata => 'Métadonnées';

  @override
  String get auditLogNextPage => 'Page suivante';

  @override
  String get auditLogNoEvents => 'Aucun événement de vérification trouvé';

  @override
  String auditLogPageOf(int current, int total) {
    return 'Page $current de $total';
  }

  @override
  String get auditLogPreviousPage => 'Page précédente';

  @override
  String get auditLogRequestId => 'ID de la requête';

  @override
  String get auditLogResourceId => 'ID de la ressource';

  @override
  String get auditLogResourceType => 'Type de ressource';

  @override
  String get auditLogSearchPlaceholder =>
      'Rechercher des chemins ou des actions...';

  @override
  String auditLogShowingEvents(int start, int end, int total) {
    return 'Affichage de $start à $end sur $total événements';
  }

  @override
  String get auditLogSuccess => 'Succès';

  @override
  String get auditLogTitle => 'Journal d\'audit';

  @override
  String get auditLogUserAgent => 'Agent utilisateur';

  @override
  String get dbPageTitle => 'Gestion de la base de données';

  @override
  String get dbTableDescAccount2FA =>
      'Paramètres d\'authentification à deux facteurs par compte';

  @override
  String get dbTableDescAccountData =>
      'Informations sur le compte utilisateur et détails du profil';

  @override
  String get dbTableDescAccountRequest =>
      'Demandes de création de compte en attente d\'approbation';

  @override
  String get dbTableDescAuditEvent =>
      'Journal d\'audit des événements pertinents pour la sécurité';

  @override
  String get dbTableDescAuth =>
      'Hachages de mots de passe pour l\'authentification des utilisateurs (colonnes sensibles masquées)';

  @override
  String get dbTableDescConsentRecord =>
      'Enregistrements des participants ayant signé le document de consentement';

  @override
  String get dbTableDescConversationParticipants =>
      'Associe les comptes aux conversations (plusieurs à plusieurs)';

  @override
  String get dbTableDescConversations =>
      'Conversations de messagerie entre utilisateurs';

  @override
  String get dbTableDescDataTypes =>
      'Catégories pour les données de santé collectées par les questions';

  @override
  String get dbTableDescFriendRequests =>
      'Demandes d\'amitié/connexion entre comptes de participants';

  @override
  String get dbTableDescHcpPatientLink =>
      'Liens entre les prestataires de soins de santé et leurs patients';

  @override
  String get dbTableDescMessages =>
      'Messages individuels envoyés dans les conversations';

  @override
  String get dbTableDescMfaChallenges =>
      'Défis de jeton MFA à usage unique (colonnes sensibles masquées)';

  @override
  String get dbTableDescPasswordResetTokens =>
      'Jetons de réinitialisation de mot de passe pour la récupération de compte';

  @override
  String get dbTableDescQuestionBank =>
      'Questions réutilisables pouvant être ajoutées aux enquêtes';

  @override
  String get dbTableDescQuestionCategories =>
      'Catégories pour organiser les questions d\'enquête';

  @override
  String get dbTableDescQuestionList =>
      'Lie les questions aux enquêtes (plusieurs à plusieurs)';

  @override
  String get dbTableDescQuestionOptions =>
      'Options pour les questions à choix unique et multiple';

  @override
  String get dbTableDescResponses =>
      'Réponses des participants aux questions d\'enquête';

  @override
  String get dbTableDescRoles =>
      'Rôles utilisateur définissant les autorisations d\'accès';

  @override
  String get dbTableDescSessions =>
      'Sessions de connexion utilisateur actives (colonnes sensibles masquées)';

  @override
  String get dbTableDescSurvey =>
      'Définitions d\'enquêtes créées par les chercheurs';

  @override
  String get dbTableDescSurveyAssignment =>
      'Suit quelles enquêtes sont assignées à quels participants';

  @override
  String get dbTableDescSurveyTemplate =>
      'Modèles d\'enquêtes réutilisables créés par les chercheurs';

  @override
  String get dbTableDescSystemSettings =>
      'Paramètres de configuration du système et préférences de l\'application';

  @override
  String get dbTableDescTemplateQuestions =>
      'Lie les questions aux modèles d\'enquête (plusieurs à plusieurs)';

  @override
  String get dbUtilitiesTitle => 'Utilitaires de base de données';

  @override
  String get dbViewerColumnHeader => 'Colonne';

  @override
  String dbViewerColumnsCount(int count) {
    return '$count colonnes';
  }

  @override
  String get dbViewerConstraintsHeader => 'Contraintes';

  @override
  String get dbViewerData => 'Données';

  @override
  String get dbViewerFailedToLoad =>
      'Échec du chargement des tables de la base de données';

  @override
  String dbViewerFailedToLoadData(String error) {
    return 'Échec du chargement des données de la table : $error';
  }

  @override
  String get dbViewerForeignKey => 'Clé étrangère';

  @override
  String get dbViewerNoData => 'Aucune donnée dans la table';

  @override
  String get dbViewerNotNull => 'Non nul';

  @override
  String get dbViewerNull => 'NUL';

  @override
  String get dbViewerNullable => 'Nullable';

  @override
  String dbViewerPageOf(int current, int total) {
    return 'Page $current de $total';
  }

  @override
  String get dbViewerPrimaryKey => 'Clé primaire';

  @override
  String get dbViewerReferenceHeader => 'Référence';

  @override
  String dbViewerRowsCount(int count) {
    return '$count lignes';
  }

  @override
  String dbViewerRowsTotal(int count) {
    return '$count lignes au total';
  }

  @override
  String get dbViewerSchema => 'Schéma';

  @override
  String get dbViewerSelectATable => 'Sélectionner une table';

  @override
  String get dbViewerSelectTable => 'Sélectionner une table';

  @override
  String dbViewerShowing(int start, int end, int total) {
    return 'Affichage de $start à $end sur $total';
  }

  @override
  String dbViewerTableData(String name) {
    return 'Données de $name';
  }

  @override
  String dbViewerTablesCount(int count) {
    return '$count tables dans la base de données';
  }

  @override
  String get dbViewerTitle => 'Visualiseur de base de données';

  @override
  String get dbViewerTypeHeader => 'Type';

  @override
  String get dbViewerViewModeLabel =>
      'Basculer entre la vue schéma et la vue données';

  @override
  String get backupCreatedError =>
      'La sauvegarde a échoué. Vérifiez les journaux du serveur.';

  @override
  String backupCreatedSuccess(String size) {
    return 'Sauvegarde créée ($size)';
  }

  @override
  String get backupCreateManual => 'Créer une sauvegarde maintenant';

  @override
  String get backupCreating => 'Création en cours…';

  @override
  String backupDeleteConfirmBody(String filename) {
    return 'Cela supprimera définitivement $filename. Cette action est irréversible.';
  }

  @override
  String get backupDeleteConfirmTitle => 'Supprimer la sauvegarde?';

  @override
  String get backupDeleteError =>
      'Impossible de supprimer la sauvegarde. Veuillez réessayer.';

  @override
  String get backupDeleteSuccess => 'Sauvegarde supprimée.';

  @override
  String get backupDeleteTooltip => 'Supprimer cette sauvegarde';

  @override
  String get backupDownloadError =>
      'Le téléchargement a échoué. Veuillez réessayer.';

  @override
  String get backupDownloadStarted => 'Téléchargement démarré.';

  @override
  String get backupDownloadTooltip => 'Télécharger le fichier de sauvegarde';

  @override
  String get backupLatest => 'Dernière sauvegarde';

  @override
  String get backupLoadError =>
      'Impossible de charger la liste des sauvegardes';

  @override
  String get backupNoneFound => 'Aucune sauvegarde trouvée';

  @override
  String get backupNoneFoundSubtitle =>
      'Aucun fichier de sauvegarde n\'existe encore. Créez une sauvegarde manuelle ou attendez l\'exécution de la sauvegarde planifiée.';

  @override
  String get backupNoRecent => 'Aucune sauvegarde — créez-en une maintenant.';

  @override
  String get backupPageSubtitle =>
      'Les sauvegardes automatiques s\'exécutent quotidiennement à 2 h, chaque dimanche et le 1er de chaque mois. Les sauvegardes manuelles conservent les 10 dernières exécutions.';

  @override
  String get backupPageTitle => 'Sauvegardes de la base de données';

  @override
  String get backupRestoreAction => 'Restaurer la base de données';

  @override
  String backupRestoreConfirmBody(String filename) {
    return 'Cela remplacera TOUTES les données actuelles par le contenu de $filename.\n\nUne sauvegarde préalable sera créée automatiquement avant le début de la restauration.\n\nCette action est irréversible.';
  }

  @override
  String get backupRestoreConfirmTitle => 'Restaurer la base de données?';

  @override
  String get backupRestoreError =>
      'La restauration a échoué. Veuillez réessayer ou contacter le support.';

  @override
  String get backupRestoreSelectHint => 'Choisir une sauvegarde à restaurer…';

  @override
  String get backupRestoreSelectLabel => 'Sélectionner une sauvegarde';

  @override
  String backupRestoreSuccess(String size, int migrations) {
    return 'Base de données restaurée. Sauvegarde préalable enregistrée ($size). $migrations migration(s) appliquée(s).';
  }

  @override
  String get backupRestoreTitle => 'Restaurer à partir d\'une sauvegarde';

  @override
  String get backupRestoreTooltip =>
      'Restaurer la base de données à partir de cette sauvegarde';

  @override
  String get backupRestoring => 'Restauration en cours…';

  @override
  String backupSavedTo(String path) {
    return 'Enregistré dans $path';
  }

  @override
  String get backupSectionCollapse => 'Masquer les sauvegardes';

  @override
  String get backupSectionExpand => 'Afficher les sauvegardes';

  @override
  String get backupTypeDaily => 'Quotidienne';

  @override
  String get backupTypeManual => 'Manuelle';

  @override
  String get backupTypeMonthly => 'Mensuelle';

  @override
  String get backupTypeWeekly => 'Hebdomadaire';

  @override
  String get backupViewAll => 'Voir toutes les sauvegardes';

  @override
  String get userManagementActivate => 'Activer';

  @override
  String get userManagementActivatedSuccess => 'Utilisateur activé';

  @override
  String get userManagementActiveOnly => 'Actifs seulement';

  @override
  String get userManagementAddNewUser => 'Ajouter un nouvel utilisateur';

  @override
  String get userManagementAddUser => 'Ajouter un utilisateur';

  @override
  String get userManagementAdminConsentExempt =>
      'Administrateur — Exempt de consentement';

  @override
  String get userManagementAll => 'Tout';

  @override
  String get userManagementAllRoles => 'Tous les rôles';

  @override
  String get userManagementCopy => 'Copier';

  @override
  String get userManagementCreatedSuccess => 'Utilisateur créé avec succès';

  @override
  String get userManagementDeactivate => 'Désactiver';

  @override
  String get userManagementDeactivatedSuccess => 'Utilisateur désactivé';

  @override
  String get userManagementDeleteUserTitle => 'Supprimer l\'utilisateur';

  @override
  String get userManagementDeleteUserTooltip => 'Supprimer l\'utilisateur';

  @override
  String get userManagementEditUser => 'Modifier l\'utilisateur';

  @override
  String get userManagementEditUserTitle => 'Modifier l\'utilisateur';

  @override
  String get userManagementEditUserTooltip => 'Modifier l\'utilisateur';

  @override
  String get userManagementFailedToImpersonate =>
      'Échec de la visualisation en tant qu\'utilisateur';

  @override
  String get userManagementFailedToLoad =>
      'Échec du chargement des utilisateurs';

  @override
  String get userManagementFilterByRole => 'Filtrer par rôle';

  @override
  String get userManagementFirstName => 'Prénom';

  @override
  String get userManagementGenerate => 'Générer';

  @override
  String get userManagementLastName => 'Nom de famille';

  @override
  String get userManagementNoUsers => 'Aucun utilisateur trouvé';

  @override
  String userManagementNowViewingAs(String name) {
    return 'Affichage en tant que $name';
  }

  @override
  String get userManagementPasswordCopied =>
      'Mot de passe copié dans le presse-papiers';

  @override
  String get userManagementResetPasswordTooltip =>
      'Réinitialiser le mot de passe';

  @override
  String get userManagementRole => 'Rôle';

  @override
  String get userManagementRoleLabel => 'Rôle';

  @override
  String get userManagementSearchByEmail => 'Rechercher par nom ou courriel...';

  @override
  String get userManagementSearchPlaceholder =>
      'Rechercher par nom ou courriel...';

  @override
  String get userManagementSearchShort => 'Rechercher...';

  @override
  String get userManagementTableActions => 'Actions';

  @override
  String get userManagementTableEmail => 'Courriel';

  @override
  String get userManagementTableLastLogin => 'Dernière connexion';

  @override
  String get userManagementTableName => 'Nom';

  @override
  String get userManagementTableRole => 'Rôle';

  @override
  String get userManagementTableStatus => 'État';

  @override
  String get userManagementTitle => 'Gestion des utilisateurs';

  @override
  String userManagementTotalUsers(int count) {
    return 'Total : $count utilisateurs';
  }

  @override
  String get userManagementUpdatedSuccess =>
      'Utilisateur mis à jour avec succès';

  @override
  String userManagementUserDeleted(String name) {
    return '$name supprimé';
  }

  @override
  String userManagementUsersShown(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utilisateurs affichés',
      one: '1 utilisateur affiché',
    );
    return '$_temp0';
  }

  @override
  String get userManagementViewAsUser => 'Voir en tant qu\'utilisateur';

  @override
  String get userRoleAdmin => 'Administrateur';

  @override
  String get userRoleHcp => 'Professionnel de la santé';

  @override
  String get userRoleHcpShort => 'PS';

  @override
  String get userRoleParticipant => 'Participant';

  @override
  String get userRoleResearcher => 'Chercheur';

  @override
  String get userRoleUnknown => 'Inconnu';

  @override
  String get settings2faDisabledSuccess => '2FA désactivée';

  @override
  String get settings2faListSubtitle =>
      'Configurer ou confirmer la 2FA pour votre compte';

  @override
  String get settingsAppearanceApplied => 'Appliqué';

  @override
  String get settingsAppearanceApply => 'Appliquer';

  @override
  String get settingsAppearanceReset => 'Réinitialiser';

  @override
  String get settingsAppearanceSectionTitle => 'Apparence';

  @override
  String get settingsAppearanceSubtitle =>
      'Choisissez un style visuel pour votre compte.';

  @override
  String get settingsAppearanceUpdated => 'Apparence mise à jour.';

  @override
  String get settingsChangePasswordSubtitle =>
      'Mettre à jour le mot de passe de votre compte';

  @override
  String get settingsDeleteAccountCancel => 'Annuler';

  @override
  String get settingsDeleteAccountConfirm => 'Soumettre la demande';

  @override
  String get settingsDeleteAccountDialogBody =>
      'Votre compte sera désactivé immédiatement et une demande de suppression sera envoyée à un administrateur pour examen. Vous serez déconnecté.';

  @override
  String get settingsDeleteAccountDialogTitle =>
      'Demander la suppression du compte ?';

  @override
  String get settingsDeleteAccountFailed =>
      'Échec de la soumission de la demande de suppression. Veuillez réessayer.';

  @override
  String get settingsDeleteAccountSubtitle =>
      'Demander la suppression permanente de votre compte';

  @override
  String get settingsDeleteAccountTitle => 'Supprimer le compte';

  @override
  String get settingsDisable2faDialogBody =>
      'Cela réduira la sécurité de votre compte. Vous pourrez la réactiver plus tard.';

  @override
  String get settingsDisable2faDialogCancel => 'Annuler';

  @override
  String get settingsDisable2faDialogConfirm => 'Désactiver';

  @override
  String get settingsDisable2faDialogTitle => 'Désactiver la 2FA ?';

  @override
  String get settingsDisable2faFailed =>
      'Échec de la désactivation de la 2FA. Veuillez réessayer.';

  @override
  String get settingsDisable2faSubtitle => 'Retirer la 2FA de votre compte';

  @override
  String get settingsDisable2faTitle => 'Désactiver la 2FA';

  @override
  String get settingsManageAccountSubtitle =>
      'Gérez les paramètres de votre compte.';

  @override
  String get settingsSecuritySectionTitle => 'Sécurité';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get uiClearAll => 'Tout effacer';

  @override
  String get uiClearFilters => 'Effacer les filtres';

  @override
  String get uiFiltersLabel => 'Filtres : ';

  @override
  String get uiNever => 'Jamais';

  @override
  String uiSearchLabel(String query) {
    return 'Recherche : « $query »';
  }

  @override
  String get uiTestControlActive => 'Actif';

  @override
  String get uiTestControlArrowTop => 'Flèche en haut';

  @override
  String get uiTestControlAspect => 'Ratio';

  @override
  String get uiTestControlAsset => 'Ressource';

  @override
  String get uiTestControlBackground => 'Arrière-plan';

  @override
  String get uiTestControlColor => 'Couleur';

  @override
  String get uiTestControlCreateEnabled => 'Création activée';

  @override
  String get uiTestControlDisabled => 'Désactivé';

  @override
  String get uiTestControlEnabled => 'Activé';

  @override
  String get uiTestControlFill => 'Remplissage';

  @override
  String get uiTestControlFit => 'Ajustement';

  @override
  String get uiTestControlHeight => 'Hauteur';

  @override
  String uiTestControlHeightPx(String value) {
    return 'Hauteur : $value px';
  }

  @override
  String get uiTestControlIcon => 'Icône';

  @override
  String get uiTestControlLabel => 'Étiquette';

  @override
  String get uiTestControlLegend => 'Légende';

  @override
  String get uiTestControlMessage => 'Message';

  @override
  String get uiTestControlNotification => 'Notification';

  @override
  String uiTestControlProgress(String value) {
    return 'Progression : $value %';
  }

  @override
  String get uiTestControlRadius => 'Rayon';

  @override
  String get uiTestControlRequired => 'Requis';

  @override
  String get uiTestControlSemantics => 'Sémantique';

  @override
  String get uiTestControlSize => 'Taille';

  @override
  String uiTestControlSpacing(String value) {
    return 'Espacement : $value';
  }

  @override
  String get uiTestControlStartExpanded => 'Démarrer développé';

  @override
  String get uiTestControlSubtitle => 'Sous-titre';

  @override
  String get uiTestControlTagline => 'Slogan';

  @override
  String get uiTestControlText => 'Texte';

  @override
  String uiTestControlThickness(String value) {
    return 'Épaisseur : $value';
  }

  @override
  String get uiTestControlTrack => 'Piste';

  @override
  String get uiTestControlTristate => 'Tristate';

  @override
  String get uiTestControlValues => 'Valeurs';

  @override
  String get uiTestControlVariant => 'Variante';

  @override
  String get uiTestControlWeight => 'Graisse';

  @override
  String get uiTestControlWidth => 'Largeur';

  @override
  String uiTestControlWidthPx(String value) {
    return 'Largeur : $value px';
  }

  @override
  String get uiTestDemoAboveDivider => 'Au-dessus du séparateur';

  @override
  String get uiTestDemoAdminPassword => 'Mot de passe administrateur';

  @override
  String get uiTestDemoAliceCarter => 'Alice Carter';

  @override
  String get uiTestDemoAppointmentTime => 'Heure du rendez-vous';

  @override
  String get uiTestDemoBadge => 'Badge';

  @override
  String get uiTestDemoBelowDivider => 'En dessous du séparateur';

  @override
  String get uiTestDemoCaution => 'Attention';

  @override
  String get uiTestDemoClickMe => 'Cliquez ici';

  @override
  String get uiTestDemoCodeCopied => 'Code copié dans le presse-papiers';

  @override
  String uiTestDemoCompletionPrefix(String value) {
    return 'Achèvement : $value %';
  }

  @override
  String get uiTestDemoConfirm => 'Confirmer';

  @override
  String get uiTestDemoConfirmAction => 'Confirmer l\'action';

  @override
  String get uiTestDemoConfirmActionBody => 'Cette action est irréversible.';

  @override
  String get uiTestDemoContinue => 'Continuer';

  @override
  String get uiTestDemoCriticalActionBody =>
      'Il s\'agit d\'une action sécurisée. Entrez votre mot de passe avant de confirmer.';

  @override
  String get uiTestDemoCriticalActionTitle => 'Confirmation d\'action critique';

  @override
  String get uiTestDemoCurrentPassword => 'Mot de passe actuel';

  @override
  String get uiTestDemoDateOfBirth => 'Date de naissance';

  @override
  String get uiTestDemoDefaultPlaceholder => 'Espace réservé par défaut';

  @override
  String get uiTestDemoDemographics => 'Démographie';

  @override
  String get uiTestDemoEmail => 'E-mail';

  @override
  String get uiTestDemoEnrollment => 'Inscription';

  @override
  String get uiTestDemoError => 'Erreur';

  @override
  String get uiTestDemoExampleImage => 'Image exemple';

  @override
  String get uiTestDemoFullName => 'Nom complet';

  @override
  String get uiTestDemoHelloWorld => 'Bonjour le monde';

  @override
  String get uiTestDemoInfo => 'Info';

  @override
  String get uiTestDemoInvalidPasswordMessage =>
      'Mot de passe incorrect. Le mot de passe de démonstration est « Admin123! ».';

  @override
  String get uiTestDemoKpiTrends => 'Tendances KPI';

  @override
  String get uiTestDemoLearnMore => 'En savoir plus';

  @override
  String uiTestDemoNormalizedPrefix(String value) {
    return 'Normalisé : $value';
  }

  @override
  String get uiTestDemoNotes => 'Notes';

  @override
  String get uiTestDemoNullIndeterminate => 'null (indéterminé)';

  @override
  String get uiTestDemoOpenModal => 'Ouvrir le modal';

  @override
  String get uiTestDemoOpenSecuredModal => 'Ouvrir le modal sécurisé';

  @override
  String get uiTestDemoOverview => 'Vue d\'ensemble';

  @override
  String get uiTestDemoParticipants => 'Participants';

  @override
  String get uiTestDemoPasswordVerified =>
      'Mot de passe vérifié. Action confirmée.';

  @override
  String get uiTestDemoPhoneNumber => 'Numéro de téléphone';

  @override
  String get uiTestDemoPlaceholderGraphic => 'Graphique de remplacement';

  @override
  String get uiTestDemoPriority => 'Priorité';

  @override
  String get uiTestDemoQueryEmpty => '(vide)';

  @override
  String get uiTestDemoQueryNone => '(aucun)';

  @override
  String uiTestDemoQueryPrefix(String value) {
    return 'Requête : $value';
  }

  @override
  String get uiTestDemoRespondents => 'Répondants';

  @override
  String get uiTestDemoSearchWidgets => 'Rechercher des widgets…';

  @override
  String get uiTestDemoShowPopover => 'Afficher le popover';

  @override
  String get uiTestDemoSuccess => 'Succès';

  @override
  String get uiTestDemoSummary => 'Résumé';

  @override
  String get uiTestDemoTaskCompletion => 'Achèvement de la tâche';

  @override
  String get uiTestDemoThisWeek => '+12 cette semaine';

  @override
  String uiTestDemoValuePrefix(String value) {
    return 'Valeur : $value';
  }

  @override
  String get uiTestDemoVerificationFailed => 'Échec de la vérification.';

  @override
  String get uiTestEnterValue => 'Saisir une valeur';

  @override
  String get uiTestPageSubtitle =>
      'Aperçus interactifs avec personnalisation en direct pour tous les widgets réutilisables.';

  @override
  String get uiTestPageTitle => 'Catalogue de widgets';

  @override
  String get uiTestSectionBasics => 'Éléments de base';

  @override
  String get uiTestSectionButtons => 'Boutons';

  @override
  String get uiTestSectionDataDisplay => 'Affichage des données';

  @override
  String get uiTestSectionFeedback => 'Retour d\'information';

  @override
  String get uiTestSectionForms => 'Formulaires et saisie';

  @override
  String get uiTestSectionMicro => 'Micro-widgets';

  @override
  String uiTestSectionNavbarActiveDestination(String label) {
    return 'Destination active : $label';
  }

  @override
  String get uiTestSectionNavbarActiveNone => 'Aucune';

  @override
  String get uiTestSectionNavbarAddSection => 'Ajouter une section';

  @override
  String get uiTestSectionNavbarAddSubsection => 'Ajouter une sous-section';

  @override
  String get uiTestSectionNavbarContainedTitle => 'Page défilante contenue';

  @override
  String get uiTestSectionNavbarHideCode => 'Masquer le code';

  @override
  String get uiTestSectionNavbarInitiallyExpanded => 'Développé initialement';

  @override
  String get uiTestSectionNavbarNoSections =>
      'Aucune section configurée. Ajoutez au moins une section dans PROPRIÉTÉS.';

  @override
  String get uiTestSectionNavbarProperties => 'PROPRIÉTÉS';

  @override
  String get uiTestSectionNavbarRemoveSection => 'Supprimer la section';

  @override
  String get uiTestSectionNavbarRemoveSubsection => 'Supprimer la sous-section';

  @override
  String get uiTestSectionNavbarReset => 'Réinitialiser';

  @override
  String get uiTestSectionNavbarScrollHint =>
      'Faites défiler ce panneau ou cliquez sur une destination pour y accéder.';

  @override
  String get uiTestSectionNavbarSectionLabel => 'Libellé de section';

  @override
  String uiTestSectionNavbarSectionN(String n) {
    return 'Section $n';
  }

  @override
  String get uiTestSectionNavbarShowCode => 'Afficher le code';

  @override
  String get uiTestSectionNavbarSubsection1 => 'Sous-section 1';

  @override
  String get uiTestSectionNavbarSubsectionLabel => 'Libellé de sous-section';

  @override
  String uiTestSectionNavbarSubsectionN(String n) {
    return 'Sous-section $n';
  }

  @override
  String get uiTestSectionNavbarUntitledSection => 'Section sans titre';

  @override
  String get uiTestSectionNavbarUntitledSubsection => 'Sous-section sans titre';

  @override
  String get uiTestWidgetAppAccordion => 'AppAccordion';

  @override
  String get uiTestWidgetAppAccordionDesc =>
      'Panneau extensible pour afficher et masquer des détails.';

  @override
  String get uiTestWidgetAppAnnouncement => 'AppAnnouncement';

  @override
  String get uiTestWidgetAppAnnouncementDesc =>
      'Bannière en ligne pour les annonces importantes.';

  @override
  String get uiTestWidgetAppBadge => 'AppBadge';

  @override
  String get uiTestWidgetAppBadgeDesc =>
      'Étiquettes de type pastille pour les statuts, rôles et catégories.';

  @override
  String get uiTestWidgetAppBarChart => 'AppBarChart';

  @override
  String get uiTestWidgetAppBarChartDesc =>
      'Graphique en barres avec fl_chart, étiquettes d\'axes et infobulles au survol.';

  @override
  String get uiTestWidgetAppBreadcrumbs => 'AppBreadcrumbs';

  @override
  String get uiTestWidgetAppBreadcrumbsDesc =>
      'Fil d\'Ariane pour la hiérarchie de navigation.';

  @override
  String get uiTestWidgetAppCardTask => 'AppCardTask';

  @override
  String get uiTestWidgetAppCardTaskDesc =>
      'Carte de tâche avec texte d\'échéance, texte de répétition optionnel et CTA.';

  @override
  String get uiTestWidgetAppCheckbox => 'AppCheckbox';

  @override
  String get uiTestWidgetAppCheckboxDesc =>
      'Case à cocher adaptée au thème en modes contrôlé et non contrôlé.';

  @override
  String get uiTestWidgetAppCreateConfirmPassword =>
      'AppCreatePasswordInput + AppConfirmPasswordInput';

  @override
  String get uiTestWidgetAppCreateConfirmPasswordDesc =>
      'Paire création/confirmation de mot de passe avec vérification en direct.';

  @override
  String get uiTestWidgetAppDateInput => 'AppDateInput';

  @override
  String get uiTestWidgetAppDateInputDesc =>
      'Champ de sélection de date avec validation requise.';

  @override
  String get uiTestWidgetAppDivider => 'AppDivider';

  @override
  String get uiTestWidgetAppDividerDesc =>
      'Séparateur visuel avec épaisseur et espacement configurables.';

  @override
  String get uiTestWidgetAppDropdownInput => 'AppDropdownInput';

  @override
  String get uiTestWidgetAppDropdownInputDesc =>
      'Liste déroulante de formulaire avec comportement requis et erreur.';

  @override
  String get uiTestWidgetAppDropdownMenu => 'AppDropdownMenu';

  @override
  String get uiTestWidgetAppDropdownMenuDesc =>
      'Menu déroulant adapté au thème pour choisir parmi des options.';

  @override
  String get uiTestWidgetAppEmailInput => 'AppEmailInput';

  @override
  String get uiTestWidgetAppEmailInputDesc =>
      'Champ e-mail avec validation de structure et remplissage automatique.';

  @override
  String get uiTestWidgetAppFilledButton => 'AppFilledButton';

  @override
  String get uiTestWidgetAppFilledButtonDesc =>
      'Bouton d\'action principal avec fond plein.';

  @override
  String get uiTestWidgetAppGraphRenderer => 'AppGraphRenderer';

  @override
  String get uiTestWidgetAppGraphRendererDesc =>
      'Conteneur de graphique responsive avec titre et contenu personnalisé optionnel.';

  @override
  String get uiTestWidgetAppIcon => 'AppIcon';

  @override
  String get uiTestWidgetAppIconDesc =>
      'Wrapper d\'icône adapté au thème avec dimensionnement responsive.';

  @override
  String get uiTestWidgetAppImage => 'AppImage';

  @override
  String get uiTestWidgetAppImageDesc =>
      'Image responsive avec prise en charge du ratio d\'aspect.';

  @override
  String get uiTestWidgetAppLongButton => 'AppLongButton';

  @override
  String get uiTestWidgetAppLongButtonDesc =>
      'Bouton pleine largeur pour les actions importantes.';

  @override
  String get uiTestWidgetAppModalOverlay => 'AppModal + AppOverlay';

  @override
  String get uiTestWidgetAppModalOverlayDesc =>
      'Modal déclenché par un bouton avec barrière superposée.';

  @override
  String get uiTestWidgetAppParagraphInput => 'AppParagraphInput';

  @override
  String get uiTestWidgetAppParagraphInputDesc =>
      'Champ de texte multiligne avec contrôle du nombre de lignes.';

  @override
  String get uiTestWidgetAppPasswordInput => 'AppPasswordInput';

  @override
  String get uiTestWidgetAppPasswordInputDesc =>
      'Champ mot de passe avec bascule d\'affichage et vérifications requises.';

  @override
  String get uiTestWidgetAppPhoneInput => 'AppPhoneInput';

  @override
  String get uiTestWidgetAppPhoneInputDesc =>
      'Champ téléphone avec sélecteur de pays et sortie normalisée.';

  @override
  String get uiTestWidgetAppPieChart => 'AppPieChart';

  @override
  String get uiTestWidgetAppPieChartDesc =>
      'Graphique circulaire avec légende, étiquettes de pourcentage et interaction tactile.';

  @override
  String get uiTestWidgetAppPlaceholderGraphic => 'AppPlaceholderGraphic';

  @override
  String get uiTestWidgetAppPlaceholderGraphicDesc =>
      'Graphique de remplacement adapté au thème pour les états vides.';

  @override
  String get uiTestWidgetAppPopover => 'AppPopover';

  @override
  String get uiTestWidgetAppPopoverDesc =>
      'Retour d\'information ancré au contexte.';

  @override
  String get uiTestWidgetAppProgressBar => 'AppProgressBar';

  @override
  String get uiTestWidgetAppProgressBarDesc =>
      'Indicateur de progression adapté au thème pour le suivi de l\'avancement.';

  @override
  String get uiTestWidgetAppRadio => 'AppRadio';

  @override
  String get uiTestWidgetAppRadioDesc =>
      'Bouton radio adapté au thème en modes contrôlé et non contrôlé.';

  @override
  String get uiTestWidgetAppRichText => 'AppRichText';

  @override
  String get uiTestWidgetAppRichTextDesc =>
      'Mise en forme en ligne avec gras, italique et styles mixtes.';

  @override
  String get uiTestWidgetAppSearchBar => 'AppSearchBar';

  @override
  String get uiTestWidgetAppSearchBarDesc =>
      'Champ de recherche avec icône de début et action d\'effacement.';

  @override
  String get uiTestWidgetAppSectionNavbar => 'AppSectionNavbar';

  @override
  String get uiTestWidgetAppSectionNavbarDesc =>
      'Navigation par sections avec groupes repliables et mise en évidence de la destination active.';

  @override
  String get uiTestWidgetAppSecuredModal => 'AppSecuredModal';

  @override
  String get uiTestWidgetAppSecuredModalDesc =>
      'Modal de confirmation d\'action critique nécessitant une vérification par mot de passe.';

  @override
  String get uiTestWidgetAppStatCard => 'AppStatCard';

  @override
  String get uiTestWidgetAppStatCardDesc =>
      'Carte de statistique avec icône, étiquette, grande valeur, sous-titre optionnel et bordure supérieure.';

  @override
  String get uiTestWidgetAppStatusDot => 'AppStatusDot';

  @override
  String get uiTestWidgetAppStatusDotDesc =>
      'Indicateur de notification superposé sur n\'importe quelle icône.';

  @override
  String get uiTestWidgetAppText => 'AppText';

  @override
  String get uiTestWidgetAppTextButton => 'AppTextButton';

  @override
  String get uiTestWidgetAppTextButtonDesc =>
      'Bouton texte pour les actions secondaires.';

  @override
  String get uiTestWidgetAppTextDesc =>
      'Texte adapté au thème avec des variantes typographiques responsives.';

  @override
  String get uiTestWidgetAppTextInput => 'AppTextInput';

  @override
  String get uiTestWidgetAppTextInputDesc =>
      'Champ de texte sur une ligne avec étiquette et validation.';

  @override
  String get uiTestWidgetAppTimeInput => 'AppTimeInput';

  @override
  String get uiTestWidgetAppTimeInputDesc =>
      'Champ de sélection d\'heure avec validation requise.';

  @override
  String get uiTestWidgetAppToast => 'AppToast';

  @override
  String get uiTestWidgetAppToastDesc =>
      'Notifications superposées transitoires avec fermeture automatique.';

  @override
  String get uiTestWidgetDataTable => 'DataTable';

  @override
  String get uiTestWidgetDataTableCell => 'DataTableCell';

  @override
  String get uiTestWidgetDataTableCellDesc =>
      'Fabriques de cellules typées pour un style de cellule cohérent.';

  @override
  String get uiTestWidgetDataTableDesc =>
      'Tableau triable avec lignes extensibles, en-têtes fixes et défilement horizontal.';

  @override
  String get uiTestWidgetHealthBankLogo => 'HealthBankLogo';

  @override
  String get uiTestWidgetHealthBankLogoDesc =>
      'Logo de la marque avec slogan optionnel et variantes de taille.';

  @override
  String get privacyPolicySection1Body =>
      'HealthBank recueille les renseignements personnels que vous fournissez lors de la création de votre compte, notamment votre nom, votre adresse courriel, votre date de naissance et votre sexe. Lorsque vous remplissez des sondages sur la santé, nous recueillons les données de santé et les réponses que vous choisissez de soumettre. Nous collectons également des renseignements techniques tels que les horodatages de connexion et l\'activité de session pour assurer la sécurité de la plateforme.\n\nNous ne recueillons que les renseignements nécessaires au fonctionnement de la plateforme et à la réalisation des recherches approuvées. Vous n\'êtes jamais tenu de fournir des renseignements au-delà de ce qui est nécessaire pour participer à votre programme de recherche.';

  @override
  String get privacyPolicySection1Title =>
      'Renseignements que nous recueillons';

  @override
  String get privacyPolicySection2Body =>
      'Vos renseignements personnels sont utilisés uniquement pour exploiter la plateforme HealthBank et faciliter la recherche en santé approuvée. Plus précisément, nous utilisons vos données pour : vérifier votre identité et gérer votre compte ; distribuer des sondages et recueillir vos réponses sur la santé ; permettre à votre professionnel de la santé désigné de surveiller votre participation ; et fournir aux chercheurs des résultats agrégés et dépersonnalisés aux fins d\'analyse.\n\nNous n\'utilisons pas vos renseignements personnels à des fins de marketing, de publicité ou à toute autre fin commerciale. Vos données ne sont jamais vendues à des tiers.';

  @override
  String get privacyPolicySection2Title => 'Utilisation de vos renseignements';

  @override
  String get privacyPolicySection3Body =>
      'Vos données de santé individuelles ne sont partagées qu\'avec les parties autorisées directement impliquées dans vos soins ou votre étude de recherche approuvée. Les chercheurs sur la plateforme ne reçoivent que des données agrégées et dépersonnalisées — les réponses individuelles ne peuvent pas être liées à votre identité dans les résultats de recherche.\n\nNous pouvons être tenus de divulguer des renseignements lorsque la loi canadienne, une ordonnance du tribunal ou la prévention d\'un préjudice grave l\'exigent. Dans tous ces cas, nous ne divulguons que le minimum d\'information requis et documentons chaque divulgation.';

  @override
  String get privacyPolicySection3Title => 'Partage de vos données';

  @override
  String get privacyPolicySection4Body =>
      'HealthBank utilise des mesures de sécurité conformes aux normes de l\'industrie pour protéger vos renseignements personnels, notamment le chiffrement des données transmises (HTTPS), le hachage des mots de passe, la gestion des sessions et des contrôles d\'accès restreints. La plateforme est exploitée sur des serveurs sécurisés dont l\'accès est limité au personnel autorisé.\n\nVos données sont conservées aussi longtemps que vous êtes un participant actif dans un programme de recherche HealthBank. Vous pouvez demander la suppression de votre compte et des données associées en tout temps en communiquant avec le responsable de la protection des renseignements personnels de HealthBank. Certaines données peuvent être conservées sous forme agrégée et dépersonnalisée pour la continuité de la recherche après la suppression du compte.';

  @override
  String get privacyPolicySection4Title =>
      'Sécurité et conservation des données';

  @override
  String get privacyPolicySection5Body =>
      'En vertu de la LPRPDE et des lois provinciales applicables, vous avez le droit : d\'accéder aux renseignements personnels que nous détenons à votre sujet ; de demander des corrections aux renseignements inexacts ; de retirer votre consentement et de demander la suppression de vos données ; et de recevoir une explication sur la façon dont vos données sont utilisées.\n\nPour exercer l\'un de ces droits, ou si vous avez des questions ou des préoccupations concernant votre vie privée, veuillez communiquer avec le responsable de la protection des renseignements personnels de HealthBank de votre établissement. Nous nous engageons à répondre à toutes les demandes de renseignements dans un délai de 30 jours.';

  @override
  String get privacyPolicySection5Title => 'Vos droits et coordonnées';

  @override
  String get privacyPolicyTitle => 'Politique de confidentialité';

  @override
  String get privacyPolicyTocTitle => 'Table des matières';

  @override
  String get tosSection1Body =>
      'En créant un compte ou en accédant à la plateforme HealthBank, vous acceptez d\'être lié par ces conditions d\'utilisation et notre politique de confidentialité. Si vous n\'acceptez pas ces conditions, vous ne devez pas utiliser la plateforme. Ces conditions peuvent être mises à jour périodiquement ; votre utilisation continue de la plateforme après notification de tout changement constitue votre acceptation des conditions révisées.';

  @override
  String get tosSection1Title => 'Acceptation des conditions';

  @override
  String get tosSection2Body =>
      'L\'accès à HealthBank se fait sur invitation seulement. Les comptes des participants sont créés par des administrateurs autorisés ou des professionnels de la santé. Vous devez avoir au moins 18 ans, ou avoir le consentement d\'un parent ou tuteur si vous avez moins de 18 ans. Vous êtes responsable de la confidentialité de vos identifiants de connexion et de toutes les activités effectuées sous votre compte.';

  @override
  String get tosSection2Title => 'Utilisateurs admissibles';

  @override
  String get tosSection3Body =>
      'Vous acceptez d\'utiliser HealthBank uniquement aux fins prévues — participer à des recherches en santé approuvées et gérer vos données de santé personnelles. Vous ne devez pas tenter d\'accéder aux données d\'autres utilisateurs ; altérer, désosser ou perturber la plateforme ; soumettre des informations fausses ou trompeuses ; ni utiliser la plateforme à des fins illégales. Le non-respect de ces responsabilités peut entraîner la suspension immédiate de votre compte.';

  @override
  String get tosSection3Title => 'Responsabilités de l\'utilisateur';

  @override
  String get tosSection4Body =>
      'Votre utilisation de HealthBank implique la collecte et l\'utilisation de données de santé personnelles telles que décrites dans notre politique de confidentialité. En utilisant la plateforme, vous consentez à cette collecte aux fins de la recherche en santé approuvée. Vous pouvez retirer votre consentement en tout temps en communiquant avec votre coordonnateur d\'étude ou le responsable de la protection des renseignements personnels de HealthBank, ce qui entraînera la désactivation de votre compte. HealthBank est exploitée conformément à la législation canadienne en matière de protection de la vie privée.';

  @override
  String get tosSection4Title => 'Données et confidentialité';

  @override
  String get tosSection5Body =>
      'HealthBank est fournie en tant que plateforme de recherche universitaire « telle quelle ». Bien que nous prenions toutes les précautions raisonnables pour maintenir la sécurité et l\'intégrité des données, l\'Université de l\'Île-du-Prince-Édouard et l\'équipe du projet HealthBank ne sauraient être tenus responsables des dommages indirects, accessoires ou consécutifs découlant de votre utilisation de la plateforme. Rien dans ces conditions ne limite la responsabilité pour négligence grave, faute intentionnelle ou conformément aux exigences de la loi applicable.';

  @override
  String get tosSection5Title => 'Limitation de responsabilité';

  @override
  String get tosTitle => 'Conditions d\'utilisation';

  @override
  String get tosTocTitle => 'Sommaire';
}
