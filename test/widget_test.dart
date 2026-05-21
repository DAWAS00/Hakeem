import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hakeem/features/auth/presentation/screens/login_screen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hakeem/core/l10n/app_localizations.dart';

void main() {
  testWidgets('LoginScreen renders without crashing', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('ar'), Locale('en')],
          locale: Locale('ar'),
          home: LoginScreen(),
        ),
      ),
    );
    // Advance past all flutter_animate entrance animations (max duration ~500ms)
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
