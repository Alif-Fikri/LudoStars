import '../game/ludo_constants.dart';
import '../game/ludo_game.dart';

class GameSession {
  GameSession._();
  static final GameSession instance = GameSession._();

  LudoGame? _game;

  bool get hasActiveGame => _game != null && !_game!.isGameOver;
  LudoGame? get game => _game;

  LudoGame startNew({
    required List<PlayerColor> players,
    required Set<PlayerColor> aiPlayers,
    Map<PlayerColor, String> playerNames = const {},
  }) {
    _game?.abandon();
    _game?.uiState.dispose();
    _game = LudoGame(
      players: players,
      aiPlayers: aiPlayers,
      playerNames: playerNames,
    );
    return _game!;
  }

  void clear() {
    _game?.abandon();
    _game?.uiState.dispose();
    _game = null;
  }
}
