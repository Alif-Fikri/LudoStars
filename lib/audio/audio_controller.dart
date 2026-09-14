import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

class AudioController {
  AudioController._();
  static final AudioController instance = AudioController._();

  final ValueNotifier<bool> musicEnabled = ValueNotifier(true);
  final ValueNotifier<bool> sfxEnabled = ValueNotifier(true);

  final AudioPlayer _music = AudioPlayer();
  final List<AudioPlayer> _sfx = [];
  int _next = 0;
  bool _ready = false;

  Future<void> init() async {
    try {
      await _music.setReleaseMode(ReleaseMode.loop);
      for (var i = 0; i < 4; i++) {
        _sfx.add(AudioPlayer()..setReleaseMode(ReleaseMode.stop));
      }
      _ready = true;
    } catch (_) {}
  }

  void _play(String file, double volume) {
    if (!sfxEnabled.value || !_ready) return;
    final p = _sfx[_next];
    _next = (_next + 1) % _sfx.length;
    unawaited(
      p.play(AssetSource('audio/$file'), volume: volume).catchError((_) {}),
    );
  }

  void hop() => _play('hop.wav', 0.45);
  void dice() => _play('dice.wav', 0.7);
  void capture() => _play('capture.wav', 0.8);
  void win() => _play('win.wav', 0.8);

  Future<void> startMusic() async {
    if (!_ready || !musicEnabled.value) return;
    try {
      await _music.play(AssetSource('audio/music.wav'), volume: 0.35);
    } catch (_) {}
  }

  Future<void> stopMusic() async {
    try {
      await _music.stop();
    } catch (_) {}
  }

  void setMusic(bool on) {
    musicEnabled.value = on;
    if (on) {
      startMusic();
    } else {
      stopMusic();
    }
  }

  void setSfx(bool on) => sfxEnabled.value = on;

  /// Pauses music while the app is not in the foreground, and resumes it only
  /// if the user had music turned on.
  Future<void> handleLifecycle(AppLifecycleState state) async {
    if (!_ready) return;
    try {
      if (state != AppLifecycleState.resumed) {
        if (_music.state == PlayerState.playing) await _music.pause();
      } else if (musicEnabled.value) {
        // resume() only works from a paused state; otherwise start from scratch.
        if (_music.state == PlayerState.paused) {
          await _music.resume();
        } else if (_music.state != PlayerState.playing) {
          await startMusic();
        }
      }
    } catch (_) {}
  }
}
