import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'fifth_page.dart'; // Import the fifth page to navigate to it
import 'twelfth_page.dart';// Import the twelfth page to navigate to it
import 'comman.dart';

class EleventhPage extends StatefulWidget {
  final String userId; // Define userId variable
  final int dayDifference;

  // Constructor to receive the userId
  EleventhPage({required this.userId, required this.dayDifference});

  @override
  _EleventhPageState createState() => _EleventhPageState();
}

class _EleventhPageState extends State<EleventhPage> {
  List<dynamic> patients = [];
  List<dynamic> displayedPatients = []; // List to hold displayed patients
  List<dynamic> searchResults = []; // List to hold search results
  TextEditingController _searchController = TextEditingController();
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    // Fetch patient data when the widget is initialized
    fetchPatients();
  }

  // Method to fetch patient data from the server
  void fetchPatients() async {
    // Define your API endpoint URL
    String apiUrl = patientlist;

    try {
      // Make HTTP POST request to fetch patient data
      var response = await http.post(Uri.parse(apiUrl));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the JSON response
        var data = json.decode(response.body);

        // Extract all patients' details from the response
        List<dynamic> patientsList = data['data'];

        // Take the latest 6 patients for display
        setState(() {
          patients = patientsList;
          displayedPatients = patientsList.reversed.take(6).toList();
        });
      } else {
        // Handle the error
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      // Handle any exceptions
      print("Error: $error");
    }
  }
  Future<void> deletePatient(String userId, int index) async {
    // Show confirmation dialog before deleting the patient
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this patient?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Close the dialog and return false
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Close the dialog and return true
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    // If the user confirms deletion
    if (confirmDelete == true) {
      String apiUrl = deletepatient;

      try {
        var response = await http.post(
          Uri.parse(apiUrl),
          body: {'userId': userId},
        );

        if (response.statusCode == 200) {
          var data = json.decode(response.body);

          if (data['status'] == 'success') {
            // Remove patient from the list and update the UI
            setState(() {
              displayedPatients.removeAt(index);
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Patient deleted successfully.'),
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to delete patient: ${data['message']}'),
            ));
          }
        } else {
          print("Error: ${response.statusCode}");
        }
      } catch (error) {
        print("Error: $error");
      }
    }
  }

  Future<String> fetchPatientImage(String userId) async {
    final response = await http.post(
      Uri.parse(viewpatient),
      body: {'userId': userId},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status']) {
        final image = data['patientDetails']['image'];
        if (image != null && image.isNotEmpty) {
          return image.startsWith('http')
              ? image
              : '$patientimage$image';
        } else {
          return ''; // Return empty if image is null or empty
        }
      } else {
        print(data['message']);
        return '';
      }
    } else {
      print('Error: ${response.statusCode}');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => FifthPage(
                  userId: widget.userId,
                  dayDifference: widget.dayDifference)),
          ModalRoute.withName('/'),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffed4662),
          automaticallyImplyLeading: false, // Disable automatic leading widget
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FifthPage(
                          userId: widget.userId,
                          dayDifference: widget.dayDifference,
                        )), // Navigate to the fifth page
                  );
                },
                child: Icon(
                  Icons.arrow_back_ios, // Path to your image asset
                  size: 30,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 10), // Add spacing between the image and text
              Text(
                'View Patients',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              height: 70,
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  // Filter the patients list based on the search query
                  setState(() {
                    if (value.isEmpty) {
                      // If the search query is empty, display the latest patients
                      displayedPatients = patients.reversed.take(6).toList();
                    } else {
                      // Filter patients by both name and user ID
                      searchResults = patients
                          .where((patient) =>
                      patient['Name']
                          .toLowerCase()
                          .contains(value.toLowerCase()) ||
                          patient['Userid']
                              .toString()
                              .contains(value.toLowerCase()))
                          .toList();
                      // Display only older patients when searching
                      displayedPatients = searchResults
                          .where((patient) => !displayedPatients.contains(patient))
                          .toList();
                    }
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: displayedPatients.length, // Use displayedPatients list here
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          FutureBuilder<String>(
                            future: fetchPatientImage(displayedPatients[index]['Userid'].toString()),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError || snapshot.data == '') {
                                return Image.asset(
                                  'assets/bprofile.png',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.contain,
                                );
                              } else {
                                return Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1, // Adjust the width of the border as needed
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(snapshot.data!),
                                  ),
                                );
                              }
                            },
                          ),
                          SizedBox(width: 15), // Add spacing between the image and text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name: ${displayedPatients[index]['Name']}', // Display patient's name
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'User id: ${displayedPatients[index]['Userid']}', // Display patient's user ID
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Call deletePatient method
                              deletePatient(displayedPatients[index]['Userid'].toString(), index);
                            },
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      // Get the userId and name of the selected patient
                      String userId = displayedPatients[index]['Userid'].toString();
                      String name = displayedPatients[index]['Name'];


                      // Navigate to the patient's details page and pass the User ID and name as parameters
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TwelfthPage(
                            userId: userId,
                            name: name,
                            dayDifference: widget.dayDifference,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xfffddbdc),
      ),
    );
  }
}
