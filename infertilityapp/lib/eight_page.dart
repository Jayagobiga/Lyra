import 'package:flutter/material.dart';
import 'package:infertilityapp/comman.dart';
import 'fifth_page.dart';
import 'ninth_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EightPage extends StatefulWidget {
  final String userId;
  final int dayDifference;

  EightPage({required this.userId, required this.dayDifference});

  @override
  _EightPageState createState() => _EightPageState();
}

class _EightPageState extends State<EightPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _significanthistoryController = TextEditingController();
  // final TextEditingController _volumeController = TextEditingController();
  // final TextEditingController _concentrationController = TextEditingController();
  // final TextEditingController _totalSpermNumberController = TextEditingController();
  // final TextEditingController _motilityController = TextEditingController();
  // final TextEditingController _progressiveMotilityController = TextEditingController();
  // final TextEditingController _morphologyController = TextEditingController();
  // final TextEditingController _viabilityController = TextEditingController();
  String smoking = '';
  String alcohol = '';
  String sexualdisfunction = '';

  Future<void> sendDataToBackend() async {
    var url = addspouse;
    var response = await http.post(Uri.parse(url), body: {
      'userid': widget.userId,
      'name': _nameController.text,
      'contactno': _contactNoController.text,
      'age': _ageController.text,
      'occupation': _occupationController.text,
      'significanthistory': _significanthistoryController.text,
      'smoking': smoking,
      'alcohol': alcohol,
      'sexualdisfunction': sexualdisfunction,
      // 'Volume': _volumeController.text,
      // 'Concentration': _concentrationController.text,
      // 'Total_sperm_number': _totalSpermNumberController.text,
      // 'Motility': _motilityController.text,
      // 'Progressive_Motility': _progressiveMotilityController.text,
      // 'Morphology': _morphologyController.text,
      // 'Viability': _viabilityController.text,
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status']) {
        // Data successfully sent to backend
        // Show dialog when NEXT is tapped
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Colors.black),
              ),
              title: Text(
                'Do you have undergone this treatment before?',
                style: TextStyle(fontSize: 18),
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NinthPage(userId: widget.userId, dayDifference: widget.dayDifference)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Yes',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FifthPage(
                                userId: widget.userId,
                                dayDifference: widget.dayDifference)),
                        ModalRoute.withName('/'),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'No',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        // Error occurred
        // Show error message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(data['message']),
              actions: <Widget>[
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
    } else {
      // Error occurred
      // Show error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to connect to the server. Please try again later.'),
            actions: <Widget>[
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

  void _setSmoking(String value) {
    setState(() {
      smoking = value;
    });
  }

  void _setAlcohol(String value) {
    setState(() {
      alcohol = value;
    });
  }

  void _setSexualDisfunction(String value) {
    setState(() {
      sexualdisfunction = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffed4662),
        title: Text(
          'Add Spouse',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Navigate to the previous page (SixthPage)
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Name',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 100),
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    'Contact Number',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: _contactNoController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    'Occupation',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 50),
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: _occupationController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    'Age',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 113),
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    'Significant\nHistory',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width:55),
                  Container(
                    width: 170,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: _significanthistoryController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                'Personal History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // SizedBox(height: 20),
              // Row(
              //   children: [
              //     Text(
              //       'Volume (ml)',
              //       style: TextStyle(fontSize: 16),
              //     ),
              //     SizedBox(width: 45),
              //     Container(
              //       width: 200,
              //       height: 45,
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         border: Border.all(color: Colors.black),
              //       ),
              //       child: TextField(
              //         controller: _volumeController,
              //         decoration: InputDecoration(
              //           border: InputBorder.none,
              //           contentPadding: EdgeInsets.all(8),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 20),
              // Row(
              //   children: [
              //     Text(
              //       'Concentration\n(million/ml)',
              //       style: TextStyle(fontSize: 16),
              //     ),
              //     SizedBox(width:30),
              //     Container(
              //       width: 200,
              //       height: 45,
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         border: Border.all(color: Colors.black),
              //       ),
              //       child: TextField(
              //         controller: _concentrationController,
              //         decoration: InputDecoration(
              //           border: InputBorder.none,
              //           contentPadding: EdgeInsets.all(8),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 20),
              // Row(
              //   children: [
              //     Text(
              //       'Total Sperm\nNumber (million)',
              //       style: TextStyle(fontSize: 16),
              //     ),
              //     SizedBox(width:7),
              //     Container(
              //       width: 200,
              //       height: 45,
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         border: Border.all(color: Colors.black),
              //       ),
              //       child: TextField(
              //         controller: _totalSpermNumberController,
              //         decoration: InputDecoration(
              //           border: InputBorder.none,
              //           contentPadding: EdgeInsets.all(8),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 20),
              // Row(
              //   children: [
              //     Text(
              //       'Motility (%)',
              //       style: TextStyle(fontSize: 16),
              //     ),
              //     SizedBox(width: 55),
              //     Container(
              //       width: 200,
              //       height: 45,
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         border: Border.all(color: Colors.black),
              //       ),
              //       child: TextField(
              //         controller: _motilityController,
              //         decoration: InputDecoration(
              //           border: InputBorder.none,
              //           contentPadding: EdgeInsets.all(8),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 20),
              // Row(
              //   children: [
              //     Text(
              //       'Progressive\nMotility (%)',
              //       style: TextStyle(fontSize: 16),
              //     ),
              //     SizedBox(width:50),
              //     Container(
              //       width: 200,
              //       height: 45,
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         border: Border.all(color: Colors.black),
              //       ),
              //       child: TextField(
              //         controller: _progressiveMotilityController,
              //         decoration: InputDecoration(
              //           border: InputBorder.none,
              //           contentPadding: EdgeInsets.all(8),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 20),
              // Row(
              //   children: [
              //     Text(
              //       'Morphology (%)',
              //       style: TextStyle(fontSize: 16),
              //     ),
              //     SizedBox(width:18),
              //     Container(
              //       width: 200,
              //       height: 45,
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         border: Border.all(color: Colors.black),
              //       ),
              //       child: TextField(
              //         controller: _morphologyController,
              //         decoration: InputDecoration(
              //           border: InputBorder.none,
              //           contentPadding: EdgeInsets.all(8),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 20),
              // Row(
              //   children: [
              //     Text(
              //       'Viability (%)',
              //       style: TextStyle(fontSize: 16),
              //     ),
              //     SizedBox(width:50),
              //     Container(
              //       width: 200,
              //       height: 45,
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         border: Border.all(color: Colors.black),
              //       ),
              //       child: TextField(
              //         controller: _viabilityController,
              //         decoration: InputDecoration(
              //           border: InputBorder.none,
              //           contentPadding: EdgeInsets.all(8),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    'Smoking',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 80),
                  GestureDetector(
                    onTap: () => _setSmoking('yes'),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: smoking == 'yes' ? Colors.black : Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('Yes'),
                      ],
                    ),
                  ),
                  SizedBox( width:60 ),
                  GestureDetector(
                    onTap: () => _setSmoking('no'),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: smoking == 'no' ? Colors.black : Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('No'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Alcohol',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 90),
                  GestureDetector(
                    onTap: () => _setAlcohol('yes'),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: alcohol == 'yes' ? Colors.black : Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('Yes'),
                      ],
                    ),
                  ),
                  SizedBox( width:60 ),
                  GestureDetector(
                    onTap: () => _setAlcohol('no'),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: alcohol == 'no' ? Colors.black : Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('No'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Sexual\nDisfunction',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width:56),
                  GestureDetector(
                    onTap: () => _setSexualDisfunction('yes'),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: sexualdisfunction == 'yes' ? Colors.black : Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('Yes'),
                      ],
                    ),
                  ),
                  SizedBox( width:60 ),
                  GestureDetector(
                    onTap: () => _setSexualDisfunction('no'),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: sexualdisfunction == 'no' ? Colors.black : Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('No'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: sendDataToBackend,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffed4662), // Background color
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(fontSize: 18,color: Colors.white),
                  ),
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
