import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/audio.dart';
import 'storage.dart';
import 'shop.dart';

class Clicker extends StatefulWidget {
  const Clicker({super.key});

  @override
  State<Clicker> createState() => _ClickerState();
}

class _ClickerState extends State<Clicker>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final List<_FloatingText> _floatingTexts = [];
  Timer? _autoClicker;
  final Random _random = Random();
  bool _isPressed = false;

  void _startAutoClicker() {
    _autoClicker?.cancel();

    int baseSpeed = 700;
    int interval = Storage.playerData["buffs"]["doubleSpeed"] ?? false
        ? (baseSpeed ~/ 2)
        : baseSpeed;

    _autoClicker = Timer.periodic(Duration(milliseconds: interval), (_) {
      _addFloatingText();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _startAutoClicker();
  }

  @override
  void dispose() {
    _autoClicker?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    Storage.savePlayerData();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      Storage.savePlayerData();
    }
  }

  void _addFloatingText({bool isUserTap = false}) {
    final dx = (_random.nextDouble() * 200 - 100);
    final dy = (_random.nextDouble() * 100 - 10);
    final key = UniqueKey();

    final floatingText = _FloatingText(
      key: key,
      offset: Offset(dx, dy),
      value: Storage.playerData["buffs"]["clickPower"] ?? 1,
      onEnd: () {
        setState(() {
          _floatingTexts.removeWhere((e) => e.key == key);
        });
      },
    );

    setState(() {
      _floatingTexts.add(floatingText);

      int power = Storage.playerData["buffs"]["clickPower"] ?? 1;
      Storage.playerData["balance"] += power;
      Storage.playerData["exp"] += 1;

      Storage.savePlayerData();
    });

    if (isUserTap) {
      setState(() => _isPressed = true);
      Future.delayed(const Duration(milliseconds: 150), () {
        setState(() => _isPressed = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          // top left
          Positioned(
            top: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Storage.playerData["avatar"] ?? Icons.flash_on,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            Storage.playerData["username"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            Storage.playerData["balance"]
                                .toString()
                                .replaceAllMapped(
                                  RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                                  (m) => '${m[1]} ',
                                ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // bottom left
          Positioned(
            bottom: 20,
            left: 20,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ),
          ),

          // top right
          Positioned(
            top: 20,
            right: 20,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  AudioManager.playSound('sounds/click.mp3', type: AudioType.click);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 400),
                      pageBuilder: (_, __, ___) => const ShopPage(),
                      transitionsBuilder: (_, animation, __, child) {
                        final offset = Tween(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).animate(animation);
                        return SlideTransition(position: offset, child: child);
                      },
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.store, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        "Магазин",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // bottom right
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Статистика"),
                      Row(
                        children: [
                          Icon(
                            Icons.expand,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "${Storage.playerData["exp"]} exp",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.ads_click,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            (Storage.playerData["buffs"]["clickPower"] ?? 1).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'),(m) => '${m[1]}',
                          ) + " кликов",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // центррр
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      _addFloatingText(isUserTap: true);
                      AudioManager.playSound('sounds/click.mp3', type: AudioType.click);
                    },
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 50),
                      opacity: _isPressed ? 0.5 : 1.0,
                      child: Container(
                        width: 165,
                        height: 165,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                "click",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black54,
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Icon(Icons.mouse, color: Colors.white, size: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IgnorePointer(child: Stack(children: _floatingTexts)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// анимка (чо так много)
class _FloatingText extends StatefulWidget {
  final Offset offset;
  final VoidCallback onEnd;
  final int value;

  const _FloatingText({
    required Key key,
    required this.offset,
    required this.onEnd,
    required this.value,
  }) : super(key: key);

  @override
  State<_FloatingText> createState() => _FloatingTextState();
}

class _FloatingTextState extends State<_FloatingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<Offset>(
      begin: widget.offset,
      end: Offset(widget.offset.dx, widget.offset.dy - 60),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 1, end: 0).animate(_controller);

    _controller.forward().whenComplete(() {
      widget.onEnd();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.translate(
          offset: _animation.value,
          child: Opacity(opacity: _fadeAnimation.value, child: child),
        );
      },
      child: Text(
        "+${widget.value}",
        style: TextStyle(
          color: Color.fromARGB(255, 222, 105, 240),
          fontSize: 24,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 2),
          ],
        ),
      ),
    );
  }
}
