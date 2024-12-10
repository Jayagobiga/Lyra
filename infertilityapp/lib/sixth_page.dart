import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:infertilityapp/tenth_page.dart';
import 'comman.dart';

class SixthPage extends StatefulWidget {
  final String userId;
  final int dayDifference;

  SixthPage({required this.userId, required this.dayDifference});

  @override
  _SixthPageState createState() => _SixthPageState();
}

class _SixthPageState extends State<SixthPage> {
  Map<String, dynamic>? doctorDetails;

  @override
  void initState() {
    super.initState();
    fetchDoctorDetails();
  }

  Future<void> fetchDoctorDetails() async {
    try {
      var response = await http.post(
        Uri.parse(drprofiledisplay),
        body: {'dr_userid': widget.userId.toString()},
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
        title: Text(
          "Doctor details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: doctorDetails == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      '$drimage${doctorDetails!['doctorimage']}',
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height:40),
                buildRow('UserId', doctorDetails!['dr_userid']),
                buildTextField('Name', doctorDetails!['dr_name']),
                buildTextField('Email', doctorDetails!['email']),
                buildTextField('Designation', doctorDetails!['designation']),
                buildTextField('Contact Number', doctorDetails!['contact_no']),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 100), // Adjust padding as needed
                  height: 40, // Adjust height as needed
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TenthPage(
                            doctorDetails: doctorDetails!,
                            userId: widget.userId,
                            dayDifference: widget.dayDifference,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffed4662), // Adjust color as needed
                        borderRadius: BorderRadius.circular(8), // Adjust border radius as needed
                      ),
                      child: Center(
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Colors.white, // Adjust text color as needed
                            fontSize: 15, // Adjust text size as needed
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Image.asset(
                  'assets/docpro_Copy.png',
                  width: 330,
                  height: 273,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
      backgroundColor: Color(0xfffddbdc),
    );
  }

  Widget buildRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width:10),
          Text(
            ':',
            style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 35),
          Expanded(
            child: Text(
              value != null ? value.toString() : 'N/A',
              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal:5),
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
          SizedBox(width:10),
          Text(
            ':',
            style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 35),
          Expanded(
            child: Text(
              value != null ? value.toString() : 'N/A',
              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}


