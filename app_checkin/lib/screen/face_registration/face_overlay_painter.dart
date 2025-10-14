import 'package:flutter/material.dart';

class FaceOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Tạo path toàn màn hình
    Path background = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Tạo path oval ở giữa
    final ovalWidth = 350.0;
    final ovalHeight = 450.0;
    final center = Offset(size.width / 2, size.height / 2);
    final ovalRect = Rect.fromCenter(
      center: center,
      width: ovalWidth,
      height: ovalHeight,
    );
    Path ovalPath = Path()..addOval(ovalRect);

    // Lấy path mờ = màn hình - oval
    Path maskPath = Path.combine(
      PathOperation.difference,
      background,
      ovalPath,
    );

    // Vẽ vùng ngoài elip
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawPath(maskPath, paint);

    // Vẽ viền elip
    Paint borderPaint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawOval(ovalRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
