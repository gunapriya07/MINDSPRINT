import 'package:flutter/material.dart';
import 'screens/landing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindBloom Quiz',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const LandingPage(),
    );
  }
}
