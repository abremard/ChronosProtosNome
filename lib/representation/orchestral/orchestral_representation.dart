import 'dart:math';
import 'package:flutter/material.dart';
import 'package:metronome/animation/shape_animation.dart';

enum Temper { staccato, legato }

class OrchestralRepresentation extends StatefulWidget {
  const OrchestralRepresentation(
      {super.key, this.temper = Temper.legato, this.beat = 2});

  final Temper temper;
  final int beat;

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

  Path drawPath() {
    Path animationPath = Path();

    switch (widget.temper) {
      case Temper.legato:
        const double height = 100.0;
        const double width = 100.0;
        const Size rectangleSize = Size(height, width);

        switch (widget.beat) {
          case 2:
            final Rect rectangle1 = Offset.zero & rectangleSize;
            final Rect rectangle2 = const Offset(width, 0) & rectangleSize;
            animationPath.addArc(rectangle1, _degToRad(0), _degToRad(360));
            animationPath.addArc(rectangle2, _degToRad(180), -_degToRad(360));
            break;
          case 3:
            break;
          case 4:
            break;
        }
        break;

      case Temper.staccato:
        switch (widget.beat) {
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

  @override
  void initState() {
    super.initState();
    bpm = 100;
  }

  @override
  Widget build(BuildContext context) {
    Path animationPath = drawPath();

    return Scaffold(
      body: Center(
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
            ShapeAnimation(
              animationPath: animationPath,
              animationDuration: _bpmToDuration(bpm, widget.beat),
            )
          ],
        ),
      ),
    );
  }
}
