import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hakeem/features/patient_dashboard/presentation/screens/dashboard_screen.dart';
import 'package:hakeem/features/ai_assistant/presentation/screens/ai_assistant_screen.dart';
import 'package:hakeem/features/home/presentation/screens/home_screen.dart';
import 'package:hakeem/features/smart_health/presentation/screens/smart_health_screen.dart';
import 'package:hakeem/features/settings/presentation/screens/settings_screen.dart';
import 'package:hakeem/features/main_layout/presentation/widgets/custom_bottom_nav_bar.dart';

class MainLayoutScreen extends ConsumerStatefulWidget {
  final GoRouterState state;
  final Widget child;

  const MainLayoutScreen({
    super.key,
    required this.state,
    required this.child,
  });

  @override
  ConsumerState<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends ConsumerState<MainLayoutScreen> {
  late PageController _pageController;

  List<String> get _paths => CustomBottomNavBar.items.map((e) => e.routePath).toList();

  int get _currentIndex {
    final path = widget.state.uri.path;
    final index = _paths.indexOf(path);
    return index != -1 ? index : 2; // Default to Home (index 2)
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void didUpdateWidget(MainLayoutScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If route changed externally (e.g. via code or deep link), animate PageView
    final newIndex = _currentIndex;
    if (_pageController.hasClients && _pageController.page?.round() != newIndex) {
      _pageController.animateToPage(
        newIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (_currentIndex != index) {
      context.go(_paths[index]);
    }
  }

  void _onBottomNavTap(int index) {
    // Navigate via GoRouter; didUpdateWidget will handle PageController animation
    context.go(_paths[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: const [
          DashboardScreen(),
          AiAssistantScreen(),
          HomeScreen(),
          SmartHealthScreen(),
          SettingsScreen(),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
