import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../game/ludo_constants.dart';
import '../l10n/strings.dart';
import 'glossy_button.dart';

class WinDialog extends StatefulWidget {
  const WinDialog({super.key, required this.winner, required this.onMenu});

  final PlayerColor winner;
  final VoidCallback onMenu;

  @override
  State<WinDialog> createState() => _WinDialogState();
}

class _WinDialogState extends State<WinDialog> with TickerProviderStateMixin {
  late final AnimationController _entrance;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _entrance.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.winner.color;
    final dark = widget.winner.darkColor;

    const trophySize = 96.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        const Positioned.fill(child: _Confetti()),
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: trophySize / 2),
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: _entrance,
                  curve: Curves.elasticOut,
                ),
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _entrance,
                    curve: const Interval(0, 0.4, curve: Curves.easeOut),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.fromLTRB(
                      24,
                      trophySize / 2 + 16,
                      24,
                      24,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F8FB),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 30,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ShaderMask(
                          shaderCallback: (rect) => LinearGradient(
                            colors: [color, dark],
                          ).createShader(rect),
                          child: const Text(
                            'VICTORY!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              tr.wins(widget.winner.label),
                              style: const TextStyle(
                                color: Color(0xFF3A4750),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          child: GlossyButton(
                            color: Colors.amber,
                            icon: Icons.home_rounded,
                            label: tr.menu,
                            fontSize: 17,
                            vertical: 16,
                            onTap: widget.onMenu,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: _entrance,
                  curve: Curves.elasticOut,
                ),
                child: AnimatedBuilder(
                  animation: _pulse,
                  builder: (context, child) {
                    final glow = 18 + _pulse.value * 10;
                    return Container(
                      width: trophySize,
                      height: trophySize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [color, dark],
                        ),
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.7),
                            blurRadius: glow,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.emoji_events_rounded,
                        color: Colors.white,
                        size: 52,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Confetti extends StatefulWidget {
  const _Confetti();

  @override
  State<_Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<_Confetti>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _t = 0;
  late final List<_Piece> _pieces;

  static const _colors = [
    Color(0xFFE53935),
    Color(0xFF43A047),
    Color(0xFFFDD835),
    Color(0xFF1E88E5),
    Colors.white,
  ];

  @override
  void initState() {
    super.initState();
    final rnd = math.Random(7);
    _pieces = List.generate(28, (i) {
      return _Piece(
        x: rnd.nextDouble(),
        phase: rnd.nextDouble(),
        speed: 0.6 + rnd.nextDouble() * 0.7,
        size: 6 + rnd.nextDouble() * 7,
        color: _colors[i % _colors.length],
        swayFreq: 1 + rnd.nextDouble() * 2,
        swayAmp: 10 + rnd.nextDouble() * 20,
        spin: (rnd.nextBool() ? 1 : -1) * (1 + rnd.nextDouble() * 2),
        square: rnd.nextBool(),
      );
    });
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
      child: Stack(children: [for (final p in _pieces) _build(p, size)]),
    );
  }

  Widget _build(_Piece p, Size size) {
    const cycle = 3.2;
    final localT = (_t / (cycle / p.speed) + p.phase) % 1.0;
    final y = -40 + localT * (size.height + 80);
    final sway = math.sin(localT * math.pi * 2 * p.swayFreq) * p.swayAmp;
    final angle = _t * p.spin;
    final opacity = localT > 0.9 ? (1 - localT) * 10 : 1.0;

    return Positioned(
      left: size.width * p.x + sway,
      top: y,
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Transform.rotate(
          angle: angle,
          child: Container(
            width: p.size,
            height: p.size * (p.square ? 1 : 1.6),
            decoration: BoxDecoration(
              color: p.color,
              borderRadius: BorderRadius.circular(p.square ? 2 : p.size),
            ),
          ),
        ),
      ),
    );
  }
}

class _Piece {
  final double x;
  final double phase;
  final double speed;
  final double size;
  final Color color;
  final double swayFreq;
  final double swayAmp;
  final double spin;
  final bool square;

  _Piece({
    required this.x,
    required this.phase,
    required this.speed,
    required this.size,
    required this.color,
    required this.swayFreq,
    required this.swayAmp,
    required this.spin,
    required this.square,
  });
}
