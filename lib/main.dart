import 'package:camera/camera.dart';
import 'package:dog_breed_detector/splash_page.dart';
import 'package:flutter/material.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog Breed Detector',
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}
