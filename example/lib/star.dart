import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';

class Star {
  Star({
    required this.x,
    required this.y,
    required this.z,
  }) : originalZ = 0 {
    originalZ = z;
  }
  double x;
  double y;
  double z;
  double originalZ;

  void update(Sketch s) {
    z -= 30;
    originalZ -= 10;

    if (z <= 0) {
      x = s.random((-s.width / 2) as int, (s.width / 2) as int?);
      y = s.random((-s.height / 2) as int, (s.height / 2) as int?);
      z = s.random(s.width);
      originalZ = z;
    }
  }

  void paintStreak(Sketch s) {
    final center = Offset(s.width / 2, s.height / 2);
    final perspectivePosition = Offset(
      lerpDouble(0, s.width, x / z)!,
      lerpDouble(0, s.height, y / z)!,
    );
    final perspectiveOrigin = Offset(
      lerpDouble(0, s.width, x / originalZ)!,
      lerpDouble(0, s.height, y / originalZ)!,
    );
    s
      ..stroke(color: Colors.white.withOpacity(0.30))
      ..line(perspectiveOrigin + center, perspectivePosition + center);
  }

  void paintStar(Sketch s) {
    final center = Offset(s.width / 2, s.height / 2);
    final perspectiveOffset = Offset(
      lerpDouble(0, s.width, x / z)!,
      lerpDouble(0, s.height, y / z)!,
    );
    final diameter = lerpDouble(8, 0, z / s.width);
    s
      ..noStroke()
      ..fill(color: Colors.white)
      ..circle(center: perspectiveOffset + center, diameter: diameter!);
  }
}
