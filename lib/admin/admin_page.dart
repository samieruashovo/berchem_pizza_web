// ignore_for_file: unnecessary_null_comparison

import 'package:berchem_pizza_web/admin/upload_item_to_firebase.dart';
import 'package:berchem_pizza_web/constants.dart';
import 'package:berchem_pizza_web/screens/home/home_screen.dart';
import 'package:berchem_pizza_web/screens/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
  // final List _producs = [];
  // fetchProducts() async {
  //   QuerySnapshot qn =
  //       await FirebaseFirestore.instance.collection("products").get();
  //   setState(() {
  //     for (int i = 0; i < qn.docs.length; i++) {
  //       _producs.add({
  //         "name": qn.docs[i]["name"],
  //         "category": qn.docs[i]["category"],
  //         "price": qn.docs[i]["price"],
  //         "imageUrl": qn.docs[i]["imageUrl"],
  //         "description": qn.docs[i]["description"],
  //         "id": qn.docs[i]["id"],
  //       });
  //     }
  //   });
  //   return qn.docs;
  // }

  @override
  void initState() {
    // fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController priceController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 1,
                      backgroundColor: Colors.red,
                      textStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  child: const Text("Go to Home Page")),
              const Text(
                "Admin",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => const UploadItem())));
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 1,
                      backgroundColor: Colors.red,
                      textStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  child: const Text("Add Food"))
            ],
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return GridView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.docChanges.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.1,
                            ),
                            itemBuilder: (_, index) {
                              return Container(
                                margin: const EdgeInsets.all(15),
                                color: Colors.grey[200],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                image: NetworkImage(snapshot
                                                    .data!
                                                    .docChanges[index]
                                                    .doc['imageUrl']))),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data!.docChanges[index]
                                                    .doc['name'],
                                                style: const TextStyle(
                                                    fontSize: 15),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "${snapshot.data!.docChanges[index].doc['price']} \$",
                                                style: TextStyle(
                                                    color:
                                                        Colors.green.shade400,
                                                    fontSize: 13),
                                              )
                                            ]),
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  showPriceEditDialog(
                                                      context,
                                                      priceController,
                                                      snapshot
                                                          .data!
                                                          .docChanges[index]
                                                          .doc['id']);
                                                },
                                                icon: const Icon(Icons.edit)),
                                            IconButton(
                                                onPressed: () {
                                                  showDeleteAlertDialog(
                                                      context,
                                                      snapshot
                                                          .data!
                                                          .docChanges[index]
                                                          .doc['id']);
                                                },
                                                icon: const Icon(Icons.delete)),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            });
                      }
                    }))));
  }
}

showDeleteAlertDialog(BuildContext context, String productId) {
  // Create button

  Widget okButton = TextButton(
    child: const Text(
      "OK",
      style: TextStyle(color: Colors.black),
    ),
    onPressed: () {
      FirebaseFirestore.instance.collection('products').doc(productId).delete();
      Navigator.of(context).pop();
    },
  );
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Edit price"),
    content: const Text(
      "Are you sure you want to delete?",
      style: TextStyle(color: Colors.black),
    ),
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

showPriceEditDialog(BuildContext context, TextEditingController priceController,
    String productId) {
  // Create button

  Widget okButton = TextButton(
    child: const Text(
      "OK",
      style: TextStyle(color: Colors.black),
    ),
    onPressed: () {
      if (priceController.text != null) {
        FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .update({
          "price": priceController.text,
        });
      } else {
        Fluttertoast.showToast(msg: "Please enter a price");
      }
      Navigator.of(context).pop();
    },
  );
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Edit price"),
    content: CustomTextField(
        controller: priceController,
        borderradius: 20,
        bordercolor: Colors.white,
        widh: 0.32,
        height: 0.05,
        icon: Icons.money,
        iconColor: Colors.grey,
        hinttext: 'Enter new price',
        fontsize: 15,
        obscureText: false),
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
