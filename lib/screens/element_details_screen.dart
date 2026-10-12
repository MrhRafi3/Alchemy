import 'package:flutter/material.dart';

import '../models/element_model.dart';
import '../theme/app_theme.dart';

class ElementDetailsScreen extends StatelessWidget {
  final ElementModel element;
  final String languageCode;

  const ElementDetailsScreen({
    super.key,
    required this.element,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final color = element.color;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BackButton(
                      languageCode: languageCode,
                    ),

                    const SizedBox(height: 28),

                    _ElementHero(
                      element: element,
                      color: color,
                    ),

                    const SizedBox(height: 28),

                    _ElementTitle(
                      element: element,
                      languageCode: languageCode,
                    ),

                    const SizedBox(height: 24),

                    _DescriptionCard(
                      element: element,
                      languageCode: languageCode,
                    ),

                    const SizedBox(height: 14),

                    _InformationCard(
                      element: element,
                      languageCode: languageCode,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final String languageCode;

  const _BackButton({
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppTheme.surface.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppTheme.border,
          ),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 17,
          color: AppTheme.primaryText,
        ),
      ),
    );
  }
}

class _ElementHero extends StatelessWidget {
  final ElementModel element;
  final Color color;

  const _ElementHero({
    required this.element,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.035),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.10),
                  blurRadius: 65,
                  spreadRadius: 10,
                ),
                BoxShadow(
                  color: color.withValues(alpha: 0.06),
                  blurRadius: 120,
                  spreadRadius: 25,
                ),
              ],
            ),
          ),

          Container(
            width: 142,
            height: 142,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.surfaceLight.withValues(alpha: 0.72),
              border: Border.all(
                color: color.withValues(alpha: 0.24),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.14),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                element.icon,
                style: TextStyle(
                  fontSize: 72,
                  shadows: [
                    Shadow(
                      color: color.withValues(alpha: 0.55),
                      blurRadius: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ElementTitle extends StatelessWidget {
  final ElementModel element;
  final String languageCode;

  const _ElementTitle({
    required this.element,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final color = element.color;

    return Column(
      children: [
        Center(
          child: Text(
            element.getName(languageCode),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(
              fontSize: 30,
              letterSpacing: -0.6,
            ),
          ),
        ),

        const SizedBox(height: 10),

        Center(
          child: _RarityBadge(
            rarity: element.rarity,
            color: color,
            languageCode: languageCode,
          ),
        ),
      ],
    );
  }
}

class _RarityBadge extends StatelessWidget {
  final ElementRarity rarity;
  final Color color;
  final String languageCode;

  const _RarityBadge({
    required this.rarity,
    required this.color,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
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
          ),
          const SizedBox(width: 7),
          Text(
            _rarityName(rarity, languageCode),
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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

class _DescriptionCard extends StatelessWidget {
  final ElementModel element;
  final String languageCode;

  const _DescriptionCard({
    required this.element,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            languageCode == 'bn'
                ? 'সম্পর্কে'
                : 'About',
            style: Theme.of(context)
                .textTheme
                .titleMedium,
          ),

          const SizedBox(height: 10),

          Text(
            element.getDescription(languageCode),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
              height: 1.55,
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _InformationCard extends StatelessWidget {
  final ElementModel element;
  final String languageCode;

  const _InformationCard({
    required this.element,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final color = element.color;

    return _GlassCard(
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.category_outlined,
            title: languageCode == 'bn'
                ? 'ক্যাটাগরি'
                : 'Category',
            value: _categoryName(
              element.category,
              languageCode,
            ),
            color: color,
          ),

          Divider(
            height: 24,
            color: Colors.white.withValues(alpha: 0.06),
          ),

          _InfoRow(
            icon: Icons.auto_awesome,
            title: languageCode == 'bn'
                ? 'আবিষ্কার XP'
                : 'Discovery XP',
            value: '+${_xpForRarity(element.rarity)} XP',
            color: color,
          ),

          Divider(
            height: 24,
            color: Colors.white.withValues(alpha: 0.06),
          ),

          _InfoRow(
            icon: Icons.fingerprint_rounded,
            title: languageCode == 'bn'
                ? 'Element ID'
                : 'Element ID',
            value: element.id,
            color: color,
          ),
        ],
      ),
    );
  }

  String _categoryName(
      ElementCategory category,
      String languageCode,
      ) {
    if (languageCode == 'bn') {
      switch (category) {
        case ElementCategory.nature:
          return 'প্রকৃতি';
        case ElementCategory.matter:
          return 'পদার্থ';
        case ElementCategory.weather:
          return 'আবহাওয়া';
        case ElementCategory.energy:
          return 'শক্তি';
        case ElementCategory.life:
          return 'জীবন';
        case ElementCategory.technology:
          return 'প্রযুক্তি';
        case ElementCategory.civilization:
          return 'সভ্যতা';
        case ElementCategory.cosmic:
          return 'মহাজাগতিক';
        case ElementCategory.mystical:
          return 'রহস্যময়';
      }
    }

    switch (category) {
      case ElementCategory.nature:
        return 'Nature';
      case ElementCategory.matter:
        return 'Matter';
      case ElementCategory.weather:
        return 'Weather';
      case ElementCategory.energy:
        return 'Energy';
      case ElementCategory.life:
        return 'Life';
      case ElementCategory.technology:
        return 'Technology';
      case ElementCategory.civilization:
        return 'Civilization';
      case ElementCategory.cosmic:
        return 'Cosmic';
      case ElementCategory.mystical:
        return 'Mystical';
    }
  }

  int _xpForRarity(ElementRarity rarity) {
    switch (rarity) {
      case ElementRarity.common:
        return 25;
      case ElementRarity.uncommon:
        return 50;
      case ElementRarity.rare:
        return 100;
      case ElementRarity.epic:
        return 200;
      case ElementRarity.legendary:
        return 500;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium,
          ),
        ),

        Text(
          value,
          textAlign: TextAlign.right,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(20),
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
      child: child,
    );
  }
}