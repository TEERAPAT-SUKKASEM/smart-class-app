import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Import our custom home screen

void main() {
  runApp(const SmartClassApp());
}

class SmartClassApp extends StatelessWidget {
  const SmartClassApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Class App',
      debugShowCheckedModeBanner: false, // Removes the little "DEBUG" banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      // This is the magic line that connects to your code!
      home: HomeScreen(),
    );
  }
}
