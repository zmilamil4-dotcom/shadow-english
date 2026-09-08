class PronunciationEvaluationResult {
  final bool isAvailable;
  final String message;

  const PronunciationEvaluationResult({required this.isAvailable, required this.message});
}

class PronunciationService {
  /// Placeholder for a future real pronunciation-analysis / AI integration.
  /// Never throws; always returns a safe result even if the future service
  /// is unavailable, has no API key, no quota, or no network (AI-01).
  Future<PronunciationEvaluationResult> evaluate({
    required String audioFilePath,
    required String expectedText,
  }) async {
    try {
      // TODO: call a real pronunciation-analysis API here in the future.
      return const PronunciationEvaluationResult(
        isAvailable: false,
        message: 'Evaluation coming soon.',
      );
    } catch (_) {
      return const PronunciationEvaluationResult(
        isAvailable: false,
        message: 'Evaluation is currently unavailable.',
      );
    }
  }
}
