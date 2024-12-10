import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PCyclePage extends StatefulWidget {
  final String userId;
  final String name;

  PCyclePage({required this.userId, required this.name});

  @override
  _PCyclePageState createState() => _PCyclePageState();
}

class _PCyclePageState extends State<PCyclePage> {
  DateTime? _selectedDate;
  int _dayDifference = 0;

  @override
  void initState() {
    super.initState();
    _fetchInitialDate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calculateDayDifference();
  }

  void _fetchInitialDate() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.40.27:80/infertility/updatecycle.php'),
        body: {
          'userid': widget.userId,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          setState(() {
            _selectedDate = DateTime.parse(data['initial_date']);
          });
        } else {
          // Handle error if initial date not fetched
        }
      } else {
        // Handle HTTP error
      }
    } catch (error) {
      // Handle network or other errors
    }
  }

  void _updateCycleDate(int dayDifference) async {
    if (_selectedDate != null) {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.40.27:80/infertility/updatedate.php'),
          body: {
            'userid': widget.userId,
            'updatedate': DateFormat('yyyy-MM-dd').format(_selectedDate!),
            'dayDifference': dayDifference.toString(),
          },
        );

        // Handle response...
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          if (responseData['status'] == true) {
            print('Date updated successfully.');
            // Call dayDifference.php to update the 'days' column
            _updateDayDifference(dayDifference);
          } else {
            print('Failed to update date: ${responseData['message']}');
          }
        } else {
          print('Failed to update date: HTTP ${response.statusCode}');
        }
      } catch (error) {
        print('Error updating date: $error');
      }
    } else {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text("Error"),
              content: Text("Please select a date."),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
      );
    }
  }

  void _updateDayDifference(int dayDifference) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.40.27:80/infertility/daydifference.php'),
        body: {
          'userid': widget.userId,
          'dayDifference': dayDifference.toString(),
        },
      );

      // Handle response...
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          print('Day difference updated successfully.');
          // Pass dayDifference back to previous page
          Navigator.pop(context, dayDifference);
        } else {
          print('Failed to update day difference: ${responseData['message']}');
        }
      } else {
        print('Failed to update day difference: HTTP ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating day difference: $error');
    }
  }

  void _calculateDayDifference() {
    if (_selectedDate != null) {
      DateTime now = DateTime.now();
      DateTime selectedDay = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
      );

      int differenceInDays = now
          .difference(selectedDay)
          .inDays;
      differenceInDays += 1;

      setState(() {
        _dayDifference = differenceInDays;
      });
    }
  }

  String _numberSuffix(int number) {
    if (number >= 11 && number <= 13) {
      return 'th';
    }
    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String _formatDayDifference(int dayDifference) {
    return '$dayDifference${_numberSuffix(dayDifference)} day';
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
            SizedBox(width: 20),
            Text(
              'Cycle Update',
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
        child: SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/sqbackground.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: kToolbarHeight + 10,
                left: 45,
                right: 45,
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 70),
                      Container(
                        height: 350,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(0.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Cycle up to:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                                SizedBox(height: 80),
                                Container(
                                  width: 350,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.pink[200],
                                    borderRadius: BorderRadius.circular(0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: true,
                                          controller: TextEditingController(
                                            text: _selectedDate != null
                                                ? DateFormat('dd/MM/yyyy')
                                                .format(_selectedDate!)
                                                : '',
                                          ),
                                          onTap: () async {
                                            final DateTime? pickedDate = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime(2100),
                                            );
                                            if (pickedDate != null &&
                                                pickedDate != _selectedDate) {
                                              setState(() {
                                                _selectedDate = pickedDate;
                                              });
                                              _calculateDayDifference(); // Calculate day difference when date changes
                                            }
                                          },
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.pink.shade200),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.pink.shade200),
                                            ),
                                            contentPadding: EdgeInsets.all(8),
                                            suffixIcon: Icon(
                                                Icons.calendar_today),
                                            hintText: 'Enter 1st day of your cycle',
                                            hintStyle: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        _updateCycleDate(_dayDifference),
                                    child: Text('OK'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: kToolbarHeight + 450,
                left: 50,
                right: 50,
                child: Image.asset(
                  'assets/cyclephoto.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}