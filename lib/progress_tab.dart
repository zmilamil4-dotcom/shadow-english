import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state_provider.dart';
import 'settings_provider.dart';
import 'app_strings.dart';
import 'app_theme.dart';

class ProgressTab extends StatelessWidget {
  const ProgressTab({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<SettingsProvider>().locale;
    final appState = context.watch<AppStateProvider>();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
        children: [
          Text(AppStrings.get('progress', locale),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.local_fire_department_rounded,
                  color: Colors.orange,
                  value: '${appState.streakDays}',
                  label: AppStrings.get('streak_days', locale),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _StatCard(
                  icon: Icons.check_circle_rounded,
                  color: AppTheme.success,
                  value: '${appState.totalTrained}',
                  label: AppStrings.get('total_sentences', locale),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(AppStrings.get('your_stats', locale),
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 14),
          _ProgressRow(icon: Icons.headphones_rounded, color: AppTheme.accentPurple, label: AppStrings.get('listening', locale), value: 0.75),
          const SizedBox(height: 12),
          _ProgressRow(icon: Icons.chat_bubble_rounded, color: AppTheme.success, label: AppStrings.get('speaking', locale), value: 0.6),
          const SizedBox(height: 12),
          _ProgressRow(icon: Icons.menu_book_rounded, color: AppTheme.warning, label: AppStrings.get('vocabulary', locale), value: 0.8),
          const SizedBox(height: 12),
          _ProgressRow(icon: Icons.edit_note_rounded, color: AppTheme.accentBlue, label: AppStrings.get('grammar', locale), value: 0.7),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _StatCard({required this.icon, required this.color, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.cardDecoration(radius: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 10),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 2),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final double value;

  const _ProgressRow({required this.icon, required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.cardDecoration(radius: 16),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyLarge)),
          SizedBox(
            width: 90,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 6,
                backgroundColor: Colors.white12,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('${(value * 100).round()}%', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
