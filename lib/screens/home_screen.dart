import 'package:flutter/material.dart';
import 'checkin_screen.dart';
import 'checkout_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Smart Class Check-in')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 60),
                backgroundColor: Colors.green,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CheckInScreen()),
              ),
              child: Text(
                'Check-in (Before Class)',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 60),
                backgroundColor: Colors.orange,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CheckOutScreen()),
              ),
              child: Text(
                'Finish Class (After Class)',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
