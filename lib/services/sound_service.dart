import 'package:audioplayers/audioplayers.dart';

/// SoundService: manages send and receive chat sound effects.
/// Uses AudioPlayer from the audioplayers package.
/// On Flutter Web, audioplayers uses HTML Audio API – sound works in Chrome.
/// Sounds are generated as short PCM WAV tones encoded as data URIs.
class SoundService {
  static final AudioPlayer _sendPlayer = AudioPlayer();
  static final AudioPlayer _receivePlayer = AudioPlayer();

  /// Tiny WAV: 440 Hz sine wave, 0.08 s, 8-bit, 8000 Hz mono.
  /// Generated inline to avoid external asset files.
  static const String _sendSoundBase64 =
      'data:audio/wav;base64,'
      'UklGRlQAAABXQVZFZm10IBAAAAABAAEARKwAAIhYAQACABAAZGF0YTAAAAB'
      'mZnZ2hoaWlqamtra6urq+vr7CwsLGxsbKysrOzs7Q0NDR0dHS0tLT09PT'
      '09PT09PT09PT09PT09PT09PR0dHS0tLT09PT09PT09PT09PT09PT09PR0dE=';

  static const String _receiveSoundBase64 =
      'data:audio/wav;base64,'
      'UklGRlQAAABXQVZFZm10IBAAAAABAAEARKwAAIhYAQACABAAZGF0YTAAAAC'
      'WlpaXl5eYmJiZmZmampqbm5ucnJydnZ2enp6fn5+goKChoaGioqKjo6Okp'
      'KSlpaWmpqanp6eoqKipqamqqqqrq6usrKytra2urq6vr6+wsLCxsbGysrI=';

  /// Plays a soft "send" ping when the user sends a message.
  static Future<void> playSend() async {
    try {
      await _sendPlayer.stop();
      await _sendPlayer.setVolume(0.35);
      await _sendPlayer.play(UrlSource(_sendSoundBase64));
    } catch (_) {
      // Gracefully ignore if audio fails (e.g., autoplay policy)
    }
  }

  /// Plays a soft "receive" pop when a bot message arrives.
  static Future<void> playReceive() async {
    try {
      await _receivePlayer.stop();
      await _receivePlayer.setVolume(0.25);
      await _receivePlayer.play(UrlSource(_receiveSoundBase64));
    } catch (_) {
      // Gracefully ignore if audio fails
    }
  }

  static void dispose() {
    _sendPlayer.dispose();
    _receivePlayer.dispose();
  }
}
