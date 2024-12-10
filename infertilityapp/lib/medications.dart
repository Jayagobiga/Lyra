import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infertilityapp/twelfth_page.dart';
import 'package:intl/intl.dart';
import 'comman.dart';

class MedicationsPage extends StatelessWidget {
  final String userId;
  final String name;
  final int dayDifference;

  MedicationsPage({required this.userId, required this.name, required this.dayDifference});

  @override
  Widget build(BuildContext context) {
    TextEditingController medicationController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    TextEditingController dosageController = TextEditingController();
    TextEditingController routeController = TextEditingController(); // New controller for Route

    Future<void> sendDataToBackend(BuildContext context) async {
      String medication = medicationController.text;
      String time = timeController.text;
      String dosage = dosageController.text;
      String route = routeController.text; // Retrieve route from text field
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final url = medications;

      try {
        final response = await http.post(
          Uri.parse(url),
          body: {
            'userId': userId,
            'medication': medication,
            'time': time,
            'dosage': dosage,
            'route': route, // Include route in the POST request
            'date': currentDate,
          },
        );

        if (response.statusCode == 200) {
          // Successful HTTP POST request
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TwelfthPage(userId: userId, name: name, dayDifference: dayDifference)),
          );
        } else {
          // HTTP request failed
          throw Exception('Failed to save medication details');
        }
      } catch (e) {
        // Error handling
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Failed to save medication details"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Color(0xffed4662),
          automaticallyImplyLeading: false, // Set background color to pink accent
          title: Row(
            children: [
              SizedBox(
                width: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Navigate to the previous page
                  },
                  child: Image.asset(
                    'assets/arrow.png', // Path to your image asset
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: 30), // Add some space between image and text
              Text(
                'Medications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView( // Wrap the Column with SingleChildScrollView
            child: Column(
              children: [
                SizedBox(height: 40), // Spacing from the AppBar
                Center(
                  child: SizedBox(
                    height: 60,
                    width: 330,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Date',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            width: 1, // Width of the vertical line
                            height: 80, // Height of the vertical line
                            color: Colors.black,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Text(
                              DateFormat('dd-MM-yyyy').format(DateTime.now()),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40), // Spacing below the rectangle box
                Padding(
                  padding: const EdgeInsets.only(right: 250.0),
                  child: Text(
                    'Medication:',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 10), // Spacing before the TextField
                Container(
                  width: 350,
                  height: 53,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: 'CLOMIPHENE CITRATE',
                          child: Text('  CLOMIPHENE CITRATE'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'LETROZOLE',
                          child: Text('  LETROZOLE'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'TAMOXIFEN',
                          child: Text('  TAMOXIFEN'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'MICRONISED',
                          child: Text('  MICRONISED'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'METFORMIN',
                          child: Text('  METFORMIN'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'HCG',
                          child: Text('  HCG'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'HMG',
                          child: Text('  HMG'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'PROLUTON',
                          child: Text('  PROLUTON'),
                        ),
                      ],
                      onChanged: (String? value) {
                        medicationController.text = value ?? ''; // Handle the selected gender here
                        print('Selected Medication: $value');
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20), // Spacing below the rectangle box
                Padding(
                  padding: const EdgeInsets.only(right: 290.0),
                  child: Text(
                    'Route:',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 10), // Spacing before the TextField
                Container(
                  width: 350,
                  height: 53,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: 'Oral',
                          child: Text('  Oral'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Injection',
                          child: Text('  Injection'),
                        ),
                      ],
                      onChanged: (String? value) {
                        routeController.text = value ?? ''; // Handle the selected gender here
                        print('Selected Route: $value');
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20), // Spacing below the rectangle box
                Padding(
                  padding: const EdgeInsets.only(right: 310.0),
                  child: Text(
                    'Time:',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 10), // Spacing before the TextField
                Container(
                  width: 350,
                  height: 53,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextField(
                      controller: timeController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20), // Spacing below the rectangle box
                Padding(
                  padding: const EdgeInsets.only(right: 220.0),
                  child: Text(
                    'Dosage(mg/ml):',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 10), // Spacing before the TextField
                Container(
                  width: 350,
                  height: 53,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextField(
                      controller: dosageController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 90), // Spacing before the 'Next' button
                SizedBox(
                  height: 50,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      sendDataToBackend(context); // Call the function to send data
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Round the corners
                      ),
                      backgroundColor: Color(0xffed4662), // Set the background color to pink
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(fontSize: 20,color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20), // Spacing at the bottom of the page
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xfffddbdc),
    );
  }
}
