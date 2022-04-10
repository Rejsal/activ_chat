import 'package:activ_chat/models/chat_model.dart';
import 'package:activ_chat/providers/auth_provider.dart';
import 'package:activ_chat/providers/chat_provider.dart';
import 'package:activ_chat/screens/camera_view.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:provider/provider.dart';

class ObjectDetectorView extends StatefulWidget {
  const ObjectDetectorView({required this.chat, Key? key}) : super(key: key);

  final ChatModel chat;

  @override
  _ObjectDetectorView createState() => _ObjectDetectorView();
}

class _ObjectDetectorView extends State<ObjectDetectorView> {
  late ObjectDetector objectDetector;

  @override
  void initState() {
    objectDetector = GoogleMlKit.vision.objectDetector(ObjectDetectorOptions(
        trackMutipleObjects: true, classifyObjects: true));
    super.initState();
  }

  bool isBusy = false;
  bool success = false;
  CustomPaint? customPaint;

  @override
  void dispose() {
    objectDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chat = Provider.of<ChatProvider>(context);
    final user = Provider.of<AuthProvider>(context);
    return Stack(
      children: [
        Expanded(
          child: CameraView(
            title: 'Object Detector',
            customPaint: customPaint,
            onImage: (inputImage) {
              processImage(inputImage);
            },
            onSubmit: () {
              if (success) {
                chat.createChat(ChatModel(
                    group: widget.chat.group,
                    fromName: user.userInfo?.name,
                    fromId: user.userInfo?.uid,
                    message: "I won the game!",
                    date: DateTime.now().toString(),
                    type: 'chat'));
                Navigator.pop(context);
              }
            },
          ),
        ),
        success
            ? Center(
                child: Image.asset('assets/icons/tick.png'),
              )
            : Container()
      ],
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final result = await objectDetector.processImage(inputImage);
    if (result.isNotEmpty) {
      if (result[0].getLabels().isNotEmpty) {
        for (var label in result[0].getLabels()) {
          if (label.getText().toLowerCase() ==
                  widget.chat.category?.toLowerCase() &&
              label.getConfidence() >= 0.7) {
            setState(() {
              success = true;
            });
            break;
          }
        }
      }
    }
    isBusy = false;
  }
}
