// ignore_for_file: no_duplicate_case_values

import 'package:berchem_pizza_web/screens/home/intro/home/home_page_intro.dart';
import 'package:flutter/material.dart';

import '../screens/screens.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    // print('Route: ${settings.name}');
    switch (settings.name) {
      case '/':
        return HomePageIntro.route();
      case HomePageIntro.routeName:
        return HomePageIntro.route();
      case HomeScreen.routeName:
        return HomeScreen.route();

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
