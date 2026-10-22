import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/element_data.dart';
import '../models/element_model.dart';
import '../providers/alchemy_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/alchemical_components.dart';
import 'element_details_screen.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    HapticHelper.light();
    _transformationController.value = Matrix4.identity();
  }

  void _zoomIn() {
    HapticHelper.light();
    final matrix = _transformationController.value.clone();
    matrix.scaleByDouble(1.25, 1.25, 1.0, 1.0);
    _transformationController.value = matrix;
  }

  void _zoomOut() {
    HapticHelper.light();
    final matrix = _transformationController.value.clone();
    matrix.scaleByDouble(0.8, 0.8, 1.0, 1.0);
    _transformationController.value = matrix;
  }

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
      child: Stack(
        children: [
          Column(
            children: [
              _DiscoveryHeader(
                alchemy: alchemy,
                discoveryCount: discoveredIds.length,
                languageCode: languageCode,
              ),
              const SizedBox(height: 6),
              Expanded(
                child: ClipRect(
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    minScale: 0.5,
                    maxScale: 2.8,
                    boundaryMargin: const EdgeInsets.all(160),
                    constrained: false,
                    child: SizedBox(
                      width: 1100,
                      height: 840,
                      child: _DiscoveryMap(
                        elements: ElementData.allElements,
                        discoveredIds: discoveredIds,
                        languageCode: languageCode,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Floating Zoom & Center Controls
          Positioned(
            right: 18,
            bottom: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _FloatingControlButton(
                  icon: Icons.add,
                  tooltip: 'Zoom in',
                  onTap: _zoomIn,
                ),
                const SizedBox(height: 8),
                _FloatingControlButton(
                  icon: Icons.remove,
                  tooltip: 'Zoom out',
                  onTap: _zoomOut,
                ),
                const SizedBox(height: 8),
                _FloatingControlButton(
                  icon: Icons.center_focus_strong_rounded,
                  tooltip: 'Reset view',
                  onTap: _resetZoom,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingControlButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _FloatingControlButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Icon(icon, size: 20, color: AppTheme.primaryText),
        ),
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
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  alchemy.text(
                    english:
                        'Interactive constellation of cosmic element synthesis.',
                    bangla:
                        'মহাজাগতিক উপাদান সংশ্লেষণের ইন্টারেক্টিভ মানচিত্র।',
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surface.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  size: 15,
                  color: AppTheme.accentLight,
                ),
                const SizedBox(width: 6),
                Text(
                  '$discoveryCount',
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
          if (positions.containsKey(element.id))
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
    // Starting Elements Tier
    'fire': Offset(160, 140),
    'water': Offset(420, 140),
    'earth': Offset(680, 140),
    'air': Offset(940, 140),

    // Tier 1 Discoveries
    'steam': Offset(280, 290),
    'lava': Offset(540, 290),
    'plant': Offset(420, 430),
    'energy': Offset(820, 290),
    'cloud': Offset(680, 430),
    'dust': Offset(940, 430),

    // Tier 2 Discoveries
    'stone': Offset(540, 430),
    'rain': Offset(280, 570),
    'lightning': Offset(780, 570),
    'sand': Offset(940, 570),
    'obsidian': Offset(160, 430),

    // Tier 3 Advanced Syntheses
    'glass': Offset(940, 710),
    'life': Offset(420, 710),
    'metal': Offset(540, 710),
    'volcano': Offset(160, 710),
    'storm': Offset(720, 710),
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
    ['lava', 'stone'],
    ['air', 'stone'],
    ['water', 'rain'],
    ['cloud', 'rain'],
    ['stone', 'sand'],
    ['air', 'sand'],
    ['fire', 'glass'],
    ['sand', 'glass'],
    ['energy', 'lightning'],
    ['cloud', 'lightning'],
    ['energy', 'life'],
    ['plant', 'life'],
    ['lava', 'obsidian'],
    ['water', 'obsidian'],
    ['stone', 'metal'],
    ['fire', 'metal'],
    ['cloud', 'storm'],
    ['lightning', 'storm'],
    ['earth', 'volcano'],
    ['lava', 'volcano'],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final connection in connections) {
      final first = connection[0];
      final second = connection[1];

      final firstPosition = positions[first];
      final secondPosition = positions[second];

      if (firstPosition == null || secondPosition == null) {
        continue;
      }

      final bothDiscovered =
          discoveredIds.contains(first) && discoveredIds.contains(second);

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = bothDiscovered ? 2.0 : 1.0
        ..strokeCap = StrokeCap.round
        ..color = bothDiscovered
            ? AppTheme.accentLight.withValues(alpha: 0.45)
            : Colors.white.withValues(alpha: 0.05);

      canvas.drawLine(firstPosition, secondPosition, paint);

      // Glow effect on discovered branches
      if (bothDiscovered) {
        final glowPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0
          ..strokeCap = StrokeCap.round
          ..color = AppTheme.accent.withValues(alpha: 0.15);

        canvas.drawLine(firstPosition, secondPosition, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConnectionPainter oldDelegate) {
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
      onTapDown: widget.isDiscovered
          ? (_) => setState(() => _pressed = true)
          : null,
      onTapUp: widget.isDiscovered
          ? (_) => setState(() => _pressed = false)
          : null,
      onTapCancel: widget.isDiscovered
          ? () => setState(() => _pressed = false)
          : null,
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
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
                      ? AppTheme.surfaceLight.withValues(alpha: 0.92)
                      : Colors.white.withValues(alpha: 0.025),
                  border: Border.all(
                    color: widget.isDiscovered
                        ? color.withValues(alpha: _pressed ? 0.8 : 0.4)
                        : Colors.white.withValues(alpha: 0.08),
                    width: widget.isDiscovered ? 1.5 : 1.0,
                  ),
                  boxShadow: widget.isDiscovered
                      ? [
                          BoxShadow(
                            color: color.withValues(
                              alpha: _pressed ? 0.35 : 0.16,
                            ),
                            blurRadius: _pressed ? 24 : 16,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: widget.isDiscovered
                      ? ElementSymbol(element: element, size: 30)
                      : Icon(
                          Icons.lock_outline_rounded,
                          size: 22,
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
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: widget.isDiscovered
                      ? AppTheme.primaryText
                      : Colors.white.withValues(alpha: 0.28),
                  fontWeight: widget.isDiscovered
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
