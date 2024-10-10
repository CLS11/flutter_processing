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
              draw: (s) {
                s.fill(color: const Color(0xFF969696));
                s.circle(
                  center: const Offset(56, 46),
                  diameter: 55,
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
              draw: (s) {
                s.fill(color: const Color(0xFFCC6600));
                s.circle(
                  center: const Offset(56, 46),
                  diameter: 55,
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
              draw: (s) {
                s.stroke(color: const Color(0xFFAAAAAA));
                s.circle(
                  center: const Offset(56, 46),
                  diameter: 55,
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
              draw: (s) {
                s.stroke(color: const Color(0xFFCC6600));
                s.circle(
                  center: const Offset(56, 46),
                  diameter: 55,
                );
              },
            ),
          ),
        );

        await screenMatchesGolden(tester, 'color_setting_stroke-example-2');
      });

      testGoldens('fill(): example 1', (tester) async {
        configureWindowSpecTest(tester);

        await tester.pumpWidget(
          Processing(
            sketch: Sketch.simple(
              draw: (s) {
                s.fill(color: const Color(0xFF969696));
                s.circle(
                  center: const Offset(56, 46),
                  diameter: 55,
                );
              },
            ),
          ),
        );

        await screenMatchesGolden(tester, 'color_setting_fill-example-1');
      });

      testGoldens('nostroke(): example 1', (tester) async {
        configureWindowSpecTest(tester);

        await tester.pumpWidget(
          Processing(
            sketch: Sketch.simple(
              draw: (s) {
                s.noStroke();
                s.circle(
                  center: const Offset(56, 46),
                  diameter: 55,
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
              draw: (s) {
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
              draw: (s) {
                s.background(color: const Color(0xFFFFCC00));
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
              draw: (s) {
                s.circle(
                  center: const Offset(40, 40),
                  diameter: 55,
                );
                s.noFill();
                s.circle(
                  center: const Offset(60, 60),
                  diameter: 55,
                );
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
              setup: (s) {
                s.background(color: const Color(0xFF404040));
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
            setup: (s) {
              s.background(color: const Color(0xFFFF0000));
            },
            draw: (s) {
              s.background(color: const Color(0xFF404040));
            },
          ),
        ),
      );

      await screenMatchesGolden(tester, 'color_setting_background-setup-draw');
    });
  });
}
