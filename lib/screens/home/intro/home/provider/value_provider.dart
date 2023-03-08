import 'package:flutter/widgets.dart';

class PriceState extends ChangeNotifier {
  double price = 0;

  PriceState(this.price);
  void addPrice(newVal) {
    price += newVal;
    notifyListeners();
  }

  void subPrice(newVal) {
    price -= newVal;
    notifyListeners();
  }

  // void addQuantity(int newQuantity) {
  //   quantity += newQuantity;
  //   notifyListeners();
  // }

  // void subQuantity(int newQuantity) {
  //   quantity -= newQuantity;
  //   notifyListeners();
  // }
}
