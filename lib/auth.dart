import 'package:flutter/material.dart';
import 'package:flutter_application_1/storage.dart';
import 'clicker.dart'; // импортируем новый экран

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _usernameController = TextEditingController();
  IconData _selectedAvatar = Icons.flash_on;

  void _login() {
    final username = _usernameController.text.trim();

    if (username.isNotEmpty) {
      Storage.authSaveData(username, _selectedAvatar);

      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => const Clicker(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero);
            final fadeTween = Tween<double>(begin: 0, end: 1);
            return SlideTransition(
              position: tween.animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
              child: FadeTransition(
                opacity: fadeTween.animate(animation),
                child: child,
              ),
            );
          },
        ),
      );
    }
  }

  Widget _avatarOption(IconData icon) {
    final bool isSelected = _selectedAvatar == icon;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAvatar = icon;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(28),
            constraints: const BoxConstraints(maxWidth: 420),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 35,
                        height: 35,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Too Young to Die",
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Перед началом игры необходимо ввести игровой ник",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Rubik',
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  "Выберите аватар",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Rubik',
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _avatarOption(Icons.flash_on),
                    const SizedBox(width: 12),
                    _avatarOption(Icons.tag_faces),
                    const SizedBox(width: 12),
                    _avatarOption(Icons.dangerous),
                  ],
                ),
                const SizedBox(height: 28),
                TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: Colors.white),
                  cursorHeight: 15,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: "...",
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2A2A2A),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Играть",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Rubik',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}