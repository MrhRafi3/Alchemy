import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/element_data.dart';
import '../models/element_model.dart';
import '../providers/alchemy_provider.dart';
import '../theme/app_theme.dart';
import 'element_details_screen.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alchemy = context.watch<AlchemyProvider>();
    final discoveredIds = alchemy.discoveredElementIds;

    final allElements = [
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

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            sliver: SliverToBoxAdapter(
              child: _CollectionHeader(
                alchemy: alchemy,
                discoveredCount: discoveredIds.length,
                totalCount: allElements.length,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.crossAxisExtent;

                final columns = width >= 700 ? 3 : 2;

                return SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final element = allElements[index];
                      final isDiscovered =
                      discoveredIds.contains(element.id);

                      return _CollectionCard(
                        element: element,
                        languageCode: alchemy.languageCode,
                        isDiscovered: isDiscovered,
                      );
                    },
                    childCount: allElements.length,
                  ),
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.08,
                  ),
                );
              },
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(bottom: 24),
          ),
        ],
      ),
    );
  }
}

class _CollectionHeader extends StatelessWidget {
  final AlchemyProvider alchemy;
  final int discoveredCount;
  final int totalCount;

  const _CollectionHeader({
    required this.alchemy,
    required this.discoveredCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalCount == 0
        ? 0.0
        : discoveredCount / totalCount;

    final percentage = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          alchemy.text(
            english: 'Element Collection',
            bangla: 'উপাদান সংগ্রহ',
          ),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 6),
        Text(
          alchemy.text(
            english: 'Discover the elements hidden within Alchemy.',
            bangla: 'Alchemy-এর মধ্যে লুকিয়ে থাকা উপাদানগুলো আবিষ্কার করুন।',
          ),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: AppTheme.surface.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppTheme.border,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_mosaic_outlined,
                      size: 17,
                      color: AppTheme.accent,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alchemy.text(
                            english: 'Discovery Progress',
                            bangla: 'আবিষ্কারের অগ্রগতি',
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$discoveredCount / $totalCount ${alchemy.text(
                            english: 'discovered',
                            bangla: 'আবিষ্কৃত',
                          )}',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$percentage%',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: 0,
                    end: progress,
                  ),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      minHeight: 7,
                      backgroundColor:
                      Colors.white.withValues(alpha: 0.06),
                      valueColor:
                      const AlwaysStoppedAnimation(
                        AppTheme.accent,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CollectionCard extends StatefulWidget {
  final ElementModel element;
  final String languageCode;
  final bool isDiscovered;

  const _CollectionCard({
    required this.element,
    required this.languageCode,
    required this.isDiscovered,
  });

  @override
  State<_CollectionCard> createState() => _CollectionCardState();
}

class _CollectionCardState extends State<_CollectionCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;

    setState(() {
      _pressed = value;
    });
  }

  void _openDetails() {
    if (!widget.isDiscovered) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ElementDetailsScreen(
          element: widget.element,
          languageCode: widget.languageCode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final element = widget.element;
    final color = element.color;

    return GestureDetector(
      onTap: widget.isDiscovered ? _openDetails : null,
      onTapDown: widget.isDiscovered
          ? (_) => _setPressed(true)
          : null,
      onTapUp: widget.isDiscovered
          ? (_) => _setPressed(false)
          : null,
      onTapCancel: widget.isDiscovered
          ? () => _setPressed(false)
          : null,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: AppTheme.surface.withValues(
              alpha: widget.isDiscovered ? 0.78 : 0.46,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: widget.isDiscovered
                  ? _rarityBorderColor(
                element.rarity,
                color,
              )
                  : AppTheme.border,
              width: widget.isDiscovered ? 1.1 : 1,
            ),
            boxShadow: widget.isDiscovered
                ? [
              BoxShadow(
                color: color.withValues(
                  alpha: _rarityGlowOpacity(
                    element.rarity,
                  ),
                ),
                blurRadius: _rarityBlur(
                  element.rarity,
                ),
                spreadRadius: 1,
              ),
            ]
                : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 16,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: widget.isDiscovered
                ? _DiscoveredContent(
              element: element,
              languageCode: widget.languageCode,
            )
                : _UndiscoveredContent(
              languageCode: widget.languageCode,
            ),
          ),
        ),
      ),
    );
  }

  Color _rarityBorderColor(
      ElementRarity rarity,
      Color elementColor,
      ) {
    switch (rarity) {
      case ElementRarity.common:
        return elementColor.withValues(alpha: 0.18);
      case ElementRarity.uncommon:
        return elementColor.withValues(alpha: 0.28);
      case ElementRarity.rare:
        return elementColor.withValues(alpha: 0.38);
      case ElementRarity.epic:
        return elementColor.withValues(alpha: 0.48);
      case ElementRarity.legendary:
        return elementColor.withValues(alpha: 0.58);
    }
  }

  double _rarityGlowOpacity(ElementRarity rarity) {
    switch (rarity) {
      case ElementRarity.common:
        return 0.05;
      case ElementRarity.uncommon:
        return 0.08;
      case ElementRarity.rare:
        return 0.12;
      case ElementRarity.epic:
        return 0.16;
      case ElementRarity.legendary:
        return 0.22;
    }
  }

  double _rarityBlur(ElementRarity rarity) {
    switch (rarity) {
      case ElementRarity.common:
        return 14;
      case ElementRarity.uncommon:
        return 18;
      case ElementRarity.rare:
        return 22;
      case ElementRarity.epic:
        return 26;
      case ElementRarity.legendary:
        return 32;
    }
  }
}

class _DiscoveredContent extends StatelessWidget {
  final ElementModel element;
  final String languageCode;

  const _DiscoveredContent({
    required this.element,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final color = element.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.035),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.10),
                    blurRadius: 25,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  element.icon,
                  style: TextStyle(
                    fontSize: 42,
                    shadows: [
                      Shadow(
                        color: color.withValues(alpha: 0.50),
                        blurRadius: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                element.getName(languageCode),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  color: AppTheme.primaryText,
                ),
              ),
            ),
            const SizedBox(width: 6),
            _RarityDot(
              color: color,
              rarity: element.rarity,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          _rarityName(
            element.rarity,
            languageCode,
          ),
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _rarityName(
      ElementRarity rarity,
      String languageCode,
      ) {
    if (languageCode == 'bn') {
      switch (rarity) {
        case ElementRarity.common:
          return 'সাধারণ';
        case ElementRarity.uncommon:
          return 'অসাধারণ';
        case ElementRarity.rare:
          return 'বিরল';
        case ElementRarity.epic:
          return 'এপিক';
        case ElementRarity.legendary:
          return 'লেজেন্ডারি';
      }
    }

    switch (rarity) {
      case ElementRarity.common:
        return 'Common';
      case ElementRarity.uncommon:
        return 'Uncommon';
      case ElementRarity.rare:
        return 'Rare';
      case ElementRarity.epic:
        return 'Epic';
      case ElementRarity.legendary:
        return 'Legendary';
    }
  }
}

class _UndiscoveredContent extends StatelessWidget {
  final String languageCode;

  const _UndiscoveredContent({
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.025),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                size: 30,
                color: Colors.white.withValues(alpha: 0.20),
              ),
            ),
          ),
        ),
        Text(
          '???',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(
            color: Colors.white.withValues(alpha: 0.35),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          languageCode == 'bn'
              ? 'এখনও আবিষ্কৃত নয়'
              : 'Not discovered',
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(
            color: Colors.white.withValues(alpha: 0.25),
          ),
        ),
      ],
    );
  }
}

class _RarityDot extends StatelessWidget {
  final Color color;
  final ElementRarity rarity;

  const _RarityDot({
    required this.color,
    required this.rarity,
  });

  @override
  Widget build(BuildContext context) {
    final size = rarity == ElementRarity.legendary ? 7.0 : 6.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.55),
            blurRadius: 7,
          ),
        ],
      ),
    );
  }
}