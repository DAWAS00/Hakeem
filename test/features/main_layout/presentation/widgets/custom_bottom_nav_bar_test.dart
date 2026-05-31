import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hakeem/shared/widgets/hakim_icon.dart';
import 'package:hakeem/features/main_layout/presentation/widgets/custom_bottom_nav_bar.dart';

void main() {
  Widget createWidgetUnderTest({
    required int currentIndex,
    required Function(int) onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: currentIndex,
          onTap: onTap,
        ),
      ),
    );
  }

  testWidgets('CustomBottomNavBar renders all items', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(
      currentIndex: 2,
      onTap: (_) {},
    ));
    
    // Allow animations to finish
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('حكيم'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('صحتي'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    
    // Check for HakimIcons (there should be 5 now)
    expect(find.byType(HakimIcon), findsNWidgets(5));
  });

  testWidgets('Tapping an item calls onTap with correct index', (WidgetTester tester) async {
    int? tappedIndex;
    
    await tester.pumpWidget(createWidgetUnderTest(
      currentIndex: 2,
      onTap: (index) => tappedIndex = index,
    ));
    
    await tester.pumpAndSettle();

    // Tap Dashboard (index 0)
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();

    expect(tappedIndex, 0);

    // Tap حكيم (index 1)
    await tester.tap(find.text('حكيم'));
    await tester.pumpAndSettle();

    expect(tappedIndex, 1);

    // Tap صحتي (index 3)
    await tester.tap(find.text('صحتي'));
    await tester.pumpAndSettle();

    expect(tappedIndex, 3);
  });
}
