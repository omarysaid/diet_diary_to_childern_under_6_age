import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../configure/configure.dart'; // Ensure this import is correct
import '../netrutionalist/diet_details.dart';
import '../users/diet_modal.dart';

class ViewDietPage extends StatefulWidget {
  final int nutritionistId;

  ViewDietPage({required this.nutritionistId});

  @override
  _ViewDietPageState createState() => _ViewDietPageState();
}

class _ViewDietPageState extends State<ViewDietPage> {
  late List<Diet> diets;
  late List<Diet> filteredDiets;
  late TextEditingController ageController;
  late TextEditingController weightController;

  @override
  void initState() {
    super.initState();
    diets = [];
    filteredDiets = [];
    ageController = TextEditingController();
    weightController = TextEditingController();
    fetchDiets();
  }

  @override
  void dispose() {
    ageController.dispose();
    weightController.dispose();
    super.dispose();
  }

  Future<void> fetchDiets() async {
    final url = "${Config.baseUrl}/User/nutritionists.php?nutritionistId=${widget.nutritionistId}";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true) {
          // Find the nutritionist by ID
          final nutritionist = jsonData['nutritionists'].firstWhere(
                (n) => n['id'] == widget.nutritionistId,
            orElse: () => null,
          );

          if (nutritionist != null) {
            final dietData = nutritionist['diets'];

            if (dietData != null && dietData is List) {
              setState(() {
                diets = dietData.map((x) => Diet(
                  id: x['diet_id'],
                  imageUrl: x['image'],
                  fromAge: x['from_age'],
                  toAge: x['to_age'],
                  fromWeight: x['from_weight'],
                  toWeight: x['to_weight'],
                  dietName: x['name'],
                  description: x['description'],
                )).toList();
                filteredDiets = List.from(diets); // Initialize filteredDiets with the fetched diets
              });
            } else {
              throw Exception('Invalid data format: dietData is not a List or is null');
            }
          } else {
            throw Exception('Nutritionist with ID ${widget.nutritionistId} not found');
          }
        } else {
          throw Exception('Failed to fetch diets: ${jsonData['message']}');
        }
      } else {
        throw Exception('Failed to load diets: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching diets: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to load diets. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _navigateToDietDetails(Diet diet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DietDetailsPage(
          imageUrl: diet.imageUrl,
          fromAge: diet.fromAge,
          toAge: diet.toAge,
          fromWeight: diet.fromWeight,
          toWeight: diet.toWeight,
          dietName: diet.dietName,
          description: diet.description,
        ),
      ),
    );
  }

  void _searchDiet() {
    String age = ageController.text;
    String weight = weightController.text;

    if (age.isNotEmpty && weight.isNotEmpty) {
      double ageValue = double.parse(age);
      double weightValue = double.parse(weight);

      setState(() {
        filteredDiets = diets.where((diet) {
          double fromAge = double.parse(diet.fromAge);
          double toAge = double.parse(diet.toAge);
          double fromWeight = double.parse(diet.fromWeight);
          double toWeight = double.parse(diet.toWeight);

          return ageValue >= fromAge &&
              ageValue <= toAge &&
              weightValue >= fromWeight &&
              weightValue <= toWeight;
        }).toList();
      });
    } else {
      setState(() {
        filteredDiets = List.from(diets);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Diets',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Age',
                        prefixIcon: Icon(Icons.cake, color: Colors.green),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Weight',
                        prefixIcon: Icon(Icons.monitor_weight, color: Colors.green),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _searchDiet,
                  child: Icon(Icons.search, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Button background color
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: filteredDiets.isEmpty
                  ? Center(child: Text('No diets found', style: TextStyle(fontSize: 18)))
                  : ListView.builder(
                itemCount: filteredDiets.length,
                itemBuilder: (context, index) {
                  Diet diet = filteredDiets[index];
                  return GestureDetector(
                    onTap: () => _navigateToDietDetails(diet),
                    child: Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 1),
                      color: Colors.green[400],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8), // Adjust border radius as needed
                              child: Image.network(
                                diet.imageUrl,
                                height: 110, // Adjust height as needed
                                width: 110, // Adjust width as needed
                                fit: BoxFit.cover, // Adjust fit as needed
                              ),
                            ),
                            SizedBox(width: 8), // Adjust spacing between image and text as needed
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    diet.dietName,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Adjust font size, weight, and color for title
                                    maxLines: 1, // Ensure only one line for the title
                                    overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis if necessary
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    diet.description,
                                    style: TextStyle(fontSize: 14, color: Colors.white), // Adjust font size and color for description
                                    maxLines: 4, // Limit description to 4 lines
                                    overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis if necessary
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.navigate_next, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
