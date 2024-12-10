import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:infertilityapp/comman.dart';
import 'package:infertilityapp/twelfth_page.dart';

class SemenAnalysisPage extends StatefulWidget {
  final String userId;
  final String name;
  final int dayDifference;

  SemenAnalysisPage({required this.userId,required this.name, required this.dayDifference});

  @override
  _SemenAnalysisPageState createState() => _SemenAnalysisPageState();
}

class _SemenAnalysisPageState extends State<SemenAnalysisPage> {
  final TextEditingController _volumeController = TextEditingController();
  final TextEditingController _concentrationController = TextEditingController();
  final TextEditingController _totalSpermNumberController = TextEditingController();
  final TextEditingController _motilityController = TextEditingController();
  final TextEditingController _progressiveMotilityController = TextEditingController();
  final TextEditingController _morphologyController = TextEditingController();
  final TextEditingController _viabilityController = TextEditingController();

  Future<void> sendSemenDataToBackend() async {
    var url = addspouse;
    var response = await http.post(Uri.parse(url), body: {
      'userid': widget.userId,
      'Volume': _volumeController.text,
      'Concentration': _concentrationController.text,
      'Total_sperm_number': _totalSpermNumberController.text,
      'Motility': _motilityController.text,
      'Progressive_Motility': _progressiveMotilityController.text,
      'Morphology': _morphologyController.text,
      'Viability': _viabilityController.text,
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status']) {
        // Handle successful response
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Data submitted successfully'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TwelfthPage(userId: widget.userId, name: widget.name, dayDifference: widget.dayDifference)),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Handle error response
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
      // Handle server error
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
          child: Text('OK'),),
          ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffed4662),
        title: Text(
          'Semen Analysis',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
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
                    'Volume (ml)',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 40),
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: _volumeController,
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
                    'Concentration\n(million/ml)',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 25),
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: _concentrationController,
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
                    'Total Sperm\nNumber \n(million)',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 40),
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: _totalSpermNumberController,
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
                    'Motility (%)',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width:50),
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: _motilityController,
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
                    'Progressive\nMotility (%)',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 40),
                  Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: _progressiveMotilityController,
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
                    'Morphology (%)',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width:10),
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: _morphologyController,
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
                    'Viability(%)',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width:50),
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: _viabilityController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: sendSemenDataToBackend,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    backgroundColor: Color(0xffed4662),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
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
