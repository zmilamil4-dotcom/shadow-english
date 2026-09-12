import '../lesson_model.dart';
import '../video_source.dart';

/// Real long-form video lessons hosted on YouTube (official channels).
/// The video is embedded via YouTube's own player — not downloaded or
/// copied — in line with YouTube's terms for embedding.
const List<LessonModel> youtubeLessonsData = [
  LessonModel(
    id: 'yt_001',
    title: 'Introduce Yourself at Work',
    level: 'B1',
    category: 'Work',
    description: 'A real BBC Learning English video about introducing yourself to new colleagues.',
    videoUrl: '', // unused — videoSource below takes priority
    videoSource: VideoSource.youtube('1AmS9h8g3E4'),
    durationSeconds: 240,
    sourceUrl: 'https://www.youtube.com/watch?v=1AmS9h8g3E4',
    transcript: [
      TranscriptSegment(
        startTime: 0,
        endTime: 240,
        text: 'Transcript not yet available for this video.',
        translation: 'النص النصي غير متوفر بعد لهذا الفيديو.',
      ),
    ],
  ),
];
