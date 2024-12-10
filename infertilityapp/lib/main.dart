import 'package:flutter/material.dart';
import 'second_page.dart';

void main() {
  runApp(MyApp(userId: 'userId',));
}

class MyApp extends StatelessWidget {
  final String userId; // Define userId as a parameter

  // Constructor to receive userId
  MyApp({required this.userId});

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Infertility App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  get userId => userId;

  @override
  void initState() {
    super.initState();
    // Navigate to the second page after a delay
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Image.asset(
              'assets/image.png',
              width: 270,
              height: 270,
            ),
            SizedBox(height: 20), // Adding some space between the image and text
            Text(
              '"We help you to be \n        complete"',
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xfffddbdc),
    );
  }
}
