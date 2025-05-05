import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icon/app_icon.png', height: 40),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      elevation: 1,
    );
  }
}