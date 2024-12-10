import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infertilityapp/comman.dart';
import 'package:infertilityapp/fourth_page.dart';
import 'package:infertilityapp/plogin.dart';

class PProfilePage extends StatefulWidget {
  final String userId;
  final String name;
  // Change Int to int

  PProfilePage({required this.userId, required this.name}); // Update constructor

  @override
  _PProfilePageState createState() => _PProfilePageState();
}

class _PProfilePageState extends State<PProfilePage> {
  late String name;
  late String imageUrl;
  late String mobileNumber;
  late String yearOfMarriage;
  late String bloodGroup;

  @override
  void initState() {
    super.initState();
    imageUrl = '';
    mobileNumber = '';
    yearOfMarriage = '';
    bloodGroup = '';
    name='';
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.post(
      Uri.parse(viewpatient),
      body: {'userId': widget.userId},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status']) {
        setState(() {
          mobileNumber = data['patientDetails']['ContactNo'];
          name = data['patientDetails']['Name'];
          yearOfMarriage = data['patientDetails']['Marriageyear'];
          bloodGroup = data['patientDetails']['Bloodgroup'];
          final image = data['patientDetails']['image'];
          if (image != null && image.isNotEmpty) {
            imageUrl = image.startsWith('http') ? image : '$patientimage$image';
          } else {
            imageUrl = ''; // Set imageUrl to empty if image is null or empty
          }
        });
        print('Image fetched successfully'); // Print statement
      } else {
        print(data['message']);
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffed4662), // Set the background color
        title: Text(
          'Patient Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold, // Make the text bold
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PLoginPage(userId: widget.userId, name: widget.name)),
            );
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
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FourthPage()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/logout.png',
                width: 26,
                height: 26,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height:40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  imageUrl.isNotEmpty
                      ? Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2), // Add black border
                    ),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                  )
                      : CircularProgressIndicator(),
                  SizedBox(height: 40),
                  buildRow('Name', name),
                  buildRow('Patient ID', widget.userId),
                  buildRow('Mobile Number', mobileNumber),
                  buildRow('Blood Group', bloodGroup),
                  buildRow('Year of Marriage', yearOfMarriage),
                ],
              ),
            ),
            SizedBox(height:0),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/docpro_Copy.png', // Replace with your bottom image path
                width: 900, // Set image width to 900
                height: 360, // Set image height to 260
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xfffddbdc),
    );
  }

  Widget buildRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width:10),
          Text(
            ':',
            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              value != null ? value.toString() : 'N/A',
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
