import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/features/auth/state/two_factor_state.dart';

void main() {
  group('TwoFactorNotifier', () {
    test('confirm with short code sets required-code error', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final sub = container.listen(twoFactorProvider, (_, __) {});
      addTearDown(sub.close);

      final notifier = container.read(twoFactorProvider.notifier);
      final result = await notifier.confirm('123');

      expect(result, isNull);
      expect(container.read(twoFactorProvider).error, twoFactorErrorCodeRequired);
    });

    test('startVerify and finishVerify update busy and error state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final sub = container.listen(twoFactorProvider, (_, __) {});
      addTearDown(sub.close);

      final notifier = container.read(twoFactorProvider.notifier);

      notifier.startVerify();
      expect(container.read(twoFactorProvider).isBusy, isTrue);
      expect(container.read(twoFactorProvider).error, isNull);

      notifier.finishVerify(error: 'bad code');
      expect(container.read(twoFactorProvider).isBusy, isFalse);
      expect(container.read(twoFactorProvider).error, 'bad code');
    });

    test('clearConfirmMessage, setError, reset, and enrollment secret behave correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final sub = container.listen(twoFactorProvider, (_, __) {});
      addTearDown(sub.close);

      final notifier = container.read(twoFactorProvider.notifier);

      notifier.setError('enroll failed');
      expect(container.read(twoFactorProvider).error, 'enroll failed');

      notifier.state = notifier.state.copyWith(
        provisioningUri: 'otpauth://totp/HealthBank?secret=ABC123',
        confirmMessage: 'done',
      );
      expect(notifier.hasEnrollmentSecret, isTrue);

      notifier.clearConfirmMessage();
      expect(container.read(twoFactorProvider).confirmMessage, isNull);

      notifier.reset();
      expect(container.read(twoFactorProvider), const TwoFactorState());
      expect(notifier.hasEnrollmentSecret, isFalse);
    });
  });
}
