import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../game/game_session.dart';
import '../game/ludo_constants.dart';
import '../game/ludo_game.dart';
import '../l10n/app_lang.dart';
import '../l10n/strings.dart';
import '../widgets/app_logo.dart';
import '../widgets/glossy_button.dart';
import '../widgets/settings_dialog.dart';
import 'game_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  bool _vsComputer = true;
  PlayerColor _myColor = PlayerColor.red;
  int _count = 4;
  final Set<PlayerColor> _localColors = {...PlayerColor.values};

  late final AnimationController _ambient;

  @override
  void initState() {
    super.initState();
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    AppLang.instance.code.addListener(_onLang);
  }

  void _onLang() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    AppLang.instance.code.removeListener(_onLang);
    _ambient.dispose();
    super.dispose();
  }

  List<PlayerColor> _buildPlayers() {
    final ordered = PlayerColor.values;
    if (_vsComputer) {
      final others = ordered.where((c) => c != _myColor).toList();
      final chosen = <PlayerColor>{_myColor, ...others.take(_count - 1)};
      return ordered.where(chosen.contains).toList();
    }
    return ordered.where(_localColors.contains).toList();
  }

  bool get _canStart => _vsComputer || _localColors.length >= 2;

  void _start() {
    final players = _buildPlayers();
    final ai = _vsComputer
        ? players.where((c) => c != _myColor).toSet()
        : <PlayerColor>{};
    final game = GameSession.instance.startNew(players: players, aiPlayers: ai);
    _open(game);
  }

  void _continue() {
    final game = GameSession.instance.game;
    if (game != null) _open(game);
  }

  void _open(LudoGame game) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => GameScreen(game: game)))
        .then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final hasActive = GameSession.instance.hasActiveGame;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF36D1DC), Color(0xFF5B86E5)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    tween: Tween(begin: 0, end: 1),
                    builder: (context, t, child) => Opacity(
                      opacity: t,
                      child: Transform.translate(
                        offset: Offset(0, (1 - t) * 24),
                        child: child,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBuilder(
                          animation: _ambient,
                          builder: (context, child) => Transform.translate(
                            offset: Offset(
                              0,
                              math.sin(_ambient.value * math.pi) * -6,
                            ),
                            child: Transform.rotate(
                              angle: (_ambient.value - 0.5) * 0.08,
                              child: child,
                            ),
                          ),
                          child: const AppLogo(size: 96),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'LUDO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 52,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 10,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                offset: Offset(0, 4),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFC107),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'S T A R S',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          tr.tagline,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 24),

                        _sectionLabel(tr.mode),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _ModeButton(
                              icon: Icons.smart_toy,
                              label: tr.vsComputer,
                              selected: _vsComputer,
                              onTap: () => setState(() => _vsComputer = true),
                            ),
                            const SizedBox(width: 12),
                            _ModeButton(
                              icon: Icons.group,
                              label: tr.local,
                              selected: !_vsComputer,
                              onTap: () => setState(() => _vsComputer = false),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),

                        _sectionLabel(
                          _vsComputer
                              ? tr.chooseYourColor
                              : tr.choosePlayerColors,
                        ),
                        const SizedBox(height: 12),
                        _ColorPicker(
                          vsComputer: _vsComputer,
                          myColor: _myColor,
                          localColors: _localColors,
                          onPickMine: (c) => setState(() => _myColor = c),
                          onToggleLocal: (c) => setState(() {
                            if (_localColors.contains(c)) {
                              if (_localColors.length > 2) {
                                _localColors.remove(c);
                              }
                            } else {
                              _localColors.add(c);
                            }
                          }),
                        ),

                        if (_vsComputer) ...[
                          const SizedBox(height: 22),
                          _sectionLabel(tr.playerCount),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [2, 3, 4].map((n) {
                              final selected = n == _count;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: ChoiceChip(
                                  label: Text('$n'),
                                  selected: selected,
                                  labelStyle: TextStyle(
                                    color: selected
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  selectedColor: Colors.amber,
                                  backgroundColor: Colors.white24,
                                  onSelected: (_) => setState(() => _count = n),
                                ),
                              );
                            }).toList(),
                          ),
                        ],

                        const SizedBox(height: 32),
                        if (hasActive) ...[
                          SizedBox(
                            width: double.infinity,
                            child: GlossyButton(
                              color: const Color(0xFF43A047),
                              icon: Icons.play_arrow,
                              label: tr.continueGame,
                              fontSize: 18,
                              vertical: 18,
                              onTap: _continue,
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: Opacity(
                              opacity: _canStart ? 1 : 0.5,
                              child: GlossyButton(
                                color: Colors.amber,
                                icon: Icons.refresh,
                                label: tr.newGame,
                                fontSize: 18,
                                vertical: 18,
                                onTap: _canStart ? _start : () {},
                              ),
                            ),
                          ),
                        ] else
                          SizedBox(
                            width: double.infinity,
                            child: Opacity(
                              opacity: _canStart ? 1 : 0.5,
                              child: GlossyButton(
                                color: Colors.amber,
                                icon: Icons.play_arrow,
                                label: tr.start,
                                fontSize: 18,
                                vertical: 18,
                                onTap: _canStart ? _start : () {},
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: _SettingsButton(onTap: () => showSettings(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFE3EAF2)],
          ),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x55000000),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.settings, color: Color(0xFF2D6FB3), size: 26),
      ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({
    required this.vsComputer,
    required this.myColor,
    required this.localColors,
    required this.onPickMine,
    required this.onToggleLocal,
  });

  final bool vsComputer;
  final PlayerColor myColor;
  final Set<PlayerColor> localColors;
  final ValueChanged<PlayerColor> onPickMine;
  final ValueChanged<PlayerColor> onToggleLocal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: PlayerColor.values.map((c) {
        final selected = vsComputer ? c == myColor : localColors.contains(c);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GestureDetector(
            onTap: () => vsComputer ? onPickMine(c) : onToggleLocal(c),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: c.color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? Colors.white : Colors.transparent,
                  width: 3,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: c.color.withValues(alpha: 0.8),
                          blurRadius: 14,
                        ),
                      ]
                    : [
                        const BoxShadow(
                          color: Color(0x55000000),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.white)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 132,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? Colors.amber : Colors.white12,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? Colors.amber : Colors.white24,
            width: 2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.5),
                    blurRadius: 14,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? Colors.black : Colors.white, size: 30),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

