import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mlkit/controller/image_controller.dart';
import 'package:flutter_mlkit/controller/text_controller.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class DetailScreen extends StatefulWidget {
  final String imagePath;
  const DetailScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TextController textController = TextController();
  ImageController imageController = ImageController();
  @override
  void initState() {
    imageController.imagePath = widget.imagePath;
    textController.textDetector.value = GoogleMlKit.vision.textRecognizer();
    imageController.recognizeEmails(textController);
    super.initState();
  }

  @override
  void dispose() {
    textController.textDetector.value.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Transcrição do Texto"),
        ),
        body: ValueListenableBuilder(
          valueListenable: imageController.imageSize,
          builder: (BuildContext context, Size value, Widget? child) {
            return value.height > 0 && value.width > 0
                ? ListView(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: double.maxFinite,
                            color: Colors.black,
                            child: ValueListenableBuilder(
                              valueListenable: textController.elements,
                              builder: (BuildContext context,
                                  List<TextElement> list, Widget? child) {
                                return CustomPaint(
                                  foregroundPainter: TextDetectorPainter(
                                    value,
                                    list,
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: value.aspectRatio,
                                    child: Image.file(
                                      File(imageController.imagePath),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Card(
                        elevation: 8,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "Identified emails",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ValueListenableBuilder(
                                valueListenable:
                                    textController.resultListString,
                                builder: (BuildContext context,
                                    List<String> list, Widget? child) {
                                  return SelectableText(
                                      list.join("\n").toString());
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
          },
        ));
  }
}

class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(this.absoluteImageSize, this.elements);

  final Size absoluteImageSize;
  final List<TextElement> elements;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    Rect scaleRect(TextElement container) {
      return Rect.fromLTRB(
        container.boundingBox.left * scaleX,
        container.boundingBox.top * scaleY,
        container.boundingBox.right * scaleX,
        container.boundingBox.bottom * scaleY,
      );
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 2.0;

    for (TextElement element in elements) {
      canvas.drawRect(scaleRect(element), paint);
    }
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return true;
  }
}
