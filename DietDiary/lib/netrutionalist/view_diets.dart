import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../configure/configure.dart';
import 'diet_details.dart';
import 'diet_modal.dart';
import 'edit_diets.dart';

void main() {
  runApp(MaterialApp(
    home: ViewDietsPage(),
  ));
}

class ViewDietsPage extends StatefulWidget {
  @override
  _ViewDietsPageState createState() => _ViewDietsPageState();
}

class _ViewDietsPageState extends State<ViewDietsPage> {
  late List<Diet> diets = [];

  @override
  void initState() {
    super.initState();
    fetchDiets();
  }

  Future<void> fetchDiets() async {
    const url = "${Config.baseUrl}/Diet/view.php";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true) {
          final dietData = jsonData['diets'];

          if (dietData != null && dietData is List) {
            setState(() {
              diets = List<Diet>.from(dietData.map((x) =>
                  Diet(
                    id: x['diet_id'],
                    imageUrl: x['image'],
                    fromAge: x['from_age'],
                    toAge: x['to_age'],
                    fromWeight: x['from_weight'],
                    toWeight: x['to_weight'],
                    dietName: x['name'],
                    description: x['description'],
                  )));
            });
          } else {
            throw Exception('Invalid data format');
          }
        } else {
          throw Exception('Failed to fetch diets: ${jsonData['message']}');
        }
      } else {
        throw Exception('Failed to load diets');
      }
    } catch (e) {
      print('Error fetching diets: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Diets',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
      ),
      body: diets.isNotEmpty
          ? ListView.builder(
        itemCount: diets.length,
        itemBuilder: (context, index) {
          Diet diet = diets[index];
          return GestureDetector(
            onTap: () {
              _navigateToDietDetails(diet);
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(16.0),
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.withOpacity(0.9),
                      Colors.green.shade400.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          diet.imageUrl,
                          width: 120,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              diet.dietName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Ages ${diet.fromAge} to ${diet.toAge} years',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Weight: ${diet.fromWeight} to ${diet.toWeight} kg',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              diet.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditDietPage(diet: diet),
                                ),
                              );

                              if (result == true) {
                                fetchDiets(); // Refresh the list if an edit was made
                              }
                            },
                            tooltip: 'Edit',
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirm Deletion'),
                                    content: Text(
                                        'Are you sure you want to delete this diet?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          try {
                                            final response = await http.delete(
                                              Uri.parse(
                                                  '${Config.baseUrl}/Diet/delete.php?diet_id=${diet.id}'),
                                            );
                                            if (response.statusCode == 200) {
                                              setState(() {
                                                diets.removeAt(index);
                                              });
                                              Navigator.of(context).pop();
                                            } else {
                                              throw Exception(
                                                  'Failed to delete diet: ${response.statusCode}');
                                            }
                                          } catch (e) {
                                            print('Error deleting diet: $e');
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Error'),
                                                  content: Text(
                                                      'Failed to delete diet. Please try again later.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            tooltip: 'Delete',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
