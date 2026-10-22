import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_mvvm_template/app.dart';
import 'package:flutter_mvvm_template/store/auth_state_provider.dart';

import '../helpers.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('splash → login → home, then sign out', (tester) async {
    await tester.pumpWidget(
      ProviderScope(overrides: testOverrides(), child: const MainApp()),
    );
    await tester.pump(AuthStateController.splashHold);
    await tester.pumpAndSettle();

    expect(find.text('Sign in'), findsWidgets);

    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pump();
    expect(find.text('Enter your phone number.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), '08012345678');
    await tester.enterText(find.byType(TextField).at(1), 'secret1');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Hi, Ada'), findsOneWidget);
    expect(find.text('Welcome aboard'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(FilledButton, 'Sign in'), findsOneWidget);
  });
}
