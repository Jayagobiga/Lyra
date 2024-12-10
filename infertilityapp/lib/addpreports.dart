import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infertilityapp/comman.dart';
import 'twelfth_page.dart';
import 'package:intl/intl.dart'; // Import package for date formatting

class AddPReportsPage extends StatefulWidget {
  final String userId;
  final String name;
  final String imageUrl;

  AddPReportsPage({required this.userId, required this.name, required this.imageUrl});

  get dayDifference => null;

  @override
  _AddPReportsPageState createState() => _AddPReportsPageState();
}

class _AddPReportsPageState extends State<AddPReportsPage> {
  DateTime? _selectedDate;
  String? _selectedDay;
  TextEditingController endometriumController = TextEditingController();
  TextEditingController leftOvaryController = TextEditingController();
  TextEditingController rightOvaryController = TextEditingController();
  Map<String, int> dayMap = {
    'Sunday': 1,
    'Monday': 2,
    'Tuesday': 3,
    'Wednesday': 4,
    'Thursday': 5,
    'Friday': 6,
    'Saturday': 7,
  };

  Future<void> saveReport() async {
    // Prepare the form data
    var formData = {
      'Userid': widget.userId,
      'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
      'day': _selectedDay ?? '', // Use selected day, or empty string if not selected
      'Endometrium': endometriumController.text,
      'Leftovery': leftOvaryController.text,
      'Rightovery': rightOvaryController.text,
    };

    // Send a POST request to your PHP script
    var response = await http.post(
      Uri.parse(addreports),
      body: formData,
    );

    if (response.statusCode == 200) {
      // Successfully saved report
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
                    MaterialPageRoute(builder: (context) => TwelfthPage(userId: widget.userId, name: widget.name, dayDifference: widget.dayDifference)),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 90),
            SizedBox(
              height: 500,
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
      //       SizedBox(height: 20),
      //       Text(
      //         'Follicular study',
      //         textAlign: TextAlign.center,
      //         style: TextStyle(
      //           color: Colors.grey,
      //           fontSize: 16,
      //           fontWeight: FontWeight.bold,
      //         ),
      //       ),
      //       SizedBox(height: 10),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           SizedBox(width: 20),
      //           Text(
      //             'Day',
      //             style: TextStyle(fontSize: 14),
      //           ),
      //           SizedBox(width: 81),
      //           Expanded(
      //             child: Container(
      //               height: 45,
      //               decoration: BoxDecoration(
      //                 color: Colors.white,
      //                 border: Border.all(color: Colors.black),
      //                 borderRadius: BorderRadius.circular(3.0),
      //               ),
      //               child: DropdownButtonFormField<String>(
      //                 decoration: InputDecoration(
      //                   border: InputBorder.none,
      //                   contentPadding: EdgeInsets.all(8),
      //                 ),
      //                 items: [
      //                   'Sunday',
      //                   'Monday',
      //                   'Tuesday',
      //                   'Wednesday',
      //                   'Thursday',
      //                   'Friday',
      //                   'Saturday',
      //                 ].map((String day) {
      //                   return DropdownMenuItem<String>(
      //                     value: day,
      //                     child: Text(day),
      //                   );
      //                 }).toList(),
      //                 onChanged: (String? value) {
      //                   setState(() {
      //                     _selectedDay = value; // Assign the selected day string directly
      //                   });
      //                 },
      //               ),
      //             ),
      //           ),
      //           SizedBox(width: 20),
      //         ],
      //       ),
      //       SizedBox(height: 10),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           SizedBox(width: 20),
      //           Text(
      //             'Date',
      //             style: TextStyle(fontSize: 14),
      //           ),
      //           SizedBox(width: 74),
      //           Expanded(
      //             child: TextFormField(
      //               readOnly: true,
      //               controller: TextEditingController(
      //                 text: _selectedDate != null
      //                     ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
      //                     : '',
      //               ),
      //               onTap: () async {
      //                 final DateTime? pickedDate = await showDatePicker(
      //                   context: context,
      //                   initialDate: DateTime.now(),
      //                   firstDate: DateTime(1900),
      //                   lastDate: DateTime(2100),
      //                 );
      //                 if (pickedDate != null && pickedDate != _selectedDate) {
      //                   setState(() {
      //                     _selectedDate = pickedDate;
      //                   });
      //                 }
      //               },
      //               decoration: InputDecoration(
      //                 border: OutlineInputBorder(),
      //                 contentPadding: EdgeInsets.all(8),
      //                 suffixIcon: Icon(Icons.arrow_drop_down),
      //               ),
      //             ),
      //           ),
      //           SizedBox(width: 20),
      //         ],
      //       ),
      //       SizedBox(height: 10),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           SizedBox(width: 10),
      //           Text(
      //             'Endometrium',
      //             style: TextStyle(fontSize: 14),
      //           ),
      //           SizedBox(width: 18),
      //           Expanded(
      //             child: Container(
      //               height: 45,
      //               decoration: BoxDecoration(
      //                 color: Colors.white,
      //                 border: Border.all(color: Colors.black),
      //                 borderRadius: BorderRadius.circular(3.0),
      //               ),
      //               child: TextField(
      //                 controller: endometriumController,
      //                 decoration: InputDecoration(
      //                   border: InputBorder.none,
      //                   contentPadding: EdgeInsets.all(8),
      //                 ),
      //               ),
      //             ),
      //           ),
      //           SizedBox(width: 20),
      //         ],
      //       ),
      //       SizedBox(
      //         height: 20,
      //       ),
      //       Text(
      //         'Folicular study',
      //         textAlign: TextAlign.center,
      //         style: TextStyle(
      //           color: Color(0xffed4662),
      //           fontSize: 16,
      //           fontWeight: FontWeight.bold,
      //         ),
      //       ),
      //       SizedBox(height: 20),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           SizedBox(width: 20),
      //           Text(
      //             'Left Ovary',
      //             style: TextStyle(fontSize: 14),
      //           ),
      //           SizedBox(width: 30),
      //           Expanded(
      //             child: Container(
      //               height: 45,
      //               decoration: BoxDecoration(
      //                 color: Colors.white,
      //                 border: Border.all(color: Colors.black),
      //                 borderRadius: BorderRadius.circular(3.0),
      //               ),
      //               child: TextField(
      //                 controller: leftOvaryController,
      //                 decoration: InputDecoration(
      //                   border: InputBorder.none,
      //                   contentPadding: EdgeInsets.all(8),
      //                 ),
      //               ),
      //             ),
      //           ),
      //           SizedBox(width: 20),
      //         ],
      //       ),
      //       SizedBox(height: 10),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           SizedBox(width: 20),
      //           Text(
      //             'Right Ovary',
      //             style: TextStyle(fontSize: 14),
      //           ),
      //           SizedBox(width: 20),
      //           Expanded(
      //             child: Container(
      //               height: 45,
      //               decoration: BoxDecoration(
      //                 color: Colors.white,
      //                 border: Border.all(color: Colors.black),
      //                 borderRadius: BorderRadius.circular(3.0),
      //               ),
      //               child: TextField(
      //                 controller: rightOvaryController,
      //                 decoration: InputDecoration(
      //                   border: InputBorder.none,
      //                   contentPadding: EdgeInsets.all(8),
      //                 ),
      //               ),
      //             ),
      //           ),
      //           SizedBox(width: 20),
      //         ],
      //       ),
      //       SizedBox(height: 10),
      //     ],
      //   ),
      // ),
      // bottomNavigationBar: BottomAppBar(
      //   color: Color(0xffed4662),
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(vertical: 8.0),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         GestureDetector(
      //           onTap: () {
      //             saveReport();
      //           },
      //           child: Text(
      //             'Save',
      //             style: TextStyle(
      //               fontSize: 18,
      //               color: Colors.white,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
          ],
        ),
      ),
    );
  }
}
