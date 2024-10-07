// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_processing/src/_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  group('core', () {
    testGoldens('User can paint with processing widget', (tester) async {
      tester.binding.window
        ..physicalSizeTestValue = Size(100, 100)
        ..devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        Processing(
          sketch: MyTestSketch(),
        ),
      );

      await screenMatchesGolden(tester, 'core_api');
    });
  });
}

class MyTestSketch extends Sketch {
  @override
  void draw() {
    background(color: const Color(0xFF404040));
  }
}
