import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class Adminpage extends StatelessWidget {
  // URL for the CSV download (replace with your actual URL)
  final String downloadUrl = "http://192.168.2.105:80/Infertilityapp/download_csv.php";  // PHP script that generates the CSV file

  // Method to download the CSV file
  Future<void> downloadFile(BuildContext context) async {
    // Check and request storage permission
    if (await Permission.storage.request().isGranted) {
      try {
        // Open the file picker to choose the folder
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['csv'],  // only allow CSV files
          withData: false,  // We don't need file data, just the path
        );

        if (result != null) {
          String? path = result.files.single.path;
          if (path != null) {
            // Now we will download the file and save it in the selected directory
            Dio dio = Dio();
            final filePath = "$path/patient_details.csv"; // Save as 'patient_details.csv'
            await dio.download(downloadUrl, filePath);

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("File downloaded to $filePath")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("No folder selected")),
            );
          }
        } else {
          // If no file was selected
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No folder selected")),
          );
        }
      } catch (e) {
        // Show error message if download fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error downloading file: $e")),
        );
      }
    } else {
      // Show message if storage permission is denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Storage permission denied")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              // Show dialog when the file.png is clicked
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Download CSV"),
                    content: Text("Do you want to download all the patient details?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Action for "No"
                          Navigator.of(context).pop();
                        },
                        child: Text("No"),
                      ),
                      TextButton(
                        onPressed: () {
                          // Action for "Yes"
                          Navigator.of(context).pop();
                          downloadFile(context); // Trigger download logic here
                        },
                        child: Text("Yes"),
                      ),
                    ],
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/file.png', // Ensure you have this image in your assets folder
                width: 40,
                height: 40,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 110.0),
            Center(
              child: Container(
                width: 300.0,
                height: 450.0,
                margin: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: LinearGradient(
                    colors: [Colors.cyan.shade300, Colors.grey.shade200],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.2, 1.0],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        'assets/alogin.png', // Ensure this image exists in your assets
                        width: 150,
                        height: 150,
                      ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to SecondPage or any other page for adding a doctor
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                      ),
                      child: Text('Add Doctor', style: TextStyle(fontSize: 18)),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to SecondPage or any other page for adding a patient
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                      ),
                      child: Text('Add Patient', style: TextStyle(fontSize: 18)),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to SecondPage or any other page for viewing a doctor
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                      ),
                      child: Text('View Doctor', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
