import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Image', () {
    group('Loading and Displaying', () {
      testWidgets('loads and displays image assets', (tester) async {
       late  Image loadedImage;
        await tester.pumpWidget(
          Processing(
            sketch: Sketch.simple(
              setup: (s) async {
                s.size(width: 500, height: 500);
                loadedImage = await s.loadImage('assets/3.png');
              },
              draw: (s) async {
                 s.image(image: loadedImage);
              },
            ),
          ),
        );
      });
    });
  });
}
