import 'package:flutter/material.dart';

import 'components/app_bar.dart';
import 'components/body.dart';

class HomePageIntro extends StatefulWidget {
  static const String routeName = '//';

  const HomePageIntro({super.key});
  static Route route() {
    return MaterialPageRoute(
      builder: (_) => const HomePageIntro(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  State<HomePageIntro> createState() => _HomePageIntroState();
}

class _HomePageIntroState extends State<HomePageIntro> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width  of our screen
    return Scaffold(
      body: Container(
        height: size.height,
        // it will take full width
        width: size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            MyAppBar(),
            Spacer(),
            // It will cover 1/3 of free spaces
            Body(),
            Spacer(
              flex: 2,
            ),
            // it will cover 2/3 of free spaces
          ],
        ),
      ),
    );
  }
}
