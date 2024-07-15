import 'package:flutter/material.dart';

class DietDetailsPage extends StatelessWidget {
  final String imageUrl;
  final String fromAge;
  final String toAge;
  final String fromWeight;
  final String toWeight;
  final String dietName;
  final String description;

  DietDetailsPage({
    required this.imageUrl,
    required this.fromAge,
    required this.toAge,
    required this.fromWeight,
    required this.toWeight,
    required this.dietName,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Diet Details',
          style: TextStyle(color: Colors.white), // Set the title color to white
        ),
        backgroundColor: Colors.green,

      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Children With Age Range  $fromAge - $toAge (years)',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17, color: Colors.green),
            ),
            SizedBox(height: 8.0),
            Text(
              'Children with Weight Range  $fromWeight - $toWeight (Kg)',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17, color: Colors.green),
            ),
            SizedBox(height: 8.0),
            Text(
              'Suitable diet ( $dietName)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.green),
            ),
            SizedBox(height: 8.0),
            Divider(color: Colors.green),
            SizedBox(height: 8.0),
            Text(
              'More Food Details',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18, ),
            ),
            SizedBox(height: 8.0),
            Text(
              description,
              style: TextStyle(fontSize: 16.0, ),
            ),
          ],
        ),
      ),
    );
  }
}
