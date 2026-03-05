import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/storage.dart';

class Clicker extends StatefulWidget {
  const Clicker({super.key});

  @override
  State<Clicker> createState() => _ClickerState();
}

class _ClickerState extends State<Clicker> with SingleTickerProviderStateMixin {
  final List<_FloatingText> _floatingTexts = [];
  Timer? _autoClicker;
  final Random _random = Random();
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _autoClicker = Timer.periodic(const Duration(milliseconds: 700), (_) {
      _addFloatingText();
    });
  }

  @override
  void dispose() {
    _autoClicker?.cancel();
    super.dispose();
  }

  void _addFloatingText({bool isUserTap = false}) {
    final dx = (_random.nextDouble() * 200 - 100);
    final dy = (_random.nextDouble() * 100 - 10);
    final key = UniqueKey();

    final floatingText = _FloatingText(
      key: key,
      offset: Offset(dx, dy),
      onEnd: () {
        setState(() {
          _floatingTexts.removeWhere((e) => e.key == key);
        });
      },
    );

    setState(() {
      _floatingTexts.add(floatingText);

      Storage.player["balance"] += 1;
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
          // top left block (playerData) ибо я забуду
          Positioned(
            top: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Storage.account["avatar"],
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      Storage.account["username"],
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
                      Storage.player["balance"].toString().replaceAllMapped(
                        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                        (match) => '${match[1]} ',
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

          // центральный кликер (вроде)
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: () => _addFloatingText(isUserTap: true),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 50),
                    opacity: _isPressed ? 0.5 : 1.0,
                    child: Container(
                      width: 165,
                      height: 165,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
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
                            Icon(
                              Icons.mouse,
                              color: Colors.white,
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                IgnorePointer(
                  child: Stack(
                    children: _floatingTexts,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// текст
class _FloatingText extends StatefulWidget {
  final Offset offset;
  final VoidCallback onEnd;

  const _FloatingText({required Key key, required this.offset, required this.onEnd}) : super(key: key);

  @override
  State<_FloatingText> createState() => _FloatingTextState();
}

class _FloatingTextState extends State<_FloatingText> with SingleTickerProviderStateMixin {
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
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          ),
        );
      },
      child: const Text(
        "+1",
        style: TextStyle(
          color: Color.fromARGB(255, 222, 105, 240),
          fontSize: 24,
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
    );
  }
}