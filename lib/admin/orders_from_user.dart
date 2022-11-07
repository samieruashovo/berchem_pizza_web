// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:berchem_pizza_web/admin/admin_page.dart';
import 'package:berchem_pizza_web/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersFromUser extends StatefulWidget {
  const OrdersFromUser({super.key});

  @override
  State<OrdersFromUser> createState() => _OrdersFromUserState();
}

class _OrdersFromUserState extends State<OrdersFromUser> {
  late final FirebaseFirestore fs = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  final List _orders = [];
  getData() async {
    try {
      QuerySnapshot qn =
          await FirebaseFirestore.instance.collection("orders").get();
      setState(() {
        for (int i = 0; i < qn.docs.length; i++) {
          _orders.add({
            "name": qn.docs[i]["name"],
            "orderId": qn.docs[i]["orderId"],
            "customerName": qn.docs[i]["customerName"],
            "city": qn.docs[i]["city"],
            "road": qn.docs[i]["road"],
            "apartment": qn.docs[i]["apartment"],
            "optional": qn.docs[i]["optional"],
          });
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Orders"),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AdminScreen()));
                  },
                  icon: const Icon(Icons.add))
            ],
          ),
        ),
        body: Center(
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('orders').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text(
                    'No Data...',
                  );
                } else {
                  var items = snapshot.data!.docs;
                  //print(items[0]['name']);
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var jsonD =
                            json.decode(snapshot.data!.docs[index]['name']);
                        String s = snapshot.data!.docs[index]['name'];
                        var name = s.replaceAll("\"", '');

                        return Container(
                          //color: Colors.grey,
                          margin: const EdgeInsets.only(
                              top: 10, left: 150, right: 150),
                          child: SizedBox(
                            width: 300,
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              tileColor: Colors.white,
                              title: Column(
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("Name: " +
                                      snapshot.data!.docs[index]
                                          ['customerName']),
                                  Text("Mobile Number: " +
                                      snapshot.data!.docs[index]
                                          ['mobileNumber']),
                                  Text("City: " +
                                      snapshot.data!.docs[index]['city']),
                                  Text("Road: " +
                                      snapshot.data!.docs[index]['road']),
                                  Text("Apartment: " +
                                      snapshot.data!.docs[index]['apartment']),
                                  Text("Optional: " +
                                      snapshot.data!.docs[index]['optional']),
                                  Text("Payment Type: " +
                                      snapshot.data!.docs[index]
                                          ['paymentType']),
                                ],
                              ),
                              trailing: IconButton(
                                  onPressed: () async {
                                    FirebaseFirestore.instance
                                        .collection('orders')
                                        .doc(snapshot.data!.docs[index]
                                            ['orderId'])
                                        .delete();
                                  },
                                  icon: const Icon(
                                    Icons.delete_sweep_outlined,
                                    color: Colors.red,
                                  )),
                            ),
                          ),
                        );
                      });
                }
              }),
        ));
  }
}
