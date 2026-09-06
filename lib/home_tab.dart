import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state_provider.dart';
import 'settings_provider.dart';
import 'app_strings.dart';
import 'app_theme.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<SettingsProvider>().locale;
    final appState = context.read<AppStateProvider>();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.graphic_eq_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text('EchoSpeak',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 22)),
              ),
              Icon(Icons.notifications_none_rounded, color: AppTheme.textSecondary),
            ],
          ),
          const SizedBox(height: 4),
          Text(AppStrings.get('welcome_sub', locale),
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),

          // Daily goal card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.glowDecoration(gradient: AppTheme.primaryGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.get('daily_goal', locale),
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 6),
                Text(AppStrings.get('daily_goal_sub', locale),
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: 0.6,
                    minHeight: 8,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                Text(AppStrings.get('daily_goal_progress', locale),
                    style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.accentPurple,
                    minimumSize: const Size(140, 44),
                  ),
                  onPressed: () => appState.goToPractice(),
                  child: Text(AppStrings.get('continue_learning', locale)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),
          Text(AppStrings.get('continue_learning', locale),
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 14),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.5,
            children: [
              _SkillCard(
                icon: Icons.headphones_rounded,
                color: AppTheme.accentPurple,
                title: AppStrings.get('listening', locale),
                progress: 0.75,
              ),
              _SkillCard(
                icon: Icons.chat_bubble_rounded,
                color: AppTheme.success,
                title: AppStrings.get('speaking', locale),
                progress: 0.6,
              ),
              _SkillCard(
                icon: Icons.menu_book_rounded,
                color: AppTheme.warning,
                title: AppStrings.get('vocabulary', locale),
                progress: 0.8,
              ),
              _SkillCard(
                icon: Icons.edit_note_rounded,
                color: AppTheme.accentBlue,
                title: AppStrings.get('grammar', locale),
                progress: 0.7,
              ),
            ],
          ),

          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.cardDecoration(),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient, shape: BoxShape.circle),
                  child: const Icon(Icons.smart_toy_rounded, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.get('ai_tutor_title', locale),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(AppStrings.get('ai_tutor_coming_soon', locale),
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.cardDecoration(),
            child: Row(
              children: [
                const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 32),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(AppStrings.get('daily_challenge', locale),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size(90, 40)),
                  onPressed: () => appState.goToPractice(),
                  child: Text(AppStrings.get('start', locale)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final double progress;

  const _SkillCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(radius: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const Spacer(),
          Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}
