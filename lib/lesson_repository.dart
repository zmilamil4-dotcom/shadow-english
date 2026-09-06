import 'lesson_model.dart';
import 'lessons_data.dart';

class LessonRepository {
  static List<LessonModel> getAll() => lessonsData;

  static List<LessonModel> getByLevel(String level) {
    return lessonsData.where((lesson) => lesson.level == level).toList();
  }

  static LessonModel? getById(String id) {
    for (final lesson in lessonsData) {
      if (lesson.id == id) return lesson;
    }
    return null;
  }
}
