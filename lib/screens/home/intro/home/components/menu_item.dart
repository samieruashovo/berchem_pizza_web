import 'package:flutter/material.dart';


class MenuItemp extends StatelessWidget {
  final String title;
  final Function()? press;
  const MenuItemp({
    super.key,
    required this.title,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
