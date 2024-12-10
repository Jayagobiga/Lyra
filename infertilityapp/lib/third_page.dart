import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infertilityapp/second_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infertilityapp/comman.dart';
import 'package:infertilityapp/fifth_page.dart';
import 'package:infertilityapp/doctor_forgot_pass.dart';
import 'dart:convert';

class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dayDifferenceController = TextEditingController();
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
    // Automatically hide the password after 2 seconds
    Timer(Duration(seconds: 1), () {
      setState(() {
        _isPasswordVisible = false;
      });
    });
  }

  Future<void> _login() async {
    // API endpoint URL
    var url = Uri.parse(doctorlogin);

    // Data to send via form data (not JSON)
    var data = {
      'dr_userid': userIdController.text,
      'password': passwordController.text,
    };

    // Send POST request to the server
    var response = await http.post(
      url,
      body: data, // Sending as form data
    );

    // Clean up response body to remove extra text like "Connected"
    String responseBody = response.body;
    if (responseBody.contains("{")) {
      responseBody = responseBody.substring(responseBody.indexOf("{"));
    }

    try {
      // Parse the cleaned JSON response
      var responseData = jsonDecode(responseBody);

      // Check login status
      if (responseData['status'] == 'success') {
        // Save the User ID using shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('UserId', userIdController.text);

        // Navigate to the FifthPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FifthPage(
              userId: userIdController.text,
              dayDifference: int.parse(userIdController.text), // Replace this if needed
            ),
          ),
        );
      } else {
        // Login failed
        _showLoginFailedDialog();
      }
    } catch (e) {
      // Handle the parsing error
      print('Error parsing JSON: $e');
      _showLoginFailedDialog();
    }
  }

  void _showLoginFailedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Failed'),
          content: Text('Invalid user id or password'),
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


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SecondPage()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfffddbdc),
          automaticallyImplyLeading: false, // Disable automatic leading widget
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SecondPage())
                  );
                },
                child: Icon(
                  Icons.arrow_back_ios, // Path to your image asset
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height:20),
                  Image.asset(
                    'assets/doctor.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Doctor Login',
                    style: TextStyle(
                      fontSize: 22,
                      fontStyle: FontStyle.italic,
                      color: Color(0xffed4662),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'User id',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextField(
                    controller: userIdController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: !_isPasswordVisible,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 40.0),
                      backgroundColor: Color(0xffed4662),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DoctorForgotPasswordPage()),
                          );
                        },
                        child: Text(
                          'Create/Forgot Password?',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 70),
                  Text(
                    'Empowering Lives, Fertility Strides.\n            Welcome back, Doctor!',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xfffddbdc),
      ),
    );
  }
}
