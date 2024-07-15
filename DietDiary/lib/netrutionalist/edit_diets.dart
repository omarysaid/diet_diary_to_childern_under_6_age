import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../configure/configure.dart';
import 'diet_modal.dart';

class EditDietPage extends StatefulWidget {
  final Diet diet;

  EditDietPage({required this.diet});

  @override
  _EditDietPageState createState() => _EditDietPageState();
}

class _EditDietPageState extends State<EditDietPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _fromAgeController;
  late TextEditingController _toAgeController;
  late TextEditingController _fromWeightController;
  late TextEditingController _toWeightController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.diet.dietName);
    _descriptionController = TextEditingController(text: widget.diet.description);
    _fromAgeController = TextEditingController(text: widget.diet.fromAge);
    _toAgeController = TextEditingController(text: widget.diet.toAge);
    _fromWeightController = TextEditingController(text: widget.diet.fromWeight);
    _toWeightController = TextEditingController(text: widget.diet.toWeight);
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateDiet() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create the multipart request
        final request = http.MultipartRequest(
          'POST', // Change to POST for compatibility with file uploads
          Uri.parse('${Config.baseUrl}/Diet/update.php'),
        );

        // Add text fields
        request.fields['diet_id'] = widget.diet.id.toString();
        request.fields['name'] = _nameController.text;
        request.fields['description'] = _descriptionController.text;
        request.fields['from_age'] = _fromAgeController.text;
        request.fields['to_age'] = _toAgeController.text;
        request.fields['from_weight'] = _fromWeightController.text;
        request.fields['to_weight'] = _toWeightController.text;

        // Add image file if present
        if (_imageFile != null) {
          request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));
        }

        // Send the request
        final response = await request.send();

        // Read the response
        final responseString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          final result = json.decode(responseString);
          if (result['success']) {
            Navigator.pop(context, true); // Return true to indicate success
          } else {
            throw Exception(result['message']);
          }
        } else {
          throw Exception('Failed to update diet, server responded with status code ${response.statusCode}');
        }
      } catch (e) {
        // Show detailed error message
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to update diet: $e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Diet', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : widget.diet.imageUrl.isNotEmpty
                      ? Image.network(widget.diet.imageUrl, fit: BoxFit.cover)
                      : Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
              SizedBox(height: 16.0),
              _buildTextField(_nameController, 'Diet Name'),
              SizedBox(height: 16.0),
              _buildTextField(_descriptionController, 'Description', maxLines: 3),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(child: _buildTextField(_fromAgeController, 'From Age')),
                  SizedBox(width: 16.0),
                  Expanded(child: _buildTextField(_toAgeController, 'To Age')),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(child: _buildTextField(_fromWeightController, 'From Weight')),
                  SizedBox(width: 16.0),
                  Expanded(child: _buildTextField(_toWeightController, 'To Weight')),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateDiet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text('Update Diet', style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        filled: true,
        fillColor: Colors.green.withOpacity(0.6),
      ),
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter ${labelText.toLowerCase()}';
        }
        return null;
      },
    );
  }
}
