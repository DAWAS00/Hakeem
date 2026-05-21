import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hakeem/core/l10n/app_localizations.dart';
import 'package:hakeem/features/auth/presentation/screens/signup_screen.dart';

void main() {
  Widget createSignupScreen() {
    return const ProviderScope(
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('ar'), Locale('en')],
        locale: Locale('en'),
        home: SignupScreen(),
      ),
    );
  }

  testWidgets('SignupScreen renders all steps correctly', (tester) async {
    // Set a larger surface size to avoid off-screen issues
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(createSignupScreen());
    await tester.pumpAndSettle();

    // Verify Step 1: Personal Info
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Personal Information'), findsOneWidget);

    // Enter Full Name
    await tester.enterText(find.byType(TextFormField).at(0), 'Ahmad Mohammad');
    
    // Enter National ID
    await tester.enterText(find.byType(TextFormField).at(1), '9123456789');

    // Enter DOB (it's readOnly, so we set controller text directly or tap picker)
    await tester.tap(find.byType(TextFormField).at(2));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK')); // English OK
    await tester.pumpAndSettle();

    // Select Gender
    await tester.tap(find.text('Male'));
    await tester.pumpAndSettle();

    // Enter Phone
    await tester.enterText(find.byType(TextFormField).at(3), '777123456');
    await tester.pumpAndSettle();

    // Tap Next
    final nextButton = find.text('Next');
    await tester.ensureVisible(nextButton);
    await tester.tap(nextButton);
    await tester.pumpAndSettle();

    // Verify Step 2: Contact Info
    expect(find.text('Contact Information'), findsOneWidget);
  });
}
