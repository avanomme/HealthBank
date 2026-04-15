// Created with the Assistance of Claude Code
// frontend/lib/src/features/auth/pages/consent_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/core/widgets/layout/base_scaffold.dart';
import 'package:frontend/src/core/widgets/basics/basics.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/state/locale_provider.dart';
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;
import 'package:frontend/src/features/participant/state/participant_dashboard_providers.dart'
    show participantConsentStatusProvider;

/// Consent form page shown after login/password change if consent not yet signed.
///
/// Displays a role-specific legal document (participant consent, researcher
/// confidentiality, or HCP confidentiality) in the user's selected language.
/// The user must read the document and check an agreement box before submitting.
class ConsentPage extends ConsumerStatefulWidget {
  const ConsentPage({super.key});

  @override
  ConsumerState<ConsentPage> createState() => _ConsentPageState();
}

class _ConsentPageState extends ConsumerState<ConsentPage> {
  bool _agreed = false;
  bool _isLoading = false;
  String? _error;
  final _signatureController = TextEditingController();
  final _scrollController = ScrollController();
  String _signatureText = '';

  @override
  void dispose() {
    _signatureController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _getConsentTitle(AppLocalizations l10n, String? role) {
    switch (role) {
      case 'researcher':
        return l10n.consentResearcherTitle;
      case 'hcp':
        return l10n.consentHcpTitle;
      case 'participant':
      default:
        return l10n.consentParticipantTitle;
    }
  }

  String _getConsentDocument(AppLocalizations l10n, String? role) {
    switch (role) {
      case 'researcher':
        return l10n.consentDocumentResearcher;
      case 'hcp':
        return l10n.consentDocumentHcp;
      case 'participant':
      default:
        return l10n.consentDocumentParticipant;
    }
  }

  bool get _canSubmit =>
      _agreed && _signatureText.trim().isNotEmpty && !_isLoading;

  Future<void> _handleSubmit() async {
    if (!_canSubmit) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final locale = ref.read(localeProvider);
      final langCode = locale.languageCode;
      final l10n = context.l10n;
      final role = ref.read(authProvider).user?.role;
      final documentText = _getConsentDocument(l10n, role);

      final client = ref.read(apiClientProvider);
      final consentApi = ConsentApi(client.dio);
      await consentApi.submitConsent(ConsentSubmitRequest(
        documentText: documentText,
        documentLanguage: langCode,
        signatureName: _signatureText.trim(),
      ));

      ref.read(authProvider.notifier).markConsentSigned();
      ref.invalidate(participantConsentStatusProvider);

      if (mounted) {
        context.go(getDashboardRouteForRole(role) ?? AppRoutes.login);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = context.l10n.consentErrorGeneric;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = Breakpoints.isMobile(screenWidth);
    final role = ref.watch(authProvider).user?.role;
    final today = DateFormat.yMMMMd().format(DateTime.now());

    return BaseScaffold(
      header: const Header(navItems: []),
      showFooter: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 0,
              vertical: 24,
            ),
            decoration: BoxDecoration(
              color: context.appColors.surface,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: context.appColors.divider, width: 1),
            ),
            padding: EdgeInsets.all(isMobile ? 24.0 : 40.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Center(
                  child: Semantics(
                    header: true,
                    child: Text(
                      _getConsentTitle(l10n, role),
                      style:
                          AppTheme.heading4.copyWith(color: AppTheme.primary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    l10n.consentPageSubtitle,
                    style:
                        AppTheme.body.copyWith(color: context.appColors.textMuted),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),

                // Date
                Text(
                  '${l10n.consentDateLabel}: $today',
                  style: AppTheme.body.copyWith(color: context.appColors.textMuted),
                ),
                const SizedBox(height: 16),

                _buildConsentText(l10n, role),
                const SizedBox(height: 24),

                _buildSignatureSection(l10n),

                // Error message
                if (_error != null) ...[
                  Semantics(

                    liveRegion: true,

                    child: Text(

                                      _error!,

                                      style: AppTheme.body.copyWith(color: AppTheme.error),

                                      textAlign: TextAlign.center,

                                    ),

                  ),
                  const SizedBox(height: 16),
                ],

                // Submit button
                AppFilledButton(
                  label: _isLoading
                      ? l10n.commonLoading
                      : l10n.consentSubmitButton,
                  onPressed: _canSubmit ? _handleSubmit : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConsentText(AppLocalizations l10n, String? role) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.appColors.divider.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: SelectableText(
            _getConsentDocument(l10n, role),
            style: AppTheme.body.copyWith(
              color: context.appColors.textPrimary,
              height: 1.6,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignatureSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Typed signature section
        Text(
          l10n.consentSignatureLabel,
          style: AppTheme.body.copyWith(
            color: context.appColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.consentSignatureDisclaimer,
          style: AppTheme.captions.copyWith(
            color: context.appColors.textMuted,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _signatureController,
          enabled: !_isLoading,
          decoration: InputDecoration(
            hintText: l10n.consentSignatureHint,
            filled: true,
            fillColor: context.appColors.divider.withValues(alpha: 0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: context.appColors.divider),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: AppTheme.body.copyWith(
            fontStyle: FontStyle.italic,
            color: context.appColors.textPrimary,
          ),
          onChanged: (v) => setState(() => _signatureText = v),
        ),
        const SizedBox(height: 16),

        // UECA notice
        Text(
          l10n.consentElectronicSignatureNotice,
          style: AppTheme.captions.copyWith(
            color: context.appColors.textMuted,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 16),

        // Agreement checkbox
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _agreed,
              onChanged: _isLoading
                  ? null
                  : (v) => setState(() => _agreed = v ?? false),
              activeColor: AppTheme.primary,
            ),
            Expanded(
              child: AppTappable(
                onTap: _isLoading
                    ? null
                    : () => setState(() => _agreed = !_agreed),
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    l10n.consentCheckboxLabel,
                    style: AppTheme.body
                        .copyWith(color: context.appColors.textPrimary),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
