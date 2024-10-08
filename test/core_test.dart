// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_processing/src/_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'test_infra.dart';

void main() {
  group('core', () {
    testGoldens('setup() paints light grey background by default.',
        (tester) async {
      configureWindowSpecTest(tester);

      await tester.pumpWidget(
        Processing(
          sketch: Sketch.simple(),
        ),
      );

      await screenMatchesGolden(tester, 'core_default_background');
    });
    testGoldens('User can paint background in setup().', (tester) async {
      configureWindowSpecTest(tester);

      await tester.pumpWidget(
        Processing(
          sketch: Sketch.simple(
            setup: (s) {
              s.background(color: const Color(0xFF404040));
            },
          ),
        ),
      );

      await screenMatchesGolden(tester, 'core_setup_background');
    });
  });

  testGoldens('User can paint background in draw().', (tester) async {
    configureWindowSpecTest(tester);

    await tester.pumpWidget(
      Processing(
        sketch: Sketch.simple(
          draw: (s) {
            s.background(color: const Color(0xFF404040));
          },
        ),
      ),
    );

    await screenMatchesGolden(tester, 'core_draw_background');
  });

  testGoldens('User can paint orange background.', (tester) async {
    configureWindowSpecTest(tester);

    await tester.pumpWidget(
      Processing(
        sketch: Sketch.simple(
          draw: (s) {
            s.background(color: const Color(0xFFFFCC00));
          },
        ),
      ),
    );

    await screenMatchesGolden(tester, 'core_draw_background_orange');
  });

  testGoldens('background() in draw() replaces background in setup()',
      (tester) async {
    configureWindowSpecTest(tester);
    await tester.pumpWidget(
      Processing(
        sketch: Sketch.simple(
          setup: (s) {
            s.background(color: const Color(0xFFFF0000));
          },
          draw: (s) {
            s.background(color: const Color(0xFF404040));
          },
        ),
      ),
    );

    await screenMatchesGolden(tester, 'core_background_setup_draw');
  });
}

/*class PaintBackgroundInSetupSketch extends Sketch {
  @override
  void setup() {
    background(color: const Color(0xFF404040));
  }
}

class PaintBackgroundInDrawSketch extends Sketch {
  @override
  void draw() {
    background(color: const Color(0xFF404040));
  }
}

class PaintOrangeBackgroundSketch extends Sketch {
  @override
  void draw() {
    background(color: const Color(0xFFFFCC00));
  }
}

class PaintBackgroundInSetupAndDrawSketch extends Sketch {
  @override
  void setup() {
    background(color: const Color(0xFFFF0000));
  }

  @override
  void draw() {
    background(color: const Color(0xFF404040));
  }
}*/
