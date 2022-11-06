@JS()
library stripe;

import 'package:flutter/material.dart';

import 'package:js/js.dart';

import '../constants.dart';

void redirectToCheckout(BuildContext _, List<LineItem> lineItem) async {
  //ass price id, quantity on parameter
  final stripe = Stripe(apiKey);
  // List<LineItem> lineItem = [
  //   LineItem(price: nikesPriceId, quantity: 3),
  //   LineItem(price: prodPriceId, quantity: 2),
  // ];
  stripe.redirectToCheckout(CheckoutOptions(
    lineItems: lineItem,
    mode: 'payment',
    successUrl: 'http://localhost:50137/#/success',
    cancelUrl: 'http://localhost:50137/#/cancel',
  ));
}

@JS()
class Stripe {
  external Stripe(String key);

  external redirectToCheckout(CheckoutOptions options);
}

@JS()
@anonymous
class CheckoutOptions {
  external List<LineItem> get lineItems;

  external String get mode;

  external String get successUrl;

  external String get cancelUrl;

  external factory CheckoutOptions({
    List<LineItem> lineItems,
    String mode,
    String successUrl,
    String cancelUrl,
    String sessionId,
  });
}

@JS()
@anonymous
class LineItem {
  external String get price;

  external int get quantity;

  external factory LineItem({String price, int quantity});
}
