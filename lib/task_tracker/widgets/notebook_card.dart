import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'washi_tape.dart';

/// Tactile sticky memo & notebook paper card from Stitch Design System
class NotebookCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double tiltAngle; // Degrees (e.g. -0.5, 1.0)
  final bool hasWashiTape;
  final Color? washiColor;
  final String? washiText;
  final bool hasPaperclip;
  final bool hasThumbtack;
  final bool showRuledLines;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;

  const NotebookCard({
    Key? key,
    required this.child,
    this.backgroundColor = AppTheme.paperWhite,
    this.tiltAngle = 0.0,
    this.hasWashiTape = false,
    this.washiColor,
    this.washiText,
    this.hasPaperclip = false,
    this.hasThumbtack = false,
    this.showRuledLines = false,
    this.padding = const EdgeInsets.all(AppTheme.spaceMd),
    this.margin = const EdgeInsets.only(bottom: AppTheme.spaceMd),
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget cardBody = Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppTheme.borderRadiusLg,
        border: AppTheme.doodleBorder(2.0),
        boxShadow: AppTheme.doodleShadow(3.0),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Ruled paper lines background
          if (showRuledLines)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: AppTheme.borderRadiusLg,
                child: CustomPaint(
                  painter: _RuledPaperPainter(),
                ),
              ),
            ),

          // Main Card Content
          Padding(
            padding: padding,
            child: child,
          ),

          // Optional Center Washi Tape
          if (hasWashiTape)
            Positioned(
              top: -8,
              left: 0,
              right: 0,
              child: Center(
                child: WashiTape(
                  color: washiColor ?? AppTheme.pastelLilac.withAlpha(210),
                  text: washiText,
                  rotation: tiltAngle != 0 ? -tiltAngle * 1.5 : -1.5,
                ),
              ),
            ),

          // Optional Paperclip visual anchor
          if (hasPaperclip)
            Positioned(
              top: -10,
              right: 28,
              child: CustomPaint(
                size: const Size(20, 36),
                painter: _PaperclipPainter(),
              ),
            ),

          // Optional Red Thumbtack visual
          if (hasThumbtack)
            Positioned(
              top: -8,
              left: 20,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppTheme.error,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.inkColor, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (onTap != null) {
      cardBody = InkWell(
        onTap: onTap,
        borderRadius: AppTheme.borderRadiusLg,
        child: cardBody,
      );
    }

    if (tiltAngle != 0.0) {
      cardBody = Transform.rotate(
        angle: tiltAngle * (math.pi / 180),
        child: cardBody,
      );
    }

    return Padding(
      padding: margin,
      child: cardBody,
    );
  }
}

class _RuledPaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.outlineVariant.withAlpha(50)
      ..strokeWidth = 1.0;

    const lineSpacing = 24.0;
    for (double y = lineSpacing; y < size.height; y += lineSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PaperclipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF615B71)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.35, size.height * 0.25)
      ..lineTo(size.width * 0.35, size.height * 0.75)
      ..arcToPoint(
        Offset(size.width * 0.65, size.height * 0.75),
        radius: Radius.circular(size.width * 0.15),
        clockwise: false,
      )
      ..lineTo(size.width * 0.65, size.height * 0.15)
      ..arcToPoint(
        Offset(size.width * 0.95, size.height * 0.15),
        radius: Radius.circular(size.width * 0.15),
        clockwise: true,
      )
      ..lineTo(size.width * 0.95, size.height * 0.65);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

