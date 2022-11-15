// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_import, empty_catches
// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously, prefer_final_fields, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../constants.dart';
import '../../constants.dart';
import '../../models/order_model.dart';
import '../../models/product_model.dart';
import '../../onlinePayment/checkout/stripe_checkout_web.dart';
import '../../onlinePayment/constants.dart';
import '../widgets/custom_textfield.dart';
import 'intro/home/components/app_bar.dart';
import 'intro/home/provider/extra_topings_provider.dart';
import 'intro/home/provider/order_provider.dart';
import 'intro/home/provider/quanity_provider.dart';
import 'intro/home/provider/value_provider.dart';
import 'intro/prod.dart';

List basketProd = [];
double price = 0;
Map<String, int> orderM = {};
Map<String, String> extraToppings = {};
int extraToppingsQuantity = 0;
String extraT = '';
List<LineItem> setLineItems = [];
Map<String, int> mapPriceId = {};
int quantity = 0;

class Topings {
  final int id;
  final String name;

  Topings({
    required this.id,
    required this.name,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = 'menu';

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

  @override
  void initState() {
    getUserInfo();
    // print("eee");
    getdata();
    super.initState();
  }

  getdata() async {
    try {
      FirebaseFirestore.instance
          .collection('products')
          .where(
            'name',
            isGreaterThanOrEqualTo: search.text,
          )
          .snapshots();
    } catch (e) {
      // print(e.toString());
    }
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
            color: kPrimaryColor,
            image: DecorationImage(image: AssetImage(imageLink))),
      ),
    );
  }

  static final List<Topings> _topings = [
    Topings(id: 1, name: "Lion"),
    Topings(id: 2, name: "Flamingo"),
    Topings(id: 3, name: "Hippo"),
    Topings(id: 4, name: "Horse"),
    Topings(id: 5, name: "Tiger"),
    Topings(id: 6, name: "Penguin"),
  ];
  final _items = _topings
      .map((topings) => MultiSelectItem<String>(topings.name, topings.name))
      .toList();
  List _selectedToppings = [];

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
          ChangeNotifierProvider<ExtraToppings>(
              create: (context) => ExtraToppings(extraToppings)),
        ],
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MyAppBar(),
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
                                        const Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(
                                            "Search your favourite food",
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
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
                                          child: Center(
                                            child: TextField(
                                              cursorColor: Colors.black,
                                              decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  icon: Icon(
                                                      Icons.search_outlined),
                                                  hintText:
                                                      "Type something..."),
                                              controller: search,
                                              onChanged: (val) {
                                                setState(() {});
                                              },
                                            ),
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
                                                  snapshot
                                                      .data!
                                                      .docChanges[index]
                                                      .doc['id'],
                                                  snapshot
                                                      .data!
                                                      .docChanges[index]
                                                      .doc['name'],
                                                  snapshot
                                                      .data!
                                                      .docChanges[index]
                                                      .doc['category'],
                                                  snapshot
                                                      .data!
                                                      .docChanges[index]
                                                      .doc['description'],
                                                  snapshot
                                                      .data!
                                                      .docChanges[index]
                                                      .doc['imageUrl'],
                                                  snapshot
                                                      .data!
                                                      .docChanges[index]
                                                      .doc['price'],
                                                );

                                                double tempPrice = 0;
                                                tempPrice = double.parse(
                                                    snapshot
                                                        .data!
                                                        .docChanges[index]
                                                        .doc['price']);

                                                Provider.of<PriceState>(context,
                                                        listen: false)
                                                    .addPrice(tempPrice);
                                                Provider.of<QuanityState>(
                                                        context,
                                                        listen: false)
                                                    .addQuantity(1);

                                                if (orderM[snapshot
                                                        .data!
                                                        .docChanges[index]
                                                        .doc['name']] ==
                                                    null) {
                                                  orderM[snapshot
                                                      .data!
                                                      .docChanges[index]
                                                      .doc['name']] = 0;
                                                }
                                                //quantity
                                                orderM[snapshot
                                                    .data!
                                                    .docChanges[index]
                                                    .doc['name']] = orderM[
                                                        snapshot
                                                            .data!
                                                            .docChanges[index]
                                                            .doc['name']]! +
                                                    1;
//for pgetting price is
                                                mapPriceId[snapshot
                                                        .data!
                                                        .docChanges[index]
                                                        .doc['priceId']] =
                                                    orderM[snapshot
                                                        .data!
                                                        .docChanges[index]
                                                        .doc['name']]!;

                                                //toppings
                                              },
                                              removeFromCart: () {
                                                if (orderM[snapshot
                                                        .data!
                                                        .docChanges[index]
                                                        .doc['name']]! >=
                                                    1) {
                                                  double tempPrice =
                                                      double.parse(snapshot
                                                          .data!
                                                          .docChanges[index]
                                                          .doc['price']);
                                                  Provider.of<PriceState>(
                                                          context,
                                                          listen: false)
                                                      .subPrice(tempPrice);

                                                  orderM[snapshot
                                                      .data!
                                                      .docChanges[index]
                                                      .doc['name']] = orderM[
                                                          snapshot
                                                              .data!
                                                              .docChanges[index]
                                                              .doc['name']]! -
                                                      1;
                                                  Provider.of<QuanityState>(
                                                          context,
                                                          listen: false)
                                                      .subQuantity(1);
                                                } else {}
                                              },
                                              toppingsExtra: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.50,
                                                child: MultiSelectDialogField(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: kPrimaryColor),
                                                  buttonIcon: const Icon(
                                                    Icons.add,
                                                    size: 1,
                                                  ),
                                                  unselectedColor:
                                                      Colors.transparent,
                                                  listType:
                                                      MultiSelectListType.CHIP,
                                                  buttonText: const Text(
                                                    "Extra",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  title: const Text(
                                                      "Extra Toppings"),
                                                  items: _items,
                                                  onConfirm: (values) {
                                                    _selectedToppings = values;

                                                    List names = values
                                                        .map((e) => e)
                                                        .toList();
                                                    print(values.length);

                                                    // String n = names.toString();
                                                    String foodName = snapshot
                                                        .data!
                                                        .docChanges[index]
                                                        .doc['name']
                                                        .toString();

                                                    // print(n);
                                                    Provider.of<ExtraToppings>(
                                                            context,
                                                            listen: false)
                                                        .add(foodName,
                                                            names.join(","));
                                                    extraT = Provider.of<
                                                                ExtraToppings>(
                                                            context,
                                                            listen: false)
                                                        .extraTop;

                                                    extraToppingsQuantity =
                                                        values.length;
                                                  },
                                                  chipDisplay:
                                                      MultiSelectChipDisplay(
                                                    scroll: true,
                                                    onTap: (value) {
                                                      Provider.of<ExtraToppings>(
                                                              context,
                                                              listen: false)
                                                          .remove(
                                                              snapshot
                                                                  .data!
                                                                  .docChanges[
                                                                      index]
                                                                  .doc['name'],
                                                              value.toString());
                                                      print("dsd" +
                                                          json.encode(Provider
                                                                  .of<ExtraToppings>(
                                                                      context)
                                                              .extraTopping));
                                                    },
                                                  ),
                                                ),
                                              ),
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
        showToBasket.add(Basket(key: key, quantity: value.toInt()))));
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

                    return Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        //style: ,
                        title: Text(
                          "Item: " + name.key,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black),
                        ),
                        subtitle: Text(
                          "Quantity: " + name.quantity.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black),
                        ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Delivery Charge: ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    "5€",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                          backgroundColor: kPrimaryColor,
                          textStyle: const TextStyle(
                              color: kTextColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      child: const Text("Cash on Delivery"))),
              Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                      onPressed: () {
                        //print(json.encode(orderM));

                        showAddressUpdateDialog(
                            context,
                            cityController,
                            roadController,
                            apartmentController,
                            moreInfoController,
                            customerNameController,
                            numberInfoController,
                            "paid online");
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          textStyle: const TextStyle(
                            color: kTextColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                      child: const Text(
                        "Pay online",
                      ))),
            ],
          ),
        ],
      ),
    );
  }
}

class Basket {
  String key;
  int quantity;
  Basket({
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
    price: price,
    // extra: extra,
  ));
}

Future<void> _uploadOrder(
    String name,
    String extra,
    String city,
    String road,
    String apartment,
    String moreInfo,
    String customerName,
    String mobileNumber,
    String paymentType) async {
  String postId = const Uuid().v1();
  try {
    final f = DateFormat('HH:mm');

    //print(f.format(DateTime.now()));
    OrderMod orderMod = OrderMod(
      name: name,
      extra: extra,
      orderId: postId,
      time: f.format(DateTime.now()),
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
        .doc(postId)
        .set(orderMod.toJson());
  } catch (e) {
    print(e.toString());
  }
}

showOrderConfirmationDialog(
  BuildContext context,
) {
  Widget okButton = ElevatedButton(
    style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        textStyle: const TextStyle(
            color: kTextColor, fontSize: 15, fontWeight: FontWeight.bold)),
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
    TextEditingController cityController,
    TextEditingController roadController,
    TextEditingController apartmentController,
    TextEditingController moreInfoController,
    TextEditingController numberInfoController,
    TextEditingController customerNameController,
    paymentType) {
  // Create button

  Widget okButton = ElevatedButton(
    style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
    onPressed: () async {
      await _uploadOrder(
          json.encode(orderM),
          extraT,
          cityController.text,
          roadController.text,
          apartmentController.text,
          moreInfoController.text,
          customerNameController.text,
          numberInfoController.text,
          paymentType);

      mapPriceId.forEach((key, value) =>
          setLineItems.add(LineItem(price: key, quantity: value)));
      if (extraToppingsQuantity > 0) {
        setLineItems.add(
            LineItem(price: extraTopingPrice, quantity: extraToppingsQuantity));
      }

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
        backgroundColor: Colors.redAccent[400],
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
            controller: cityController,
            borderradius: 20,
            bordercolor: Colors.grey[300]!,
            widh: 0.32,
            height: 0.05,
            //icon: Icons.money,
            iconColor: Colors.grey,
            hinttext: 'Enter your city',
            fontsize: 15,
            obscureText: false),
        const SizedBox(
          height: 3,
        ),
        CustomTextField(
            controller: roadController,
            borderradius: 20,
            bordercolor: Colors.grey[300]!,
            widh: 0.32,
            height: 0.05,
            //icon: Icons.money,
            iconColor: Colors.grey,
            hinttext: 'Enter road no.',
            fontsize: 15,
            obscureText: false),
        const SizedBox(
          height: 3,
        ),
        CustomTextField(
            controller: apartmentController,
            borderradius: 20,
            bordercolor: Colors.grey[300]!,
            widh: 0.32,
            height: 0.05,
            // icon: Icons.money,
            iconColor: Colors.grey,
            hinttext: 'Enter your apartment',
            fontsize: 15,
            obscureText: false),
        const SizedBox(
          height: 3,
        ),
        CustomTextField(
            controller: moreInfoController,
            borderradius: 20,
            bordercolor: Colors.grey[300]!,
            widh: 0.32,
            height: 0.05,
            //icon: Icons.money,
            iconColor: Colors.grey,
            hinttext: 'Tell us more about your location',
            fontsize: 15,
            obscureText: false),
        const SizedBox(
          height: 3,
        ),
        CustomTextField(
            controller: customerNameController,
            borderradius: 20,
            bordercolor: Colors.grey[300]!,
            widh: 0.32,
            height: 0.05,
            //icon: Icons.money,
            iconColor: Colors.grey,
            hinttext: 'Your name',
            fontsize: 15,
            obscureText: false),
        const SizedBox(
          height: 3,
        ),
        CustomTextField(
            controller: numberInfoController,
            borderradius: 20,
            bordercolor: Colors.grey[300]!,
            widh: 0.32,
            height: 0.05,
            iconColor: Colors.grey,
            hinttext: 'Enter your number',
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
