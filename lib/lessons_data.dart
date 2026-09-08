import 'lesson_model.dart';

// Placeholder videos: Creative Commons sample videos (Blender Foundation),
// safe to use as legal placeholders until real content is added.
const String _sampleVideo1 =
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4';
const String _sampleVideo2 =
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4';

const List<LessonModel> lessonsData = [
  LessonModel(
    id: 'l001',
    title: 'Saying Hello',
    level: 'A1',
    category: 'Daily Conversation',
    description: 'Learn simple greetings used every day.',
    videoUrl: _sampleVideo1,
    durationSeconds: 12,
    transcript: [
      TranscriptSegment(
        startTime: 0,
        endTime: 4,
        text: 'Hello, how are you today?',
        translation: 'مرحبًا، كيف حالك اليوم؟',
      ),
      TranscriptSegment(
        startTime: 4,
        endTime: 8,
        text: 'I am fine, thank you.',
        translation: 'أنا بخير، شكرًا لك.',
      ),
      TranscriptSegment(
        startTime: 8,
        endTime: 12,
        text: 'Nice to meet you.',
        translation: 'سعيد بلقائك.',
      ),
    ],
  ),
  LessonModel(
    id: 'l002',
    title: 'At the Coffee Shop',
    level: 'A2',
    category: 'Daily Conversation',
    description: 'Order a drink and make small talk.',
    videoUrl: _sampleVideo1,
    durationSeconds: 12,
    transcript: [
      TranscriptSegment(
        startTime: 0,
        endTime: 4,
        text: 'Can I get a coffee, please?',
        translation: 'هل يمكنني الحصول على قهوة من فضلك؟',
      ),
      TranscriptSegment(
        startTime: 4,
        endTime: 8,
        text: 'Sure, what size would you like?',
        translation: 'بالتأكيد، أي حجم تريد؟',
      ),
      TranscriptSegment(
        startTime: 8,
        endTime: 12,
        text: 'A medium one, please.',
        translation: 'حجم متوسط من فضلك.',
      ),
    ],
  ),
  LessonModel(
    id: 'l003',
    title: 'Planning a Trip',
    level: 'B1',
    category: 'Travel',
    description: 'Talk about travel plans and destinations.',
    videoUrl: _sampleVideo2,
    durationSeconds: 12,
    transcript: [
      TranscriptSegment(
        startTime: 0,
        endTime: 4,
        text: 'Where are you going for vacation?',
        translation: 'إلى أين ستذهب في الإجازة؟',
      ),
      TranscriptSegment(
        startTime: 4,
        endTime: 8,
        text: 'I am thinking about visiting Turkey.',
        translation: 'أفكر في زيارة تركيا.',
      ),
      TranscriptSegment(
        startTime: 8,
        endTime: 12,
        text: 'That sounds like a great idea.',
        translation: 'تبدو فكرة رائعة.',
      ),
    ],
  ),
  LessonModel(
    id: 'l004',
    title: 'A Job Interview',
    level: 'B2',
    category: 'Work',
    description: 'Common questions and answers in interviews.',
    videoUrl: _sampleVideo2,
    durationSeconds: 12,
    transcript: [
      TranscriptSegment(
        startTime: 0,
        endTime: 4,
        text: 'Tell me about your previous experience.',
        translation: 'أخبرني عن خبرتك السابقة.',
      ),
      TranscriptSegment(
        startTime: 4,
        endTime: 8,
        text: 'I worked as a developer for three years.',
        translation: 'عملت كمطوّر لمدة ثلاث سنوات.',
      ),
      TranscriptSegment(
        startTime: 8,
        endTime: 12,
        text: 'That is very impressive.',
        translation: 'هذا مثير للإعجاب حقًا.',
      ),
    ],
  ),
  LessonModel(
    id: 'l005',
    title: 'Discussing Technology',
    level: 'C1',
    category: 'Technology',
    description: 'Advanced vocabulary about modern technology.',
    videoUrl: _sampleVideo1,
    durationSeconds: 12,
    transcript: [
      TranscriptSegment(
        startTime: 0,
        endTime: 4,
        text: 'Artificial intelligence is changing our lives.',
        translation: 'الذكاء الاصطناعي يغيّر حياتنا.',
      ),
      TranscriptSegment(
        startTime: 4,
        endTime: 8,
        text: 'It brings both opportunities and challenges.',
        translation: 'إنه يجلب فرصًا وتحديات في آنٍ واحد.',
      ),
      TranscriptSegment(
        startTime: 8,
        endTime: 12,
        text: 'We must use it responsibly.',
        translation: 'يجب أن نستخدمه بمسؤولية.',
      ),
    ],
  ),
];
