import 'lesson_model.dart';
import 'lessons_data.dart';
import 'data/a1_lessons.dart';
import 'data/youtube_lessons.dart';

class LessonRepository {
  static List<LessonModel> _allLessons() => [
        ...lessonsData,
        ...a1LessonsData,
        ...youtubeLessonsData,
      ];

  static List<LessonModel> getAll() => _allLessons();

  static List<LessonModel> getByLevel(String level) {
    return _allLessons().where((lesson) => lesson.level == level).toList();
  }

  static LessonModel? getById(String id) {
    for (final lesson in _allLessons()) {
      if (lesson.id == id) return lesson;
    }
    return null;
  }
}
