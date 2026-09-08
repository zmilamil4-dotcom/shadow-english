import 'package:flutter/material.dart';
import '../app_theme.dart';

class LevelChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Gradient gradient;

  const LevelChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
    this.gradient = AppTheme.primaryGradient,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          gradient: selected ? gradient : null,
          color: selected ? null : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: selected ? null : Border.all(color: Colors.white12),
        ),
        child: Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: selected ? Colors.white : AppTheme.textSecondary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
