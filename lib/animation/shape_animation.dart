import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:metronome/animation/shape_animation_painter.dart';

class ShapeAnimation extends StatefulWidget {
  final Duration animationDuration;
  final Path animationPath;

  const ShapeAnimation({
    Key? key,
    this.animationDuration = const Duration(seconds: 6),
    required this.animationPath,
  }) : super(key: key);

  @override
  State<ShapeAnimation> createState() => _ShapeAnimationState();
}

class _ShapeAnimationState extends State<ShapeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      upperBound: 100.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ValueNotifier(100.0),
      builder: (BuildContext context, double value, Widget? child) {
        animationController.duration = const Duration(seconds: 6);

        return AnimatedBuilder(
          animation: animationController,
          builder: (context, snapshot) {
            Widget centerTextWidget = const SizedBox.shrink();

            final totalLength = widget.animationPath.computeMetrics().fold(
                0.0, (double prev, PathMetric metric) => prev + metric.length);

            final currentLength = totalLength * animationController.value;

            return Stack(
              alignment: Alignment.center,
              children: [
                centerTextWidget,
                CustomPaint(
                    size: const Size(100, 100),
                    painter: ShapeAnimationPainter(
                        progressStrokeWidth: 15,
                        backStrokeWidth: 15,
                        currentLength: currentLength,
                        backColor: const Color(0xFF16262D),
                        animationPath: widget.animationPath)),
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
