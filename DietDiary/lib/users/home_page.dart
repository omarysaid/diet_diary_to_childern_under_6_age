import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../netrutionalist/nutritionists.dart';
import 'explanation.dart';
import 'package:diet_diary/netrutionalist/profile.dart';
import 'package:diet_diary/users/view_diet.dart';

class CurveNavbar extends StatefulWidget {
  const CurveNavbar({Key? key}) : super(key: key);

  @override
  _CurvedNavbarState createState() => _CurvedNavbarState();
}

class _CurvedNavbarState extends State<CurveNavbar> {
  int _currentIndex = 0; // Index of the current page, changed to 0 for ViewDietPage

  final List<Widget> _pages = [
    // Define your pages here
    NutritionistListPage(),
    ReadPage(), // Add your ReadPage here
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.green,
        color: Colors.green,
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.remove_red_eye_rounded, size: 26, color: Colors.white), // For ViewDietPage
          Icon(Icons.book, size: 26, color: Colors.white), // For ReadPage
          Icon(Icons.person, size: 26, color: Colors.white), // For ProfilePage
        ],
        onTap: (index) {
          // Set state to rebuild the widget with the new current index
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
