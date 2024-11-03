// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class Processing extends StatefulWidget {
  const Processing({
    required this.sketch,
    this.clipBehavior = Clip.hardEdge,
    super.key,
    this.focusNode,
  });

  final FocusNode? focusNode;
  final Sketch sketch;
  final Clip clipBehavior;

  @override
  State<Processing> createState() => _ProcessingState();
}

class _ProcessingState extends State<Processing>
    with SingleTickerProviderStateMixin {
  final _controlKeys = <LogicalKeyboardKey>{
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.controlLeft,
    LogicalKeyboardKey.controlRight,
    LogicalKeyboardKey.meta, //for windows
    LogicalKeyboardKey.metaLeft,
    LogicalKeyboardKey.metaRight,
    LogicalKeyboardKey.alt,
    LogicalKeyboardKey.altLeft,
    LogicalKeyboardKey.altRight,
    LogicalKeyboardKey.shift,
    LogicalKeyboardKey.shiftLeft,
    LogicalKeyboardKey.shiftRight,
    LogicalKeyboardKey.capsLock,
    LogicalKeyboardKey.escape,
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.arrowRight,
    LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.home,
    LogicalKeyboardKey.pageDown,
    LogicalKeyboardKey.pageUp,
  };

  final GlobalKey _sketchCanvasKey = GlobalKey();
  late Ticker _ticker;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _ticker = Ticker(_onTick)..start();
    _focusNode = widget.focusNode ?? FocusNode();

    widget.sketch._loop = _loop;
    widget.sketch._noLoop = _noLoop;
  }

  @override
  void didUpdateWidget(Processing oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode = widget.focusNode ?? FocusNode();
    }

    if (widget.sketch != oldWidget.sketch) {
      oldWidget.sketch
        .._loop = null
        .._noLoop = null;
      widget.sketch
        .._loop = _loop
        .._noLoop = _noLoop;
      _ticker.stop();
      if (widget.sketch._isLooping) {
        _ticker.start();
      }
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(dynamic elapsedTime) {
    if (!mounted) return;
    setState(
      () {
        widget.sketch.draw();
        widget.sketch.elapsedTime = elapsedTime as Duration;
      },
    );
  }

  void _noLoop() {
    if (_ticker.isTicking) {
      _ticker.stop();
    }
  }

  void _loop() {
    if (!_ticker.isTicking) {
      _ticker.start();
    }
  }

  void _onKey(RawKeyEvent event) {
    print(
      'Key press receieved. Event: ${event.runtimeType}, Key: ${event.logicalKey}',
    );
    if (event is RawKeyDownEvent) {
      widget.sketch._onKeyPressed(event.logicalKey);

      if (!_controlKeys.contains(event.logicalKey)) {
        widget.sketch._onKeyTyped(event.logicalKey);
      }
    } else if (event is RawKeyUpEvent) {
      widget.sketch._onKeyReleased(event.logicalKey);
    }
  }

  MouseButton _getMouseButton(int mouseButtonMask) {
    if (mouseButtonMask & kPrimaryButton != 0) {
      return MouseButton.left;
    } else if (mouseButtonMask & kSecondaryButton != 0) {
      return MouseButton.right;
    } else if (mouseButtonMask & kMiddleMouseButton != 0) {
      return MouseButton.center;
    } else {
      throw Exception('Invalid mouse button mask: $mouseButtonMask');
    }
  }

  Offset _getCanvasOffsetFromWidgetOffset(Offset widgetOffset) {
    final myBox = context.findRenderObject();
    final canvasBox =
        _sketchCanvasKey.currentContext!.findRenderObject() as RenderBox;
    return canvasBox.globalToLocal(widgetOffset, ancestor: myBox);
  }

  void _onPointerDown(PointerDownEvent event) {
    if (event.kind != PointerDeviceKind.mouse) {
      return;
    }
    final mouseButton = _getMouseButton(event.buttons);

    widget.sketch._pressedMouseButtons.add(mouseButton);
    widget.sketch
      .._mouseButton = mouseButton
      .._updateMousePosition(_getCanvasOffsetFromWidgetOffset(event.position))
      .._onMousePressed();
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (event.kind != PointerDeviceKind.mouse) {
      return;
    }
    final mouseButton = _getMouseButton(event.buttons);

    widget.sketch
      .._mouseButton = mouseButton
      .._updateMousePosition(_getCanvasOffsetFromWidgetOffset(event.position))
      .._onMouseDragged();
  }

  void _onPointerUp(PointerUpEvent event) {
    if (event.kind != PointerDeviceKind.mouse) {
      return;
    }
    //final mouseButton = _getMouseButton(event.buttons);

    widget.sketch._pressedMouseButtons
        .clear(); //We don't know which button was released hence removing all the pressed buttons
    widget.sketch
      .._mouseButton = null
      .._updateMousePosition(_getCanvasOffsetFromWidgetOffset(event.position))
      .._onMouseReleased()
      .._onMouseClicked();
  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (event.kind != PointerDeviceKind.mouse) {
      return;
    }
    //final mouseButton = _getMouseButton(event.buttons);
    widget.sketch._pressedMouseButtons.clear();
    widget.sketch
      .._mouseButton = null
      .._updateMousePosition(_getCanvasOffsetFromWidgetOffset(event.position))
      .._onMouseReleased();
  }

  void _onPointerHover(PointerHoverEvent event) {
    if (event.kind != PointerDeviceKind.mouse) {
      return;
    }
    widget.sketch
      .._updateMousePosition(_getCanvasOffsetFromWidgetOffset(event.position))
      .._onMouseMoved();
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) {
      return;
    }

    widget.sketch._onMouseWheel(event.scrollDelta.dy);
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _onKey,
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerHover: _onPointerHover,
        onPointerUp: _onPointerUp,
        onPointerCancel: _onPointerCancel,
        onPointerSignal: _onPointerSignal,
        child: Center(
          child: CustomPaint(
            key: _sketchCanvasKey,
            size: Size(
              widget.sketch._desiredWidth.toDouble(),
              widget.sketch._desiredHeight.toDouble(),
            ),
            painter: _SketchPainter(
              sketch: widget.sketch,
              clipBehavior: widget.clipBehavior,
            ),
          ),
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
    void Function(Sketch)? keyPressed,
    void Function(Sketch)? keyReleased,
    void Function(Sketch)? keyTyped,
    void Function(Sketch)? mousePressed,
    void Function(Sketch)? mouseDragged,
    void Function(Sketch)? mouseReleased,
    void Function(Sketch)? mouseClicked,
    void Function(Sketch)? mouseMoved,
    void Function(Sketch, double)? mouseWheel,
  })  : _setup = setup,
        _draw = draw,
        _keyPressed = keyPressed,
        _keyReleased = keyReleased,
        _keyTyped = keyTyped,
        _mousePressed = mousePressed,
        _mouseDragged = mouseDragged,
        _mouseReleased = mouseReleased,
        _mouseClicked = mouseClicked,
        _mouseMoved = mouseMoved,
        _mouseWheel = mouseWheel;

  late void Function(Sketch)? _setup = (s) {};
  late void Function(Sketch)? _draw = (s) {};
  late void Function(Sketch)? _keyPressed = (s) {};
  late void Function(Sketch)? _keyReleased = (s) {};
  late void Function(Sketch)? _keyTyped = (s) {};
  late void Function(Sketch)? _mousePressed = (s) {};
  late void Function(Sketch)? _mouseDragged = (s) {};
  late void Function(Sketch)? _mouseReleased = (s) {};
  late void Function(Sketch)? _mouseClicked = (s) {};
  late void Function(Sketch)? _mouseMoved = (s) {};
  late void Function(Sketch, double count)? _mouseWheel;

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

  void _onKeyPressed(LogicalKeyboardKey key) {
    _pressedKeys.add(key);
    _key = key;
    keyPressed();
  }

  void keyPressed() {
    _keyPressed?.call(this);
  }

  void _onKeyReleased(LogicalKeyboardKey key) {
    _pressedKeys.remove(key);
    _key = key;
    keyReleased();
  }

  void keyReleased() {
    _keyReleased?.call(this);
  }

  void _onKeyTyped(LogicalKeyboardKey key) {
    keyTyped();
  }

  void keyTyped() {
    _keyTyped?.call(this);
  }

  void _onMousePressed() {
    mousePressed();
  }

  void mousePressed() {
    _mousePressed?.call(this);
  }

  void _onMouseReleased() {
    mouseReleased();
  }

  void mouseReleased() {
    _mouseReleased?.call(this);
  }

  void _onMouseDragged() {
    mouseDragged();
  }

  void mouseDragged() {
    _mouseDragged?.call(this);
  }

  void _onMouseClicked() {
    mouseClicked();
  }

  void mouseClicked() {
    _mouseClicked?.call(this);
  }

  void _onMouseMoved() {
    mouseMoved();
  }

  void mouseMoved() {
    _mouseMoved?.call(this);
  }

  void _onMouseWheel(double count) {
    mouseWheel(count);
  }

  void mouseWheel(double count) {
    _mouseWheel?.call(this, count);
  }

  late Canvas _canvas;
  late Size _size;
  late Paint _fillPaint;
  late Paint _strokePaint;
  late Color _backgroundColor = const Color(0xffc5c5c5c5c);

  int _desiredWidth = 100;
  int _desiredHeight = 100;

  //***************STRUCTURE***************//
  bool _isLooping = true;
  VoidCallback? _loop;
  VoidCallback? _noLoop;

  void loop() {
    _isLooping = true;
    _loop?.call();
  }

  void noLoop() {
    _isLooping = false;
    _noLoop?.call();
  }

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

  //******************SHAPE/ATTRIBUTES***********//
  void strokeWeight(int newWeight) {
    if (newWeight < 0) {
      throw Exception('Stroke weight must be greater than 0');
    }

    _strokePaint.strokeWidth = newWeight.toDouble();
  }

  //******************INPUT/KEYBOARD***************//
  Set<LogicalKeyboardKey> _pressedKeys = {};

  bool get isKeyPressed => _pressedKeys.isNotEmpty;
  LogicalKeyboardKey? _key;
  LogicalKeyboardKey? get key => _key;

  //******************INPUT/MOUSE******************//
  Set<MouseButton> _pressedMouseButtons = {};
  int _mouseX = 0;
  int get mouseX => _mouseX;
  int _mouseY = 0;
  int get mouseY => _mouseY;

  int _pmouseX = 0;
  int get pmouseX => _pmouseX;
  int _pmouseY = 0;
  int get pmouseY => _pmouseY;

  bool get isMousePressed => _pressedMouseButtons.isNotEmpty;

  MouseButton? _mouseButton;
  MouseButton? get mouseButton => _mouseButton;

  void _updateMousePosition(Offset newPosition) {
    _pmouseX = _mouseX;
    _pmouseY = _mouseY;

    _mouseX = newPosition.dx.round();
    _mouseY = newPosition.dy.round();
  }

  //******************TRANSFORM***************//
  void translate({
    double? x,
    double? y,
    double? z,
  }) {
    if (z != null) {
      throw UnimplementedError('3D translations are not yet supported');
    }

    _canvas.translate(x ?? 0, y ?? 0);
  }
}

enum MouseButton {
  left,
  center,
  right,
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
  _SketchPainter({
    required this.sketch,
    required this.clipBehavior,
  }) : assert(sketch != null);

  final Sketch sketch;
  final Clip clipBehavior;

  @override
  void paint(Canvas canvas, Size size) {
    if (clipBehavior != Clip.none) {
      canvas.clipRect(Offset.zero & size,
          doAntiAlias: clipBehavior == Clip.antiAlias ||
              clipBehavior == Clip.antiAliasWithSaveLayer);

      //Save layer for antiAliasWithSaveLayer
    }
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
