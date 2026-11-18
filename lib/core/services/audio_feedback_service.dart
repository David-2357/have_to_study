import 'dart:math' as math;
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class AudioFeedbackService {
  static final AudioFeedbackService _instance = AudioFeedbackService._internal();
  factory AudioFeedbackService() => _instance;
  AudioFeedbackService._internal();

  AudioPlayer? _player;

  AudioPlayer get player {
    if (_player == null) {
      _player = AudioPlayer();
      try {
        _player!.setAudioContext(
          AudioContext(
            android: const AudioContextAndroid(
              isSpeakerphoneOn: true,
              stayAwake: true,
              contentType: AndroidContentType.sonification,
              usageType: AndroidUsageType.alarm,
              audioFocus: AndroidAudioFocus.gainTransientMayDuck,
            ),
            iOS: AudioContextIOS(
              category: AVAudioSessionCategory.playback,
              options: const {
                AVAudioSessionOptions.duckOthers,
              },
            ),
          ),
        );
      } catch (_) {}
    }
    return _player!;
  }

  Uint8List _generateWav({
    required List<double> freqs,
    required List<double> weights,
    required double durationSec,
    double decayFactor = 3.0,
  }) {
    const sampleRate = 22050;
    final totalSamples = (sampleRate * durationSec).toInt();
    final byteCount = totalSamples * 2;
    final buffer = ByteData(44 + byteCount);

    // RIFF header
    buffer.setUint8(0, 0x52); // R
    buffer.setUint8(1, 0x49); // I
    buffer.setUint8(2, 0x46); // F
    buffer.setUint8(3, 0x46); // F
    buffer.setUint32(4, 36 + byteCount, Endian.little);
    buffer.setUint8(8, 0x57); // W
    buffer.setUint8(9, 0x41); // A
    buffer.setUint8(10, 0x56); // V
    buffer.setUint8(11, 0x45); // E

    // fmt chunk
    buffer.setUint8(12, 0x66); // f
    buffer.setUint8(13, 0x6D); // m
    buffer.setUint8(14, 0x74); // t
    buffer.setUint8(15, 0x20); // ' '
    buffer.setUint32(16, 16, Endian.little); // Chunk size
    buffer.setUint16(20, 1, Endian.little); // Audio format: PCM (1)
    buffer.setUint16(22, 1, Endian.little); // Channels: 1
    buffer.setUint32(24, sampleRate, Endian.little); // Sample rate
    buffer.setUint32(28, sampleRate * 2, Endian.little); // Byte rate
    buffer.setUint16(32, 2, Endian.little); // Block align
    buffer.setUint16(34, 16, Endian.little); // Bits per sample

    // data chunk
    buffer.setUint8(36, 0x64); // d
    buffer.setUint8(37, 0x61); // a
    buffer.setUint8(38, 0x74); // t
    buffer.setUint8(39, 0x61); // a
    buffer.setUint32(40, byteCount, Endian.little);

    // Generar muestras con envolvente exponencial
    var offset = 44;
    for (int i = 0; i < totalSamples; i++) {
      final t = i / sampleRate;
      final envelope = math.exp(-decayFactor * t);
      double sample = 0;
      for (int f = 0; f < freqs.length; f++) {
        sample += math.sin(2 * math.pi * freqs[f] * t) * weights[f];
      }
      final value = (sample * envelope * 28000).clamp(-32767.0, 32767.0).toInt();
      buffer.setInt16(offset, value, Endian.little);
      offset += 2;
    }

    return buffer.buffer.asUint8List();
  }

  // Reproducir sonido al completar fase de pomodoro
  Future<void> playCompletionAlert(String soundType) async {
    try {
      await HapticFeedback.heavyImpact();
      await playTone(soundType);
    } catch (_) {
      try {
        await SystemSound.play(SystemSoundType.alert);
      } catch (_) {}
    }
  }

  // Reproducir tono para previsualización o alerta
  Future<void> playTone(String soundType) async {
    try {
      Uint8List bytes;
      final soundLower = soundType.toLowerCase();

      if (soundLower.contains('cuenco')) {
        // Cuenco tibetano: frecuencias graves y resonantes
        bytes = _generateWav(
          freqs: [216.0, 432.0, 648.0],
          weights: [0.6, 0.3, 0.1],
          durationSec: 1.8,
          decayFactor: 1.8,
        );
      } else if (soundLower.contains('zen')) {
        // Campana zen: tono alto y brillante (528 Hz)
        bytes = _generateWav(
          freqs: [528.0, 1056.0],
          weights: [0.8, 0.2],
          durationSec: 1.5,
          decayFactor: 2.2,
        );
      } else {
        // Tono suave: acorde armónico cálido C5 + E5
        bytes = _generateWav(
          freqs: [523.25, 659.25],
          weights: [0.5, 0.5],
          durationSec: 1.2,
          decayFactor: 2.5,
        );
      }

      await player.stop();
      await player.play(BytesSource(bytes));
    } catch (_) {
      await SystemSound.play(SystemSoundType.alert);
    }
  }

  void dispose() {
    _player?.dispose();
    _player = null;
  }
}
