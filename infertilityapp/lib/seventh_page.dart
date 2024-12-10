import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:infertilityapp/comman.dart';
import 'package:intl/intl.dart';
import 'eight_page.dart';

class SeventhPage extends StatefulWidget {
  final String userId;
  final int dayDifference;

  SeventhPage({required this.userId, required this.dayDifference});

  @override
  _SeventhPageState createState() => _SeventhPageState();
}

class _SeventhPageState extends State<SeventhPage> {
  DateTime? _selectedDate;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _marriageYearController = TextEditingController();
  final TextEditingController _bloodgroupController = TextEditingController();
  final TextEditingController _medicalHistoryController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _BMIController = TextEditingController();
  final TextEditingController _contraceptiveHistoryController = TextEditingController();
  final TextEditingController _lastMenstrualPeriodController = TextEditingController();
  final TextEditingController _menstrualhistoryController = TextEditingController();
  final TextEditingController _flowController = TextEditingController();
  final TextEditingController _coitalHistoryController = TextEditingController();
  final TextEditingController _obstetricHistoryController = TextEditingController();
  final TextEditingController _surgicalHistoryController = TextEditingController();
  String? consanguineous;
  String? smoking;
  String? alcohol;

  File? _imageFile;
  final picker = ImagePicker();

  Future<void> _getImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Image Source"),
          content: Text("Do you want to pick image from camera or gallery?"),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final pickedFile = await picker.getImage(source: ImageSource.camera);
                _setImageFile(pickedFile);
              },
              child: Text("Camera"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final pickedFile = await picker.getImage(source: ImageSource.gallery);
                _setImageFile(pickedFile);
              },
              child: Text("Gallery"),
            ),
          ],
        );
      },
    );
  }

  void _setImageFile(PickedFile? pickedFile) {
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> sendDataToBackend() async {
    // Validate all required fields
    if (_nameController.text.isEmpty ||
        _contactNoController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _genderController.text.isEmpty ||
        _heightController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _marriageYearController.text.isEmpty ||
        _bloodgroupController.text.isEmpty ||
        _medicalHistoryController.text.isEmpty ||
        _occupationController.text.isEmpty ||
        _BMIController.text.isEmpty ||
        _contraceptiveHistoryController.text.isEmpty ||
        _lastMenstrualPeriodController.text.isEmpty ||
        _menstrualhistoryController.text.isEmpty ||
        _flowController.text.isEmpty ||
        _coitalHistoryController.text.isEmpty ||
        _obstetricHistoryController.text.isEmpty ||
        _surgicalHistoryController.text.isEmpty) {

      // Show a dialog for missing fields
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Missing Fields"),
          content: Text("All fields are required. Please fill in all fields."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    // Validate the phone number to ensure it has exactly 10 digits
    if (!RegExp(r"^\d{10}$").hasMatch(_contactNoController.text)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Invalid Phone Number"),
          content: Text("Phone number must be exactly 10 digits."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    // If validations pass, send the request to the backend
    var url = 'http://14.139.187.229:8081/Infertilityapp/addpatient.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['userid'] = widget.userId!;
    request.fields['name'] = _nameController.text;
    request.fields['contactno'] = _contactNoController.text;
    request.fields['age'] = _ageController.text;
    request.fields['gender'] = _genderController.text;
    request.fields['height'] = _heightController.text;
    request.fields['weight'] = _weightController.text;
    request.fields['marriageyear'] = _marriageYearController.text;
    request.fields['bloodgroup'] = _bloodgroupController.text;
    request.fields['medicalhistory'] = _medicalHistoryController.text;
    request.fields['occupation'] = _occupationController.text;
    request.fields['BMI'] = _BMIController.text;
    request.fields['contraceptive_history'] = _contraceptiveHistoryController.text;
    request.fields['last_menstrual_period'] = _lastMenstrualPeriodController.text;
    request.fields['menstrual_history'] = _menstrualhistoryController.text;
    request.fields['flow'] = _flowController.text;
    request.fields['coital_history'] = _coitalHistoryController.text;
    request.fields['obstetric_history'] = _obstetricHistoryController.text;
    request.fields['surgical_history'] = _surgicalHistoryController.text;
    request.fields['consanguineous'] = consanguineous ?? '';
    request.fields['smoking'] = smoking ?? '';
    request.fields['alcohol'] = alcohol ?? '';

    // Add image file if present
    if (_imageFile != null) {
      var pic = await http.MultipartFile.fromPath("image", _imageFile!.path);
      request.files.add(pic);
    }

    // Send the request
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var data = jsonDecode(responseData);

      if (data['status']) {
        // Navigate to the next page on success
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EightPage(
              userId: widget.userId ?? '',
              dayDifference: widget.dayDifference,
            ),
          ),
        );
      } else {
        // Show an error dialog if the backend response contains an error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(data['message']),
              actions: <Widget>[
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
    } else {
      // Show an error dialog if the request failed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to connect to the server. Please try again later.'),
            actions: <Widget>[
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
  }
  void _setSmoking(String value) {
    setState(() {
      smoking = value;
    });
  }

  void _setconsanguineous(String value) {
    setState(() {
      consanguineous = value;
    });
  }

  void _setAlcohol(String value) {
    setState(() {
      alcohol = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffed4662),
        title: Text(
          'Add Patient',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: GestureDetector(
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
      ),
      body: SingleChildScrollView(
        child:  Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _getImage,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Change to circle shape
                      color: Colors.white,
                      image: _imageFile != null
                          ? DecorationImage(
                        image: FileImage(_imageFile!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: _imageFile == null
                        ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200], // Background color of circle
                      ),
                      child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                    )
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20), // Adjust height as needed
              // Name row
              Row(
                children: [
                  Text(
                    'Name',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 100),
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'ID',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 133),
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: TextEditingController(text: widget.userId),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Mobile Number',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: _contactNoController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Year of Marriage',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8),
                        ),
                        items: List.generate(
                          DateTime.now().year - 1969,
                              (index) => DropdownMenuItem<int>(
                            value: DateTime.now().year - index,
                            child: Text((DateTime.now().year - index).toString()),
                          ),
                        ),
                        onChanged: (int? value) {
                          _marriageYearController.text = value?.toString() ?? '';
                          print('Selected year: $value');
                        }
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Blood Group',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 45),
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8),
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: 'A+',
                          child: Text('A+'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'A-',
                          child: Text('A-'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'B+',
                          child: Text('B+'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'B-',
                          child: Text('B-'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'AB+',
                          child: Text('AB+'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'AB-',
                          child: Text('AB-'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'O+',
                          child: Text('O+'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'O-',
                          child: Text('O-'),
                        ),
                      ],
                      onChanged: (String? value) {
                        _bloodgroupController.text = value ?? '';// Handle the selected blood group here
                        print('Selected blood group: $value');
                      },
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Age',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 116),
                      Container(
                        width: 200,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                        child: DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8),
                          ),
                          items: [
                            DropdownMenuItem<int>(
                              value: 18,
                              child: Text('18'),
                            ),
                            DropdownMenuItem<int>(
                              value: 19,
                              child: Text('19'),
                            ),
                            // Add other ages up to 60+
                            for (int i = 20; i <= 60; i++)
                              DropdownMenuItem<int>(
                                value: i,
                                child: Text(i.toString()),
                              ),
                            DropdownMenuItem<int>(
                              value: 61,
                              child: Text('60+'),
                            ),
                          ],
                          onChanged: (int? value) {
                            _ageController.text = value?.toString() ?? ''; // Handle the selected age here
                            print('Selected age: $value');
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Gender',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 88),
                      Container(
                        width: 200,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            items: [
                              DropdownMenuItem<String>(
                                value: 'Female',
                                child: Text('Female'),
                              ),
                            ],
                            onChanged: (String? value) {
                              _genderController.text = value ?? ''; // Handle the selected gender here
                              print('Selected Gender: $value');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Height(cm)',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 53),
                      Container(
                        width: 200,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                        child: TextField(
                          controller: _heightController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Weight(kg)',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width:56),
                      Container(
                        width: 200,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                        child: TextField(
                          controller: _weightController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Occupation',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 50),
                      Container(
                        width: 200,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                        child: TextField(
                          controller: _occupationController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'BMI',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 114),
                      Container(
                        width: 200,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                        child: TextField(
                          controller: _BMIController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8),
                            hintText: 'BMI = kg/m²', // This is where you set the BMI formula as a hint
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
          Row(
            children: [
              Text(
                'Last period',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(width: 50),
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  controller: _lastMenstrualPeriodController,
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null && pickedDate != _selectedDate) {
                      setState(() {
                        _selectedDate = pickedDate;
                        _lastMenstrualPeriodController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
                      });
                    }
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            ],
          ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Menstrual history',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              items: [
                                DropdownMenuItem<String>(
                                  value: 'regular',
                                  child: Text('regular'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'irregular',
                                  child: Text('irregular'),
                                ),
                              ],
                              onChanged: (String? value) {
                                _menstrualhistoryController.text = value ?? '';
                                print('Selected menstrual history: $value');
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Flow',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 120),
                Container(
                  width: 150,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: 'scanty',
                          child: Text('scanty'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'moderate',
                          child: Text('moderate'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'severe',
                          child: Text('severe'),
                        ),
                      ],
                      onChanged: (String? value) {
                        _flowController.text = value ?? '';
                        print('Selected flow: $value');
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Consanguineous:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () => _setconsanguineous('yes'),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: consanguineous == 'yes' ? Colors.black : Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('Yes'),
                    ],
                  ),
                ),
                SizedBox(width:30),
                GestureDetector(
                  onTap: () => _setconsanguineous('no'),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: consanguineous == 'no' ? Colors.black : Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('No'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Contraceptive\nhistory',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 40),
                Container(
                  width: 170,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextField(
                    controller: _contraceptiveHistoryController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Coital history',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width:46),
                    Container(
                      width: 170,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                      ),
                      child: TextField(
                        controller: _coitalHistoryController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ],
                ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Obstetric history',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width:18),
                Container(
                  width: 170,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextField(
                    controller: _obstetricHistoryController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Surgical history',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width:26),
                Container(
                  width: 170,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextField(
                    controller: _surgicalHistoryController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Text(
                  'Smoking:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 70),
                GestureDetector(
                  onTap: () => _setSmoking('yes'),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: smoking == 'yes' ? Colors.black : Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('Yes'),
                    ],
                  ),
                ),
                SizedBox(width: 60),
                GestureDetector(
                  onTap: () => _setSmoking('no'),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: smoking == 'no' ? Colors.black : Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('No'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Alcohol:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 80),
                GestureDetector(
                  onTap: () => _setAlcohol('yes'),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: alcohol == 'yes' ? Colors.black : Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('Yes'),
                    ],
                  ),
                ),
                SizedBox(width: 60),
                GestureDetector(
                  onTap: () => _setAlcohol('no'),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: alcohol == 'no' ? Colors.black : Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('No'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Medical history',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 24),
                Container(
                  width: 170,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextField(
                    controller: _medicalHistoryController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height:20),
          ],
        ),],
        ),],),),),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: GestureDetector(
            onTap: () async {
              await sendDataToBackend();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'NEXT',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xfffddbdc),
    );
  }
}