import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/element_data.dart';
import '../providers/alchemy_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/alchemical_components.dart';
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
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
          child: Column(
            children: [
              _LabHeader(alchemy: alchemy),
              const SizedBox(height: 12),
              Expanded(child: FusionArea(alchemy: alchemy)),
              const SizedBox(height: 12),
              _DiscoveredElementShelf(alchemy: alchemy),
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

  const _LabHeader({required this.alchemy});

  void _showHintSheet(BuildContext context) {
    HapticHelper.light();
    final hint = alchemy.getCraftableUndiscoveredHint();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight.withValues(alpha: 0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: AppTheme.accentGlow),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.gold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.lightbulb_outline,
                      color: AppTheme.gold,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alchemy.text(
                            english: 'Alchemical Whisper',
                            bangla: 'আলকেমিক সংকেত',
                          ),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          alchemy.text(
                            english: 'A mysterious reaction awaits...',
                            bangla: 'একটি রহস্যময় বিক্রিয়া অপেক্ষা করছে...',
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (hint != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    children: [
                      ElementSymbol(element: hint, size: 30),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              alchemy.text(
                                english: 'Potential Discovery',
                                bangla: 'সম্ভাব্য আবিষ্কার',
                              ),
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppTheme.gold,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              alchemy.text(
                                english:
                                    'You hold the elements to forge "${hint.getName(alchemy.languageCode)}"!',
                                bangla:
                                    'আপনার কাছে "${hint.getName(alchemy.languageCode)}" তৈরির উপাদান রয়েছে!',
                              ),
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Text(
                    alchemy.text(
                      english:
                          'All currently craftable recipes from your collection have been discovered! Keep experimenting or review the Discovery Tree.',
                      bangla:
                          'আপনার বর্তমান উপাদান দিয়ে সম্ভাব্য সব আবিষ্কার সম্পন্ন হয়েছে! নতুন সমন্বয় চেষ্টা করুন বা আবিষ্কার গাছ দেখুন।',
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              AlchemicalButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  alchemy.text(english: 'Understood', bangla: 'বুঝেছি'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHistorySheet(BuildContext context) {
    HapticHelper.light();
    final history = alchemy.fusionHistory;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.65,
          ),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight.withValues(alpha: 0.96),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: AppTheme.borderGlow),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.history_rounded,
                      color: AppTheme.accent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    alchemy.text(
                      english: 'Fusion History',
                      bangla: 'ফিউশন ইতিহাস',
                    ),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${history.length} ${alchemy.text(english: 'records', bangla: 'রেকর্ড')}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (history.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  child: Center(
                    child: Text(
                      alchemy.text(
                        english: 'No fusions attempted yet in this session.',
                        bangla: 'এখনও কোনো ফিউশন করা হয়নি।',
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: history.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = history[index];
                      final isSuccess = item.result != null;

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.surface.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSuccess
                                ? item.result!.color.withValues(alpha: 0.25)
                                : AppTheme.border,
                          ),
                        ),
                        child: Row(
                          children: [
                            ElementSymbol(element: item.first, size: 18),
                            const SizedBox(width: 4),
                            const Text(
                              '+',
                              style: TextStyle(
                                color: AppTheme.secondaryText,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            ElementSymbol(element: item.second, size: 18),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: AppTheme.tertiaryText,
                            ),
                            const SizedBox(width: 12),
                            if (isSuccess) ...[
                              ElementSymbol(element: item.result!, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item.result!.getName(alchemy.languageCode),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              if (item.isNew)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.gold.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    alchemy.text(
                                      english: 'NEW',
                                      bangla: 'নতুন',
                                    ),
                                    style: const TextStyle(
                                      color: AppTheme.gold,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                            ] else ...[
                              const Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: AppTheme.ruby,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                alchemy.text(
                                  english: 'No reaction',
                                  bangla: 'প্রতিক্রিয়া নেই',
                                ),
                                style: const TextStyle(
                                  color: AppTheme.secondaryText,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.accent,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accent,
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'ALCHEMY',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        letterSpacing: 2.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  alchemy.text(english: 'Laboratory', bangla: 'গবেষণাগার'),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                ),
              ],
            ),
            const Spacer(),
            // Quick Hint Button
            IconButton(
              icon: const Icon(
                Icons.lightbulb_outline_rounded,
                size: 20,
                color: AppTheme.gold,
              ),
              tooltip: alchemy.text(english: 'Hint', bangla: 'সংকেত'),
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.surfaceLight.withValues(alpha: 0.7),
                side: const BorderSide(color: AppTheme.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => _showHintSheet(context),
            ),
            const SizedBox(width: 6),
            // History Button
            IconButton(
              icon: const Icon(
                Icons.history_rounded,
                size: 20,
                color: AppTheme.secondaryText,
              ),
              tooltip: alchemy.text(english: 'History', bangla: 'ইতিহাস'),
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.surfaceLight.withValues(alpha: 0.7),
                side: const BorderSide(color: AppTheme.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => _showHistorySheet(context),
            ),
            const SizedBox(width: 6),
            // Level Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    size: 14,
                    color: AppTheme.accent,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'LV ${alchemy.level}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.primaryText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // XP Progress Bar and Counter
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
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${alchemy.currentLevelXp} / ${alchemy.xpForNextLevel} XP',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: alchemy.levelProgress,
                      minHeight: 6,
                      backgroundColor: Colors.white.withValues(alpha: 0.06),
                      valueColor: const AlwaysStoppedAnimation(AppTheme.accent),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: AppTheme.surface.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome_mosaic_outlined,
                    size: 14,
                    color: AppTheme.accent,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${alchemy.discoveryCount} / ${alchemy.totalElementCount}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
// ELEMENT SHELF
// ============================================================

enum _ShelfMode { primal, all }

class _DiscoveredElementShelf extends StatefulWidget {
  final AlchemyProvider alchemy;

  const _DiscoveredElementShelf({required this.alchemy});

  @override
  State<_DiscoveredElementShelf> createState() =>
      _DiscoveredElementShelfState();
}

class _DiscoveredElementShelfState extends State<_DiscoveredElementShelf> {
  _ShelfMode _mode = _ShelfMode.primal;

  @override
  Widget build(BuildContext context) {
    final alchemy = widget.alchemy;
    final discoveredIds = alchemy.discoveredElementIds;

    // In primal mode: the 4 core foundation elements
    // In all mode: all currently discovered elements
    final elements = _mode == _ShelfMode.primal
        ? ElementData.startingElements
        : ElementData.allElements
              .where((e) => discoveredIds.contains(e.id))
              .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              alchemy.text(english: 'Your Elements', bangla: 'আপনার উপাদান'),
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 10),
            // Mode toggle: Primal vs All Discovered
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _modeButton(
                    label: alchemy.text(english: 'Primal', bangla: 'আদিম'),
                    selected: _mode == _ShelfMode.primal,
                    onTap: () {
                      HapticHelper.selection();
                      setState(() => _mode = _ShelfMode.primal);
                    },
                  ),
                  _modeButton(
                    label:
                        '${alchemy.text(english: 'All', bangla: 'সব')} (${alchemy.discoveryCount})',
                    selected: _mode == _ShelfMode.all,
                    onTap: () {
                      HapticHelper.selection();
                      setState(() => _mode = _ShelfMode.all);
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (alchemy.firstElementId != null)
              GestureDetector(
                onTap: () {
                  alchemy.clearFusion();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.clear_all_rounded,
                        size: 14,
                        color: AppTheme.ruby,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        alchemy.text(english: 'Clear', bangla: 'মুছুন'),
                        style: const TextStyle(
                          color: AppTheme.ruby,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 8),

        // Horizontally scrolling shelf of cards
        SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: elements.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final element = elements[index];
              final isSelectedInChamber =
                  alchemy.firstElementId == element.id ||
                  alchemy.secondElementId == element.id;

              return ElementCard(
                element: element,
                languageCode: alchemy.languageCode,
                isSelected: isSelectedInChamber,
                height: 86,
                width: 82,
                onTap: () {
                  alchemy.addElement(element.id);
                  if (alchemy.secondElementId != null) {
                    alchemy.fuseElements();
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _modeButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.accent.withValues(alpha: 0.22)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? AppTheme.accent.withValues(alpha: 0.5)
                : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppTheme.primaryText : AppTheme.secondaryText,
          ),
        ),
      ),
    );
  }
}
