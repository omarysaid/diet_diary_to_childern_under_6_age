import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../configure/configure.dart';
import '../netrutionalist/home_page.dart';
import '../users/home_page.dart';
import 'register.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _autoFillUsername();
  }

  Future<void> _autoFillUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? registeredUsername = prefs.getString('registered_username');

    if (registeredUsername != null) {
      setState(() {
        usernameController.text = registeredUsername;
      });
    }
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

  Future<void> login(BuildContext context) async {
    const String url = '${Config.baseUrl}/Auth/login.php';
    // Replace with your PHP endpoint URL

    // Prepare the data to be sent
    final Map<String, dynamic> userData = {
      'username': usernameController.text,
      'password': passwordController.text,
    };

    // Send POST request
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );

    // Decode the response
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    if (response.statusCode == 200 && responseData['success']) {
      final String? role = responseData['role']; // Nullable String

      if (role == 'Nutritionist'
          '') {
        // Store username and phone number for admin user as well
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', usernameController.text);
        // Assuming phone number is also retrieved from the API response
        prefs.setString('phone', responseData['phone'].toString());
        prefs.setString('user_id', responseData['user_id'].toString());

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CurvedNavbar()),
        );
      } else {
        // Store username and phone number
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', usernameController.text);
        // Assuming phone number is also retrieved from the API response
        prefs.setString('phone', responseData['phone'].toString());

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CurveNavbar ()),
        );
      }
    } else {
      _showToast(responseData['message']);
    }
  }

// starts of ui page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/kali.png'),
                fit: BoxFit.cover,
              ),
            ),
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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

  Widget _header(BuildContext context) {
    return Column(
      children: [
        Text(
          "SMART DIET\n DIARY",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 35, // Reduced font size
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
    Container(
    padding: EdgeInsets.only(top: 10), // Add top margin
    child: Text(
    "Enter your credentials to login",
    style: TextStyle(
    fontSize: 20,
    color: Colors.green,
    ),
    ),
        ),
      ],
    );
  }

  Widget _inputField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              hintText: "Username",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white), // Border color
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder( // Ensure border color when focused
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white),
              ),
              fillColor: Colors.teal.withOpacity(0.6),
              filled: true,
              prefixIcon: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20), // Reduced SizedBox height
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              hintText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white), // Border color
              ),
              enabledBorder: OutlineInputBorder( // Ensure border color when not focused
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder( // Ensure border color when focused
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white),
              ),
              fillColor: Colors.teal.withOpacity(0.6),
              filled: true,
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.white,
              ),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20), // Reduced SizedBox height
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
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
                login(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                // Set to transparent to make button background transparent
                elevation: 0,
                // Remove elevation
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 16), // Adjusted padding
                textStyle: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20), // Reduced SizedBox height
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account? ",
                style: TextStyle(fontSize: 20), // Reduced font size
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white, fontSize: 20), // Reduced font size
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
