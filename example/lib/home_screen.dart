import 'package:example/star.dart';
import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _stars = <Star>[];

  @override
  void reassemble() {
    super.reassemble();
    _stars.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
        child: Processing(
          sketch: Sketch.simple(
            setup: (s) {
              const width = 1600;
              const height = 900;

              s
                ..size(width: width, height: height)
                ..background(color: Colors.black);

              if (_stars.isEmpty) {
                for (int i = 0; i < 100; ++i) {
                  _stars.add(
                    Star(
                      x: s.random((-width / 2).toInt(), (width / 2).toInt()),
                      y: s.random((-height / 2).toInt(), (height / 2).toInt()),
                      z: s.random(width),
                    ),
                  );
                }
              }
            },
            draw: (s) {
              s.background(color: Colors.black);
              for (final star in _stars) {
                star.update(s);
              }
              for (final star in _stars) {
                star.paintStreak(s);
              }
              for (final star in _stars) {
                star.paintStar(s);
              }
            },
          ),
        ),
      ),
    );
  }
}
