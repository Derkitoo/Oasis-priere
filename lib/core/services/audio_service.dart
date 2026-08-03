import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../utils/web_audio.dart';

class AudioService {
  static final AudioService _instance = AudioService._();
  factory AudioService() => _instance;
  AudioService._();

  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  double _voiceVolume = 1.0;

  Future<void> _safePlay(AudioPlayer player, Source source) async {
    if (kIsWeb) return;
    try {
      await player.play(source);
    } catch (_) {}
  }

  // ─── Prière guidée ───
  Future<void> playPrayerStep(String stepId) async {
    await _safePlay(_player, AssetSource('audio/prayer/$stepId.mp3'));
  }

  Future<void> playAdhan(String prayerName) async {
    await _safePlay(_player, AssetSource('audio/adhan/${prayerName.toLowerCase()}.mp3'));
  }

  Future<void> playChime() async {
    if (kIsWeb) {
      playWebTone(freq: 880, duration: 0.5, volume: 0.3);
    } else {
      await _safePlay(_sfxPlayer, AssetSource('audio/sfx/chime.mp3'));
    }
  }

  Future<void> playTasbihBead() async {
    if (kIsWeb) {
      playWebTone(freq: 1200, duration: 0.12, volume: 0.25);
    } else {
      await _safePlay(_sfxPlayer, AssetSource('audio/sfx/bead.mp3'));
    }
  }

  Future<void> playXpGain() async {
    if (kIsWeb) {
      playWebTone(freq: 660, duration: 0.3, volume: 0.2);
    } else {
      await _safePlay(_sfxPlayer, AssetSource('audio/sfx/xp_gain.mp3'));
    }
  }

  Future<void> playLevelUp() async {
    if (kIsWeb) {
      playWebChord([523.25, 659.25, 783.99], duration: 1.2);
    } else {
      await _safePlay(_sfxPlayer, AssetSource('audio/sfx/level_up.mp3'));
    }
  }

  Future<void> playSuccess() async {
    if (kIsWeb) {
      playWebChord([440, 554.37, 659.25], duration: 0.8);
    } else {
      await _safePlay(_sfxPlayer, AssetSource('audio/sfx/success.mp3'));
    }
  }

  Future<void> playSura(String suraId) async {
    await _safePlay(_player, AssetSource('audio/suras/$suraId.mp3'));
  }

  void setVoiceVolume(double volume) {
    _voiceVolume = volume.clamp(0.0, 1.0);
    if (!kIsWeb) _player.setVolume(_voiceVolume);
  }

  double voiceVolumeForRakat(int rakatIndex, int totalRakat) {
    if (totalRakat <= 1) return 1.0;
    return switch (rakatIndex) {
      0 => 1.0,
      1 => 0.6,
      _ => 0.3,
    };
  }

  Future<void> stop() async {
    try { await _player.stop(); } catch (_) {}
    try { await _sfxPlayer.stop(); } catch (_) {}
  }

  Future<void> pause() async { try { await _player.pause(); } catch (_) {} }
  Future<void> resume() async { try { await _player.resume(); } catch (_) {} }

  void dispose() {
    _player.dispose();
    _sfxPlayer.dispose();
  }
}
