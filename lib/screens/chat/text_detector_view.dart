import 'package:activ_chat/providers/camera_provider.dart';
import 'package:activ_chat/screens/camera_view.dart';
import 'package:activ_chat/screens/chat/text_detector_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:provider/provider.dart';

class TextDetectorView extends StatefulWidget {
  const TextDetectorView({Key? key}) : super(key: key);

  @override
  _TextDetectorViewState createState() => _TextDetectorViewState();
}

class _TextDetectorViewState extends State<TextDetectorView> {
  TextDetector textDetector = GoogleMlKit.vision.textDetector();
  bool isBusy = false;
  CustomPaint? customPaint;

  @override
  void dispose() async {
    super.dispose();
    await textDetector.close();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Text Detector',
      customPaint: customPaint,
      onImage: (inputImage) {
        processImage(inputImage);
      },
      onSubmit: () {
        Navigator.pop(context, true);
      },
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final recognisedText = await textDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = TextDetectorPainter(
          recognisedText,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }
    isBusy = false;
    if (mounted) {
      setState(() {});
      Provider.of<CameraProvider>(context, listen: false)
          .updateRecognizedText(recognisedText.text);
    }
  }
}
