import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Tactile hand-drawn checkbox with celebration spark
class DoodleCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const DoodleCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<DoodleCheckbox> createState() => _DoodleCheckboxState();
}

class _DoodleCheckboxState extends State<DoodleCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  bool _showSparkle = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTap() {
    final newValue = !widget.value;
    if (newValue) {
      _animController.forward().then((_) => _animController.reverse());
      setState(() => _showSparkle = true);
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) setState(() => _showSparkle = false);
      });
    }
    widget.onChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: _handleTap,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: widget.value ? AppTheme.pastelMint : AppTheme.paperCard,
                borderRadius: BorderRadius.circular(7),
                border: AppTheme.doodleBorder(2.0),
                boxShadow: AppTheme.doodleShadow(1.5),
              ),
              child: Center(
                child: widget.value
                    ? const Icon(
                        Icons.check_rounded,
                        size: 20,
                        color: AppTheme.pastelMintDark,
                      )
                    : null,
              ),
            ),
          ),
        ),
        if (_showSparkle)
          const Positioned(
            top: -16,
            right: -10,
            child: Text(
              '🎉',
              style: TextStyle(fontSize: 16),
            ),
          ),
      ],
    );
  }
}

