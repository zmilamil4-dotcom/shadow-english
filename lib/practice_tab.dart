import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'sentences_data.dart';
import 'recorder_service.dart';
import 'tts_service.dart';
import 'app_state_provider.dart';
import 'settings_provider.dart';
import 'app_strings.dart';
import 'primary_button.dart';

class PracticeTab extends StatefulWidget {
  const PracticeTab({super.key});

  @override
  State<PracticeTab> createState() => _PracticeTabState();
}

class _PracticeTabState extends State<PracticeTab> {
  final TtsService _tts = TtsService();
  final RecorderService _recorder = RecorderService();
  bool _isRecording = false;

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _onSpeakPressed(BuildContext context) async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      if (!mounted) return;
      _showPermissionDialog(context);
      return;
    }
    if (!_isRecording) {
      await _recorder.start();
      setState(() => _isRecording = true);
    } else {
      await _recorder.stop();
      setState(() => _isRecording = false);
      if (!mounted) return;
      context.read<AppStateProvider>().completeRecording();
    }
  }

  void _showPermissionDialog(BuildContext context) {
    final locale = context.read<SettingsProvider>().locale;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppStrings.get('mic_permission_title', locale)),
        content: Text(AppStrings.get('mic_permission_body', locale)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppStrings.get('ok', locale))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text(AppStrings.get('open_settings', locale)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<SettingsProvider>().locale;
    final soundEnabled = context.watch<SettingsProvider>().soundEnabled;
    final sentenceIndex = context.watch<AppStateProvider>().sentenceIndex;
    final sentence = sentencesData[sentenceIndex % sentencesData.length];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(sentence.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: AppStrings.get('listen', locale),
              icon: Icons.volume_up,
              onPressed: soundEnabled ? () => _tts.speak(sentence.text) : () {},
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: _isRecording ? AppStrings.get('stop', locale) : AppStrings.get('speak', locale),
              icon: _isRecording ? Icons.stop_circle : Icons.mic,
              color: _isRecording ? Colors.redAccent : null,
              onPressed: () => _onSpeakPressed(context),
            ),
          ],
        ),
      ),
    );
  }
}
