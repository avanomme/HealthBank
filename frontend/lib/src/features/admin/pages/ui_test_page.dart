// Created with the Assistance of Claude Code and ChatGPT
// Copyright-free images by Pexels
// frontend/lib/src/features/admin/pages/ui_test_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/basics/app_accordion.dart';
import 'package:frontend/src/core/widgets/basics/app_breadcrumbs.dart';
import 'package:frontend/src/core/widgets/basics/app_dropdown_menu.dart';
import 'package:frontend/src/core/widgets/basics/app_image.dart';
import 'package:frontend/src/core/widgets/basics/app_modal.dart';
import 'package:frontend/src/core/widgets/basics/app_placeholder_graphic.dart';
import 'package:frontend/src/core/widgets/basics/app_section_navbar.dart';
import 'package:frontend/src/core/widgets/basics/healthbank_logo.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/core/widgets/data_display/app_bar_chart.dart';
import 'package:frontend/src/core/widgets/data_display/app_card_task.dart';
import 'package:frontend/src/core/widgets/data_display/app_graph_renderer.dart';
import 'package:frontend/src/core/widgets/data_display/app_pie_chart.dart';
import 'package:frontend/src/core/widgets/data_display/app_progress_bar.dart';
import 'package:frontend/src/core/widgets/data_display/app_stat_card.dart';
import 'package:frontend/src/core/widgets/data_display/data_table.dart'
    as custom;
import 'package:frontend/src/core/widgets/data_display/data_table_cell.dart';
import 'package:frontend/src/core/widgets/feedback/feedback.dart';
import 'package:frontend/src/core/widgets/forms/forms.dart';
import 'package:frontend/src/core/widgets/micro/micro.dart';
import 'package:frontend/src/core/l10n/l10n.dart';
import 'package:frontend/src/features/admin/widgets/widgets.dart';

/// UI Test page - interactive widget catalogue with live customization.
class UiTestPage extends StatefulWidget {
  const UiTestPage({super.key});

  @override
  State<UiTestPage> createState() => _UiTestPageState();
}

class _UiTestPageState extends State<UiTestPage> {
  // ── AppText ──
  AppTextVariant _textVariant = AppTextVariant.bodyMedium;
  Color _textColor = AppTheme.textPrimary;
  FontWeight _textFontWeight = FontWeight.normal;

  // ── AppRichText ──
  AppTextVariant _richTextVariant = AppTextVariant.bodyMedium;

  // ── AppBadge ──
  AppBadgeVariant _badgeVariant = AppBadgeVariant.neutral;
  AppBadgeSize _badgeSize = AppBadgeSize.medium;

  // ── AppIcon ──
  Color _iconColor = AppTheme.primary;
  String _selectedIcon = 'health_and_safety';

  // ── AppStatusDot ──
  bool _statusNotification = true;

  // ── AppDivider ──
  double _dividerThickness = 1;
  double _dividerSpacing = 16;

  // ── AppCheckbox ──
  bool? _checkboxValue = true;
  bool _checkboxTristate = false;
  bool _checkboxEnabled = true;

  // ── AppRadio ──
  String _radioValue = 'option1';
  bool _radioEnabled = true;

  // ── AppFilledButton ──
  Color _filledBtnColor = AppTheme.primary;
  bool _filledBtnDisabled = false;

  // ── AppTextButton ──
  Color _textBtnColor = AppTheme.primary;
  bool _textBtnDisabled = false;

  // ── AppLongButton ──
  Color _longBtnColor = AppTheme.primary;
  bool _longBtnDisabled = false;

  // ── AppAnnouncement ──
  Color _announcementBg = AppTheme.primary;
  Color _announcementText = AppTheme.textContrast;
  bool _announcementShowIcon = true;

  // ── AppPopover ──
  Color _popoverBg = AppTheme.primary;
  Color _popoverText = AppTheme.textContrast;
  bool _popoverShowIcon = true;
  bool _popoverArrowOnTop = true;

  // ── DataTable ──
  int? _expandedTableRow;

  // ── AppBarChart ──
  Color _barChartColor = AppTheme.primary;
  bool _barChartShowValues = true;

  // ── AppPieChart ──
  bool _pieChartShowLegend = true;

  // ── AppStatCard ──
  Color _statCardColor = AppTheme.primary;
  bool _statCardShowIcon = true;
  bool _statCardShowSubtitle = true;

  // ── HealthBankLogo ──
  HealthBankLogoSize _logoSize = HealthBankLogoSize.medium;
  bool _logoTagline = false;

  // ── AppAccordion ──
  bool _accordionInitiallyExpanded = false;

  // ── AppBreadcrumbs ──
  int _activeBreadcrumbIndex = 2;

  // ── AppSectionNavbar ──
  int _sectionNavbarSectionSeed = 3;
  int _sectionNavbarSubsectionSeed = 5;
  List<_SectionNavbarEditorSection> _sectionNavbarEditorSections = [];

  // ── AppDropdownMenu ──
  String? _dropdownSelection = 'weekly';

  // ── Forms and Input ──
  bool _textInputEnabled = true;
  bool _textInputRequired = true;
  bool _paragraphInputEnabled = true;
  bool _paragraphInputRequired = true;
  bool _emailInputEnabled = true;
  bool _emailInputRequired = true;
  bool _passwordInputEnabled = true;
  bool _createPasswordInputEnabled = true;
  bool _dateInputEnabled = true;
  bool _dateInputRequired = true;
  bool _timeInputEnabled = true;
  bool _timeInputRequired = true;
  bool _phoneInputEnabled = true;
  bool _phoneInputRequired = true;
  bool _dropdownInputEnabled = true;
  bool _dropdownInputRequired = true;
  DateTime? _formDate = DateTime.now();
  TimeOfDay? _formTime = TimeOfDay.now();
  String? _formDropdownSelection;
  String _formSearchQuery = '';
  String _formPhoneNormalized = '';
  AppPhoneCountry _formPhoneCountry = AppPhoneCountry.commonCountries.first;

  // ── AppProgressBar ──
  double _progressBarValue = 0.6;
  double _progressBarHeight = 10;
  Color _progressBarFillColor = AppTheme.success;
  Color _progressBarTrackColor = const Color(0xFFE5E7EB);

  // ── AppImage ──
  double _appImageAspectRatio = 16 / 9;
  double _appImageWidth = 320;
  double _appImageHeight = 180;
  bool _appImageSetWidth = false;
  bool _appImageSetHeight = false;
  bool _appImageRounded = true;
  BoxFit _appImageFit = BoxFit.cover;
  bool _appImageExcludeSemantics = false;

  // ── AppPlaceholderGraphic ──
  double _placeholderAspectRatio = 4 / 3;
  BoxFit _placeholderFit = BoxFit.cover;
  bool _placeholderRounded = true;
  bool _placeholderExcludeSemantics = false;
  String _placeholderAssetPath = 'assets/placeholder_image.jpg';

  // ── Text controllers ──
  late final TextEditingController _textContentCtrl;
  late final TextEditingController _badgeLabelCtrl;
  late final TextEditingController _announcementMsgCtrl;
  late final TextEditingController _popoverMsgCtrl;
  late final TextEditingController _toastMsgCtrl;
  late final TextEditingController _appImageSemanticLabelCtrl;
  late final TextEditingController _placeholderSemanticLabelCtrl;
  late final TextEditingController _formTextCtrl;
  late final TextEditingController _formParagraphCtrl;
  late final TextEditingController _formEmailCtrl;
  late final TextEditingController _formPasswordCtrl;
  late final TextEditingController _formCreatePasswordCtrl;
  late final TextEditingController _formConfirmPasswordCtrl;
  late final TextEditingController _formPhoneCtrl;
  late final TextEditingController _formSearchCtrl;

  // ── Shared option maps ──
  static final _colorOptions = <String, Color>{
    'primary': AppTheme.primary,
    'secondary': AppTheme.secondary,
    'success': AppTheme.success,
    'error': AppTheme.error,
    'caution': AppTheme.caution,
    'info': AppTheme.info,
    'textPrimary': AppTheme.textPrimary,
    'textMuted': AppTheme.textMuted,
    'textContrast': AppTheme.textContrast,
  };

  static final _iconEntries = <String, IconData>{
    'health_and_safety': Icons.health_and_safety,
    'security': Icons.security,
    'warning_amber': Icons.warning_amber,
    'error_outline': Icons.error_outline,
    'info_outline': Icons.info_outline,
    'check_circle': Icons.check_circle,
    'settings': Icons.settings,
    'person': Icons.person,
    'mail': Icons.mail,
    'star': Icons.star,
  };

  static final _fontWeights = <String, FontWeight>{
    'normal': FontWeight.normal,
    'w500': FontWeight.w500,
    'w600': FontWeight.w600,
    'bold': FontWeight.bold,
  };

  static final _aspectRatioOptions = <double, String>{
    1 / 1: '1:1',
    4 / 3: '4:3',
    3 / 2: '3:2',
    16 / 9: '16:9',
    21 / 9: '21:9',
  };

  static final _fitOptions = <BoxFit, String>{
    BoxFit.cover: 'cover',
    BoxFit.contain: 'contain',
    BoxFit.fill: 'fill',
    BoxFit.fitWidth: 'fitWidth',
    BoxFit.fitHeight: 'fitHeight',
    BoxFit.scaleDown: 'scaleDown',
    BoxFit.none: 'none',
  };

  Map<String, String> get _placeholderAssets => <String, String>{
    'assets/placeholder_image.jpg': context.l10n.uiTestDemoDefaultPlaceholder,
    'assets/example_image.jpg': context.l10n.uiTestDemoExampleImage,
  };

  List<_SectionNavbarEditorSection> _defaultSectionNavbarEditorSections() {
    final l10n = context.l10n;
    return [
      _SectionNavbarEditorSection(
        id: 'section-1',
        label: l10n.uiTestDemoOverview,
        initiallyExpanded: true,
        children: [
          _SectionNavbarEditorItem(id: 'subsection-1', label: l10n.uiTestDemoSummary),
          _SectionNavbarEditorItem(id: 'subsection-2', label: l10n.uiTestDemoKpiTrends),
        ],
      ),
      _SectionNavbarEditorSection(
        id: 'section-2',
        label: l10n.uiTestDemoParticipants,
        initiallyExpanded: false,
        children: [
          _SectionNavbarEditorItem(id: 'subsection-3', label: l10n.uiTestDemoDemographics),
          _SectionNavbarEditorItem(id: 'subsection-4', label: l10n.uiTestDemoEnrollment),
        ],
      ),
    ];
  }

  bool _sectionNavbarInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_sectionNavbarInitialized) {
      _sectionNavbarInitialized = true;
      _sectionNavbarEditorSections = _defaultSectionNavbarEditorSections();
    }
  }

  @override
  void initState() {
    super.initState();
    _textContentCtrl = TextEditingController(text: 'Hello World');
    _badgeLabelCtrl = TextEditingController(text: 'Badge');
    _announcementMsgCtrl = TextEditingController(
      text: 'System maintenance tonight at 9 PM.',
    );
    _popoverMsgCtrl = TextEditingController(
      text: 'Please check the required fields.',
    );
    _toastMsgCtrl = TextEditingController(
      text: 'Operation completed successfully.',
    );
    _appImageSemanticLabelCtrl = TextEditingController(text: 'Example image');
    _placeholderSemanticLabelCtrl = TextEditingController(
      text: 'Placeholder graphic',
    );
    _formTextCtrl = TextEditingController(text: 'Alice Carter');
    _formParagraphCtrl = TextEditingController(
      text: 'Participant notes can be entered here.',
    );
    _formEmailCtrl = TextEditingController(text: 'alice@example.org');
    _formPasswordCtrl = TextEditingController(text: 'Password1!');
    _formCreatePasswordCtrl = TextEditingController();
    _formConfirmPasswordCtrl = TextEditingController();
    _formPhoneCtrl = TextEditingController(text: '5551234567');
    _formSearchCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _textContentCtrl.dispose();
    _badgeLabelCtrl.dispose();
    _announcementMsgCtrl.dispose();
    _popoverMsgCtrl.dispose();
    _toastMsgCtrl.dispose();
    _appImageSemanticLabelCtrl.dispose();
    _placeholderSemanticLabelCtrl.dispose();
    _formTextCtrl.dispose();
    _formParagraphCtrl.dispose();
    _formEmailCtrl.dispose();
    _formPasswordCtrl.dispose();
    _formCreatePasswordCtrl.dispose();
    _formConfirmPasswordCtrl.dispose();
    _formPhoneCtrl.dispose();
    _formSearchCtrl.dispose();
    super.dispose();
  }

  // ── Color name helper ──
  String _colorName(Color c) {
    for (final e in _colorOptions.entries) {
      if (e.value == c) return 'AppTheme.${e.key}';
    }
    return 'AppTheme.primary';
  }

  String _weightName(FontWeight w) {
    for (final e in _fontWeights.entries) {
      if (e.value == w) return 'FontWeight.${e.key}';
    }
    return 'FontWeight.normal';
  }

  void _showPopover(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.08),
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: AppPopover(
          message: _popoverMsgCtrl.text,
          backgroundColor: _popoverBg,
          textColor: _popoverText,
          icon: _popoverShowIcon ? const Icon(Icons.info_outline) : null,
          arrowOnTop: _popoverArrowOnTop,
        ),
      ),
    );
  }

  void _showSecuredModalDemo(BuildContext context) {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AppSecuredModal(
        title: l10n.uiTestDemoCriticalActionTitle,
        body: l10n.uiTestDemoCriticalActionBody,
        passwordLabel: l10n.uiTestDemoAdminPassword,
        invalidPasswordMessage: l10n.uiTestDemoInvalidPasswordMessage,
        verifyPassword: (password) async {
          await Future<void>.delayed(const Duration(milliseconds: 450));
          return password == 'Admin123!';
        },
        onBack: () => Navigator.of(dialogContext).pop(),
        onVerificationSuccess: (_) async {
          Navigator.of(dialogContext).pop();
          if (!mounted) return;
          AppToast.showSuccess(
            context,
            message: l10n.uiTestDemoPasswordVerified,
          );
        },
        onVerificationFailure: (_) async {
          if (!mounted) return;
          AppToast.showError(context, message: l10n.uiTestDemoVerificationFailed);
        },
      ),
    );
  }

  String _fitName(BoxFit fit) {
    for (final e in _fitOptions.entries) {
      if (e.key == fit) return 'BoxFit.${e.value}';
    }
    return 'BoxFit.cover';
  }

  // ── Control builders ──
  Widget _control(String label, Widget input) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, bottom: 4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stackControl = constraints.maxWidth < 360;

          if (stackControl) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: context.appColors.textMuted,
                  ),
                ),
                const SizedBox(height: 6),
                input,
              ],
            );
          }

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: context.appColors.textMuted,
                ),
              ),
              const SizedBox(width: 8),
              input,
            ],
          );
        },
      ),
    );
  }

  Widget _enumDropdown<T>(
    T value,
    Map<T, String> items,
    ValueChanged<T> onChanged,
  ) {
    return DropdownButton<T>(
      value: value,
      isDense: true,
      underline: const SizedBox.shrink(),
      style: TextStyle(fontSize: 13, color: context.appColors.textPrimary),
      items: items.entries
          .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }

  Widget _colorDropdown(Color value, ValueChanged<Color> onChanged) {
    final safeValue = _colorOptions.containsValue(value)
        ? value
        : AppTheme.primary;
    return DropdownButton<Color>(
      value: safeValue,
      isDense: true,
      underline: const SizedBox.shrink(),
      items: _colorOptions.entries
          .map(
            (e) => DropdownMenuItem(
              value: e.value,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: e.value,
                      shape: BoxShape.circle,
                      border: Border.all(color: context.appColors.divider, width: 0.5),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    e.key,
                    style: TextStyle(
                      fontSize: 13,
                      color: context.appColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }

  Widget _toggle(bool value, ValueChanged<bool> onChanged) {
    return Transform.scale(
      scale: 0.8,
      child: Switch(
        value: value,
        onChanged: onChanged,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _textField(TextEditingController controller, VoidCallback onChanged) {
    return SizedBox(
      width: 200,
      height: 32,
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          isDense: true,
          hintText: context.l10n.uiTestEnterValue,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        ),
        onChanged: (_) => onChanged(),
      ),
    );
  }

  List<AppSectionNavbarSection> _buildSectionNavbarSections() {
    return _sectionNavbarEditorSections.map((section) {
      final resolvedSectionLabel = _resolvedSectionLabel(section.label);

      return AppSectionNavbarSection(
        id: section.id,
        label: resolvedSectionLabel,
        destinationId: 'destination-${section.id}',
        initiallyExpanded: section.initiallyExpanded,
        children: section.children.map((subsection) {
          return AppSectionNavbarItem(
            label: _resolvedSubsectionLabel(subsection.label),
            destinationId: 'destination-${section.id}-${subsection.id}',
          );
        }).toList(),
      );
    }).toList();
  }

  String _resolvedSectionLabel(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? context.l10n.uiTestSectionNavbarUntitledSection : trimmed;
  }

  String _resolvedSubsectionLabel(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? context.l10n.uiTestSectionNavbarUntitledSubsection : trimmed;
  }

  String _escapeCodeString(String value) {
    return value.replaceAll(r'\', r'\\').replaceAll("'", r"\'");
  }

  String _buildSectionNavbarCode(List<AppSectionNavbarSection> sections) {
    final buffer = StringBuffer()
      ..writeln('AppSectionNavbar(')
      ..writeln('  activeDestinationId: activeDestinationId,')
      ..writeln('  sections: [');

    for (final section in sections) {
      buffer
        ..writeln('    AppSectionNavbarSection(')
        ..writeln("      id: '${_escapeCodeString(section.id)}',")
        ..writeln("      label: '${_escapeCodeString(section.label)}',")
        ..writeln(
          "      destinationId: '${_escapeCodeString(section.destinationId)}',",
        )
        ..writeln('      initiallyExpanded: ${section.initiallyExpanded},');

      if (section.children.isEmpty) {
        buffer.writeln('      children: const [],');
      } else {
        buffer.writeln('      children: [');
        for (final child in section.children) {
          buffer
            ..writeln('        AppSectionNavbarItem(')
            ..writeln("          label: '${_escapeCodeString(child.label)}',")
            ..writeln(
              "          destinationId: '${_escapeCodeString(child.destinationId)}',",
            )
            ..writeln('        ),');
        }
        buffer.writeln('      ],');
      }

      buffer.writeln('    ),');
    }

    buffer
      ..writeln('  ],')
      ..writeln('  onDestinationTap: (destinationId) {')
      ..writeln('    // Scroll the in-page content area to destinationId.')
      ..writeln('  },')
      ..write(')');

    return buffer.toString();
  }

  void _addSectionNavbarSection() {
    setState(() {
      final sectionId = 'section-${_sectionNavbarSectionSeed++}';
      final subsectionId = 'subsection-${_sectionNavbarSubsectionSeed++}';
      _sectionNavbarEditorSections = [
        ..._sectionNavbarEditorSections,
        _SectionNavbarEditorSection(
          id: sectionId,
          label: context.l10n.uiTestSectionNavbarSectionN('${_sectionNavbarEditorSections.length + 1}'),
          initiallyExpanded: true,
          children: [
            _SectionNavbarEditorItem(id: subsectionId, label: context.l10n.uiTestSectionNavbarSubsection1),
          ],
        ),
      ];
    });
  }

  void _removeSectionNavbarSection(String sectionId) {
    if (_sectionNavbarEditorSections.length <= 1) return;

    setState(() {
      _sectionNavbarEditorSections = _sectionNavbarEditorSections
          .where((section) => section.id != sectionId)
          .toList();
    });
  }

  void _updateSectionNavbarSectionLabel(String sectionId, String value) {
    setState(() {
      _sectionNavbarEditorSections = _sectionNavbarEditorSections.map((
        section,
      ) {
        if (section.id != sectionId) return section;
        return section.copyWith(label: value);
      }).toList();
    });
  }

  void _toggleSectionNavbarSectionExpansion(String sectionId, bool value) {
    setState(() {
      _sectionNavbarEditorSections = _sectionNavbarEditorSections.map((
        section,
      ) {
        if (section.id != sectionId) return section;
        return section.copyWith(initiallyExpanded: value);
      }).toList();
    });
  }

  void _addSectionNavbarSubsection(String sectionId) {
    setState(() {
      _sectionNavbarEditorSections = _sectionNavbarEditorSections.map((
        section,
      ) {
        if (section.id != sectionId) return section;

        return section.copyWith(
          children: [
            ...section.children,
            _SectionNavbarEditorItem(
              id: 'subsection-${_sectionNavbarSubsectionSeed++}',
              label: context.l10n.uiTestSectionNavbarSubsectionN('${section.children.length + 1}'),
            ),
          ],
        );
      }).toList();
    });
  }

  void _removeSectionNavbarSubsection(String sectionId, String subsectionId) {
    setState(() {
      _sectionNavbarEditorSections = _sectionNavbarEditorSections.map((
        section,
      ) {
        if (section.id != sectionId) return section;

        return section.copyWith(
          children: section.children
              .where((subsection) => subsection.id != subsectionId)
              .toList(),
        );
      }).toList();
    });
  }

  void _updateSectionNavbarSubsectionLabel(
    String sectionId,
    String subsectionId,
    String value,
  ) {
    setState(() {
      _sectionNavbarEditorSections = _sectionNavbarEditorSections.map((
        section,
      ) {
        if (section.id != sectionId) return section;

        return section.copyWith(
          children: section.children.map((subsection) {
            if (subsection.id != subsectionId) return subsection;
            return subsection.copyWith(label: value);
          }).toList(),
        );
      }).toList();
    });
  }

  void _resetSectionNavbarDemo() {
    setState(() {
      _sectionNavbarSectionSeed = 3;
      _sectionNavbarSubsectionSeed = 5;
      _sectionNavbarEditorSections = _defaultSectionNavbarEditorSections();
    });
  }

  Widget _buildSectionNavbarControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppFilledButton(
              label: context.l10n.uiTestSectionNavbarAddSection,
              onPressed: _addSectionNavbarSection,
            ),
            AppTextButton(label: context.l10n.uiTestSectionNavbarReset, onPressed: _resetSectionNavbarDemo),
          ],
        ),
        const SizedBox(height: 12),
        ..._sectionNavbarEditorSections.asMap().entries.map((entry) {
          final index = entry.key;
          final section = entry.value;
          final canRemoveSection = _sectionNavbarEditorSections.length > 1;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.appColors.surfaceRaised,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.appColors.divider),
              boxShadow: context.appColors.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppText(
                      context.l10n.uiTestSectionNavbarSectionN('${index + 1}'),
                      variant: AppTextVariant.bodyLarge,
                      fontWeight: FontWeight.w600,
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: context.l10n.uiTestSectionNavbarRemoveSection,
                      onPressed: canRemoveSection
                          ? () => _removeSectionNavbarSection(section.id)
                          : null,
                      icon: const Icon(Icons.delete_outline, size: 18),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                TextFormField(
                  key: ValueKey('section-label-${section.id}'),
                  initialValue: section.label,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: context.l10n.uiTestSectionNavbarSectionLabel,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) =>
                      _updateSectionNavbarSectionLabel(section.id, value),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    AppText(
                      context.l10n.uiTestSectionNavbarInitiallyExpanded,
                      variant: AppTextVariant.bodySmall,
                      color: context.appColors.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Switch(
                      value: section.initiallyExpanded,
                      onChanged: (value) =>
                          _toggleSectionNavbarSectionExpansion(
                            section.id,
                            value,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ...section.children.map((subsection) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            key: ValueKey(
                              'subsection-label-${section.id}-${subsection.id}',
                            ),
                            initialValue: subsection.label,
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: context.l10n.uiTestSectionNavbarSubsectionLabel,
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (value) =>
                                _updateSectionNavbarSubsectionLabel(
                                  section.id,
                                  subsection.id,
                                  value,
                                ),
                          ),
                        ),
                        IconButton(
                          tooltip: context.l10n.uiTestSectionNavbarRemoveSubsection,
                          onPressed: () => _removeSectionNavbarSubsection(
                            section.id,
                            subsection.id,
                          ),
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            size: 18,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  );
                }),
                AppTextButton(
                  label: context.l10n.uiTestSectionNavbarAddSubsection,
                  onPressed: () => _addSectionNavbarSubsection(section.id),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final sectionNavbarSections = _buildSectionNavbarSections();
    final items = _buildPageItems(context, sectionNavbarSections);
    return AdminScaffold(
      currentRoute: '/admin/ui-test',
      scrollable: false,
      child: ListView.builder(
        key: const Key('ui_test_page_list'),
        padding: const EdgeInsets.only(bottom: 32),
        itemCount: items.length,
        itemBuilder: (_, i) => items[i],
      ),
    );
  }

  List<Widget> _buildPageItems(
    BuildContext context,
    List<AppSectionNavbarSection> sectionNavbarSections,
  ) {
    return [
          Semantics(
            header: true,
            child: Text(
              context.l10n.uiTestPageTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.uiTestPageSubtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: context.appColors.textMuted),
          ),
          const SizedBox(height: 32),

          // ═══════════════════════════════════
          // MICRO WIDGETS
          // ═══════════════════════════════════
          _SectionHeader(title: context.l10n.uiTestSectionMicro),
          const SizedBox(height: 16),

          // ── AppText ──
          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppText,
            description: context.l10n.uiTestWidgetAppTextDesc,
            code:
                'AppText(\n'
                "  '${_textContentCtrl.text}',\n"
                '  variant: AppTextVariant.${_textVariant.name},\n'
                '  color: ${_colorName(_textColor)},\n'
                '  fontWeight: ${_weightName(_textFontWeight)},\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlText,
                  _textField(_textContentCtrl, () => setState(() {})),
                ),
                _control(
                  context.l10n.uiTestControlVariant,
                  _enumDropdown<AppTextVariant>(_textVariant, {
                    for (final v in AppTextVariant.values) v: v.name,
                  }, (v) => setState(() => _textVariant = v)),
                ),
                _control(
                  context.l10n.uiTestControlColor,
                  _colorDropdown(
                    _textColor,
                    (c) => setState(() => _textColor = c),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlWeight,
                  _enumDropdown<FontWeight>(_textFontWeight, {
                    for (final e in _fontWeights.entries) e.value: e.key,
                  }, (w) => setState(() => _textFontWeight = w)),
                ),
              ],
            ),
            child: AppText(
              _textContentCtrl.text,
              variant: _textVariant,
              color: _textColor,
              fontWeight: _textFontWeight,
            ),
          ),

          // ── AppRichText ──
          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppRichText,
            description: context.l10n.uiTestWidgetAppRichTextDesc,
            code:
                'AppRichText(\n'
                '  variant: AppTextVariant.${_richTextVariant.name},\n'
                '  text: TextSpan(\n'
                "    text: 'This is ',\n"
                '    children: [\n'
                "      TextSpan(text: 'bold', style: TextStyle(fontWeight: FontWeight.w700)),\n"
                "      TextSpan(text: ' and '),\n"
                "      TextSpan(text: 'italic', style: TextStyle(fontStyle: FontStyle.italic)),\n"
                '    ],\n'
                '  ),\n'
                ')',
            controls: Wrap(
              children: [
                _control(
                  context.l10n.uiTestControlVariant,
                  _enumDropdown<AppTextVariant>(_richTextVariant, {
                    for (final v in AppTextVariant.values) v: v.name,
                  }, (v) => setState(() => _richTextVariant = v)),
                ),
              ],
            ),
            child: AppRichText(
              variant: _richTextVariant,
              text: TextSpan(
                text: 'This is ',
                children: [
                  TextSpan(
                    text: 'bold',
                    style: AppTheme.body.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'italic',
                    style: AppTheme.body.copyWith(fontStyle: FontStyle.italic),
                  ),
                  const TextSpan(text: ' text.'),
                ],
              ),
            ),
          ),

          // ── AppBadge ──
          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppBadge,
            description: context.l10n.uiTestWidgetAppBadgeDesc,
            code:
                'AppBadge(\n'
                "  label: '${_badgeLabelCtrl.text}',\n"
                '  variant: AppBadgeVariant.${_badgeVariant.name},\n'
                '  size: AppBadgeSize.${_badgeSize.name},\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlLabel,
                  _textField(_badgeLabelCtrl, () => setState(() {})),
                ),
                _control(
                  context.l10n.uiTestControlVariant,
                  _enumDropdown<AppBadgeVariant>(_badgeVariant, {
                    for (final v in AppBadgeVariant.values) v: v.name,
                  }, (v) => setState(() => _badgeVariant = v)),
                ),
                _control(
                  context.l10n.uiTestControlSize,
                  _enumDropdown<AppBadgeSize>(_badgeSize, {
                    for (final v in AppBadgeSize.values) v: v.name,
                  }, (v) => setState(() => _badgeSize = v)),
                ),
              ],
            ),
            child: AppBadge(
              label: _badgeLabelCtrl.text,
              variant: _badgeVariant,
              size: _badgeSize,
            ),
          ),

          // ── AppIcon ──
          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppIcon,
            description: context.l10n.uiTestWidgetAppIconDesc,
            code:
                'AppIcon(\n'
                '  Icons.$_selectedIcon,\n'
                '  color: ${_colorName(_iconColor)},\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlIcon,
                  DropdownButton<String>(
                    value: _selectedIcon,
                    isDense: true,
                    underline: const SizedBox.shrink(),
                    items: _iconEntries.entries
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.key,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(e.value, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  e.key,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: context.appColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedIcon = v);
                    },
                  ),
                ),
                _control(
                  context.l10n.uiTestControlColor,
                  _colorDropdown(
                    _iconColor,
                    (c) => setState(() => _iconColor = c),
                  ),
                ),
              ],
            ),
            child: AppIcon(_iconEntries[_selectedIcon]!, color: _iconColor),
          ),

          // ── AppStatusDot ──
          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppStatusDot,
            description: context.l10n.uiTestWidgetAppStatusDotDesc,
            code:
                'AppStatusDot(\n'
                '  icon: AppIcon(Icons.mail, color: AppTheme.primary),\n'
                '  hasNotification: $_statusNotification,\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlNotification,
                  _toggle(
                    _statusNotification,
                    (v) => setState(() => _statusNotification = v),
                  ),
                ),
              ],
            ),
            child: AppStatusDot(
              icon: const AppIcon(Icons.mail, color: AppTheme.primary),
              hasNotification: _statusNotification,
            ),
          ),

          // ── AppDivider ──
          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppDivider,
            description: context.l10n.uiTestWidgetAppDividerDesc,
            code:
                'AppDivider(\n'
                '  thickness: ${_dividerThickness.toStringAsFixed(0)},\n'
                '  spacing: ${_dividerSpacing.toStringAsFixed(0)},\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlThickness(_dividerThickness.toStringAsFixed(0)),
                  SizedBox(
                    width: 120,
                    child: Slider(
                      value: _dividerThickness,
                      min: 1,
                      max: 8,
                      divisions: 7,
                      onChanged: (v) => setState(() => _dividerThickness = v),
                    ),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlSpacing(_dividerSpacing.toStringAsFixed(0)),
                  SizedBox(
                    width: 120,
                    child: Slider(
                      value: _dividerSpacing,
                      min: 0,
                      max: 40,
                      divisions: 8,
                      onChanged: (v) => setState(() => _dividerSpacing = v),
                    ),
                  ),
                ),
              ],
            ),
            child: Column(
              children: [
                AppText(context.l10n.uiTestDemoAboveDivider),
                AppDivider(
                  thickness: _dividerThickness,
                  spacing: _dividerSpacing,
                ),
                AppText(context.l10n.uiTestDemoBelowDivider),
              ],
            ),
          ),

          // ── AppCheckbox ──
          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppCheckbox,
            description: context.l10n.uiTestWidgetAppCheckboxDesc,
            code:
                'AppCheckbox(\n'
                '  value: ${_checkboxTristate ? _checkboxValue : (_checkboxValue ?? false)},\n'
                '  tristate: $_checkboxTristate,\n'
                '  enabled: $_checkboxEnabled,\n'
                '  onChanged: (value) => setState(() => isChecked = value),\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlTristate,
                  _toggle(_checkboxTristate, (v) {
                    setState(() {
                      _checkboxTristate = v;
                      if (!v && _checkboxValue == null) _checkboxValue = false;
                    });
                  }),
                ),
                _control(
                  context.l10n.uiTestControlEnabled,
                  _toggle(
                    _checkboxEnabled,
                    (v) => setState(() => _checkboxEnabled = v),
                  ),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppCheckbox(
                  value: _checkboxTristate
                      ? _checkboxValue
                      : (_checkboxValue ?? false),
                  tristate: _checkboxTristate,
                  enabled: _checkboxEnabled,
                  onChanged: _checkboxEnabled
                      ? (v) => setState(() => _checkboxValue = v)
                      : null,
                ),
                const SizedBox(width: 8),
                AppText(
                  context.l10n.uiTestDemoValuePrefix(_checkboxValue?.toString() ?? context.l10n.uiTestDemoNullIndeterminate),
                  variant: AppTextVariant.bodySmall,
                  color: context.appColors.textMuted,
                ),
              ],
            ),
          ),

          // ── AppRadio ──
          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppRadio,
            description: context.l10n.uiTestWidgetAppRadioDesc,
            code:
                "AppRadio<String>(\n"
                "  value: 'option1',\n"
                "  groupValue: '$_radioValue',\n"
                '  enabled: $_radioEnabled,\n'
                '  onChanged: (value) => setState(() => selected = value),\n'
                ')',
            controls: Wrap(
              children: [
                _control(
                  context.l10n.uiTestControlEnabled,
                  _toggle(
                    _radioEnabled,
                    (v) => setState(() => _radioEnabled = v),
                  ),
                ),
              ],
            ),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final opt in ['option1', 'option2', 'option3'])
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppRadio<String>(
                        value: opt,
                        groupValue: _radioValue,
                        enabled: _radioEnabled,
                        onChanged: (v) =>
                            setState(() => _radioValue = v ?? _radioValue),
                      ),
                      AppText(opt, variant: AppTextVariant.bodySmall),
                    ],
                  ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ═══════════════════════════════════
          // BUTTONS
          // ═══════════════════════════════════
          _SectionHeader(title: context.l10n.uiTestSectionButtons),
          const SizedBox(height: 16),

          // ── AppFilledButton ──
          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppFilledButton,
            description: context.l10n.uiTestWidgetAppFilledButtonDesc,
            code:
                'AppFilledButton(\n'
                "  label: 'Click Me',\n"
                '  backgroundColor: ${_colorName(_filledBtnColor)},\n'
                '  onPressed: ${_filledBtnDisabled ? 'null' : '() {}'},\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlColor,
                  _colorDropdown(
                    _filledBtnColor,
                    (c) => setState(() => _filledBtnColor = c),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlDisabled,
                  _toggle(
                    _filledBtnDisabled,
                    (v) => setState(() => _filledBtnDisabled = v),
                  ),
                ),
              ],
            ),
            child: AppFilledButton(
              label: context.l10n.uiTestDemoClickMe,
              backgroundColor: _filledBtnColor,
              onPressed: _filledBtnDisabled ? null : () {},
            ),
          ),

          // ── AppTextButton ──
          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppTextButton,
            description: context.l10n.uiTestWidgetAppTextButtonDesc,
            code:
                'AppTextButton(\n'
                "  label: 'Learn more',\n"
                '  textColor: ${_colorName(_textBtnColor)},\n'
                '  onPressed: ${_textBtnDisabled ? 'null' : '() {}'},\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlColor,
                  _colorDropdown(
                    _textBtnColor,
                    (c) => setState(() => _textBtnColor = c),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlDisabled,
                  _toggle(
                    _textBtnDisabled,
                    (v) => setState(() => _textBtnDisabled = v),
                  ),
                ),
              ],
            ),
            child: AppTextButton(
              label: context.l10n.uiTestDemoLearnMore,
              textColor: _textBtnColor,
              onPressed: _textBtnDisabled ? null : () {},
            ),
          ),

          // ── AppLongButton ──
          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppLongButton,
            description: context.l10n.uiTestWidgetAppLongButtonDesc,
            code:
                'AppLongButton(\n'
                "  label: 'Continue',\n"
                '  backgroundColor: ${_colorName(_longBtnColor)},\n'
                '  onPressed: ${_longBtnDisabled ? 'null' : '() {}'},\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlColor,
                  _colorDropdown(
                    _longBtnColor,
                    (c) => setState(() => _longBtnColor = c),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlDisabled,
                  _toggle(
                    _longBtnDisabled,
                    (v) => setState(() => _longBtnDisabled = v),
                  ),
                ),
              ],
            ),
            child: AppLongButton(
              label: context.l10n.uiTestDemoContinue,
              backgroundColor: _longBtnColor,
              onPressed: _longBtnDisabled ? null : () {},
            ),
          ),

          const SizedBox(height: 32),

          // ═══════════════════════════════════
          // FEEDBACK
          // ═══════════════════════════════════
          _SectionHeader(title: context.l10n.uiTestSectionFeedback),
          const SizedBox(height: 16),

          // ── AppAnnouncement ──
          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppAnnouncement,
            description: context.l10n.uiTestWidgetAppAnnouncementDesc,
            code:
                'AppAnnouncement(\n'
                "  message: '${_announcementMsgCtrl.text}',\n"
                '  backgroundColor: ${_colorName(_announcementBg)},\n'
                '  textColor: ${_colorName(_announcementText)},\n'
                '  icon: ${_announcementShowIcon ? 'Icon(Icons.announcement_outlined)' : 'null'},\n'
                '  onTap: () {},\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlMessage,
                  _textField(_announcementMsgCtrl, () => setState(() {})),
                ),
                _control(
                  context.l10n.uiTestControlBackground,
                  _colorDropdown(
                    _announcementBg,
                    (c) => setState(() => _announcementBg = c),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlText,
                  _colorDropdown(
                    _announcementText,
                    (c) => setState(() => _announcementText = c),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlIcon,
                  _toggle(
                    _announcementShowIcon,
                    (v) => setState(() => _announcementShowIcon = v),
                  ),
                ),
              ],
            ),
            child: AppAnnouncement(
              message: _announcementMsgCtrl.text,
              backgroundColor: _announcementBg,
              textColor: _announcementText,
              icon: _announcementShowIcon
                  ? const Icon(Icons.announcement_outlined)
                  : null,
              onTap: () {},
            ),
          ),

          // ── AppPopover ──
          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppPopover,
            description: context.l10n.uiTestWidgetAppPopoverDesc,
            code:
                'AppFilledButton(\n'
                "  label: 'Show popover',\n"
                '  onPressed: () => _showPopover(context),\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlMessage,
                  _textField(_popoverMsgCtrl, () => setState(() {})),
                ),
                _control(
                  context.l10n.uiTestControlBackground,
                  _colorDropdown(
                    _popoverBg,
                    (c) => setState(() => _popoverBg = c),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlText,
                  _colorDropdown(
                    _popoverText,
                    (c) => setState(() => _popoverText = c),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlIcon,
                  _toggle(
                    _popoverShowIcon,
                    (v) => setState(() => _popoverShowIcon = v),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlArrowTop,
                  _toggle(
                    _popoverArrowOnTop,
                    (v) => setState(() => _popoverArrowOnTop = v),
                  ),
                ),
              ],
            ),
            child: AppFilledButton(
              label: context.l10n.uiTestDemoShowPopover,
              onPressed: () => _showPopover(context),
            ),
          ),

          // ── AppToast ──
          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppToast,
            description: context.l10n.uiTestWidgetAppToastDesc,
            code:
                'AppToast.showSuccess(\n'
                '  context,\n'
                "  message: '${_toastMsgCtrl.text}',\n"
                '  duration: Duration(seconds: 4),\n'
                ');',
            controls: Wrap(
              children: [
                _control(
                  context.l10n.uiTestControlMessage,
                  _textField(_toastMsgCtrl, () => setState(() {})),
                ),
              ],
            ),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                AppFilledButton(
                  label: context.l10n.uiTestDemoSuccess,
                  backgroundColor: AppTheme.success,
                  onPressed: () => AppToast.showSuccess(
                    context,
                    message: _toastMsgCtrl.text,
                  ),
                ),
                AppFilledButton(
                  label: context.l10n.uiTestDemoError,
                  backgroundColor: AppTheme.error,
                  onPressed: () =>
                      AppToast.showError(context, message: _toastMsgCtrl.text),
                ),
                AppFilledButton(
                  label: context.l10n.uiTestDemoCaution,
                  backgroundColor: AppTheme.caution,
                  textColor: context.appColors.textPrimary,
                  onPressed: () => AppToast.showCaution(
                    context,
                    message: _toastMsgCtrl.text,
                  ),
                ),
                AppFilledButton(
                  label: context.l10n.uiTestDemoInfo,
                  backgroundColor: AppTheme.info,
                  onPressed: () =>
                      AppToast.showInfo(context, message: _toastMsgCtrl.text),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ═══════════════════════════════════
          // FORMS AND INPUT
          // ═══════════════════════════════════
          _SectionHeader(title: context.l10n.uiTestSectionForms),
          const SizedBox(height: 16),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppTextInput,
            description: context.l10n.uiTestWidgetAppTextInputDesc,
            code:
                'AppTextInput(\n'
                "  label: 'Full Name',\n"
                '  controller: controller,\n'
                '  enabled: $_textInputEnabled,\n'
                '  isRequired: $_textInputRequired,\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlEnabled,
                  _toggle(
                    _textInputEnabled,
                    (v) => setState(() => _textInputEnabled = v),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlRequired,
                  _toggle(
                    _textInputRequired,
                    (v) => setState(() => _textInputRequired = v),
                  ),
                ),
              ],
            ),
            child: SizedBox(
              width: 420,
              child: AppTextInput(
                label: context.l10n.uiTestDemoFullName,
                controller: _formTextCtrl,
                enabled: _textInputEnabled,
                isRequired: _textInputRequired,
              ),
            ),
          ),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppParagraphInput,
            description: context.l10n.uiTestWidgetAppParagraphInputDesc,
            code:
                'AppParagraphInput(\n'
                "  label: 'Notes',\n"
                '  controller: controller,\n'
                '  minLines: 3,\n'
                '  maxLines: 6,\n'
                '  enabled: true,\n'
                '  isRequired: true,\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlEnabled,
                  _toggle(
                    _paragraphInputEnabled,
                    (v) => setState(() => _paragraphInputEnabled = v),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlRequired,
                  _toggle(
                    _paragraphInputRequired,
                    (v) => setState(() => _paragraphInputRequired = v),
                  ),
                ),
              ],
            ),
            child: SizedBox(
              width: 520,
              child: AppParagraphInput(
                label: context.l10n.uiTestDemoNotes,
                controller: _formParagraphCtrl,
                minLines: 3,
                maxLines: 6,
                enabled: _paragraphInputEnabled,
                isRequired: _paragraphInputRequired,
              ),
            ),
          ),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppEmailInput,
            description: context.l10n.uiTestWidgetAppEmailInputDesc,
            code:
                'AppEmailInput(\n'
                "  label: 'Email',\n"
                '  controller: controller,\n'
                '  enabled: true,\n'
                '  isRequired: true,\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlEnabled,
                  _toggle(
                    _emailInputEnabled,
                    (v) => setState(() => _emailInputEnabled = v),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlRequired,
                  _toggle(
                    _emailInputRequired,
                    (v) => setState(() => _emailInputRequired = v),
                  ),
                ),
              ],
            ),
            child: SizedBox(
              width: 420,
              child: AppEmailInput(
                label: context.l10n.uiTestDemoEmail,
                controller: _formEmailCtrl,
                enabled: _emailInputEnabled,
                isRequired: _emailInputRequired,
              ),
            ),
          ),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppPasswordInput,
            description: context.l10n.uiTestWidgetAppPasswordInputDesc,
            code:
                'AppPasswordInput(\n'
                "  label: 'Current Password',\n"
                '  controller: controller,\n'
                '  enabled: true,\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlEnabled,
                  _toggle(
                    _passwordInputEnabled,
                    (v) => setState(() => _passwordInputEnabled = v),
                  ),
                ),
              ],
            ),
            child: SizedBox(
              width: 420,
              child: AppPasswordInput(
                label: context.l10n.uiTestDemoCurrentPassword,
                controller: _formPasswordCtrl,
                enabled: _passwordInputEnabled,
              ),
            ),
          ),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppCreateConfirmPassword,
            description: context.l10n.uiTestWidgetAppCreateConfirmPasswordDesc,
            code:
                'Column(\n'
                '  children: [\n'
                "    AppCreatePasswordInput(label: 'Create Password'),\n"
                "    AppConfirmPasswordInput(label: 'Confirm Password'),\n"
                '  ],\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlCreateEnabled,
                  _toggle(
                    _createPasswordInputEnabled,
                    (v) => setState(() => _createPasswordInputEnabled = v),
                  ),
                ),
              ],
            ),
            child: SizedBox(
              width: 520,
              child: Column(
                children: [
                  AppCreatePasswordInput(
                    controller: _formCreatePasswordCtrl,
                    enabled: _createPasswordInputEnabled,
                  ),
                  const SizedBox(height: 12),
                  AppConfirmPasswordInput(
                    controller: _formConfirmPasswordCtrl,
                    createPasswordController: _createPasswordInputEnabled
                        ? _formCreatePasswordCtrl
                        : null,
                  ),
                ],
              ),
            ),
          ),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppDateInput,
            description: context.l10n.uiTestWidgetAppDateInputDesc,
            code:
                'AppDateInput(\n'
                "  label: 'Date of Birth',\n"
                '  value: selectedDate,\n'
                '  enabled: true,\n'
                '  isRequired: true,\n'
                '  onChanged: (value) {},\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlEnabled,
                  _toggle(
                    _dateInputEnabled,
                    (v) => setState(() => _dateInputEnabled = v),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlRequired,
                  _toggle(
                    _dateInputRequired,
                    (v) => setState(() => _dateInputRequired = v),
                  ),
                ),
              ],
            ),
            child: SizedBox(
              width: 320,
              child: AppDateInput(
                label: context.l10n.uiTestDemoDateOfBirth,
                value: _formDate,
                enabled: _dateInputEnabled,
                isRequired: _dateInputRequired,
                onChanged: (value) => setState(() => _formDate = value),
              ),
            ),
          ),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppTimeInput,
            description: context.l10n.uiTestWidgetAppTimeInputDesc,
            code:
                'AppTimeInput(\n'
                "  label: 'Appointment Time',\n"
                '  value: selectedTime,\n'
                '  enabled: true,\n'
                '  isRequired: true,\n'
                '  onChanged: (value) {},\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlEnabled,
                  _toggle(
                    _timeInputEnabled,
                    (v) => setState(() => _timeInputEnabled = v),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlRequired,
                  _toggle(
                    _timeInputRequired,
                    (v) => setState(() => _timeInputRequired = v),
                  ),
                ),
              ],
            ),
            child: SizedBox(
              width: 320,
              child: AppTimeInput(
                label: context.l10n.uiTestDemoAppointmentTime,
                value: _formTime,
                enabled: _timeInputEnabled,
                isRequired: _timeInputRequired,
                onChanged: (value) => setState(() => _formTime = value),
              ),
            ),
          ),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppPhoneInput,
            description: context.l10n.uiTestWidgetAppPhoneInputDesc,
            code:
                'AppPhoneInput(\n'
                "  label: 'Phone Number',\n"
                '  enabled: true,\n'
                '  isRequired: true,\n'
                '  onNormalizedChanged: (value) {},\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlEnabled,
                  _toggle(
                    _phoneInputEnabled,
                    (v) => setState(() => _phoneInputEnabled = v),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlRequired,
                  _toggle(
                    _phoneInputRequired,
                    (v) => setState(() => _phoneInputRequired = v),
                  ),
                ),
              ],
            ),
            child: SizedBox(
              width: 620,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppPhoneInput(
                    label: context.l10n.uiTestDemoPhoneNumber,
                    controller: _formPhoneCtrl,
                    enabled: _phoneInputEnabled,
                    isRequired: _phoneInputRequired,
                    initialCountry: _formPhoneCountry,
                    onCountryChanged: (value) =>
                        setState(() => _formPhoneCountry = value),
                    onNormalizedChanged: (value) =>
                        setState(() => _formPhoneNormalized = value),
                  ),
                  const SizedBox(height: 6),
                  AppText(
                    context.l10n.uiTestDemoNormalizedPrefix(_formPhoneNormalized.isEmpty ? context.l10n.uiTestDemoQueryNone : _formPhoneNormalized),
                    variant: AppTextVariant.bodySmall,
                    color: context.appColors.textMuted,
                  ),
                ],
              ),
            ),
          ),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppDropdownInput,
            description: context.l10n.uiTestWidgetAppDropdownInputDesc,
            code:
                'AppDropdownInput<String>(\n'
                "  label: 'Priority',\n"
                '  options: [...],\n'
                '  value: selected,\n'
                '  enabled: true,\n'
                '  isRequired: true,\n'
                '  onChanged: (value) {},\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlEnabled,
                  _toggle(
                    _dropdownInputEnabled,
                    (v) => setState(() => _dropdownInputEnabled = v),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlRequired,
                  _toggle(
                    _dropdownInputRequired,
                    (v) => setState(() => _dropdownInputRequired = v),
                  ),
                ),
              ],
            ),
            child: SizedBox(
              width: 320,
              child: AppDropdownInput<String>(
                label: context.l10n.uiTestDemoPriority,
                value: _formDropdownSelection,
                enabled: _dropdownInputEnabled,
                isRequired: _dropdownInputRequired,
                options: const [
                  AppDropdownInputOption(label: 'Low', value: 'low'),
                  AppDropdownInputOption(label: 'Medium', value: 'medium'),
                  AppDropdownInputOption(label: 'High', value: 'high'),
                ],
                onChanged: (value) =>
                    setState(() => _formDropdownSelection = value),
              ),
            ),
          ),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppSearchBar,
            description: context.l10n.uiTestWidgetAppSearchBarDesc,
            code:
                'AppSearchBar(\n'
                "  hintText: 'Search widgets...',\n"
                '  controller: controller,\n'
                '  onChanged: (value) {},\n'
                ')',
            child: SizedBox(
              width: 420,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSearchBar(
                    controller: _formSearchCtrl,
                    hintText: context.l10n.uiTestDemoSearchWidgets,
                    onChanged: (value) =>
                        setState(() => _formSearchQuery = value),
                  ),
                  const SizedBox(height: 6),
                  AppText(
                    context.l10n.uiTestDemoQueryPrefix(_formSearchQuery.isEmpty ? context.l10n.uiTestDemoQueryEmpty : _formSearchQuery),
                    variant: AppTextVariant.bodySmall,
                    color: context.appColors.textMuted,
                  ),
                ],
              ),
            ),
          ),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppSecuredModal,
            description: context.l10n.uiTestWidgetAppSecuredModalDesc,
            code:
                'AppFilledButton(\n'
                "  label: 'Open secured modal',\n"
                '  onPressed: () => _showSecuredModalDemo(context),\n'
                ')',
            child: AppFilledButton(
              label: context.l10n.uiTestDemoOpenSecuredModal,
              onPressed: () => _showSecuredModalDemo(context),
            ),
          ),

          const SizedBox(height: 32),

          // ═══════════════════════════════════
          // DATA DISPLAY
          // ═══════════════════════════════════
          _SectionHeader(title: context.l10n.uiTestSectionDataDisplay),
          const SizedBox(height: 16),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppCardTask,
            description: context.l10n.uiTestWidgetAppCardTaskDesc,
            code:
                'AppCardTask(\n'
                "  title: 'Daily Check-In',\n"
                "  dueText: 'Due today at 2:30 PM',\n"
                "  repeatText: 'Repeats every 3 days',\n"
                "  actionLabel: 'Do Task',\n"
                '  actionColor: AppTheme.secondary,\n'
                '  actionTextColor: AppTheme.textContrast,\n'
                '  onAction: () {},\n'
                ')',
            child: AppCardTask(
              title: 'Daily Check-In',
              dueText: 'Due today at 2:30 PM',
              repeatText: 'Repeats every 3 days',
              actionLabel: 'Do Task',
              actionColor: AppTheme.secondary,
              actionTextColor: AppTheme.textContrast,
              onAction: () {},
            ),
          ),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppGraphRenderer,
            description: context.l10n.uiTestWidgetAppGraphRendererDesc,
            code:
                'AppGraphRenderer(\n'
                "  title: 'Weekly Mood Trend',\n"
                "  placeholderText: 'Graph placeholder',\n"
                '  child: Row(\n'
                '    crossAxisAlignment: CrossAxisAlignment.end,\n'
                '    children: [\n'
                '      Expanded(child: _Bar(height: 0.35)),\n'
                '      SizedBox(width: 8),\n'
                '      Expanded(child: _Bar(height: 0.7)),\n'
                '      SizedBox(width: 8),\n'
                '      Expanded(child: _Bar(height: 0.5)),\n'
                '    ],\n'
                '  ),\n'
                ')',
            child: AppGraphRenderer(
              title: 'Weekly Mood Trend',
              placeholderText: 'Graph placeholder',
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  height: 160,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: FractionallySizedBox(
                          heightFactor: 0.35,
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FractionallySizedBox(
                          heightFactor: 0.7,
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.secondary.withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FractionallySizedBox(
                          heightFactor: 0.5,
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.success.withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FractionallySizedBox(
                          heightFactor: 0.82,
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.info.withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FractionallySizedBox(
                          heightFactor: 0.58,
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.caution.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppProgressBar,
            description: context.l10n.uiTestWidgetAppProgressBarDesc,
            code:
                'AppProgressBar(\n'
                '  progress: ${_progressBarValue.toStringAsFixed(2)},\n'
                '  height: ${_progressBarHeight.toStringAsFixed(0)},\n'
                '  backgroundColor: ${_colorName(_progressBarTrackColor)},\n'
                '  progressColor: ${_colorName(_progressBarFillColor)},\n'
                '  borderRadius: BorderRadius.zero,\n'
                "  semanticLabel: 'Task completion',\n"
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlProgress('${(_progressBarValue * 100).round()}'),
                  SizedBox(
                    width: 120,
                    child: Slider(
                      value: _progressBarValue,
                      min: 0,
                      max: 1,
                      divisions: 8,
                      onChanged: (v) => setState(() => _progressBarValue = v),
                    ),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlHeightPx(_progressBarHeight.toStringAsFixed(0)),
                  SizedBox(
                    width: 120,
                    child: Slider(
                      value: _progressBarHeight,
                      min: 4,
                      max: 24,
                      divisions: 8,
                      onChanged: (v) => setState(() => _progressBarHeight = v),
                    ),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlTrack,
                  _colorDropdown(
                    _progressBarTrackColor,
                    (c) => setState(() => _progressBarTrackColor = c),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlFill,
                  _colorDropdown(
                    _progressBarFillColor,
                    (c) => setState(() => _progressBarFillColor = c),
                  ),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppProgressBar(
                  progress: _progressBarValue,
                  height: _progressBarHeight,
                  backgroundColor: _progressBarTrackColor,
                  progressColor: _progressBarFillColor,
                  borderRadius: BorderRadius.zero,
                  semanticLabel: context.l10n.uiTestDemoTaskCompletion,
                ),
                const SizedBox(height: 12),
                AppText(
                  context.l10n.uiTestDemoCompletionPrefix('${(_progressBarValue * 100).round()}'),
                  variant: AppTextVariant.bodySmall,
                  color: context.appColors.textMuted,
                ),
              ],
            ),
          ),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetDataTable,
            description: context.l10n.uiTestWidgetDataTableDesc,
            code:
                'custom.DataTable(\n'
                '  stickyHeader: true,\n'
                '  expandedRowBuilder: (index) => _buildDetails(index),\n'
                '  expandedRowIndex: _expandedRow,\n'
                '  onRowTap: (i) => setState(() =>\n'
                '    _expandedRow = _expandedRow == i ? null : i),\n'
                '  columns: [\n'
                "    DataTableCell.custom(flex: 1, child: Text('ID')),\n"
                "    DataTableCell.custom(flex: 3, child: Text('Name')),\n"
                "    DataTableCell.custom(flex: 2, child: Text('Status')),\n"
                '  ],\n'
                '  rows: items.map((item) => Row(\n'
                '    children: [\n'
                '      DataTableCell.text(item.id),\n'
                '      DataTableCell.text(item.name),\n'
                "      DataTableCell.badge('Active', color: AppTheme.success),\n"
                '    ],\n'
                '  )).toList(),\n'
                "  footer: Text('3 items'),\n"
                ')',
            child: SizedBox(
              height: 300,
              child: custom.DataTable(
                stickyHeader: true,
                expandedRowBuilder: (index) => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.03),
                    border: Border(
                      bottom: BorderSide(color: context.appColors.divider),
                    ),
                  ),
                  child: Text('Expanded details for row ${index + 1}'),
                ),
                expandedRowIndex: _expandedTableRow,
                onRowTap: (i) => setState(
                  () => _expandedTableRow = _expandedTableRow == i ? null : i,
                ),
                columns: [
                  DataTableCell.custom(flex: 1, child: const Text('ID')),
                  DataTableCell.custom(flex: 3, child: const Text('Name')),
                  DataTableCell.custom(flex: 2, child: const Text('Role')),
                  DataTableCell.custom(flex: 2, child: const Text('Status')),
                ],
                rows: [
                  Row(
                    children: [
                      DataTableCell.text('1'),
                      DataTableCell.text('Alice Johnson'),
                      DataTableCell.badge('Admin', color: AppTheme.error),
                      DataTableCell.status(isActive: true),
                    ],
                  ),
                  Row(
                    children: [
                      DataTableCell.text('2'),
                      DataTableCell.text('Bob Smith'),
                      DataTableCell.badge(
                        'Researcher',
                        color: AppTheme.secondary,
                      ),
                      DataTableCell.status(isActive: true),
                    ],
                  ),
                  Row(
                    children: [
                      DataTableCell.text('3'),
                      DataTableCell.text('Carol Davis'),
                      DataTableCell.badge('Participant', color: AppTheme.info),
                      DataTableCell.status(isActive: false),
                    ],
                  ),
                ],
              ),
            ),
          ),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetDataTableCell,
            description: context.l10n.uiTestWidgetDataTableCellDesc,
            code:
                "// Text cell\nDataTableCell.text('John Doe', muted: true)\n\n"
                "// Badge cell\nDataTableCell.badge('Admin', color: AppTheme.error)\n\n"
                '// Status cell\nDataTableCell.status(isActive: true)\n\n'
                '// Date cell\nDataTableCell.date(DateTime.now())\n\n'
                "// Avatar cell\nDataTableCell.avatar(text: 'John', initial: 'J', color: AppTheme.primary)\n\n"
                '// Actions cell\nDataTableCell.actions(children: [\n'
                '  IconButton(icon: Icon(Icons.edit), onPressed: () {}),\n'
                '])',
            child: Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _cellDemo('text', DataTableCell.text('John Doe')),
                _cellDemo(
                  'text (muted)',
                  DataTableCell.text('Secondary', muted: true),
                ),
                _cellDemo(
                  'badge',
                  DataTableCell.badge('Admin', color: AppTheme.error),
                ),
                _cellDemo(
                  'status (active)',
                  DataTableCell.status(isActive: true),
                ),
                _cellDemo(
                  'status (inactive)',
                  DataTableCell.status(isActive: false),
                ),
                _cellDemo('date', DataTableCell.date(DateTime.now())),
                _cellDemo(
                  'avatar',
                  DataTableCell.avatar(
                    text: 'Alice',
                    initial: 'A',
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),

          // ── AppStatCard ──
          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppStatCard,
            description: context.l10n.uiTestWidgetAppStatCardDesc,
            code:
                'AppStatCard(\n'
                "  label: 'Respondents',\n"
                "  value: '142',\n"
                '  icon: Icons.people,\n'
                '  color: ${_colorName(_statCardColor)},\n'
                "${_statCardShowSubtitle ? "  subtitle: '+12 this week',\n" : ''}"
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlColor,
                  _colorDropdown(
                    _statCardColor,
                    (c) => setState(() => _statCardColor = c),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlIcon,
                  _toggle(
                    _statCardShowIcon,
                    (v) => setState(() => _statCardShowIcon = v),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlSubtitle,
                  _toggle(
                    _statCardShowSubtitle,
                    (v) => setState(() => _statCardShowSubtitle = v),
                  ),
                ),
              ],
            ),
            child: SizedBox(
              width: 280,
              child: AppStatCard(
                label: context.l10n.uiTestDemoRespondents,
                value: '142',
                icon: _statCardShowIcon ? Icons.people : null,
                color: _statCardColor,
                subtitle: _statCardShowSubtitle ? context.l10n.uiTestDemoThisWeek : null,
              ),
            ),
          ),

          // ── AppBarChart ──
          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppBarChart,
            description: context.l10n.uiTestWidgetAppBarChartDesc,
            code:
                'AppBarChart(\n'
                "  title: 'Responses by Category',\n"
                '  data: {..},\n'
                '  barColor: ${_colorName(_barChartColor)},\n'
                '  showValues: $_barChartShowValues,\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlColor,
                  _colorDropdown(
                    _barChartColor,
                    (c) => setState(() => _barChartColor = c),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlValues,
                  _toggle(
                    _barChartShowValues,
                    (v) => setState(() => _barChartShowValues = v),
                  ),
                ),
              ],
            ),
            // Keep the showcase page scrollable by preventing embedded charts
            // from claiming drag gestures inside the catalog.
            child: IgnorePointer(
              child: AppBarChart(
                title: 'Responses by Category',
                data: const {
                  'Demographics': 24,
                  'Mental Health': 18,
                  'Physical': 21,
                  'Lifestyle': 15,
                  'Symptoms': 9,
                },
                barColor: _barChartColor,
                height: 250,
                showValues: _barChartShowValues,
              ),
            ),
          ),

          // ── AppPieChart ──
          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppPieChart,
            description: context.l10n.uiTestWidgetAppPieChartDesc,
            code:
                'AppPieChart(\n'
                "  title: 'Gender Distribution',\n"
                '  data: {..},\n'
                '  showLegend: $_pieChartShowLegend,\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlLegend,
                  _toggle(
                    _pieChartShowLegend,
                    (v) => setState(() => _pieChartShowLegend = v),
                  ),
                ),
              ],
            ),
            child: IgnorePointer(
              child: AppPieChart(
                title: 'Gender Distribution',
                data: const {
                  'Male': 38,
                  'Female': 42,
                  'Non-binary': 8,
                  'Prefer not to say': 4,
                },
                showLegend: _pieChartShowLegend,
                height: 220,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // ═══════════════════════════════════
          // BASICS
          // ═══════════════════════════════════
          _SectionHeader(title: context.l10n.uiTestSectionBasics),
          const SizedBox(height: 16),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetHealthBankLogo,
            description: context.l10n.uiTestWidgetHealthBankLogoDesc,
            code:
                'HealthBankLogo(\n'
                '  size: HealthBankLogoSize.${_logoSize.name},\n'
                '  showTagline: $_logoTagline,\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlSize,
                  _enumDropdown<HealthBankLogoSize>(_logoSize, {
                    for (final v in HealthBankLogoSize.values) v: v.name,
                  }, (v) => setState(() => _logoSize = v)),
                ),
                _control(
                  context.l10n.uiTestControlTagline,
                  _toggle(
                    _logoTagline,
                    (v) => setState(() => _logoTagline = v),
                  ),
                ),
              ],
            ),
            child: HealthBankLogo(size: _logoSize, showTagline: _logoTagline),
          ),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppAccordion,
            description: context.l10n.uiTestWidgetAppAccordionDesc,
            code:
                'AppAccordion(\n'
                "  title: 'Details',\n"
                "  body: 'Additional context goes here.',\n"
                '  leadingIcon: Icon(Icons.info_outline),\n'
                '  initiallyExpanded: $_accordionInitiallyExpanded,\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlStartExpanded,
                  _toggle(
                    _accordionInitiallyExpanded,
                    (v) => setState(() => _accordionInitiallyExpanded = v),
                  ),
                ),
              ],
            ),
            child: AppAccordion(
              title: 'Details',
              body: 'Additional context goes here.',
              leadingIcon: const Icon(Icons.info_outline),
              initiallyExpanded: _accordionInitiallyExpanded,
            ),
          ),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppBreadcrumbs,
            description: context.l10n.uiTestWidgetAppBreadcrumbsDesc,
            code:
                'AppBreadcrumbs(\n'
                '  items: [\n'
                "    AppBreadcrumbItem(label: 'Home', onTap: () {}),\n"
                "    AppBreadcrumbItem(label: 'Admin', onTap: () {}),\n"
                "    AppBreadcrumbItem(label: 'UI Test', isActive: true),\n"
                '  ],\n'
                ')',
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlActive,
                  _enumDropdown<int>(
                    _activeBreadcrumbIndex,
                    const {0: 'Home', 1: 'Admin', 2: 'UI Test'},
                    (v) => setState(() => _activeBreadcrumbIndex = v),
                  ),
                ),
              ],
            ),
            child: AppBreadcrumbs(
              items: [
                AppBreadcrumbItem(
                  label: 'Home',
                  onTap: () {},
                  isActive: _activeBreadcrumbIndex == 0,
                ),
                AppBreadcrumbItem(
                  label: 'Admin',
                  onTap: () {},
                  isActive: _activeBreadcrumbIndex == 1,
                ),
                AppBreadcrumbItem(
                  label: 'UI Test',
                  isActive: _activeBreadcrumbIndex == 2,
                ),
              ],
            ),
          ),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppSectionNavbar,
            description: context.l10n.uiTestWidgetAppSectionNavbarDesc,
            code: _buildSectionNavbarCode(sectionNavbarSections),
            controls: _buildSectionNavbarControls(),
            child: SizedBox(
              height: 420,
              child: _SectionNavbarDemo(sections: sectionNavbarSections),
            ),
          ),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppDropdownMenu,
            description: context.l10n.uiTestWidgetAppDropdownMenuDesc,
            code:
                'AppDropdownMenu<String>(\n'
                "  initialValue: 'weekly',\n"
                '  options: [\n'
                "    AppDropdownOption(label: 'Daily', value: 'daily'),\n"
                "    AppDropdownOption(label: 'Weekly', value: 'weekly'),\n"
                "    AppDropdownOption(label: 'Monthly', value: 'monthly', enabled: false),\n"
                '  ],\n'
                '  onChanged: (value) {},\n'
                ')',
            child: SizedBox(
              width: 280,
              child: AppDropdownMenu<String>(
                initialValue: _dropdownSelection,
                hintText: 'Select cadence',
                options: const [
                  AppDropdownOption(label: 'Daily', value: 'daily'),
                  AppDropdownOption(label: 'Weekly', value: 'weekly'),
                  AppDropdownOption(
                    label: 'Monthly',
                    value: 'monthly',
                    enabled: false,
                  ),
                ],
                onChanged: (value) =>
                    setState(() => _dropdownSelection = value),
              ),
            ),
          ),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppModalOverlay,
            description: context.l10n.uiTestWidgetAppModalOverlayDesc,
            code:
                "AppFilledButton(\n"
                "  label: 'Open modal',\n"
                '  onPressed: () {\n'
                '    showDialog(\n'
                '      context: context,\n'
                '      barrierDismissible: false,\n'
                '      builder: (_) => AppModal(\n'
                "        title: 'Confirm action',\n"
                "        body: 'This action cannot be undone.',\n"
                "        actionLabel: 'Confirm',\n"
                '        onClose: () => Navigator.of(context).pop(),\n'
                '      ),\n'
                '    );\n'
                '  },\n'
                ')',
            child: AppFilledButton(
              label: context.l10n.uiTestDemoOpenModal,
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) => AppModal(
                    title: context.l10n.uiTestDemoConfirmAction,
                    body: context.l10n.uiTestDemoConfirmActionBody,
                    actionLabel: context.l10n.uiTestDemoConfirm,
                    onClose: () => Navigator.of(dialogContext).pop(),
                  ),
                );
              },
            ),
          ),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppImage,
            description: context.l10n.uiTestWidgetAppImageDesc,
            code: (() {
              final buffer = StringBuffer()
                ..writeln('AppImage(')
                ..writeln(
                  "  image: const AssetImage('assets/example_image.jpg'),",
                )
                ..writeln(
                  '  aspectRatio: ${_appImageAspectRatio.toStringAsFixed(2)},',
                )
                ..writeln('  fit: ${_fitName(_appImageFit)},');
              if (_appImageSetWidth) {
                buffer.writeln(
                  '  width: ${_appImageWidth.toStringAsFixed(0)},',
                );
              }
              if (_appImageSetHeight) {
                buffer.writeln(
                  '  height: ${_appImageHeight.toStringAsFixed(0)},',
                );
              }
              if (_appImageRounded) {
                buffer.writeln('  borderRadius: BorderRadius.circular(12),');
              }
              if (_appImageSemanticLabelCtrl.text.isNotEmpty) {
                buffer.writeln(
                  "  semanticLabel: '${_appImageSemanticLabelCtrl.text}',",
                );
              }
              if (_appImageExcludeSemantics) {
                buffer.writeln('  excludeFromSemantics: true,');
              }
              buffer.write(')');
              return buffer.toString();
            })(),
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlAspect,
                  _enumDropdown<double>(
                    _appImageAspectRatio,
                    _aspectRatioOptions,
                    (v) => setState(() => _appImageAspectRatio = v),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlFit,
                  _enumDropdown<BoxFit>(
                    _appImageFit,
                    _fitOptions,
                    (v) => setState(() => _appImageFit = v),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlWidth,
                  _toggle(
                    _appImageSetWidth,
                    (v) => setState(() => _appImageSetWidth = v),
                  ),
                ),
                if (_appImageSetWidth)
                  _control(
                    context.l10n.uiTestControlWidthPx(_appImageWidth.toStringAsFixed(0)),
                    SizedBox(
                      width: 120,
                      child: Slider(
                        value: _appImageWidth,
                        min: 120,
                        max: 520,
                        divisions: 20,
                        onChanged: (v) => setState(() => _appImageWidth = v),
                      ),
                    ),
                  ),
                _control(
                  context.l10n.uiTestControlHeight,
                  _toggle(
                    _appImageSetHeight,
                    (v) => setState(() => _appImageSetHeight = v),
                  ),
                ),
                if (_appImageSetHeight)
                  _control(
                    context.l10n.uiTestControlHeightPx(_appImageHeight.toStringAsFixed(0)),
                    SizedBox(
                      width: 120,
                      child: Slider(
                        value: _appImageHeight,
                        min: 120,
                        max: 520,
                        divisions: 20,
                        onChanged: (v) => setState(() => _appImageHeight = v),
                      ),
                    ),
                  ),
                _control(
                  context.l10n.uiTestControlRadius,
                  _toggle(
                    _appImageRounded,
                    (v) => setState(() => _appImageRounded = v),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlSemantics,
                  _toggle(
                    _appImageExcludeSemantics,
                    (v) => setState(() => _appImageExcludeSemantics = v),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlLabel,
                  _textField(_appImageSemanticLabelCtrl, () => setState(() {})),
                ),
              ],
            ),
            child: AppImage(
              image: const AssetImage('assets/example_image.jpg'),
              aspectRatio: _appImageAspectRatio,
              fit: _appImageFit,
              width: _appImageSetWidth ? _appImageWidth : null,
              height: _appImageSetHeight ? _appImageHeight : null,
              borderRadius: _appImageRounded ? BorderRadius.circular(12) : null,
              semanticLabel: _appImageSemanticLabelCtrl.text.isEmpty
                  ? null
                  : _appImageSemanticLabelCtrl.text,
              excludeFromSemantics: _appImageExcludeSemantics,
            ),
          ),

          _WidgetShowcase(
            title: context.l10n.uiTestWidgetAppPlaceholderGraphic,
            description: context.l10n.uiTestWidgetAppPlaceholderGraphicDesc,
            code: (() {
              final buffer = StringBuffer()
                ..writeln('AppPlaceholderGraphic(')
                ..writeln("  assetPath: '$_placeholderAssetPath',")
                ..writeln(
                  '  aspectRatio: ${_placeholderAspectRatio.toStringAsFixed(2)},',
                )
                ..writeln('  fit: ${_fitName(_placeholderFit)},');
              if (_placeholderRounded) {
                buffer.writeln('  borderRadius: BorderRadius.circular(12),');
              }
              if (_placeholderSemanticLabelCtrl.text.isNotEmpty) {
                buffer.writeln(
                  "  semanticLabel: '${_placeholderSemanticLabelCtrl.text}',",
                );
              }
              if (_placeholderExcludeSemantics) {
                buffer.writeln('  excludeFromSemantics: true,');
              }
              buffer.write(')');
              return buffer.toString();
            })(),
            controls: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _control(
                  context.l10n.uiTestControlAspect,
                  _enumDropdown<double>(
                    _placeholderAspectRatio,
                    _aspectRatioOptions,
                    (v) => setState(() => _placeholderAspectRatio = v),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlAsset,
                  _enumDropdown<String>(
                    _placeholderAssetPath,
                    _placeholderAssets,
                    (v) => setState(() => _placeholderAssetPath = v),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlFit,
                  _enumDropdown<BoxFit>(
                    _placeholderFit,
                    _fitOptions,
                    (v) => setState(() => _placeholderFit = v),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlRadius,
                  _toggle(
                    _placeholderRounded,
                    (v) => setState(() => _placeholderRounded = v),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlSemantics,
                  _toggle(
                    _placeholderExcludeSemantics,
                    (v) => setState(() => _placeholderExcludeSemantics = v),
                  ),
                ),
                _control(
                  context.l10n.uiTestControlLabel,
                  _textField(
                    _placeholderSemanticLabelCtrl,
                    () => setState(() {}),
                  ),
                ),
              ],
            ),
            child: SizedBox(
              width: 320,
              child: AppPlaceholderGraphic(
                aspectRatio: _placeholderAspectRatio,
                assetPath: _placeholderAssetPath,
                fit: _placeholderFit,
                borderRadius: _placeholderRounded
                    ? BorderRadius.circular(12)
                    : null,
                semanticLabel: _placeholderSemanticLabelCtrl.text.isEmpty
                    ? null
                    : _placeholderSemanticLabelCtrl.text,
                excludeFromSemantics: _placeholderExcludeSemantics,
              ),
            ),
          ),
      ];
  }

  Widget _cellDemo(String label, Widget cell) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          label,
          variant: AppTextVariant.bodySmall,
          color: context.appColors.textMuted,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: context.appColors.divider),
            borderRadius: BorderRadius.circular(4),
          ),
          child: cell,
        ),
      ],
    );
  }
}

class _SectionNavbarEditorSection {
  const _SectionNavbarEditorSection({
    required this.id,
    required this.label,
    required this.children,
    this.initiallyExpanded = true,
  });

  final String id;
  final String label;
  final List<_SectionNavbarEditorItem> children;
  final bool initiallyExpanded;

  _SectionNavbarEditorSection copyWith({
    String? label,
    List<_SectionNavbarEditorItem>? children,
    bool? initiallyExpanded,
  }) {
    return _SectionNavbarEditorSection(
      id: id,
      label: label ?? this.label,
      children: children ?? this.children,
      initiallyExpanded: initiallyExpanded ?? this.initiallyExpanded,
    );
  }
}

class _SectionNavbarEditorItem {
  const _SectionNavbarEditorItem({required this.id, required this.label});

  final String id;
  final String label;

  _SectionNavbarEditorItem copyWith({String? label}) {
    return _SectionNavbarEditorItem(id: id, label: label ?? this.label);
  }
}

class _SectionNavbarDemo extends StatefulWidget {
  const _SectionNavbarDemo({required this.sections});

  final List<AppSectionNavbarSection> sections;

  @override
  State<_SectionNavbarDemo> createState() => _SectionNavbarDemoState();
}

class _SectionNavbarDemoState extends State<_SectionNavbarDemo> {
  final ScrollController _contentScrollController = ScrollController();
  late Map<String, GlobalKey> _targetKeys;
  String? _activeDestinationId;

  List<String> get _orderedDestinationIds {
    return [
      for (final section in widget.sections) section.destinationId,
      for (final section in widget.sections)
        for (final child in section.children) child.destinationId,
    ];
  }

  Map<String, String> get _destinationLabels {
    return {
      for (final section in widget.sections)
        section.destinationId: section.label,
      for (final section in widget.sections)
        for (final child in section.children) child.destinationId: child.label,
    };
  }

  @override
  void initState() {
    super.initState();
    _targetKeys = _buildTargetKeys(const {});
    _activeDestinationId = _orderedDestinationIds.isEmpty
        ? null
        : _orderedDestinationIds.first;

    _contentScrollController.addListener(_handleScrollChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _refreshActiveDestination();
    });
  }

  @override
  void didUpdateWidget(covariant _SectionNavbarDemo oldWidget) {
    super.didUpdateWidget(oldWidget);

    _targetKeys = _buildTargetKeys(_targetKeys);

    if (_orderedDestinationIds.isEmpty) {
      _activeDestinationId = null;
      return;
    }

    if (_activeDestinationId == null ||
        !_orderedDestinationIds.contains(_activeDestinationId)) {
      _activeDestinationId = _orderedDestinationIds.first;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _refreshActiveDestination();
    });
  }

  @override
  void dispose() {
    _contentScrollController
      ..removeListener(_handleScrollChanged)
      ..dispose();
    super.dispose();
  }

  Map<String, GlobalKey> _buildTargetKeys(Map<String, GlobalKey> existingKeys) {
    return {
      for (final destinationId in _orderedDestinationIds)
        destinationId: existingKeys[destinationId] ?? GlobalKey(),
    };
  }

  void _handleScrollChanged() {
    _refreshActiveDestination();
  }

  void _refreshActiveDestination() {
    if (!_contentScrollController.hasClients ||
        _orderedDestinationIds.isEmpty) {
      return;
    }

    final destination = _resolveActiveDestination(
      _contentScrollController.position.pixels,
    );
    if (destination == null || destination == _activeDestinationId) return;

    setState(() {
      _activeDestinationId = destination;
    });
  }

  String? _resolveActiveDestination(double scrollPixels) {
    const viewportAnchor = 84.0;
    String? active;

    for (final destination in _orderedDestinationIds) {
      final offset = _offsetForDestination(destination);
      if (offset == null) continue;

      if (offset <= scrollPixels + viewportAnchor) {
        active = destination;
      } else {
        break;
      }
    }

    return active ?? _orderedDestinationIds.firstOrNull;
  }

  double? _offsetForDestination(String destinationId) {
    if (!_contentScrollController.hasClients) return null;

    final context = _targetKeys[destinationId]?.currentContext;
    if (context == null) return null;

    final renderObject = context.findRenderObject();
    if (renderObject == null) return null;
    if (renderObject is RenderBox && !renderObject.hasSize) {
      return null;
    }

    final viewport = RenderAbstractViewport.of(renderObject);
    return viewport.getOffsetToReveal(renderObject, 0.0).offset;
  }

  Future<void> _onDestinationTap(String destinationId) async {
    final targetOffset = _offsetForDestination(destinationId);
    if (targetOffset == null || !_contentScrollController.hasClients) return;

    setState(() {
      _activeDestinationId = destinationId;
    });

    await _contentScrollController.animateTo(
      targetOffset.clamp(
        _contentScrollController.position.minScrollExtent,
        _contentScrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
    );
  }

  List<Widget> _buildContentBlocks() {
    if (widget.sections.isEmpty) {
      return [
        AppText(
          context.l10n.uiTestSectionNavbarNoSections,
          variant: AppTextVariant.bodyMedium,
          color: context.appColors.textMuted,
        ),
      ];
    }

    final blocks = <Widget>[];

    for (final section in widget.sections) {
      blocks.add(
        _sectionTitle(
          key: _targetKeys[section.destinationId],
          title: section.label,
        ),
      );
      blocks.add(const SizedBox(height: 12));

      if (section.children.isEmpty) {
        blocks.add(
          _contentCard(
            title: '${section.label} Details',
            body:
                'This section currently has no subsections. Add one in PROPERTIES to test child-item navigation.',
          ),
        );
      } else {
        for (final child in section.children) {
          blocks.add(
            _contentCard(
              key: _targetKeys[child.destinationId],
              title: child.label,
              body:
                  'Sample content block for ${child.label.toLowerCase()} to demonstrate in-page jump and active highlighting.',
            ),
          );
          blocks.add(const SizedBox(height: 12));
        }
      }

      blocks.add(const SizedBox(height: 20));
    }

    if (blocks.isNotEmpty) {
      blocks.removeLast();
    }

    return blocks;
  }

  @override
  Widget build(BuildContext context) {
    final activeLabel = _activeDestinationId == null
        ? context.l10n.uiTestSectionNavbarActiveNone
        : (_destinationLabels[_activeDestinationId!] ?? _activeDestinationId!);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 920,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 280,
              child: AppSectionNavbar(
                sections: widget.sections,
                activeDestinationId: _activeDestinationId,
                onDestinationTap: _onDestinationTap,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.appColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.appColors.divider),
                  boxShadow: context.appColors.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            context.l10n.uiTestSectionNavbarContainedTitle,
                            variant: AppTextVariant.headlineSmall,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(height: 6),
                          AppText(
                            context.l10n.uiTestSectionNavbarScrollHint,
                            variant: AppTextVariant.bodyMedium,
                            color: context.appColors.textMuted,
                          ),
                          const SizedBox(height: 4),
                          AppText(
                            context.l10n.uiTestSectionNavbarActiveDestination(activeLabel),
                            variant: AppTextVariant.bodySmall,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: context.appColors.divider),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _contentScrollController,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildContentBlocks(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle({required GlobalKey? key, required String title}) {
    return KeyedSubtree(
      key: key,
      child: AppText(
        title,
        variant: AppTextVariant.headlineSmall,
        color: AppTheme.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _contentCard({
    GlobalKey? key,
    required String title,
    required String body,
  }) {
    return KeyedSubtree(
      key: key,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.appColors.surfaceRaised,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.appColors.divider),
          boxShadow: context.appColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title,
              variant: AppTextVariant.bodyLarge,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 8),
            AppText(
              body,
              variant: AppTextVariant.bodyMedium,
              color: context.appColors.textMuted,
            ),
            const SizedBox(height: 10),
            Container(
              height: 76,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: context.appColors.divider),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section header with accent bar.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 28,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            softWrap: true,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// A showcase card with live preview, property controls, and expandable code.
class _WidgetShowcase extends StatefulWidget {
  const _WidgetShowcase({
    required this.title,
    required this.description,
    required this.code,
    required this.child,
    this.controls,
  });

  final String title;
  final String description;
  final String code;
  final Widget child;
  final Widget? controls;

  @override
  State<_WidgetShowcase> createState() => _WidgetShowcaseState();
}

class _WidgetShowcaseState extends State<_WidgetShowcase> {
  bool _showCode = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.appColors.surfaceRaised,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.appColors.divider),
        boxShadow: context.appColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.appColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                // Code toggle
                InkWell(
                  onTap: () => setState(() => _showCode = !_showCode),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _showCode
                          ? AppTheme.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: _showCode ? AppTheme.primary : context.appColors.divider,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.code,
                          size: 16,
                          color: _showCode
                              ? AppTheme.primary
                              : context.appColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _showCode ? context.l10n.uiTestSectionNavbarHideCode : context.l10n.uiTestSectionNavbarShowCode,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: _showCode
                                    ? AppTheme.primary
                                    : context.appColors.textMuted,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Live preview
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: widget.child,
          ),

          // Properties panel
          if (widget.controls != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              decoration: BoxDecoration(
                color: context.appColors.surfaceSubtle,
                border: Border(top: BorderSide(color: context.appColors.divider)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.uiTestSectionNavbarProperties,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: context.appColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  widget.controls!,
                ],
              ),
            ),
          ],

          // Code section
          if (_showCode) ...[
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(16),
                    child: SelectableText(
                      widget.code,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        height: 1.5,
                        color: Color(0xFFCDD6F4),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: widget.code));
                        AppToast.showSuccess(
                          context,
                          message: context.l10n.uiTestDemoCodeCopied,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.copy,
                          size: 16,
                          color: Color(0xFF89B4FA),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
