// Created with the Assistance of Claude Code and Codex
// frontend/lib/features/auth/pages/request_account_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/api/models/models.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/core/widgets/layout/base_scaffold.dart';
import 'package:frontend/src/core/widgets/basics/header.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';

/// Request Account page
///
/// Features:
/// - Account request form with name, email, role selection
/// - Conditional participant fields (birthdate, gender)
/// - Validation + submission to public /request_account endpoint
class RequestAccountPage extends ConsumerStatefulWidget {
  const RequestAccountPage({super.key});

  @override
  ConsumerState<RequestAccountPage> createState() => _RequestAccountPageState();
}

class _RequestAccountPageState extends ConsumerState<RequestAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _genderOtherController = TextEditingController();

  int? _selectedRoleId;
  String? _selectedGender;
  DateTime? _selectedBirthdate;
  bool _isLoading = false;
  bool _isSubmitted = false;
  String? _error;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _genderOtherController.dispose();
    super.dispose();
  }

  bool get _isParticipant => _selectedRoleId == 1;

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final l10n = context.l10n;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authApi = ref.read(authApiProvider);
      await authApi.submitAccountRequest(
        AccountRequestCreate(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          roleId: _selectedRoleId!,
          birthdate: _selectedBirthdate != null
              ? '${_selectedBirthdate!.year}-${_selectedBirthdate!.month.toString().padLeft(2, '0')}-${_selectedBirthdate!.day.toString().padLeft(2, '0')}'
              : null,
          gender: _isParticipant ? _selectedGender : null,
          genderOther: _selectedGender == 'Other'
              ? _genderOtherController.text.trim()
              : null,
        ),
      );
      setState(() {
        _isSubmitted = true;
        _isLoading = false;
      });
    } catch (e) {
      final errorMsg = e.toString();
      String displayError;
      if (errorMsg.contains('409') && errorMsg.contains('already exists')) {
        displayError = l10n.requestAccountDuplicateEmail;
      } else if (errorMsg.contains('409') && errorMsg.contains('pending')) {
        displayError = l10n.requestAccountDuplicatePending;
      } else if (errorMsg.contains('429')) {
        displayError = l10n.requestAccountTooManyRequests;
      } else {
        displayError = l10n.requestAccountError;
      }
      setState(() {
        _isLoading = false;
        _error = displayError;
      });
    }
  }

  Future<void> _pickBirthdate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthdate ?? DateTime(now.year - 25),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _selectedBirthdate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = Breakpoints.isMobile(screenWidth);
    final cardPadding = isMobile ? 24.0 : 40.0;

    return BaseScaffold(
      header: const Header(navItems: []),
      showFooter: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
            decoration: BoxDecoration(
              color: context.appColors.surface,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: context.appColors.divider, width: 1),
            ),
            padding: EdgeInsets.all(cardPadding),
            child: _isSubmitted
                ? _buildSuccessContent(l10n)
                : _buildFormContent(l10n),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(AppLocalizations l10n) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Semantics(
            header: true,
            child: Text(
              l10n.requestAccountTitle,
              style: AppTheme.heading4.copyWith(color: AppTheme.primary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.requestAccountSubtitle,
            style: AppTheme.body.copyWith(color: context.appColors.textMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // First Name
          TextFormField(
            key: const ValueKey('auth_first_name'),
            controller: _firstNameController,
            autofillHints: const [AutofillHints.givenName],
            enabled: !_isLoading,
            decoration: _inputDecoration(l10n.requestAccountFirstName),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? l10n.requestAccountFirstNameRequired
                : null,
          ),
          const SizedBox(height: 16),

          // Last Name
          TextFormField(
            key: const ValueKey('auth_last_name'),
            controller: _lastNameController,
            autofillHints: const [AutofillHints.familyName],
            enabled: !_isLoading,
            decoration: _inputDecoration(l10n.requestAccountLastName),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? l10n.requestAccountLastNameRequired
                : null,
          ),
          const SizedBox(height: 16),

          // Email
          TextFormField(
            key: const ValueKey('auth_register_email'),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            enabled: !_isLoading,
            decoration: _inputDecoration(l10n.requestAccountEmail),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return l10n.requestAccountEmailRequired;
              }
              if (!v.contains('@')) {
                return l10n.authEmailInvalid;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Role
          DropdownButtonFormField<int>(
            key: const ValueKey('auth_role_dropdown'),
            initialValue: _selectedRoleId,
            isExpanded: true,
            decoration: _inputDecoration(l10n.requestAccountRole),
            items: [
              DropdownMenuItem(
                value: 1,
                child: Text(l10n.requestAccountRoleParticipant),
              ),
              DropdownMenuItem(
                value: 2,
                child: Text(l10n.requestAccountRoleResearcher),
              ),
              DropdownMenuItem(
                value: 3,
                child: Text(l10n.requestAccountRoleHcp),
              ),
            ],
            onChanged: _isLoading
                ? null
                : (v) => setState(() => _selectedRoleId = v),
            validator: (v) =>
                v == null ? l10n.requestAccountRoleRequired : null,
          ),
          const SizedBox(height: 16),

          // Conditional participant fields
          if (_isParticipant) ...[
            // Birthdate
            InkWell(
              key: const ValueKey('auth_birthdate'),
              onTap: _isLoading ? null : _pickBirthdate,
              child: InputDecorator(
                decoration: _inputDecoration(l10n.requestAccountBirthdate),
                child: Text(
                  _selectedBirthdate != null
                      ? '${_selectedBirthdate!.year}-${_selectedBirthdate!.month.toString().padLeft(2, '0')}-${_selectedBirthdate!.day.toString().padLeft(2, '0')}'
                      : '',
                  style: AppTheme.body.copyWith(
                    color: _selectedBirthdate != null
                        ? context.appColors.textPrimary
                        : context.appColors.textMuted,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Gender
            DropdownButtonFormField<String>(
              key: const ValueKey('auth_gender_dropdown'),
              initialValue: _selectedGender,
              isExpanded: true,
              decoration: _inputDecoration(l10n.requestAccountGender),
              items: [
                DropdownMenuItem(
                  value: 'Male',
                  child: Text(l10n.requestAccountGenderMale),
                ),
                DropdownMenuItem(
                  value: 'Female',
                  child: Text(l10n.requestAccountGenderFemale),
                ),
                DropdownMenuItem(
                  value: 'Non-Binary',
                  child: Text(l10n.requestAccountGenderNonBinary),
                ),
                DropdownMenuItem(
                  value: 'Prefer Not to Say',
                  child: Text(l10n.requestAccountGenderPreferNotToSay),
                ),
                DropdownMenuItem(
                  value: 'Other',
                  child: Text(l10n.requestAccountGenderOther),
                ),
              ],
              onChanged: _isLoading
                  ? null
                  : (v) => setState(() => _selectedGender = v),
            ),
            const SizedBox(height: 16),

            // Gender Other text field
            if (_selectedGender == 'Other') ...[
              TextFormField(
                key: const ValueKey('auth_gender_other'),
                controller: _genderOtherController,
                enabled: !_isLoading,
                decoration: _inputDecoration(
                  l10n.requestAccountGenderOtherSpecify,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],

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
            label: _isLoading ? 'Loading\u2026' : l10n.requestAccountSubmit,
            onPressed: _isLoading ? null : _handleSubmit,
          ),
          const SizedBox(height: 24),

          // Back to login
          AppTextButton(
            label: l10n.requestAccountBackToLogin,
            onPressed: _isLoading ? null : () => context.go('/login'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 64,
          color: AppTheme.primary,
        ),
        const SizedBox(height: 24),
        Semantics(
          header: true,
          child: Text(
            l10n.requestAccountTitle,
            style: AppTheme.heading4.copyWith(color: AppTheme.primary),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.requestAccountSuccess,
          style: AppTheme.body.copyWith(color: context.appColors.textMuted),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        AppFilledButton(
          label: l10n.requestAccountBackToLogin,
          onPressed: () => context.go('/login'),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration([String? labelText]) {
    return InputDecoration(
      labelText: labelText,
      filled: true,
      fillColor: context.appColors.divider,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: context.appColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(
          color: context.appColors.inputBorderFocused,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppTheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppTheme.error, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
