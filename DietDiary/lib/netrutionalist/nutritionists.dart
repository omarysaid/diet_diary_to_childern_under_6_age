import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../configure/configure.dart';
import '../users/view_diet.dart';
import 'nutritionist_modal.dart';

class NutritionistListPage extends StatefulWidget {
  @override
  _NutritionistListPageState createState() => _NutritionistListPageState();
}

class _NutritionistListPageState extends State<NutritionistListPage> {
  late List<Nutritionist> nutritionists;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nutritionists = [];
    fetchNutritionists();
  }

  Future<void> fetchNutritionists() async {
    setState(() {
      isLoading = true;
    });

    const url = "${Config.baseUrl}/User/nutritionists.php"; // Replace with your PHP endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true) {
          final nutritionistData = jsonData['nutritionists'];

          if (nutritionistData != null && nutritionistData is List) {
            setState(() {
              nutritionists = nutritionistData
                  .map((json) => Nutritionist.fromJson(json))
                  .toList();
              isLoading = false;
            });
          } else {
            throw Exception('Invalid data format');
          }
        } else {
          throw Exception('Failed to fetch nutritionists: ${jsonData['message']}');
        }
      } else {
        throw Exception('Failed to load nutritionists');
      }
    } catch (e) {
      print('Error fetching nutritionists: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load nutritionists. Please try again later.'),
          duration: Duration(seconds: 3),
        ),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nutritionists',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : nutritionists.isEmpty
          ? Center(child: Text('No nutritionists found'))
          : ListView.builder(
        itemCount: nutritionists.length,
        itemBuilder: (context, index) {
          Nutritionist nutritionist = nutritionists[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewDietPage(nutritionistId: nutritionist.id), // Pass nutritionistId
                ),
              );
            },
            child: Card(
              color: Colors.grey[100],
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.green, // Green avatar background color
                      child: Text(
                        nutritionist.getInitials(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            nutritionist.username,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            nutritionist.phone,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Position: ${nutritionist.role}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.navigate_next),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
