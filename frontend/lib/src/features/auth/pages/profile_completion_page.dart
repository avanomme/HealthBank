// Created with the Assistance of Claude Code
// frontend/lib/features/auth/pages/profile_completion_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/api/models/models.dart';
import 'package:frontend/src/features/auth/state/auth_providers.dart';
import 'package:frontend/src/core/widgets/layout/base_scaffold.dart';
import 'package:frontend/src/core/widgets/basics/header.dart';
import 'package:frontend/src/config/go_router.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';

/// Profile Completion page for participants
///
/// Shown after password change when a participant's profile is missing
/// birthdate and/or gender (admin-created accounts).
class ProfileCompletionPage extends ConsumerStatefulWidget {
  const ProfileCompletionPage({super.key});

  @override
  ConsumerState<ProfileCompletionPage> createState() =>
      _ProfileCompletionPageState();
}

class _ProfileCompletionPageState
    extends ConsumerState<ProfileCompletionPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedBirthdate;
  String? _selectedGender;
  bool _isLoading = false;
  String? _error;

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

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_selectedBirthdate == null) {
      setState(() => _error = context.l10n.profileCompletionBirthdateRequired);
      return;
    }
    if (_selectedGender == null) {
      setState(() => _error = context.l10n.profileCompletionGenderRequired);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authApi = ref.read(authApiProvider);
      final birthdate =
          '${_selectedBirthdate!.year}-${_selectedBirthdate!.month.toString().padLeft(2, '0')}-${_selectedBirthdate!.day.toString().padLeft(2, '0')}';

      await authApi.completeProfile(
        ProfileCompleteRequest(
          birthdate: birthdate,
          gender: _selectedGender!,
        ),
      );

      ref.read(authProvider.notifier).clearNeedsProfileCompletion();

      if (mounted) {
        final authState = ref.read(authProvider);
        if (!authState.hasSignedConsent) {
          context.go(AppRoutes.consent);
          return;
        }

        final role = authState.user?.role;
        context.go(getDashboardRouteForRole(role) ?? AppRoutes.login);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = context.l10n.profileCompletionError;
      });
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
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
            decoration: BoxDecoration(
              color: context.appColors.surface,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: context.appColors.divider, width: 1),
            ),
            padding: EdgeInsets.all(cardPadding),
            child: _buildFormContent(l10n),
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
          // Icon
          const Icon(
            Icons.person_outline,
            size: 48,
            color: AppTheme.primary,
          ),
          const SizedBox(height: 16),

          // Title
          Semantics(
            header: true,
            child: Text(
              l10n.profileCompletionTitle,
              style: AppTheme.heading4.copyWith(color: AppTheme.primary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.profileCompletionSubtitle,
            style: AppTheme.body.copyWith(color: context.appColors.textMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Birthdate
          InkWell(
            key: const ValueKey('profile_birthdate'),
            onTap: _isLoading ? null : _pickBirthdate,
            child: InputDecorator(
              decoration: _inputDecoration(labelText: l10n.profileCompletionBirthdate),
              child: Text(
                _selectedBirthdate != null
                    ? '${_selectedBirthdate!.year}-${_selectedBirthdate!.month.toString().padLeft(2, '0')}-${_selectedBirthdate!.day.toString().padLeft(2, '0')}'
                    : l10n.profileCompletionBirthdate,
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
            key: const ValueKey('profile_gender_dropdown'),
            initialValue: _selectedGender,
            decoration: _inputDecoration(labelText: l10n.profileCompletionGender),
            items: [
              DropdownMenuItem(
                  value: 'Male', child: Text(l10n.profileCompletionGenderMale)),
              DropdownMenuItem(
                  value: 'Female',
                  child: Text(l10n.profileCompletionGenderFemale)),
              DropdownMenuItem(
                  value: 'Non-Binary',
                  child: Text(l10n.profileCompletionGenderNonBinary)),
              DropdownMenuItem(
                  value: 'Prefer Not to Say',
                  child: Text(l10n.profileCompletionGenderPreferNotToSay)),
              DropdownMenuItem(
                  value: 'Other',
                  child: Text(l10n.profileCompletionGenderOther)),
            ],
            onChanged:
                _isLoading ? null : (v) => setState(() => _selectedGender = v),
          ),
          const SizedBox(height: 16),

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
                : l10n.profileCompletionSubmit,
            onPressed: _isLoading ? null : _handleSubmit,
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({Widget? suffixIcon, String? labelText}) {
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
        borderSide: BorderSide(color: context.appColors.inputBorderFocused, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppTheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppTheme.error, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      suffixIcon: suffixIcon,
    );
  }
}
