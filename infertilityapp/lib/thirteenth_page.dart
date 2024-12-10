import 'package:flutter/material.dart';
class ThirteenthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thirteenth Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update UI based on item 1
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update UI based on item 2
                Navigator.pop(context);
              },
            ),
            // Add more list items as needed
          ],
        ),
      ),
      body: Center(
        child: Text(
          'This is the thirteenth page content.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}