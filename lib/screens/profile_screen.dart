import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/achievement_data.dart';
import '../data/element_data.dart';
import '../models/achievement_model.dart';
import '../models/element_model.dart';
import '../providers/alchemy_provider.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alchemy = context.watch<AlchemyProvider>();

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  _ProfileHeader(alchemy: alchemy),
                  const SizedBox(height: 20),
                  _LevelCard(alchemy: alchemy),
                  const SizedBox(height: 14),
                  _StatsGrid(alchemy: alchemy),
                  const SizedBox(height: 14),
                  _RarityCard(alchemy: alchemy),
                  const SizedBox(height: 14),
                  _AchievementsCard(alchemy: alchemy),
                  const SizedBox(height: 14),
                  _SettingsCard(alchemy: alchemy),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final AlchemyProvider alchemy;

  const _ProfileHeader({required this.alchemy});

  String _getRankTitle(int level, String lang) {
    if (lang == 'bn') {
      if (level <= 1) return 'নবিস আলকেমিস্ট';
      if (level <= 2) return 'শিক্ষানবিশ আলকেমিস্ট';
      if (level <= 3) return 'দক্ষ রূপান্তরকারী';
      if (level <= 4) return 'মাস্টার আলকেমিস্ট';
      return 'গ্র্যান্ড ম্যাগুস';
    }
    if (level <= 1) return 'Novice Alchemist';
    if (level <= 2) return 'Apprentice Alchemist';
    if (level <= 3) return 'Adept Transmuter';
    if (level <= 4) return 'Master Alchemist';
    return 'Grand Magus';
  }

  @override
  Widget build(BuildContext context) {
    final rank = _getRankTitle(alchemy.level, alchemy.languageCode);

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accent.withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.surfaceLight.withValues(alpha: 0.9),
                border: Border.all(
                  color: AppTheme.accentLight.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accent.withValues(alpha: 0.2),
                    blurRadius: 28,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Center(
                child: Text('⚗️', style: TextStyle(fontSize: 42)),
              ),
            ),
            Positioned(
              bottom: 2,
              right: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.gold,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.gold.withValues(alpha: 0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Text(
                  'LV ${alchemy.level}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          alchemy.text(english: 'Alchemist', bangla: 'আলকেমিস্ট'),
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.accent.withValues(alpha: 0.25)),
          ),
          child: Text(
            rank,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppTheme.accentLight,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _LevelCard extends StatelessWidget {
  final AlchemyProvider alchemy;

  const _LevelCard({required this.alchemy});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.22)),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  size: 20,
                  color: AppTheme.accentLight,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alchemy.text(
                        english: 'Alchemy Level',
                        bangla: 'আলকেমি লেভেল',
                      ),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'LV ${alchemy.level}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.accentLight,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${alchemy.currentLevelXp} / ${alchemy.xpForNextLevel} XP',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: AppTheme.secondaryText),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: alchemy.levelProgress),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.06),
                  valueColor: const AlwaysStoppedAnimation(AppTheme.accent),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              alchemy.text(
                english:
                    '${alchemy.xpForNextLevel - alchemy.currentLevelXp} XP to next rank',
                bangla:
                    'পরবর্তী র‍্যাঙ্কের জন্য ${alchemy.xpForNextLevel - alchemy.currentLevelXp} XP',
              ),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final AlchemyProvider alchemy;

  const _StatsGrid({required this.alchemy});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.auto_awesome,
            value: '${alchemy.xp}',
            label: alchemy.text(english: 'Total XP', bangla: 'মোট XP'),
            color: AppTheme.accentLight,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.grid_view_rounded,
            value: '${alchemy.discoveryCount}',
            label: alchemy.text(english: 'Discoveries', bangla: 'আবিষ্কার'),
            color: AppTheme.emerald,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryText,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _RarityCard extends StatelessWidget {
  final AlchemyProvider alchemy;

  const _RarityCard({required this.alchemy});

  @override
  Widget build(BuildContext context) {
    final counts = _getRarityCounts(alchemy);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            alchemy.text(
              english: 'Discovery Rarities',
              bangla: 'আবিষ্কারের বিরলতা',
            ),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          _RarityRow(
            label: alchemy.text(english: 'Common', bangla: 'সাধারণ'),
            count: counts[ElementRarity.common] ?? 0,
            color: const Color(0xFF9AA3B2),
          ),
          _RarityRow(
            label: alchemy.text(english: 'Uncommon', bangla: 'অসাধারণ'),
            count: counts[ElementRarity.uncommon] ?? 0,
            color: AppTheme.emerald,
          ),
          _RarityRow(
            label: alchemy.text(english: 'Rare', bangla: 'বিরল'),
            count: counts[ElementRarity.rare] ?? 0,
            color: AppTheme.sapphire,
          ),
          _RarityRow(
            label: alchemy.text(english: 'Epic', bangla: 'এপিক'),
            count: counts[ElementRarity.epic] ?? 0,
            color: AppTheme.amethyst,
          ),
          _RarityRow(
            label: alchemy.text(english: 'Legendary', bangla: 'লেজেন্ডারি'),
            count: counts[ElementRarity.legendary] ?? 0,
            color: AppTheme.gold,
          ),
        ],
      ),
    );
  }

  Map<ElementRarity, int> _getRarityCounts(AlchemyProvider alchemy) {
    final counts = <ElementRarity, int>{};
    for (final element in ElementData.allElements) {
      if (alchemy.discoveredElementIds.contains(element.id)) {
        counts[element.rarity] = (counts[element.rarity] ?? 0) + 1;
      }
    }
    return counts;
  }
}

class _RarityRow extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _RarityRow({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 6),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '$count',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: count > 0 ? color : AppTheme.secondaryText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementsCard extends StatelessWidget {
  final AlchemyProvider alchemy;

  const _AchievementsCard({required this.alchemy});

  @override
  Widget build(BuildContext context) {
    final achievements = AchievementData.all;
    final unlockedCount = alchemy.achievementCount;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.emoji_events_outlined,
                  size: 20,
                  color: AppTheme.gold,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alchemy.text(
                        english: 'Achievements',
                        bangla: 'অর্জনসমূহ',
                      ),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$unlockedCount / ${achievements.length} ${alchemy.text(english: 'unlocked', bangla: 'আনলক')}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          for (int i = 0; i < achievements.length; i++) ...[
            _AchievementTile(achievement: achievements[i], alchemy: alchemy),
            if (i < achievements.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final AchievementModel achievement;
  final AlchemyProvider alchemy;

  const _AchievementTile({required this.achievement, required this.alchemy});

  @override
  Widget build(BuildContext context) {
    final unlocked = alchemy.unlockedAchievementIds.contains(achievement.id);
    final progress = (alchemy.discoveryCount / achievement.requiredDiscoveries)
        .clamp(0.0, 1.0);
    final color = unlocked ? AppTheme.gold : AppTheme.secondaryText;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: unlocked
            ? color.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: unlocked
              ? color.withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: unlocked ? 0.12 : 0.05),
              border: Border.all(
                color: color.withValues(alpha: unlocked ? 0.3 : 0.08),
              ),
            ),
            child: Icon(
              unlocked
                  ? Icons.emoji_events_rounded
                  : Icons.lock_outline_rounded,
              size: 20,
              color: color.withValues(alpha: unlocked ? 1.0 : 0.4),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.getTitle(alchemy.languageCode),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: unlocked
                        ? AppTheme.primaryText
                        : AppTheme.secondaryText,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  achievement.getDescription(alchemy.languageCode),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    color: AppTheme.secondaryText,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: Colors.white.withValues(alpha: 0.06),
                    valueColor: AlwaysStoppedAnimation(
                      color.withValues(alpha: unlocked ? 0.85 : 0.35),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${alchemy.discoveryCount.clamp(0, achievement.requiredDiscoveries)} / ${achievement.requiredDiscoveries} ${alchemy.text(english: 'discoveries', bangla: 'আবিষ্কার')}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    color: unlocked ? color : AppTheme.secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              const Icon(Icons.auto_awesome, size: 13, color: AppTheme.gold),
              const SizedBox(height: 3),
              Text(
                '+${achievement.xpReward}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: unlocked ? AppTheme.gold : AppTheme.secondaryText,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text(
                'XP',
                style: TextStyle(fontSize: 9, color: AppTheme.secondaryText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final AlchemyProvider alchemy;

  const _SettingsCard({required this.alchemy});

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: AppTheme.border),
          ),
          title: Text(
            alchemy.text(
              english: 'Reset Alchemical Journey?',
              bangla: 'যাত্রা পুনরায় শুরু করবেন?',
            ),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Text(
            alchemy.text(
              english:
                  'This will reset your discoveries and achievements back to the beginning. This action cannot be undone.',
              bangla:
                  'এটি আপনার সমস্ত আবিষ্কার এবং অর্জন মুছে দেবে। এটি অপরিবর্তনযোগ্য।',
            ),
            style: const TextStyle(color: AppTheme.secondaryText),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                alchemy.text(english: 'Cancel', bangla: 'বাতিল'),
                style: const TextStyle(color: AppTheme.secondaryText),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.ruby,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                alchemy.resetProgress();
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      alchemy.text(
                        english: 'Alchemical journey reset to beginning.',
                        bangla: 'আলকেমিক যাত্রা পুনরায় শুরু হয়েছে।',
                      ),
                    ),
                  ),
                );
              },
              child: Text(
                alchemy.text(english: 'Reset All', bangla: 'রিসেট করুন'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            alchemy.text(
              english: 'Preferences & Storage',
              bangla: 'পছন্দ ও সংরক্ষণ',
            ),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          // Haptics toggle
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.sapphire.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.vibration_rounded,
                  size: 18,
                  color: AppTheme.sapphire,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alchemy.text(
                        english: 'Haptic Feedback',
                        bangla: 'হ্যাপটিক ভাইব্রেশন',
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      alchemy.text(
                        english: 'Vibrate on element interactions',
                        bangla: 'উপাদান স্পর্শে হালকা কম্পন',
                      ),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              Switch(
                value: alchemy.hapticsEnabled,
                activeThumbColor: AppTheme.accent,
                onChanged: (val) {
                  alchemy.setHapticsEnabled(val);
                },
              ),
            ],
          ),
          const Divider(height: 24, color: AppTheme.border),
          // Reset progress action
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.ruby.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.restart_alt_rounded,
                  size: 18,
                  color: AppTheme.ruby,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alchemy.text(
                        english: 'Reset Progress',
                        bangla: 'অগ্রগতি পুনরায় সেট করুন',
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppTheme.ruby,
                      ),
                    ),
                    Text(
                      alchemy.text(
                        english: 'Restart with 4 primal elements',
                        bangla: '৪টি আদি উপাদান দিয়ে পুনরায় শুরু',
                      ),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.ruby),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _confirmReset(context),
                child: Text(
                  alchemy.text(english: 'Reset', bangla: 'রিসেট'),
                  style: const TextStyle(
                    color: AppTheme.ruby,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
