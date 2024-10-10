// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_processing/src/_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_infra.dart';

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

      await screenMatchesGolden(tester, 'core_setup-paints-default-background');
    });
  });
}
