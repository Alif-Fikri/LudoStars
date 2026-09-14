import 'package:flutter/material.dart';

import '../audio/audio_controller.dart';
import '../l10n/app_lang.dart';
import '../l10n/strings.dart';
import 'glossy_button.dart';

Future<void> showSettings(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black54,
    builder: (_) => const _SettingsDialog(),
  );
}

class _SettingsDialog extends StatelessWidget {
  const _SettingsDialog();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLang.instance.code,
      builder: (context, langCode, _) => _body(context, langCode),
    );
  }

  Widget _body(BuildContext context, String langCode) {
    final audio = AudioController.instance;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E86A8), Color(0xFF124A63)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x88000000),
              blurRadius: 24,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.settings, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  tr.settings,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _label(tr.language),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                for (final lang in AppLang.supported)
                  _FlagButton(
                    lang: lang,
                    selected: langCode == lang.code,
                    onTap: () => AppLang.instance.set(lang.code),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            _label('${tr.music} & ${tr.sound}'),
            const SizedBox(height: 8),
            ValueListenableBuilder<bool>(
              valueListenable: audio.musicEnabled,
              builder: (context, on, _) => GlossyButton(
                color: on ? const Color(0xFF43A047) : const Color(0xFF607D8B),
                icon: on ? Icons.music_note : Icons.music_off,
                label: '${tr.music}: ${on ? tr.on : tr.off}',
                vertical: 13,
                onTap: () => audio.setMusic(!on),
              ),
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder<bool>(
              valueListenable: audio.sfxEnabled,
              builder: (context, on, _) => GlossyButton(
                color: on ? const Color(0xFF43A047) : const Color(0xFF607D8B),
                icon: on ? Icons.volume_up : Icons.volume_off,
                label: '${tr.sound}: ${on ? tr.on : tr.off}',
                vertical: 13,
                onTap: () => audio.setSfx(!on),
              ),
            ),
            const SizedBox(height: 20),
            GlossyButton(
              color: const Color(0xFFFFB300),
              icon: Icons.check,
              label: tr.close,
              vertical: 13,
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _FlagButton extends StatelessWidget {
  const _FlagButton({
    required this.lang,
    required this.selected,
    required this.onTap,
  });

  final LangOption lang;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: lang.label,
      selected: selected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          width: 56,
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? Colors.amber.withValues(alpha: 0.28)
                : Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? const Color(0xFFFFC107)
                  : Colors.white.withValues(alpha: 0.2),
              width: selected ? 2.4 : 1.2,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.45),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: Text(lang.flag, style: const TextStyle(fontSize: 30)),
        ),
      ),
    );
  }
}
