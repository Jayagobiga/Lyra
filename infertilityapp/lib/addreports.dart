import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'twelfth_page.dart';
import 'package:intl/intl.dart'; // Import package for date formatting
import 'comman.dart';

class AddReportsPage extends StatefulWidget {
  final String userId;
  final String name;
  final String imageUrl;
  final int dayDifference;

  AddReportsPage({
    required this.userId,
    required this.name,
    required this.imageUrl,
    required this.dayDifference,
  });

  @override
  _AddReportsPageState createState() => _AddReportsPageState();
}

class _AddReportsPageState extends State<AddReportsPage> {
  DateTime? _selectedDate;
  TextEditingController endometriumController = TextEditingController();
  TextEditingController folliculardiameterController = TextEditingController();
  TextEditingController RIController = TextEditingController();
  TextEditingController PSVController = TextEditingController();
  TextEditingController perifollicularrateController = TextEditingController();
  TextEditingController FSHController = TextEditingController();
  TextEditingController LHController = TextEditingController();
  TextEditingController TSHController = TextEditingController();
  TextEditingController ProlactinController = TextEditingController();
  TextEditingController AMHController = TextEditingController();
  TextEditingController HSGReportController = TextEditingController();

  Future<void> saveReport() async {
    // Prepare the form data
    var formData = {
      'Userid': widget.userId,
      'date': DateFormat('yyyy-MM-dd').format(_selectedDate!), // Use selected date
      'endometrium_thickness': endometriumController.text,
      'follicular_diameter': folliculardiameterController.text,
      'RI': RIController.text,
      'PSV': PSVController.text,
      'perifollicular_rate': perifollicularrateController.text,
      'FSH': FSHController.text,
      'LH': LHController.text,
      'TSH': TSHController.text,
      'Prolactin': ProlactinController.text,
      'AMH': AMHController.text,
      'HSG_report': HSGReportController.text,
    };

    try {
      // Send a POST request to your PHP script
      var response = await http.post(
        Uri.parse(addreports),
        body: formData,
      );

      if (response.statusCode == 200) {
        // Successfully saved report
        var responseBody = response.body;
        print("Response Body: $responseBody");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Reports saved successfully"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TwelfthPage(
                              userId: widget.userId,
                              name: widget.name,
                              dayDifference: widget.dayDifference)),
                    );
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        // Failed to save report
        print("Failed to save report. Status code: ${response.statusCode}");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Failed to save reports"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("Error occurred while saving report: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("An error occurred. Please try again."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
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
              'Add Reports',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              SizedBox(
                height: 250,
                child: InteractiveViewer(
                  panEnabled: true,
                  boundaryMargin: EdgeInsets.all(20),
                  minScale: 0.9,
                  maxScale: 3.0,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date',
                    style: TextStyle(fontSize: 14),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
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
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          // Set the background color to white
                          filled: true,
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(8),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Scan reports',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              _buildReportField('Endometrium Thickness', endometriumController),
              _buildReportField(
                  'Follicular Diameter', folliculardiameterController),
              _buildReportField(
                  'Perifollicular Rate', perifollicularrateController),
              Text(
                'Follicular flow parameters',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              _buildReportField('RI', RIController),
              _buildReportField('PSV', PSVController),
              Text(
                'Blood Investigations',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              _buildReportField('FSH', FSHController),
              _buildReportField('LH', LHController),
              _buildReportField('TSH', TSHController),
              _buildReportField('Prolactin', ProlactinController),
              _buildReportField('AMH', AMHController),
              _buildReportField('HSG Report', HSGReportController),
              SizedBox(height: 20),
              GestureDetector(
                onTap: saveReport,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xffed4662),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: Center(
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xfffddbdc),
    );
  }

  Widget _buildReportField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                fillColor: Colors.white,
                // Set the background color to white
                filled: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
