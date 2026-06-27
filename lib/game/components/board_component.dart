import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../ludo_constants.dart';

class BoardComponent extends PositionComponent {
  double get cellSize => size.x / kGridSize;

  Vector2 cellCenter(num col, num row) =>
      Vector2((col + 0.5) * cellSize, (row + 0.5) * cellSize);

  @override
  void render(Canvas canvas) {
    final cs = cellSize;
    final boardRect = Rect.fromLTWH(0, 0, size.x, size.y);

    canvas.drawRRect(
      RRect.fromRectAndRadius(boardRect, Radius.circular(cs * 0.4)),
      Paint()..color = const Color(0xFFFFFDF5),
    );

    _paintYards(canvas, cs);
    _paintTrack(canvas, cs);
    _paintHomeColumns(canvas, cs);
    _paintCenter(canvas, cs);
    _paintSafeStars(canvas, cs);
    _paintGrid(canvas, cs);

    canvas.drawRRect(
      RRect.fromRectAndRadius(boardRect, Radius.circular(cs * 0.4)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = cs * 0.12
        ..color = const Color(0xFF263238),
    );
  }

  void _rect(
    Canvas canvas,
    double col,
    double row,
    double w,
    double h,
    Paint paint,
  ) {
    canvas.drawRect(
      Rect.fromLTWH(col * cellSize, row * cellSize, w * cellSize, h * cellSize),
      paint,
    );
  }

  void _paintYards(Canvas canvas, double cs) {
    kYardRects.forEach((color, r) {
      _rect(
        canvas,
        r.left,
        r.top,
        r.width,
        r.height,
        Paint()..color = color.color,
      );

      final inset = 0.7;
      _rect(
        canvas,
        r.left + inset,
        r.top + inset,
        r.width - 2 * inset,
        r.height - 2 * inset,
        Paint()..color = Colors.white,
      );

      for (final spot in kYardSpots[color]!) {
        canvas.drawCircle(
          cellCenter(spot.col, spot.row).toOffset(),
          cs * 0.55,
          Paint()..color = color.color.withValues(alpha: 0.35),
        );
      }
    });
  }

  void _paintTrack(Canvas canvas, double cs) {
    final white = Paint()..color = Colors.white;

    _rect(canvas, 0, 6, 15, 3, white);
    _rect(canvas, 6, 0, 3, 15, white);
  }

  void _paintHomeColumns(Canvas canvas, double cs) {
    kHomePaths.forEach((color, cells) {
      for (var i = 0; i < cells.length - 1; i++) {
        final c = cells[i];
        _rect(
          canvas,
          c.col.toDouble(),
          c.row.toDouble(),
          1,
          1,
          Paint()..color = color.color,
        );
      }
    });

    for (final color in PlayerColor.values) {
      final c = kRingPath[color.ringStart];
      _rect(
        canvas,
        c.col.toDouble(),
        c.row.toDouble(),
        1,
        1,
        Paint()..color = color.color.withValues(alpha: 0.55),
      );
    }
  }

  void _paintCenter(Canvas canvas, double cs) {
    final c = cellCenter(7, 7);
    final tl = Offset(6 * cs, 6 * cs);
    final tr = Offset(9 * cs, 6 * cs);
    final br = Offset(9 * cs, 9 * cs);
    final bl = Offset(6 * cs, 9 * cs);
    void tri(Offset a, Offset b, PlayerColor color) {
      final path = Path()
        ..moveTo(a.dx, a.dy)
        ..lineTo(b.dx, b.dy)
        ..lineTo(c.x, c.y)
        ..close();
      canvas.drawPath(path, Paint()..color = color.color);
    }

    tri(tl, bl, PlayerColor.red);
    tri(tl, tr, PlayerColor.green);
    tri(tr, br, PlayerColor.yellow);
    tri(bl, br, PlayerColor.blue);
  }

  void _paintSafeStars(Canvas canvas, double cs) {
    final paint = Paint()..color = const Color(0x55000000);
    for (final idx in kSafeCells) {
      final cell = kRingPath[idx];
      _drawStar(canvas, cellCenter(cell.col, cell.row), cs * 0.32, paint);
    }
  }

  void _drawStar(Canvas canvas, Vector2 center, double radius, Paint paint) {
    final path = Path();
    const points = 5;
    for (var i = 0; i < points * 2; i++) {
      final r = i.isEven ? radius : radius * 0.45;
      final angle = -math.pi / 2 + i * math.pi / points;
      final x = center.x + r * math.cos(angle);
      final y = center.y + r * math.sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _paintGrid(Canvas canvas, double cs) {
    final line = Paint()
      ..color = const Color(0x22000000)
      ..strokeWidth = 1;

    for (var i = 0; i <= kGridSize; i++) {
      final p = i * cs;

      canvas.drawLine(Offset(6 * cs, p), Offset(9 * cs, p), line);

      canvas.drawLine(Offset(p, 6 * cs), Offset(p, 9 * cs), line);
    }
    for (var i = 6; i <= 9; i++) {
      final p = i * cs;
      canvas.drawLine(Offset(0, p), Offset(size.x, p), line);
      canvas.drawLine(Offset(p, 0), Offset(p, size.y), line);
    }
  }
}
