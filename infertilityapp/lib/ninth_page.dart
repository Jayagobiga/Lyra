import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'fifth_page.dart';
import 'comman.dart';

class NinthPage extends StatelessWidget {
  final String userId;
  final int dayDifference;

  NinthPage({required this.userId,required this.dayDifference});

  TextEditingController _specificationsController = TextEditingController();

  Future<void> _saveSpecifications(BuildContext context) async {
    // Get the entered specifications
    String specifications = _specificationsController.text;

    // Prepare the POST request body
    Map<String, String> requestBody = {
      'userid': userId,
      'Specifications': specifications,
    };

    // Send the POST request
    http.Response response = await http.post(
      Uri.parse(speci),
      body: requestBody,
    );

    // Parse the response JSON
    Map<String, dynamic> responseData = json.decode(response.body);

    if (responseData['status'] == true) {
      // Show success dialog if the specifications were saved successfully
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Your specifications were added successfully."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FifthPage(userId: userId,dayDifference: dayDifference)),
                  );
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      // Show error dialog if there was an error saving the specifications
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(responseData['message']),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
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
            SizedBox(width: 5),
            Text(
              'Specifications',
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
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/sqbackground.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 450,
                  ),
                  Image.asset(
                    'assets/mother.png',
                    width: 1800,
                    height: 230,
                  ),
                ],
              ),
            ),
            Positioned(
              top: kToolbarHeight,
              left: 40,
              right: 40,
              child: Container(
                width: double.infinity,
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
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: TextField(
                        controller: _specificationsController,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Enter here!!!',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
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
      bottomNavigationBar: BottomAppBar(
        color: Color(0xffed4662),
        child: GestureDetector(
          onTap: () {
            _saveSpecifications(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: SizedBox()),
              Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
