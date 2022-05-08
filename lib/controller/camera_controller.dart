import 'package:camera/camera.dart';

class CameraInfoController {
  List<CameraDescription> _cameras = [];
  late CameraController controller;
  Future<void> startCamera() async {
    _cameras = await availableCameras();
  }

  CameraDescription? get cameraSelect => _cameras.isEmpty ? null : _cameras[0];

  Future<void> initializeCamera() async {
    if (cameraSelect != null) {
      final CameraController cameraController = CameraController(
        cameraSelect!,
        ResolutionPreset.max,
      );
      controller = cameraController;
    }
  }

  Future<String?> takePicture() async {
    if (!controller.value.isInitialized) {
      print("Controller is not initialized");
      return null;
    }
    String? imagePath;
    if (controller.value.isTakingPicture) {
      print("Processing is progress ...");
      return null;
    }
    try {
      controller.setFlashMode(FlashMode.off);
      final XFile file = await controller.takePicture();
      imagePath = file.path;
    } on CameraException catch (e) {
      print("Camera Exception: $e");
      return null;
    }

    return imagePath;
  }
}
