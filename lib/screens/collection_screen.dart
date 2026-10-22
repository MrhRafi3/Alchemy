import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/element_data.dart';
import '../models/element_model.dart';
import '../providers/alchemy_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/alchemical_components.dart';
import 'element_details_screen.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  _CollectionFilter _filter = _CollectionFilter.all;
  ElementCategory? _categoryFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alchemy = context.watch<AlchemyProvider>();
    final discoveredIds = alchemy.discoveredElementIds;
    final allElements = ElementData.allElements;

    // Filter elements
    final filteredElements = allElements.where((element) {
      final isDiscovered = discoveredIds.contains(element.id);

      // Status filter
      if (_filter == _CollectionFilter.discovered && !isDiscovered) {
        return false;
      }
      if (_filter == _CollectionFilter.locked && isDiscovered) {
        return false;
      }

      // Category filter
      if (_categoryFilter != null && element.category != _categoryFilter) {
        return false;
      }

      // Search query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final nameEn = element.nameEn.toLowerCase();
        final nameBn = element.nameBn.toLowerCase();
        if (!nameEn.contains(query) && !nameBn.contains(query)) {
          return false;
        }
      }

      return true;
    }).toList();

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CollectionHeader(
                    alchemy: alchemy,
                    discoveredCount: discoveredIds.length,
                    totalCount: allElements.length,
                  ),
                  const SizedBox(height: 16),
                  AlchemicalSearchField(
                    controller: _searchController,
                    hintText: alchemy.text(
                      english: 'Search elements...',
                      bangla: 'উপাদান অনুসন্ধান করুন...',
                    ),
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val.trim();
                      });
                    },
                    onClear: () {
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  // Filter Chips
                  _FilterRow(
                    alchemy: alchemy,
                    currentFilter: _filter,
                    onFilterChanged: (f) {
                      setState(() {
                        _filter = f;
                      });
                    },
                    currentCategory: _categoryFilter,
                    onCategoryChanged: (cat) {
                      setState(() {
                        _categoryFilter = cat;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          if (filteredElements.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.surfaceLight,
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: const Icon(
                          Icons.search_off_rounded,
                          size: 32,
                          color: AppTheme.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        alchemy.text(
                          english: 'No elements found',
                          bangla: 'কোন উপাদান পাওয়া যায়নি',
                        ),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        alchemy.text(
                          english: 'Try clearing your search or filter tags.',
                          bangla: 'আপনার সার্চ বা ফিল্টার পরিবর্তন করে দেখুন।',
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.crossAxisExtent;
                  final columns = width >= 700 ? 3 : 2;

                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final element = filteredElements[index];
                      final isDiscovered = discoveredIds.contains(element.id);

                      return _CollectionCard(
                        element: element,
                        languageCode: alchemy.languageCode,
                        isDiscovered: isDiscovered,
                        onSendToLab: isDiscovered
                            ? () {
                                alchemy.addElement(element.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(
                                      milliseconds: 1400,
                                    ),
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
                              }
                            : null,
                      );
                    }, childCount: filteredElements.length),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.05,
                    ),
                  );
                },
              ),
            ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }
}

enum _CollectionFilter { all, discovered, locked }

class _FilterRow extends StatelessWidget {
  final AlchemyProvider alchemy;
  final _CollectionFilter currentFilter;
  final ValueChanged<_CollectionFilter> onFilterChanged;
  final ElementCategory? currentCategory;
  final ValueChanged<ElementCategory?> onCategoryChanged;

  const _FilterRow({
    required this.alchemy,
    required this.currentFilter,
    required this.onFilterChanged,
    required this.currentCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          AlchemicalChip(
            label: alchemy.text(english: 'All', bangla: 'সব'),
            selected:
                currentFilter == _CollectionFilter.all &&
                currentCategory == null,
            onTap: () {
              onFilterChanged(_CollectionFilter.all);
              onCategoryChanged(null);
            },
          ),
          const SizedBox(width: 6),
          AlchemicalChip(
            label: alchemy.text(english: 'Discovered', bangla: 'আবিষ্কৃত'),
            selected: currentFilter == _CollectionFilter.discovered,
            onTap: () {
              onFilterChanged(_CollectionFilter.discovered);
            },
          ),
          const SizedBox(width: 6),
          AlchemicalChip(
            label: alchemy.text(english: 'Locked', bangla: 'লক করা'),
            selected: currentFilter == _CollectionFilter.locked,
            onTap: () {
              onFilterChanged(_CollectionFilter.locked);
            },
          ),
          const SizedBox(width: 10),
          Container(width: 1, height: 20, color: AppTheme.border),
          const SizedBox(width: 10),
          _categoryChip(ElementCategory.nature, 'Nature', 'প্রকৃতি'),
          const SizedBox(width: 6),
          _categoryChip(ElementCategory.weather, 'Weather', 'আবহাওয়া'),
          const SizedBox(width: 6),
          _categoryChip(ElementCategory.energy, 'Energy', 'শক্তি'),
          const SizedBox(width: 6),
          _categoryChip(ElementCategory.matter, 'Matter', 'পদার্থ'),
          const SizedBox(width: 6),
          _categoryChip(ElementCategory.life, 'Life', 'জীবন'),
          const SizedBox(width: 6),
          _categoryChip(ElementCategory.technology, 'Technology', 'প্রযুক্তি'),
        ],
      ),
    );
  }

  Widget _categoryChip(ElementCategory category, String enName, String bnName) {
    final selected = currentCategory == category;
    return AlchemicalChip(
      label: alchemy.text(english: enName, bangla: bnName),
      selected: selected,
      onTap: () {
        if (selected) {
          onCategoryChanged(null);
        } else {
          onCategoryChanged(category);
        }
      },
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
    final progress = totalCount == 0 ? 0.0 : discoveredCount / totalCount;
    final percentage = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          alchemy.text(english: 'Element Collection', bangla: 'উপাদান সংগ্রহ'),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(
          alchemy.text(
            english:
                'Discover and study the primordial elements of the cosmos.',
            bangla: 'মহাবিশ্বের আদিম উপাদানগুলো আবিষ্কার এবং পর্যবেক্ষণ করুন।',
          ),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppTheme.surface.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppTheme.border),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_mosaic_outlined,
                      size: 19,
                      color: AppTheme.accentLight,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alchemy.text(
                            english: 'Discovery Progress',
                            bangla: 'আবিষ্কারের অগ্রগতি',
                          ),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$discoveredCount / $totalCount ${alchemy.text(english: 'discovered', bangla: 'আবিষ্কৃত')}',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$percentage%',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.accentLight,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      minHeight: 7,
                      backgroundColor: Colors.white.withValues(alpha: 0.06),
                      valueColor: const AlwaysStoppedAnimation(AppTheme.accent),
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
  final VoidCallback? onSendToLab;

  const _CollectionCard({
    required this.element,
    required this.languageCode,
    required this.isDiscovered,
    this.onSendToLab,
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
    HapticHelper.light();
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
      onTapDown: widget.isDiscovered ? (_) => _setPressed(true) : null,
      onTapUp: widget.isDiscovered ? (_) => _setPressed(false) : null,
      onTapCancel: widget.isDiscovered ? () => _setPressed(false) : null,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: AppTheme.surface.withValues(
              alpha: widget.isDiscovered ? 0.85 : 0.45,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: widget.isDiscovered
                  ? color.withValues(alpha: _pressed ? 0.5 : 0.22)
                  : AppTheme.border,
              width: widget.isDiscovered ? 1.2 : 1.0,
            ),
            boxShadow: widget.isDiscovered
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: _pressed ? 0.2 : 0.08),
                      blurRadius: _pressed ? 22 : 14,
                      spreadRadius: 1,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: widget.isDiscovered
                    ? _DiscoveredContent(
                        element: element,
                        languageCode: widget.languageCode,
                      )
                    : _UndiscoveredContent(languageCode: widget.languageCode),
              ),
              if (widget.isDiscovered && widget.onSendToLab != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      HapticHelper.light();
                      widget.onSendToLab!();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.surfaceLight.withValues(alpha: 0.8),
                        border: Border.all(color: color.withValues(alpha: 0.3)),
                      ),
                      child: const Icon(
                        Icons.science_outlined,
                        size: 14,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiscoveredContent extends StatelessWidget {
  final ElementModel element;
  final String languageCode;

  const _DiscoveredContent({required this.element, required this.languageCode});

  @override
  Widget build(BuildContext context) {
    final color = element.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Center(
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.06),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.15),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(child: ElementSymbol(element: element, size: 34)),
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
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: [
                  BoxShadow(color: color.withValues(alpha: 0.7), blurRadius: 6),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          _rarityName(element.rarity, languageCode),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
        ),
      ],
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

class _UndiscoveredContent extends StatelessWidget {
  final String languageCode;

  const _UndiscoveredContent({required this.languageCode});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.02),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                size: 24,
                color: Colors.white.withValues(alpha: 0.22),
              ),
            ),
          ),
        ),
        Text(
          '???',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.35),
            letterSpacing: 2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          languageCode == 'bn' ? 'এখনও আবিষ্কৃত নয়' : 'Undiscovered',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.22),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
