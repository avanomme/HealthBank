// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/src/core/api/api.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/layout/layout.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/features/question_bank/state/question_providers.dart'
    show apiClientProvider;

/// User profile page for viewing and editing personal account information.
///
/// Loads the current user from the API and allows updating name, email,
/// birthdate, and gender. Wrapped in a [RoleAwareScaffold].
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _birthdateController;
  late final TextEditingController _genderController;

  bool _loading = true;
  bool _saving = false;
  bool _isEditing = false;
  String? _error;
  String? _success;

  SessionMeResponse? _session;

  void _resetControllersFromSession() {
    final user = _session?.user;
    if (user == null) return;

    _firstNameController.text = user.firstName ?? '';
    _lastNameController.text = user.lastName ?? '';
    _emailController.text = user.email;
    _birthdateController.text = user.birthdate ?? '';
    _genderController.text = user.gender ?? '';
  }

  void _cancelEditing() {
    _resetControllersFromSession();
    setState(() {
      _isEditing = false;
      _error = null;
      _success = null;
    });
  }

  String _displayValue(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? '—' : text;
  }

  AuthApi _authApi() {
    final client = ref.read(apiClientProvider);
    return AuthApi(client.dio);
  }

  UserApi _userApi() {
    final client = ref.read(apiClientProvider);
    return UserApi(client.dio);
  }

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _birthdateController = TextEditingController();
    _genderController = TextEditingController();

    _loadProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _birthdateController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _loading = true;
      _error = null;
      _success = null;
    });

    try {
      final session = await _authApi().getSessionInfo();

      _session = session;
      _resetControllersFromSession();

      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = context.l10n.profileLoadError;
      });
    }
  }

  Future<void> _pickBirthdate() async {
    DateTime initialDate = DateTime(2000, 1, 1);

    final currentText = _birthdateController.text.trim();
    if (currentText.isNotEmpty) {
      try {
        initialDate = DateTime.parse(currentText);
      } catch (_) {}
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _birthdateController.text =
          '${picked.year.toString().padLeft(4, '0')}-'
          '${picked.month.toString().padLeft(2, '0')}-'
          '${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _saving = true;
      _error = null;
      _success = null;
    });

    try {
      final birthdateText = _birthdateController.text.trim();

      await _userApi().updateCurrentUser(
        CurrentUserUpdate(
          firstName: _firstNameController.text.trim().isEmpty
              ? null
              : _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim().isEmpty
              ? null
              : _lastNameController.text.trim(),
          email: _emailController.text.trim().isEmpty
              ? null
              : _emailController.text.trim(),
          birthdate: birthdateText.isEmpty
              ? null
              : DateTime.parse(birthdateText),
          gender: _genderController.text.trim().isEmpty
              ? null
              : _genderController.text.trim(),
        ),
      );

      await _loadProfile();

      if (!mounted) return;
      setState(() {
        _saving = false;
        _success = context.l10n.profileUpdateSuccess;
        _isEditing = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = context.l10n.profileUpdateError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RoleAwareScaffold(
      currentRoute: '/profile',
      showFooter: false,
      child: Center(child: _buildCard(context)),
    );
  }

  Widget _buildCard(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = Breakpoints.isMobile(screenWidth);
    final cardPadding = isMobile ? 24.0 : 40.0;

    return Container(
      constraints: const BoxConstraints(maxWidth: 720),
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.divider),
      ),
      child: _loading
          ? const Padding(
              padding: EdgeInsets.all(24),
              child: AppLoadingIndicator(),
            )
          : _isEditing
          ? _buildEditForm(context)
          : _buildProfileView(context),
    );
  }

  Widget _buildProfileView(BuildContext context) {
    final user = _session?.user;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Semantics(
            header: true,
            child: Text(
              context.l10n.profileTitle,
              style: AppTheme.heading2.copyWith(color: AppTheme.primary),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            context.l10n.profileSubtitle,
            style: AppTheme.body.copyWith(color: context.appColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),

        if (_error != null) ...[
          Center(
            child: Semantics(
   liveRegion: true,
   child: Text(
               _error!,
               style: AppTheme.body.copyWith(color: AppTheme.error),
               textAlign: TextAlign.center,
             ),
 ),
          ),
          const SizedBox(height: 12),
        ],

        if (_success != null) ...[
          Center(
            child: Text(
              _success!,
              style: AppTheme.body.copyWith(color: AppTheme.primary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
        ],

        if (user != null) ...[
          _buildProfileFieldView(
            context,
            label: context.l10n.profileRole(_session!.user.role),
            value:
                '${_displayValue(user.firstName)} ${_displayValue(user.lastName)}'
                    .replaceAll('— —', '—'),
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
          _buildProfileFieldView(
            context,
            label: context.l10n.profileEmail,
            value: _displayValue(user.email),
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 12),
          _buildProfileFieldView(
            context,
            label: context.l10n.profileBirthdate,
            value: _displayValue(user.birthdate),
            icon: Icons.calendar_today_outlined,
          ),
          const SizedBox(height: 12),
          _buildProfileFieldView(
            context,
            label: context.l10n.profileGender,
            value: _displayValue(user.gender),
            icon: Icons.badge_outlined,
          ),
          const SizedBox(height: 24),
        ],

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _loading || _saving
                ? null
                : () {
                    setState(() {
                      _isEditing = true;
                      _error = null;
                      _success = null;
                    });
                  },
            child: Text(context.l10n.profileEditInformation),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileFieldView(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    bool emphasizeValue = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.appColors.divider.withValues(alpha: 0.8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.captions.copyWith(
                    color: context.appColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Semantics(
                  header: true,
                  child: Text(
                    value,
                    style: (emphasizeValue ? AppTheme.heading3 : AppTheme.body)
                        .copyWith(color: context.appColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            header: true,
            child: Text(
              context.l10n.profileTitle,
              style: AppTheme.heading2.copyWith(color: AppTheme.primary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.profileSubtitle,
            style: AppTheme.body.copyWith(color: context.appColors.textMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          if (_error != null) ...[
            Semantics(

              liveRegion: true,

              child: Text(

                          _error!,

                          style: AppTheme.body.copyWith(color: AppTheme.error),

                          textAlign: TextAlign.center,

                        ),

            ),
            const SizedBox(height: 12),
          ],

          if (_success != null) ...[
            Text(
              _success!,
              style: AppTheme.body.copyWith(color: AppTheme.primary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
          ],

          if (_session != null) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                context.l10n.profileRole(_session!.user.role),
                style: AppTheme.body.copyWith(
                  color: context.appColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          TextFormField(
            controller: _firstNameController,
            enabled: !_saving,
            decoration: InputDecoration(
              labelText: context.l10n.profileFirstName,
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if ((value ?? '').trim().isEmpty) {
                return context.l10n.profileFirstNameRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _lastNameController,
            enabled: !_saving,
            decoration: InputDecoration(
              labelText: context.l10n.profileLastName,
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if ((value ?? '').trim().isEmpty) {
                return context.l10n.profileLastNameRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _emailController,
            enabled: !_saving,
            decoration: InputDecoration(
              labelText: context.l10n.profileEmail,
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              final text = (value ?? '').trim();
              if (text.isEmpty) {
                return context.l10n.profileEmailRequired;
              }
              if (!text.contains('@')) {
                return context.l10n.profileEmailInvalid;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _birthdateController,
            readOnly: true,
            enabled: !_saving,
            decoration: InputDecoration(
              labelText: context.l10n.profileBirthdate,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                tooltip: context.l10n.tooltipPickDate,
                onPressed: _saving ? null : _pickBirthdate,
              ),
            ),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _genderController,
            enabled: !_saving,
            decoration: InputDecoration(
              labelText: context.l10n.profileGender,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _saving ? null : _cancelEditing,
                  child: Text(context.l10n.commonCancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saving ? null : _saveProfile,
                  child: _saving
                      ? const AppLoadingIndicator.inline(size: 18)
                      : Text(context.l10n.profileSaveChanges),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
