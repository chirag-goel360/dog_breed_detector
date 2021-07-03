import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class ImageDetection extends StatefulWidget {
  @override
  _ImageDetectionState createState() => _ImageDetectionState();
}

class _ImageDetectionState extends State<ImageDetection> {
  ImagePicker imagePicker;
  File _file;
  String result = '';

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    loadDataModelFiles();
  }

  imageFromCamera() async {
    PickedFile pickedFile = await imagePicker.getImage(
      source: ImageSource.camera,
    );
    _file = File(
      pickedFile.path,
    );
    setState(() {
      runModelOnImage();
    });
  }

  imageFormGallery() async {
    PickedFile pickedFile = await imagePicker.getImage(
      source: ImageSource.gallery,
    );
    _file = File(
      pickedFile.path,
    );
    setState(() {
      runModelOnImage();
    });
  }

  @override
  void dispose() async {
    super.dispose();
  }

  runModelOnImage() async {
    var recognitions = await Tflite.runModelOnImage(
      path: _file.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.1,
      asynch: true,
    );
    print(recognitions.length.toString());
    setState(() {
      result = "";
    });
    recognitions.forEach((element) {
      setState(() {
        result += element["label"]+'\n';
      });
    });
  }

  loadDataModelFiles() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/background.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 100,
            ),
            child: Stack(
              children: [
                Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/frame.jpg',
                        height: 250,
                        width: 250,
                      ),
                    ),
                  ],
                ),
                Center(
                  child: TextButton(
                    onPressed: imageFormGallery,
                    onLongPress: imageFromCamera,
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 8,
                      ),
                      child: _file != null
                          ? Image.file(
                              _file,
                              width: 180,
                              height: 220,
                              fit: BoxFit.fill,
                            )
                          : Container(
                              width: 150,
                              height: 225,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey[800],
                                  ),
                                  Text(
                                    'Press for Gallery',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Long Press for Camera',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Text(
                  '$result',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
