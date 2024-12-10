import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infertilityapp/comman.dart';

class PMedicationPage extends StatefulWidget {
  final String userId;
  PMedicationPage({required this.userId});

  @override
  _PMedicationPageState createState() => _PMedicationPageState();
}

class _PMedicationPageState extends State<PMedicationPage> {
  List<Map<String, dynamic>> medicationDetails = [];

  // Function to fetch medication details from the server
  Future<void> fetchMedicationDetails(String userId) async {
    final response = await http.post(
      Uri.parse(viewmed),
      body: {'userid': userId},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status']) {
        // Sort the medication details by date
        List<Map<String, dynamic>> sortedMedications = List<Map<String, dynamic>>.from(data['patientDetails']);
        sortedMedications.sort((a, b) => b['date'].compareTo(a['date']));
        // Take only the latest 5 medication details
        setState(() {
          medicationDetails = sortedMedications.take(5).toList();
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
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
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch medication details'),
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

  @override
  void initState() {
    super.initState();
    fetchMedicationDetails(widget.userId);
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
                child: Image.asset(
                  'assets/arrow.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 30),
            Text(
              'View Medications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: medicationDetails.length,
        itemBuilder: (context, index) {
          // Access medication details using medicationDetails[index]
          var medication = medicationDetails[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 25.0),
            child: Container(
              height: 190,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:BorderRadius.circular(20),
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                  width: 0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Medication: ${medication['Medication']}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Route: ${medication['Route']}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Dosage: ${medication['Dosage']}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Timing: ${medication['Time']}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Date: ${medication['date']}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      backgroundColor: Color(0xfffddbdc),
    );
  }
}
