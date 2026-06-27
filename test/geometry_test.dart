import 'package:flutter_test/flutter_test.dart';
import 'package:ludogams/game/ludo_constants.dart';

int cheby(Cell a, Cell b) =>
    (a.col - b.col).abs() > (a.row - b.row).abs()
        ? (a.col - b.col).abs()
        : (a.row - b.row).abs();

int manhattan(Cell a, Cell b) =>
    (a.col - b.col).abs() + (a.row - b.row).abs();

void main() {
  test('ring has 52 unique in-bounds cells', () {
    expect(kRingPath.length, 52);
    final seen = <String>{};
    for (final c in kRingPath) {
      expect(c.col >= 0 && c.col < kGridSize, isTrue);
      expect(c.row >= 0 && c.row < kGridSize, isTrue);
      expect(seen.add('${c.col},${c.row}'), isTrue, reason: 'duplicate $c');
    }
  });

  test('ring is continuous (each step adjacent incl. corner turns)', () {
    for (var i = 0; i < kRingPath.length; i++) {
      final a = kRingPath[i];
      final b = kRingPath[(i + 1) % kRingPath.length];
      expect(cheby(a, b), 1, reason: 'gap between cell $i and ${i + 1}');
    }
  });

  test('each color enters its home column from the ring correctly', () {
    for (final color in PlayerColor.values) {
      // Cell at relative step 50 is the last ring cell before peeling off.
      final entryRing = kRingPath[(color.ringStart + 50) % kRingPath.length];
      final home = kHomePaths[color]!;
      expect(home.length, 6);
      expect(manhattan(entryRing, home.first), 1,
          reason: '${color.label} home entry not adjacent');
      // Home column cells are orthogonally contiguous.
      for (var i = 0; i < home.length - 1; i++) {
        expect(manhattan(home[i], home[i + 1]), 1,
            reason: '${color.label} home gap at $i');
      }
    }
  });

  test('each color finishes on a distinct center cell', () {
    final finishes = <String>{};
    for (final color in PlayerColor.values) {
      final f = kHomePaths[color]!.last;
      expect(finishes.add('${f.col},${f.row}'), isTrue);
      // Finish cells border the center.
      expect(f.col >= 6 && f.col <= 8, isTrue);
      expect(f.row >= 6 && f.row <= 8, isTrue);
    }
  });

  test('safe cells are valid ring indices and include all starts', () {
    for (final idx in kSafeCells) {
      expect(idx >= 0 && idx < kRingPath.length, isTrue);
    }
    for (final color in PlayerColor.values) {
      expect(kSafeCells.contains(color.ringStart), isTrue);
    }
  });
}
