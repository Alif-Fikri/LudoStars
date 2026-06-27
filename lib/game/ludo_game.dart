import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../audio/audio_controller.dart';
import '../l10n/strings.dart';
import 'components/board_component.dart';
import 'components/token_component.dart';
import 'ludo_constants.dart';
import 'ludo_models.dart';

class LudoGame extends FlameGame {
  LudoGame({required this.players, this.aiPlayers = const {}})
    : assert(players.length >= 2 && players.length <= 4);

  final List<PlayerColor> players;
  final Set<PlayerColor> aiPlayers;

  void Function(PlayerColor winner)? onGameOver;

  final ValueNotifier<LudoUiState?> uiState = ValueNotifier(null);

  late final BoardComponent board;
  final Map<PlayerColor, List<Token>> tokens = {};
  final List<TokenComponent> _tokenComponents = [];

  int _currentIndex = 0;
  int dice = 0;
  GamePhase phase = GamePhase.roll;
  int _consecutiveSixes = 0;
  bool _rerollUsed = false;
  String _message = '';
  PlayerColor? winner;

  static const int _aiThinkMs = 850;
  static const int _moveCellMs = 270;

  final math.Random _rng = math.Random();
  bool _busy = false;
  bool _ready = false;
  bool _abandoned = false;

  void abandon() => _abandoned = true;

  PlayerColor get currentPlayer => players[_currentIndex];
  bool get isGameOver => phase == GamePhase.gameOver;
  bool get isAiTurn => !isGameOver && aiPlayers.contains(currentPlayer);

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  Future<void> onLoad() async {
    board = BoardComponent();
    add(board);

    for (final color in players) {
      final list = List.generate(4, (i) => Token(color: color, index: i));
      tokens[color] = list;
      for (final t in list) {
        final comp = TokenComponent(token: t);
        _tokenComponents.add(comp);
        board.add(comp);
      }
    }

    _ready = true;
    _layout();
    _message = _turnPrompt();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _publish();
      _scheduleAiTurn();
    });
  }

  double _lastBoardSide = -1;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (!_ready) return;
    final s = math.min(size.x, size.y);
    if (s == _lastBoardSide) return;
    _layout();
  }

  void _layout() {
    final s = math.min(size.x, size.y);
    _lastBoardSide = s;
    board.size = Vector2.all(s);
    board.position = Vector2((size.x - s) / 2, (size.y - s) / 2);
    _syncTokens(animate: false);
  }

  String _turnPrompt() => isAiTurn
      ? tr.thinking(currentPlayer.label)
      : tr.turnRoll(currentPlayer.label);

  void rollDice() {
    if (phase != GamePhase.roll || _busy) return;
    dice = 1 + _rng.nextInt(6);
    AudioController.instance.dice();
    if (dice == 6) {
      _consecutiveSixes++;
    } else {
      _consecutiveSixes = 0;
    }

    if (_consecutiveSixes == 3) {
      _message = tr.threeSixes;
      _busy = true;
      _publish();
      _delayThen(_passTurn);
      return;
    }

    phase = GamePhase.action;
    final movable = _movableTokens();

    if (movable.isEmpty) {
      _clearHighlights();
      _message = dice == 6
          ? tr.sixNoMove(currentPlayer.label)
          : tr.noMove(currentPlayer.label, dice);
      _busy = true;
      _publish();
      _delayThen(_passTurn);
      return;
    }

    _highlight(movable);
    _message = isAiTurn
        ? tr.botMoves(currentPlayer.label, dice)
        : tr.rolledTap(dice);
    _publish();

    if (isAiTurn) _delayMs(_aiThinkMs, _aiAct);
  }

  void applyReroll() {
    if (_rerollUsed || phase != GamePhase.action || _busy || isAiTurn) return;
    _rerollUsed = true;
    if (dice == 6 && _consecutiveSixes > 0) _consecutiveSixes--;
    dice = 0;
    phase = GamePhase.roll;
    _clearHighlights();
    _message = tr.freeReroll(currentPlayer.label);
    _publish();
  }

  void handleTapAt(double x, double y) {
    if (phase != GamePhase.action || _busy || isAiTurn) return;
    final movable = _movableTokens();
    if (movable.isEmpty) return;
    final p = Vector2(x - board.position.x, y - board.position.y);
    Token? best;
    var bestDist = board.cellSize;
    for (final c in _tokenComponents) {
      if (!movable.contains(c.token)) continue;
      final d = c.position.distanceTo(p);
      if (d < bestDist) {
        bestDist = d;
        best = c.token;
      }
    }
    if (best != null) _moveToken(best);
  }

  List<Token> _movableTokens() {
    final result = <Token>[];
    for (final t in tokens[currentPlayer]!) {
      if (t.isFinished) continue;
      if (t.inYard) {
        if (dice == 6) result.add(t);
        continue;
      }
      if (t.step + dice <= kFinishStep) result.add(t);
    }
    return result;
  }

  void _moveToken(Token token) {
    _busy = true;
    _clearHighlights();

    final from = token.step;
    if (token.inYard) {
      token.step = 0;
    } else {
      token.step += dice;
    }

    var finished = false;
    if (token.step >= kFinishStep) {
      token.step = kFinishStep;
      finished = true;
    }

    final points = <Vector2>[];
    final startStep = from < 0 ? 0 : from + 1;
    for (var s = startStep; s <= token.step; s++) {
      points.add(_stepCenter(token.color, s));
    }
    _componentFor(token).walk(points);
    _publish();

    final walkMs = (points.length * _moveCellMs + 250).clamp(500, 2400);
    _delayMs(walkMs, () => _resolveMove(token, finished));
  }

  void _resolveMove(Token token, bool finished) {
    var captured = false;
    final gi = token.ringIndex;
    if (gi != null && !kSafeCells.contains(gi)) {
      for (final other in _allTokens()) {
        if (other.color != token.color && other.ringIndex == gi) {
          other.step = kYardStep;
          captured = true;
        }
      }
    }

    _syncTokens(animate: true);

    final extraTurn = dice == 6 || captured || finished;
    final won = tokens[token.color]!.every((t) => t.isFinished);
    if (captured) {
      AudioController.instance.capture();
      _message = tr.captured(currentPlayer.label);
    } else if (finished) {
      _message = tr.reachedHome(currentPlayer.label);
    }
    _publish();

    _delayMs(captured ? 550 : 0, () {
      if (won) {
        _gameOver(token.color);
      } else if (extraTurn) {
        phase = GamePhase.roll;
        dice = 0;
        _message = tr.anotherTurn(currentPlayer.label);
        _busy = false;
        _publish();
        _scheduleAiTurn();
      } else {
        _passTurn();
      }
    });
  }

  void _passTurn() {
    _currentIndex = (_currentIndex + 1) % players.length;
    _consecutiveSixes = 0;
    _rerollUsed = false;
    dice = 0;
    phase = GamePhase.roll;
    _clearHighlights();
    _message = _turnPrompt();
    _busy = false;
    _publish();
    _scheduleAiTurn();
  }

  void _gameOver(PlayerColor w) {
    winner = w;
    phase = GamePhase.gameOver;
    dice = 0;
    AudioController.instance.win();
    _message = tr.wins(w.label);
    _busy = false;
    _publish();
    onGameOver?.call(w);
  }

  void _scheduleAiTurn() {
    if (!isAiTurn || phase != GamePhase.roll || _busy) return;
    _delayMs(_aiThinkMs, _aiRoll);
  }

  void _aiRoll() {
    if (!isAiTurn || phase != GamePhase.roll || _busy) return;
    rollDice();
  }

  void _aiAct() {
    if (!isAiTurn || phase != GamePhase.action || _busy) return;
    final movable = _movableTokens();
    if (movable.isEmpty) {
      _passTurn();
      return;
    }
    _moveToken(_pickAiMove(movable));
  }

  Token _pickAiMove(List<Token> movable) {
    Token? capture;
    var captureValue = -1;
    Token? finish;
    Token? exitYard;

    for (final t in movable) {
      final newStep = t.inYard ? 0 : t.step + dice;
      if (t.inYard) exitYard ??= t;
      if (newStep >= kFinishStep) finish ??= t;
      if (newStep >= 0 && newStep <= 50) {
        final targetGi = (t.color.ringStart + newStep) % kRingPath.length;
        if (!kSafeCells.contains(targetGi)) {
          for (final o in _allTokens()) {
            if (o.color != t.color &&
                o.ringIndex == targetGi &&
                o.step > captureValue) {
              captureValue = o.step;
              capture = t;
            }
          }
        }
      }
    }

    if (capture != null) return capture;
    if (finish != null) return finish;
    if (exitYard != null) return exitYard;
    movable.sort((a, b) => b.step.compareTo(a.step));
    return movable.first;
  }

  Vector2 _stepCenter(PlayerColor color, int step) {
    final cell = step <= 50
        ? kRingPath[(color.ringStart + step) % kRingPath.length]
        : kHomePaths[color]![step - 51];
    return board.cellCenter(cell.col, cell.row);
  }

  TokenComponent _componentFor(Token t) =>
      _tokenComponents.firstWhere((c) => c.token == t);

  Iterable<Token> _allTokens() => tokens.values.expand((l) => l);

  void _highlight(List<Token> movable) {
    for (final c in _tokenComponents) {
      c.movable = movable.contains(c.token);
    }
  }

  void _clearHighlights() {
    for (final c in _tokenComponents) {
      c.movable = false;
    }
  }

  void _syncTokens({required bool animate}) {
    final byCell = <String, List<TokenComponent>>{};
    for (final c in _tokenComponents) {
      final cell = c.token.cell;
      byCell.putIfAbsent('${cell.col},${cell.row}', () => []).add(c);
    }
    for (final group in byCell.values) {
      for (var i = 0; i < group.length; i++) {
        group[i].snapTo(
          stackIndex: i,
          stackCount: group.length,
          animate: animate,
        );
      }
    }
  }

  void _delayThen(VoidCallback fn) => _delayMs(700, fn);

  void _delayMs(int ms, VoidCallback fn) {
    Future<void>.delayed(Duration(milliseconds: ms), () {
      if (!_abandoned) fn();
    });
  }

  void _publish() {
    if (_abandoned) return;
    final movable = phase == GamePhase.action ? _movableTokens() : const [];
    uiState.value = LudoUiState(
      currentPlayer: currentPlayer,
      players: players,
      phase: phase,
      dice: dice,
      canReroll:
          phase == GamePhase.action && !_rerollUsed && !_busy && !isAiTurn,
      hasMoves: movable.isNotEmpty,
      isAiTurn: isAiTurn,
      message: _message,
      winner: winner,
      finishedCounts: {
        for (final p in players)
          p: tokens[p]!.where((t) => t.isFinished).length,
      },
    );
  }
}
