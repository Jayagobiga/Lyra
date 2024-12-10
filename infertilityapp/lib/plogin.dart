import 'package:flutter/material.dart';
import 'package:infertilityapp/comman.dart';
import 'package:infertilityapp/results.dart';
import 'package:infertilityapp/second_page.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:infertilityapp/fourth_page.dart';
import 'package:infertilityapp/padvice.dart';
import 'package:infertilityapp/pcycle.dart';
import 'package:infertilityapp/pgraph.dart';
import 'package:infertilityapp/pmedication.dart';
import 'package:infertilityapp/pprofile.dart';
import 'package:infertilityapp/preports.dart';
import 'dart:io';

class PLoginPage extends StatefulWidget {
  final String userId;
  final String name;

  PLoginPage({required this.userId, required this.name});

  @override
  _PLoginPageState createState() => _PLoginPageState();
}

class _PLoginPageState extends State<PLoginPage> {
  DateTime? _selectedDate;
  int _dayCount = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchSavedDate();
  }

  Future<void> _fetchSavedDate() async {
    final url = fetchdate;
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'userId': widget.userId});

    print('Request URL: $url'); // Debugging
    print('Request Headers: $headers'); // Debugging
    print('Request Body: $body'); // Debugging

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print('Response Status: ${response.statusCode}'); // Debugging
    print('Response Body: ${response.body}'); // Debugging

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Response Data: $responseData'); // Debugging

      if (responseData['selectedDate'] != null) {
        setState(() {
          _selectedDate = DateTime.parse(responseData['selectedDate']);
          _calculateDayCount();
        });
      }
    } else {
      print('Failed to load date from backend');
    }
  }

  void _calculateDayCount() {
    if (_selectedDate != null) {
      final now = DateTime.now();
      final difference = now.difference(_selectedDate!).inDays;
      setState(() {
        _dayCount = difference + 1;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _calculateDayCount(); // Update day count immediately
        _saveDate(pickedDate);
      });
    }
  }

  Future<void> _saveDate(DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selected_date', date.toIso8601String());

    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'userId': widget.userId, 'selectedDate': date.toIso8601String()});

    final response1 = await http.post(
      Uri.parse(savedate),
      headers: headers,
      body: body,
    );

    if (response1.statusCode == 200) {
      print('Date saved successfully');
    } else {
      print('Failed to save date to backend');
      print('Response status: ${response1.statusCode}');
      print('Response body: ${response1.body}');
    }
    final response2 = await http.post(
      Uri.parse(saveperioddate),
      headers: headers,
      body: body,
    );

    if (response2.statusCode == 200) {
      print('Date saved successfully to saveperioddate');
    } else {
      print('Failed to save date to saveperioddate backend');
      print('Response status: ${response2.statusCode}');
      print('Response body: ${response2.body}');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    DateTime? fertileStartDate;
    DateTime? fertileEndDate;

    if (_selectedDate != null) {
      fertileStartDate = _selectedDate!.add(Duration(days: 14));
      fertileEndDate = _selectedDate!.add(Duration(days: 18));
    }
    final Uri whatsApp = Uri.parse('http://wasap.my/919444311000');
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => FourthPage(),
          ),
          ModalRoute.withName('/'), // Make sure this matches your- route name
        );

        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xffed4662),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer(); // Open drawer when menu icon is tapped
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Image.asset(
                        'assets/menu.png',
                        width: 35,
                        height: AppBar().preferredSize.height,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () async {
                      launchUrl(whatsApp);
                    },
                    child: Image.asset(
                      'assets/whats.png',
                      width: 35,
                      height: 35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        drawer: Container(
          height: 850,
          width: 260,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 80,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xffed4662),
                    ),
                    child: Text(
                      widget.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: Image.asset('assets/bprofile.png', width: 40, height: 40), // Profile icon
                  title: Text('Patient Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PProfilePage(userId: widget.userId, name: widget.name)),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset('assets/pluss.png', width: 40, height: 40), // Add Reports icon
                  title: Text('Add Reports'),
                  onTap: () {
                    _launchWhatsApp();
                  },
                ),
                ListTile(
                  leading: Image.asset('assets/calendar.png', width: 40, height: 40), // Profile icon
                  title: Text('Period History'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResultsPage(userId: widget.userId)),
                    );
                  },
                ),
            ListTile(
              leading: Image.asset(
                'assets/logout.png',
                width: 40,
                height: 40,
              ), // Logout icon
              title: Text('Logout'),
              onTap: () async {
                // Show confirmation dialog
                bool? confirmLogout = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirm Logout'),
                      content: Text('Are you sure you want to log out?'),
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

                // If the user confirms the logout
                if (confirmLogout == true) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SecondPage()),
                    ModalRoute.withName('/'),
                  );
                }
              },
            ),
            ],
            ),
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                children: [
                  SizedBox(height: 0),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/girl4.png',
                          width: 240,
                          height: 240,
                        ),
                        SizedBox(height: 0),
                        Column(
                            children: <Widget>[
                          Text(
                               _selectedDate == null
                             ? 'No date selected'
                                   : 'Selected Date: ${DateFormat.yMMMd().format(_selectedDate!)}',
                                    ),
                                Text(
                                         'Day:$_dayCount',
                                  style: Theme.of(context).textTheme.headline4,
                                       ),
                              SizedBox(height: 0),
                              if (_selectedDate != null)
                                Text(
                                  'Your fertile period starts from\n   ${DateFormat.yMMMd().format(fertileStartDate!)} - ${DateFormat.yMMMd().format(fertileEndDate!)}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                   ElevatedButton(
                                         onPressed: () => _selectDate(context),
                                         child: Text('Select Start Date'),
                                            ),
                                                    ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20,vertical:0),
                    child: Card(
                      elevation: 6.0,
                      color: Color(0xfffddbdc),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => PReportsPage(userId: widget.userId, name: widget.name)),
                                          );
                                        },
                                        child: Card(
                                          elevation: 4.0,
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            width: 95,
                                            height: 95,
                                            child: Center(
                                              child: Image.asset(
                                                'assets/medical-report.png',
                                                width: 60,
                                                height: 70,
                                              ),
                                            ),
                                            padding: EdgeInsets.all(20),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Reports',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => PAdvicePage(userId: widget.userId)),
                                          );
                                        },
                                        child: Card(
                                          elevation: 4.0,
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            width: 95,
                                            height: 95,
                                            child: Center(
                                              child: Image.asset(
                                                'assets/advices.png',
                                                width: 60,
                                                height: 70,
                                              ),
                                            ),
                                            padding: EdgeInsets.all(20),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Advices',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => PGraphPage(userId: widget.userId)),
                                          );
                                        },
                                        child: Card(
                                          color:Colors.white,
                                          elevation: 4.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            width: 95,
                                            height: 95,
                                            child: Center(
                                              child: Image.asset(
                                                'assets/analytic.png',
                                                width: 60,
                                                height: 70,
                                              ),
                                            ),
                                            padding: EdgeInsets.all(20),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Graphs',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => PMedicationPage(userId: widget.userId)),
                                          );
                                        },
                                        child: Card(
                                          elevation: 4.0,
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            width: 95,
                                            height: 95,
                                            child: Center(
                                              child: Image.asset(
                                                'assets/medicine.png',
                                                width: 60,
                                                height: 70,
                                              ),
                                            ),
                                            padding: EdgeInsets.all(20),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Medications',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],),
            ),
          ),
        ),),
    );
  }


  Future<void> _launchWhatsApp() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                onTap: () {
                  _pickImage(ImageSource.camera, widget.userId);
                  Navigator.pop(context);
                },
                title: Text('Take Photo'),
              ),
              ListTile(
                onTap: () {
                  _pickImage(ImageSource.gallery, widget.userId);
                  Navigator.pop(context);
                },
                title: Text('Choose from Gallery'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source, String userId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      uploadImage(imageFile, userId);
    }
  }

  Future<void> uploadImage(File imageFile, String userId) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(uploadimg),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );
      request.fields['Userid'] = userId;

      var streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        // Show Snackbar on successful upload
        Navigator.of(context).pop();
        _showSnackbar('Image uploaded successfully');
      } else {
        // Show Snackbar on failed upload
        Navigator.of(context).pop();
        _showSnackbar('Image upload failed');
      }
    } catch (error) {
      print('Error: $error');
      // Show Snackbar on error
      _showSnackbar('Error: $error');
    }
  }

  void _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
