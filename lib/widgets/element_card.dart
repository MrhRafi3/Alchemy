import 'package:flutter/material.dart';

import '../models/element_model.dart';
import '../theme/app_theme.dart';

class ElementCard extends StatefulWidget {
  final ElementModel element;
  final String languageCode;

  const ElementCard({
    super.key,
    required this.element,
    required this.languageCode,
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
          width: 82,
          height: 82,
          child: _DragPreview(
            icon: element.icon,
            color: color,
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.28,
        child: _buildCard(
          context,
          color,
          element.icon,
          name,
        ),
      ),
      onDragStarted: () => _setPressed(true),
      onDragEnd: (_) => _setPressed(false),
      child: _buildCard(
        context,
        color,
        element.icon,
        name,
      ),
    );
  }

  Widget _buildCard(
      BuildContext context,
      Color color,
      String icon,
      String name,
      ) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: 88,
          decoration: BoxDecoration(
            color: AppTheme.surface.withValues(
              alpha: _pressed ? 0.95 : 0.72,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withValues(
                alpha: _pressed ? 0.38 : 0.14,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(
                  alpha: _pressed ? 0.20 : 0.06,
                ),
                blurRadius: _pressed ? 22 : 14,
                spreadRadius: _pressed ? 1 : 0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                icon,
                style: TextStyle(
                  fontSize: 28,
                  shadows: [
                    Shadow(
                      color: color.withValues(
                        alpha: _pressed ? 0.65 : 0.28,
                      ),
                      blurRadius: _pressed ? 14 : 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DragPreview extends StatelessWidget {
  final String icon;
  final Color color;

  const _DragPreview({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.surfaceLight.withValues(alpha: 0.95),
        border: Border.all(
          color: color.withValues(alpha: 0.55),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: 25,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: Text(
          icon,
          style: const TextStyle(
            fontSize: 32,
          ),
        ),
      ),
    );
  }
}