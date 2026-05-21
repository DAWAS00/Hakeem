import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';
import '../providers/login_notifier.dart';

class BiometricButton extends ConsumerWidget {
  const BiometricButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canUseBiometric = ref.watch(
      loginNotifierProvider.select((s) => s.canUseBiometric),
    );

    if (!canUseBiometric) return const SizedBox.shrink();

    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () =>
            ref.read(loginNotifierProvider.notifier).loginWithBiometric(),
        icon: const Icon(Icons.fingerprint, size: 22, color: HakimColors.accent),
        label: const Text(
          'تسجيل الدخول بالبصمة',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: HakimColors.accent,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: HakimColors.borderFocus),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.lg),
        ),
      ),
    );
  }
}
