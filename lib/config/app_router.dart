// ignore_for_file: no_duplicate_case_values

import 'package:flutter/material.dart';

import '../screens/home/about.dart';
import '../screens/home/intro/home/home_page_intro.dart';
import '../screens/login/login_screen.dart';
import '../screens/login/sign_up.dart';
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
      case UserLoginView.routeName:
        return UserLoginView.route();
      case AboutPage.routeName:
        return AboutPage.route();
      case RegisterView.routeName:
        return RegisterView.route();

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
