import 'package:flutter/material.dart';

import '../models/element_model.dart';
import '../theme/app_theme.dart';
import 'alchemical_components.dart';

class ElementCard extends StatefulWidget {
  final ElementModel element;
  final String languageCode;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool showRarity;
  final double height;
  final double width;

  const ElementCard({
    super.key,
    required this.element,
    required this.languageCode,
    this.onTap,
    this.isSelected = false,
    this.showRarity = true,
    this.height = 86,
    this.width = 82,
  });

  @override
  State<ElementCard> createState() => _ElementCardState();
}

class _ElementCardState extends State<ElementCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final element = widget.element;
    final color = element.color;
    final name = element.getName(widget.languageCode);

    return LongPressDraggable<String>(
      data: element.id,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 84,
          height: 84,
          child: _DragPreview(element: element, name: name),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.25,
        child: _buildCard(context, color, element, name),
      ),
      onDragStarted: () {
        HapticHelper.medium();
        _setPressed(true);
      },
      onDragEnd: (_) => _setPressed(false),
      child: GestureDetector(
        onTap: () {
          HapticHelper.light();
          widget.onTap?.call();
        },
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: _buildCard(context, color, element, name),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    Color color,
    ElementModel element,
    String name,
  ) {
    final isSelected = widget.isSelected;

    return AnimatedScale(
      scale: _pressed ? 0.93 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.16)
              : AppTheme.surface.withValues(alpha: _pressed ? 0.95 : 0.85),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: 0.8)
                : color.withValues(alpha: _pressed ? 0.5 : 0.22),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? color.withValues(alpha: 0.35)
                  : color.withValues(alpha: _pressed ? 0.25 : 0.08),
              blurRadius: isSelected ? 18 : (_pressed ? 16 : 10),
              spreadRadius: isSelected ? 1 : 0,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.showRarity)
              Positioned(
                top: 7,
                right: 7,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.8),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            if (isSelected)
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                  child: const Icon(Icons.check, size: 9, color: Colors.black),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElementSymbol(element: element, size: 26),
                  const SizedBox(height: 6),
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isSelected ? color : AppTheme.primaryText,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DragPreview extends StatelessWidget {
  final ElementModel element;
  final String name;

  const _DragPreview({required this.element, required this.name});

  @override
  Widget build(BuildContext context) {
    final color = element.color;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 22,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElementSymbol(element: element, size: 32),
            const SizedBox(height: 4),
            Text(
              name,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
