import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_processing/src/_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Input', () {
    group('Keyboard', () {
      testWidgets('keypress lifecycle', (tester) async {
        LogicalKeyboardKey? key;
        bool isKeyPressed = false;
        int keyPressedCallCount = 0;
        int keyReleasedCallCount = 0;

        final focusNode = FocusNode();
        focusNode.requestFocus();

        await tester.pumpWidget(
          Processing(
            focusNode: focusNode,
            sketch: Sketch.simple(
              draw: (s) async {
                s.noLoop();
              },
              keyPressed: (s) {
                keyPressedCallCount += 1;
                isKeyPressed = s.isKeyPressed as bool;
                key = s.key as LogicalKeyboardKey?;
              },
              keyReleased: (s) {
                keyReleasedCallCount += 1;
                isKeyPressed = s.isKeyPressed as bool;
                key = s.key as LogicalKeyboardKey?;
              },
            ),
          ),
        );

        await tester.sendKeyDownEvent(LogicalKeyboardKey.keyA);
        await tester.pumpAndSettle();

        expect(keyPressedCallCount, 1);
        expect(isKeyPressed, true);
        expect(keyReleasedCallCount, 0);
        expect(key, LogicalKeyboardKey.keyA);

        await tester.sendKeyUpEvent(LogicalKeyboardKey.keyA);
        await tester.pumpAndSettle();

        expect(keyPressedCallCount, 1);
        expect(keyReleasedCallCount, 1);
        expect(isKeyPressed, false);
        expect(key, LogicalKeyboardKey.keyA);
      });

      testWidgets('keyTyped invoked for non-control key', (tester) async {
        int keyTypedCallCount = 0;

        final focusNode = FocusNode();
        focusNode.requestFocus();

        await tester.pumpWidget(
          Processing(
            focusNode: focusNode,
            sketch: Sketch.simple(
              draw: (s) async {
                s.noLoop();
              },
              keyTyped: (s) {
                keyTypedCallCount += 1;
              },
            ),
          ),
        );

        await tester.sendKeyDownEvent(LogicalKeyboardKey.keyA);
        await tester.pumpAndSettle();

        expect(keyTypedCallCount, 1);
      });

      testWidgets('keyTyped NOT invoked for non-control key', (tester) async {
        int keyTypedCallCount = 0;

        final focusNode = FocusNode();
        focusNode.requestFocus();

        await tester.pumpWidget(
          Processing(
            focusNode: focusNode,
            sketch: Sketch.simple(
              draw: (s) async {
                s.noLoop();
              },
              keyTyped: (s) {
                keyTypedCallCount += 1;
              },
            ),
          ),
        );

        await tester.sendKeyDownEvent(LogicalKeyboardKey.control);
        await tester.pumpAndSettle();

        expect(keyTypedCallCount, 0);
      });
    });
  });
}
