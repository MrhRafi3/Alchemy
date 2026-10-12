
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
padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
sliver: SliverToBoxAdapter(
child: Column(
children: [
_ProfileHeader(
alchemy: alchemy,
),

const SizedBox(height: 24),

_LevelCard(
alchemy: alchemy,
),

const SizedBox(height: 14),

_StatsGrid(
alchemy: alchemy,
),

const SizedBox(height: 14),

_RarityCard(
alchemy: alchemy,
),

const SizedBox(height: 14),

_AchievementsCard(
alchemy: alchemy,
),
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

const _ProfileHeader({
required this.alchemy,
});

@override
Widget build(BuildContext context) {
return Column(
children: [
Container(
width: 92,
height: 92,
decoration: BoxDecoration(
shape: BoxShape.circle,
color: AppTheme.surfaceLight.withValues(alpha: 0.72),
border: Border.all(
color: AppTheme.accent.withValues(alpha: 0.28),
width: 1.2,
),
boxShadow: [
BoxShadow(
color: AppTheme.accent.withValues(alpha: 0.10),
blurRadius: 30,
spreadRadius: 2,
),
],
),
child: const Center(
child: Text(
'⚗️',
style: TextStyle(
fontSize: 46,
),
),
),
),

const SizedBox(height: 16),

Text(
alchemy.text(
english: 'Alchemist',
bangla: 'আলকেমিস্ট',
),
style: Theme.of(context).textTheme.headlineMedium,
),

const SizedBox(height: 5),

Text(
alchemy.text(
english: 'Your journey of discovery',
bangla: 'আপনার আবিষ্কারের যাত্রা',
),
style: Theme.of(context).textTheme.bodyMedium,
),
],
);
}
}

class _LevelCard extends StatelessWidget {
final AlchemyProvider alchemy;

const _LevelCard({
required this.alchemy,
});

@override
Widget build(BuildContext context) {
return Container(
width: double.infinity,
padding: const EdgeInsets.all(18),
decoration: BoxDecoration(
color: AppTheme.surface.withValues(alpha: 0.74),
borderRadius: BorderRadius.circular(22),
border: Border.all(
color: AppTheme.accent.withValues(alpha: 0.16),
),
boxShadow: [
BoxShadow(
color: AppTheme.accent.withValues(alpha: 0.05),
blurRadius: 24,
spreadRadius: 1,
),
],
),
child: Column(
children: [
Row(
children: [
Container(
width: 42,
height: 42,
decoration: BoxDecoration(
color: AppTheme.accent.withValues(alpha: 0.10),
borderRadius: BorderRadius.circular(13),
),
child: const Icon(
Icons.auto_awesome,
size: 20,
color: AppTheme.accent,
),
),
const SizedBox(width: 12),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
alchemy.text(
english: 'Alchemy Level',
bangla: 'আলকেমি লেভেল',
),
style: Theme.of(context).textTheme.titleMedium,
),
const SizedBox(height: 2),
Text(
'LV ${alchemy.level}',
style: Theme.of(context)
    .textTheme
    .labelSmall
    ?.copyWith(
color: AppTheme.accent,
fontWeight: FontWeight.w600,
),
),
],
),
),
Text(
'${alchemy.currentLevelXp} / ${alchemy.xpForNextLevel} XP',
style: Theme.of(context).textTheme.labelSmall?.copyWith(
color: AppTheme.secondaryText,
),
),
],
),

const SizedBox(height: 16),

ClipRRect(
borderRadius: BorderRadius.circular(10),
child: TweenAnimationBuilder<double>(
tween: Tween(
begin: 0,
end: alchemy.levelProgress,
),
duration: const Duration(milliseconds: 700),
curve: Curves.easeOutCubic,
builder: (context, value, child) {
return LinearProgressIndicator(
value: value,
minHeight: 8,
backgroundColor:
Colors.white.withValues(alpha: 0.06),
valueColor: const AlwaysStoppedAnimation(
AppTheme.accent,
),
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
'${alchemy.xpForNextLevel - alchemy.currentLevelXp} XP to next level',
bangla:
'পরবর্তী লেভেলের জন্য ${alchemy.xpForNextLevel - alchemy.currentLevelXp} XP',
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

const _StatsGrid({
required this.alchemy,
});

@override
Widget build(BuildContext context) {
return Row(
children: [
Expanded(
child: _StatCard(
icon: Icons.auto_awesome,
value: '${alchemy.xp}',
label: alchemy.text(
english: 'Total XP',
bangla: 'মোট XP',
),
color: AppTheme.accent,
),
),
const SizedBox(width: 12),
Expanded(
child: _StatCard(
icon: Icons.grid_view_rounded,
value: '${alchemy.discoveryCount}',
label: alchemy.text(
english: 'Discoveries',
bangla: 'আবিষ্কার',
),
color: const Color(0xFF65C466),
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
color: AppTheme.surface.withValues(alpha: 0.72),
borderRadius: BorderRadius.circular(20),
border: Border.all(
color: AppTheme.border,
),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Container(
width: 34,
height: 34,
decoration: BoxDecoration(
color: color.withValues(alpha: 0.08),
borderRadius: BorderRadius.circular(11),
),
child: Icon(
icon,
size: 17,
color: color,
),
),
const SizedBox(height: 14),
Text(
value,
style: Theme.of(context)
    .textTheme
    .headlineMedium
    ?.copyWith(
fontSize: 25,
color: AppTheme.primaryText,
),
),
const SizedBox(height: 2),
Text(
label,
style: Theme.of(context).textTheme.labelSmall,
),
],
),
);
}
}

class _RarityCard extends StatelessWidget {
final AlchemyProvider alchemy;

const _RarityCard({
required this.alchemy,
});

@override
Widget build(BuildContext context) {
final counts = _getRarityCounts(alchemy);

return Container(
width: double.infinity,
padding: const EdgeInsets.all(17),
decoration: BoxDecoration(
color: AppTheme.surface.withValues(alpha: 0.72),
borderRadius: BorderRadius.circular(22),
border: Border.all(
color: AppTheme.border,
),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
alchemy.text(
english: 'Discovery Rarities',
bangla: 'আবিষ্কারের বিরলতা',
),
style: Theme.of(context).textTheme.titleMedium,
),
const SizedBox(height: 16),
_RarityRow(
label: alchemy.text(
english: 'Common',
bangla: 'সাধারণ',
),
count: counts[ElementRarity.common] ?? 0,
color: const Color(0xFF9AA3B2),
),
_RarityRow(
label: alchemy.text(
english: 'Uncommon',
bangla: 'অসাধারণ',
),
count: counts[ElementRarity.uncommon] ?? 0,
color: const Color(0xFF65C466),
),
_RarityRow(
label: alchemy.text(
english: 'Rare',
bangla: 'বিরল',
),
count: counts[ElementRarity.rare] ?? 0,
color: const Color(0xFF4DA6FF),
),
_RarityRow(
label: alchemy.text(
english: 'Epic',
bangla: 'এপিক',
),
count: counts[ElementRarity.epic] ?? 0,
color: const Color(0xFFB56CFF),
),
_RarityRow(
label: alchemy.text(
english: 'Legendary',
bangla: 'লেজেন্ডারি',
),
count: counts[ElementRarity.legendary] ?? 0,
color: const Color(0xFFFFB84D),
),
],
),
);
}

Map<ElementRarity, int> _getRarityCounts(
AlchemyProvider alchemy,
) {
final elements = [
ElementData.fire,
ElementData.water,
ElementData.earth,
ElementData.air,
ElementData.steam,
ElementData.lava,
ElementData.energy,
ElementData.plant,
ElementData.cloud,
ElementData.dust,
];

final counts = <ElementRarity, int>{};

for (final element in elements) {
if (alchemy.discoveredElementIds.contains(element.id)) {
counts[element.rarity] =
(counts[element.rarity] ?? 0) + 1;
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
width: 7,
height: 7,
decoration: BoxDecoration(
shape: BoxShape.circle,
color: color,
boxShadow: [
BoxShadow(
color: color.withValues(alpha: 0.45),
blurRadius: 6,
),
],
),
),
const SizedBox(width: 10),
Expanded(
child: Text(
label,
style: Theme.of(context)
    .textTheme
    .bodyMedium
    ?.copyWith(
color: AppTheme.primaryText,
),
),
),
Text(
'$count',
style: Theme.of(context)
    .textTheme
    .titleMedium
    ?.copyWith(
color: count > 0
? color
    : AppTheme.secondaryText,
),
),
],
),
);
}
}

class _AchievementsCard extends StatelessWidget {
final AlchemyProvider alchemy;

const _AchievementsCard({
required this.alchemy,
});

@override
Widget build(BuildContext context) {
final achievements = AchievementData.all;
final unlockedCount = alchemy.achievementCount;

return Container(
width: double.infinity,
padding: const EdgeInsets.all(17),
decoration: BoxDecoration(
color: AppTheme.surface.withValues(alpha: 0.72),
borderRadius: BorderRadius.circular(22),
border: Border.all(
color: AppTheme.border,
),
boxShadow: [
BoxShadow(
color: Colors.black.withValues(alpha: 0.10),
blurRadius: 18,
offset: const Offset(0, 7),
),
],
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Container(
width: 38,
height: 38,
decoration: BoxDecoration(
color: const Color(0xFFFFB84D)
    .withValues(alpha: 0.10),
borderRadius: BorderRadius.circular(12),
),
child: const Icon(
Icons.emoji_events_outlined,
size: 19,
color: Color(0xFFFFB84D),
),
),
const SizedBox(width: 11),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
alchemy.text(
english: 'Achievements',
bangla: 'অর্জনসমূহ',
),
style: Theme.of(context)
    .textTheme
    .titleMedium,
),
const SizedBox(height: 2),
Text(
'$unlockedCount / ${achievements.length} ${alchemy.text(
english: 'unlocked',
bangla: 'আনলক',
)}',
style: Theme.of(context)
    .textTheme
    .labelSmall,
),
],
),
),
],
),

const SizedBox(height: 18),

for (int i = 0; i < achievements.length; i++) ...[
_AchievementTile(
achievement: achievements[i],
alchemy: alchemy,
),
if (i < achievements.length - 1)
const SizedBox(height: 10),
],
],
),
);
}
}

class _AchievementTile extends StatelessWidget {
final AchievementModel achievement;
final AlchemyProvider alchemy;

const _AchievementTile({
required this.achievement,
required this.alchemy,
});

@override
Widget build(BuildContext context) {
final unlocked = alchemy.unlockedAchievementIds
    .contains(achievement.id);

final progress = (alchemy.discoveryCount /
achievement.requiredDiscoveries)
    .clamp(0.0, 1.0);

final color = unlocked
? const Color(0xFFFFB84D)
    : AppTheme.secondaryText;

return AnimatedContainer(
duration: const Duration(milliseconds: 300),
curve: Curves.easeOutCubic,
padding: const EdgeInsets.all(13),
decoration: BoxDecoration(
color: unlocked
? color.withValues(alpha: 0.055)
    : Colors.white.withValues(alpha: 0.025),
borderRadius: BorderRadius.circular(17),
border: Border.all(
color: unlocked
? color.withValues(alpha: 0.18)
    : Colors.white.withValues(alpha: 0.055),
),
boxShadow: unlocked
? [
BoxShadow(
color: color.withValues(alpha: 0.07),
blurRadius: 18,
spreadRadius: 1,
),
]
    : [],
),
child: Row(
children: [
AnimatedContainer(
duration: const Duration(milliseconds: 300),
width: 44,
height: 44,
decoration: BoxDecoration(
shape: BoxShape.circle,
color: color.withValues(
alpha: unlocked ? 0.10 : 0.045,
),
border: Border.all(
color: color.withValues(
alpha: unlocked ? 0.22 : 0.08,
),
),
),
child: Icon(
unlocked
? Icons.emoji_events_rounded
    : Icons.lock_outline_rounded,
size: 20,
color: color.withValues(
alpha: unlocked ? 1.0 : 0.35,
),
),
),

const SizedBox(width: 12),

Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
achievement.getTitle(
alchemy.languageCode,
),
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: Theme.of(context)
    .textTheme
    .titleMedium
    ?.copyWith(
fontSize: 14,
color: unlocked
? AppTheme.primaryText
    : AppTheme.secondaryText,
),
),

const SizedBox(height: 3),

Text(
achievement.getDescription(
alchemy.languageCode,
),
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: Theme.of(context)
    .textTheme
    .labelSmall
    ?.copyWith(
color: unlocked
? AppTheme.secondaryText
    : AppTheme.secondaryText
    .withValues(alpha: 0.65),
height: 1.3,
),
),

const SizedBox(height: 8),

ClipRRect(
borderRadius: BorderRadius.circular(8),
child: LinearProgressIndicator(
value: progress,
minHeight: 4,
backgroundColor:
Colors.white.withValues(alpha: 0.05),
valueColor: AlwaysStoppedAnimation(
color.withValues(
alpha: unlocked ? 0.75 : 0.30,
),
),
),
),

const SizedBox(height: 5),

Text(
'${alchemy.discoveryCount.clamp(0, achievement.requiredDiscoveries)} / ${achievement.requiredDiscoveries} ${alchemy.text(
english: 'discoveries',
bangla: 'আবিষ্কার',
)}',
style: Theme.of(context)
    .textTheme
    .labelSmall
    ?.copyWith(
fontSize: 10,
color: unlocked
? color
    : AppTheme.secondaryText,
),
),
],
),
),

const SizedBox(width: 10),

Column(
children: [
const Icon(
Icons.auto_awesome,
size: 13,
color: Color(0xFFFFB84D),
),
const SizedBox(height: 3),
Text(
'+${achievement.xpReward}',
style: Theme.of(context)
    .textTheme
    .labelSmall
    ?.copyWith(
color: unlocked
? const Color(0xFFFFB84D)
    : AppTheme.secondaryText,
fontWeight: FontWeight.w600,
),
),
Text(
'XP',
style: Theme.of(context)
    .textTheme
    .labelSmall
    ?.copyWith(
fontSize: 9,
),
),
],
),
],
),
);
}
}