import 'dart:convert';

import 'package:flutter/widgets.dart';

class ExtraToppings extends ChangeNotifier {
  Map<String, String> extraTopping = {};
  String extraTop = "";
  ExtraToppings(this.extraTopping);

  void add(String name, String topping) {
    extraTopping.addAll({name: topping});
    extraTop = json.encode(extraTopping);
    notifyListeners();
  }

  void remove(String name, String topping) {
    // extraTopping[name]!.remove(topping);
    notifyListeners();
  }
}
