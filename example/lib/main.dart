import 'package:example/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FlutterProcessingApp());
}

class FlutterProcessingApp extends StatelessWidget {
  const FlutterProcessingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Processing Example',
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

