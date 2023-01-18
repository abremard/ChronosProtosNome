import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:metronome/animation/shape_animation.dart';

enum Temper { neutral, portato, legato, staccato }

enum Shape { orchestral }

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
  late Temper temper;

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

  void updateTemper(Temper? selectedTemper) {
    setState(() {
      if (selectedTemper != null) {
        temper = selectedTemper;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    bpm = 100;
    beat = 1;
    shape = Shape.orchestral;
    temper = Temper.neutral;
  }

  Rect drawRectangle(width, height, {offset = Offset.zero}) {
    return Offset.zero & Size(width, height);
  }

  @override
  Widget build(BuildContext context) {
    Path drawPath() {
      Path animationPath = Path();

      switch (temper) {
        case Temper.neutral:
          switch (beat) {
            case 1:
              switch (shape) {
                case Shape.orchestral:
                  animationPath.addArc(
                      drawRectangle(50.0, 130.0), _degToRad(0), _degToRad(360));
                  break;
              }
              break;
            case 2:
              break;
            case 3:
              break;
            case 4:
              break;
          }
          break;

        case Temper.portato:
          switch (beat) {
            case 1:
              animationPath.addArc(
                  drawRectangle(40.0, 170.0), _degToRad(0), _degToRad(360));
              break;
            case 2:
              break;
            case 3:
              break;
            case 4:
              break;
          }
          break;

        case Temper.legato:
          switch (beat) {
            case 1:
              break;
            case 2:
              switch (shape) {
                case Shape.orchestral:
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
                case Shape.orchestral:
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
            case 1:
              break;
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
                      title: const Text('1'),
                      leading: Radio<int>(
                        value: 1,
                        groupValue: beat,
                        onChanged: (int? value) {
                          updateBeat(value);
                        },
                      ),
                    ),
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
                      title: const Text('Orchestral'),
                      leading: Radio<Shape>(
                        value: Shape.orchestral,
                        groupValue: shape,
                        onChanged: (Shape? value) {
                          updateShape(value);
                        },
                      ),
                    ),
                    const Text('Mode'),
                    ListTile(
                      title: const Text('Neutral'),
                      leading: Radio<Temper>(
                        value: Temper.neutral,
                        groupValue: temper,
                        onChanged: (Temper? value) {
                          updateTemper(value);
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Portato'),
                      leading: Radio<Temper>(
                        value: Temper.portato,
                        groupValue: temper,
                        onChanged: (Temper? value) {
                          updateTemper(value);
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Legato'),
                      leading: Radio<Temper>(
                        value: Temper.legato,
                        groupValue: temper,
                        onChanged: (Temper? value) {
                          updateTemper(value);
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Staccato'),
                      leading: Radio<Temper>(
                        value: Temper.staccato,
                        groupValue: temper,
                        onChanged: (Temper? value) {
                          updateTemper(value);
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
                margin: const EdgeInsets.only(top: 150.0),
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
