import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'lesson_model.dart';
import 'recorder_service.dart';
import 'pronunciation_service.dart';
import 'tts_service.dart';
import 'word_details_sheet.dart';
import 'app_theme.dart';
import 'widgets/echo_background.dart';
import 'widgets/glass_card.dart';

enum _VideoState { loading, ready, error }

class LessonScreen extends StatefulWidget {
  final LessonModel lesson;
  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  VideoPlayerController? _controller;
  _VideoState _videoState = _VideoState.loading;
  String _videoErrorMessage = '';

  final RecorderService _recorder = RecorderService();
  final PronunciationService _pronunciationService = PronunciationService();
  final TtsService _tts = TtsService();

  int _currentSegmentIndex = 0;
  bool _isRecording = false;
  String? _lastRecordingPath;
  String? _recorderError;
  String? _evaluationMessage;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    final controller = VideoPlayerController.networkUrl(Uri.parse(widget.lesson.videoUrl));
    _controller = controller;
    controller.addListener(_onVideoTick);
    try {
      await controller.initialize().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Video took too long to load.');
        },
      );
      if (!mounted) return;
      setState(() => _videoState = _VideoState.ready);
    } on TimeoutException {
      if (!mounted) return;
      setState(() {
        _videoState = _VideoState.error;
        _videoErrorMessage = 'The video took too long to load. Check your internet connection and try again.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _videoState = _VideoState.error;
        _videoErrorMessage = 'Could not load the video. Check your internet connection and try again.';
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoTick);
    _controller?.dispose();
    _recorder.dispose();
    super.dispose();
  }

  void _onVideoTick() {
    final controller = _controller;
    if (controller == null || _videoState != _VideoState.ready) return;
    if (controller.value.hasError) {
      setState(() {
        _videoState = _VideoState.error;
        _videoErrorMessage = 'Playback error. Please try again.';
      });
      return;
    }
    final positionSeconds = controller.value.position.inMilliseconds / 1000.0;
    final segments = widget.lesson.transcript;
    for (int i = 0; i < segments.length; i++) {
      if (positionSeconds >= segments[i].startTime && positionSeconds < segments[i].endTime) {
        if (_currentSegmentIndex != i) {
          setState(() => _currentSegmentIndex = i);
        }
        break;
      }
    }
  }

  Future<void> _retryVideo() async {
    setState(() => _videoState = _VideoState.loading);
    await _controller?.dispose();
    await _initVideo();
  }

  void _togglePlay() {
    final controller = _controller;
    if (controller == null || _videoState != _VideoState.ready) return;
    setState(() {
      if (controller.value.isPlaying) {
        controller.pause();
      } else {
        controller.play();
      }
    });
  }

  void _seekToSegment(int index) {
    final controller = _controller;
    if (controller == null || _videoState != _VideoState.ready) return;
    final segment = widget.lesson.transcript[index];
    controller.seekTo(Duration(milliseconds: (segment.startTime * 1000).round()));
    controller.play();
    setState(() => _currentSegmentIndex = index);
  }

  void _onWordTap(String word) {
    final clean = word.replaceAll(RegExp(r'[^\w]'), '');
    showWordDetailsSheet(context, word: clean.isEmpty ? word : clean, tts: _tts);
  }

  Future<void> _onRecordPressed() async {
    if (_isRecording) {
      final result = await _recorder.stop();
      if (!mounted) return;
      setState(() {
        _isRecording = false;
        if (result.success) {
          _lastRecordingPath = result.filePath;
          _recorderError = null;
        } else {
          _recorderError = result.errorMessage;
          _lastRecordingPath = null;
        }
      });
      if (result.success) {
        _runEvaluation();
      }
      return;
    }

    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      if (!mounted) return;
      _showPermissionDialog();
      return;
    }

    setState(() {
      _evaluationMessage = null;
      _recorderError = null;
    });

    final result = await _recorder.start();
    if (!mounted) return;
    setState(() {
      _isRecording = result.success;
      if (!result.success) _recorderError = result.errorMessage;
    });
  }

  Future<void> _runEvaluation() async {
    final path = _lastRecordingPath;
    if (path == null) return;
    final segment = widget.lesson.transcript[_currentSegmentIndex];
    try {
      final result = await _pronunciationService.evaluate(
        audioFilePath: path,
        expectedText: segment.text,
      );
      if (!mounted) return;
      setState(() => _evaluationMessage = result.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _evaluationMessage = 'Evaluation is currently unavailable.');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Microphone permission needed'),
        content: const Text('Please allow microphone access from your device settings.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final segments = widget.lesson.transcript;
    final currentSegment = segments[_currentSegmentIndex];
    final words = currentSegment.text.split(' ');

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: Text(widget.lesson.title),
      ),
      body: EchoBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.black),
                clipBehavior: Clip.hardEdge,
                child: _buildVideoArea(),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Demo video for playback testing only — not English-learning audio.',
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
            if (widget.lesson.sourceUrl != null) ...[
              const SizedBox(height: 4),
              Text(
                'Topic inspired by: ${widget.lesson.sourceUrl}',
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
            const SizedBox(height: 20),
            GlassCard(
              radius: AppRadius.xl,
              gradient: AppTheme.primaryGradient,
              glow: true,
              padding: const EdgeInsets.all(20),
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
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(w,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Text(currentSegment.translation, style: const TextStyle(color: Colors.white70, fontSize: 15)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CircleButton(
                  icon: Icons.replay_rounded,
                  gradient: AppTheme.primaryGradient,
                  size: 56,
                  onTap: () => _seekToSegment(_currentSegmentIndex),
                ),
                const SizedBox(width: 24),
                _CircleButton(
                  icon: _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                  gradient: _isRecording
                      ? const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFF59E0B)])
                      : AppTheme.pinkGradient,
                  size: 78,
                  onTap: _onRecordPressed,
                ),
              ],
            ),
            if (_isRecording) ...[
              const SizedBox(height: 12),
              const Center(child: Text('Recording...', style: TextStyle(color: Colors.white70))),
            ],
            if (_recorderError != null) ...[
              const SizedBox(height: 16),
              GlassCard(
                radius: AppRadius.md,
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, color: Colors.redAccent),
                    const SizedBox(width: 10),
                    Expanded(child: Text(_recorderError!)),
                  ],
                ),
              ),
            ],
            if (_lastRecordingPath != null && _recorderError == null) ...[
              const SizedBox(height: 16),
              GlassCard(
                radius: AppRadius.md,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle_rounded, color: AppTheme.success),
                        SizedBox(width: 10),
                        Expanded(child: Text('Recording saved successfully.')),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(_evaluationMessage ?? 'Evaluation coming soon.',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _lastRecordingPath = null;
                            _evaluationMessage = null;
                          });
                        },
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('Record again'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 28),
            const Text('Transcript', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ...List.generate(segments.length, (i) {
              final segment = segments[i];
              final isActive = i == _currentSegmentIndex;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () => _seekToSegment(i),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isActive ? AppTheme.accentPurple.withValues(alpha: 0.2) : AppTheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: isActive ? Border.all(color: AppTheme.accentPurple, width: 1.2) : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(segment.text,
                            style: TextStyle(
                                color: isActive ? Colors.white : AppTheme.textSecondary,
                                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal)),
                        const SizedBox(height: 4),
                        Text(segment.translation,
                            style: TextStyle(
                                color: isActive ? Colors.white70 : AppTheme.textSecondary.withValues(alpha: 0.7),
                                fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoArea() {
    switch (_videoState) {
      case _VideoState.loading:
        return const Center(child: CircularProgressIndicator(color: Colors.white70));
      case _VideoState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off_rounded, color: Colors.white54, size: 40),
                const SizedBox(height: 10),
                Text(_videoErrorMessage,
                    textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: _retryVideo,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      case _VideoState.ready:
        final controller = _controller!;
        return GestureDetector(
          onTap: _togglePlay,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              VideoPlayer(controller),
              if (!controller.value.isPlaying)
                const Icon(Icons.play_circle_fill_rounded, color: Colors.white70, size: 56),
            ],
          ),
        );
    }
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final LinearGradient gradient;
  final double size;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.gradient, required this.size, required this.onTap});

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
          boxShadow: [BoxShadow(color: AppTheme.accentPurple.withValues(alpha: 0.4), blurRadius: 18, spreadRadius: 1)],
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.42),
      ),
    );
  }
}
