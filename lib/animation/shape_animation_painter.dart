import 'package:flutter/material.dart';

class ShapeAnimationPainter extends CustomPainter {
  final double progressStrokeWidth;
  final double backStrokeWidth;
  final double currentLength;
  final Color backColor;
  final Path animationPath;

  ShapeAnimationPainter({
    required this.progressStrokeWidth,
    required this.backStrokeWidth,
    required this.currentLength,
    required this.backColor,
    required this.animationPath,
  });

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

      final isLastSegment = nextLength > length;
      if (isLastSegment) {
        final remainingLength = length - currentLength;
        final pathSegment = metric.extractPath(0.0, remainingLength);

        path.addPath(pathSegment, Offset.zero);
        break;
      } else {
        final pathSegment = metric.extractPath(0.0, metric.length);
        path.addPath(pathSegment, Offset.zero);
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
