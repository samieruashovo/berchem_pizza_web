// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously, prefer_final_fields, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:berchem_pizza_web/screens/home/intro/cons.dart' as c;
import 'package:berchem_pizza_web/screens/home/intro/home/provider/order_provider.dart';
import 'package:berchem_pizza_web/screens/home/search/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:berchem_pizza_web/models/product_model.dart';
import 'package:berchem_pizza_web/screens/home/intro/home/components/app_bar.dart';
import 'package:berchem_pizza_web/screens/home/intro/home/provider/quanity_provider.dart';
import 'package:berchem_pizza_web/screens/home/intro/prod.dart';

import '../../models/order_model.dart';
import '../../onlinePayment/checkout/stripe_checkout_web.dart';
import '../../onlinePayment/constants.dart';
import '../widgets/custom_textfield.dart';
import 'intro/home/provider/value_provider.dart';

List basketProd = [];
double price = 0;
Map<String, int> orderM = {};
List<LineItem> setLineItems = [];
Map<String, int> mapPriceId = {};
int quantity = 0;

class HomeScreen extends StatefulWidget {
  static const String routeName = '//';

  const HomeScreen({super.key});
  static Route route() {
    return MaterialPageRoute(
      builder: (_) => const HomeScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController search = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _roadController = TextEditingController();
  TextEditingController _apartmentController = TextEditingController();
  TextEditingController _moreInfoController = TextEditingController();
  TextEditingController _customerNameController = TextEditingController();
  TextEditingController _numberInfoController = TextEditingController();
  var userSnap;
  final List _producs = [];
  fetchProducts() async {
    QuerySnapshot qn =
        await FirebaseFirestore.instance.collection("products").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _producs.add({
          "name": qn.docs[i]["name"],
          "category": qn.docs[i]["category"],
          "price": qn.docs[i]["price"],
          "imageUrl": qn.docs[i]["imageUrl"],
          "description": qn.docs[i]["description"],
          "id": qn.docs[i]["id"],
        });
      }
    });
    return qn.docs;
  }

  @override
  void initState() {
    fetchProducts();
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var usersnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    setState(() {
      userSnap = usersnap;
    });
  }

  _buildCategories(context, imageLink, onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        height: 120,
        width: 120,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: c.kPrimaryColor,
            image: DecorationImage(image: AssetImage(imageLink))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prodStream = FirebaseFirestore.instance
        .collection('products')
        .where(
          'name',
          isGreaterThanOrEqualTo: search.text,
        )
        .snapshots();
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<PriceState>(
              create: (context) => PriceState(0)),
          ChangeNotifierProvider<QuanityState>(
              create: (context) => QuanityState(0)),
          ChangeNotifierProvider<OrderQuantity>(
              create: (context) => OrderQuantity(orderM)),
        ],
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyAppBar(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      _buildCategories(
                                          context, "assets/pizza.png", () {}),
                                      _buildCategories(
                                          context, "assets/juice.png", () {}),
                                      _buildCategories(
                                          context, "assets/burger.png", () {}),
                                    ],
                                  ),
                                  Container(
                                    height: 100,
                                    width: 500,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[700],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: const EdgeInsets.only(
                                        left: 40,
                                        right: 40,
                                        top: 20,
                                        bottom: 10),
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Search your favourite food",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          width: 200,
                                          height: 30,
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: TextField(
                                            cursorColor: Colors.black,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                icon:
                                                    Icon(Icons.search_outlined),
                                                hintText: "Type something"),
                                            controller: search,
                                            onChanged: (val) {
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Items available',
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                ),
                              ),
                              StreamBuilder(
                                  stream: prodStream,
                                  builder: (context,
                                      AsyncSnapshot<
                                              QuerySnapshot<
                                                  Map<String, dynamic>>>
                                          snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else {
                                      return GridView.builder(
                                          shrinkWrap: true,
                                          itemCount: snapshot.data!.docs.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 1,
                                            crossAxisSpacing: 1,
                                          ),
                                          itemBuilder: (_, index) {
                                            Provider.of<PriceState>(context,
                                                    listen: false)
                                                .price;
                                            Provider.of<QuanityState>(context,
                                                    listen: false)
                                                .quantity;
                                            return Prod(
                                              addToCart: () {
                                                addToBasket(
                                                  _producs[index]["id"],
                                                  _producs[index]["name"],
                                                  _producs[index]["category"],
                                                  _producs[index]
                                                      ["description"],
                                                  _producs[index]["imageUrl"],
                                                  _producs[index]["price"],
                                                );
                                                // setState(() {
                                                double tempPrice = 0;
                                                tempPrice = double.parse(
                                                    _producs[index]["price"]);
                                                //print(price);
                                                // print(
                                                //     "temp " + tempPrice.toString());
                                                Provider.of<PriceState>(context,
                                                        listen: false)
                                                    .addPrice(tempPrice);
                                                Provider.of<QuanityState>(
                                                        context,
                                                        listen: false)
                                                    .addQuantity(1);

                                                // price += tempPrice;
                                                // quantity += 1;
                                                if (orderM[_producs[index]
                                                        ["name"]] ==
                                                    null) {
                                                  orderM[_producs[index]
                                                      ["name"]] = 0;
                                                }
                                                orderM[_producs[index]
                                                    ["name"]] = orderM[
                                                        _producs[index]
                                                            ["name"]]! +
                                                    1;

                                                // setLineItems.add(LineItem(
                                                //     price: prodPriceId,
                                                //     quantity: quantity));
                                                mapPriceId[prodPriceId] =
                                                    orderM[_producs[index]
                                                        ["name"]]!;
                                                print(mapPriceId);

                                                print(orderM);
                                                //  } );
                                              },
                                              removeFromCart: () {
                                                //setState(() {
                                                if (orderM[_producs[index]
                                                        ["name"]]! >=
                                                    1) {
                                                  double tempPrice =
                                                      double.parse(
                                                          _producs[index]
                                                              ["price"]);
                                                  Provider.of<PriceState>(
                                                          context,
                                                          listen: false)
                                                      .subPrice(tempPrice);
                                                  //price -= tempPrice;

                                                  orderM[_producs[index]
                                                      ["name"]] = orderM[
                                                          _producs[index]
                                                              ["name"]]! -
                                                      1;
                                                  Provider.of<QuanityState>(
                                                          context,
                                                          listen: false)
                                                      .subQuantity(1);
                                                  // quantity -= 1;
                                                  // print(mapPriceId);

                                                  //print(orderM);
                                                } else {
                                                  // print("not in the cart");
                                                }
                                                //});
                                              },
                                              imageLink: snapshot
                                                  .data!
                                                  .docChanges[index]
                                                  .doc['imageUrl'],
                                              productTitle: snapshot
                                                  .data!
                                                  .docChanges[index]
                                                  .doc['name'],
                                              productDesc: snapshot
                                                  .data!
                                                  .docChanges[index]
                                                  .doc['description'],
                                              prodPrice: snapshot
                                                  .data!
                                                  .docChanges[index]
                                                  .doc['price'],
                                            );
                                          });
                                    }
                                  })
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
                //margin: const EdgeInsets.only(top: 40),
                width: MediaQuery.of(context).size.width * 0.23,
                height: MediaQuery.of(context).size.height * 0.96,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: LeftBasketScreeen(
                  cityController: _cityController,
                  roadController: _roadController,
                  apartmentController: _apartmentController,
                  moreInfoController: _moreInfoController,
                  customerNameController: _customerNameController,
                  numberInfoController: _numberInfoController,
                )),
          ],
        ),
      ),
    );
  }
}

class LeftBasketScreeen extends StatelessWidget {
  final TextEditingController cityController;
  final TextEditingController roadController;
  final TextEditingController apartmentController;
  final TextEditingController moreInfoController;
  final TextEditingController customerNameController;
  final TextEditingController numberInfoController;

  const LeftBasketScreeen(
      {super.key,
      required this.cityController,
      required this.roadController,
      required this.apartmentController,
      required this.moreInfoController,
      required this.customerNameController,
      required this.numberInfoController});

  @override
  Widget build(BuildContext context) {
    final newPrice = Provider.of<PriceState>(context).price;
    final newQuantity = Provider.of<QuanityState>(context).quantity;
    final orderQ = Provider.of<OrderQuantity>(context).orderQ;
    List showToBasket = [];
    orderQ.forEach(((key, value) =>
        showToBasket.add(basket(key: key, quantity: value.toInt()))));
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: const [
              Text(
                "Your Cart",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Divider(),
            ],
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: showToBasket.length,
                  itemBuilder: ((context, index) {
                    var name = showToBasket[index];
                    //print(name.key);
                    return Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        //style: ,
                        title: Text("Item: " + name.key),
                        subtitle: Text(
                          "Quantity: " + name.quantity.toString(),
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                        ),
                        // trailing: Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     IconButton(
                        //         onPressed: () {},
                        //         icon: const Icon(
                        //           Icons.add,
                        //           color: Colors.green,
                        //         )),
                        //     IconButton(
                        //         onPressed: () {
                        //           if (orderM[products[index]["name"]]! >= 1) {
                        //             double tempPrice =
                        //                 double.parse(products[index]["price"]);
                        //             Provider.of<PriceState>(context,
                        //                     listen: false)
                        //                 .subPrice(tempPrice);
                        //             //price -= tempPrice;

                        //             orderM[products[index]["name"]] =
                        //                 orderM[products[index]["name"]]! - 1;
                        //             Provider.of<OrderQuantity>(context,
                        //                     listen: false)
                        //                 .add(products[index]["name"], 1);
                        //             Provider.of<QuanityState>(context,
                        //                     listen: false)
                        //                 .subQuantity(1);
                        //             // quantity -= 1;
                        //             print(price);
                        //           } else {
                        //             print("not in the cart");
                        //           }
                        //         },
                        //         icon: const Icon(
                        //           Icons.add,
                        //           color: Colors.red,
                        //         ))
                        //   ],
                        // ),
                      ),
                    );
                  })),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "No of Items: ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    "$newQuantity",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Total: ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    newPrice.toStringAsFixed(2) + " €",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                      onPressed: () {
                        showAddressUpdateDialog(
                            context,
                            cityController,
                            roadController,
                            apartmentController,
                            moreInfoController,
                            customerNameController,
                            numberInfoController,
                            "Cash on Delivery");
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: c.kPrimaryColor,
                          textStyle: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      child: const Text("Cash on Delivery"))),
              Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                      onPressed: () {
                        print(json.encode(orderM));

                        // showAddressUpdateDialog(
                        //     context,
                        //     _cityController,
                        //     _roadController,
                        //     _apartmentController,
                        //     _moreInfoController,
                        //     _customerNameController,
                        //     _numberInfoController,
                        //     "paid online");
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: c.kPrimaryColor,
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                      child: const Text(
                        "Pay online",
                        // style: TextStyle(color: Colors.black),
                      ))),
            ],
          ),
          // const Divider(),
        ],
      ),
      // width: MediaQuery.of(context).size.width * 0.10,
    );
  }
}

class basket {
  String key;
  int quantity;
  basket({
    required this.key,
    required this.quantity,
  });
}

addToBasket(String id, String name, String category, String description,
    String imageUrl, String price) {
  basketProd.add(Product(
      id: id,
      name: name,
      category: category,
      description: description,
      imageUrl: imageUrl,
      price: price));
}

Future<void> _uploadOrder(
    String name,
    String city,
    String road,
    String apartment,
    String moreInfo,
    String customerName,
    String mobileNumber,
    String paymentType) async {
  String _postId = const Uuid().v1();
  try {
    OrderMod orderMod = OrderMod(
      name: name,
      orderId: _postId,
      city: city,
      road: road,
      apartment: apartment,
      optional: moreInfo,
      customerName: customerName,
      mobileNumber: mobileNumber,
      paymentType: paymentType,
    );
    FirebaseFirestore.instance
        .collection('orders')
        .doc(_postId)
        .set(orderMod.toJson());
  } catch (e) {}
}
//remove from cart
/*onPressed: () {
                                                      setState(() {
                                                        if (orderM[_producs[
                                                                    index]
                                                                ["name"]]! >=
                                                            1) {
                                                          double tempPrice =
                                                              double.parse(
                                                                  _producs[
                                                                          index]
                                                                      [
                                                                      "price"]);

                                                          price -= tempPrice;

                                                          orderM[_producs[index]
                                                                  ["name"]] =
                                                              orderM[_producs[
                                                                          index]
                                                                      [
                                                                      "name"]]! -
                                                                  1;
                                                          quantity -= 1;
                                                          print(price);
                                                        } else {
                                                          print(
                                                              "not in the cart");
                                                        }
                                                      });
                                                    },*/

showOrderConfirmationDialog(
  BuildContext context,
) {
  Widget okButton = ElevatedButton(
    style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
    onPressed: () {
      Navigator.of(context).pop();
    },
    child: const Text(
      "Okay",
      style: TextStyle(color: Colors.white),
    ),
  );
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text(
      "Your order",
      style: TextStyle(fontSize: 15),
    ),
    content: const Text("Your order has been recorded"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAddressUpdateDialog(
    BuildContext context,
    TextEditingController _cityController,
    TextEditingController _roadController,
    TextEditingController _apartmentController,
    TextEditingController _moreInfoController,
    TextEditingController _numberInfoController,
    TextEditingController _customerNameController,
    paymentType) {
  // Create button

  Widget okButton = ElevatedButton(
    style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
    onPressed: () async {
      await _uploadOrder(
          json.encode(orderM),
          _cityController.text,
          _roadController.text,
          _apartmentController.text,
          _moreInfoController.text,
          _customerNameController.text,
          _numberInfoController.text,
          paymentType);

      mapPriceId.forEach((key, value) =>
          setLineItems.add(LineItem(price: key, quantity: value)));

      if (paymentType == "paid online") {
        redirectToCheckout(context, setLineItems);
      } else {
        Navigator.pop(context);
        showOrderConfirmationDialog(context);
      }
    },
    child: const Text(
      "Proceed",
      style: TextStyle(color: Colors.white),
    ),
  );
  Widget cancelButton = ElevatedButton(
    style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
    onPressed: () {
      Navigator.of(context).pop();
    },
    child: const Text(
      "Cancel",
      style: TextStyle(color: Colors.white),
    ),
  );
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text(
      "Tell us how can we find you",
      style: TextStyle(fontSize: 15),
    ),
    content: Column(
      children: [
        CustomTextField(
            controller: _cityController,
            borderradius: 20,
            bordercolor: Colors.grey[300]!,
            widh: 0.32,
            height: 0.05,
            //icon: Icons.money,
            iconColor: Colors.grey,
            hinttext: 'Enter your city',
            hintColor: Colors.black,
            fontsize: 15,
            obscureText: false),
        const SizedBox(
          height: 3,
        ),
        CustomTextField(
            controller: _roadController,
            borderradius: 20,
            bordercolor: Colors.grey[300]!,
            widh: 0.32,
            height: 0.05,
            //icon: Icons.money,
            iconColor: Colors.grey,
            hinttext: 'Enter road no.',
            hintColor: Colors.black,
            fontsize: 15,
            obscureText: false),
        const SizedBox(
          height: 3,
        ),
        CustomTextField(
            controller: _apartmentController,
            borderradius: 20,
            bordercolor: Colors.grey[300]!,
            widh: 0.32,
            height: 0.05,
            // icon: Icons.money,
            iconColor: Colors.grey,
            hinttext: 'Enter your apartment',
            hintColor: Colors.black,
            fontsize: 15,
            obscureText: false),
        const SizedBox(
          height: 3,
        ),
        CustomTextField(
            controller: _moreInfoController,
            borderradius: 20,
            bordercolor: Colors.grey[300]!,
            widh: 0.32,
            height: 0.05,
            //icon: Icons.money,
            iconColor: Colors.grey,
            hinttext: 'Tell us more about your location',
            hintColor: Colors.black,
            fontsize: 15,
            obscureText: false),
        const SizedBox(
          height: 3,
        ),
        CustomTextField(
            controller: _customerNameController,
            borderradius: 20,
            bordercolor: Colors.grey[300]!,
            widh: 0.32,
            height: 0.05,
            //icon: Icons.money,
            iconColor: Colors.grey,
            hinttext: 'Your name',
            hintColor: Colors.black,
            fontsize: 15,
            obscureText: false),
        const SizedBox(
          height: 3,
        ),
        CustomTextField(
            controller: _numberInfoController,
            borderradius: 20,
            bordercolor: Colors.grey[300]!,
            widh: 0.32,
            height: 0.05,
            // icon: Icons.money,
            iconColor: Colors.grey,
            hinttext: 'Enter your number',
            hintColor: Colors.black,
            fontsize: 15,
            obscureText: false),
      ],
    ),
    actions: [
      cancelButton,
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
