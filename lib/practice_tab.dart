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

  Future<void> _onSpeakPressed(BuildContext context) async {
    if (_isRecording) {
      final result = await _recorder.stop();
      _stopWaveAnimation();
      if (!mounted) return;
      setState(() {
        _isRecording = false;
        if (result.success) {
          _showResult = true;
        }
      });
      if (result.success) {
        context.read<AppStateProvider>().recordCompleted();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.errorMessage ?? 'Recording failed.')),
        );
      }
      return;
    }

    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      if (!mounted) return;
      _showPermissionDialog(context);
      return;
    }

    setState(() {
      _showResult = false;
    });
    _startWaveAnimation();

    final result = await _recorder.start();
    if (!mounted) return;
    setState(() => _isRecording = result.success);
    if (!result.success) {
      _stopWaveAnimation();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage ?? 'Could not start recording.')),
      );
    }
  }

  void _showPermissionDialog(BuildContext context) {
    final locale = context.read<SettingsProvider>().locale;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(AppStrings.get('mic_perm
