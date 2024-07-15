import 'package:diet_diary/netrutionalist/profile.dart';
import 'package:diet_diary/netrutionalist/view_diets.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'add_page.dart'; // Import your AddPage

class CurvedNavbar extends StatefulWidget {
  const CurvedNavbar({Key? key}) : super(key: key);

  @override
  _CurvedNavbarState createState() => _CurvedNavbarState();
}

class _CurvedNavbarState extends State<CurvedNavbar> {
  int _currentIndex = 0; // Index of the current page, changed to 0 for AddPage

  final List<Widget> _pages = [
    // Define your pages here
    AddPage(),
    ViewDietsPage(),
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
          Icon(Icons.add, size: 26, color: Colors.white),
          Icon(Icons.remove_red_eye_rounded, size: 26, color: Colors.white),
          Icon(Icons.person, size: 26, color: Colors.white),
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
