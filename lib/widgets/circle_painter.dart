import 'package:flutter/material.dart';

/// Draws a circle if placed into a square widget.
class CirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final Size? size;

  CirclePainter({required this.color, required this.strokeWidth, this.size});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.strokeWidth = strokeWidth;
    paint.color = color;
    paint.style = PaintingStyle.stroke;

    Size drawingSize = this.size ?? size;
    canvas.drawOval(
      Rect.fromCenter(
          center: size.center(const Offset(0, 0)),
          width: drawingSize.width,
          height: drawingSize.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
