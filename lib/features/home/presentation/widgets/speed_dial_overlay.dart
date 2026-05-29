import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/home_models.dart';
import '../providers/home_provider.dart';
import '../../../assistant/presentation/widgets/voice_assistant_sheet.dart';

// ─── Duration constants ────────────────────────────────────────────────────
const _kSleepDelay = Duration(seconds: 30);

// ─── SpeedDialOverlay (Now acts as a direct AI Chat FAB) ────────────────────
class SpeedDialOverlay extends ConsumerStatefulWidget {
  const SpeedDialOverlay({super.key, required this.items});
  // We keep the items parameter for compatibility, but won't display the list
  final List<SpeedDialItem> items;

  @override
  ConsumerState<SpeedDialOverlay> createState() => _SpeedDialOverlayState();
}

class _SpeedDialOverlayState extends ConsumerState<SpeedDialOverlay> {
  Timer? _sleepTimer;

  @override
  void initState() {
    super.initState();
    _startSleepTimer();
  }

  @override
  void dispose() {
    _sleepTimer?.cancel();
    super.dispose();
  }

  void _startSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = Timer(_kSleepDelay, () => _setMascot(MascotState.sleepy));
  }

  void _setMascot(MascotState s) {
    if (mounted) ref.read(mascotStateProvider.notifier).set(s);
  }

  void _onMascotTap() {
    _setMascot(MascotState.happy);
    // Navigate directly to AI Assistant
    context.push('/assistant');
    
    // Reset sleep timer after interaction
    _startSleepTimer();
  }

  void _onMascotLongPress() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const VoiceAssistantSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Mascot FAB - Positioned fixed above the bottom bar
        Positioned(
          bottom: 114,
          right: 18,
          child: _MascotFab(
            onTap: _onMascotTap,
            onLongPress: _onMascotLongPress,
          ),
        ),
      ],
    );
  }
}

// ─── Mascot FAB ────────────────────────────────────────────────────────────
class _MascotFab extends ConsumerWidget {
  const _MascotFab({required this.onTap, required this.onLongPress});
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mascot = ref.watch(mascotStateProvider);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Hero(
        tag: 'mascot-hero',
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: ScaleTransition(scale: anim, child: child),
          ),
          child: mascot == MascotState.idle
              ? SvgPicture.asset(
                  mascot.assetPath,
                  key: const ValueKey('idle'),
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveY(
                    begin: 0,
                    end: -5,
                    duration: 2400.ms,
                    curve: Curves.easeInOut,
                  )
              : SvgPicture.asset(
                  mascot.assetPath,
                  key: ValueKey(mascot),
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
        ),
      ),
    );
  }
}
