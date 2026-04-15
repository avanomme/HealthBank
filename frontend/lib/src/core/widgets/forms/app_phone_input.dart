// Created with the Assistance of Codex
/// AppPhoneInput
///
/// Description:
/// - A theme-aware phone form field with country selector and normalized dial
///   output.
/// - `AppPhoneInput` is a **form widget** designed for reusable phone capture.
///
/// Features:
/// - Supports either `controller` or `initialValue` input sources.
/// - Includes country selection via `AppPhoneCountry` options.
/// - Emits raw local input (`onChanged`) and normalized dial output
///   (`onNormalizedChanged`).
/// - Normalized output format is `+<countryCodeDigits><localDigits>`.
/// - Optional required validation via `isRequired` (enabled by default).
/// - Displays animated inline error text using shared form helpers.
///
/// Usage Example:
/// ```dart
/// AppPhoneInput(
///   label: 'Phone Number',
///   onNormalizedChanged: (value) => debugPrint('Dial value: $value'),
/// );
/// ```
library;

import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/forms/form_field_shared.dart';
import 'package:frontend/src/core/l10n/l10n.dart';

class AppPhoneInput extends StatefulWidget {
  const AppPhoneInput({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hintText,
    this.countries = AppPhoneCountry.commonCountries,
    this.initialCountry,
    this.onCountryChanged,
    this.onChanged,
    this.onNormalizedChanged,
    this.enabled = true,
    this.isRequired = true,
    this.validator,
    this.focusNode,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final List<AppPhoneCountry> countries;
  final AppPhoneCountry? initialCountry;
  final ValueChanged<AppPhoneCountry>? onCountryChanged;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onNormalizedChanged;
  final bool enabled;
  final bool isRequired;
  final AppStringValidator? validator;
  final FocusNode? focusNode;
  final AutovalidateMode autovalidateMode;

  @override
  State<AppPhoneInput> createState() => _AppPhoneInputState();
}

class _AppPhoneInputState extends State<AppPhoneInput> {
  final GlobalKey<FormFieldState<String>> _fieldKey =
      GlobalKey<FormFieldState<String>>();
  TextEditingController? _internalController;
  late AppPhoneCountry _selectedCountry;

  TextEditingController get _controller =>
      widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController(
        text: widget.initialValue ?? '',
      );
    }

    _selectedCountry = widget.initialCountry ?? widget.countries.first;
    _controller.addListener(_syncFieldValue);
    _emitNormalizedValueDeferred();
  }

  @override
  void didUpdateWidget(covariant AppPhoneInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_syncFieldValue);
      _internalController?.removeListener(_syncFieldValue);

      if (widget.controller == null && _internalController == null) {
        _internalController = TextEditingController(
          text: widget.initialValue ?? '',
        );
      }

      _controller.addListener(_syncFieldValue);
      _syncFieldValue();
    }

    if (oldWidget.initialCountry != widget.initialCountry &&
        widget.initialCountry != null) {
      _selectedCountry = widget.initialCountry!;
      _emitNormalizedValueDeferred();
    }

    if (widget.controller == null &&
        oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_syncFieldValue);
    _internalController?.dispose();
    super.dispose();
  }

  void _syncFieldValue() {
    _fieldKey.currentState?.didChange(_controller.text);
    _emitNormalizedValueDeferred();
  }

  String _normalizedValue() {
    final localDigits = phoneDigitsOnly(_controller.text);
    if (localDigits.isEmpty) return '';
    final codeDigits = phoneDigitsOnly(_selectedCountry.dialCode);
    return '+$codeDigits$localDigits';
  }

  void _emitNormalizedValue() {
    widget.onNormalizedChanged?.call(_normalizedValue());
  }

  void _emitNormalizedValueDeferred() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _emitNormalizedValue();
    });
  }

  String? _validate(String value) {
    final requiredError = appRequiredValidation(
      value,
      isRequired: widget.isRequired,
      label: widget.label,
    );
    if (requiredError != null) return requiredError;

    if (value.trim().isNotEmpty && phoneDigitsOnly(value).isEmpty) {
      return context.l10n.formPhoneValidationError;
    }

    return widget.validator?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final metrics = appFormMetrics(context);

    return FormField<String>(
      key: _fieldKey,
      initialValue: _controller.text,
      enabled: widget.enabled,
      autovalidateMode: widget.autovalidateMode,
      validator: (value) => _validate(value ?? _controller.text),
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appInputLabel(
              context,
              label: widget.label,
              enabled: widget.enabled,
            ),
            SizedBox(height: metrics.spacing * 0.3),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: InputDecorator(
                    decoration:
                        appInputDecoration(
                          context,
                          enabled: widget.enabled,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: metrics.spacing * 0.55,
                            vertical: metrics.spacing * 0.38,
                          ),
                        ).copyWith(
                          errorText: state.errorText == null ? null : ' ',
                          errorStyle: const TextStyle(height: 0, fontSize: 0),
                        ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<AppPhoneCountry>(
                        value: _selectedCountry,
                        isExpanded: true,
                        icon: const Icon(Icons.expand_more),
                        style: metrics.bodyStyle,
                        items: widget.countries
                            .map(
                              (country) => DropdownMenuItem<AppPhoneCountry>(
                                value: country,
                                child: Text(
                                  '${country.label} (${country.dialCode})',
                                  overflow: TextOverflow.ellipsis,
                                  style: metrics.bodyStyle,
                                ),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: widget.enabled
                            ? (country) {
                                if (country == null) return;
                                setState(() => _selectedCountry = country);
                                widget.onCountryChanged?.call(country);
                                _emitNormalizedValue();
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: metrics.spacing * 0.4),
                Expanded(
                  flex: 7,
                  child: appFieldSemantics(
                    label: widget.label,
                    enabled: widget.enabled,
                    isRequired: widget.isRequired,
                    errorText: state.errorText,
                    child: TextField(
                      controller: _controller,
                      focusNode: widget.focusNode,
                      enabled: widget.enabled,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      style: metrics.bodyStyle,
                      decoration:
                          appInputDecoration(
                            context,
                            hintText: widget.hintText ?? context.l10n.formPhoneHint,
                            enabled: widget.enabled,
                          ).copyWith(
                            errorText: state.errorText == null ? null : ' ',
                            errorStyle: const TextStyle(height: 0, fontSize: 0),
                          ),
                      onChanged: (value) {
                        state.didChange(value);
                        widget.onChanged?.call(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
            appAnimatedMessage(
              context,
              message: state.errorText,
              color: AppTheme.error,
            ),
          ],
        );
      },
    );
  }
}


/// Country option model used by [AppPhoneInput].
class AppPhoneCountry {
  const AppPhoneCountry({
    required this.isoCode,
    required this.label,
    required this.dialCode,
  });

  final String isoCode;
  final String label;
  final String dialCode;

  static const List<AppPhoneCountry> commonCountries = [
    AppPhoneCountry(isoCode: 'US', label: 'United States', dialCode: '+1'),
    AppPhoneCountry(isoCode: 'CA', label: 'Canada', dialCode: '+1'),
    AppPhoneCountry(isoCode: 'GB', label: 'United Kingdom', dialCode: '+44'),
    AppPhoneCountry(isoCode: 'AU', label: 'Australia', dialCode: '+61'),
    AppPhoneCountry(isoCode: 'NZ', label: 'New Zealand', dialCode: '+64'),
    AppPhoneCountry(isoCode: 'SG', label: 'Singapore', dialCode: '+65'),
    AppPhoneCountry(isoCode: 'IN', label: 'India', dialCode: '+91'),
    AppPhoneCountry(isoCode: 'JP', label: 'Japan', dialCode: '+81'),
    AppPhoneCountry(isoCode: 'KR', label: 'South Korea', dialCode: '+82'),
    AppPhoneCountry(isoCode: 'DE', label: 'Germany', dialCode: '+49'),
    AppPhoneCountry(isoCode: 'FR', label: 'France', dialCode: '+33'),
    AppPhoneCountry(isoCode: 'NL', label: 'Netherlands', dialCode: '+31'),
  ];
}

