import 'package:camera/camera.dart';

class CameraCaptureResult {
  final bool success;
  final String? imagePath;
  final String? errorMessage;

  const CameraCaptureResult({required this.success, this.imagePath, this.errorMessage});
}

class CameraTextService {
  CameraController? _controller;

  CameraController? get controller => _controller;

  Future<bool> initialize() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return false;
      _controller = CameraController(cameras.first, ResolutionPreset.medium, enableAudio: false);
      await _controller!.initialize();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<CameraCaptureResult> capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const CameraCaptureResult(success: false, errorMessage: 'Camera is not ready.');
    }
    try {
      final file = await controller.takePicture();
      return CameraCaptureResult(success: true, imagePath: file.path);
    } catch (e) {
      return CameraCaptureResult(success: false, errorMessage: 'Could not capture photo: $e');
    }
  }

  Future<void> dispose() async {
    try {
      await _controller?.dispose();
    } catch (_) {}
  }
}
