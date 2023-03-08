import 'package:flutter/material.dart';

import '../../languages/language_constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  static const String routeName = 'about';

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => const AboutPage(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Container(
            color: Colors.white,
            height: 80,
            child: Center(
                child: Text(
              translation(context).berchemPizzaText,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
          ),
          Container(
            color: Colors.grey[300],
            height: 60,
            child: const Center(
                child: Text(
              "ABOUT US",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            )),
          ),
          RichText(
            text: const TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text:
                        "Berchem Pizza is a Belgium based restaurant that is home to your favorite foods, Pizzas and much more.\n",
                    style: TextStyle(fontSize: 15)),
                TextSpan(
                    text: "The restairent had started their journy in 2022.\n",
                    style: TextStyle(fontSize: 15)),
                //contact information
              ],
            ),
          )
        ],
      ),
    );
  }
}
