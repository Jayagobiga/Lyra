import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infertilityapp/comman.dart';

class SpousePage extends StatefulWidget {
  final String userId;
  final String name;

  SpousePage({required this.userId, required this.name});

  @override
  _SpousePageState createState() => _SpousePageState();
}

class _SpousePageState extends State<SpousePage> {
  Map<String, dynamic>? spouseDetails;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchSpouseDetails();
  }

  Future<void> fetchSpouseDetails() async {
    try {
      var response = await http.post(
        Uri.parse(viewspouse),
        body: {'userid': widget.userId},
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status']) {
          setState(() {
            spouseDetails = jsonData['spouseDetails'];
            isLoading = false;
          });
        } else {
          setState(() {
            hasError = true;
            errorMessage = jsonData['message'];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          hasError = true;
          errorMessage = 'Failed to load spouse details. Please try again later.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Error fetching data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spouse Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xffed4662),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
          ? Center(child: Text(errorMessage))
          : SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildSectionHeader('Spouse Details'),
            buildDetailRow('Name', spouseDetails!['Name']),
            buildDetailRow('Contact Number', spouseDetails!['Contactnumber']),
            buildDetailRow('Occupation', spouseDetails!['occupation']),
            buildDetailRow('Age', spouseDetails!['Age']),
            buildDetailRow('Significant History', spouseDetails!['significanthistory']),
            buildSectionHeader('Personal History'),
            buildDetailRow('Smoking', spouseDetails!['smoking']),
            buildDetailRow('Alcohol', spouseDetails!['alcohol']),
            buildDetailRow('Sexual Dysfunction', spouseDetails!['sexualdisfunction']),
            buildSectionHeader('Semen Analysis'),
            buildDetailRow('Volume (ml)', spouseDetails!['Volume']),
            buildDetailRow('Concentration\n(million/ml)', spouseDetails!['Concentration']),
            buildDetailRow('Total sperm number\n(million)', spouseDetails!['Total_sperm_number']),
            buildDetailRow('Motility(%)', spouseDetails!['Motility']),
            buildDetailRow('Progressive \nMotility(%)', spouseDetails!['Progressive_Motility']),
            buildDetailRow('Morphology(%)', spouseDetails!['Morphology']),
            buildDetailRow('Viability(%)', spouseDetails!['Viability']),
          ],
        ),
      ),
      backgroundColor: Color(0xfffddbdc),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0,horizontal: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(label,
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue, // Adjust color as needed
        ),
      ),
    );
  }
}
