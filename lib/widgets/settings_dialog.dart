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

class _SettingsDialog extends StatefulWidget {
  const _SettingsDialog();

  @override
  State<_SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<_SettingsDialog> {
  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GlossyButton(
                    color: AppLang.instance.isId
                        ? const Color(0xFF607D8B)
                        : Colors.amber,
                    label: 'English',
                    vertical: 12,
                    onTap: () => setState(() => AppLang.instance.set('en')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GlossyButton(
                    color: AppLang.instance.isId
                        ? Colors.amber
                        : const Color(0xFF607D8B),
                    label: 'Indonesia',
                    vertical: 12,
                    onTap: () => setState(() => AppLang.instance.set('id')),
                  ),
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
    alignment: Alignment.centerLeft,
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
