import 'dart:math';

import 'package:flutter/material.dart';

class ParticleBackground extends StatefulWidget {
  final Widget child;

  const ParticleBackground({
    super.key,
    required this.child,
  });

  @override
  State<ParticleBackground> createState() =>
      _ParticleBackgroundState();
}

class _ParticleBackgroundState
    extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final Random _random = Random();

  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();

    _particles = List.generate(
      35,
          (_) => _Particle.random(_random),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
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
          child: CustomPaint(
            painter: _ParticlePainter(
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

class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;

  const _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });

  factory _Particle.random(Random random) {
    return _Particle(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: 0.8 + random.nextDouble() * 2,
      speed: 0.1 + random.nextDouble() * 0.3,
      opacity: 0.08 + random.nextDouble() * 0.18,
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Animation<double> animation;

  _ParticlePainter({
    required this.particles,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    for (final particle in particles) {
      final movement =
          (animation.value * particle.speed) % 1;

      final x = particle.x * size.width;

      final y =
          ((particle.y + movement) % 1) * size.height;

      final paint = Paint()
        ..color = Colors.white.withValues(
          alpha: particle.opacity,
        );

      canvas.drawCircle(
        Offset(x, y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
      covariant _ParticlePainter oldDelegate,
      ) {
    return false;
  }
}