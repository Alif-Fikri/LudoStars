import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../audio/audio_controller.dart';
import '../ludo_constants.dart';
import '../ludo_models.dart';
import 'board_component.dart';

class TokenComponent extends PositionComponent {
  TokenComponent({required this.token});

  final Token token;

  bool movable = false;

  static const double segSeconds = 0.28;

  final List<Vector2> _path = [];
  Vector2 _segStart = Vector2.zero();
  double _segT = 0;
  double _hop = 0;
  bool _walkMode = false;

  BoardComponent get board => parent as BoardComponent;

  bool get isWalking => _path.isNotEmpty;

  @override
  void update(double dt) {
    super.update(dt);
    if (_path.isEmpty) {
      _hop = 0;
      return;
    }

    _segT += dt / segSeconds;
    final t = Curves.easeInOut.transform(_segT.clamp(0.0, 1.0));
    final to = _path.first;
    position = Vector2(
      _segStart.x + (to.x - _segStart.x) * t,
      _segStart.y + (to.y - _segStart.y) * t,
    );
    _hop = math.sin(t * math.pi) * board.cellSize * 0.34;

    if (_segT >= 1) {
      position = to.clone();
      _segStart = to.clone();
      _path.removeAt(0);
      _segT = 0;
      _hop = 0;
      if (_walkMode) AudioController.instance.hop();
    }
  }

  @override
  void render(Canvas canvas) {
    final r = size.x / 2;
    final cy = r - _hop;
    final center = Offset(r, cy);

    final lift = (_hop / board.cellSize).clamp(0.0, 1.0);
    final shadowScale = 1 - lift * 0.45;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(r, r + r * 0.52),
        width: r * 1.5 * shadowScale,
        height: r * 0.5 * shadowScale,
      ),
      Paint()..color = Color.fromRGBO(0, 0, 0, 0.22 * shadowScale),
    );

    if (movable && !isWalking) {
      canvas.drawCircle(
        center,
        r * 1.18,
        Paint()..color = Colors.white.withValues(alpha: 0.4),
      );
      canvas.drawCircle(
        center,
        r * 1.18,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = r * 0.15
          ..color = Colors.white,
      );
    }

    canvas.drawCircle(center, r * 0.88, Paint()..color = token.color.color);
    canvas.drawCircle(
      center.translate(-r * 0.22, -r * 0.26),
      r * 0.3,
      Paint()..color = Colors.white.withValues(alpha: 0.55),
    );
    canvas.drawCircle(
      center,
      r * 0.88,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.14
        ..color = token.color.darkColor,
    );
  }

  void _applySizing(int stackCount) {
    size = Vector2.all(board.cellSize * (stackCount > 1 ? 0.62 : 0.78));
    anchor = Anchor.center;
  }

  void walk(List<Vector2> points) {
    if (points.isEmpty) return;
    _applySizing(1);
    _walkMode = true;
    _path
      ..clear()
      ..addAll(points);
    _segStart = position.clone();
    _segT = 0;
  }

  void snapTo({
    required int stackIndex,
    required int stackCount,
    required bool animate,
  }) {
    _applySizing(stackCount);
    final target = _stackedTarget(stackIndex, stackCount);
    final far = !position.isZero() && position.distanceTo(target) > 1;
    if (animate && far) {
      _walkMode = false;
      _path
        ..clear()
        ..add(target);
      _segStart = position.clone();
      _segT = 0;
    } else {
      _walkMode = false;
      _path.clear();
      _hop = 0;
      position = target;
    }
  }

  Vector2 _stackedTarget(int stackIndex, int stackCount) {
    final center = board.cellCenter(token.cell.col, token.cell.row);
    if (stackCount <= 1) return center;
    final s = board.cellSize * 0.17;
    final offsets = _clusterOffsets(stackCount);
    final o = offsets[stackIndex % offsets.length];
    return center + Vector2(o.dx * s, o.dy * s);
  }

  List<Offset> _clusterOffsets(int n) {
    switch (n) {
      case 2:
        return const [Offset(-1, 0), Offset(1, 0)];
      case 3:
        return const [Offset(0, -1), Offset(-1, 0.8), Offset(1, 0.8)];
      default:
        return const [
          Offset(-1, -1),
          Offset(1, -1),
          Offset(-1, 1),
          Offset(1, 1),
        ];
    }
  }
}
