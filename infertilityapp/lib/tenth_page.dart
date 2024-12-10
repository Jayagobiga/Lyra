import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:infertilityapp/comman.dart';
import 'package:infertilityapp/fifth_page.dart';

class TenthPage extends StatefulWidget {
  final Map<String, dynamic> doctorDetails;
  final String userId;
  final int dayDifference;

  TenthPage({required this.doctorDetails,required this.userId,required this.dayDifference});

  @override
  _TenthPageState createState() => _TenthPageState();
}

class _TenthPageState extends State<TenthPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _designationController;
  late TextEditingController _contactController;

  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.doctorDetails['dr_name']);
    _emailController =
        TextEditingController(text: widget.doctorDetails['email']);
    _designationController =
        TextEditingController(text: widget.doctorDetails['designation']);
    _contactController =
        TextEditingController(text: widget.doctorDetails['contact_no']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _designationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _submitForm() async {
    // Print the values of form fields before submitting the form
    print('Name: ${_nameController.text}');
    print('Email: ${_emailController.text}');
    print('Designation: ${_designationController.text}');
    print('Contact Number: ${_contactController.text}');

    try {
      var uri = Uri.parse(
          drprofileedit);
      var request = http.MultipartRequest('POST', uri);

      request.fields['userId'] = widget.doctorDetails['dr_userid'];
      request.fields['dr_name'] = _nameController.text;
      request.fields['email'] = _emailController.text;
      request.fields['designation'] = _designationController.text;
      request.fields['contact_no'] = _contactController.text;

      // Check if an image is selected
      if (_image != null) {
        request.files.add(
            await http.MultipartFile.fromPath('doctorimage', _image!.path));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')));
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  FifthPage(userId: widget.userId,
                      dayDifference: widget.dayDifference)
          ),
        );
      } else {
        // Error
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile')));
      }
    } catch (e) {
      print("Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')));
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
          "Edit Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.0, 70.0, 20.0, 20.0),
        // Adjust top padding only
        child: Card(
          elevation: 4, // Add elevation to the card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10), // Add border radius to the card
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  onTap: _getImage,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: _image == null
                        ? CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(
                          '$drimageedit${widget
                              .doctorDetails['doctorimage']}'),
                      backgroundColor: Colors.transparent,
                    )
                        : CircleAvatar(
                      radius: 70,
                      backgroundImage: FileImage(_image!),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: Container(
                    width: 270, // Adjust width as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.pink[200],
                    ),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: Container(
                    width: 270, // Adjust width as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.pink[200],
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: Container(
                    width: 270, // Adjust width as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.pink[200],
                    ),
                    child: TextFormField(
                      controller: _designationController,
                      decoration: InputDecoration(
                        labelText: 'Designation',
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: Container(
                    width: 270, // Adjust width as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.pink[200],
                    ),
                    child: TextFormField(
                      controller: _contactController,
                      decoration: InputDecoration(
                        labelText: 'Contact Number',
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: _submitForm,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 110),
                    // Adjust padding as needed
                    child: Container(
                      width: double.infinity, // Adjust width as needed
                      height: 35, // Adjust height as needed
                      decoration: BoxDecoration(
                        color: Color(0xffed4662), // Adjust color as needed
                        borderRadius: BorderRadius.circular(
                            6), // Adjust border radius as needed
                      ),
                      child: Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white, // Adjust text color as needed
                            fontSize: 14, // Adjust text size as needed
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xfffddbdc),
    );
  }
}