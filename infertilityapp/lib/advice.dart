import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infertilityapp/comman.dart';
import 'package:infertilityapp/twelfth_page.dart';
import 'package:infertilityapp/viewadvice2.dart';
import 'package:intl/intl.dart';


class AdvicePage extends StatelessWidget {
  final String userId;
  final String name;
  final int dayDifference;

  AdvicePage({required this.userId,required this.name,required this.dayDifference});

  final TextEditingController _adviceController = TextEditingController();

  Future<void> _addAdvice(BuildContext context) async {
    // Get the current date
    DateTime now = DateTime.now();
    String formattedDate = "${now.year}-${now.month}-${now.day}";

    // Get the entered advice
    String advice = _adviceController.text;

    // Send data to the PHP backend script
    final response = await http.post(
      Uri.parse(addadvice),
      body: {
        'userid': userId,
        'date': formattedDate,
        'addadvice': advice,
      },
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Successful request
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Your advice is added successfully"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TwelfthPage(userId: userId, name: name, dayDifference: dayDifference)),
                  );
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      // Request failed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Failed to add advice. Please try again later."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Dismiss the dialog
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
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Navigate to the previous page
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(width: 20),
            Text(
              'Add Advices',
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
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: kToolbarHeight + 10,
                left: 40,
                right: 40,
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),
                      Container(
                        height: 370,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Date:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 100),
                                SingleChildScrollView(
                                  child: TextField(
                                    controller: _adviceController,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      hintText: 'Text here!!!',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                                    ),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
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
                bottom: 320,
                left: 130,
                right: 130,
                child: ElevatedButton(
                  onPressed: () => _addAdvice(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffed4662),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'ADD',
                    style: TextStyle(
                      color: Colors.white,
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
    );
  }
}
