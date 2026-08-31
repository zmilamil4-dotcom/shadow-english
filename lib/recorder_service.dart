import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class RecorderService {
  final AudioRecorder _recorder = AudioRecorder();

  Future<bool> hasPermission() => _recorder.hasPermission();

  Future<void> start() async {
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/echo_speak_record.m4a';
    await _recorder.start(const RecordConfig(), path: path);
  }

  Future<String?> stop() async {
    return await _recorder.stop();
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }
}
