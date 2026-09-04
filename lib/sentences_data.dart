import 'sentence_model.dart';

const List<SentenceModel> sentencesData = [
  // Lesson 1
  SentenceModel(
    id: 1,
    lessonId: 1,
    text: 'Hello, how are you?',
    translations: {
      'ar': 'مرحبًا، كيف حالك؟',
      'fr': 'Bonjour, comment allez-vous ?',
      'es': 'Hola, ¿cómo estás?',
      'de': 'Hallo, wie geht es dir?',
      'it': 'Ciao, come stai?',
      'tr': 'Merhaba, nasılsın?',
      'pt': 'Olá, como você está?',
      'ja': 'こんにちは、お元気ですか？',
      'ko': '안녕하세요, 어떻게 지내세요?',
      'zh': '你好，你好吗？',
    },
  ),

  SentenceModel(
    id: 2,
    lessonId: 1,
    text: 'My name is...',
    translations: {
      'ar': 'اسمي هو...',
      'fr': 'Je m’appelle...',
      'es': 'Me llamo...',
      'de': 'Ich heiße...',
      'it': 'Mi chiamo...',
      'tr': 'Benim adım...',
      'pt': 'Meu nome é...',
      'ja': '私の名前は…です。',
      'ko': '제 이름은 ...입니다.',
      'zh': '我的名字是……',
    },
  ),

  SentenceModel(
    id: 3,
    lessonId: 1,
    text: 'I like learning English.',
    translations: {
      'ar': 'أحب تعلم اللغة الإنجليزية.',
      'fr': 'J’aime apprendre l’anglais.',
      'es': 'Me gusta aprender inglés.',
      'de': 'Ich lerne gerne Englisch.',
      'it': 'Mi piace imparare l’inglese.',
      'tr': 'İngilizce öğrenmeyi seviyorum.',
      'pt': 'Gosto de aprender inglês.',
      'ja': '英語を学ぶのが好きです。',
      'ko': '저는 영어를 배우는 것을 좋아합니다.',
      'zh': '我喜欢学习英语。',
    },
  ),

  // Lesson 2
  SentenceModel(
    id: 4,
    lessonId: 2,
    text: 'What are you doing?',
    translations: {
      'ar': 'ماذا تفعل؟',
      'fr': 'Qu’est-ce que tu fais ?',
      'es': '¿Qué estás haciendo?',
      'de': 'Was machst du?',
      'it': 'Cosa stai facendo?',
      'tr': 'Ne yapıyorsun?',
      'pt': 'O que você está fazendo?',
      'ja': '何をしていますか？',
      'ko': '무엇을 하고 있나요?',
      'zh': '你在做什么？',
    },
  ),

  SentenceModel(
    id: 5,
    lessonId: 2,
    text: 'Have a nice day.',
    translations: {
      'ar': 'أتمنى لك يومًا سعيدًا.',
      'fr': 'Passez une bonne journée.',
      'es': 'Que tengas un buen día.',
      'de': 'Ich wünsche dir einen schönen Tag.',
      'it': 'Buona giornata.',
      'tr': 'İyi günler.',
      'pt': 'Tenha um bom dia.',
      'ja': '良い一日を。',
      'ko': '좋은 하루 보내세요.',
      'zh': '祝你今天愉快。',
    },
  ),
];
