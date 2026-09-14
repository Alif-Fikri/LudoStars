import 'package:flutter/material.dart';

import '../l10n/strings.dart';

enum PlayerColor { red, green, yellow, blue }

extension PlayerColorX on PlayerColor {
  Color get color {
    switch (this) {
      case PlayerColor.red:
        return const Color(0xFFE53935);
      case PlayerColor.green:
        return const Color(0xFF43A047);
      case PlayerColor.yellow:
        return const Color(0xFFFDD835);
      case PlayerColor.blue:
        return const Color(0xFF1E88E5);
    }
  }

  Color get darkColor {
    switch (this) {
      case PlayerColor.red:
        return const Color(0xFFB71C1C);
      case PlayerColor.green:
        return const Color(0xFF1B5E20);
      case PlayerColor.yellow:
        return const Color(0xFFF9A825);
      case PlayerColor.blue:
        return const Color(0xFF0D47A1);
    }
  }

  String get label {
    switch (this) {
      case PlayerColor.red:
        return tr.colorRed;
      case PlayerColor.green:
        return tr.colorGreen;
      case PlayerColor.yellow:
        return tr.colorYellow;
      case PlayerColor.blue:
        return tr.colorBlue;
    }
  }

  int get ringStart {
    switch (this) {
      case PlayerColor.red:
        return 0;
      case PlayerColor.green:
        return 13;
      case PlayerColor.yellow:
        return 26;
      case PlayerColor.blue:
        return 39;
    }
  }
}

const int kGridSize = 15;

class Cell {
  final int col;
  final int row;
  const Cell(this.col, this.row);
}

const List<Cell> kRingPath = [
  Cell(1, 6),
  Cell(2, 6),
  Cell(3, 6),
  Cell(4, 6),
  Cell(5, 6),
  Cell(6, 5),
  Cell(6, 4),
  Cell(6, 3),
  Cell(6, 2),
  Cell(6, 1),
  Cell(6, 0),
  Cell(7, 0),
  Cell(8, 0),
  Cell(8, 1),
  Cell(8, 2),
  Cell(8, 3),
  Cell(8, 4),
  Cell(8, 5),
  Cell(9, 6),
  Cell(10, 6),
  Cell(11, 6),
  Cell(12, 6),
  Cell(13, 6),
  Cell(14, 6),
  Cell(14, 7),
  Cell(14, 8),
  Cell(13, 8),
  Cell(12, 8),
  Cell(11, 8),
  Cell(10, 8),
  Cell(9, 8),
  Cell(8, 9),
  Cell(8, 10),
  Cell(8, 11),
  Cell(8, 12),
  Cell(8, 13),
  Cell(8, 14),
  Cell(7, 14),
  Cell(6, 14),
  Cell(6, 13),
  Cell(6, 12),
  Cell(6, 11),
  Cell(6, 10),
  Cell(6, 9),
  Cell(5, 8),
  Cell(4, 8),
  Cell(3, 8),
  Cell(2, 8),
  Cell(1, 8),
  Cell(0, 8),
  Cell(0, 7),
  Cell(0, 6),
];

const Map<PlayerColor, List<Cell>> kHomePaths = {
  PlayerColor.red: [
    Cell(1, 7),
    Cell(2, 7),
    Cell(3, 7),
    Cell(4, 7),
    Cell(5, 7),
    Cell(6, 7),
  ],
  PlayerColor.green: [
    Cell(7, 1),
    Cell(7, 2),
    Cell(7, 3),
    Cell(7, 4),
    Cell(7, 5),
    Cell(7, 6),
  ],
  PlayerColor.yellow: [
    Cell(13, 7),
    Cell(12, 7),
    Cell(11, 7),
    Cell(10, 7),
    Cell(9, 7),
    Cell(8, 7),
  ],
  PlayerColor.blue: [
    Cell(7, 13),
    Cell(7, 12),
    Cell(7, 11),
    Cell(7, 10),
    Cell(7, 9),
    Cell(7, 8),
  ],
};

const Map<PlayerColor, List<Cell>> kYardSpots = {
  PlayerColor.red: [Cell(1, 1), Cell(4, 1), Cell(1, 4), Cell(4, 4)],
  PlayerColor.green: [Cell(10, 1), Cell(13, 1), Cell(10, 4), Cell(13, 4)],
  PlayerColor.yellow: [Cell(10, 10), Cell(13, 10), Cell(10, 13), Cell(13, 13)],
  PlayerColor.blue: [Cell(1, 10), Cell(4, 10), Cell(1, 13), Cell(4, 13)],
};

const Set<int> kSafeCells = {0, 13, 26, 39, 8, 21, 34, 47};

const int kFinishStep = 56;

const int kYardStep = -1;

const Map<PlayerColor, Rect> kYardRects = {
  PlayerColor.red: Rect.fromLTWH(0, 0, 6, 6),
  PlayerColor.green: Rect.fromLTWH(9, 0, 6, 6),
  PlayerColor.yellow: Rect.fromLTWH(9, 9, 6, 6),
  PlayerColor.blue: Rect.fromLTWH(0, 9, 6, 6),
};
