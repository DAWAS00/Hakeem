import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/enums/login_method.dart';
import 'biometric_button.dart';
import 'error_banner.dart';
import 'national_id_field.dart';
import 'or_divider.dart';
import 'otp_hint.dart';
import 'password_field.dart';
import 'phone_field.dart';
import 'primary_button.dart';
import 'sanad_button.dart';
import 'tab_switcher.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({
    super.key,
    required this.activeTab,
    required this.phoneController,
    required this.nationalIdController,
    required this.passwordController,
    required this.phoneFocus,
    required this.nationalIdFocus,
    required this.passwordFocus,
    required this.obscurePassword,
    required this.isLoading,
    required this.errorMessage,
    required this.onTabSwitch,
    required this.onTogglePassword,
    required this.onLoginPressed,
    required this.onSanadPressed,
    required this.onForgotPassword,
  });

  final LoginMethod activeTab;
  final TextEditingController phoneController;
  final TextEditingController nationalIdController;
  final TextEditingController passwordController;
  final FocusNode phoneFocus;
  final FocusNode nationalIdFocus;
  final FocusNode passwordFocus;
  final bool obscurePassword;
  final bool isLoading;
  final String? errorMessage;
  final ValueChanged<LoginMethod> onTabSwitch;
  final VoidCallback onTogglePassword;
  final VoidCallback onLoginPressed;
  final VoidCallback onSanadPressed;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0x33000000)
                : const Color(0x11000000),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(HakimSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabSwitcher(active: activeTab, onSwitch: onTabSwitch),

          const SizedBox(height: HakimSpacing.lg),

          if (activeTab == LoginMethod.phone)
            PhoneField(
              controller: phoneController,
              focusNode: phoneFocus,
              nextFocus: passwordFocus,
            )
          else
            NationalIdField(
              controller: nationalIdController,
              focusNode: nationalIdFocus,
              nextFocus: passwordFocus,
            ),

          const SizedBox(height: HakimSpacing.md),

          PasswordField(
            controller: passwordController,
            focusNode: passwordFocus,
            obscureText: obscurePassword,
            onToggle: onTogglePassword,
            onSubmit: onLoginPressed,
          ),

          const SizedBox(height: HakimSpacing.sm),

          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onForgotPassword,
              child: Text(
                l10n.forgotPassword,
                style: TextStyle(
                  fontSize: 13,
                  color: HakimColorScheme.of(context).accent,
                  decoration: TextDecoration.underline,
                  decorationColor: HakimColorScheme.of(context).accent,
                ),
              ),
            ),
          ),

          const SizedBox(height: HakimSpacing.lg),

          PrimaryButton(
            label: l10n.login,
            isLoading: isLoading,
            onPressed: onLoginPressed,
          ),

          const SizedBox(height: HakimSpacing.sm),

          const OtpHint(),

          if (errorMessage != null) ...[
            const SizedBox(height: HakimSpacing.md),
            ErrorBanner(message: errorMessage!),
          ],

          const SizedBox(height: HakimSpacing.lg),
          const OrDivider(),
          const SizedBox(height: HakimSpacing.lg),

          SanadButton(onPressed: onSanadPressed),

          const SizedBox(height: HakimSpacing.md),

          const BiometricButton(),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 100.ms)
        .slideY(begin: 0.08, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }
}
