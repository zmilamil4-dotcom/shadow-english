import 'dart:io';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class RecorderResult {
  final bool success;
  final String? filePath;
  final String? errorMessage;

  const RecorderResult({required this.success, this.filePath, this.errorMessage});
}

class RecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;

  bool get isRecording => _isRecording;

  Future<bool> hasPermission() async {
    try {
      return await _recorder.hasPermission();
    } catch (_) {
      return false;
    }
  }

  Future<RecorderResult> start() async {
    if (_isRecording) {
      return const RecorderResult(success: false, errorMessage: 'Already recording.');
    }
    try {
      final hasPerm = await hasPermission();
      if (!hasPerm) {
        return const RecorderResult(success: false, errorMessage: 'Microphone permission denied.');
      }
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/echo_speak_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorder.start(const RecordConfig(), path: path);
      _isRecording = true;
      return RecorderResult(success: true, filePath: path);
    } catch (e) {
      _isRecording = false;
      return RecorderResult(success: false, errorMessage: 'Failed to start recording: $e');
    }
  }

  Future<RecorderResult> stop() async {
    if (!_isRecording) {
      return const RecorderResult(success: false, errorMessage: 'Not recording.');
    }
    try {
      final path = await _recorder.stop();
      _isRecording = false;
      if (path == null) {
        return const RecorderResult(success: false, errorMessage: 'Recording did not produce a file.');
      }
      final file = File(path);
      final exists = await file.exists();
      if (!exists) {
        return const RecorderResult(success: false, errorMessage: 'Recorded file was not found.');
      }
      final size = await file.length();
      if (size <= 0) {
        return const RecorderResult(success: false, errorMessage: 'Recorded file is empty.');
      }
      return RecorderResult(success: true, filePath: path);
    } catch (e) {
      _isRecording = false;
      return RecorderResult(success: false, errorMessage: 'Failed to stop recording: $e');
    }
  }

  Future<void> dispose() async {
    try {
      await _recorder.dispose();
    } catch (_) {}
  }
}
