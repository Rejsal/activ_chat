import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraProvider with ChangeNotifier {
  List<CameraDescription> _cameras = [];
  int _cameraIndex = 0;
  final CameraLensDirection _initialDirection = CameraLensDirection.back;
  String _recognizedText = "";

  List<CameraDescription> get cameras => _cameras;
  int get cameraIndex => _cameraIndex;
  CameraLensDirection get initialDirection => _initialDirection;
  String get recognizedText => _recognizedText;

  Future<void> loadCameras() async {
    _cameras = await availableCameras();

    if (cameras.any(
      (element) =>
          element.lensDirection == _initialDirection &&
          element.sensorOrientation == 90,
    )) {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere((element) =>
            element.lensDirection == _initialDirection &&
            element.sensorOrientation == 90),
      );
    } else {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere(
          (element) => element.lensDirection == _initialDirection,
        ),
      );
    }
    notifyListeners();
  }

  void updateCameraIndex(cameraIndex) {
    _cameraIndex = cameraIndex;
    notifyListeners();
  }

  void updateRecognizedText(String text) {
    _recognizedText = text;
    notifyListeners();
  }
}
