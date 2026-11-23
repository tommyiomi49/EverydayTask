import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Ruler progress bar from Stitch "Weekly Goal Tracker"
class RulerProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String label;

  const RulerProgressBar({
    Key? key,
    required this.progress,
    this.label = 'Weekly Goal Tracker',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final percentage = (clampedProgress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceSm),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: AppTheme.borderRadiusMd,
        border: AppTheme.doodleBorder(2.0),
        boxShadow: AppTheme.doodleShadow(2.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.straighten_rounded,
                      size: 18,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.pastelMint,
                    borderRadius: AppTheme.borderRadiusFull,
                    border: AppTheme.doodleBorder(1.0),
                    boxShadow: AppTheme.doodleShadow(1.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$percentage% Finished',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.pastelMintDark,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text('🎯', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Ruler Bar
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                height: 24,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.paperWhite,
                  borderRadius: AppTheme.borderRadiusDefault,
                  border: AppTheme.doodleBorder(1.5),
                ),
                child: Stack(
                  children: [
                    // Ruler Tick Marks Overlay
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _RulerTicksPainter(),
                      ),
                    ),

                    // Highlighter marker fill
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: clampedProgress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.pastelYellow.withAlpha(220),
                          borderRadius: BorderRadius.horizontal(
                            left: const Radius.circular(6),
                            right: clampedProgress >= 0.98
                                ? const Radius.circular(6)
                                : Radius.zero,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 2),
                            child: Icon(
                              Icons.edit_rounded,
                              size: 12,
                              color: AppTheme.onPrimaryFixedVariant.withAlpha(200),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RulerTicksPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.textOutline.withAlpha(120)
      ..strokeWidth = 1.0;

    const tickSpacing = 8.0;
    int tickIndex = 0;

    for (double x = 4; x < size.width - 4; x += tickSpacing) {
      double tickHeight;
      if (tickIndex % 4 == 0) {
        tickHeight = 12.0; // Major inch mark
        paint.strokeWidth = 1.5;
      } else if (tickIndex % 2 == 0) {
        tickHeight = 8.0; // Half mark
        paint.strokeWidth = 1.0;
      } else {
        tickHeight = 5.0; // Sub tick
        paint.strokeWidth = 0.8;
      }

      canvas.drawLine(
        Offset(x, size.height - tickHeight - 2),
        Offset(x, size.height - 2),
        paint,
      );
      tickIndex++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
