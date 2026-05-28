import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../shared/widgets/hakim_icon.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../domain/models/home_models.dart';
import '../providers/home_provider.dart';

// ─── Duration constants ────────────────────────────────────────────────────
const _kStaggerMs  = 35;
const _kItemDurMs  = 250;
const _kTotalMs    = _kStaggerMs * 8 + _kItemDurMs;
const _kSleepDelay = Duration(seconds: 30);
const _kCelebDelay = Duration(seconds: 2);

// ─── SpeedDialOverlay ──────────────────────────────────────────────────────
class SpeedDialOverlay extends ConsumerStatefulWidget {
  const SpeedDialOverlay({super.key, required this.items});
  final List<SpeedDialItem> items;

  @override
  ConsumerState<SpeedDialOverlay> createState() => _SpeedDialOverlayState();
}

class _SpeedDialOverlayState extends ConsumerState<SpeedDialOverlay>
    with SingleTickerProviderStateMixin {

  late final AnimationController _ctrl;
  late final List<Animation<double>> _itemAnims;
  late final Animation<double> _scrimOpacity;

  Timer? _sleepTimer;
  Timer? _celebTimer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _kTotalMs),
    );
    _scrimOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );
    final count = widget.items.length;
    _itemAnims = List.generate(count, (i) {
      final start = (i * _kStaggerMs) / _kTotalMs;
      final end   = start + (_kItemDurMs / _kTotalMs);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _ctrl,
          curve: Interval(
            start.clamp(0.0, 1.0),
            end.clamp(0.0, 1.0),
            curve: Curves.easeOutBack,
          ),
        ),
      );
    });
    _startSleepTimer();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _sleepTimer?.cancel();
    _celebTimer?.cancel();
    super.dispose();
  }

  // ── Sleep timer ────────────────────────────────────────────────────────
  void _startSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = Timer(_kSleepDelay, () => _setMascot(MascotState.sleepy));
  }

  void _setMascot(MascotState s) {
    if (mounted) ref.read(mascotStateProvider.notifier).set(s);
  }

  // ── Open / close ───────────────────────────────────────────────────────
  void _toggle() {
    final isOpen = ref.read(speedDialProvider);
    ref.read(speedDialProvider.notifier).toggle();
    if (!isOpen) {
      _sleepTimer?.cancel();
      _celebTimer?.cancel();
      _setMascot(MascotState.happy);
      _ctrl.forward();
    } else {
      _close();
    }
  }

  void _close() {
    ref.read(speedDialProvider.notifier).close();
    _ctrl.reverse();
    _setMascot(MascotState.idle);
    _startSleepTimer();
  }

  // ── Item interaction ───────────────────────────────────────────────────
  void _onItemHover(MascotState state) => _setMascot(state);

  void _onItemHoverEnd() => _setMascot(MascotState.happy);

  void _onItemTapped(SpeedDialItem item) {
    item.onTap?.call();
    _setMascot(MascotState.celebrating);
    _ctrl.reverse();
    ref.read(speedDialProvider.notifier).close();
    _celebTimer?.cancel();
    _celebTimer = Timer(_kCelebDelay, () {
      _setMascot(MascotState.idle);
      _startSleepTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = ref.watch(speedDialProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        isOpen ? _ctrl.forward() : _ctrl.reverse();
      }
    });

    return Stack(
      children: [
        // Scrim
        AnimatedBuilder(
          animation: _scrimOpacity,
          builder: (context, child) => IgnorePointer(
            ignoring: !isOpen,
            child: GestureDetector(
              onTap: _close,
              child: Container(
                color: Colors.black.withValues(alpha: _scrimOpacity.value * 0.5),
              ),
            ),
          ),
        ),

        // Dial items
        if (isOpen || !_ctrl.isDismissed)
          Positioned(
            bottom: 210,
            right: 18,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(widget.items.length, (i) {
                final index = widget.items.length - 1 - i;
                final item  = widget.items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AnimatedBuilder(
                    animation: _itemAnims[index],
                    builder: (context, child) {
                      final t = _itemAnims[index].value;
                      return Transform.translate(
                        offset: Offset(0, (1 - t) * 30),
                        child: Opacity(opacity: t.clamp(0.0, 1.0), child: child),
                      );
                    },
                    child: _DialItem(
                      item: item,
                      onTap:       () => _onItemTapped(item),
                      onHover:     () => _onItemHover(item.mascotState),
                      onHoverEnd:  _onItemHoverEnd,
                    ),
                  ),
                );
              }),
            ),
          ),

        // Mascot FAB
        Positioned(
          bottom: 114,
          right: 18,
          child: _MascotFab(onTap: _toggle),
        ),
      ],
    );
  }
}

// ─── Mascot FAB ────────────────────────────────────────────────────────────
class _MascotFab extends ConsumerWidget {
  const _MascotFab({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mascot = ref.watch(mascotStateProvider);

    return GestureDetector(
      onTap: onTap,
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
    );
  }
}

// ─── Dial item ─────────────────────────────────────────────────────────────
class _DialItem extends StatefulWidget {
  const _DialItem({
    required this.item,
    required this.onTap,
    required this.onHover,
    required this.onHoverEnd,
  });

  final SpeedDialItem item;
  final VoidCallback onTap;
  final VoidCallback onHover;
  final VoidCallback onHoverEnd;

  @override
  State<_DialItem> createState() => _DialItemState();
}

class _DialItemState extends State<_DialItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
        widget.onHover();
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _pressed = false);
        widget.onHoverEnd();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Theme.of(context).dividerColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                widget.item.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color ??
                      HakimColorScheme.of(context).textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: widget.item.bgColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.item.bgColor.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: HakimIcon(
                  widget.item.icon,
                  size: 22,
                  color: widget.item.iconColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
