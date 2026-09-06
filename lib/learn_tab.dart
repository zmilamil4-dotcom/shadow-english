import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import 'app_strings.dart';
import 'app_theme.dart';

class LearnTab extends StatefulWidget {
  const LearnTab({super.key});

  @override
  State<LearnTab> createState() => _LearnTabState();
}

class _LearnTabState extends State<LearnTab> {
  int _tabIndex = 0;
  String _level = 'A1';

  final List<Map<String, dynamic>> _lessons = const [
    {'icon': Icons.eco_rounded, 'color': Color(0xFF22C55E), 'title': 'Beginner', 'subtitle': 'Start your journey', 'done': 12, 'total': 30},
    {'icon': Icons.local_cafe_rounded, 'color': Color(0xFFF59E0B), 'title': 'Daily Life', 'subtitle': 'Common conversations', 'done': 18, 'total': 30},
    {'icon': Icons.flight_rounded, 'color': Color(0xFF3B82F6), 'title': 'Travel', 'subtitle': 'Useful words & phrases', 'done': 14, 'total': 30},
    {'icon': Icons.work_rounded, 'color': Color(0xFF8B5CF6), 'title': 'Business', 'subtitle': 'Professional English', 'done': 10, 'total': 30},
    {'icon': Icons.record_voice_over_rounded, 'color': Color(0xFFEF4444), 'title': 'Pronunciation', 'subtitle': 'Speak like a native', 'done': 15, 'total': 30},
  ];

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
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
              itemCount: _lessons.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final lesson = _lessons[i];
                final progress = lesson['done'] / lesson['total'];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: AppTheme.cardDecoration(radius: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: (lesson['color'] as Color).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(lesson['icon'] as IconData, color: lesson['color'] as Color),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(lesson['title'] as String,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15)),
                            const SizedBox(height: 2),
                            Text(lesson['subtitle'] as String,
                                style: Theme.of(context).textTheme.bodySmall),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: progress.toDouble(),
                                minHeight: 5,
                                backgroundColor: Colors.white12,
                                valueColor: AlwaysStoppedAnimation(lesson['color'] as Color),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${lesson['done']}/${lesson['total']}',
                          style: Theme.of(context).textTheme.bodySmall),
                      const Icon(Icons.chevron_right_rounded, color: Colors.white38),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
