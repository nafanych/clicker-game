
import 'package:flutter/material.dart';
import 'package:flutter_application_1/audio.dart';
import 'package:flutter_application_1/notify.dart';
import 'storage.dart';

class ShopPage extends StatefulWidget {
  final VoidCallback? onBuyDoubleSpeed;

  const ShopPage({super.key, this.onBuyDoubleSpeed});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  int getClickPrice() {
    int clickPower = (Storage.playerData["buffs"]["clickPower"] ?? 1) as int;
    return 50 + (clickPower - 1) * 25;
  }

  void buyDoubleSpeed() {
    if (Storage.playerData["buffs"]["doubleSpeed"]) {
      return Notify.info(context, "Улучшение уже куплено!");
    }
    if (Storage.playerData["balance"] < 200) {
      return Notify.error(context, "Недостаточно средств!");
  }

    setState(() {
      Storage.playerData["balance"] -= 200;
      Storage.playerData["buffs"]["doubleSpeed"] = true;
      Notify.success(context, "Улучшение куплено!");
      AudioManager.playSound('sounds/buyed.mp3', type: AudioType.buyed);

      widget.onBuyDoubleSpeed?.call();
    });

    Storage.savePlayerData();
  }

  void buyClickPower() {
    if (Storage.playerData["buffs"]["clickPower"] >= 50) return Notify.info(context, "Улучшение прокачано на максимум!");;

    int price = getClickPrice();

    if (Storage.playerData["balance"] < price) return Notify.error(context, "Недостаточно средств!");

    setState(() {
      Storage.playerData["balance"] -= price;
      Storage.playerData["buffs"]["clickPower"] += 1;
      Notify.success(context, "Улучшение куплено!");
      AudioManager.playSound('sounds/buyed.mp3', type: AudioType.buyed);
    });

    Storage.savePlayerData();
  }

  void buyExp() {
    if (Storage.playerData["balance"] < 100) return Notify.error(context, "Недостаточно средств!");
    
    setState(() {
      Storage.playerData["balance"] -= 100;
      Storage.playerData["exp"] += 50;
      Notify.success(context, "Улучшение куплено!");
      AudioManager.playSound('sounds/buyed.mp3', type: AudioType.buyed);
    });

    Storage.savePlayerData();
  }

  Widget shopButton(String title, String desc, int price, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                Text("$desc\nЦена: $price",
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onTap,
            child: const Text("Купить"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
        title: const Text("Магазин"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

           shopButton(
              "X2 скорость фарма",
              "Единоразовый апгрейд",
              200,
              buyDoubleSpeed,
            ),

            shopButton(
              "+1 к кликам",
              "До +50 кликов",
              getClickPrice(),
              buyClickPower,
            ),

            shopButton(
              "+50 EXP",
              "Для прокачки уровней",
              100,
              buyExp,
            ),

          ],
        ),
      ),
    );
  }
}