import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/alchemy_provider.dart';
import '../theme/app_theme.dart';
import 'alchemical_components.dart';

class LanguageSelector extends StatelessWidget {
  final bool compact;

  const LanguageSelector({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final alchemy = context.watch<AlchemyProvider>();

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LanguageButton(
            label: 'EN',
            selected: alchemy.languageCode == 'en',
            onTap: () {
              alchemy.setLanguage('en');
            },
          ),
          const SizedBox(width: 2),
          _LanguageButton(
            label: 'বাংলা',
            selected: alchemy.languageCode == 'bn',
            onTap: () {
              alchemy.setLanguage('bn');
            },
          ),
        ],
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: selected
            ? AppTheme.accent.withValues(alpha: 0.22)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: selected
              ? AppTheme.accent.withValues(alpha: 0.5)
              : Colors.transparent,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppTheme.accent.withValues(alpha: 0.15),
                  blurRadius: 8,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(11),
          onTap: () {
            HapticHelper.selection();
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              label,
              style: TextStyle(
                color: selected ? AppTheme.primaryText : AppTheme.secondaryText,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
