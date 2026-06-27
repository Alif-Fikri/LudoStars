import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedDice extends StatefulWidget {
  const AnimatedDice({super.key, required this.value, this.size = 64});

  final int value;
  final double size;

  @override
  State<AnimatedDice> createState() => _AnimatedDiceState();
}

class _AnimatedDiceState extends State<AnimatedDice>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void didUpdateWidget(AnimatedDice old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value && widget.value > 0) {
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value;
        final angle = (1 - t) * math.pi * 3;
        final lift = math.sin(t * math.pi) * 8;
        return Transform.translate(
          offset: Offset(0, -lift),
          child: Transform.rotate(
            angle: _c.isAnimating ? angle : 0,
            child: _Face(value: widget.value, size: s),
          ),
        );
      },
    );
  }
}

class _Face extends StatelessWidget {
  const _Face({required this.value, required this.size});
  final int value;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFE8EAF0)],
        ),
        borderRadius: BorderRadius.circular(size * 0.22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x55000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: CustomPaint(painter: _DicePainter(value)),
    );
  }
}

class _DicePainter extends CustomPainter {
  _DicePainter(this.value);
  final int value;

  static const _layouts = <int, List<Offset>>{
    1: [Offset(0.5, 0.5)],
    2: [Offset(0.27, 0.27), Offset(0.73, 0.73)],
    3: [Offset(0.27, 0.27), Offset(0.5, 0.5), Offset(0.73, 0.73)],
    4: [
      Offset(0.27, 0.27),
      Offset(0.73, 0.27),
      Offset(0.27, 0.73),
      Offset(0.73, 0.73),
    ],
    5: [
      Offset(0.27, 0.27),
      Offset(0.73, 0.27),
      Offset(0.5, 0.5),
      Offset(0.27, 0.73),
      Offset(0.73, 0.73),
    ],
    6: [
      Offset(0.27, 0.25),
      Offset(0.73, 0.25),
      Offset(0.27, 0.5),
      Offset(0.73, 0.5),
      Offset(0.27, 0.75),
      Offset(0.73, 0.75),
    ],
  };

  @override
  void paint(Canvas canvas, Size size) {
    final pips = _layouts[value];
    if (pips == null) {
      final tp = TextPainter(
        text: TextSpan(
          text: '?',
          style: TextStyle(
            color: const Color(0xFFB0BEC5),
            fontSize: size.width * 0.55,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2),
      );
      return;
    }
    final r = size.width * 0.1;
    for (final p in pips) {
      final center = Offset(p.dx * size.width, p.dy * size.height);
      canvas.drawCircle(
        center.translate(0, r * 0.3),
        r,
        Paint()..color = const Color(0x33000000),
      );
      canvas.drawCircle(center, r, Paint()..color = const Color(0xFF263238));
    }
  }

  @override
  bool shouldRepaint(_DicePainter oldDelegate) => oldDelegate.value != value;
}
