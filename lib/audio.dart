import 'package:audioplayers/audioplayers.dart';
import 'storage.dart';

enum AudioType { click, buyed }

class AudioManager {
  static AudioPlayer? _bgMusicPlayer;

  static Future<void> playSound(String assetPath, {AudioType type = AudioType.click}) async {
    bool isEnabled = false;
    switch (type) {
      case AudioType.click:
        isEnabled = Storage.playerData["settings"]["soundClick"] ?? true;
        break;
      case AudioType.buyed:
        isEnabled = Storage.playerData["settings"]["soundBuyed"] ?? true;
        break;
    }

    if (!isEnabled) return;

    final player = AudioPlayer();
    await player.setReleaseMode(ReleaseMode.stop);
    await player.play(AssetSource(assetPath));
    player.onPlayerComplete.listen((_) {
      player.dispose();
    });
  }

  static Future<void> playBackgroundMusic(String assetPath) async {
    bool isMusicEnabled = Storage.playerData["settings"]["music"] ?? true;
    if (!isMusicEnabled) return;

    if (_bgMusicPlayer == null) {
      _bgMusicPlayer = AudioPlayer();
      await _bgMusicPlayer!.setReleaseMode(ReleaseMode.loop);
      await _bgMusicPlayer!.setVolume(0.2);
      await _bgMusicPlayer!.play(AssetSource(assetPath));
    }
  }

  static Future<void> stopBackgroundMusic() async {
    await _bgMusicPlayer?.stop();
    _bgMusicPlayer?.dispose();
    _bgMusicPlayer = null;
  }
}