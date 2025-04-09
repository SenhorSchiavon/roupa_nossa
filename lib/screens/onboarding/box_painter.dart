import 'package:flutter/material.dart';

class CustomBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double width = size.width;
    final double height = size.height;

    // Draw box
    final Path boxPath = Path()
      ..moveTo(width * 0.2, height * 0.6)
      ..lineTo(width * 0.2, height * 0.9)
      ..lineTo(width * 0.8, height * 0.9)
      ..lineTo(width * 0.8, height * 0.6)
      ..lineTo(width * 0.65, height * 0.5)
      ..lineTo(width * 0.35, height * 0.5)
      ..close();

    // Draw box lid
    final Path lidPath = Path()
      ..moveTo(width * 0.35, height * 0.5)
      ..lineTo(width * 0.2, height * 0.4)
      ..lineTo(width * 0.8, height * 0.4)
      ..lineTo(width * 0.65, height * 0.5)
      ..close();

    canvas.drawPath(boxPath, paint);
    canvas.drawPath(lidPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}