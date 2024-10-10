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
    void Function(Sketch)? setup,
    void Function(Sketch)? draw,
  })  : _setup = setup,
        _draw = draw;

  late void Function(Sketch)? _setup = (s) {};
  late void Function(Sketch)? _draw = (s) {};
  void _doSetup() {
    assert(canvas != null);
    assert(size != null);
    //Default background color
    background(color: const Color(0xFFC5C5C5));

    _fillPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;

    _strokePaint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    setup();
  }

  void setup() {
    _setup?.call(this);
  }

  void draw() {
    _draw?.call(this);
  }

  late Canvas canvas;
  late Size size;
  late Paint _fillPaint;
  late Paint _strokePaint;

  //**************COLOR/SETTING **************//

  void background({required Color color}) {
    final paint = Paint()..color = color;
    canvas.drawRect(Offset.zero & size, paint);
  }

  void fill({
    required Color color,
  }) {
    _fillPaint.color = color;
  }

  void noFill() {
    _fillPaint.color = const Color(0x00000000);
  }

  void stroke({
    required Color color,
  }) {
    _strokePaint.color = color;
  }

  void noStroke() {
    _strokePaint.color = const Color(0x00000000);
  }

  //***************SHAPE/2D PRIMITIVE************//
  void circle({
    required Offset center,
    required double diameter,
  }) {
    canvas
      ..drawCircle(center, diameter / 2, _fillPaint)
      ..drawCircle(center, diameter / 2, _strokePaint);
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
      .._doSetup()
      ..draw();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Return false to indicate that it does not need to repaint
  }
}
