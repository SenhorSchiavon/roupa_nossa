import 'package:flutter/material.dart';

class MagnifyingGlassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final double width = size.width;
    final double height = size.height;

    // Draw glass circle
    canvas.drawCircle(
      Offset(width * 0.4, height * 0.4),
      width * 0.3,
      paint,
    );

    // Draw handle
    canvas.drawLine(
      Offset(width * 0.6, height * 0.6),
      Offset(width * 0.8, height * 0.8),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}