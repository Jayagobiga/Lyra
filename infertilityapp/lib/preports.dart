import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infertilityapp/addpreports.dart';
import 'dart:convert';

import 'package:infertilityapp/addreports.dart';
import 'package:infertilityapp/comman.dart';

class PReportsPage extends StatefulWidget {
  final String userId;
  final String name;

  PReportsPage({required this.userId, required this.name});

  @override
  _PReportsPageState createState() => _PReportsPageState();
}

class _PReportsPageState extends State<PReportsPage> {
  List<String> imageUrls = [];
  List<String> dates = [];

  @override
  void initState() {
    super.initState();
    // Fetch image URLs when the widget is initialized
    fetchImages();
  }

  Future<void> fetchImages() async {
    final Uri url = Uri.parse(
      '$viewimg?userid=${widget.userId}',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        imageUrls = List<String>.from(data['images'].map((image) => image['url']));
        dates = List<String>.from(data['images'].map((image) => image['date']));
      });
    } else {
      // Handle error
      print('Failed to load images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffed4662),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(
              width: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  'assets/arrow.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 30),
            Text(
              'View Reports',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: List.generate(
              imageUrls.length,
                  (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  height: 70,
                  child: ListTile(
                    title: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddPReportsPage(
                              userId: widget.userId,
                              name: widget.name,
                              imageUrl: imageUrls[index], // Pass the image URL
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 330,
                        height: 85,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 90,
                              child: Container(
                                width: 70,
                                height: 70,
                                child: Image.network(
                                  imageUrls[index],
                                  fit: BoxFit.cover, // Maintain aspect ratio and cover the space
                                ),
                              ),
                            ),
                            SizedBox(width: 30),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${dates[index]}', // Display date
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xfffddbdc),
    );
  }
}
