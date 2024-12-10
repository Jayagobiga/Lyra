import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infertilityapp/comman.dart'; // Assuming this contains your API URL definitions

class ViewDoctor extends StatefulWidget {
  const ViewDoctor({Key? key}) : super(key: key);

  @override
  _ViewDoctorState createState() => _ViewDoctorState();
}

class _ViewDoctorState extends State<ViewDoctor> {
  List<Map<String, dynamic>> allDoctors = [];
  List<Map<String, dynamic>> displayedDoctors = [];
  String searchString = '';

  @override
  void initState() {
    super.initState();
    fetchAllDoctorsFromDatabase();
  }

  void fetchAllDoctorsFromDatabase() async {
    try {
      var response = await http.post(
        Uri.parse(viewdoctor), // Your API endpoint to get doctor list
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<dynamic> doctorsList = data['data'];
        List<Map<String, dynamic>> details = [];
        doctorsList.forEach((doctor) {
          details.add({
            'dr_userid': doctor['dr_userid'].toString(), // Convert to String
            'dr_name': doctor['dr_name'],
          });
        });

        setState(() {
          allDoctors = details;
          displayedDoctors = allDoctors.reversed.take(6).toList();
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }


  Future<void> deleteDoctor(String doctorUserId) async {
    // Show confirmation dialog before deleting the doctor
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this doctor?'),
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

    // If user confirms deletion
    if (confirmDelete == true) {
      try {
        var response = await http.post(
          Uri.parse(deletedoctor), // Your API endpoint to delete doctor
          body: {
            'userId': doctorUserId, // Ensure userId is passed as a string
          },
        );

        if (response.statusCode == 200) {
          var data = json.decode(response.body);

          if (data['status'] == 'success') {
            setState(() {
              allDoctors.removeWhere(
                      (doctor) => doctor['dr_userid'] == doctorUserId);
              displayedDoctors = allDoctors
                  .where((doctor) =>
              doctor['dr_name'].toLowerCase().contains(searchString) ||
                  doctor['dr_userid'].toString().contains(searchString))
                  .toList();
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Doctor deleted successfully.')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to delete doctor.')),
            );
          }
        } else {
          print("Error: ${response.statusCode}");
        }
      } catch (e) {
        print("Exception: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffed4662),
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
          title: Container(
            height: 60,
            alignment: Alignment.centerLeft,
            child: Text(
              'View Doctors',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Search bar
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              height: 70,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchString = value.toLowerCase();
                    displayedDoctors = allDoctors
                        .where((doctor) =>
                    doctor['dr_name']
                        .toLowerCase()
                        .contains(searchString) ||
                        doctor['dr_userid'].toString().contains(searchString))
                        .toList();
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
            // Doctor list
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: List.generate(
                      displayedDoctors.length,
                          (index) {
                        return GestureDetector(
                          onTap: () {
                            // Navigate to the DoctorPage when the doctor is tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorPage(
                                  doctorUserId: int.parse(displayedDoctors[index]['dr_userid']),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(0),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    '${displayedDoctors[index]['dr_userid']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        displayedDoctors[index]['dr_name'],
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(width: 20),
                                      GestureDetector(
                                        onTap: () {
                                          deleteDoctor(displayedDoctors[index]['dr_userid']);
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xfffddbdc),
      ),
    );
  }
}















// DoctorPage
class DoctorPage extends StatefulWidget {
  final int doctorUserId; // Change the data type to int

  const DoctorPage({Key? key, required this.doctorUserId}) : super(key: key);

  @override
  _DoctorPageState createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  Map<String, dynamic>? doctorDetails;

  @override
  void initState() {
    super.initState();
    fetchDoctorDetails();
  }

  void fetchDoctorDetails() async {
    try {
      var response = await http.post(
        Uri.parse(drprofiledisplay),
        body: {'dr_userid': widget.doctorUserId.toString()}, // Convert int to string here
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          doctorDetails = data['doctorDetails'];
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffed4662),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Text(
              "Doctor details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: doctorDetails == null
                ? Center(child: CircularProgressIndicator())
                : ListView(
              padding: EdgeInsets.all(20),
              children: [
                // Image display container
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  child: CircleAvatar(
                    radius: 70, // Adjust the radius as needed
                    backgroundImage: doctorDetails!['doctorimage'] != null && doctorDetails!['doctorimage'].isNotEmpty
                        ? NetworkImage('$drimage${doctorDetails!['doctorimage']}')
                        : AssetImage('assets/bprofile.png') as ImageProvider, // Use profile.png if no doctor image
                    // Add black border
                    foregroundColor: Colors.black,
                    child: ClipOval(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                            width: 2, // Adjust border width as needed
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Other details containers
                Column(
                  children: [
                    buildTextField('User ID', doctorDetails!['dr_userid']),
                    buildTextField('Name', doctorDetails!['dr_name']),
                    buildTextField('Email', doctorDetails!['email']),
                    buildTextField('Designation', doctorDetails!['designation']),
                    buildTextField('Contact No', doctorDetails!['contact_no']),
                  ],
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/docpro_Copy.png',
            width: 330,
            height: 300,
            fit: BoxFit.cover,
          ),
        ],
      ),
      backgroundColor: Color(0xfffddbdc),
    );
  }

  Widget buildTextField(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal:15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10),
          Text(
            ':',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 35),
          Expanded(
            child: Text(
              value != null ? value.toString() : 'N/A',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
