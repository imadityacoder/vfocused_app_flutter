import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final _player = AudioPlayer();

  static Future<void> playCycleCompleteSound() async {
    await _player.play(AssetSource('sounds/ding1.mp3'));
  }

  static Future<void> playCycleBreakSound() async {
    await _player.play(AssetSource('sounds/ding2.mp3'));
  }
}
