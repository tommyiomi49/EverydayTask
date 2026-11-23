import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool isOverdue;

  const StatusBadge({
    Key? key,
    required this.status,
    this.isOverdue = false,
  }) : super(key: key);

  Color get _bgColor {
    if (isOverdue) return AppTheme.pastelPink;
    switch (status.toLowerCase()) {
      case 'completed':
        return AppTheme.pastelMint;
      case 'in progress':
        return AppTheme.pastelLilac;
      case 'pending':
      default:
        return AppTheme.pastelYellow;
    }
  }

  Color get _textColor {
    if (isOverdue) return AppTheme.pastelPinkDark;
    switch (status.toLowerCase()) {
      case 'completed':
        return AppTheme.pastelMintDark;
      case 'in progress':
        return AppTheme.pastelLilacDark;
      case 'pending':
      default:
        return AppTheme.pastelYellowDark;
    }
  }

  String get _displayLabel {
    if (isOverdue) return 'Overdue';
    return status;
  }

  IconData get _icon {
    if (isOverdue) return Icons.warning_amber_rounded;
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle_rounded;
      case 'in progress':
        return Icons.timelapse_rounded;
      case 'pending':
      default:
        return Icons.schedule_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: AppTheme.borderRadiusFull,
        border: AppTheme.doodleBorder(1.2),
        boxShadow: AppTheme.doodleShadow(1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 13, color: _textColor),
          const SizedBox(width: 4),
          Text(
            _displayLabel,
            style: TextStyle(
              color: _textColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
