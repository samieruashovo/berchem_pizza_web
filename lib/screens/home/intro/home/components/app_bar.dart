// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:berchem_pizza_web/screens/home/home_screen.dart';
import 'package:berchem_pizza_web/screens/home/intro/home/components/menu_item.dart';
import 'package:berchem_pizza_web/screens/login/login_screen.dart';

import '../../../default_button.dart';

class MyAppBar extends StatefulWidget {
  MyAppBar({
    Key? key,
  }) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(46),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 30,
            color: Colors.black.withOpacity(0.16),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Image.asset(
            "assets/images/logo.png",
            height: 25,
            alignment: Alignment.topCenter,
          ),
          const SizedBox(width: 5),
          Text(
            "Berchem Pizza".toUpperCase(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          DefaultButtonp(
            text: "Menu",
            press: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
          MenuItemp(
            title: "about",
            press: () {},
          ),
          MenuItemp(
            title: "Login",
            press: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UserLoginView()));
            },
          ),
        ],
      ),
    );
  }
}
