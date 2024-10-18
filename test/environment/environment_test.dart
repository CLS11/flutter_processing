// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_processing/src/_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_infra.dart';

void main() {
  group('Environment', () {
    testGoldens('width()', (tester) async {
      configureWindowSpecTest(tester);
      await tester.pumpWidget(
        Processing(
          sketch: Sketch.simple(
            draw: (s) {
              s
                ..noLoop()
                ..noStroke()
                ..background(color: Colors.black)
                ..rect(rect: Rect.fromLTWH(0, 40, s.width.toDouble(), 20))
                ..rect(rect: Rect.fromLTWH(0, 60, s.width / 2, 20));
            },
          ),
        ),
      );

      await screenMatchesGolden(
        tester,
        'environment_width-example-1',
        // customPump: (tester) async {
        //   await tester.pump(const Duration(milliseconds: 17));
        // },
      );
    });

    testGoldens('height()', (tester) async {
      configureWindowSpecTest(tester);
      await tester.pumpWidget(
        Processing(
          sketch: Sketch.simple(
            draw: (s) {
              s
                ..noLoop()
                ..noStroke()
                ..background(color: Colors.black)
                ..rect(rect: Rect.fromLTWH(40, 0, 20, s.height.toDouble()))
                ..rect(rect: Rect.fromLTWH(60, 0, 20, s.height / 2));
            },
          ),
        ),
      );

      await screenMatchesGolden(
        tester,
        'environment_height-example-1',
        // customPump: (tester) async {
        //  await tester.pump(const Duration(milliseconds: 17));
        // },
      );
    });

    testGoldens('size()', (tester) async {
      configureWindowSpecTest(tester);
      //Expanding the canvas size
      tester.binding.window.physicalSizeTestValue = Size(200, 200);
      await tester.pump();
      await tester.pumpWidget(
        Processing(
          sketch: Sketch.simple(
            setup: (s) {
              s
                ..noLoop()
                ..size(width: 500, height: 500);
            },
            draw: (s) {
              s.circle(center: const Offset(50, 50), diameter: 25);
            },
          ),
        ),
      );

      await screenMatchesGolden(
        tester,
        'environment_size-example-1',
        // customPump: (tester) async {
        //   await tester.pump(const Duration(milliseconds: 17));
        // },
      );
    });
  });
}
