import 'package:flutter_processing/flutter_processing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Random', () {
    testWidgets('random()', (tester) async {
      await tester.pumpWidget(
        Processing(
          sketch: Sketch.simple(
            draw: (s) async {
              s
                ..noLoop()
                ..randomSeed(0);
              double randomValue = s.random(50);
              expect(randomValue, 41.27570359435851);

              randomValue = s.random(-50, 50);
              expect(randomValue, 38.63148172405516);
            },
          ),
        ),
      );
    });
  });
}
