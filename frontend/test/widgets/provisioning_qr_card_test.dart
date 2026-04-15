import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/features/auth/widgets/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  testWidgets('shows QrImageView with provided provisioning URI', (tester) async {
    const uri = 'otpauth://totp/MyApp:alice?secret=ABC123&issuer=MyApp';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProvisioningQrCard(provisioningUri: uri),
        ),
      ),
    );

    // QR is present
    expect(find.byType(QrImageView), findsOneWidget);

    // The URI box is present (SelectableText contains the exact uri)
    expect(find.text(uri), findsOneWidget);
  });

  testWidgets('does not crash with a normal otpauth uri', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProvisioningQrCard(provisioningUri: 'otpauth://totp/x?secret=Y'),
        ),
      ),
    );

    expect(find.byType(QrImageView), findsOneWidget);
  });
}