import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../billing/purchase_manager.dart';

const bool kShowRemoveAdsButton = false;

class RemoveAdsButton extends StatelessWidget {
  const RemoveAdsButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (!kShowRemoveAdsButton) return const SizedBox.shrink();
    return ValueListenableBuilder<bool>(
      valueListenable: PurchaseManager.instance.adsRemoved,
      builder: (context, adsRemoved, _) {
        if (adsRemoved) return const SizedBox.shrink();
        return _PromoButton(onTap: onTap);
      },
    );
  }
}

class _PromoButton extends StatefulWidget {
  const _PromoButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_PromoButton> createState() => _PromoButtonState();
}

class _PromoButtonState extends State<_PromoButton>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _t = 0;
  bool _down = false;

  static const _size = 46.0;
  static const _ringSpan = 26.0;
  static const _attentionCycle = 4.2;
  static const _ringPeriod = 2.1;
  static const _breathPeriod = 2.6;

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

  double get _wiggle {
    const start = 0.78;
    final phase = (_t / _attentionCycle) % 1.0;
    if (phase < start) return 0;
    final local = (phase - start) / (1 - start);
    return math.sin(local * math.pi * 4) * 0.17 * (1 - local);
  }

  double get _breath => 1 + 0.045 * math.sin(_t * 2 * math.pi / _breathPeriod);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _down = true),
        onTapCancel: () => setState(() => _down = false),
        onTapUp: (_) {
          setState(() => _down = false);
          widget.onTap();
        },
        child: SizedBox(
          width: _size + _ringSpan,
          height: _size + _ringSpan,
          child: Stack(
            alignment: Alignment.center,
            children: [
              for (var i = 0; i < 2; i++) _ring(i * 0.5),
              Transform.scale(
                scale: (_down ? 0.92 : 1) * _breath,
                child: Transform.rotate(angle: _wiggle, child: _core()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ring(double offset) {
    final p = (_t / _ringPeriod + offset) % 1.0;
    final scale = 1 + p * (_ringSpan / _size);
    final opacity = (1 - p) * 0.45;
    return IgnorePointer(
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Transform.scale(
          scale: scale,
          child: Container(
            width: _size,
            height: _size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFFD54F), width: 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _core() {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFD54F), Color(0xFFFFA000)],
        ),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFA000).withValues(alpha: 0.55),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          const BoxShadow(
            color: Color(0x40000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: const Icon(
        Icons.block_rounded,
        color: Color(0xFF4A3200),
        size: 24,
      ),
    );
  }
}
