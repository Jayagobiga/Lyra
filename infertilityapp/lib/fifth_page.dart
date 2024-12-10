import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infertilityapp/comman.dart';
import 'package:infertilityapp/eleventh_page.dart';
import 'package:infertilityapp/seventh_page.dart';
import 'package:infertilityapp/third_page.dart';
import 'sixth_page.dart'; // Import statement for the SixthPage

class FifthPage extends StatefulWidget {
  final String userId; // Declare userId variable to store the received user ID
  final int dayDifference;

  // Constructor to receive the user ID as a parameter
  FifthPage({required this.userId,required this.dayDifference});

  @override
  _FifthPageState createState() => _FifthPageState();
}

class _FifthPageState extends State<FifthPage> {
  Map<String, dynamic>? userData;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    // Fetch user data when the page is initialized
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      var url = Uri.parse(doctorprofile);
      var response = await http.post(
        url,
        body: {'userId': widget.userId},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            userData = data['data'];
          });
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception caught: $e');
    }
  }
  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    await fetchUserData();

    // Add a delay of 1 second before setting _isRefreshing to false
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to the ThirdPage when back button is pressed
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ThirdPage()),
          ModalRoute.withName('/'), // This ensures that ThirdPage becomes the new root
        );
        return false; // Prevents default back button behavior
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffed4662),
          title: Text(
            'Hello!',
            style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SixthPage(userId: widget.userId,dayDifference: widget.dayDifference,)), // Pass the userId to SixthPage
              );
            },
            child: Container(
              width: 40,
              child: Image.asset(
                'assets/profile.png', // Replace 'assets/your_image.png' with your image path
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Center(
        child: _isRefreshing
        ? CircularProgressIndicator() // Show a loading indicator while refreshing
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/person.png', // Replace 'assets/your_image.png' with your image path
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  // Send form data to PHP server
                  var url = Uri.parse(patientid);
                  var response = await http.post(
                    url,
                    body: {
                      'name': ' ', // Replace with user input
                      'contactno': ' ', // Replace with user input
                      'age': ' ', // Replace with user input
                      'gender': ' ', // Replace with user input
                      'height': ' ', // Replace with user input
                      'weight': ' ', // Replace with user input
                      'address': ' ', // Replace with user input
                      'marriageyear': ' ', // Replace with user input
                      'bloodgroup': ' ', // Replace with user input
                      'medicalhistory': ' ', // Replace with user input
                      'password': ' ', // Replace with user input
                      'repassword': ' ', // Replace with user input
                    },
                  );

                  // Handle response
                  if (response.statusCode == 200) {
                    // Successful response
                    var data = json.decode(response.body);
                    print('Response data: $data'); // Print response data for debugging
                    if (data['status'] == true) {
                      // Patient registration successful
                      // Extract the patient ID from the response using the correct key
                      int patientId = data['Userid'];


                      // Navigate to the SeventhPage with User ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeventhPage(userId: patientId.toString(),dayDifference: widget.dayDifference), // Convert to string
                        ),
                      );

                    } else {
                      // Error in registration
                      print('Error: ${data['message']}');
                    }
                  } else {
                    // Error in HTTP request
                    print('Failed to register patient: ${response.statusCode}');
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 3, // Set elevation here
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '         Add patient details          ',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 20),
                    Image.asset(
                      'assets/injury.png', // Replace 'assets/injury.png' with your image path
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to EleventhPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EleventhPage(userId: widget.userId,dayDifference: widget.dayDifference)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 3, // Set elevation here
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '  View/Modify patient details  ',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 20),
                    Image.asset(
                      'assets/injury.png', // Replace 'assets/injury.png' with your image path
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
        backgroundColor: Color(0xfffddbdc),
      ),
    );
  }
}
