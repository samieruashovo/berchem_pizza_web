import 'package:flutter/widgets.dart';

class OrderQuantity extends ChangeNotifier {
  Map<String, num> orderQ = {};
  OrderQuantity(this.orderQ);

  void add(String name, int newQuantity) {
    orderQ[name] = newQuantity + 1;
    notifyListeners();
  }

  void sub(String name, int newQuantity) {
    orderQ[name] = newQuantity - 1;
    notifyListeners();
  }
}
