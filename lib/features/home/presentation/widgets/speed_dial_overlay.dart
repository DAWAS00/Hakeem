import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../domain/models/home_models.dart';
import '../providers/home_provider.dart';

class SpeedDialOverlay extends ConsumerStatefulWidget {
  const SpeedDialOverlay({
    super.key,
    required this.items,
  });

  final List<SpeedDialItem> items;

  @override
  ConsumerState<SpeedDialOverlay> createState() => _SpeedDialOverlayState();
}

class _SpeedDialOverlayState extends ConsumerState<SpeedDialOverlay>
    with SingleTickerProviderStateMixin {

  late final AnimationController _ctrl;
  late final List<Animation<double>> _itemAnims;
  late final Animation<double> _fabRotation;
  late final Animation<double> _scrimOpacity;

  static const _kStaggerMs   = 35;
  static const _kItemDurMs   = 250;
  static const _kTotalMs     = _kStaggerMs * 8 + _kItemDurMs;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _kTotalMs),
    );

    _fabRotation = Tween<double>(begin: 0, end: math.pi / 4).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
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
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _sync(bool isOpen) {
    if (isOpen) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
  }

  void _toggle() {
    final isOpen = ref.read(speedDialProvider);
    ref.read(speedDialProvider.notifier).toggle();
    _sync(!isOpen);
  }

  void _close() {
    ref.read(speedDialProvider.notifier).close();
    _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = ref.watch(speedDialProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _sync(isOpen);
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
                color: (isDark ? HakimColors.bgBase : Colors.black)
                    .withValues(alpha: _scrimOpacity.value * 0.7),
              ),
            ),
          ),
        ),

        // Items (Vertical list)
        if (isOpen || !_ctrl.isDismissed)
          Positioned(
            bottom: 140, // Above FAB
            right: 18,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(widget.items.length, (i) {
                // Reverse list for layout so first item in list is bottom-most
                final index = widget.items.length - 1 - i;
                final item = widget.items[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AnimatedBuilder(
                    animation: _itemAnims[index],
                    builder: (context, child) {
                      final t = _itemAnims[index].value;
                      return Transform.translate(
                        offset: Offset(0, (1.0 - t) * 30),
                        child: Opacity(
                          opacity: t.clamp(0.0, 1.0),
                          child: child,
                        ),
                      );
                    },
                    child: _DialItem(item: item, onTap: () {
                      item.onTap?.call();
                      _close();
                    }),
                  ),
                );
              }),
            ),
          ),

        // FAB
        Positioned(
          bottom: 72,
          right:  18,
          child: _SpeedDialFab(
            rotation: _fabRotation,
            isOpen: isOpen,
            onTap: _toggle,
          ),
        ),
      ],
    );
  }
}

class _DialItem extends StatelessWidget {
  const _DialItem({required this.item, required this.onTap});

  final SpeedDialItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
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
            item.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColors.textPrimary,
            ),
          ),
        ),

        const SizedBox(width: 12),

        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item.bgColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: item.bgColor.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: HugeIcon(
                icon: item.icon,
                size: 22,
                color: item.iconColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SpeedDialFab extends StatelessWidget {
  const _SpeedDialFab({
    required this.rotation,
    required this.isOpen,
    required this.onTap,
  });

  final Animation<double> rotation;
  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: isOpen ? HakimColors.error : HakimColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (isOpen ? HakimColors.error : HakimColors.primary)
                  .withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: AnimatedBuilder(
          animation: rotation,
          builder: (_, child) => Transform.rotate(
            angle: rotation.value,
            child: child,
          ),
          child: const HugeIcon(
            icon: HugeIcons.strokeRoundedAdd01,
            size: 28,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
