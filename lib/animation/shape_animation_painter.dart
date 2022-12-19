import 'package:flutter/material.dart';

class ShapeAnimationPainter extends CustomPainter {
  final double backStrokeWidth;
  final double currentLength;
  final double progressStrokeWidth;
  final double snakeLength;
  final double totalLength;
  final Color backColor;
  final Path animationPath;
  final SweepGradient frontGradient;

  ShapeAnimationPainter({
    required this.animationPath,
    required this.backColor,
    required this.backStrokeWidth,
    required this.currentLength,
    required this.frontGradient,
    required this.progressStrokeWidth,
    required this.totalLength,
    this.snakeLength = 150,
  });

  int loopNumber = 0;

  Path extractPathUntilLength(
    Path originalPath,
    double length,
  ) {
    var currentLength = 0.0;

    final path = Path();

    var metricsIterator = originalPath.computeMetrics().iterator;

    while (metricsIterator.moveNext()) {
      var metric = metricsIterator.current;

      var nextLength = currentLength + metric.length;

      final remainingLength = length - currentLength;
      final pathSegment =
          metric.extractPath(remainingLength - snakeLength, remainingLength);

      path.addPath(pathSegment, Offset.zero);

      if (length < snakeLength) {
        path.addPath(
            metric.extractPath(
                totalLength - snakeLength + remainingLength, totalLength),
            Offset.zero);
      }

      currentLength = nextLength;
    }
    return path;
  }

  void drawFullPath(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = backStrokeWidth;

    canvas.drawPath(animationPath, paint);
  }

  void drawPathPortion(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader =
          frontGradient.createShader(Offset.zero & const Size(100.0, 100.0))
      ..strokeWidth = progressStrokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(
        extractPathUntilLength(animationPath, currentLength), paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (backStrokeWidth > 0) {
      drawFullPath(canvas, size);
    }
    drawPathPortion(canvas, size);
  }

  @override
  bool shouldRepaint(ShapeAnimationPainter oldDelegate) {
    return oldDelegate.currentLength != currentLength;
  }
}
