import 'package:flutter/material.dart';
import 'storage.dart';
import 'audio.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool music;
  late bool soundClick;
  late bool soundBuyed;

  @override
  void initState() {
    super.initState();
    music = Storage.playerData["settings"]["music"] ?? true;
    soundClick = Storage.playerData["settings"]["soundClick"] ?? true;
    soundBuyed = Storage.playerData["settings"]["soundBuyed"] ?? true;
  }

  void _updateSettings() {
    Storage.playerData["settings"]["music"] = music;
    Storage.playerData["settings"]["soundClick"] = soundClick;
    Storage.playerData["settings"]["soundBuyed"] = soundBuyed;

    Storage.savePlayerData();

    if (music) {
      AudioManager.playBackgroundMusic('sounds/music.mp3');
    } else {
      AudioManager.stopBackgroundMusic();
    }
  }

  Future<void> _resetProgress() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Сброс прогресса"),
        content: const Text("Вы уверены что хотите сбросить весь прогресс?"),
        actions: [
          TextButton(
            child: const Text("Отмена"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text("Подтвердить"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      String un = Storage.playerData["username"];
      IconData ic = Storage.playerData["avatar"];

      Storage.playerData = {
        "username": un,
        "avatar": ic,
        "balance": 0,
        "exp": 0,
        "buffs": {
          "clickPower": 1,
          "doubleSpeed": false,
        },
        "settings": {
          "music": true,
          "soundClick": true,
          "soundBuyed": true,
        }
      };
      await Storage.savePlayerData();
      setState(() {
        music = true;
        soundClick = true;
        soundBuyed = true;
      });

      if (music) {
        AudioManager.playBackgroundMusic('sounds/music.mp3');
      } else {
        AudioManager.stopBackgroundMusic();
      }
    }
  }

  void _showAuthorInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Об авторе"),
        content: const Text("Игра создана by ковалев & потапов РПО 5"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Закрыть"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (soundClick) {
          AudioManager.playSound('sounds/click.mp3', type: AudioType.click);
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 37, 37, 37),
          title: const Text("Настройки"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (soundClick) {
                AudioManager.playSound('sounds/click.mp3', type: AudioType.click);
              }
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text("Музыка", style: TextStyle(color: Colors.white)),
                value: music,
                onChanged: (val) => setState(() {
                  music = val;
                  _updateSettings();
                }),
              ),
              SwitchListTile(
                title: const Text("Звук клика", style: TextStyle(color: Colors.white)),
                value: soundClick,
                onChanged: (val) => setState(() {
                  soundClick = val;
                  _updateSettings();
                }),
              ),
              SwitchListTile(
                title: const Text("Звук покупки", style: TextStyle(color: Colors.white)),
                value: soundBuyed,
                onChanged: (val) => setState(() {
                  soundBuyed = val;
                  _updateSettings();
                }),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetProgress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 67, 67, 67),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text("Сбросить прогресс"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _showAuthorInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 45, 45, 45),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text("Об авторе"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}