import 'package:flutter/material.dart';

class ReadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Read Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false, // Hide the back button
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome,',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              height: 220.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/kali.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20.0), // Add border radius here
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Find the right diet for your child!',
              style: TextStyle(fontSize: 22.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Text(
              'Search by age:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 30.0),
            Text(
              '(0 to 0.9) for children under 1 year\n'
                  '(1 to 1.9) for children under 2 years\n'
                  '(2 to 2.9) for children under 3 years\n'
                  '(3 to 3.9) for children under 4 years\n'
                  '(4 to 4.9) for children under 5 years\n'
                  '(5 to 5.9) for children under 6 years\n\n'
                  'Decimal stands for months',
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
