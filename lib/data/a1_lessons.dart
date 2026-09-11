import '../lesson_model.dart';

// Placeholder videos for technical playback testing only — not the
// official lesson audio. Real licensed video sources will replace
// these once available.
const String _sampleVideoA = 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
const String _sampleVideoB = 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';

/// Original A1-level example sentences written for EchoSpeak, inspired by
/// (but not copied from) the official British Council LearnEnglish A1
/// topics referenced via [LessonModel.sourceUrl]. No transcript text from
/// those pages is reproduced here.
const List<LessonModel> a1LessonsData = [
  LessonModel(
    id: 'a1_001',
    title: 'Meeting New People',
    level: 'A1',
    category: 'Daily Conversation',
    description: 'Simple greetings for meeting someone for the first time.',
    videoUrl: _sampleVideoA,
    durationSeconds: 12,
    sourceUrl: 'https://learnenglish.britishcouncil.org/free-resources/speaking/a1/meeting-new-people',
    transcript: [
      TranscriptSegment(startTime: 0, endTime: 4, text: 'Hi, my name is Sara.', translation: 'مرحبًا، اسمي سارة.'),
      TranscriptSegment(startTime: 4, endTime: 8, text: 'Nice to meet you, Sara.', translation: 'سعيد بلقائك يا سارة.'),
      TranscriptSegment(startTime: 8, endTime: 12, text: 'Nice to meet you too.', translation: 'سعيدة بلقائك أيضًا.'),
    ],
  ),
  LessonModel(
    id: 'a1_002',
    title: 'Where Are You From?',
    level: 'A1',
    category: 'Daily Conversation',
    description: 'Talking about your country and nationality.',
    videoUrl: _sampleVideoB,
    durationSeconds: 12,
    sourceUrl: 'https://learnenglish.britishcouncil.org/free-resources/speaking/a1/talking-about-where-youre',
    transcript: [
      TranscriptSegment(startTime: 0, endTime: 4, text: 'Where are you from?', translation: 'من أين أنت؟'),
      TranscriptSegment(startTime: 4, endTime: 8, text: 'I am from Egypt.', translation: 'أنا من مصر.'),
      TranscriptSegment(startTime: 8, endTime: 12, text: 'I live in Cairo.', translation: 'أعيش في القاهرة.'),
    ],
  ),
  LessonModel(
    id: 'a1_003',
    title: 'Talking About Family',
    level: 'A1',
    category: 'Daily Conversation',
    description: 'Describing your family members.',
    videoUrl: _sampleVideoA,
    durationSeconds: 12,
    sourceUrl: 'https://learnenglish.britishcouncil.org/free-resources/speaking/a1/talking-about-other-people',
    transcript: [
      TranscriptSegment(startTime: 0, endTime: 4, text: 'This is my brother.', translation: 'هذا أخي.'),
      TranscriptSegment(startTime: 4, endTime: 8, text: 'He is a student.', translation: 'هو طالب.'),
      TranscriptSegment(startTime: 8, endTime: 12, text: 'He is very kind.', translation: 'هو لطيف جدًا.'),
    ],
  ),
  LessonModel(
    id: 'a1_004',
    title: 'Hobbies and Free Time',
    level: 'A1',
    category: 'Daily Conversation',
    description: 'Talking about what you like doing.',
    videoUrl: _sampleVideoB,
    durationSeconds: 12,
    sourceUrl: 'https://learnenglish.britishcouncil.org/free-resources/general/video-series/starting-out/episode-03-what-do-you-doing',
    transcript: [
      TranscriptSegment(startTime: 0, endTime: 4, text: 'What do you like doing?', translation: 'ماذا تحب أن تفعل؟'),
      TranscriptSegment(startTime: 4, endTime: 8, text: 'I like reading books.', translation: 'أحب قراءة الكتب.'),
      TranscriptSegment(startTime: 8, endTime: 12, text: 'I also like cycling.', translation: 'أحب ركوب الدراجة أيضًا.'),
    ],
  ),
  LessonModel(
    id: 'a1_005',
    title: 'Asking for Directions',
    level: 'A1',
    category: 'Travel',
    description: 'Simple phrases for finding your way.',
    videoUrl: _sampleVideoA,
    durationSeconds: 12,
    sourceUrl: 'https://learnenglish.britishcouncil.org/free-resources/general/video-series/starting-out/episode-04-where-are-you',
    transcript: [
      TranscriptSegment(startTime: 0, endTime: 4, text: 'Excuse me, where is the station?', translation: 'عفوًا، أين المحطة؟'),
      TranscriptSegment(startTime: 4, endTime: 8, text: 'It is near the bank.', translation: 'إنها قرب البنك.'),
      TranscriptSegment(startTime: 8, endTime: 12, text: 'Thank you very much.', translation: 'شكرًا جزيلاً لك.'),
    ],
  ),
  LessonModel(
    id: 'a1_006',
    title: 'Shopping for Clothes',
    level: 'A1',
    category: 'Daily Conversation',
    description: 'Basic shopping phrases and clothing words.',
    videoUrl: _sampleVideoB,
    durationSeconds: 12,
    sourceUrl: 'https://learnenglish.britishcouncil.org/free-resources/general/video-series/starting-out/episode-04-where-are-you',
    transcript: [
      TranscriptSegment(startTime: 0, endTime: 4, text: 'I like this shirt.', translation: 'أحب هذا القميص.'),
      TranscriptSegment(startTime: 4, endTime: 8, text: 'How much is it?', translation: 'كم سعره؟'),
      TranscriptSegment(startTime: 8, endTime: 12, text: 'It is ten pounds.', translation: 'سعره عشرة جنيهات.'),
    ],
  ),
  LessonModel(
    id: 'a1_007',
    title: 'At the Restaurant',
    level: 'A1',
    category: 'Daily Conversation',
    description: 'Ordering food and drinks.',
    videoUrl: _sampleVideoA,
    durationSeconds: 12,
    sourceUrl: 'https://learnenglish.britishcouncil.org/free-resources/general/video-series/starting-out/episode-05-speaking-or-eating',
    transcript: [
      TranscriptSegment(startTime: 0, endTime: 4, text: 'Can I see the menu, please?', translation: 'هل يمكنني رؤية قائمة الطعام من فضلك؟'),
      TranscriptSegment(startTime: 4, endTime: 8, text: 'I would like some tea.', translation: 'أريد بعض الشاي.'),
      TranscriptSegment(startTime: 8, endTime: 12, text: 'Anything else?', translation: 'أي شيء آخر؟'),
    ],
  ),
  LessonModel(
    id: 'a1_008',
    title: 'Telling the Time',
    level: 'A1',
    category: 'Daily Conversation',
    description: 'Talking about time and daily schedules.',
    videoUrl: _sampleVideoB,
    durationSeconds: 12,
    sourceUrl: 'https://learnenglish.britishcouncil.org/free-resources/general/video-series/starting-out/episode-11-what-time-it',
    transcript: [
      TranscriptSegment(startTime: 0, endTime: 4, text: 'What time is it?', translation: 'كم الساعة؟'),
      TranscriptSegment(startTime: 4, endTime: 8, text: 'It is nine o\'clock.', translation: 'الساعة التاسعة.'),
      TranscriptSegment(startTime: 8, endTime: 12, text: 'The film starts soon.', translation: 'الفيلم سيبدأ قريبًا.'),
    ],
  ),
  LessonModel(
    id: 'a1_009',
    title: 'Making Suggestions',
    level: 'A1',
    category: 'Daily Conversation',
    description: 'Useful phrases for suggesting an activity.',
    videoUrl: _sampleVideoA,
    durationSeconds: 12,
    sourceUrl: 'https://learnenglish.britishcouncil.org/free-resources/speaking/a1/making-suggestions',
    transcript: [
      TranscriptSegment(startTime: 0, endTime: 4, text: 'Why don\'t we go for a walk?', translation: 'لماذا لا نذهب في نزهة؟'),
      TranscriptSegment(startTime: 4, endTime: 8, text: 'That sounds like a good idea.', translation: 'تبدو فكرة جيدة.'),
      TranscriptSegment(startTime: 8, endTime: 12, text: 'Let\'s go now.', translation: 'لنذهب الآن.'),
    ],
  ),
];
