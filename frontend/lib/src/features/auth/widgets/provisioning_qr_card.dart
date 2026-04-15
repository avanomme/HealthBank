import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProvisioningQrCard extends StatelessWidget {
  final String provisioningUri;
  const ProvisioningQrCard({super.key, required this.provisioningUri});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.appColors.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: context.appColors.divider),
          ),
          child: QrImageView(
            data: provisioningUri,
            version: QrVersions.auto,
            size: 220,
            errorCorrectionLevel: QrErrorCorrectLevel.M,
          ),
        ),
        const SizedBox(height: 16),
        _ProvisioningUriBox(uri: provisioningUri),
      ],
    );
  }
}

class _ProvisioningUriBox extends StatelessWidget {
  final String uri;
  const _ProvisioningUriBox({required this.uri});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.appColors.divider.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: context.appColors.divider),
      ),
      padding: const EdgeInsets.all(12),
      child: SelectableText(
        uri,
        style: AppTheme.captions.copyWith(
          color: context.appColors.textPrimary,
          height: 1.4,
        ),
      ),
    );
  }
}