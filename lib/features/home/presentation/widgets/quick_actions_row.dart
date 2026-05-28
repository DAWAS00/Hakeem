import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../shared/widgets/hakim_icon.dart';
import '../../domain/models/home_models.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key, required this.actions});
  final List<QuickAction> actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: actions
          .map((a) => Expanded(child: _QuickActionButton(action: a)))
          .toList(),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({required this.action});
  final QuickAction action;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);

    return GestureDetector(
      onTap: action.onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: action.bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: HakimIcon(action.icon, size: 24, color: action.iconColor),
          ),
          const SizedBox(height: 6),
          Text(
            action.label,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: c.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
