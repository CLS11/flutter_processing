import 'package:flutter/material.dart';
import 'package:flutter_processing/src/_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_infra.dart';

void main() {
  group('Color', () {
    group('setting', () {
      testGoldens('fill(): example 1', (tester) async {
        configureWindowSpecTest(tester);

        await tester.pumpWidget(
          Processing(
            sketch: Sketch.simple(
              draw: (s) async {
                s
                  ..noLoop()
                  ..fill(color: const Color(0xFF969696))
                  ..rect(
                    rect: Rect.fromLTWH(30, 20, 55, 55),
                  );
              },
            ),
          ),
        );

        await screenMatchesGolden(tester, 'color_setting_fill-example-1');
      });

      testGoldens('fill(): example 2', (tester) async {
        configureWindowSpecTest(tester);

        await tester.pumpWidget(
          Processing(
            sketch: Sketch.simple(
              draw: (s) async {
                s
                  ..noLoop()
                  ..fill(color: const Color(0xFFCC6600))
                  ..rect(
                    rect: Rect.fromLTWH(30, 20, 55, 55),
                  );
              },
            ),
          ),
        );

        await screenMatchesGolden(tester, 'color_setting_fill-example-2');
      });

      testGoldens('stroke(): example 1', (tester) async {
        configureWindowSpecTest(tester);

        await tester.pumpWidget(
          Processing(
            sketch: Sketch.simple(
              draw: (s) async {
                s
                  ..noLoop()
                  ..stroke(color: const Color(0xFFAAAAAA))
                  ..rect(
                    rect: Rect.fromLTWH(30, 20, 55, 55),
                  );
              },
            ),
          ),
        );

        await screenMatchesGolden(tester, 'color_setting_stroke-example-1');
      });

      testGoldens('stroke(): example 2', (tester) async {
        configureWindowSpecTest(tester);

        await tester.pumpWidget(
          Processing(
            sketch: Sketch.simple(
              draw: (s) async {
                s
                  ..noLoop()
                  ..stroke(color: const Color(0xFFCC6600))
                  ..rect(
                    rect: Rect.fromLTWH(30, 20, 55, 55),
                  );
              },
            ),
          ),
        );

        await screenMatchesGolden(tester, 'color_setting_stroke-example-2');
      });

      testGoldens('nostroke(): example 1', (tester) async {
        configureWindowSpecTest(tester);

        await tester.pumpWidget(
          Processing(
            sketch: Sketch.simple(
              draw: (s) async {
                s
                  ..noLoop()
                  ..noStroke()
                  ..rect(
                    rect: Rect.fromLTWH(30, 20, 55, 55),
                  );
              },
            ),
          ),
        );

        await screenMatchesGolden(tester, 'color_setting_noStroke-example-1');
      });
      testGoldens('background(): example1', (tester) async {
        configureWindowSpecTest(tester);

        await tester.pumpWidget(
          Processing(
            sketch: Sketch.simple(
              draw: (s) async {
                s.background(color: const Color(0xFF404040));
              },
            ),
          ),
        );

        await screenMatchesGolden(tester, 'color_setting_background-example-1');
      });

      testGoldens('background(): example2.', (tester) async {
        configureWindowSpecTest(tester);

        await tester.pumpWidget(
          Processing(
            sketch: Sketch.simple(
              draw: (s) async {
                s
                  ..noLoop()
                  ..background(color: const Color(0xFFFFCC00));
              },
            ),
          ),
        );

        await screenMatchesGolden(tester, 'color_setting_background-example-2');
      });

      testGoldens('nofill(): example 1', (tester) async {
        configureWindowSpecTest(tester);

        await tester.pumpWidget(
          Processing(
            sketch: Sketch.simple(
              draw: (s) async {
                s
                  ..noLoop()
                  ..rect(rect: Rect.fromLTWH(15, 10, 55, 55))
                  ..noFill()
                  ..rect(rect: Rect.fromLTWH(30, 20, 55, 55));
              },
            ),
          ),
        );

        await screenMatchesGolden(tester, 'color_setting_nofill-example-1');
      });

      testGoldens('User can paint background in setup().', (tester) async {
        configureWindowSpecTest(tester);

        await tester.pumpWidget(
          Processing(
            sketch: Sketch.simple(
              setup: (s) async {
                s
                  ..noLoop()
                  ..background(color: const Color(0xFF404040));
              },
            ),
          ),
        );

        await screenMatchesGolden(tester, 'color_setting_background-in-setup');
      });
    });

    testGoldens('background() in draw() replaces background in setup()',
        (tester) async {
      configureWindowSpecTest(tester);
      await tester.pumpWidget(
        Processing(
          sketch: Sketch.simple(
            setup: (s) async {
              s
                ..noLoop()
                ..background(color: const Color(0xFFFF0000));
            },
            draw: (s) async {
              s.background(color: const Color(0xFF404040));
            },
          ),
        ),
      );

      await screenMatchesGolden(tester, 'color_setting_background-setup-draw');
    });
  });
}
