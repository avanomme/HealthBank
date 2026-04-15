import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/widgets/buttons/buttons.dart';
import 'package:frontend/src/features/admin/widgets/impersonation_banner.dart';
import 'package:frontend/src/features/auth/auth_state.dart';

import '../../../test_helpers.dart';

class _ImpersonationNotifier extends StateNotifier<ImpersonationState>
    implements ImpersonationNotifier {
  _ImpersonationNotifier(
    super.state, {
    this.endSuccess = true,
  });

  bool endSuccess;
  int endCalls = 0;
  int clearCalls = 0;

  @override
  Ref get ref => throw UnimplementedError();

  @override
  Future<void> fetchSessionInfo() async {}

  @override
  Future<void> startRolePreview(String role) async {
    state = ImpersonationState(mode: ViewAsMode.rolePreview, previewRole: role);
  }

  @override
  Future<String?> startImpersonation(int userId) async => null;

  @override
  Future<bool> endImpersonation() async {
    endCalls++;
    if (!endSuccess) {
      state = state.copyWith(error: 'Unable to end impersonation');
    }
    return endSuccess;
  }

  @override
  void clear() {
    state = const ImpersonationState();
  }

  @override
  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void clearImpersonationState() {
    clearCalls++;
    state = const ImpersonationState();
  }
}

Widget _buildBanner(ImpersonationState state, _ImpersonationNotifier notifier) {
  return buildTestWidget(
    const ImpersonationBanner(),
    overrides: [
      impersonationProvider.overrideWith((ref) => notifier),
    ],
  );
}

Widget _buildAnimatedBanner(
  ImpersonationState state,
  _ImpersonationNotifier notifier,
) {
  return buildTestWidget(
    const AnimatedImpersonationBanner(),
    overrides: [
      impersonationProvider.overrideWith((ref) => notifier),
    ],
  );
}

Widget _buildWrapper(ImpersonationState state, _ImpersonationNotifier notifier) {
  return buildTestWidget(
    const ImpersonationBannerWrapper(child: Text('Wrapped Content')),
    overrides: [
      impersonationProvider.overrideWith((ref) => notifier),
    ],
  );
}

void main() {
  group('ImpersonationBanner', () {
    testWidgets('hides when not impersonating', (tester) async {
      final notifier = _ImpersonationNotifier(const ImpersonationState());

      await tester.pumpWidget(_buildBanner(notifier.state, notifier));
      await tester.pumpAndSettle();

      expect(find.byType(ImpersonationBanner), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(AppFilledButton), findsNothing);
    });

    testWidgets('shows message and action button while impersonating',
        (tester) async {
      final notifier = _ImpersonationNotifier(
        const ImpersonationState(
          mode: ViewAsMode.rolePreview,
          previewRole: 'participant',
        ),
      );

      await tester.pumpWidget(_buildBanner(notifier.state, notifier));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(AppFilledButton), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.minHeight, kImpersonationBannerHeight);
    });

    testWidgets('button disabled when impersonation is loading', (tester) async {
      final notifier = _ImpersonationNotifier(
        const ImpersonationState(
          mode: ViewAsMode.rolePreview,
          previewRole: 'researcher',
          isLoading: true,
        ),
      );

      await tester.pumpWidget(_buildBanner(notifier.state, notifier));
      await tester.pumpAndSettle();

      expect(find.byType(AppFilledButton), findsOneWidget);
      await tester.tap(find.byType(AppFilledButton));
      await tester.pump();

      expect(notifier.endCalls, 0);
    });

    testWidgets('tapping button calls end and clears state on success',
        (tester) async {
      final notifier = _ImpersonationNotifier(
        const ImpersonationState(
          mode: ViewAsMode.rolePreview,
          previewRole: 'participant',
        ),
        endSuccess: true,
      );

      await tester.pumpWidget(_buildBanner(notifier.state, notifier));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(AppFilledButton));
      await tester.pumpAndSettle();

      expect(notifier.endCalls, 1);
      expect(notifier.clearCalls, 1);
    });
  });

  group('AnimatedImpersonationBanner', () {
    testWidgets('animates hidden state when not impersonating', (tester) async {
      final notifier = _ImpersonationNotifier(const ImpersonationState());

      await tester.pumpWidget(_buildAnimatedBanner(notifier.state, notifier));
      await tester.pumpAndSettle();

      final slide = tester.widget<AnimatedSlide>(find.byType(AnimatedSlide));
      final opacity = tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity));

      expect(slide.offset, const Offset(0, -1));
      expect(opacity.opacity, 0.0);
    });

    testWidgets('shows wrapper height only while impersonating', (tester) async {
      final notifier = _ImpersonationNotifier(
        const ImpersonationState(
          mode: ViewAsMode.rolePreview,
          previewRole: 'admin',
        ),
      );

      await tester.pumpWidget(_buildWrapper(notifier.state, notifier));
      await tester.pumpAndSettle();

      final shown = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      expect(shown.constraints?.minHeight, kImpersonationBannerHeight);
      expect(find.text('Wrapped Content'), findsOneWidget);

      notifier.clearImpersonationState();
      await tester.pumpAndSettle();

      final hidden = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      expect(hidden.constraints?.minHeight, 0);
      expect(find.text('Wrapped Content'), findsOneWidget);
    });
  });
}
