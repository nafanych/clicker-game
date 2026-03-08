import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Map<String, dynamic> playerData = {
    "username": "",
    "avatar": Icons.flash_on,
    "balance": 0,
    "location": 1,
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

  static void loginSetData(String name, IconData avt) {
    playerData["username"] = name;
    playerData["avatar"] = avt;
  }

  static Future<void> savePlayerData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt("balance", playerData["balance"]);
    await prefs.setInt("location", playerData["location"]);
    await prefs.setInt("exp", playerData["exp"]);

    await prefs.setInt("clickPower", playerData["buffs"]["clickPower"]);
    await prefs.setBool("doubleSpeed", playerData["buffs"]["doubleSpeed"]);

    await prefs.setBool("music", playerData["settings"]["music"]);
    await prefs.setBool("soundClick", playerData["settings"]["soundClick"]);
    await prefs.setBool("soundBuyed", playerData["settings"]["soundBuyed"]);
  }

  static Future<void> loadPlayerData() async {
    final prefs = await SharedPreferences.getInstance();

    playerData["balance"] = prefs.getInt("balance") ?? 0;
    playerData["location"] = prefs.getInt("location") ?? 0;
    playerData["exp"] = prefs.getInt("exp") ?? 0;

    playerData["buffs"]["clickPower"] = prefs.getInt("clickPower") ?? 1;
    playerData["buffs"]["doubleSpeed"] = prefs.getBool("doubleSpeed") ?? false;

    playerData["settings"]["music"] = prefs.getBool("music") ?? true;
    playerData["settings"]["soundClick"] = prefs.getBool("soundClick") ?? true;
    playerData["settings"]["soundBuyed"] = prefs.getBool("soundBuyed") ?? true;
  }
}