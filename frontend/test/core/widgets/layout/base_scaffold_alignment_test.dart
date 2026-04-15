// Created with the Assistance of Codex
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/state/cookie_consent_provider.dart';
import 'package:frontend/src/core/widgets/layout/layout.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../test_helpers.dart';

void main() {
  Widget buildPage(Widget child) {
    return buildTestPage(child);
  }

  group('BaseScaffold alignment', () {
    testWidgets('provides resolved alignment metrics to descendants', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildPage(
          BaseScaffold(
            showHeader: false,
            showFooter: false,
            scrollable: false,
            alignment: AppPageAlignment.wide,
            child: Builder(
              builder: (context) {
                final spec = context.resolvePageAlignment();
                return Text(
                  '${spec.horizontalPadding}/${spec.maxContentWidth}',
                  textDirection: TextDirection.ltr,
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('32.0/960.0'), findsOneWidget);
    });

    testWidgets('constrains padded regular pages to the regular max width', (
      tester,
    ) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.binding.setSurfaceSize(const Size(2200, 1200));

      await tester.pumpWidget(
        buildPage(
          BaseScaffold(
            showHeader: false,
            showFooter: false,
            scrollable: false,
            alignment: AppPageAlignment.regular,
            child: Container(
              key: const ValueKey('regular-child'),
              width: double.infinity,
              height: 100,
              color: Colors.red,
            ),
          ),
        ),
      );

      expect(
        tester.getSize(find.byKey(const ValueKey('regular-child'))).width,
        1600,
      );
    });

    testWidgets(
      'lets edge-to-edge pages use shared aligned content constraints',
      (tester) async {
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.binding.setSurfaceSize(const Size(1800, 1200));

        await tester.pumpWidget(
          buildPage(
            BaseScaffold(
              showHeader: false,
              showFooter: false,
              scrollable: false,
              alignment: AppPageAlignment.wide,
              bodyBehavior: AppPageBodyBehavior.edgeToEdge,
              child: AppPageAlignedContent(
                child: Container(
                  key: const ValueKey('wide-child'),
                  width: double.infinity,
                  height: 100,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        );

        expect(
          tester.getSize(find.byKey(const ValueKey('wide-child'))).width,
          960,
        );
      },
    );

    testWidgets(
      'keeps compact pages unconstrained while applying compact padding',
      (tester) async {
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.binding.setSurfaceSize(const Size(1800, 1200));

        await tester.pumpWidget(
          buildPage(
            BaseScaffold(
              showHeader: false,
              showFooter: false,
              scrollable: false,
              alignment: AppPageAlignment.compact,
              child: Container(
                key: const ValueKey('compact-child'),
                width: double.infinity,
                height: 100,
                color: Colors.green,
              ),
            ),
          ),
        );

        expect(
          tester.getSize(find.byKey(const ValueKey('compact-child'))).width,
          1760,
        );
      },
    );

    testWidgets('exposes skip link and main content semantics', (tester) async {
      await tester.pumpWidget(
        buildPage(
          const BaseScaffold(
            showFooter: false,
            scrollable: false,
            child: Text('Body'),
          ),
        ),
      );

      expect(find.text('Skip to main content'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && widget.properties.label == 'Main content',
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'does not shrink non-scrollable page height when cookie banner is visible',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.binding.setSurfaceSize(const Size(800, 600));

        Widget buildMeasuredPage({required CookieConsentNotifier notifier}) {
          return buildTestPage(
            BaseScaffold(
              showHeader: false,
              showFooter: false,
              scrollable: false,
              child: LayoutBuilder(
                builder: (context, constraints) => SizedBox(
                  key: const ValueKey('viewport-child'),
                  width: double.infinity,
                  height: constraints.maxHeight,
                ),
              ),
            ),
            overrides: [cookieConsentProvider.overrideWith((ref) => notifier)],
          );
        }

        await tester.pumpWidget(
          buildMeasuredPage(notifier: CookieConsentNotifier.accepted()),
        );
        await tester.pumpAndSettle();
        final bannerFreeHeight = tester
            .getSize(find.byKey(const ValueKey('viewport-child')))
            .height;

        await tester.pumpWidget(
          buildMeasuredPage(notifier: CookieConsentNotifier()),
        );
        await tester.pumpAndSettle();

        expect(
          tester.getSize(find.byKey(const ValueKey('viewport-child'))).height,
          bannerFreeHeight,
        );
      },
    );
  });
}
