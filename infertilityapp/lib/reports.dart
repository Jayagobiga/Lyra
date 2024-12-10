import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'comman.dart';
import 'package:infertilityapp/addreports.dart';

class ReportsPage extends StatefulWidget {
  final String userId;
  final String name;
  final int dayDifference;

  ReportsPage({
    required this.userId,
    required this.name,
    required this.dayDifference,
  });

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  List<String> imageUrls = [];
  List<String> dates = [];
  List<String> days = [];

  @override
  void initState() {
    super.initState();
    // Fetch image URLs when the widget is initialized
    fetchImages();
  }

  Future<void> fetchImages() async {
    final Uri url = Uri.parse('$viewimg?userid=${widget.userId}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> data = json.decode(response.body);
      print('Data fetched: $data'); // Debug print
      setState(() {
        // Adjusted to handle nested JSON structure
        imageUrls = List<String>.from(data['images'].map((image) => image['url']));
        dates = List<String>.from(data['images'].map((image) => image['date']));
      });
      print('Image URLs: $imageUrls'); // Debug print
      print('Dates: $dates'); // Debug print
    } else {
      // Handle error
      print('Failed to load images');
    }
  }

  Future<void> deleteReport(int index) async {
    // Show confirmation dialog
    bool? isConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Report'),
          content: Text('Are you sure you want to delete this report?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User pressed "No"
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User pressed "Yes"
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (isConfirmed == true) {
      // If confirmed, proceed to delete the report
      final String apiUrl = deletereport;

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'userId': widget.userId,
          'date': dates[index], // Send the specific date to delete
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          // On success, remove the image and date from the list
          setState(() {
            imageUrls.removeAt(index);
            dates.removeAt(index);
          });
          // Optionally show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Report deleted successfully')),
          );
        } else {
          // Handle failure from PHP
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete report')),
          );
        }
      } else {
        // Handle HTTP request failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to connect to server')),
        );
      }
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
                            builder: (context) => AddReportsPage(
                              userId: widget.userId,
                              name: widget.name,
                              imageUrl: imageUrls[index],
                              dayDifference: widget.dayDifference,
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
                            Spacer(), // Push the delete icon to the right
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                deleteReport(index); // Call delete function on icon press
                              },
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
