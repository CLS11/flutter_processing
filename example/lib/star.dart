import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';

class Star {
  Star({
    required this.x,
    required this.y,
    required this.z,
  });
  double x;
  double y;
  double z;

  void update() {
    z -= 1;
  }

  void paint(Sketch s) {
    final center = Offset(s.width / 2, s.height / 2);
    final perspectiveOffset = Offset(
      lerpDouble(-s.width / 2, s.width / 2, x / z)!,
      lerpDouble(-s.height / 2, s.height / 2, y / z)!,
    );
    s
      ..noStroke()
      ..fill(color: Colors.white)
      ..circle(center: perspectiveOffset + center, diameter: 4);
  }
}
