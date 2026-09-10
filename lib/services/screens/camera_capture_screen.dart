import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/camera_text_service.dart';
import '../services/ocr_service.dart';
import '../tts_service.dart';
import '../word_details_sheet.dart';
import '../app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/glow_button.dart';

enum _ScanState { initializing, cameraError, ready, processing, result }

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  final CameraTextService _cameraService = CameraTextService();
  final OcrService _ocrService = OcrService();
  final TtsService _tts = TtsService();

  _ScanState _state = _ScanState.initializing;
  String _errorMessage = '';
  String _extractedText = '';

  @override
  void initState() {
    super.initState();
    _setup();
  }

  Future<void> _setup() async {
    setState(() => _state = _ScanState.initializing);
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (!mounted) return;
      setState(() {
        _state = _ScanState.cameraError;
        _errorMessage = 'Camera permission denied. Please allow it from your device settings.';
      });
      return;
    }
    final ok = await _cameraService.initialize();
    if (!mounted) return;
    if (!ok) {
      setState(() {
        _state = _ScanState.cameraError;
        _errorMessage = 'Could not access the camera on this device.';
      });
      return;
    }
    setState(() => _state = _ScanState.ready);
  }

  Future<void> _capture() async {
    setState(() => _state = _ScanState.processing);
    final captureResult = await _cameraService.capture();
    if (!captureResult.success || captureResult.imagePath == null) {
      if (!mounted) return;
      setState(() {
        _state = _ScanState.cameraError;
        _errorMessage = captureResult.errorMessage ?? 'Capture failed.';
      });
      return;
    }
    final ocrResult = await _ocrService.recognizeFromImage(captureResult.imagePath!);
    if (!mounted) return;
    if (!ocrResult.success) {
      setState(() => _state = _ScanState.ready);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ocrResult.errorMessage ?? 'No text detected.')),
      );
      return;
    }
    setState(() {
      _extractedText = ocrResult.text;
      _state = _ScanState.result;
    });
  }

  void _retake() {
    setState(() {
      _extractedText = '';
      _state = _ScanState.ready;
    });
  }

  void _onWordTap(String word) {
    final clean = word.replaceAll(RegExp(r'[^\w]'), '');
    showWordDetailsSheet(context, word: clean.isEmpty ? word : clean, tts: _tts);
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _ocrService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: const Text('Scan Text'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case _ScanState.initializing:
      case _ScanState.processing:
        return const Center(child: CircularProgressIndicator(color: Colors.white70));

      case _ScanState.cameraError:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.camera_alt_outlined, color: Colors.white54, size: 40),
                const SizedBox(height: 12),
                Text(_errorMessage, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 16),
                GlowButton(label: 'Retry', icon: Icons.refresh_rounded, onTap: _setup),
              ],
            ),
          ),
        );

      case _ScanState.ready:
        final controller = _cameraService.controller;
        if (controller == null) {
          return const Center(child: CircularProgressIndicator(color: Colors.white70));
        }
        return Stack(
          fit: StackFit.expand,
          children: [
            CameraPreview(controller),
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _capture,
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentPurple.withValues(alpha: 0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 32),
                  ),
                ),
              ),
            ),
          ],
        );

      case _ScanState.result:
        final words = _extractedText.split(RegExp(r'\s+'));
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              GlassCard(
                radius: AppRadius.lg,
                child: Wrap(
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
                        child: Text(w, style: const TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              GlowButton(label: 'Scan Again', icon: Icons.camera_alt_rounded, onTap: _retake),
            ],
          ),
        );
    }
  }
}
