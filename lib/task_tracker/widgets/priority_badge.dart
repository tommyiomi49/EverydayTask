import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PriorityBadge extends StatelessWidget {
  final String priority;
  final bool compact;

  const PriorityBadge({
    Key? key,
    required this.priority,
    this.compact = false,
  }) : super(key: key);

  Color get _bgColor {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.pastelPink;
      case 'medium':
        return AppTheme.pastelYellow;
      case 'low':
      default:
        return AppTheme.pastelMint;
    }
  }

  Color get _textColor {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.pastelPinkDark;
      case 'medium':
        return AppTheme.onPrimaryFixedVariant;
      case 'low':
      default:
        return AppTheme.pastelMintDark;
    }
  }

  String get _dotEmoji {
    switch (priority.toLowerCase()) {
      case 'high':
        return '🔴';
      case 'medium':
        return '🟡';
      case 'low':
      default:
        return '🟢';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: AppTheme.borderRadiusFull,
          border: AppTheme.doodleBorder(1.2),
          boxShadow: AppTheme.doodleShadow(1.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              priority.toUpperCase(),
              style: TextStyle(
                color: _textColor,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(width: 3),
            Text(_dotEmoji, style: const TextStyle(fontSize: 9)),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: AppTheme.borderRadiusFull,
        border: AppTheme.doodleBorder(1.5),
        boxShadow: AppTheme.doodleShadow(1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$priority Priority',
            style: TextStyle(
              color: _textColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 4),
          Text(_dotEmoji, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
