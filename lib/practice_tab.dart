import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'lesson_model.dart';
import 'lesson_repository.dart';
import 'lesson_screen.dart';
import 'app_theme.dart';
import 'widgets/glass_card.dart';

class PracticeTab extends StatelessWidget {
  const PracticeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<SettingsProvider>().locale;
    final lessons = LessonRepository.getAll();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
        children: [
          Text(
            locale == 'ar' ? 'التدريب' : 'Practice',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 6),
          Text(
            locale == 'ar'
                ? 'اختر درسًا للتدرّب على الاستماع والقراءة والتحدث والكتابة معًا.'
                : 'Pick a lesson to practice Listening, Reading, Speaking and Writing together.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          ...lessons.map((lesson) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _PracticeLessonCard(
                  lesson: lesson,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => LessonScreen(lesson: lesson)),
                    );
                  },
                ),
              )),
        ],
      ),
    );
  }
}

class _PracticeLessonCard extends StatelessWidget {
  final LessonModel lesson;
  final VoidCallback onTap;

  const _PracticeLessonCard({required this.lesson, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lesson.title, style: AppTextStyles.title.copyWith(fontSize: 15)),
                  const SizedBox(height: 2),
                  Text('${lesson.level} • ${lesson.category}', style: AppTextStyles.caption),
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
