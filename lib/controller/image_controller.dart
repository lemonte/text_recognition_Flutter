import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mlkit/controller/text_controller.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class ImageController {
  String imagePath = "";
  ValueNotifier<Size> imageSize = ValueNotifier<Size>(const Size(0, 0));

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();
    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );
    final Size _imageSize = await completer.future;
    imageSize.value = _imageSize;
  }

  void recognizeEmails(TextController textController) async {
    _getImageSize(File(imagePath));
    final inputImage = InputImage.fromFilePath(imagePath);
    final text =
        await textController.textDetector.value.processImage(inputImage);
    List<String> resultStrings = [];
    List<TextElement> elementsList = [];
    for (TextBlock block in text.blocks) {
      for (TextLine line in block.lines) {
        resultStrings.add(line.text);
        for (TextElement element in line.elements) {
          elementsList.add(element);
        }
      }
    }
    textController.elements.value = elementsList;
    // textController.elements.notifyListeners();
    textController.resultListString.value = resultStrings;
  }
}
