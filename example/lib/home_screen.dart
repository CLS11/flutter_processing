import 'package:example/star.dart';
import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';
import 'package:example/droplet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //final _stars = <Star>[];

  final _droplets = <Droplet>[];

  @override
  void reassemble() {
    super.reassemble();
    // _stars.clear();
    _droplets.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
        child: Processing(
          sketch: Sketch.simple(
            setup: (s) {
              final width = 640;
              final height = 360;
              s
                ..size(width: width, height: height)
                ..background(color: Color.fromARGB(255, 200, 175, 250));

              for (int i = 0; i < 100; ++i) {
                _droplets.add(
                  Droplet(
                    x: s.random(width),
                    y: s.random(-height, 0),
                    z: s.random(1),
                    length: 20,
                  ),
                );
              }
            },
            draw: (s) {
              for (final droplet in _droplets) {
                droplet
                  ..fall(s)
                  ..show(s);
              }
            },
          ),
        ),
      ),
    );
  }
}
