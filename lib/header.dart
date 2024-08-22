import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String headerTitle;

  const Header({
    super.key,
    required this.headerTitle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: const Color(0xFFF2E8DA),
        title: Text(
          headerTitle,
          style: const TextStyle(
            color: Color(0xFF646464),
            fontSize: 21,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ));
  }
}
