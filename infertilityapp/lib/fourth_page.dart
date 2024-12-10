import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infertilityapp/comman.dart';
import 'package:infertilityapp/periodtracker.dart';
import 'package:infertilityapp/plogin.dart';
import 'package:infertilityapp/update_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forgot_password_page.dart';
import 'second_page.dart'; // Import the forgot password page

class FourthPage extends StatefulWidget {
  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
    var url = Uri.parse(patientlogin);

    // Form data to be sent to the server
    var data = {
      'Userid': userIdController.text,
      'password': passwordController.text,
    };

    // Send POST request to the server
    var response = await http.post(
      url,
      body: data,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );

    // Print the raw response body
    print('Response body: ${response.body}');

    try {
      // Remove any unexpected text from the response
      String responseBody = response.body;
      if (responseBody.startsWith('Connected')) {
        responseBody = responseBody.substring('Connected'.length);
      }

      // Parse the response JSON
      var responseData = json.decode(responseBody);

      // Check login status
      if (responseData['status'] == 'success') {
        // Login successful
        // Save the User ID using shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userIdController.text);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PLoginPage(userId: userIdController.text, name: ''),
          ),
        );
      } else {
        // Login failed
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
    } catch (e) {
      print('Error parsing response: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while processing the response.'),
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



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to the login page when the back button is pressed
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SecondPage()),
          ModalRoute.withName('/'),
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
          child: Container(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Image.asset(
                        'assets/patient.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Patient',
                            style: TextStyle(
                              fontSize: 22,
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 24,
                              fontStyle: FontStyle.italic,
                              color: Color(0xffed4662),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
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
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
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
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                            onPressed: _togglePasswordVisibility,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
                          backgroundColor: Color(0xffed4662),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
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
                                MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
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
                      SizedBox(height: 80),
                      Text(
                        'Hope blooms here. Welcome back to\nyour journey',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xfffddbdc),
      ),
    );
  }
}
