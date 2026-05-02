import 'package:flutter/material.dart';
import '../Pages/simple_pages/menu_page.dart';

/// ================= BACK BUTTON =================
class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
        shadows: [
          Shadow(
            offset: Offset(3, 1),
            blurRadius: 2,
          ),
        ],
      ),
      onPressed: () => Navigator.pop(context),
    );
  }
}

/// ================= MENU BUTTON =================
class CustomMenuButton extends StatelessWidget {
  const CustomMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.menu,
        color: Colors.white,
        size: 30,
        shadows: [
          Shadow(
            offset: Offset(3, 1),
            blurRadius: 2,
          ),
        ],
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MenuPage()),
        );
      },
    );
  }
}