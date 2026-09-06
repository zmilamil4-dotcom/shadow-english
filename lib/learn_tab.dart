import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'app_strings.dart';
import 'app_theme.dart';
import 'lesson_model.dart';
import 'lesson_repository.dart';
import 'lesson_screen.dart';

class LearnTab extends StatefulWidget {
  const LearnTab({super.key});

  @override
  State<LearnTab> createState() => _LearnTabState();
}

class _LearnTabState extends State<LearnTab> {
  int _tabIndex = 0;
  String _level = 'A1';

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<SettingsProvider>().locale;
    final tabLabels = [
      AppStrings.get('lessons', locale),
      AppStrings.get('words', locale),
      AppStrings.get('phrases', locale),
      AppStrings.get('grammar', locale),
    ];
    final levels = ['A1', 'A2', 'B1', 'B2', 'C1'];
    final lessons = LessonRepository.getByLevel(_level);

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(AppStrings.get('learn', locale),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22)),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: tabLabels.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final selected = i == _tabIndex;
                return ChoiceChip(
                  label: Text(tabLabels[i]),
                  selected: selected,
                  onSelected: (_) => setState(() => _tabIndex = i),
                  selectedColor: AppTheme.accentPurple,
                  backgroundColor: AppTheme.surface,
                  labelStyle: TextStyle(
                      color: selected ? Colors.white : AppTheme.textSecondary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: levels.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final selected = levels[i] == _level;
                return ChoiceChip(
                  label: Text(levels[i]),
                  selected: selected,
                  onSelected: (_) => setState(() => _level = levels[i]),
                  selectedColor: AppTheme.accentBlue,
                  backgroundColor: AppTheme.surface,
                  labelStyle: TextStyle(
                      color: selected ? Colors.white : AppTheme.textSecondary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _tabIndex != 0
                ? Center(
                    child: Text(
                      locale == 'ar' ? 'قريبًا' : 'Coming soon',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : lessons.isEmpty
                    ? Center(
                        child: Text(
                          locale == 'ar'
                              ? 'لا توجد دروس لهذا المستوى بعد'
                              : 'No lessons for this level yet',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
                        itemCount: lessons.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final lesson = lessons[i];
                          return _LessonCard(
                            lesson: lesson,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => LessonScreen(lesson: lesson),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final LessonModel lesson;
  final VoidCallback onTap;

  const _LessonCard({required this.lesson, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final minutes = (lesson.durationSeconds / 60).ceil();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.cardDecoration(radius: 20),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lesson.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(lesson.description, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text('$minutes min', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(width: 12),
                      Icon(Icons.category_outlined, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(lesson.category, style: Theme.of(context).textTheme.bodySmall),
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
