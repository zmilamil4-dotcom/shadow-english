import 'package:flutter/material.dart';
import '../app_theme.dart';

/// Lightweight atmospheric background — uses fading RadialGradients instead
/// of BackdropFilter/Gaussian blur to stay cheap on Android devices.
class EchoBackground extends StatelessWidget {
  final Widget child;
  const EchoBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Stack(
        children: [
          const Positioned(
            top: -120,
            left: -80,
            child: _Glow(color: AppTheme.accentPurple, size: 320),
          ),
          const Positioned(
            top: 180,
            right: -100,
            child: _Glow(color: AppTheme.accentBlue, size: 280),
          ),
          const Positioned(
            bottom: -100,
            left: 40,
            child: _Glow(color: AppTheme.accentPink, size: 260),
          ),
          child,
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final Color color;
  final double size;
  const _Glow({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: 0.28), color.withValues(alpha: 0.0)],
          ),
        ),
      ),
    );
  }
}
