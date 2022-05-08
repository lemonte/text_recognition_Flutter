import 'package:flutter/material.dart';
import 'package:flutter_mlkit/controller/camera_controller.dart';
import 'package:flutter_mlkit/screens/camera_screen.dart';

// Global variable for storing the list of cameras available

Future<void> main() async {
  CameraInfoController cameraController = CameraInfoController();
  WidgetsFlutterBinding.ensureInitialized();
  await cameraController.startCamera();
  runApp(MyApp(
    cameraInfoController: cameraController,
  ));
}

class MyApp extends StatelessWidget {
  final CameraInfoController cameraInfoController;
  const MyApp({Key? key, required this.cameraInfoController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MLKit Vision',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CameraScreen(
        cameraInfoController: cameraInfoController,
      ),
    );
  }
}
