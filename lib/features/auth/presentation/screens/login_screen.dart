import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/constants/hakim_spacing.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/app_settings_provider.dart';
import '../providers/login_notifier.dart';
import '../providers/login_state.dart';
import '../widgets/brand_header.dart';
import '../widgets/footer.dart';
import '../widgets/login_card.dart';

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

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
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
                      IconButton(
                        onPressed: () =>
                            ref.read(appSettingsProvider.notifier).toggleTheme(),
                        icon: HugeIcon(
                          icon: Theme.of(context).brightness == Brightness.dark
                              ? HugeIcons.strokeRoundedSun01
                              : HugeIcons.strokeRoundedMoon01,
                          size: 24,
                          color: Theme.of(context).iconTheme.color ?? (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
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
