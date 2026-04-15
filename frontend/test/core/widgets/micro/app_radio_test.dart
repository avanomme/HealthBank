// Created with the Assistance of Codex
import 'dart:ui' show CheckedState;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/core/theme/theme.dart';
import 'package:frontend/src/core/widgets/micro/app_radio.dart';

import '../../../test_helpers.dart';

void main() {
  group('AppRadio', () {
    testWidgets('renders selected in uncontrolled mode from initialGroupValue',
        (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(buildTestWidget(
          const AppRadio<String>(
            value: 'yes',
            initialGroupValue: 'yes',
          ),
        ));

        final semantics = tester.getSemantics(find.byType(Radio<String>));
        expect(semantics.flagsCollection.isChecked, CheckedState.isTrue);
      } finally {
        handle.dispose();
      }
    });

    testWidgets('calls onChanged and updates uncontrolled state when tapped',
        (tester) async {
      String? changedValue;

      await tester.pumpWidget(buildTestWidget(
        AppRadio<String>(
          value: 'yes',
          initialGroupValue: 'no',
          onChanged: (value) => changedValue = value,
        ),
      ));

      await tester.tap(find.byType(Radio<String>));
      await tester.pumpAndSettle();

      expect(changedValue, 'yes');
    });

    testWidgets('reflects controlled updates from the parent', (tester) async {
      final handle = tester.ensureSemantics();
      String? current = 'no';
      try {
        await tester.pumpWidget(buildTestWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return AppRadio<String>(
                value: 'yes',
                groupValue: current,
                onChanged: (value) => setState(() => current = value),
              );
            },
          ),
        ));

        await tester.tap(find.byType(Radio<String>));
        await tester.pumpAndSettle();

        final semantics = tester.getSemantics(find.byType(Radio<String>));
        expect(semantics.flagsCollection.isChecked, CheckedState.isTrue);
      } finally {
        handle.dispose();
      }
    });

    testWidgets('is non interactive when disabled', (tester) async {
      var changed = false;

      await tester.pumpWidget(buildTestWidget(
        AppRadio<String>(
          value: 'yes',
          initialGroupValue: 'no',
          enabled: false,
          onChanged: (_) => changed = true,
        ),
      ));

      await tester.tap(find.byType(Radio<String>));
      await tester.pumpAndSettle();

      expect(changed, isFalse);
    });

    testWidgets('passes through activeColor and toggleable options',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppRadio<String>(
          value: 'yes',
          groupValue: 'yes',
          toggleable: true,
          activeColor: AppTheme.success,
        ),
      ));

      final radio = tester.widget<Radio<String>>(find.byType(Radio<String>));
      expect(radio.activeColor, AppTheme.success);
      expect(radio.toggleable, isTrue);
    });

    testWidgets('uses the theme active color when no override is provided',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const AppRadio<String>(
          value: 'yes',
          groupValue: 'yes',
        ),
      ));

      final radio = tester.widget<Radio<String>>(find.byType(Radio<String>));
      expect(radio.activeColor, AppTheme.primary);
    });

    testWidgets('updates uncontrolled selection semantics after a tap',
        (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(buildTestWidget(
          AppRadio<String>(
            value: 'yes',
            initialGroupValue: 'no',
            onChanged: (_) {},
          ),
        ));

        await tester.tap(find.byType(Radio<String>));
        await tester.pumpAndSettle();

        final semantics = tester.getSemantics(find.byType(Radio<String>));
        expect(semantics.flagsCollection.isChecked, CheckedState.isTrue);
      } finally {
        handle.dispose();
      }
    });

    testWidgets('forwards density and tap target overrides', (tester) async {
      const density = VisualDensity(horizontal: -2, vertical: -2);

      await tester.pumpWidget(buildTestWidget(
        const AppRadio<String>(
          value: 'yes',
          groupValue: 'yes',
          visualDensity: density,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ));

      final radio = tester.widget<Radio<String>>(find.byType(Radio<String>));
      expect(radio.visualDensity, density);
      expect(
        radio.materialTapTargetSize,
        MaterialTapTargetSize.shrinkWrap,
      );
    });
  });
}
