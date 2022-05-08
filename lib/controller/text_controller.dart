import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class TextController {
  ValueNotifier<TextRecognizer> textDetector =
      ValueNotifier<TextRecognizer>(TextRecognizer());
  ValueNotifier<List<TextElement>> elements =
      ValueNotifier<List<TextElement>>([]);
  ValueNotifier<List<String>> resultListString =
      ValueNotifier<List<String>>([]);
}
