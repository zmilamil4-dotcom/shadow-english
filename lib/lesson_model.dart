class TranscriptSegment {
  final double startTime; // seconds
  final double endTime; // seconds
  final String text; // English text
  final String translation; // Arabic translation

  const TranscriptSegment({
    required this.startTime,
    required this.endTime,
    required this.text,
    required this.translation,
  });
}

class LessonModel {
  final String id;
  final String title;
  final String level; // A1, A2, B1, B2, C1
  final String category;
  final String description;
  final String videoUrl;
  final int durationSeconds;
  final String? thumbnailUrl;
  final String? sourceUrl; // reference/inspiration source, not embedded content
  final List<TranscriptSegment> transcript;

  const LessonModel({
    required this.id,
    required this.title,
    required this.level,
    required this.category,
    required this.description,
    required this.videoUrl,
    required this.durationSeconds,
    this.thumbnailUrl,
    this.sourceUrl,
    required this.transcript,
  });
}
