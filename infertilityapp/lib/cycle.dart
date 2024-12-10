import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'comman.dart';

class CyclePage extends StatefulWidget {
  final String userId; // Define userId variable

  CyclePage({Key? key, required this.userId}) : super(key: key); // Accept userId as a parameter

  @override
  _CyclePageState createState() => _CyclePageState();
}

class _CyclePageState extends State<CyclePage> {
  DateTime? _selectedDate;
  int _dayCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchSavedDate();
  }

  Future<void> _fetchSavedDate() async {
    final url = fetchdate;
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'userId': widget.userId});

    print('Request URL: $url'); // Debugging
    print('Request Headers: $headers'); // Debugging
    print('Request Body: $body'); // Debugging

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print('Response Status: ${response.statusCode}'); // Debugging
    print('Response Body: ${response.body}'); // Debugging

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Response Data: $responseData'); // Debugging

      if (responseData['selectedDate'] != null) {
        setState(() {
          _selectedDate = DateTime.parse(responseData['selectedDate']);
          _calculateDayCount();
        });
      }
    } else {
      print('Failed to load date from backend');
    }
  }

  void _calculateDayCount() {
    if (_selectedDate != null) {
      final now = DateTime.now();
      final difference = now.difference(_selectedDate!).inDays;
      setState(() {
        _dayCount = difference + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffed4662),
        automaticallyImplyLeading: false, // Remove the elevation
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Navigate to the previous page
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_back_ios, // Path to your image asset
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(width: 20), // Add space between image and text
            Text(
              'Cycle Update',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height, // Set height of SingleChildScrollView
          child: Stack(
            children: [
              Positioned(
                top: kToolbarHeight + 20, // Position it below the app bar with additional space
                left: 45,
                right: 45,
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 70),
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 6), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Patient on:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none, // Remove border line
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 40),
                                Container(
                                  width: 350,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.pink[200],
                                    borderRadius: BorderRadius.circular(15), // Adjust the radius to change the curve
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: Offset(0, 2), // Shadow position, you can adjust as needed
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Day: $_dayCount', // Display the day count
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 90,
                left: 30,
                right: 30,
                child: Image.asset(
                  'assets/cyclephoto.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xfffddbdc),
    );
  }
}
