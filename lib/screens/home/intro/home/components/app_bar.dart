// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:berchem_pizza_web/languages/language_constants.dart';
import 'package:berchem_pizza_web/screens/home/about.dart';
import 'package:flutter/material.dart';

import 'package:berchem_pizza_web/screens/home/home_screen.dart';
import 'package:berchem_pizza_web/screens/home/intro/home/components/menu_item.dart';
import 'package:berchem_pizza_web/screens/login/login_screen.dart';

import '../../../../../languages/language.dart';
import '../../../../../main.dart';
import '../../../default_button.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({
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
            translation(context).berchemPizzaText.toUpperCase(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          DefaultButtonp(
            text: translation(context).homeText,
            press: () {
              Navigator.of(context).pushNamed(HomeScreen.routeName);
            },
          ),
          MenuItemp(
            title: translation(context).aboutText,
            press: () {
              Navigator.of(context).pushNamed(AboutPage.routeName);
            },
          ),
          MenuItemp(
            title: translation(context).loginText,
            press: () {
              Navigator.of(context).pushNamed(UserLoginView.routeName);
            },
          ),
          DropdownButton<Language>(
            isDense: true,
            underline: const SizedBox.shrink(),
            icon: const Icon(
              Icons.language,
              color: Colors.black,
            ),
            onChanged: (Language? language) async {
              if (language != null) {
                Locale locale = await setLocale(language.languageCode);
                MyApp.setLocale(context, locale);
              }
            },
            items: Language.languageList()
                .map<DropdownMenuItem<Language>>(
                  (e) => DropdownMenuItem<Language>(
                    value: e,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          e.flag,
                          style: const TextStyle(fontSize: 30),
                        ),
                        Text(e.name)
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
