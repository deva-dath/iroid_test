import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(93, 167, 163, 1),
      title: Text(
        title,
        style: TextStyle(
            color: Colors.white,
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
            fontSize: 26),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          color: Colors.white,
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // Add notification action here
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
