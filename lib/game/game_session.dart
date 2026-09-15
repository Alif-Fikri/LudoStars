import 'dart:convert';

import '../game/ludo_constants.dart';
import '../game/ludo_game.dart';
import '../storage/app_store.dart';

class GameSession {
  GameSession._();
  static final GameSession instance = GameSession._();

  static const _storeKey = 'saved_game';

  LudoGame? _game;

  /// A game persisted from an earlier app run, not yet rebuilt.
  Map<String, dynamic>? _pending;

  bool get hasActiveGame =>
      (_game != null && !_game!.isGameOver) || _pending != null;

  LudoGame? get game => _game;

  /// Reads any game saved by a previous run. Call once at startup.
  void loadSaved() {
    final raw = AppStore.instance.getString(_storeKey);
    if (raw == null) return;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      if (map['v'] == 1 && _colors(map['players']).length >= 2) {
        _pending = map;
      } else {
        AppStore.instance.remove(_storeKey);
      }
    } catch (_) {
      // A snapshot we can't read is worse than none.
      AppStore.instance.remove(_storeKey);
    }
  }

  LudoGame startNew({
    required List<PlayerColor> players,
    required Set<PlayerColor> aiPlayers,
    Map<PlayerColor, String> playerNames = const {},
  }) {
    _disposeCurrent();
    _pending = null;
    _game = _wire(
      LudoGame(
        players: players,
        aiPlayers: aiPlayers,
        playerNames: playerNames,
      ),
    );
    return _game!;
  }

  /// The in-memory game if one is running, otherwise one rebuilt from the
  /// snapshot saved by a previous run.
  LudoGame? resume() {
    if (_game != null && !_game!.isGameOver) return _game;
    final map = _pending;
    if (map == null) return null;

    final players = _colors(map['players']);
    final steps = <PlayerColor, List<int>>{};
    final rawTokens = map['tokens'] as Map<String, dynamic>? ?? const {};
    for (final entry in rawTokens.entries) {
      final color = _color(entry.key);
      if (color == null) continue;
      steps[color] = [for (final s in entry.value as List) (s as num).toInt()];
    }

    _disposeCurrent();
    _pending = null;
    _game = _wire(
      LudoGame(
        players: players,
        aiPlayers: _colors(map['ai']).toSet(),
        playerNames: {
          for (final e
              in (map['names'] as Map<String, dynamic>? ?? const {}).entries)
            ?_color(e.key): e.value as String,
        },
        restoredSteps: steps,
        restoredIndex: (map['currentIndex'] as num?)?.toInt() ?? 0,
        restoredRanking: _colors(map['ranking']),
        restoredSixes: (map['sixes'] as num?)?.toInt() ?? 0,
        restoredRerollUsed: map['rerollUsed'] as bool? ?? false,
      ),
    );
    return _game;
  }

  void clear() {
    _disposeCurrent();
    _pending = null;
    AppStore.instance.remove(_storeKey);
  }

  LudoGame _wire(LudoGame game) {
    game.onCheckpoint = (g) {
      if (g == null) {
        AppStore.instance.remove(_storeKey);
      } else {
        AppStore.instance.setString(_storeKey, jsonEncode(g.toSnapshot()));
      }
    };
    return game;
  }

  void _disposeCurrent() {
    _game?.abandon();
    _game?.uiState.dispose();
    _game = null;
  }

  static List<PlayerColor> _colors(Object? raw) => [
    for (final name in (raw as List? ?? const [])) ?_color(name as String),
  ];

  static PlayerColor? _color(String name) {
    for (final c in PlayerColor.values) {
      if (c.name == name) return c;
    }
    return null;
  }
}
