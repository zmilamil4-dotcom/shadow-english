import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state_provider.dart';
import 'settings_provider.dart';
import 'app_strings.dart';
import 'app_theme.dart';
import 'lesson_model.dart';
import 'lesson_repository.dart';
import 'lesson_screen.dart';
import 'widgets/echo_background.dart';
import 'widgets/glass_card.dart';
import 'widgets/glow_button.dart';
import 'widgets/level_chip.dart';
import 'widgets/section_header.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String _selectedLevel = 'A1';

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<SettingsProvider>().locale;
    final appState = context.read<AppStateProvider>();
    final levels = ['A1', 'A2', 'B1', 'B2', 'C1'];
    final recommendedLessons = LessonRepository.getByLevel(_selectedLevel);

    return EchoBackground(
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 110,
          ),
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(Icons.graphic_eq_rounded, color: Colors.white),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.get('welcome', locale), style: AppTextStyles.title),
                      Text(AppStrings.get('welcome_sub', locale), style: AppTextStyles.bodySecondary),
                    ],
                  ),
                ),
                Icon(Icons.notifications_none_rounded, color: AppTheme.textSecondary),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Level selector
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: levels.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, i) {
                  return LevelChip(
                    label: levels[i],
                    selected: levels[i] == _selectedLevel,
                    onTap: () => setState(() => _selectedLevel = levels[i]),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Continue Learning card
            GlassCard(
              radius: AppRadius.xl,
              gradient: AppTheme.primaryGradient,
              glow: true,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.get('daily_goal', locale),
                      style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(AppStrings.get('daily_goal_sub', locale),
                      style: AppTextStyles.heading.copyWith(fontSize: 20, color: Colors.white)),
                  const SizedBox(height: AppSpacing.md),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    child: LinearProgressIndicator(
                      value: 0.6,
                      minHeight: 8,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(AppStrings.get('daily_goal_progress', locale),
                      style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                  const SizedBox(height: AppSpacing.md),
                  GlowButton(
                    label: AppStrings.get('continue_learning', locale),
                    icon: Icons.play_arrow_rounded,
                    gradient: const LinearGradient(colors: [Colors.white, Colors.white]),
                    onTap: () => appState.goToPractice(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Quick actions
            Row(
              children: [
                Expanded(
                  child: GlowButton(
                    label: AppStrings.get('speaking_practice', locale),
                    icon: Icons.mic_rounded,
                    gradient: AppTheme.pinkGradient,
                    onTap: () => appState.goToPractice(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: GlowButton(
                    label: AppStrings.get('learn', locale),
                    icon: Icons.menu_book_rounded,
                    gradient: AppTheme.blueCyanGradient,
                    onTap: () => appState.setTab(1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Progress summary
            SectionHeader(title: AppStrings.get('your_stats', locale)),
            const SizedBox(height: AppSpacing.md),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
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
            const SizedBox(height: AppSpacing.xl),

            // Recommended lessons
            SectionHeader(
              title: 'Recommended Lessons',
              actionLabel: AppStrings.get('lessons', locale),
              onAction: () => appState.setTab(1),
            ),
            const SizedBox(height: AppSpacing.md),
            if (recommendedLessons.isEmpty)
              Text(
                locale == 'ar' ? 'لا توجد دروس لهذا المستوى بعد' : 'No lessons for this level yet',
                style: AppTextStyles.bodySecondary,
              )
            else
              ...recommendedLessons.map((lesson) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _HomeLessonCard(
                      lesson: lesson,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => LessonScreen(lesson: lesson)),
                        );
                      },
                    ),
                  )),

            const SizedBox(height: AppSpacing.lg),
            GlassCard(
              radius: AppRadius.lg,
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.smart_toy_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.get('ai_tutor_title', locale), style: AppTextStyles.title.copyWith(fontSize: 15)),
                        const SizedBox(height: AppSpacing.xs),
                        Text(AppStrings.get('ai_tutor_coming_soon', locale), style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            GlassCard(
              radius: AppRadius.lg,
              child: Row(
                children: [
                  const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 32),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(AppStrings.get('daily_challenge', locale), style: AppTextStyles.title.copyWith(fontSize: 15)),
                  ),
                  SizedBox(
                    width: 90,
                    child: GlowButton(
                      label: AppStrings.get('start', locale),
                      gradient: AppTheme.primaryGradient,
                      height: 40,
                      onTap: () => appState.goToPractice(),
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
    return GlassCard(
      radius: AppRadius.md,
      padding: const EdgeInsets.all(AppSpacing.sm + 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.2), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const Spacer(),
          Text(title, style: AppTextStyles.body.copyWith(fontSize: 14)),
          const SizedBox(height: AppSpacing.xs),
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

class _HomeLessonCard extends StatelessWidget {
  final LessonModel lesson;
  final VoidCallback onTap;

  const _HomeLessonCard({required this.lesson, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final minutes = (lesson.durationSeconds / 60).ceil();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: GlassCard(
        radius: AppRadius.lg,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lesson.title, style: AppTextStyles.title.copyWith(fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(lesson.description, style: AppTextStyles.caption),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text('$minutes min', style: AppTextStyles.caption),
                      const SizedBox(width: 12),
                      Icon(Icons.category_outlined, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(lesson.category, style: AppTextStyles.caption),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}
