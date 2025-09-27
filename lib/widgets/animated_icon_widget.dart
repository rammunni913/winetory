import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedIconWidget extends StatelessWidget {
  final IconData icon;

  const AnimatedIconWidget({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 48,
        color: Colors.black,
      ),
    ).animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 2000.ms, colors: [
          Colors.transparent,
          Colors.white.withOpacity(0.3),
          Colors.transparent,
        ]);
  }
}
