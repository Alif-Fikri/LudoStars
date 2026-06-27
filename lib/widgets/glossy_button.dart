import 'package:flutter/material.dart';

class GlossyButton extends StatefulWidget {
  const GlossyButton({
    super.key,
    required this.color,
    required this.label,
    required this.onTap,
    this.icon,
    this.fontSize = 16,
    this.vertical = 16,
  });

  final Color color;
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final double fontSize;
  final double vertical;

  @override
  State<GlossyButton> createState() => _GlossyButtonState();
}

class _GlossyButtonState extends State<GlossyButton> {
  bool _down = false;
  static const _radius = 18.0;

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(widget.color);
    final glossTop = Color.lerp(widget.color, Colors.white, 0.45)!;
    final dark = hsl
        .withLightness((hsl.lightness - 0.22).clamp(0, 1))
        .toColor();
    final textColor = hsl.lightness > 0.6 ? Colors.black87 : Colors.white;

    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) {
        setState(() => _down = false);
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        transform: Matrix4.translationValues(0, _down ? 4 : 0, 0),
        padding: EdgeInsets.symmetric(
          vertical: widget.vertical,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [glossTop, widget.color, widget.color, dark],
            stops: const [0, 0.5, 0.52, 1],
          ),
          borderRadius: BorderRadius.circular(_radius),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.4),
            width: 1.2,
          ),
          boxShadow: _down
              ? null
              : [
                  BoxShadow(color: dark, offset: const Offset(0, 5)),
                  const BoxShadow(
                    color: Color(0x55000000),
                    offset: Offset(0, 8),
                    blurRadius: 12,
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, color: textColor),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                widget.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
