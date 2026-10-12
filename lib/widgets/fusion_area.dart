import 'dart:math';

import 'package:flutter/material.dart';

import '../data/element_data.dart';
import '../models/element_model.dart';
import '../providers/alchemy_provider.dart';
import '../theme/app_theme.dart';

class FusionArea extends StatefulWidget {
  final AlchemyProvider alchemy;

  const FusionArea({
    super.key,
    required this.alchemy,
  });

  @override
  State<FusionArea> createState() => _FusionAreaState();
}

class _FusionAreaState extends State<FusionArea>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _orbitController;
  late final AnimationController _fusionController;
  late final AnimationController _failureController;

  bool _isHovering = false;

  FusionResult? _fusionOutcome;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    _fusionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _failureController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    widget.alchemy.addListener(_handleAlchemyChanged);
  }

  @override
  void didUpdateWidget(covariant FusionArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.alchemy != widget.alchemy) {
      oldWidget.alchemy.removeListener(_handleAlchemyChanged);
      widget.alchemy.addListener(_handleAlchemyChanged);
    }
  }

  @override
  void dispose() {
    widget.alchemy.removeListener(_handleAlchemyChanged);
    _pulseController.dispose();
    _orbitController.dispose();
    _fusionController.dispose();
    _failureController.dispose();
    super.dispose();
  }

  void _handleAlchemyChanged() {
    final providerOutcome = widget.alchemy.lastFusionResult;

    if (widget.alchemy.firstElementId != null &&
        _fusionOutcome != null) {
      setState(() {
        _fusionOutcome = null;
      });
      return;
    }

    if (providerOutcome != null &&
        !providerOutcome.isIncomplete &&
        !identical(providerOutcome, _fusionOutcome)) {
      _applyOutcome(providerOutcome);
    } else if (providerOutcome == null &&
        _fusionOutcome != null &&
        widget.alchemy.firstElementId == null &&
        widget.alchemy.secondElementId == null) {
      setState(() {
        _fusionOutcome = null;
      });
    }
  }

  void _applyOutcome(FusionResult outcome) {
    if (identical(_fusionOutcome, outcome)) {
      return;
    }

    _fusionController.stop();
    _failureController.stop();

    setState(() {
      _isHovering = false;
      _fusionOutcome = outcome;
    });

    if (outcome.isSuccess && outcome.element != null) {
      debugPrint(
        'Fusion successful (${outcome.status.name}): ${outcome.element!.nameEn}',
      );
      _fusionController.forward(from: 0);
    } else if (outcome.isInvalid) {
      debugPrint('Fusion failed');
      _failureController.forward(from: 0);
    }
  }

  void _handleDrop(String elementId) {
    _fusionController.stop();
    _failureController.stop();

    setState(() {
      _isHovering = false;
      _fusionOutcome = null;
    });

    widget.alchemy.addElement(elementId);

    if (widget.alchemy.secondElementId == null) {
      return;
    }

    final outcome = widget.alchemy.fuseElements();
    _applyOutcome(outcome);
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (details) {
        _fusionController.stop();
        _failureController.stop();

        setState(() {
          _isHovering = true;
          _fusionOutcome = null;
        });

        return true;
      },
      onLeave: (_) {
        setState(() {
          _isHovering = false;
        });
      },
      onAcceptWithDetails: (details) {
        _handleDrop(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        return AnimatedBuilder(
          animation: Listenable.merge([
            _pulseController,
            _orbitController,
            _fusionController,
            _failureController,
          ]),
          builder: (context, child) {
            final pulse = Curves.easeInOut.transform(
              _pulseController.value,
            );

            final fusionProgress = Curves.easeOutCubic.transform(
              _fusionController.value,
            );

            final failureProgress = _failureController.value;

            final glow = 0.06 + (pulse * 0.08);

            final outcome = _fusionOutcome;
            final fusionResult = outcome?.element;
            final isNewDiscovery = outcome?.isNewDiscovery ?? false;
            final fusionFailed = outcome?.isInvalid ?? false;

            final isFusing = fusionResult != null &&
                _fusionController.isAnimating;

            final activeColor =
                fusionResult?.color ?? AppTheme.accent;

            final coreExpansion = isNewDiscovery ? 28.0 : 10.0;
            final glowExpansion = isNewDiscovery ? 45.0 : 15.0;

            final coreSize = isFusing
                ? 110 +
                    (pulse * 12) +
                    (fusionProgress * coreExpansion)
                : 110 + (pulse * 12);

            final shakeOffset = fusionFailed
                ? sin(failureProgress * pi * 7) *
                    (1 - failureProgress) *
                    7
                : 0.0;

            return Transform.translate(
              offset: Offset(shakeOffset, 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _isHovering
                      ? AppTheme.accent.withValues(alpha: 0.08)
                      : activeColor.withValues(
                          alpha: fusionResult != null
                              ? (isNewDiscovery ? 0.045 : 0.025)
                              : 0.0,
                        ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: _isHovering
                        ? AppTheme.accent.withValues(alpha: 0.38)
                        : fusionFailed
                        ? Colors.white.withValues(alpha: 0.12)
                        : AppTheme.border,
                    width: _isHovering ? 1.5 : 1,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 230 +
                          (pulse * 15) +
                          (fusionProgress * glowExpansion),
                      height: 230 +
                          (pulse * 15) +
                          (fusionProgress * glowExpansion),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: activeColor.withValues(
                          alpha: fusionResult != null
                              ? glow * (isNewDiscovery ? 0.55 : 0.35)
                              : glow * 0.25,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: activeColor.withValues(
                              alpha: _isHovering
                                  ? glow + 0.10
                                  : fusionResult != null
                                  ? glow +
                                      (fusionProgress *
                                          (isNewDiscovery
                                              ? 0.16
                                              : 0.06))
                                  : glow,
                            ),
                            blurRadius: _isHovering
                                ? 110
                                : 90 +
                                    (fusionProgress *
                                        glowExpansion),
                            spreadRadius: 25 +
                                (fusionProgress *
                                    (isNewDiscovery ? 8 : 3)),
                          ),
                        ],
                      ),
                    ),
                    Transform.rotate(
                      angle: _orbitController.value * 2 * pi,
                      child: SizedBox(
                        width: 190 +
                            (fusionProgress *
                                (isNewDiscovery ? 35 : 12)),
                        height: 190 +
                            (fusionProgress *
                                (isNewDiscovery ? 35 : 12)),
                        child: CustomPaint(
                          painter: _OrbitPainter(
                            color: fusionResult != null
                                ? activeColor
                                : _isHovering
                                ? Colors.white
                                : AppTheme.accent,
                            progress: isNewDiscovery
                                ? fusionProgress
                                : fusionProgress * 0.35,
                          ),
                        ),
                      ),
                    ),
                    if (fusionResult != null && isNewDiscovery)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: CustomPaint(
                            painter: _ParticleBurstPainter(
                              color: activeColor,
                              progress: fusionProgress,
                            ),
                          ),
                        ),
                      ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: _isHovering
                          ? coreSize + 12
                          : coreSize,
                      height: _isHovering
                          ? coreSize + 12
                          : coreSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            activeColor.withValues(
                              alpha: 0.22 +
                                  (pulse * 0.10) +
                                  (fusionProgress *
                                      (isNewDiscovery
                                          ? 0.25
                                          : 0.08)),
                            ),
                            activeColor.withValues(
                              alpha: 0.05 +
                                  (fusionProgress *
                                      (isNewDiscovery
                                          ? 0.08
                                          : 0.03)),
                            ),
                            Colors.transparent,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: activeColor.withValues(
                              alpha: _isHovering
                                  ? 0.35
                                  : 0.18 +
                                      (pulse * 0.12) +
                                      (fusionProgress *
                                          (isNewDiscovery
                                              ? 0.25
                                              : 0.08)),
                            ),
                            blurRadius: _isHovering
                                ? 60
                                : 45 +
                                    (pulse * 15) +
                                    (fusionProgress *
                                        (isNewDiscovery
                                            ? 40
                                            : 14)),
                            spreadRadius: 5 +
                                (fusionProgress *
                                    (isNewDiscovery ? 8 : 2)),
                          ),
                        ],
                      ),
                    ),
                    _buildSelectedElementPreview(
                      context,
                      pulse,
                    ),
                    _buildCenterContent(
                      context,
                      pulse,
                      fusionProgress,
                      failureProgress,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSelectedElementPreview(
      BuildContext context,
      double pulse,
      ) {
    if (_fusionOutcome != null) {
      return const SizedBox.shrink();
    }

    final firstId = widget.alchemy.firstElementId;

    if (firstId == null) {
      return const SizedBox.shrink();
    }

    final element = ElementData.findById(firstId);

    if (element == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 24,
      left: 20,
      right: 20,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: element.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: element.color.withValues(alpha: 0.20),
            ),
            boxShadow: [
              BoxShadow(
                color: element.color.withValues(
                  alpha: 0.05 + (pulse * 0.04),
                ),
                blurRadius: 18,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                element.icon,
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                element.getName(
                  widget.alchemy.languageCode,
                ),
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: element.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterContent(
      BuildContext context,
      double pulse,
      double fusionProgress,
      double failureProgress,
      ) {
    final outcome = _fusionOutcome;

    if (outcome != null &&
        outcome.isSuccess &&
        outcome.element != null) {
      final result = outcome.element!;
      final isNewDiscovery = outcome.isNewDiscovery;
      final isBangla = widget.alchemy.languageCode == 'bn';

      final revealInput = isNewDiscovery
          ? ((fusionProgress - 0.45) / 0.55).clamp(0.0, 1.0)
          : ((fusionProgress - 0.20) / 0.80).clamp(0.0, 1.0);

      final revealCurve = isNewDiscovery
          ? Curves.easeOutBack
          : Curves.easeOutCubic;

      final revealProgress = revealCurve
          .transform(revealInput)
          .clamp(0.0, 1.0);

      final revealOpacity = isNewDiscovery
          ? ((fusionProgress - 0.38) / 0.30).clamp(0.0, 1.0)
          : ((fusionProgress - 0.15) / 0.35).clamp(0.0, 1.0);

      final minScale = isNewDiscovery ? 0.55 : 0.85;

      return Opacity(
        opacity: revealOpacity,
        child: Transform.scale(
          scale: minScale + (revealProgress * (1.0 - minScale)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                result.icon,
                style: TextStyle(
                  fontSize: isNewDiscovery
                      ? 48 + (revealProgress * 8)
                      : 46,
                  shadows: [
                    Shadow(
                      color: result.color.withValues(
                        alpha: isNewDiscovery ? 0.8 : 0.5,
                      ),
                      blurRadius: isNewDiscovery
                          ? 20 + (revealProgress * 12)
                          : 16,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                result.getName(
                  widget.alchemy.languageCode,
                ),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                isNewDiscovery
                    ? widget.alchemy.text(
                        english: 'NEW DISCOVERY',
                        bangla: 'নতুন আবিষ্কার',
                      )
                    : widget.alchemy.text(
                        english: 'ALREADY DISCOVERED',
                        bangla: 'পূর্বে আবিষ্কৃত',
                      ),
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(
                  color: isNewDiscovery
                      ? result.color
                      : AppTheme.secondaryText,
                  fontWeight: FontWeight.w700,
                  letterSpacing: isBangla ? 0 : 1.4,
                ),
              ),
              if (isNewDiscovery && outcome.xpGained > 0) ...[
                const SizedBox(height: 8),
                Opacity(
                  opacity: revealProgress,
                  child: Text(
                    '+${outcome.xpGained} XP',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(
                      color: Colors.white.withValues(
                        alpha: 0.75,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (outcome != null && outcome.isInvalid) {
      final opacity =
      (1 - failureProgress).clamp(0.0, 1.0);

      return Opacity(
        opacity: opacity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.close_rounded,
              size: 40,
              color: Colors.white.withValues(alpha: 0.55),
            ),
            const SizedBox(height: 12),
            Text(
              widget.alchemy.text(
                english: 'Nothing happened',
                bangla: 'কিছুই ঘটেনি',
              ),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),
            const SizedBox(height: 5),
            Text(
              widget.alchemy.text(
                english: 'Try another combination',
                bangla: 'অন্য একটি সংমিশ্রণ চেষ্টা করুন',
              ),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),
          ],
        ),
      );
    }

    final firstElementId = widget.alchemy.firstElementId;

    if (firstElementId != null) {
      final firstElement = ElementData.findById(firstElementId);

      if (firstElement != null) {
        return _buildWaitingContent(
          context,
          firstElement,
          pulse,
        );
      }
    }

    return _buildEmptyContent(
      context,
      pulse,
    );
  }

  Widget _buildWaitingContent(
      BuildContext context,
      ElementModel firstElement,
      double pulse,
      ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.scale(
          scale: 1 + (pulse * 0.04),
          child: Text(
            firstElement.icon,
            style: TextStyle(
              fontSize: 38,
              shadows: [
                Shadow(
                  color: firstElement.color.withValues(
                    alpha: 0.55,
                  ),
                  blurRadius: 16,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.alchemy.text(
            english: 'First element ready',
            bangla: 'প্রথম উপাদান প্রস্তুত',
          ),
          style: Theme.of(context)
              .textTheme
              .titleMedium,
        ),
        const SizedBox(height: 5),
        Text(
          widget.alchemy.text(
            english: 'Drop another element to fuse',
            bangla: 'ফিউশনের জন্য আরেকটি উপাদান দিন',
          ),
          style: Theme.of(context)
              .textTheme
              .bodyMedium,
        ),
        const SizedBox(height: 12),
        _SelectionProgress(
          languageCode: widget.alchemy.languageCode,
        ),
      ],
    );
  }

  Widget _buildEmptyContent(
      BuildContext context,
      double pulse,
      ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.scale(
          scale: 1 + (pulse * 0.06),
          child: Icon(
            _isHovering
                ? Icons.add_circle_outline
                : Icons.auto_awesome,
            size: 38,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          _isHovering
              ? widget.alchemy.text(
            english: 'Release to fuse',
            bangla: 'ফিউশনের জন্য ছেড়ে দিন',
          )
              : widget.alchemy.text(
            english: 'Fusion Chamber',
            bangla: 'ফিউশন চেম্বার',
          ),
          style: Theme.of(context)
              .textTheme
              .titleMedium,
        ),
        const SizedBox(height: 6),
        Text(
          _isHovering
              ? widget.alchemy.text(
            english: 'Drop the element here',
            bangla: 'উপাদানটি এখানে ছেড়ে দিন',
          )
              : widget.alchemy.text(
            english: 'Drag two elements here',
            bangla: 'দুটি উপাদান এখানে টেনে আনুন',
          ),
          style: Theme.of(context)
              .textTheme
              .bodyMedium,
        ),
      ],
    );
  }
}

class _SelectionProgress extends StatelessWidget {
  final String languageCode;

  const _SelectionProgress({
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final isBangla = languageCode == 'bn';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppTheme.accent.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.accent.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.merge_type_rounded,
            size: 14,
            color: AppTheme.accent,
          ),
          const SizedBox(width: 6),
          Text(
            isBangla
                ? '১ / ২ উপাদান নির্বাচিত'
                : '1 / 2 ELEMENT SELECTED',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(
              color: AppTheme.accent,
              fontWeight: FontWeight.w600,
              letterSpacing: isBangla ? 0 : 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  final Color color;
  final double progress;

  const _OrbitPainter({
    required this.color,
    required this.progress,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.width / 2 - 4;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2 + (progress * 1.2)
      ..color = color.withValues(
        alpha: 0.16 + (progress * 0.18),
      );

    canvas.drawCircle(
      center,
      radius,
      paint,
    );

    final dotPaint = Paint()
      ..color = color.withValues(
        alpha: 0.65 + (progress * 0.25),
      );

    canvas.drawCircle(
      Offset(
        center.dx,
        center.dy - radius,
      ),
      3 + (progress * 2),
      dotPaint,
    );

    if (progress > 0.15) {
      final secondDotAngle =
          progress * pi * 4;

      canvas.drawCircle(
        Offset(
          center.dx +
              cos(secondDotAngle) * radius,
          center.dy +
              sin(secondDotAngle) * radius,
        ),
        2.5 + (progress * 1.5),
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
      covariant _OrbitPainter oldDelegate,
      ) {
    return oldDelegate.color != color ||
        oldDelegate.progress != progress;
  }
}

class _ParticleBurstPainter extends CustomPainter {
  final Color color;
  final double progress;

  static final List<_BurstParticle> _particles =
  _createParticles();

  const _ParticleBurstPainter({
    required this.color,
    required this.progress,
  });

  static List<_BurstParticle> _createParticles() {
    final random = Random(42);

    return List.generate(28, (index) {
      final angle = random.nextDouble() * pi * 2;
      final distance = 0.45 + random.nextDouble() * 0.55;
      final size = 1.2 + random.nextDouble() * 2.4;
      final delay = random.nextDouble() * 0.22;

      return _BurstParticle(
        angle: angle,
        distance: distance,
        size: size,
        delay: delay,
      );
    });
  }

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    if (progress < 0.15) {
      return;
    }

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final burstProgress =
    ((progress - 0.15) / 0.85)
        .clamp(0.0, 1.0);

    for (final particle in _particles) {
      final particleProgress =
      ((burstProgress - particle.delay) /
          (1 - particle.delay))
          .clamp(0.0, 1.0);

      if (particleProgress <= 0) {
        continue;
      }

      final easedProgress =
      Curves.easeOutCubic.transform(
        particleProgress,
      );

      final radius =
          45 +
              (easedProgress * 125 * particle.distance);

      final x =
          center.dx +
              cos(particle.angle) * radius;

      final y =
          center.dy +
              sin(particle.angle) * radius;

      final opacity =
      (1 - particleProgress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = color.withValues(
          alpha: opacity * 0.85,
        );

      canvas.drawCircle(
        Offset(x, y),
        particle.size *
            (1 - particleProgress * 0.35),
        paint,
      );

      if (particleProgress > 0.05 &&
          particleProgress < 0.75) {
        final glowPaint = Paint()
          ..color = color.withValues(
            alpha: opacity * 0.20,
          )
          ..maskFilter = const MaskFilter.blur(
            BlurStyle.normal,
            5,
          );

        canvas.drawCircle(
          Offset(x, y),
          particle.size * 2.5,
          glowPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(
      covariant _ParticleBurstPainter oldDelegate,
      ) {
    return oldDelegate.color != color ||
        oldDelegate.progress != progress;
  }
}

class _BurstParticle {
  final double angle;
  final double distance;
  final double size;
  final double delay;

  const _BurstParticle({
    required this.angle,
    required this.distance,
    required this.size,
    required this.delay,
  });
}