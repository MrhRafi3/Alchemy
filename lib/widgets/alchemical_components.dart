import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/element_model.dart';
import '../theme/app_theme.dart';

/// Displays a guaranteed-to-render, vector elemental symbol with radiant glow.
class ElementSymbol extends StatelessWidget {
  final ElementModel element;
  final double size;
  final Color? color;
  final bool glow;

  const ElementSymbol({
    super.key,
    required this.element,
    this.size = 28,
    this.color,
    this.glow = true,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? element.color;
    return Icon(
      element.iconData,
      size: size,
      color: iconColor,
      shadows: glow
          ? [
              Shadow(
                color: iconColor.withValues(alpha: 0.65),
                blurRadius: size * 0.45,
              ),
            ]
          : null,
    );
  }
}

/// Helper for tactical haptic feedback across touch interactions.
class HapticHelper {
  static bool enabled = true;

  static void light() {
    if (enabled) HapticFeedback.lightImpact();
  }

  static void medium() {
    if (enabled) HapticFeedback.mediumImpact();
  }

  static void selection() {
    if (enabled) HapticFeedback.selectionClick();
  }

  static void success() {
    if (enabled) {
      HapticFeedback.mediumImpact();
      Future.delayed(const Duration(milliseconds: 90), () {
        HapticFeedback.lightImpact();
      });
    }
  }

  static void error() {
    if (enabled) HapticFeedback.vibrate();
  }
}

/// A luxury frosted alchemical card with subtle border glow and depth.
class AlchemicalCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? glowColor;
  final VoidCallback? onTap;
  final double borderRadius;
  final bool elevated;

  const AlchemicalCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.glowColor,
    this.onTap,
    this.borderRadius = 22,
    this.elevated = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = elevated ? AppTheme.surfaceLight : AppTheme.surface;
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: glowColor != null
              ? glowColor!.withValues(alpha: 0.3)
              : AppTheme.border,
          width: glowColor != null ? 1.2 : 1.0,
        ),
        boxShadow: [
          ...AppTheme.cardShadow,
          if (glowColor != null)
            BoxShadow(
              color: glowColor!.withValues(alpha: 0.12),
              blurRadius: 24,
              spreadRadius: 1,
            ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: () {
          HapticHelper.light();
          onTap!();
        },
        child: card,
      );
    }

    return card;
  }
}

/// A tactile interactive button with glowing alchemical states.
class AlchemicalButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final IconData? icon;

  const AlchemicalButton({
    super.key,
    required this.child,
    this.onPressed,
    this.isPrimary = true,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    this.borderRadius = 16,
    this.icon,
  });

  @override
  State<AlchemicalButton> createState() => _AlchemicalButtonState();
}

class _AlchemicalButtonState extends State<AlchemicalButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final primaryColor = widget.color ?? AppTheme.accent;

    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled
          ? (_) {
              setState(() => _pressed = false);
              HapticHelper.light();
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: widget.padding,
          decoration: BoxDecoration(
            gradient: widget.isPrimary && enabled
                ? LinearGradient(
                    colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: widget.isPrimary
                ? (enabled ? null : AppTheme.surfaceLight)
                : AppTheme.surface.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: widget.isPrimary
                  ? Colors.white.withValues(alpha: 0.15)
                  : primaryColor.withValues(alpha: enabled ? 0.35 : 0.15),
            ),
            boxShadow: widget.isPrimary && enabled
                ? [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 16,
                  color: widget.isPrimary ? Colors.white : primaryColor,
                ),
                const SizedBox(width: 8),
              ],
              DefaultTextStyle(
                style: TextStyle(
                  color: widget.isPrimary
                      ? Colors.white
                      : (enabled ? primaryColor : AppTheme.secondaryText),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                child: widget.child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A filter chip for categorizing elements or views with luminous indicator.
class AlchemicalChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;
  final int? count;

  const AlchemicalChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.leading,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticHelper.selection();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.accent.withValues(alpha: 0.18)
              : AppTheme.surface.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppTheme.accent.withValues(alpha: 0.5)
                : AppTheme.border,
            width: selected ? 1.2 : 1.0,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppTheme.accent.withValues(alpha: 0.15),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 6)],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected ? AppTheme.primaryText : AppTheme.secondaryText,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: selected
                      ? AppTheme.accent.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? AppTheme.accentLight
                        : AppTheme.secondaryText,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A sleek search input field styled for the dark alchemical aesthetic.
class AlchemicalSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final VoidCallback? onClear;

  const AlchemicalSearchField({
    super.key,
    required this.controller,
    this.onChanged,
    required this.hintText,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: AppTheme.primaryText, fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppTheme.tertiaryText,
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppTheme.secondaryText,
            size: 20,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppTheme.secondaryText,
                    size: 18,
                  ),
                  onPressed: () {
                    controller.clear();
                    onClear?.call();
                    HapticHelper.light();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

/// Rarity badge component with appropriate jewel color and glowing reflection.
class AlchemicalRarityBadge extends StatelessWidget {
  final ElementRarity rarity;
  final Color color;
  final String label;

  const AlchemicalRarityBadge({
    super.key,
    required this.rarity,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.30), width: 1.0),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.08), blurRadius: 10),
        ],
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
                BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 6),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
