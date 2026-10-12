import 'package:flutter/material.dart';

import '../models/achievement_model.dart';
import '../theme/app_theme.dart';

class AchievementUnlockOverlay extends StatefulWidget {
  final AchievementModel achievement;
  final String languageCode;
  final VoidCallback onFinished;

  const AchievementUnlockOverlay({
    super.key,
    required this.achievement,
    required this.languageCode,
    required this.onFinished,
  });

  @override
  State<AchievementUnlockOverlay> createState() =>
      _AchievementUnlockOverlayState();
}

class _AchievementUnlockOverlayState
    extends State<AchievementUnlockOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _opacity;
  late final Animation<double> _scale;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      reverseDuration: const Duration(milliseconds: 450),
    );

    _opacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0,
        0.28,
        curve: Curves.easeOut,
      ),
    );

    _scale = Tween<double>(
      begin: 0.88,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.45,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, -0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.45,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _showAnimation();
  }

  Future<void> _showAnimation() async {
    await _controller.forward();

    await Future<void>.delayed(
      const Duration(milliseconds: 2400),
    );

    if (!mounted) {
      return;
    }

    await _controller.reverse();

    if (!mounted) {
      return;
    }

    widget.onFinished();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final achievement = widget.achievement;

    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 18,
      right: 18,
      child: IgnorePointer(
        child: FadeTransition(
          opacity: _opacity,
          child: SlideTransition(
            position: _slide,
            child: ScaleTransition(
              scale: _scale,
              alignment: Alignment.topCenter,
              child: _AchievementCard(
                achievement: achievement,
                languageCode: widget.languageCode,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final AchievementModel achievement;
  final String languageCode;

  const _AchievementCard({
    required this.achievement,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final isBangla = languageCode == 'bn';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE8C96A).withValues(alpha: 0.28),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE8C96A).withValues(alpha: 0.10),
            blurRadius: 35,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          const _AchievementIcon(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBangla
                      ? 'অর্জন আনলক হয়েছে'
                      : 'ACHIEVEMENT UNLOCKED',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(
                    color: const Color(0xFFE8C96A),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  achievement.getTitle(languageCode),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    color: AppTheme.primaryText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  achievement.getDescription(languageCode),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _XpBadge(
            xp: achievement.xpReward,
          ),
        ],
      ),
    );
  }
}

class _AchievementIcon extends StatelessWidget {
  const _AchievementIcon();

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE8C96A);

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: gold.withValues(alpha: 0.08),
        border: Border.all(
          color: gold.withValues(alpha: 0.24),
        ),
        boxShadow: [
          BoxShadow(
            color: gold.withValues(alpha: 0.16),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: const Icon(
        Icons.workspace_premium_rounded,
        color: gold,
        size: 27,
      ),
    );
  }
}

class _XpBadge extends StatelessWidget {
  final int xp;

  const _XpBadge({
    required this.xp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: AppTheme.accent.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: AppTheme.accent.withValues(alpha: 0.18),
        ),
      ),
      child: Text(
        '+$xp XP',
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(
          color: AppTheme.accent,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}