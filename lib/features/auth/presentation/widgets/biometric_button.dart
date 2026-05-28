import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';
import '../../../../core/constants/hakim_icons.dart';
import '../../../../shared/widgets/hakim_icon.dart';
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
        icon: HakimIcon(HakimIcons.fingerprint, size: 22, color: HakimColorScheme.of(context).accent),
        label: Text(
          'تسجيل الدخول بالبصمة',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: HakimColorScheme.of(context).accent,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: HakimColorScheme.of(context).borderFocus),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.lg),
        ),
      ),
    );
  }
}
