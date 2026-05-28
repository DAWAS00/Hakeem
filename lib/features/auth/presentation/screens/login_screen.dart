import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/hakim_icons.dart';
import '../../../../shared/widgets/hakim_icon.dart';
import '../../../../core/constants/hakim_colors.dart' hide HakimRadius;
import '../../../../core/constants/hakim_spacing.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/app_settings_provider.dart';
import '../providers/login_notifier.dart';
import '../providers/login_state.dart';
import '../widgets/brand_header.dart';
import '../widgets/footer.dart';
import '../widgets/login_card.dart';

/// The primary login entry point for the Hakim application.
/// 
/// This screen provides a multi-input login form (phone, national ID, password)
/// and handles navigation to the home screen or signup flow.
/// It uses Riverpod for state management.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _passwordController = TextEditingController();

  final _phoneFocus = FocusNode();
  final _nationalIdFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _phoneController.dispose();
    _nationalIdController.dispose();
    _passwordController.dispose();
    _phoneFocus.dispose();
    _nationalIdFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    // Direct mock navigation to home
    context.go('/home');
  }

  void _onSanadPressed() {
    // TODO: launch Sanad OAuth flow
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginNotifierProvider);

    ref.listen<LoginState>(loginNotifierProvider, (_, next) {
      if (next.status == LoginStatus.success) {
        // TODO: navigate to home screen via GoRouter
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.login)),
        );
      }
    });

    final c = HakimColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: c.bgBase,
      resizeToAvoidBottomInset: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: HakimSpacing.xl,
              vertical: HakimSpacing.xl,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            ref.read(appSettingsProvider.notifier).toggleTheme(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: c.bgCard,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: c.border, width: 0.5),
                          ),
                          child: HakimIcon(
                            isDark ? HakimIcons.sun01 : HakimIcons.moon01,
                            size: 14,
                            color: c.textSecondary,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          final newLocale =
                              Localizations.localeOf(context).languageCode == 'ar'
                                  ? const Locale('en')
                                  : const Locale('ar');
                          ref.read(appSettingsProvider.notifier).setLocale(newLocale);
                        },
                        child: Text(
                          Localizations.localeOf(context).languageCode == 'ar'
                              ? 'English'
                              : 'عربي',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: HakimSpacing.lg),

                  const BrandHeader(),

                  const SizedBox(height: HakimSpacing.xxl),

                  LoginCard(
                    activeTab: state.activeTab,
                    phoneController: _phoneController,
                    nationalIdController: _nationalIdController,
                    passwordController: _passwordController,
                    phoneFocus: _phoneFocus,
                    nationalIdFocus: _nationalIdFocus,
                    passwordFocus: _passwordFocus,
                    obscurePassword: state.obscurePassword,
                    isLoading: state.isLoading,
                    errorMessage: state.hasError ? state.errorMessage : null,
                    onTabSwitch: ref.read(loginNotifierProvider.notifier).switchTab,
                    onTogglePassword:
                        ref.read(loginNotifierProvider.notifier).togglePassword,
                    onLoginPressed: _onLoginPressed,
                    onSanadPressed: _onSanadPressed,
                    onForgotPassword: () {
                      // TODO: navigate to forgot-password screen
                    },
                  ),

                  const SizedBox(height: HakimSpacing.xl),

                  Footer(
                    onRegisterTap: () {
                      context.push('/signup');
                    },
                  ),

                  const SizedBox(height: HakimSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
