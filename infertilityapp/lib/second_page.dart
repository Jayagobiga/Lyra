import 'package:flutter/material.dart';
import 'package:infertilityapp/admin.dart';
import 'package:infertilityapp/fourth_page.dart';
import 'package:infertilityapp/third_page.dart';

class SecondPage extends StatelessWidget {
// Define userId as a parameter

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double buttonWidth = screenWidth * 0.83; // Adjust button width as a percentage of screen width
    double buttonHeight = screenHeight * 0.07; // Adjust button height as a percentage of screen height

    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Row(
      //     children: [
      //       GestureDetector(
      //         onTap: () {
      //           Navigator.pop(context); // Navigate to the previous page
      //         },
      //         child: Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: Icon(
      //             Icons.arrow_back_ios, // Path to your image asset
      //             size: 25,
      //             color: Colors.black,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: SingleChildScrollView(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Image.asset(
              'assets/frontpic.png',
              width: 400,
              height: 400,
            ),
            // SizedBox(height:5),
            // ElevatedButton(
            //   style: ButtonStyle(
            //     fixedSize: MaterialStateProperty.all(Size(buttonWidth, buttonHeight)),
            //     padding: MaterialStateProperty.all(EdgeInsets.all(0)),
            //     backgroundColor: MaterialStateProperty.all(Color(0xffed4662)),
            //     shape: MaterialStateProperty.all(RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(0),
            //     )),
            //   ),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => Admin()),
            //     );
            //   },
            //   child: const Text(
            //     'Admin Login',
            //     style: TextStyle(
            //       fontSize: 22,
            //       color: Colors.white,
            //       fontWeight: FontWeight.normal,
            //     ),
            //   ),
            // ),
            SizedBox(height:30), // Adjust spacing as a percentage of screen height
            ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(Size(buttonWidth, buttonHeight)),
                padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                backgroundColor: MaterialStateProperty.all(Color(0xffed4662)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
                elevation: MaterialStateProperty.all(5),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ThirdPage()),
                );
              },
              child: Text(
                'Doctor Login',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height:30), // Adjust spacing as a percentage of screen height
            ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(Size(buttonWidth, buttonHeight)),
                padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                backgroundColor: MaterialStateProperty.all(Color(0xffed4662)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
                elevation: MaterialStateProperty.all(5),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FourthPage()),
                );
              },
              child: Text(
                'Patient Login',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height:50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Are you admin?',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Admin()),
                    );
                  },
                  child: Text(
                    'Admin',
                    style: TextStyle(
                      fontSize: 19.0,fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xfffddbdc),
    );
  }
}
