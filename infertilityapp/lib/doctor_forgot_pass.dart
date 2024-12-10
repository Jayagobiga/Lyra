import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infertilityapp/comman.dart';
import 'package:infertilityapp/third_page.dart';

class DoctorForgotPasswordPage extends StatefulWidget {
  @override
  _DoctorForgotPasswordPageState createState() =>
      _DoctorForgotPasswordPageState();
}

class _DoctorForgotPasswordPageState extends State<DoctorForgotPasswordPage> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false; // Add this variable to track password visibility

  Future<void> updatePassword() async {
    final Uri apiUrl = Uri.parse(drforgotpass);

    final response = await http.post(
      apiUrl,
      body: {
        'userid': userIdController.text,
        'password': newPasswordController.text,
        'repassword': confirmPasswordController.text,
      },
    );

    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      if (responseData['status'] == true) {
        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text(responseData['message']),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ThirdPage()),
                    );
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        // Show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(responseData['message']),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to update password"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffed4662),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(
              width: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(width: 30),
            Text(
              'Reset Password',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 120), // Add space from AppBar
            Center(
              child: Material(
                elevation: 4, // Add elevation here
                borderRadius: BorderRadius.circular(10), // Optional: Add border radius
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white, // Move the color inside the BoxDecoration
                  ),
                  width: 350,
                  height: 370,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40),
                        Material(
                          elevation: 2, // Add elevation here
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.pink[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: userIdController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'User id',
                                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        Material(
                          elevation: 2, // Add elevation here
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.pink[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: newPasswordController,
                              obscureText: !_isPasswordVisible, // Use the visibility toggle
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'New Password',
                                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
                                suffixIcon: IconButton(
                                  icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                    // Automatically hide the password after 1 second
                                    Future.delayed(Duration(seconds: 1), () {
                                      setState(() {
                                        _isPasswordVisible = false;
                                      });
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        Material(
                          elevation: 2, // Add elevation here
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.pink[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: confirmPasswordController,
                              obscureText: !_isPasswordVisible, // Use the visibility toggle
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Confirm new password',
                                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
                                suffixIcon: IconButton(
                                  icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                    // Automatically hide the password after 1 second
                                    Future.delayed(Duration(seconds: 1), () {
                                      setState(() {
                                        _isPasswordVisible = false;
                                      });
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Add space between container and button
            Center(
              child: GestureDetector(
                onTap: () {
                  updatePassword();
                },
                child: Material(
                  elevation: 4, // Add elevation here
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 90,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xffed4662),
                      borderRadius: BorderRadius.circular(8),
                      //border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xfffddbdc),
    );
  }
}
