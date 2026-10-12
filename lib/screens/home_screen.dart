import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/element_data.dart';
import '../providers/alchemy_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/element_card.dart';
import '../widgets/fusion_area.dart';
import '../widgets/particle_background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alchemy = context.watch<AlchemyProvider>();

    return ParticleBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            20,
          ),
          child: Column(
            children: [
              _LabHeader(
                alchemy: alchemy,
              ),

              const SizedBox(height: 24),

              Expanded(
                child: FusionArea(
                  alchemy: alchemy,
                ),
              ),

              const SizedBox(height: 20),

              _ElementsPlaceholder(
                alchemy: alchemy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// LAB HEADER
// ============================================================

class _LabHeader extends StatelessWidget {
  final AlchemyProvider alchemy;

  const _LabHeader({
    required this.alchemy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ALCHEMY',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alchemy.text(
                    english: 'Laboratory',
                    bangla: 'গবেষণাগার',
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight.withValues(
                  alpha: 0.7,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppTheme.border,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    size: 15,
                    color: AppTheme.accent,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    'LV ${alchemy.level}',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(
                      color: AppTheme.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        alchemy.text(
                          english: 'Level ${alchemy.level}',
                          bangla: 'লেভেল ${alchemy.level}',
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                          color: AppTheme.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${alchemy.currentLevelXp} / ${alchemy.xpForNextLevel} XP',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                          color: AppTheme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: alchemy.levelProgress,
                      minHeight: 5,
                      backgroundColor:
                      Colors.white.withValues(alpha: 0.06),
                      valueColor:
                      const AlwaysStoppedAnimation(
                        AppTheme.accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppTheme.surface.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.border,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome_mosaic_outlined,
                    size: 15,
                    color: AppTheme.accent,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${alchemy.discoveryCount}',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(
                      color: AppTheme.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// ELEMENTS
// ============================================================

class _ElementsPlaceholder extends StatelessWidget {
  final AlchemyProvider alchemy;

  const _ElementsPlaceholder({
    required this.alchemy,
  });

  @override
  Widget build(BuildContext context) {
    final elements = ElementData.startingElements;

    return Column(
      children: [
        Row(
          children: [
            Text(
              alchemy.text(
                english: 'Your Elements',
                bangla: 'আপনার উপাদান',
              ),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),
            const Spacer(),
            Text(
              '${alchemy.discoveryCount}',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (int i = 0; i < elements.length; i++) ...[
              Expanded(
                child: ElementCard(
                  element: elements[i],
                  languageCode: alchemy.languageCode,
                ),
              ),
              if (i < elements.length - 1)
                const SizedBox(width: 10),
            ],
          ],
        ),
      ],
    );
  }
}