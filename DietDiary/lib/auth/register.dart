import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../configure/configure.dart';
import 'login.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getRegisteredUsername();
  }

  Future<void> _getRegisteredUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? registeredUsername = prefs.getString('registered_username');

    if (registeredUsername != null) {
      setState(() {
        usernameController.text = registeredUsername;
      });
    }
  }

  String? _validateFields() {
    if (usernameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      return 'Please enter all fields';
    }
    return null;
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showValidationDialog(BuildContext context, String message) {
    _showToast(message);
  }

  void _showSuccessDialog(BuildContext context, String message) {
    _showToast(message);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<void> signUp(BuildContext context) async {
    const String url = '${Config.baseUrl}/Auth/register.php';

    final String? validationError = _validateFields();
    if (validationError != null) {
      _showValidationDialog(context, validationError);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showValidationDialog(context, 'Passwords do not match');
      return;
    }

    final Map<String, dynamic> userData = {
      'username': usernameController.text,
      'phone': phoneController.text,
      'password': passwordController.text,
      'role': 'NormalUser', // Add the hidden role field here
    };

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['status'] == 'success') {
      _showSuccessDialog(context, responseData['message']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('registered_username', usernameController.text);
    } else {
      _showValidationDialog(context, responseData['message']);
    }
  }

  // UI starts here

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100, bottom: 20),
      child: Column(
        children: [
          Text(
            "Register here.",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          Text(
            "Enter your credentials to register",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: BottomRectangleClipper(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.teal,
                    Colors.grey,
                  ],
                ),
              ),
              width: double.infinity,
              height: double.infinity, // Fill the available height
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              // Wrap your Column with SingleChildScrollView
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _header(context),
                  _inputField(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              hintText: "Username",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white),
              ),
              fillColor: Colors.teal.withOpacity(0.9),
              filled: true,
              prefixIcon: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
              hintText: "Phone",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white),
              ),
              fillColor: Colors.teal.withOpacity(0.9),
              filled: true,
              prefixIcon: const Icon(
                Icons.phone,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              hintText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white),
              ),
              fillColor: Colors.teal.withOpacity(0.9),
              filled: true,
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.white,
              ),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: confirmPasswordController,
            decoration: InputDecoration(
              hintText: "Confirm Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white),
              ),
              fillColor: Colors.teal.withOpacity(0.9),
              filled: true,
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.white,
              ),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white), // Add white border
              borderRadius: BorderRadius.circular(10), // Adjust border radius as needed
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green,
                  Colors.teal,
                ],
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                signUp(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // Set to transparent to make button background transparent
                elevation: 0, // Remove elevation
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              child: const Text(
                "Register",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account?",
                style: TextStyle(fontSize: 20),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class BottomRectangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height); // Start from the bottom-left corner
    path.lineTo(size.width, size.height); // Go to the bottom-right corner
    path.lineTo(size.width, 0); // Go to the top-right corner
    path.close(); // Close the path to form a rectangle
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
