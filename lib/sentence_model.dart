class SentenceModel {
  final int id;
  final int lessonId;
  final String text;

  // Translations by language code.
  // Example: ar = Arabic, fr = French, es = Spanish.
  final Map<String, String> translations;

  const SentenceModel({
    required this.id,
    required this.lessonId,
    required this.text,
    required this.translations,
  });

  String getTranslation(String languageCode) {
    return translations[languageCode] ?? translations['en'] ?? text;
  }
}
