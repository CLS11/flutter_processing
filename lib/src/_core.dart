import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Processing extends StatefulWidget {
  const Processing({required this.sketch, super.key});

  final Sketch sketch;

  @override
  State<Processing> createState() => _ProcessingState();
}

class _ProcessingState extends State<Processing>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void didUpdateWidget(Processing oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.sketch != oldWidget.sketch) {
      _ticker
        ..stop()
        ..start();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _ticker.dispose();
  }

  void _onTick(dynamic elapsedTime) {
    print('Tick: $elapsedTime');
    setState(
      () {
        widget.sketch.draw();
        widget.sketch.elapsedTime = elapsedTime as Duration;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(
          widget.sketch._desiredWidth.toDouble(),
          widget.sketch._desiredHeight.toDouble(),
        ),
        painter: _SketchPainter(
          sketch: widget.sketch,
        ),
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

  bool _hasDoneSetup = false;

  void _doSetup() {
    if (_hasDoneSetup) {
      return;
    }
    _hasDoneSetup = true;
    assert(_canvas != null);
    assert(size != null);
    //Default background color
    background(color: _backgroundColor);

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

  void _onDraw() {
    background(color: _backgroundColor);

    draw();

    if (_lastDrawTime != null) {
      if (_elapsedTime - _lastDrawTime! < _desiredFrameTime) {
        return;
      }
    }

    _frameCount += 1;
    _lastDrawTime = _elapsedTime;

    final secondsFraction = _elapsedTime.inMilliseconds / 1000.0;
    _actualFrameRate = secondsFraction > 0
        ? (_frameCount / secondsFraction).round()
        : _actualFrameRate;
  }

  void draw() {
    _draw?.call(this);
  }

  late Canvas _canvas;
  late Size _size;
  late Paint _fillPaint;
  late Paint _strokePaint;
  late Color _backgroundColor = const Color(0xffc5c5c5c5c);

  int _desiredWidth = 100;
  int _desiredHeight = 100;

  //***************ENVIRONMENT*************//
  Duration _elapsedTime = Duration.zero;
  set elapsedTime(Duration newElapsedTime) => _elapsedTime = newElapsedTime;

  Duration? _lastDrawTime;

  int _frameCount = 0;
  int get frameCount => _frameCount;
  int _actualFrameRate = 10;
  int get frameRate => _actualFrameRate;
  Duration _desiredFrameTime = Duration(milliseconds: (1000.0 / 60).floor());
  set frameRate(int frameRate) =>
      _desiredFrameTime = Duration(milliseconds: (1000.0 / frameRate).floor());

  int get width => _size.width.toInt();

  int get height => _size.height.toInt();

  void size({required int width, required int height}) {
    _desiredWidth = width;
    _desiredHeight = height;
  }

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
    _backgroundColor = color;
    final paint = Paint()..color = color;
    _canvas.drawRect(Offset.zero & _size, paint);
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
    _canvas
      ..drawCircle(center, diameter / 2, _fillPaint)
      ..drawCircle(center, diameter / 2, _strokePaint);
  }

  void ellipse(Ellipse ellipse) {
    _canvas
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
        _canvas.drawArc(
          ellipse.rect,
          startAngle,
          endAngle - startAngle,
          false,
          _fillPaint,
        );
        _canvas.drawArc(
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
        _canvas.drawArc(
          ellipse.rect,
          startAngle,
          endAngle - startAngle,
          true,
          _fillPaint,
        );
        _canvas.drawPath(
          chordPath,
          _strokePaint,
        );
      case ArcMode.pie:
        _canvas.drawArc(
          ellipse.rect,
          startAngle,
          endAngle - startAngle,
          true,
          _fillPaint,
        );
        _canvas.drawArc(
          ellipse.rect,
          startAngle,
          endAngle - startAngle,
          true,
          _strokePaint,
        );
      case ArcMode.openStrokePieFill:
        _canvas.drawArc(
          ellipse.rect,
          startAngle,
          endAngle - startAngle,
          true,
          _fillPaint,
        );
        _canvas.drawArc(
          ellipse.rect,
          startAngle,
          endAngle - startAngle,
          false,
          _strokePaint,
        );
    }
  }

  void square(Square square) {
    _canvas
      ..drawRect(square.rect, _fillPaint)
      ..drawRect(square.rect, _strokePaint);
  }

  void rect({
    required Rect rect,
    BorderRadius? borderRadius,
  }) {
    if (borderRadius == null) {
      _canvas
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
      _canvas
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
    _canvas
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
    _canvas
      ..drawPath(path, _fillPaint)
      ..drawPath(path, _strokePaint);
  }

  void line(Offset pt1, Offset pt2, [Offset? pt3]) {
    if (pt3 != null) {
      throw UnimplementedError('3D line drawing is not yet supported.');
    }
    _canvas.drawLine(pt1, pt2, _strokePaint);
  }

  void point({required double x, required double y, double? z}) {
    if (z != null) {
      throw UnimplementedError('3d point drawing is not yet supported.');
    }
    _strokePaint.style = PaintingStyle.fill;
    _canvas.drawRect(
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
      .._canvas = canvas
      .._size = size
      .._doSetup()
      .._onDraw();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Return false to indicate that it does not need to repaint
  }
}
