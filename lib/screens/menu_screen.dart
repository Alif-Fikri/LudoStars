import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../game/game_session.dart';
import '../game/ludo_constants.dart';
import '../game/ludo_game.dart';
import '../l10n/app_lang.dart';
import '../l10n/strings.dart';
import '../widgets/app_logo.dart';
import '../widgets/glossy_button.dart';
import '../widgets/remove_ads_button.dart';
import '../widgets/remove_ads_dialog.dart';
import '../widgets/settings_dialog.dart';
import 'game_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _vsComputer = true;
  PlayerColor _myColor = PlayerColor.red;
  int _count = 4;
  final Set<PlayerColor> _localColors = {...PlayerColor.values};
  final Map<PlayerColor, TextEditingController> _nameControllers = {
    for (final c in PlayerColor.values) c: TextEditingController(),
  };

  Map<PlayerColor, String> get _playerNames => {
    for (final e in _nameControllers.entries) e.key: e.value.text,
  };

  @override
  void initState() {
    super.initState();
    AppLang.instance.code.addListener(_onLang);
  }

  void _onLang() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    AppLang.instance.code.removeListener(_onLang);
    for (final c in _nameControllers.values) {
      c.dispose();
    }
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

  Future<void> _start() async {
    final proceed = await _showNameDialog(
      context,
      label: _vsComputer ? tr.yourName : tr.playerNames,
      colors: _vsComputer ? [_myColor] : _buildPlayers(),
      controllers: _nameControllers,
    );
    if (proceed != true || !mounted) return;

    final players = _buildPlayers();
    final ai = _vsComputer
        ? players.where((c) => c != _myColor).toSet()
        : <PlayerColor>{};
    final game = GameSession.instance.startNew(
      players: players,
      aiPlayers: ai,
      playerNames: _playerNames,
    );
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
      backgroundColor: const Color(0xFF2E9BD6),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(child: _buildHero()),
            _buildSheet(hasActive),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF36D1DC), Color(0xFF4A90E2)],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: _FloatingTokens()),
          SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _SettingsButton(onTap: () => showSettings(context)),
                      RemoveAdsButton(onTap: () => showRemoveAds(context)),
                    ],
                  ),
                ),
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppLogo(size: 92),
                      const SizedBox(height: 16),
                      const Text(
                        'LUDO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 46,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 8,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC107),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          'S T A R S',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSheet(bool hasActive) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: 1),
      builder: (context, t, child) => Transform.translate(
        offset: Offset(0, (1 - t) * 40),
        child: Opacity(opacity: t, child: child),
      ),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF6F8FB),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 24,
              offset: Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _sectionLabel(tr.mode),
                const SizedBox(height: 10),
                _ModeSegment(
                  vsComputer: _vsComputer,
                  onChanged: (v) => setState(() => _vsComputer = v),
                ),
                const SizedBox(height: 22),
                _sectionLabel(
                  _vsComputer ? tr.chooseYourColor : tr.choosePlayerColors,
                ),
                const SizedBox(height: 14),
                _ColorPicker(
                  vsComputer: _vsComputer,
                  myColor: _myColor,
                  localColors: _localColors,
                  onPickMine: (c) => setState(() => _myColor = c),
                  onToggleLocal: (c) => setState(() {
                    if (_localColors.contains(c)) {
                      if (_localColors.length > 2) _localColors.remove(c);
                    } else {
                      _localColors.add(c);
                    }
                  }),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  child: _vsComputer
                      ? Column(
                          children: [
                            const SizedBox(height: 22),
                            _sectionLabel(tr.playerCount),
                            const SizedBox(height: 12),
                            _CountSegment(
                              count: _count,
                              onChanged: (n) => setState(() => _count = n),
                            ),
                          ],
                        )
                      : const SizedBox(width: double.infinity),
                ),
                const SizedBox(height: 26),
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
                  const SizedBox(height: 12),
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
    );
  }

  Widget _sectionLabel(String text) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: Color(0xFF7A8A9A),
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    ),
  );
}

class _FloatingTokens extends StatefulWidget {
  const _FloatingTokens();

  @override
  State<_FloatingTokens> createState() => _FloatingTokensState();
}

class _FloatingTokensState extends State<_FloatingTokens>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _t = 0;

  static const _cycle = 14.0;
  static const _tokens = [
    (color: Color(0xFFE53935), x: 0.12, phase: 0.0, speed: 1.0, size: 26.0),
    (color: Color(0xFF43A047), x: 0.85, phase: 0.25, speed: 0.8, size: 20.0),
    (color: Color(0xFFFDD835), x: 0.30, phase: 0.55, speed: 1.15, size: 16.0),
    (color: Color(0xFF1E88E5), x: 0.68, phase: 0.78, speed: 0.9, size: 22.0),
    (color: Color(0xFFFFFFFF), x: 0.50, phase: 0.4, speed: 1.05, size: 14.0),
  ];

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      setState(() => _t = elapsed.inMicroseconds / 1e6);
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return IgnorePointer(
      child: Stack(
        children: [for (final tk in _tokens) _dot(tk, size)],
      ),
    );
  }

  Widget _dot(
    ({Color color, double x, double phase, double speed, double size}) tk,
    Size size,
  ) {
    final p = (_t / (_cycle / tk.speed) + tk.phase) % 1.0;
    final y = size.height * (1.05 - p * 1.2);
    final sway = 14 * math.sin(p * 2 * math.pi * 2);
    final opacity = (p < 0.15 ? p / 0.15 : (p > 0.85 ? (1 - p) / 0.15 : 1.0))
        .clamp(0.0, 1.0);
    return Positioned(
      left: size.width * tk.x + sway,
      top: y,
      child: Opacity(
        opacity: opacity * 0.4,
        child: Container(
          width: tk.size,
          height: tk.size,
          decoration: BoxDecoration(
            color: tk.color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
          ),
        ),
      ),
    );
  }
}

class _ModeSegment extends StatelessWidget {
  const _ModeSegment({required this.vsComputer, required this.onChanged});

  final bool vsComputer;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        const pad = 5.0;
        final segW = (w - pad * 2) / 2;
        return Container(
          height: 92,
          padding: const EdgeInsets.all(pad),
          decoration: BoxDecoration(
            color: const Color(0xFFE9EEF3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                alignment: vsComputer
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  width: segW,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withValues(alpha: 0.45),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _seg(
                      Icons.smart_toy,
                      tr.vsComputer,
                      vsComputer,
                      () => onChanged(true),
                    ),
                  ),
                  Expanded(
                    child: _seg(
                      Icons.group,
                      tr.local,
                      !vsComputer,
                      () => onChanged(false),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _seg(IconData icon, String label, bool active, VoidCallback onTap) {
    final color = active ? Colors.black87 : const Color(0xFF7A8A9A);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(12),
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
        child: const Icon(Icons.settings, color: Color(0xFF2D6FB3), size: 24),
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: PlayerColor.values.map((c) {
        final selected = vsComputer ? c == myColor : localColors.contains(c);
        return GestureDetector(
          onTap: () => vsComputer ? onPickMine(c) : onToggleLocal(c),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: c.color,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? Colors.white : Colors.white,
                width: selected ? 4 : 0,
              ),
              boxShadow: [
                if (selected)
                  BoxShadow(
                    color: c.color.withValues(alpha: 0.55),
                    blurRadius: 14,
                    spreadRadius: 1,
                  )
                else
                  const BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
              ],
            ),
            child: selected
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 28)
                : null,
          ),
        );
      }).toList(),
    );
  }
}

Future<bool?> _showNameDialog(
  BuildContext context, {
  required String label,
  required List<PlayerColor> colors,
  required Map<PlayerColor, TextEditingController> controllers,
}) {
  return showDialog<bool>(
    context: context,
    barrierColor: Colors.black54,
    builder: (ctx) => GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(ctx).unfocus(),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 34),
              padding: const EdgeInsets.fromLTRB(22, 46, 22, 22),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F8FB),
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 26,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShaderMask(
                    shaderCallback: (rect) => const LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF2D6FB3)],
                    ).createShader(rect),
                    child: Text(
                      label.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  ...colors.map((c) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [c.color, c.darkColor],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: c.color.withValues(alpha: 0.5),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: controllers[c],
                              maxLength: 14,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                isDense: true,
                                counterText: '',
                                hintText: c.label,
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: c.color.withValues(alpha: 0.35),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: c.color,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GlossyButton(
                          color: Colors.amber,
                          icon: Icons.play_arrow,
                          label: tr.start,
                          onTap: () => Navigator.of(ctx).pop(true),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF36D1DC), Color(0xFF4A90E2)],
                ),
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.5),
                    blurRadius: 14,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.badge_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _CountSegment extends StatelessWidget {
  const _CountSegment({required this.count, required this.onChanged});

  static const _options = [2, 3, 4];

  final int count;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const pad = 5.0;
        final segW = (constraints.maxWidth - pad * 2) / _options.length;
        final index = _options.indexOf(count).clamp(0, _options.length - 1);
        return Container(
          height: 56,
          padding: const EdgeInsets.all(pad),
          decoration: BoxDecoration(
            color: const Color(0xFFE9EEF3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                alignment: Alignment(-1 + index * (2 / (_options.length - 1)), 0),
                child: Container(
                  width: segW,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withValues(alpha: 0.45),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: _options.map((n) {
                  final selected = n == count;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged(n),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOut,
                          style: TextStyle(
                            color: selected
                                ? Colors.black87
                                : const Color(0xFF7A8A9A),
                            fontSize: selected ? 22 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                          child: Text('$n'),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
