import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UpdateDate(userId: '205'), // Use a valid userId
    );
  }
}

class UpdateDate extends StatefulWidget {
  final String userId;

  UpdateDate({required this.userId});

  @override
  _UpdateDatePageState createState() => _UpdateDatePageState();
}

class _UpdateDatePageState extends State<UpdateDate> {
  DateTime? _selectedDate;
  int _dayCount = 1;

  @override
  void initState() {
    super.initState();
    _fetchSavedDate();
  }

  Future<void> _fetchSavedDate() async {
    final url = 'http://192.168.40.27:80/infertility/fetchdate.php';
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

    final response = await http.post(
      Uri.parse('http://192.168.40.27:80/infertility/save_date.php'), // Ensure this is the correct URL
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': widget.userId, 'selectedDate': date.toIso8601String()}),
    );

    if (response.statusCode == 200) {
      print('Date saved successfully');
    } else {
      print('Failed to save date to backend');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Period Tracker', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xffed4662), // Example of custom app bar color
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _selectedDate == null
                  ? 'No date selected'
                  : 'Selected Date: ${DateFormat.yMMMd().format(_selectedDate!)}',
            ),
            Text(
              'Day Count: $_dayCount',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select Date'),
            ),
          ],
        ),
      ),
    );
  }
}
