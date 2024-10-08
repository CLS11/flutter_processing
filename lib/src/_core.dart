import 'package:flutter/material.dart';

class Processing extends StatelessWidget {
  const Processing({required this.sketch, super.key});

  final Sketch sketch;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _SketchPainter(
        sketch: sketch,
      ),
    );
  }
}

class Sketch {
  Sketch();

  Sketch.simple({
    required void Function(Sketch) setup,
    required void Function(Sketch) draw,
  })  : _setup = setup,
        _draw = draw;

  late void Function(Sketch) _setup;
  late void Function(Sketch) _draw;

  void setup() {
    _setup(this); // Call the setup method with 'this' as the parameter
  }

  void draw() {
    _draw(this);
  }

  late Canvas canvas;
  late Size size;

  void background({required Color color}) {
    assert(canvas != null);
    assert(size != null);

    final paint = Paint()..color = color;
    canvas.drawRect(Offset.zero & size, paint);
  }
}

class _SketchPainter extends CustomPainter {
  _SketchPainter({required this.sketch}) : assert(sketch != null);

  final Sketch sketch;

  @override
  void paint(Canvas canvas, Size size) {
    sketch
      ..canvas = canvas
      ..size = size
      ..setup()
      ..draw();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Return false to indicate that it does not need to repaint
  }
}
