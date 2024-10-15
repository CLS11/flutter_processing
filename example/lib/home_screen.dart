import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Offset _circleOffset = Offset(400, 250);

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
                s
                  ..setSize(width: 400, height: 400)
                  ..background(color: Colors.white);
              },
              draw: (s) {
                s.circle(
                  center: Size(s.width.toDouble(), s.height.toDouble())
                      .center(Offset.zero),
                  diameter: 50,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
