import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
        child: SizedBox(
          width: 800,
          height: 500,
          child: Processing(
            sketch: Sketch.simple(
              setup: (s) {
                print('setup()');
              },
              draw: (s) {
                print('draw(), frame: ${s.frameCount}');
              },
            ),
          ),
        ),
      ),
    );
  }
}
