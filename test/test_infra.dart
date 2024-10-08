// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

void configureWindowSpecTest(WidgetTester tester) {
  tester.binding.window
    ..physicalSizeTestValue = Size(100, 100)
    ..devicePixelRatioTestValue = 1.0;
}
