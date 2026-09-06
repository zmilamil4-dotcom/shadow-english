import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'sentences_data.dart';
import 'recorder_service.dart';
import 'tts_service.dart';
import 'app_state_provider.dart';
import 'settings_provider.dart';
import 'app_strings.dart';
import 'app_theme.dart';

class PracticeTab extends StatefulWidget {
  const PracticeTab({super.key});

  @override
  State<PracticeTab> createState() => _PracticeTabState();
}

class _PracticeTabState extends State<PracticeTab> {
  final TtsService _tts = TtsService();
  final RecorderService _recorder = RecorderService();
  final Random _random = Random();

  bool _isRecording = false;
  bool _showResult = false;
  Timer? _waveTimer;
  List<double> _waveHeights = List.filled(24, 6);

  @override
  void dispose() {
    _waveTimer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  void _startWaveAnimation() {
    _waveTimer = Timer.periodic(const Duration(milliseconds: 150), (_) {
      setState(() {
        _waveHeights = List.generate(24, (_) => 6 + _random.nextDouble() * 26);
      });
    });
  }

  void _stopWaveAnimation() {
    _waveTimer?.cancel();
    setState(() {
      _waveHeights = List.filled(24, 6);
    });
  }

  Future<void> _onRecordPressed(BuildContext context) async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      if (!mounted) return;
      _showPermissionDialog(context);
      return;
    }
    if (!_isRecording) {
      setState(() {
        _isRecording = true;
        _showResult = false;
      });
      _startWaveAnimation();
      await _recorder.start();
    } else {
      await _recorder.stop();
      _stopWaveAnimation();
      setState(() {
        _isRecording = false;
        _showResult = true;
      });
      if (!mounted) return;
      context.read<AppStateProvider>().recordCompleted();
    }
  }

  void _showPermissionDialog(BuildContext context) {
    final locale = context.read<SettingsProvider>().locale;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
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

  void _onWordTap(String word) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(word), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<SettingsProvider>().locale;
    final soundEnabled = context.watch<SettingsProvider>().soundEnabled;
    final appState = context.watch<AppStateProvider>();
    final sentence = sentencesData[appState.sentenceIndex % sentencesData.length];
    final words = sentence.text.split(' ');

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
        children: [
          Text(AppStrings.get('speaking_practice', locale),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22)),
          const SizedBox(height: 4),
          Text(AppStrings.get('repeat_sentence', locale),
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),

          // Video placeholder
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: AppTheme.glowDecoration(gradient: AppTheme.pinkGradient, radius: 20),
              child: const Center(
                child: Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 56),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Sentence card with tappable words
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 8,
                  children: words.map((w) {
                    return GestureDetector(
                      onTap: () => _onWordTap(w),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(w,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Text('/ ˈɪ.pʰə pleɪsˈhoʊldər /',
                    style: TextStyle(color: AppTheme.textSecondary, fontStyle: FontStyle.italic)),
                const SizedBox(height: 4),
                Text(AppStrings.get('tap_word_hint', locale),
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Waveform
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: AppTheme.cardDecoration(radius: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _waveHeights.map((h) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: 4,
                  height: h,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              _isRecording ? AppStrings.get('recording', locale) : AppStrings.get('tap_to_record', locale),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CircleActionButton(
                icon: Icons.volume_up_rounded,
                gradient: AppTheme.primaryGradient,
                size: 56,
                onTap: soundEnabled ? () => _tts.speak(sentence.text) : () {},
              ),
              const SizedBox(width: 24),
              _CircleActionButton(
                icon: _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                gradient: _isRecording
                    ? const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFF59E0B)])
                    : AppTheme.pinkGradient,
                size: 78,
                onTap: () => _onRecordPressed(context),
              ),
            ],
          ),

          if (_showResult) ...[
            const SizedBox(height: 24),
            _ResultCard(locale: locale),
          ],

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  appState.previousSentence(sentencesData.length);
                  setState(() => _showResult = false);
                },
                icon: const Icon(Icons.arrow_back_ios_rounded, size: 16),
                label: Text(AppStrings.get('previous', locale)),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  appState.nextSentence(sentencesData.length);
                  setState(() => _showResult = false);
                },
                icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                label: Text(AppStrings.get('next', locale)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final LinearGradient gradient;
  final double size;
  final VoidCallback onTap;

  const _CircleActionButton({
    required this.icon,
    required this.gradient,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: gradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: AppTheme.accentPurple.withOpacity(0.4), blurRadius: 18, spreadRadius: 1),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.42),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String locale;
  const _ResultCard({required this.locale});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircularProgressIndicator(
                      value: 0.85,
                      strokeWidth: 6,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation(AppTheme.success),
                    ),
                    const Text('85%', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.get('good_job', locale),
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(AppStrings.get('recording_saved', locale),
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _MetricRow(label: AppStrings.get('pronunciation', locale), value: 0.9),
          const SizedBox(height: 8),
          _MetricRow(label: AppStrings.get('fluency', locale), value: 0.8),
          const SizedBox(height: 8),
          _MetricRow(label: AppStrings.get('completeness', locale), value: 0.85),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final double value;
  const _MetricRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 110, child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation(AppTheme.accentBlue),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text('${(value * 100).round()}%', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
