import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infertilityapp/comman.dart';

class PAdvicePage extends StatefulWidget {
  final String userId;

  PAdvicePage({required this.userId});

  @override
  _PAdvicePageState createState() => _PAdvicePageState();
}

class _PAdvicePageState extends State<PAdvicePage> {
  late List<Map<String, dynamic>> advices = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
  }

  Future<void> fetchDataFromApi() async {
    final url = Uri.parse(
        viewadvice);
    final response = await http.post(url, body: {
      'userid': widget.userId,
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final allAdvices = List<Map<String, dynamic>>.from(
          jsonData['viewadvices']);
      // Sort advices based on date (assuming 'Date' is a timestamp)
      allAdvices.sort((a, b) => b['Date'].compareTo(a['Date']));
      setState(() {
        // Take only the latest 5 advices
        advices = allAdvices.take(5).toList();
      });
    } else {
      print('Failed to fetch data: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
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
                'View Advices',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: advices.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 7.0, horizontal: 30.0),
              child: Container(
                height: 184,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Date: ${advices[index]['Date']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Center(
                          child: Text(
                            '${advices[index]['Addadvices']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
      backgroundColor: Color(0xfffddbdc),
    );
  }
}


