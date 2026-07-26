import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TokenBurstComponent extends PositionComponent {
  TokenBurstComponent({required Vector2 position, required Color color})
    : _color = color,
      super(position: position, anchor: Anchor.center, priority: 1000);

  final Color _color;
  final List<_Spark> _sparks = [];
  double _age = 0;

  static const double _duration = 0.7;

  @override
  Future<void> onLoad() async {
    final rnd = math.Random();
    final colors = [_color, Colors.white, Colors.amber];
    for (var i = 0; i < 20; i++) {
      _sparks.add(
        _Spark(
          angle: rnd.nextDouble() * math.pi * 2,
          speed: 50 + rnd.nextDouble() * 90,
          size: 3 + rnd.nextDouble() * 4,
          color: colors[i % colors.length],
          square: rnd.nextBool(),
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _age += dt;
    if (_age >= _duration) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final t = (_age / _duration).clamp(0.0, 1.0);
    final ease = 1 - math.pow(1 - t, 2).toDouble();
    final opacity = (1 - t).clamp(0.0, 1.0);

    for (final s in _sparks) {
      final dist = s.speed * ease;
      final dx = math.cos(s.angle) * dist;
      final dy = math.sin(s.angle) * dist - (t * t * 40);
      final sz = s.size * (1 - t * 0.4);
      final paint = Paint()..color = s.color.withValues(alpha: opacity);
      final rect = Rect.fromCenter(
        center: Offset(dx, dy),
        width: sz,
        height: sz,
      );
      if (s.square) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(sz * 0.25)),
          paint,
        );
      } else {
        canvas.drawOval(rect, paint);
      }
    }
  }
}

class _Spark {
  _Spark({
    required this.angle,
    required this.speed,
    required this.size,
    required this.color,
    required this.square,
  });

  final double angle;
  final double speed;
  final double size;
  final Color color;
  final bool square;
}
