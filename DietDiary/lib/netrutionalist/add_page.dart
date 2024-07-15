import 'dart:io';
import 'package:diet_diary/netrutionalist/view_diets.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configure/configure.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AddPage(),
    );
  }
}

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController fromAgeController = TextEditingController();
  TextEditingController toAgeController = TextEditingController();
  TextEditingController fromWeightController = TextEditingController();
  TextEditingController toWeightController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  XFile? imageFile;

  String userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id') ?? '';
    });
  }

  Future<void> sendData(BuildContext context, Map<String, dynamic> data,
      XFile? imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Config.baseUrl}/Diet/add.php'),
      );

      if (imageFile != null) {
        String fileName = imageFile.path
            .split('/')
            .last;
        String fileType = fileName
            .split('.')
            .last;
        List<int> imageBytes = await imageFile.readAsBytes();

        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            imageBytes,
            filename: fileName,
            contentType: MediaType('image', fileType),
          ),
        );
      }

      Map<String, String> stringData = data.map((key, value) =>
          MapEntry(key, value.toString()));
      request.fields.addAll(stringData);

      var response = await request.send();

      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => CurvedNavbar()), // Navigate to ViewDietPage
        );
      } else {
        throw Exception('Failed to send data');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/protein2.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 180,
          ),
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 150.0,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(''),
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.2),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _inputField(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inputField(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/mtoto.jpg',
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 10),
                Text(
                  'Enter diet details here',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        imageFile != null
            ? Row(
          children: [
            Expanded(
              child: Image.file(
                File(imageFile!.path),
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ],
        )
            : Container(),
        SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () async {
            final picker = ImagePicker();
            final pickedFile = await picker.pickImage(
                source: ImageSource.gallery);
            if (pickedFile != null) {
              setState(() {
                imageFile = pickedFile;
              });
            }
          },
          icon: Icon(Icons.image),
          label: Text('Choose Image'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
          ),
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Expanded(child: _buildInputField(
                "From Age", Icons.calendar_today, fromAgeController)),
            SizedBox(width: 20),
            Expanded(child: _buildInputField(
                "To Age", Icons.calendar_today, toAgeController)),
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Expanded(child: _buildInputField(
                "From Weight", Icons.line_weight, fromWeightController)),
            SizedBox(width: 20),
            Expanded(child: _buildInputField(
                "To Weight", Icons.line_weight, toWeightController)),
          ],
        ),
        SizedBox(height: 5),
        _buildInputField("Diet Name", Icons.label, nameController),
        SizedBox(height: 5),
        _buildMultilineInputField(
            "Description", Icons.description, descriptionController),
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.green,
                Colors.teal,
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ElevatedButton(
            onPressed: () {
              final Map<String, dynamic> data = {
                "user_id": userId, // Add user_id here
                "from_age": fromAgeController.text,
                "to_age": toAgeController.text,
                "from_weight": fromWeightController.text,
                "to_weight": toWeightController.text,
                "name": nameController.text,
                "description": descriptionController.text,
              };
              sendData(context, data, imageFile);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.transparent),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            child: const Text(
              "Submit",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(String hintText, IconData prefixIcon,
      TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: Colors.green),
        filled: true,
        fillColor: Colors.green.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      ),
    );
  }

  Widget _buildMultilineInputField(String hintText, IconData prefixIcon,
      TextEditingController controller) {
    return Container(
      height: 100,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIcon, color: Colors.green),
          filled: true,
          fillColor: Colors.green.withOpacity(0.4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        ),
      ),
    );
  }
}