
import 'package:flutter/material.dart';

class Storage {
  static Map<String, dynamic> account = {
    "username": "",
    "avatar": Icons.flash_on
  };

  static Map<String, dynamic> player = {
    "balance": 950,
    "location": 1,
  };

  static void authSaveData(String name, IconData avt) {
    account["username"] = name;
    account["avatar"] = avt;

    print("${account["username"]}, ${account["avatar"]}");
  }
}