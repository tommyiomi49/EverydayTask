import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'notebook_card.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? badge;
  final String? emoji;
  final double tilt;
  final bool hasPaperclip;
  final VoidCallback? onTap;

  const StatsCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.badge,
    this.emoji,
    this.tilt = 0.0,
    this.hasPaperclip = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotebookCard(
      backgroundColor: color,
      tiltAngle: tilt,
      hasWashiTape: !hasPaperclip,
      washiColor: color.withAlpha(200),
      hasPaperclip: hasPaperclip,
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Icon circle + badge / emoji
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.paperWhite.withAlpha(200),
                  shape: BoxShape.circle,
                  border: AppTheme.doodleBorder(1.2),
                  boxShadow: AppTheme.doodleShadow(1.0),
                ),
                child: Icon(icon, size: 18, color: AppTheme.inkColor),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.paperWhite.withAlpha(200),
                    borderRadius: BorderRadius.circular(4),
                    border: AppTheme.doodleBorder(1.0),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                )
              else if (emoji != null)
                Text(emoji!, style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),

          // Value and Title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      height: 1.0,
                    ),
              ),
              const SizedBox(height: 3),
              Text(
                title.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
