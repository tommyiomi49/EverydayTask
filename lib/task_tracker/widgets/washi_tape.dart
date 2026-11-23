import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Translucent decorative washi tape strip from Stitch "Paper Planner"
class WashiTape extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;
  final double rotation; // In degrees
  final String? text;
  final IconData? icon;

  const WashiTape({
    Key? key,
    this.width = 110,
    this.height = 18,
    this.color,
    this.rotation = -2.0,
    this.text,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tapeColor = color ?? AppTheme.pastelLilac.withAlpha(210);

    return Transform.rotate(
      angle: rotation * (math.pi / 180),
      child: Container(
        width: text != null ? null : width,
        height: height,
        padding: text != null
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 2)
            : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: tapeColor,
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              offset: const Offset(1, 1),
              blurRadius: 1,
            ),
          ],
        ),
        child: text != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 13, color: AppTheme.inkColor),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    text!,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.inkColor.withAlpha(220),
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              )
            : Center(
                child: Container(
                  height: 1,
                  width: width * 0.6,
                  color: Colors.black.withAlpha(15),
                ),
              ),
      ),
    );
  }
}

