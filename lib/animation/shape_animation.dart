import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:metronome/animation/shape_animation_painter.dart';

class ShapeAnimation extends StatefulWidget {
  final Duration animationDuration;
  final Path animationPath;
  final double snakeLength;

  const ShapeAnimation({
    Key? key,
    required this.animationDuration,
    required this.animationPath,
    required this.snakeLength,
  }) : super(key: key);

  @override
  State<ShapeAnimation> createState() => _ShapeAnimationState();
}

class _ShapeAnimationState extends State<ShapeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late SweepGradient sweepGradient;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      value: 0.0,
      upperBound: 100.0,
    );

    final List<Color> progressColors = [];
    progressColors.add(Colors.lightBlue);
    progressColors.add(Colors.lightBlue);

    sweepGradient = SweepGradient(
      tileMode: TileMode.decal,
      colors: progressColors,
    );
  }

  double mapSpeed(double value, List<double> cutoff) {
    switch (cutoff.length) {
      case 1:
        if (value <= 50) {
          return cutoff.elementAt(0) * value * 2;
        } else {
          return ((1 - cutoff.elementAt(0)) * value * 2) +
              (cutoff.elementAt(0) - 0.5) * 50;
        }
      case 2:
        if (value <= 100 / 3) {
          return cutoff.elementAt(0) * value * 3;
        } else if (100 / 3 < value && value <= 200 / 3) {
          return ((cutoff.elementAt(1) - cutoff.elementAt(0)) * value * 3) +
              (100 / 3) * (cutoff.elementAt(0) - (1 / 3));
        } else {
          return ((1 - cutoff.elementAt(1)) * value * 3) +
              (100 / 3) * (cutoff.elementAt(1) - 2);
        }
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ValueNotifier(100.0),
      builder: (BuildContext context, double value, Widget? child) {
        animationController.duration = widget.animationDuration;
        animationController.animateTo(value);

        return AnimatedBuilder(
          animation: animationController,
          builder: (context, snapshot) {
            Widget centerTextWidget = const SizedBox.shrink();

            final totalLength = widget.animationPath.computeMetrics().fold(
                0.0, (double prev, PathMetric metric) => prev + metric.length);

            final currentLength = totalLength * animationController.value / 100;

            if ((animationController.value >= animationController.upperBound)) {
              animationController.reset();
              animationController.animateTo(value);
            }

            return Stack(
              alignment: Alignment.center,
              children: [
                centerTextWidget,
                CustomPaint(
                    size: const Size(100, 100),
                    painter: ShapeAnimationPainter(
                      animationPath: widget.animationPath,
                      backColor: const Color(0xFF16262D),
                      backStrokeWidth: 1,
                      currentLength: currentLength,
                      frontGradient: sweepGradient,
                      progressStrokeWidth: 15,
                      snakeLength: widget.snakeLength,
                      totalLength: totalLength,
                    )),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
