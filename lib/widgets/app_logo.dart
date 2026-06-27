import 'dart:math' as math;

import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: size * 0.14,
            offset: Offset(0, size * 0.08),
          ),
        ],
      ),
      child: CustomPaint(painter: _LogoPainter()),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final r = s * 0.22;
    final rect = Rect.fromLTWH(0, 0, s, s);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(r));

    canvas.drawRRect(rrect, Paint()..color = Colors.white);

    final pad = s * 0.14;
    final gap = s * 0.035;
    final mid = s / 2;
    final qr = Radius.circular(s * 0.05);

    void quad(double l, double t, double rr, double b, Color c) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTRB(l, t, rr, b), qr),
        Paint()..color = c,
      );
    }

    quad(pad, pad, mid - gap, mid - gap, const Color(0xFFE53935));
    quad(mid + gap, pad, s - pad, mid - gap, const Color(0xFF43A047));
    quad(pad, mid + gap, mid - gap, s - pad, const Color(0xFF1E88E5));
    quad(mid + gap, mid + gap, s - pad, s - pad, const Color(0xFFFDD835));

    final c = Offset(mid, mid);
    canvas.drawCircle(c, s * 0.18, Paint()..color = Colors.white);
    _star(canvas, c, s * 0.15, s * 0.065, const Color(0xFFFFC107));
  }

  void _star(Canvas canvas, Offset c, double outer, double inner, Color color) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final rad = i.isEven ? outer : inner;
      final a = -math.pi / 2 + i * math.pi / 5;
      final p = Offset(c.dx + rad * math.cos(a), c.dy + rad * math.sin(a));
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_LogoPainter oldDelegate) => false;
}
