// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously, prefer_final_fields, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:berchem_pizza_web/models/product_model.dart';

import 'package:berchem_pizza_web/screens/login/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';

import '../../models/order_model.dart';
import '../../onlinePayment/checkout/stripe_checkout_web.dart';
import '../../onlinePayment/constants.dart';
import '../widgets/custom_textfield.dart';

List basketProd = [];
double price = 0;
Map<String, int> orderM = {};
List<LineItem> setLineItems = [];
Map<String, int> mapPriceId = {};
int quantity = 0;

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        //scrollDirection: Axis.vertical,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Items available',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('products')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return GridView.builder(
                              shrinkWrap: true,
                              itemCount: _producs.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.1,
                              ),
                              itemBuilder: (_, index) {
                                return InkWell(
                                  onTap: () {
                                    print(_producs[index]['imageUrl']);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(15),
                                    color: Colors.grey[200],
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            clipBehavior: Clip.none,
                                            decoration: BoxDecoration(
                                                color: const Color(0xff7c94b6),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                        _producs[index]
                                                            ['imageUrl']))),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 5, top: 3),
                                              child: Text(
                                                _producs[index]["name"],
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[600]),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 5, top: 3),
                                              child: Text(
                                                "€ " + _producs[index]["price"],
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[600]),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        Container(
                                            margin: const EdgeInsets.only(
                                                left: 5, top: 5, bottom: 5),
                                            child: Row(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    addToBasket(
                                                      _producs[index]["id"],
                                                      _producs[index]["name"],
                                                      _producs[index]
                                                          ["category"],
                                                      _producs[index]
                                                          ["description"],
                                                      _producs[index]
                                                          ["imageUrl"],
                                                      _producs[index]["price"],
                                                    );
                                                    setState(() {
                                                      double tempPrice =
                                                          double.parse(
                                                              _producs[index]
                                                                  ["price"]);
                                                      print(price);

                                                      price += tempPrice;
                                                      quantity += 1;
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
                                                    });
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.green,
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  child:
                                                      const Text("Add to cart"),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                ElevatedButton(
                                                    onPressed: () {
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
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                    child: const Icon(
                                                        Icons.delete)),
                                              ],
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }
                      })
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 40),
                width: MediaQuery.of(context).size.width * 0.23,
                height: MediaQuery.of(context).size.height * 0.27,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: Container(
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Your Cart",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  "No of Items: ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                "${quantity}",
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
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                price.toStringAsFixed(2) + " €",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: ElevatedButton(
                                  onPressed: () {
                                    print(json.encode(orderM));
                                    showAddressUpdateDialog(
                                        context,
                                        _cityController,
                                        _roadController,
                                        _apartmentController,
                                        _moreInfoController,
                                        _customerNameController,
                                        _numberInfoController,
                                        "Cash on Delivery");
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      textStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  child: const Text("Cash on Delivery"))),
                          Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: ElevatedButton(
                                  onPressed: () {
                                    print(json.encode(orderM));

                                    showAddressUpdateDialog(
                                        context,
                                        _cityController,
                                        _roadController,
                                        _apartmentController,
                                        _moreInfoController,
                                        _customerNameController,
                                        _numberInfoController,
                                        "paid online");
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      textStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  child: const Text("Pay online"))),
                        ],
                      ),
                    ],
                  ),
                  // width: MediaQuery.of(context).size.width * 0.10,
                )),
          ],
        ),
      ),
    );
  }
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

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.lightGreen,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UserLoginView()));
            },
          ),
          const Text(
            "Berchem Pizza",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      centerTitle: false,

      // title: BlocBuilder<LocationBloc, LocationState>(
      //   builder: (context, state) {
      //     if (state is LocationLoading) {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //     if (state is LocationLoaded) {
      //       return InkWell(
      //         onTap: () {
      //           Navigator.pushNamed(context, LocationScreen.routeName);
      //         },
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Text(
      //               'CURRENT LOCATION',
      //               style: Theme.of(context)
      //                   .textTheme
      //                   .bodyText1!
      //                   .copyWith(color: Colors.white),
      //             ),
      //             Text(
      //               state.place.name,
      //               style: Theme.of(context)
      //                   .textTheme
      //                   .headline6!
      //                   .copyWith(color: Colors.white),
      //             ),
      //           ],
      //         ),
      //       );
      //     } else {
      //       return const Text('Something went wrong.');
      //     }
      //   },
      // ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
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
