import 'package:dog_breed_detector/homepage.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: HomePage(),
      title: Text(
        'Dog Breed Detector',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: Colors.pink,
        ),
      ),
      image: Image.asset(
        'assets/dog.gif',
      ),
      backgroundColor: Colors.blue.shade50,
      photoSize: 100,
      loaderColor: Colors.deepOrangeAccent,
      loadingText: Text(
        'From Chirag Goel',
        style: TextStyle(
          color: Colors.pinkAccent,
          fontSize: 18,
        ),
      ),
    );
  }
}
