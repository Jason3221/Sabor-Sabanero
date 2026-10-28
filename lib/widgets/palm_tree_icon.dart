import 'package:flutter/material.dart';

/// Pequeña palmera dibujada a mano (tronco dorado + abanico de hojas
/// blancas), usada sobre el logo "Sabor Caribe".
class PalmTreeIcon extends StatelessWidget {
  final double size;

  const PalmTreeIcon({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _PalmTreePainter()),
    );
  }
}

class _PalmTreePainter extends CustomPainter {
  static const _gold = Color(0xFFFFC107);

  @override
  void paint(Canvas canvas, Size size) {
    final frondCenter = Offset(size.width * 0.5, size.height * 0.4);

    // Tronco: curva dorada hacia abajo, con una leve inclinación.
    final trunkPaint = Paint()
      ..color = _gold
      ..strokeWidth = size.width * 0.09
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final trunkPath = Path()
      ..moveTo(frondCenter.dx, frondCenter.dy)
      ..quadraticBezierTo(
        size.width * 0.62,
        size.height * 0.68,
        size.width * 0.54,
        size.height * 0.98,
      );
    canvas.drawPath(trunkPath, trunkPaint);

    // Hojas: abanico de 6 pétalos blancos alrededor del punto superior.
    final frondPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    const angles = [-75.0, -45.0, -15.0, 15.0, 45.0, 75.0];
    final frondWidth = size.width * 0.22;
    final frondHeight = size.height * 0.5;

    for (final degrees in angles) {
      canvas.save();
      canvas.translate(frondCenter.dx, frondCenter.dy);
      canvas.rotate(degrees * 3.1415926535 / 180);

      final petal = Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(frondWidth * 0.5, -frondHeight * 0.55, 0, -frondHeight)
        ..quadraticBezierTo(-frondWidth * 0.5, -frondHeight * 0.55, 0, 0)
        ..close();
      canvas.drawPath(petal, frondPaint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
