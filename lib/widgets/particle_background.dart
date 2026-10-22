import 'dart:math';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ParticleBackground extends StatefulWidget {
  final Widget child;

  const ParticleBackground({super.key, required this.child});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final Random _random = Random(42);
  late final List<_AlchemicalParticle> _particles;

  @override
  void initState() {
    super.initState();

    final colors = [
      AppTheme.accentLight,
      AppTheme.gold,
      AppTheme.sapphire,
      Colors.white,
    ];

    _particles = List.generate(40, (index) {
      return _AlchemicalParticle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: 1.0 + _random.nextDouble() * 2.2,
        speed: 0.05 + _random.nextDouble() * 0.15,
        opacity: 0.12 + _random.nextDouble() * 0.28,
        color: colors[_random.nextInt(colors.length)],
        driftPhase: _random.nextDouble() * 2 * pi,
      );
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.4),
                radius: 1.2,
                colors: [Color(0xFF101726), AppTheme.background],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _AlchemicalParticlePainter(
              particles: _particles,
              animation: _controller,
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _AlchemicalParticle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;
  final Color color;
  final double driftPhase;

  const _AlchemicalParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.color,
    required this.driftPhase,
  });
}

class _AlchemicalParticlePainter extends CustomPainter {
  final List<_AlchemicalParticle> particles;
  final Animation<double> animation;

  _AlchemicalParticlePainter({required this.particles, required this.animation})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final t = animation.value;

    for (final particle in particles) {
      // Floating upwards gently like mystic alchemical motes
      final progress = (particle.y - (t * particle.speed)) % 1.0;
      final y = (progress < 0 ? 1.0 + progress : progress) * size.height;
      final horizontalDrift = sin(t * 2 * pi + particle.driftPhase) * 12;
      final x = (particle.x * size.width + horizontalDrift) % size.width;

      final paint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity);

      canvas.drawCircle(Offset(x, y), particle.size, paint);

      // Subtle glow halo for larger motes
      if (particle.size > 2.0) {
        final glowPaint = Paint()
          ..color = particle.color.withValues(alpha: particle.opacity * 0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawCircle(Offset(x, y), particle.size * 2.2, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _AlchemicalParticlePainter oldDelegate) => false;
}
