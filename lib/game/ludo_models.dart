import 'ludo_constants.dart';

class Token {
  final PlayerColor color;
  final int index;
  int step;

  Token({required this.color, required this.index, this.step = kYardStep});

  bool get inYard => step == kYardStep;
  bool get isFinished => step >= kFinishStep;
  bool get onRing => step >= 0 && step <= 50;

  int? get ringIndex =>
      onRing ? (color.ringStart + step) % kRingPath.length : null;

  Cell get cell {
    if (inYard) return kYardSpots[color]![index];
    if (onRing) return kRingPath[ringIndex!];
    return kHomePaths[color]![step - 51];
  }
}

enum GamePhase { roll, action, gameOver }

class LudoUiState {
  final PlayerColor currentPlayer;
  final List<PlayerColor> players;
  final GamePhase phase;
  final int dice;
  final bool canReroll;
  final bool hasMoves;
  final bool isAiTurn;
  final String message;
  final PlayerColor? winner;
  final Map<PlayerColor, int> finishedCounts;

  const LudoUiState({
    required this.currentPlayer,
    required this.players,
    required this.phase,
    required this.dice,
    required this.canReroll,
    required this.hasMoves,
    required this.isAiTurn,
    required this.message,
    required this.winner,
    required this.finishedCounts,
  });
}
