import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';

class Droplet {
  Droplet({
    required this.x,
    required this.y,
    required this.z,
    required this.length,
  });
  double x;
  double y;
  double z;
  double length;

  void fall(Sketch s) {
    y += lerpDouble(8, 20, z)!;

    if (y > s.height) {
      y = 0;
      z = s.random(1);
    }
  }

  void show(Sketch s) {
    final perspectiveLength = lerpDouble(0.2 * length, length, z);

    s
      ..stroke(color: Color.fromARGB(255, 128, 43, 226))
      ..line(Offset(x, y), Offset(x, y + perspectiveLength!));
  }
}
