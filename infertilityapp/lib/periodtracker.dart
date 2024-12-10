import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class PeriodTrackerHomePage extends StatefulWidget {
  final String userId;

  PeriodTrackerHomePage({required this.userId});

  @override
  _PeriodTrackerHomePageState createState() => _PeriodTrackerHomePageState();
}

class _PeriodTrackerHomePageState extends State<PeriodTrackerHomePage> {
  DateTime? selectedDate;
  int? dayDifference;
  DateTime? fertileStartDate;
  DateTime? fertileEndDate;

  @override
  void initState() {
    super.initState();
    // Fetch saved period start date and fertile period from backend
    fetchPeriodData();
  }

  Future<void> fetchPeriodData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.40.27:80/infertility/get_period.php?userid=${widget.userId}'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          selectedDate = DateTime.parse(data['date']);
          dayDifference = DateTime.now().difference(selectedDate!).inDays + 1;
          if (data['fertileStart'] != null && data['fertileEnd'] != null) {
            fertileStartDate = DateTime.parse(data['fertileStart']);
            fertileEndDate = DateTime.parse(data['fertileEnd']);
          } else {
            fertileStartDate = null;
            fertileEndDate = null;
          }
        });
        // Check fertile period if necessary
        checkFertilePeriod();
      } else {
        print('Failed to load period data');
      }
    } catch (e) {
      print('Error fetching period data: $e');
    }
  }

  Future<void> savePeriodData(DateTime selectedDate, int days) async {
    try {
      // Calculate fertile period (typically day 14 to day 18)
      fertileStartDate = selectedDate.add(Duration(days: 14));
      fertileEndDate = selectedDate.add(Duration(days: 18));

      final periodResponse = await http.post(
        Uri.parse('http://192.168.40.27:80/infertility/save_period.php'),
        body: {
          'userid': widget.userId,
          'date': DateFormat('yyyy-MM-dd').format(selectedDate),
          'days': days.toString(),
          'fertileStart': DateFormat('yyyy-MM-dd').format(fertileStartDate!),
          'fertileEnd': DateFormat('yyyy-MM-dd').format(fertileEndDate!),
        },
      );

      if (periodResponse.statusCode == 200) {
        print('Period data saved successfully');
      } else {
        print('Failed to save period data');
      }
    } catch (e) {
      print('Error saving period data: $e');
    }
  }

  void checkFertilePeriod() {
    if (selectedDate != null && fertileStartDate != null && fertileEndDate != null) {
      DateTime currentDate = DateTime.now();
      if (currentDate.isAfter(fertileStartDate!) && currentDate.isBefore(fertileEndDate!)) {
        // Show fertile period notification
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showFertilePeriodNotification();
        });
      }
    }
  }

  void _showFertilePeriodNotification() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Fertile Period'),
          content: Text('You are in your fertile period.'),
          actions: [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Period Tracker', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xffed4662), // Example of custom app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 0),
            Center(
              child: Image.asset(
                'assets/girl4.png',
                width: 260,
                height: 260,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (selectedDate != null && dayDifference != null && fertileStartDate != null && fertileEndDate != null) ...[
                        Text(
                          'You are in Day: $dayDifference',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Fertile Period',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'From ${DateFormat('yyyy-MM-dd').format(fertileStartDate!)} to ${DateFormat('yyyy-MM-dd').format(fertileEndDate!)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ] else ...[
                        Text(
                          'You are in day: $dayDifference',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Fertile Period',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Fertile period not available',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPeriodDatePage(),
                  ),
                );
                if (picked != null) {
                  updateSelectedDate(picked);
                }
              },
              child: Text('Edit Period Date', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffed4662),
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateSelectedDate(DateTime date) async {
    setState(() {
      selectedDate = date;
      dayDifference = DateTime.now().difference(selectedDate!).inDays + 1;
    });

    // Save selected date, days, and fertile period to backend
    await savePeriodData(selectedDate!, dayDifference!);
  }
}

class EditPeriodDatePage extends StatefulWidget {
  @override
  _EditPeriodDatePageState createState() => _EditPeriodDatePageState();
}

class _EditPeriodDatePageState extends State<EditPeriodDatePage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Period Start Date'),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Text('Select Date'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedDate);
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
