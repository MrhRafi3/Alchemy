import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/element_data.dart';
import '../data/recipe_data.dart';
import '../models/element_model.dart';
import '../providers/alchemy_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/alchemical_components.dart';

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
    final alchemy = context.watch<AlchemyProvider>();
    final ingredients = RecipeData.findIngredientsFor(element.id);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BackButton(languageCode: languageCode),
                    const SizedBox(height: 24),
                    _ElementHero(element: element, color: color),
                    const SizedBox(height: 24),
                    _ElementTitle(element: element, languageCode: languageCode),
                    const SizedBox(height: 20),
                    _DescriptionCard(
                      element: element,
                      languageCode: languageCode,
                    ),
                    const SizedBox(height: 14),
                    _InformationCard(
                      element: element,
                      languageCode: languageCode,
                    ),
                    const SizedBox(height: 14),
                    _RecipeCard(
                      ingredients: ingredients,
                      languageCode: languageCode,
                    ),
                    const SizedBox(height: 24),
                    // Action: Load into Lab
                    Center(
                      child: AlchemicalButton(
                        color: color,
                        icon: Icons.science_rounded,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        onPressed: () {
                          alchemy.addElement(element.id);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(milliseconds: 1500),
                              content: Text(
                                alchemy.text(
                                  english:
                                      '${element.nameEn} loaded into Lab chamber!',
                                  bangla:
                                      '${element.nameBn} ল্যাব চেম্বারে যুক্ত হয়েছে!',
                                ),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          alchemy.text(
                            english: 'Send to Lab Chamber',
                            bangla: 'ল্যাব চেম্বারে পাঠান',
                          ),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
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

  const _BackButton({required this.languageCode});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticHelper.light();
        Navigator.of(context).pop();
      },
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppTheme.surface.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
          boxShadow: AppTheme.cardShadow,
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

  const _ElementHero({required this.element, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.05),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.16),
                  blurRadius: 75,
                  spreadRadius: 10,
                ),
                BoxShadow(
                  color: color.withValues(alpha: 0.08),
                  blurRadius: 130,
                  spreadRadius: 25,
                ),
              ],
            ),
          ),
          Container(
            width: 146,
            height: 146,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.surfaceLight.withValues(alpha: 0.85),
              border: Border.all(
                color: color.withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.22),
                  blurRadius: 36,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(child: ElementSymbol(element: element, size: 64)),
          ),
        ],
      ),
    );
  }
}

class _ElementTitle extends StatelessWidget {
  final ElementModel element;
  final String languageCode;

  const _ElementTitle({required this.element, required this.languageCode});

  @override
  Widget build(BuildContext context) {
    final color = element.color;

    return Column(
      children: [
        Center(
          child: Text(
            element.getName(languageCode),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w800,
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.75), blurRadius: 8),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _rarityName(rarity, languageCode),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  String _rarityName(ElementRarity rarity, String languageCode) {
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

  const _DescriptionCard({required this.element, required this.languageCode});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            languageCode == 'bn' ? 'সম্পর্কে' : 'About',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(
            element.getDescription(languageCode),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.55,
              color: AppTheme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final List<String>? ingredients;
  final String languageCode;

  const _RecipeCard({required this.ingredients, required this.languageCode});

  @override
  Widget build(BuildContext context) {
    final hasRecipe = ingredients != null && ingredients!.length == 2;

    ElementModel? el1;
    ElementModel? el2;
    if (hasRecipe) {
      el1 = ElementData.findById(ingredients![0]);
      el2 = ElementData.findById(ingredients![1]);
    }

    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            languageCode == 'bn' ? 'আলকেমিক উৎস' : 'Alchemical Origin',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          if (hasRecipe && el1 != null && el2 != null)
            Row(
              children: [
                _MiniElementPill(element: el1, lang: languageCode),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '+',
                    style: TextStyle(
                      color: AppTheme.secondaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _MiniElementPill(element: el2, lang: languageCode),
              ],
            )
          else
            Row(
              children: [
                const Icon(Icons.flare_rounded, color: AppTheme.gold, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    languageCode == 'bn'
                        ? 'আদিম উপাদান — সৃষ্টির সূচনা থেকেই বিদ্যমান।'
                        : 'Primal Element — existed since the dawn of creation.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _MiniElementPill extends StatelessWidget {
  final ElementModel element;
  final String lang;

  const _MiniElementPill({required this.element, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: element.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: element.color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElementSymbol(element: element, size: 16),
          const SizedBox(width: 7),
          Text(
            element.getName(lang),
            style: TextStyle(
              color: element.color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
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

  const _InformationCard({required this.element, required this.languageCode});

  @override
  Widget build(BuildContext context) {
    final color = element.color;

    return _GlassCard(
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.category_outlined,
            title: languageCode == 'bn' ? 'ক্যাটাগরি' : 'Category',
            value: _categoryName(element.category, languageCode),
            color: color,
          ),
          Divider(height: 24, color: Colors.white.withValues(alpha: 0.06)),
          _InfoRow(
            icon: Icons.auto_awesome,
            title: languageCode == 'bn' ? 'আবিষ্কার XP' : 'Discovery XP',
            value: '+${ElementData.xpForRarity(element.rarity)} XP',
            color: color,
          ),
          Divider(height: 24, color: Colors.white.withValues(alpha: 0.06)),
          _InfoRow(
            icon: Icons.fingerprint_rounded,
            title: 'Element ID',
            value: element.id,
            color: color,
          ),
        ],
      ),
    );
  }

  String _categoryName(ElementCategory category, String languageCode) {
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
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.secondaryText),
          ),
        ),
        Text(
          value,
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({required this.child});

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
      child: child,
    );
  }
}
