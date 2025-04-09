import 'package:flutter/material.dart';

class TShirtPainter extends CustomPainter {
  final Color color;
  final bool hasHeart;

  TShirtPainter({
    required this.color,
    required this.hasHeart,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double width = size.width;
    final double height = size.height;

    // Draw T-shirt body
    final Path path = Path()
      ..moveTo(width * 0.2, height * 0.2)
      ..lineTo(width * 0.35, height * 0.2)
      ..lineTo(width * 0.35, height * 0.1)
      ..quadraticBezierTo(width * 0.5, height * 0.05, width * 0.65, height * 0.1)
      ..lineTo(width * 0.65, height * 0.2)
      ..lineTo(width * 0.8, height * 0.2)
      ..lineTo(width * 0.8, height * 0.5)
      ..quadraticBezierTo(width * 0.7, height * 0.6, width * 0.7, height * 0.9)
      ..lineTo(width * 0.3, height * 0.9)
      ..quadraticBezierTo(width * 0.3, height * 0.6, width * 0.2, height * 0.5)
      ..close();

    // Draw collar
    final Path collarPath = Path()
      ..moveTo(width * 0.4, height * 0.2)
      ..lineTo(width * 0.4, height * 0.3)
      ..quadraticBezierTo(width * 0.5, height * 0.35, width * 0.6, height * 0.3)
      ..lineTo(width * 0.6, height * 0.2);

    canvas.drawPath(path, paint);
    canvas.drawPath(collarPath, paint);

    // Draw sleeve lines
    canvas.drawLine(
      Offset(width * 0.2, height * 0.2),
      Offset(width * 0.1, height * 0.4),
      paint,
    );
    canvas.drawLine(
      Offset(width * 0.1, height * 0.4),
      Offset(width * 0.2, height * 0.4),
      paint,
    );

    canvas.drawLine(
      Offset(width * 0.8, height * 0.2),
      Offset(width * 0.9, height * 0.4),
      paint,
    );
    canvas.drawLine(
      Offset(width * 0.9, height * 0.4),
      Offset(width * 0.8, height * 0.4),
      paint,
    );

    // Draw heart if needed
    if (hasHeart) {
      final Paint heartPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      final Path heartPath = Path()
        ..moveTo(width * 0.3, height * 0.35)
        ..quadraticBezierTo(width * 0.25, height * 0.3, width * 0.3, height * 0.25)
        ..quadraticBezierTo(width * 0.35, height * 0.2, width * 0.4, height * 0.25)
        ..quadraticBezierTo(width * 0.45, height * 0.2, width * 0.5, height * 0.25)
        ..quadraticBezierTo(width * 0.55, height * 0.3, width * 0.5, height * 0.35)
        ..quadraticBezierTo(width * 0.4, height * 0.45, width * 0.3, height * 0.35);

      canvas.drawPath(heartPath, heartPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}