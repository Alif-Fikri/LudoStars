import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../ads/ad_manager.dart';
import '../game/game_session.dart';
import '../game/ludo_constants.dart';
import '../game/ludo_game.dart';
import '../game/ludo_models.dart';
import '../l10n/strings.dart';
import '../widgets/dice_widget.dart';
import '../widgets/glossy_button.dart';
import '../widgets/win_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.game});

  final LudoGame game;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _gameOverHandled = false;

  LudoGame get _game => widget.game;

  @override
  void initState() {
    super.initState();
    _game.onGameOver = _handleGameOver;
  }

  void _handleGameOver(List<PlayerColor> ranking) {
    if (_gameOverHandled) return;
    _gameOverHandled = true;
    AdManager.instance.showInterstitial(
      onDismissed: () {
        if (mounted) _showWinnerDialog(ranking);
      },
    );
  }

  void _showWinnerDialog(List<PlayerColor> ranking) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, _, _) => Material(
        type: MaterialType.transparency,
        child: WinDialog(
          winner: ranking.first,
          ranking: ranking,
          nameOf: _game.nameOf,
          onMenu: () {
            GameSession.instance.clear();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3FC1E0), Color(0xFF2D6FB3)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: ValueListenableBuilder<LudoUiState?>(
            valueListenable: _game.uiState,
            builder: (context, state, _) {
              return Column(
                children: [
                  _Header(
                    state: state,
                    game: _game,
                    onExit: () => Navigator.of(context).maybePop(),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTapDown: (d) => _game.handleTapAt(
                              d.localPosition.dx,
                              d.localPosition.dy,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x66000000),
                                    blurRadius: 26,
                                    offset: Offset(0, 14),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: GameWidget(game: _game),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (state != null)
                    _ControlPanel(state: state, onRoll: _game.rollDice),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.state,
    required this.game,
    required this.onExit,
  });
  final LudoUiState? state;
  final LudoGame game;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onExit,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (state != null) Expanded(child: _Scoreboard(state: state!)),
            ],
          ),
          if (state != null) ...[
            const SizedBox(height: 10),
            _TurnBanner(state: state!, game: game),
          ],
        ],
      ),
    );
  }
}

class _Scoreboard extends StatelessWidget {
  const _Scoreboard({required this.state});
  final LudoUiState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: state.players.map((p) {
        final active =
            p == state.currentPlayer && state.phase != GamePhase.gameOver;
        final hsl = HSLColor.fromColor(p.color);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                hsl.withLightness((hsl.lightness + 0.1).clamp(0, 1)).toColor(),
                p.darkColor,
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: active ? Border.all(color: Colors.white, width: 2) : null,
            boxShadow: [
              BoxShadow(color: p.darkColor, offset: const Offset(0, 3)),
              if (active)
                BoxShadow(
                  color: p.color.withValues(alpha: 0.8),
                  blurRadius: 14,
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.flag, size: 16, color: Colors.white),
              const SizedBox(width: 5),
              Text(
                '${state.finishedCounts[p] ?? 0}/4',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _TurnBanner extends StatelessWidget {
  const _TurnBanner({required this.state, required this.game});
  final LudoUiState state;
  final LudoGame game;

  @override
  Widget build(BuildContext context) {
    final p = state.currentPlayer;
    final over = state.phase == GamePhase.gameOver;
    final hsl = HSLColor.fromColor(p.color);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            hsl.withLightness((hsl.lightness + 0.1).clamp(0, 1)).toColor(),
            p.darkColor,
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: p.darkColor, offset: const Offset(0, 5)),
          BoxShadow(
            color: p.color.withValues(alpha: 0.5),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 19,
            backgroundColor: Colors.white,
            child: Icon(
              over
                  ? Icons.emoji_events
                  : (state.isAiTurn ? Icons.smart_toy : Icons.person),
              color: p.color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  over ? tr.finished : tr.turnOf(game.nameOf(p)),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(color: Colors.black26, offset: Offset(0, 1)),
                    ],
                  ),
                ),
                Text(
                  state.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          if (state.isAiTurn && !over)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}

class _ControlPanel extends StatelessWidget {
  const _ControlPanel({required this.state, required this.onRoll});

  final LudoUiState state;
  final VoidCallback onRoll;

  @override
  Widget build(BuildContext context) {
    final canRoll = state.phase == GamePhase.roll && !state.isAiTurn;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, 22, 20, 16 + bottomInset),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2E86A8), Color(0xFF0E3A4D)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [BoxShadow(color: Color(0x66000000), blurRadius: 18)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedDice(value: state.dice, size: 66),
              const SizedBox(width: 20),
              Expanded(child: _primaryAction(canRoll)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _primaryAction(bool canRoll) {
    if (state.isAiTurn) {
      return Text(
        tr.computerPlaying,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white70, fontSize: 15),
      );
    }
    if (canRoll) {
      return GlossyButton(
        color: state.currentPlayer.color,
        icon: Icons.casino,
        label: tr.rollDice,
        onTap: onRoll,
      );
    }
    return Text(
      tr.tapHighlighted,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white, fontSize: 15),
    );
  }
}
