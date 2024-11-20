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
        backgroundColor: Colors.white,
        titleSpacing: -10.0,
        title: Text(
          headerTitle,
          style: const TextStyle(
            color: Color(0xFF646464),
            fontSize: 15,
          ),
        ),
        leading: SizedBox(
          width: 20,
          height: 20,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ));
  }
}
