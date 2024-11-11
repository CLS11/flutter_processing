import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter/services.dart';
import 'package:flutter_processing/flutter_processing.dart';
import 'package:example/star.dart';
import 'package:example/droplet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ui.Image _loadedImage;
  //final _stars = <Star>[];

  final _droplets = <Droplet>[];

  @override
  void reassemble() {
    super.reassemble();
    // _stars.clear();
    _droplets.clear();
  }

  Future<Uint8List?> getImageBytes(ui.Image image) async {
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
        child: Processing(
          sketch: Sketch.simple(
            setup: (s) async {
              s.size(width: 500, height: 500);
              _loadedImage = await s.loadImage('assets/3.png');
              setState(() {});
              /*final width = 640;
              final height = 360;
              s
                ..size(width: width, height: height)
                ..background(color: Color.fromARGB(255, 200, 175, 250));

              for (int i = 0; i < 100; ++i) {
                _droplets.add(
                  Droplet(
                    x: s.random(width),
                    y: s.random(-height, 0),
                    z: s.random(1),
                    length: 20,
                  ),
                );
              }*/
            },
            draw: (s) async {
              final bytes = await getImageBytes(_loadedImage);
              if (bytes != null) {
                final flutterImage = Image.memory(bytes);
                s.image(
                  image: flutterImage,
                  origin: Offset(100, 200),
                );
              }
              /*for (final droplet in _droplets) {
                droplet
                  ..fall(s)
                  ..show(s);
              }
            },
            mouseMoved: (s) {
              // print(
              // "mouseMoved - current position: ${s.mouseX}, ${s.mouseY}, previous position: ${s.pmouseX}, ${s.pmouseY}",
              // );
            },
            mousePressed: (s) {
              //print(
              // 'mousePressed - current position: ${s.mouseX}, ${s.mouseY}, previous position: ${s.pmouseX}, ${s.pmouseY}',
              // );
            },
            mouseReleased: (s) {
              //  print(
              // "mouseReleased - current position: ${s.mouseX}, ${s.mouseY}, previous position: ${s.pmouseX}, ${s.pmouseY}",
              // );
            },
            mouseClicked: (s) {
              // print(
              // "mouseClicked - current position: ${s.mouseX}, ${s.mouseY}, previous position: ${s.pmouseX}, ${s.pmouseY}",
              // );
            },
            mouseDragged: (s) {
              // print(
              //  "mouseDragged - current position: ${s.mouseX}, ${s.mouseY}, previous position: ${s.pmouseX}, ${s.pmouseY},",
              // );
            },
            mouseWheel: (s, count) {
              print('mouseWheel - count: $count');*/
            },
          ),
        ),
      ),
    );
  }
}
