import 'package:dog_breed_detector/camera_detection.dart';
import 'package:dog_breed_detector/image_detection.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _list = [
    ImageDetection(),
    CameraDetection(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dog Breed Detection',
        ),
        centerTitle: true,
      ),
      body: _list[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.image,
              color: Colors.teal,
            ),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera_front,
              color: Colors.teal,
            ),
            label: 'Live Camera',
          ),
        ],
        backgroundColor: Colors.green.shade50,
        elevation: 5,
        iconSize: 25,
        selectedFontSize: 16,
        unselectedFontSize: 16,
        unselectedItemColor: Colors.red,
      ),
    );
  }
}