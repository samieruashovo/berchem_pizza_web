import 'package:flutter/widgets.dart';

class QuanityState extends ChangeNotifier {
  int quantity = 0;
  QuanityState(this.quantity);

  void addQuantity(int newQuantity) {
    quantity += newQuantity;
    notifyListeners();
  }

  void subQuantity(int newQuantity) {
    quantity -= newQuantity;
    notifyListeners();
  }
}
