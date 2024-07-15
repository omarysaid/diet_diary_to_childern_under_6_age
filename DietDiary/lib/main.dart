import 'dart:async';
import 'package:flutter/material.dart';
import 'Auth/login.dart';
import 'package:flutter/services.dart' show AssetManifest;



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Set background color to white
      ),
      home: AnimationPage(),
    );
  }
}

class AnimationPage extends StatefulWidget {
  @override
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> {
  late Timer _timer;
  int _currentIndex = 0;

  final List<String> _imagePaths = [
    'assets/images/kali.png',
    'assets/images/lishe.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _imagePaths.length;
      });
      // Stop the timer and navigate to LoginPage after the last image
      if (_currentIndex == _imagePaths.length - 1) {
        _timer.cancel();
        // Navigate to the login page after animation completes
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  LoginPage()), // Replace LoginPage with your actual login page
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_imagePaths[_currentIndex]),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
