import 'dart:math';

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

  //***************RANDOM******************//

  Random _random = Random();

  //Sets the seed value for all [random()] invocations to the given [seed].

  //To return to a natural seed value, pass [null] for [seed].
  void randomSeed(int seed) {
    _random = Random(seed);
  }

  double random(int bound1, [int? bound2]) {
    final lowerBound = bound2 != null ? bound1 : 0;
    final upperBound = bound2 ?? bound1; //bound2 != null ? bound2 : bound1

    if (upperBound < lowerBound) {
      throw Exception('random() lower bound must be less than upper bound');
    }
    return _random.nextDouble() * (upperBound - lowerBound) + lowerBound;
  }

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

  //***************SHAPE/2D PRIMITIVES**************//
  void circle({
    required Offset center,
    required double diameter,
  }) {
    canvas
      ..drawCircle(center, diameter / 2, _fillPaint)
      ..drawCircle(center, diameter / 2, _strokePaint);
  }

  void ellipse(Ellipse ellipse) {
    canvas
      ..drawOval(ellipse.rect, _fillPaint)
      ..drawOval(ellipse.rect, _strokePaint);
  }

  void arc({
    required Ellipse ellipse,
    required double startAngle,
    required double endAngle,
    ArcMode mode = ArcMode.openStrokePieFill,
  }) {
    switch (mode) {
      case ArcMode.open:
        canvas.drawArc(
          ellipse.rect,
          startAngle,
          endAngle - startAngle,
          false,
          _fillPaint,
        );
        canvas.drawArc(
          ellipse.rect,
          startAngle,
          endAngle - startAngle,
          false,
          _strokePaint,
        );
      case ArcMode.chord:
        final chordPath = Path()
          ..addArc(ellipse.rect, startAngle, endAngle - startAngle)
          ..close();
        canvas.drawArc(
          ellipse.rect,
          startAngle,
          endAngle - startAngle,
          true,
          _fillPaint,
        );
        canvas.drawPath(
          chordPath,
          _strokePaint,
        );
      case ArcMode.pie:
        canvas.drawArc(
          ellipse.rect,
          startAngle,
          endAngle - startAngle,
          true,
          _fillPaint,
        );
        canvas.drawArc(
          ellipse.rect,
          startAngle,
          endAngle - startAngle,
          true,
          _strokePaint,
        );
      case ArcMode.openStrokePieFill:
        canvas.drawArc(
          ellipse.rect,
          startAngle,
          endAngle - startAngle,
          true,
          _fillPaint,
        );
        canvas.drawArc(
          ellipse.rect,
          startAngle,
          endAngle - startAngle,
          false,
          _strokePaint,
        );
    }
  }

  void square(Square square) {
    canvas
      ..drawRect(square.rect, _fillPaint)
      ..drawRect(square.rect, _strokePaint);
  }

  void rect({
    required Rect rect,
    BorderRadius? borderRadius,
  }) {
    if (borderRadius == null) {
      canvas
        ..drawRect(rect, _fillPaint)
        ..drawRect(rect, _strokePaint);
    } else {
      final rrect = RRect.fromRectAndCorners(
        rect,
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
      );
      canvas
        ..drawRRect(rrect, _fillPaint)
        ..drawRRect(rrect, _strokePaint);
    }
  }

  void triangle(Offset pt1, Offset pt2, Offset pt3) {
    final path = Path()
      ..moveTo(pt1.dx, pt1.dy)
      ..lineTo(pt2.dx, pt2.dy)
      ..lineTo(pt3.dx, pt3.dy)
      ..close();
    canvas
      ..drawPath(path, _fillPaint)
      ..drawPath(path, _strokePaint);
  }

  void quad(Offset pt1, Offset pt2, Offset pt3, Offset pt4) {
    final path = Path()
      ..moveTo(pt1.dx, pt1.dy)
      ..lineTo(pt2.dx, pt2.dy)
      ..lineTo(pt3.dx, pt3.dy)
      ..lineTo(pt4.dx, pt4.dy)
      ..close();
    canvas
      ..drawPath(path, _fillPaint)
      ..drawPath(path, _strokePaint);
  }

  void line(Offset pt1, Offset pt2, [Offset? pt3]) {
    if (pt3 != null) {
      throw UnimplementedError('3D line drawing is not yet supported.');
    }
    canvas.drawLine(pt1, pt2, _strokePaint);
  }

  void point({required double x, required double y, double? z}) {
    if (z != null) {
      throw UnimplementedError('3d point drawing is not yet supported.');
    }
    _strokePaint.style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(x, y, 1, 1),
      _strokePaint,
    );
    _strokePaint.style = PaintingStyle.stroke;
  }
}

class Square {
  Square.fromLTE(Offset topLeft, double extent)
      : _rect = Rect.fromLTWH(
          topLeft.dx,
          topLeft.dy,
          extent,
          extent,
        );

  Square.fromCenter(Offset center, double extent)
      : _rect = Rect.fromCenter(
          center: center,
          width: extent,
          height: extent,
        );

  final Rect _rect;
  Rect get rect => _rect;
}

class Ellipse {
  Ellipse.fromLTWH({
    required Offset topLeft,
    required double width,
    required double height,
  }) : _rect = Rect.fromLTWH(
          topLeft.dx,
          topLeft.dy,
          width,
          height,
        );

  Ellipse.fromLTRB({
    required Offset topLeft,
    required Offset bottomRight,
  }) : _rect = Rect.fromLTRB(
          topLeft.dx,
          topLeft.dy,
          bottomRight.dx,
          bottomRight.dy,
        );

  Ellipse.fromCenter({
    required Offset center,
    required double width,
    required double height,
  }) : _rect = Rect.fromCenter(
          center: center,
          width: width,
          height: height,
        );

  Ellipse.fromCenterWithRadius({
    required Offset center,
    required double radius1,
    required double radius2,
  }) : _rect = Rect.fromCenter(
          center: center,
          width: radius1 * 2,
          height: radius2 * 2,
        );

  final Rect _rect;
  Rect get rect => _rect;
}

enum ArcMode { openStrokePieFill, open, chord, pie }

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
