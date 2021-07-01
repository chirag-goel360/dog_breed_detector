import 'package:camera/camera.dart';
import 'package:dog_breed_detector/main.dart';
import 'package:flutter/material.dart';

class CameraDetection extends StatefulWidget {
  @override
  _CameraDetectionState createState() => _CameraDetectionState();
}

class _CameraDetectionState extends State<CameraDetection> {
  bool isRunning = false;
  String result = "";
  CameraController cameraController;
  CameraImage imageCamera;

  initializeCamera() async {
    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.max,
    );
    await cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream((image) => {
            if (!isRunning)
              {
                isRunning = true,
                imageCamera = image,
                //runModelOnStreamFrames(),
              },
          });
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/background.jpg',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Center(
                child: Container(
                  height: 320,
                  width: 360,
                  child: Image.asset(
                    'assets/frame.jpg',
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 35,
                    ),
                    height: 270,
                    width: 360,
                    child: imageCamera == null ? Container(
                      height: 270,
                      width: 360,
                      child: Icon(
                        Icons.photo_camera_back,
                        color: Colors.blueAccent,
                        size: 40,
                      ),
                    ) : AspectRatio(
                      aspectRatio: cameraController.value.aspectRatio,
                      child: CameraPreview(
                        cameraController,
                      ),
                    ),
                  ),
                  onPressed: () {
                    initializeCamera();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
