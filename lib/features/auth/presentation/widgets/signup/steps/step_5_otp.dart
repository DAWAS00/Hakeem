import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import 'package:hakeem/core/constants/hakim_icons.dart';
import 'package:hakeem/core/l10n/app_localizations.dart';
import '../../otp_hint.dart';
import '../signup_step_card.dart';
import '../signup_card_header.dart';

class Step5Otp extends StatefulWidget {
  const Step5Otp({
    super.key,
    required this.isLoading,
    required this.onVerify,
    required this.onResend,
  });

  final bool isLoading;
  final ValueChanged<String> onVerify;
  final VoidCallback onResend;

  @override
  State<Step5Otp> createState() => _Step5OtpState();
}

class _Step5OtpState extends State<Step5Otp> {
  final _codeCtrl = TextEditingController();

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = HakimColorScheme.of(context);

    final defaultPinTheme = PinTheme(
      width: 48,
      height: 52,
      textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: c.textPrimary,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(HakimSpacing.xl),
      child: Column(
        children: [
          SignupStepCard(
            child: Column(
              children: [
                SignupCardHeader(
                  icon: HakimIcons.smsOutlined,
                  title: l10n.otpVerification,
                  subtitle: l10n.otpVerificationSubtitle,
                ),
                const SizedBox(height: HakimSpacing.md),
                const OtpHint(),
                const SizedBox(height: HakimSpacing.lg),
                Pinput(
                  length: 6,
                  controller: _codeCtrl,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration?.copyWith(
                      border: Border.all(color: c.primary, width: 1.5),
                    ),
                  ),
                  enabled: !widget.isLoading,
                ),
              ],
            ),
          ),
          const SizedBox(height: HakimSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: widget.isLoading || _codeCtrl.text.length != 6
                  ? null
                  : () => widget.onVerify(_codeCtrl.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: c.sanad,
                disabledBackgroundColor: c.sanad.withValues(alpha: 0.35),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(
                      l10n.otpVerifyButton,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
            ),
          ),
          const SizedBox(height: HakimSpacing.md),
          TextButton(
            onPressed: widget.isLoading ? null : widget.onResend,
            child: Text(
              l10n.otpResend,
              style: TextStyle(fontSize: 13, color: c.accent),
            ),
          ),
          const SizedBox(height: HakimSpacing.xl),
        ],
      ),
    );
  }
}
