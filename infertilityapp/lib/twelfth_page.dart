import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infertilityapp/comman.dart';
import 'package:infertilityapp/cycle.dart';
import 'package:infertilityapp/eleventh_page.dart';
import 'package:infertilityapp/fifth_page.dart';
import 'package:infertilityapp/graph.dart';
import 'package:infertilityapp/medications.dart';
import 'package:infertilityapp/reports.dart';
import 'package:infertilityapp/results.dart';
import 'package:infertilityapp/second_page.dart';
import 'package:infertilityapp/semenanalysis.dart';
import 'package:infertilityapp/spouse.dart';
import 'package:infertilityapp/third_page.dart';
import 'package:infertilityapp/viewadvice2.dart';
import 'package:infertilityapp/viewstatus.dart';

class TwelfthPage extends StatefulWidget {
  final String userId;
  final String name;
  final int dayDifference;

  TwelfthPage({required this.userId, required this.name, required this.dayDifference});

  @override
  _TwelfthPageState createState() => _TwelfthPageState();
}

class _TwelfthPageState extends State<TwelfthPage> {
  Map<String, dynamic>? patientDetails;
  List<Map<String, dynamic>>? medications;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPatientDetails();
    fetchMedications(widget.userId);
  }

  Future<void> fetchPatientDetails() async {
    final response = await http.post(
      Uri.parse(viewpatient),
      body: {'userId': widget.userId},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == true) {
        setState(() {
          patientDetails = responseData['patientDetails'];
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          errorMessage = responseData['message'];
          isLoading = false;
        });
      }
    } else {
      setState(() {
        hasError = true;
        errorMessage = 'Server error. Please try again later.';
        isLoading = false;
      });
    }
  }

  Future<void> fetchMedications(String userId) async {
    try {
      var response = await http.post(
        Uri.parse(viewmed),
        body: {'userid': userId},
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status']) {
          List<Map<String, dynamic>> sortedMedications = List<
              Map<String, dynamic>>.from(jsonData['patientDetails']);
          sortedMedications.sort((a, b) => b['date'].compareTo(a['date']));
          setState(() {
            medications = sortedMedications.take(5).toList();
          });
        } else {
          print(jsonData['message']);
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to the EleventhPage when back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>
              EleventhPage(
                  userId: widget.userId, dayDifference: widget.dayDifference)),
        );
        return false; // Prevent the default back button behavior
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            backgroundColor: Color(0xffed4662),
            leading: GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FifthPage(
                              userId: widget.userId,
                              dayDifference: widget.dayDifference)),
                  ModalRoute.withName('/'),
                );
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 30,
                color: Colors.black,
              ),
            ),
            title: Row(
              children: [
                SizedBox(width: 1),
                Text(
                  'Patient Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            automaticallyImplyLeading: true,
            actions: [
              GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset(
                    'assets/menu.png',
                    width: 30,
                    height: AppBar().preferredSize.height,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: Container(
          height: 850,
          width: 250,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 100,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.pink[100],
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            'assets/arrow.png',
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          widget.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Image.asset(
                          'assets/pen.png',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/medications.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  title: Text('Medications'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          MedicationsPage(userId: widget.userId, name: widget
                              .name, dayDifference: widget.dayDifference)),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/sreport.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  title: Text('Spouse Reports'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          SemenAnalysisPage(userId: widget.userId, name: widget
                              .name, dayDifference: widget.dayDifference)),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/report.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  title: Text('View Reports'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          ReportsPage(userId: widget.userId,
                              name: widget.name,
                              dayDifference: widget.dayDifference)),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/graph.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  title: Text('View Graph'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          GraphPage(userId: widget.userId,
                              name: widget.name,
                              dayDifference: widget.dayDifference)),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/spouse.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  title: Text('Spouse Details'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          SpousePage(userId: widget.userId, name: widget.name)),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/status.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  title: Text('View Status'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          ViewStatusPage(userId: widget.userId)),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/advice.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  title: Text('View Advice'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          ViewAdvicePage2(userId: widget.userId, name: widget
                              .name, dayDifference: widget.dayDifference)),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/cycle.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  title: Text('Cycle Update'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          CyclePage(userId: widget.userId)),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/calendar.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  title: Text('View Results'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          ResultsPage(userId: widget.userId)),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/logout.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  title: Text('Logout'),
                  onTap: () async {
                    bool? confirmLogout = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm Logout'),
                          content: Text('Are you sure you want to log out?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(
                                    false); // Close the dialog and return false
                              },
                              child: Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(
                                    true); // Close the dialog and return true
                              },
                              child: Text('Yes'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmLogout == true) {
                      // Perform logout logic here
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SecondPage()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : hasError
            ? Center(child: Text(errorMessage))
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (patientDetails!['image'] != null &&
                    patientDetails!['image'].isNotEmpty)
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          '$patientimage${patientDetails!['image']}',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 16),
                buildSectionHeader('Patient Details'),
                buildDetailsRow('Name', patientDetails!['Name']),
                buildDetailsRow('Contact No', patientDetails!['ContactNo']),
                buildDetailsRow('Age', patientDetails!['Age']),
                // buildDetailsRow('Gender', patientDetails!['Gender']),
                buildDetailsRow('Height', patientDetails!['Height']),
                buildDetailsRow('Weight', patientDetails!['Weight']),
                buildDetailsRow(
                    'Marriage Year', patientDetails!['Marriageyear']),
                buildDetailsRow('Blood Group', patientDetails!['Bloodgroup']),
                buildDetailsRow(
                    'Medical History', patientDetails!['Medicalhistory']),
                buildDetailsRow(
                    'Specification', patientDetails!['Specifications']),
                buildDetailsRow('Occupation', patientDetails!['occupation']),
                buildDetailsRow('BMI', patientDetails!['BMI']),
                buildDetailsRow('Contraceptive History',
                    patientDetails!['contraceptive_history']),
                buildDetailsRow('Last Menstrual Period',
                    patientDetails!['last_menstrual_period']),
                buildDetailsRow(
                    'Menstrual History', patientDetails!['menstrual_history']),
                buildDetailsRow('Flow', patientDetails!['flow']),
                buildDetailsRow(
                    'Consanguineous', patientDetails!['consanguineous']),
                buildDetailsRow(
                    'Coital History', patientDetails!['coital_history']),
                buildDetailsRow(
                    'Obstetric History', patientDetails!['obstetric_history']),
                buildDetailsRow(
                    'Surgical History', patientDetails!['surgical_history']),
                buildDetailsRow('Smoking', patientDetails!['smoking']),
                buildDetailsRow('Alcohol', patientDetails!['alcohol']),
                if (medications != null && medications!.isNotEmpty) ...[
                  buildSectionHeader('Medications'),
                  ...medications!.map((medication) =>
                      buildMedicationCard(medication)).toList(),
                ],
              ],
            ),
          ),
        ),
        backgroundColor: Color(0xfffddbdc),
      ),
    );
  }

  Widget buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.pinkAccent, // Adjust color as needed
        ),
      ),
    );
  }

  Widget buildDetailsRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(label,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget buildMedicationCard(Map<String, dynamic> medication) {
    return Card(
      child: ListTile(
        title: Text('Medication: ${medication['Medication']}'),
        subtitle: Text('Date: ${medication['date']}'),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            // Show a confirmation dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm Deletion'),
                  content: Text(
                      'Are you sure you want to delete this medication?'),
                  actions: [
                    // Cancel button
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Cancel'),
                    ),
                    // Delete button
                    TextButton(
                      onPressed: () {
                        deleteMedication(
                            medication); // Call the delete function with the medication data
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Delete'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void deleteMedication(Map<String, dynamic> medication) async {
    // Send the POST request to your PHP backend to delete the medication
    final response = await http.post(
      Uri.parse(deletemed),
      body: {
        'userid': widget.userId, // Provide the user's ID
        'medication': medication['Medication'], // Provide the medication name
        'date': medication['date'], // Provide the date
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['status'] == 'success') {
        // Handle successful deletion, update the UI
        print('Medication deleted successfully.');

        // Assuming you have a list of medications in the state (medications list):
        setState(() {
          // Remove the deleted medication from the list
          medications?.removeWhere((item) =>
          item['Medication'] == medication['Medication']);
        });
      } else {
        // Handle error if no medication was deleted
        print('Error: ${responseBody['message']}');
      }
    } else {
      // Handle network error
      print('Failed to delete medication.');
    }
  }
}

