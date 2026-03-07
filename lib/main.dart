import 'package:flutter/material.dart';
import 'package:flutter_application_1/storage.dart';
import 'package:flutter_application_1/audio.dart';
import 'auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Storage.loadPlayerData();

  AudioManager.playBackgroundMusic('sounds/music.mp3');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const AuthPage(),
    );
  }
}