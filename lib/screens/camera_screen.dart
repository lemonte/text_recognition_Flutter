import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mlkit/controller/camera_controller.dart';

import 'detail_screen.dart';

class CameraScreen extends StatefulWidget {
  final CameraInfoController cameraInfoController;
  const CameraScreen({Key? key, required this.cameraInfoController})
      : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    widget.cameraInfoController.initializeCamera();
    widget.cameraInfoController.controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    widget.cameraInfoController.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Flutter MLKit Vision'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await widget.cameraInfoController
                .takePicture()
                .then((String? path) {
              if (path != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      imagePath: path,
                    ),
                  ),
                );
              } else {
                log('Image path not found!');
              }
            });
          },
          child: Icon(Icons.document_scanner_outlined),
        ),
        body: ValueListenableBuilder(
          valueListenable: widget.cameraInfoController.controller,
          builder:
              (BuildContext context, CameraValue controller, Widget? child) {
            return controller.isInitialized
                ? OrientationBuilder(builder: (context, orientation) {
                    return stackCamera();
                  })
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
          },
        ));
  }

  Widget stackCamera() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: CameraPreview(widget.cameraInfoController.controller))
      ],
    );
  }
}
