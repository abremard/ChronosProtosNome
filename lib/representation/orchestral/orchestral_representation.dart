import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:metronome/animation/shape_animation.dart';

enum Temper { staccato, legato }

enum Shape { circle, lobe }

class OrchestralRepresentation extends StatefulWidget {
  const OrchestralRepresentation({super.key, this.temper = Temper.legato});

  final Temper temper;

  @override
  State<OrchestralRepresentation> createState() =>
      _OrchestralRepresentationState();
}

const double _piDiv180 = pi / 180;

Duration _bpmToDuration(int bpm, int beat) {
  return Duration(milliseconds: (60000 * beat / bpm).round());
}

double _degToRad(double degree) {
  return degree * _piDiv180;
}

class _OrchestralRepresentationState extends State<OrchestralRepresentation> {
  late int bpm;
  late int beat;
  late Shape shape;

  double getPathLength(Path path) {
    List<PathMetric> pathMetric = path.computeMetrics().toList();
    double pathLength = 0;
    pathMetric.forEach((contour) {
      pathLength += contour.length;
    });
    return pathLength;
  }

  void updateBPM(String? inputValue) {
    setState(() {
      if (inputValue != null && int.tryParse(inputValue) != null) {
        int numericValue = int.parse(inputValue);
        if (0 < numericValue && numericValue <= 400) {
          bpm = numericValue;
        }
      }
    });
  }

  void updateBeat(int? selectedBeat) {
    setState(() {
      if (selectedBeat != null) {
        beat = selectedBeat;
      }
    });
  }

  void updateShape(Shape? selectedShape) {
    setState(() {
      if (selectedShape != null) {
        shape = selectedShape;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    bpm = 100;
    beat = 2;
    shape = Shape.circle;
  }

  @override
  Widget build(BuildContext context) {
    Path drawPath() {
      Path animationPath = Path();

      switch (widget.temper) {
        case Temper.legato:
          switch (beat) {
            case 2:
              switch (shape) {
                case Shape.circle:
                  const double height = 150.0;
                  const double width = 150.0;
                  const Size rectangleSize = Size(width, height);
                  final Rect rectangle1 = Offset.zero & rectangleSize;
                  final Rect rectangle2 =
                      const Offset(width, 0) & rectangleSize;
                  animationPath.addArc(
                      rectangle1, _degToRad(0), _degToRad(360));
                  animationPath.addArc(
                      rectangle2, _degToRad(180), -_degToRad(360));
                  break;
                case Shape.lobe:
                  animationPath.moveTo(150, 70);
                  animationPath.quadraticBezierTo(-10, 180, -20, 70);
                  animationPath.quadraticBezierTo(-10, -30, 150, 70);
                  animationPath.quadraticBezierTo(310, 180, 320, 70);
                  animationPath.quadraticBezierTo(310, -30, 150, 70);
                  break;
              }
              break;
            case 3:
              switch (shape) {
                case Shape.circle:
                  final Rect rectangle1 =
                      const Offset(40, 66) & const Size(150.0, 150.0);
                  final Rect rectangle2 =
                      const Offset(151.0, 0) & const Size(150.0, 150.0);
                  final Rect rectangle3 =
                      const Offset(40, -66) & const Size(150.0, 150.0);
                  animationPath.addArc(
                      rectangle1, _degToRad(-60), _degToRad(360));
                  animationPath.addArc(
                      rectangle2, _degToRad(180), -_degToRad(360));
                  animationPath.addArc(
                      rectangle3, _degToRad(60), _degToRad(360));
                  break;
                case Shape.lobe:
                  animationPath.moveTo(150, 70);
                  animationPath.quadraticBezierTo(80, 228, 5, 140);
                  animationPath.quadraticBezierTo(-60, 40, 150, 70);
                  animationPath.quadraticBezierTo(310, 180, 320, 70);
                  animationPath.quadraticBezierTo(310, -30, 150, 70);
                  animationPath.quadraticBezierTo(-30, 60, 20, -40);
                  animationPath.quadraticBezierTo(80, -120, 150, 70);
                  break;
              }
              break;
            case 4:
              break;
          }
          break;

        case Temper.staccato:
          switch (beat) {
            case 2:
              break;
            case 3:
              break;
            case 4:
              break;
          }
          break;
      }
      return animationPath;
    }

    Path animationPath = drawPath();

    return Scaffold(
      body: Center(
          child: Row(
        children: [
          Flexible(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(50.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Beats per minute',
                      labelText: 'BPM*',
                    ),
                    initialValue: bpm.toString(),
                    onChanged: (String? value) {
                      updateBPM(value);
                    },
                  ),
                ),
                Column(
                  children: [
                    const Text('Beat'),
                    ListTile(
                      title: const Text('2'),
                      leading: Radio<int>(
                        value: 2,
                        groupValue: beat,
                        onChanged: (int? value) {
                          updateBeat(value);
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('3'),
                      leading: Radio<int>(
                        value: 3,
                        groupValue: beat,
                        onChanged: (int? value) {
                          updateBeat(value);
                        },
                      ),
                    ),
                    const Text('Shape'),
                    ListTile(
                      title: const Text('Circle'),
                      leading: Radio<Shape>(
                        value: Shape.circle,
                        groupValue: shape,
                        onChanged: (Shape? value) {
                          updateShape(value);
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Lobe'),
                      leading: Radio<Shape>(
                        value: Shape.lobe,
                        groupValue: shape,
                        onChanged: (Shape? value) {
                          updateShape(value);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
              child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20.0, top: 150.0),
                child: ShapeAnimation(
                  animationPath: animationPath,
                  animationDuration: _bpmToDuration(bpm, beat),
                  snakeLength: clampDouble(bpm.toDouble(), 200, 400),
                ),
              )
            ],
          ))
        ],
      )),
    );
  }
}
