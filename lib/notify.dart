
import 'package:flutter/material.dart';

class Notify {
  static void success(BuildContext context, String text) {
    _show(context, text, const Color.fromARGB(255, 3, 168, 72));
  }

  static void error(BuildContext context, String text) {
    _show(context, text, const Color.fromARGB(255, 209, 31, 11));
  }

  static void info(BuildContext context, String text) {
    _show(context, text, const Color.fromARGB(255, 190, 216, 19));
  }

  static void _show(BuildContext context, String text, Color color) {
    final overlay = Overlay.of(context);

    final entry = OverlayEntry(
      builder: (context) => _NotifyWidget(
        text: text,
        color: color,
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 2), () {
      entry.remove();
    });
  }
}

class _NotifyWidget extends StatefulWidget {
  final String text;
  final Color color;

  const _NotifyWidget({
    required this.text,
    required this.color,
  });

  @override
  State<_NotifyWidget> createState() => _NotifyWidgetState();
}

class _NotifyWidgetState extends State<_NotifyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> slide;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    slide = Tween(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    controller.forward();

    Future.delayed(const Duration(milliseconds: 1700), () {
      controller.reverse();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: SlideTransition(
        position: slide,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black54, blurRadius: 8)
              ],
            ),
            child: Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}