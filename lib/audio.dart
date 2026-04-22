import 'package:audioplayers/audioplayers.dart';
import 'storage.dart';

enum AudioType { click, buyed }

class AudioManager {
  static AudioPlayer? _bgMusicPlayer;
  
  static final Map<String, AudioPool> _pools = {};

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

    if (!_pools.containsKey(assetPath)) {
      _pools[assetPath] = await AudioPool.createFromAsset(
        path: assetPath,
        maxPlayers: 5,
      );
    }

    await _pools[assetPath]!.start();
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
    await _bgMusicPlayer?.dispose();
    _bgMusicPlayer = null;
  }
}