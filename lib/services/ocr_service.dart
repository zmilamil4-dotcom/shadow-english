import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrResult {
  final bool success;
  final String text;
  final String? errorMessage;

  const OcrResult({required this.success, required this.text, this.errorMessage});
}

/// On-device OCR — no internet, no API key, no cloud AI service.
class OcrService {
  final TextRecognizer _recognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<OcrResult> recognizeFromImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _recognizer.processImage(inputImage);
      final text = recognizedText.text.trim();
      if (text.isEmpty) {
        return const OcrResult(
          success: false,
          text: '',
          errorMessage: 'No text detected. Try again with a clearer photo.',
        );
      }
      return OcrResult(success: true, text: text);
    } catch (e) {
      return OcrResult(success: false, text: '', errorMessage: 'Text recognition failed: $e');
    }
  }

  Future<void> dispose() async {
    try {
      await _recognizer.close();
    } catch (_) {}
  }
}
