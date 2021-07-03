import 'package:camera/camera.dart';
import 'package:dog_breed_detector/main.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

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
                  runModelOnStreamFrames(),
                },
            });
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  void dispose() async {
    super.dispose();
    cameraController?.dispose();
  }

  runModelOnStreamFrames() async {
    if (imageCamera != null) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imageCamera.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: imageCamera.height,
        imageWidth: imageCamera.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true,
      );
      print(recognitions.length.toString());
      result = "";
      recognitions.forEach((element) {
        setState(() {
          result += element["label"] + '\n';
        });
      });
      isRunning = false;
    }
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
                  margin: EdgeInsets.only(
                    top: 100,
                  ),
                  height: 300,
                  width: 330,
                  child: Image.asset(
                    'assets/frame.jpg',
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 100,
                    ),
                    height: 280,
                    width: 240,
                    child: imageCamera == null
                        ? Container(
                            height: 150,
                            width: 200,
                            child: Icon(
                              Icons.photo_camera_back,
                              color: Colors.blueAccent,
                              size: 40,
                            ),
                          )
                        : AspectRatio(
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
          Center(
            child: Container(
              margin: EdgeInsets.only(
                top: 55,
              ),
              child: SingleChildScrollView(
                child: Text(
                  result,
                  style: TextStyle(
                    backgroundColor: Colors.white,
                    fontSize: 25,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
