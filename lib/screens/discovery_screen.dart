import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/element_data.dart';
import '../models/element_model.dart';
import '../providers/alchemy_provider.dart';
import '../theme/app_theme.dart';
import 'element_details_screen.dart';

class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final discoveredIds = context.select<AlchemyProvider, Set<String>>(
      (alchemy) => alchemy.discoveredElementIds,
    );
    final languageCode = context.select<AlchemyProvider, String>(
      (alchemy) => alchemy.languageCode,
    );
    final alchemy = context.read<AlchemyProvider>();

    return SafeArea(
      child: Column(
        children: [
          _DiscoveryHeader(
            alchemy: alchemy,
            discoveryCount: discoveredIds.length,
            languageCode: languageCode,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: InteractiveViewer(
              minScale: 0.65,
              maxScale: 2.5,
              boundaryMargin: const EdgeInsets.all(120),
              constrained: false,
              child: SizedBox(
                width: 900,
                height: 680,
                child: _DiscoveryMap(
                  elements: ElementData.allElements,
                  discoveredIds: discoveredIds,
                  languageCode: languageCode,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscoveryHeader extends StatelessWidget {
  final AlchemyProvider alchemy;
  final int discoveryCount;
  final String languageCode;

  const _DiscoveryHeader({
    required this.alchemy,
    required this.discoveryCount,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alchemy.text(
                    english: 'Discovery Tree',
                    bangla: 'আবিষ্কার গাছ',
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium,
                ),
                const SizedBox(height: 5),
                Text(
                  alchemy.text(
                    english: 'Trace the elements you have discovered.',
                    bangla: 'আপনি আবিষ্কার করা উপাদানগুলোর পথ দেখুন।',
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppTheme.surface.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(13),
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
                const SizedBox(width: 6),
                Text(
                  '$discoveryCount',
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
    );
  }
}

class _DiscoveryMap extends StatelessWidget {
  final List<ElementModel> elements;
  final Set<String> discoveredIds;
  final String languageCode;

  const _DiscoveryMap({
    required this.elements,
    required this.discoveredIds,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final positions = _positions;

    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _ConnectionPainter(
              discoveredIds: discoveredIds,
              positions: positions,
            ),
          ),
        ),
        for (final element in elements)
          Positioned(
            left: positions[element.id]!.dx - 46,
            top: positions[element.id]!.dy - 46,
            child: _DiscoveryNode(
              element: element,
              isDiscovered: discoveredIds.contains(element.id),
              languageCode: languageCode,
            ),
          ),
      ],
    );
  }

  static const Map<String, Offset> _positions = {
    'fire': Offset(150, 150),
    'water': Offset(380, 150),
    'earth': Offset(610, 150),
    'air': Offset(760, 290),

    'steam': Offset(265, 290),
    'lava': Offset(495, 290),
    'energy': Offset(690, 410),

    'plant': Offset(265, 450),
    'cloud': Offset(495, 500),
    'dust': Offset(700, 560),
  };
}

class _ConnectionPainter extends CustomPainter {
  final Set<String> discoveredIds;
  final Map<String, Offset> positions;

  _ConnectionPainter({
    required Set<String> discoveredIds,
    required this.positions,
  }) : discoveredIds = Set<String>.unmodifiable(discoveredIds);

  static const List<List<String>> connections = [
    ['fire', 'steam'],
    ['water', 'steam'],
    ['fire', 'lava'],
    ['earth', 'lava'],
    ['fire', 'energy'],
    ['air', 'energy'],
    ['water', 'plant'],
    ['earth', 'plant'],
    ['water', 'cloud'],
    ['air', 'cloud'],
    ['earth', 'dust'],
    ['air', 'dust'],
  ];

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    for (final connection in connections) {
      final first = connection[0];
      final second = connection[1];

      final firstPosition = positions[first];
      final secondPosition = positions[second];

      if (firstPosition == null || secondPosition == null) {
        continue;
      }

      final bothDiscovered =
          discoveredIds.contains(first) &&
              discoveredIds.contains(second);

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = bothDiscovered ? 1.5 : 1
        ..strokeCap = StrokeCap.round
        ..color = bothDiscovered
            ? AppTheme.accent.withValues(alpha: 0.30)
            : Colors.white.withValues(alpha: 0.045);

      canvas.drawLine(
        firstPosition,
        secondPosition,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
      covariant _ConnectionPainter oldDelegate,
      ) {
    return !setEquals(oldDelegate.discoveredIds, discoveredIds) ||
        !mapEquals(oldDelegate.positions, positions);
  }
}

class _DiscoveryNode extends StatefulWidget {
  final ElementModel element;
  final bool isDiscovered;
  final String languageCode;

  const _DiscoveryNode({
    required this.element,
    required this.isDiscovered,
    required this.languageCode,
  });

  @override
  State<_DiscoveryNode> createState() => _DiscoveryNodeState();
}

class _DiscoveryNodeState extends State<_DiscoveryNode> {
  bool _pressed = false;

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
          ? (_) {
        setState(() {
          _pressed = true;
        });
      }
          : null,
      onTapUp: widget.isDiscovered
          ? (_) {
        setState(() {
          _pressed = false;
        });
      }
          : null,
      onTapCancel: widget.isDiscovered
          ? () {
        setState(() {
          _pressed = false;
        });
      }
          : null,
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1,
        duration: const Duration(milliseconds: 120),
        child: SizedBox(
          width: 92,
          height: 108,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isDiscovered
                      ? AppTheme.surfaceLight.withValues(alpha: 0.90)
                      : Colors.white.withValues(alpha: 0.025),
                  border: Border.all(
                    color: widget.isDiscovered
                        ? color.withValues(
                      alpha: _borderOpacity(
                        element.rarity,
                      ),
                    )
                        : Colors.white.withValues(alpha: 0.06),
                    width: 1.2,
                  ),
                  boxShadow: widget.isDiscovered
                      ? [
                    BoxShadow(
                      color: color.withValues(
                        alpha: _glowOpacity(
                          element.rarity,
                        ),
                      ),
                      blurRadius: _glowBlur(
                        element.rarity,
                      ),
                      spreadRadius: 1,
                    ),
                  ]
                      : [],
                ),
                child: Center(
                  child: widget.isDiscovered
                      ? Text(
                    element.icon,
                    style: TextStyle(
                      fontSize: 35,
                      shadows: [
                        Shadow(
                          color: color.withValues(alpha: 0.55),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                  )
                      : Icon(
                    Icons.lock_outline_rounded,
                    size: 24,
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                widget.isDiscovered
                    ? element.getName(widget.languageCode)
                    : '???',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(
                  color: widget.isDiscovered
                      ? AppTheme.primaryText
                      : Colors.white.withValues(alpha: 0.25),
                  fontWeight: widget.isDiscovered
                      ? FontWeight.w500
                      : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _borderOpacity(ElementRarity rarity) {
    switch (rarity) {
      case ElementRarity.common:
        return 0.20;
      case ElementRarity.uncommon:
        return 0.30;
      case ElementRarity.rare:
        return 0.40;
      case ElementRarity.epic:
        return 0.50;
      case ElementRarity.legendary:
        return 0.60;
    }
  }

  double _glowOpacity(ElementRarity rarity) {
    switch (rarity) {
      case ElementRarity.common:
        return 0.06;
      case ElementRarity.uncommon:
        return 0.09;
      case ElementRarity.rare:
        return 0.13;
      case ElementRarity.epic:
        return 0.17;
      case ElementRarity.legendary:
        return 0.22;
    }
  }

  double _glowBlur(ElementRarity rarity) {
    switch (rarity) {
      case ElementRarity.common:
        return 16;
      case ElementRarity.uncommon:
        return 20;
      case ElementRarity.rare:
        return 24;
      case ElementRarity.epic:
        return 28;
      case ElementRarity.legendary:
        return 34;
    }
  }
}