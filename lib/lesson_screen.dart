import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'lesson_model.dart';
import 'recorder_service.dart';
import 'app_theme.dart';

class LessonScreen extends StatefulWidget {
  final LessonModel lesson;
  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late VideoPlayerController _controller;
  final RecorderService _recorder = RecorderService();
  bool _videoReady = false;
  int _currentSegmentIndex = 0;
  bool _isRecording = false;
  bool _showRecordedNotice = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.lesson.videoUrl))
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _videoReady = true);
      });
    _controller.addListener(_onVideoTick);
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoTick);
    _controller.dispose();
    _recorder.dispose();
    super.dispose();
  }

  void _onVideoTick() {
    if (!_videoReady) return;
    final positionSeconds = _controller.value.position.inMilliseconds / 1000.0;
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

  void _togglePlay() {
    if (!_videoReady) return;
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _seekToSegment(int index) {
    if (!_videoReady) return;
    final segment = widget.lesson.transcript[index];
    _controller.seekTo(Duration(milliseconds: (segment.startTime * 1000).round()));
    _controller.play();
    setState(() => _currentSegmentIndex = index);
  }

  void _onWordTap(String word) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(word), duration: const Duration(seconds: 1)),
    );
  }

  Future<void> _onRecordPressed() async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      if (!mounted) return;
      _showPermissionDialog();
      return;
    }
    if (!_isRecording) {
      await _recorder.start();
      setState(() {
        _isRecording = true;
        _showRecordedNotice = false;
      });
    } else {
      await _recorder.stop();
      setState(() {
        _isRecording = false;
        _showRecordedNotice = true;
      });
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black,
              ),
              clipBehavior: Clip.hardEdge,
              child: _videoReady
                  ? GestureDetector(
                      onTap: _togglePlay,
                      child: Stack(
                        alignment: Alignment.center,
                        fit: StackFit.expand,
                        children: [
                          VideoPlayer(_controller),
                          if (!_controller.value.isPlaying)
                            const Icon(Icons.play_circle_fill_rounded,
                                color: Colors.white70, size: 56),
                        ],
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(color: Colors.white70),
                    ),
            ),
          ),
          const SizedBox(height: 20),

          // Current segment card (highlighted)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.glowDecoration(gradient: AppTheme.primaryGradient, radius: 20),
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
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(w,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Text(currentSegment.translation,
                    style: const TextStyle(color: Colors.white70, fontSize: 15)),
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

          if (_showRecordedNotice) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.cardDecoration(radius: 16),
              child: const Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: AppTheme.success),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text('Recording saved. Pronunciation evaluation coming soon.'),
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
                    color: isActive ? AppTheme.accentPurple.withOpacity(0.2) : AppTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: isActive
                        ? Border.all(color: AppTheme.accentPurple, width: 1.2)
                        : null,
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
                              color: isActive
                                  ? Colors.white70
                                  : AppTheme.textSecondary.withOpacity(0.7),
                              fontSize: 13)),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final LinearGradient gradient;
  final double size;
  final VoidCallback onTap;

  const _CircleButton({
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
