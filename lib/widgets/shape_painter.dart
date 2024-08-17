import 'package:flutter/material.dart';

class ShapePainter extends CustomPainter {
  Rect rect;
  final ShapeBorder? shapeBorder;
  final Color color;
  final double opacity;

  ShapePainter({
    required this.rect,
    required this.color,
    this.shapeBorder,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color.withOpacity(opacity);
    final outer = RRect.fromLTRBR(
        0, 0, size.width, size.height, const Radius.circular(0));

    final radius = shapeBorder == const CircleBorder() ? 50.0 : 3.0;

    final inner = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    canvas.drawDRRect(outer, inner, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
