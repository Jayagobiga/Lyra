import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'comman.dart';

class ResultsPage extends StatefulWidget {
  final String userId;
  ResultsPage({required this.userId});

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  List<String> dates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDates();
  }

  Future<void> _fetchDates() async {
    final response = await http.post(
      Uri.parse(fetchperioddate), // Replace with your actual URL
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userid': widget.userId}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('dates')) {
        setState(() {
          dates = List<String>.from(data['dates']);
          dates.sort((a, b) => b.compareTo(a)); // Sort dates in descending order
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Period History', style: TextStyle(fontFamily: 'CustomFont',fontWeight:FontWeight.bold)),
        backgroundColor: Color(0xffed4662),
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/girl.png',
            width: 300,
            height: 300,
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : dates.isEmpty
                ? Center(child: Text('No records found', style: TextStyle(fontFamily: 'CustomFont')))
                : ListView.builder(
              itemCount: dates.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: Image.asset('assets/calendar.png', width: 40, height: 40), // Replace with your image
                    title: Text(
                      dates[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                        fontFamily: 'CustomFont',
                      ),
                    ),
                    subtitle: Text(
                      'Recorded date',
                      style: TextStyle(color: Colors.grey, fontFamily: 'CustomFont'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xfffddbdc),
    );
  }
}
