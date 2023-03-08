// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../models/product_model.dart';
// import '../home_screen.dart';
// import '../intro/home/provider/order_provider.dart';
// import '../intro/home/provider/quanity_provider.dart';
// import '../intro/home/provider/value_provider.dart';
// import '../intro/prod.dart';

// class SearchPage extends StatefulWidget {
//   final mapPriceId;
//   final orderM;
//   final products;
//   final prodPriceId;
//   const SearchPage({
//     super.key,
//     required this.mapPriceId,
//     required this.orderM,
//     required this.products,
//     required this.prodPriceId,
//   });

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   TextEditingController search = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
//         .collection('products')
//         .where(
//           'name',
//           isGreaterThanOrEqualTo: search.text,
//         )
//         .snapshots();
//     return Scaffold(
//       appBar: AppBar(
//         title: Container(
//           padding: const EdgeInsets.only(
//             left: 20,
//             right: 10,
//           ),
//           child: TextField(
//             controller: search,
//             decoration: const InputDecoration(
//               hintText: 'Search',
//             ),
//             onChanged: (value) {
//               setState(() {});
//             },
//           ),
//         ),
//       ),
//       body: MultiProvider(
//         providers: [
//           ChangeNotifierProvider<PriceState>(
//               create: (context) => PriceState(0)),
//           ChangeNotifierProvider<QuanityState>(
//               create: (context) => QuanityState(0)),
//           ChangeNotifierProvider<OrderQuantity>(
//               create: (context) => OrderQuantity(orderM)),
//         ],
//         child: StreamBuilder(
//           stream: _usersStream,
//           builder:
//               (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (snapshot.hasError) {
//               return const Text("something is wrong");
//             }
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }

//             return Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   childAspectRatio: 1,
//                   crossAxisSpacing: 1,
//                 ),
//                 itemCount: snapshot.data!.docs.length,
//                 itemBuilder: (_, index) {
//                   return Prod(
//                       addToCart: () {
//                         addToBasket(
//                           widget.products[index]["id"],
//                           widget.products[index]["name"],
//                           widget.products[index]["category"],
//                           widget.products[index]["description"],
//                           widget.products[index]["imageUrl"],
//                           widget.products[index]["price"],
//                         );

//                         double tempPrice = 0;
//                         tempPrice =
//                             double.parse(widget.products[index]["price"]);

//                         Provider.of<PriceState>(context, listen: false)
//                             .addPrice(tempPrice);
//                         Provider.of<QuanityState>(context, listen: false)
//                             .addQuantity(1);

//                         if (widget.orderM[widget.products[index]["name"]] ==
//                             null) {
//                           widget.orderM[widget.products[index]["name"]] = 0;
//                         }
//                         widget.orderM[widget.products[index]["name"]] =
//                             widget.orderM[widget.products[index]["name"]]! + 1;

//                         // setLineItems.add(LineItem(
//                         //     price: prodPriceId,
//                         //     quantity: quantity));
//                         widget.mapPriceId[widget.prodPriceId] =
//                             widget.orderM[widget.products[index]["name"]]!;
//                         // print(mapPriceId);

//                         // print(orderM);
//                       },
//                       removeFromCart: () {
//                         //setState(() {
//                         if (widget.orderM[widget.products[index]["name"]]! >=
//                             1) {
//                           double tempPrice =
//                               double.parse(widget.products[index]["price"]);
//                           Provider.of<PriceState>(context, listen: false)
//                               .subPrice(tempPrice);
//                           //price -= tempPrice;

//                           widget.orderM[widget.products[index]["name"]] =
//                               widget.orderM[widget.products[index]["name"]]! -
//                                   1;
//                           // Provider.of<OrderQuantity>(
//                           //         context,
//                           //         listen: false)
//                           //     .add(_producs[index]["name"],
//                           //         1);
//                           Provider.of<QuanityState>(context, listen: false)
//                               .subQuantity(1);
//                           // quantity -= 1;
//                           // print(mapPriceId);

//                           //print(orderM);
//                         } else {
//                           // print("not in the cart");
//                         }
//                         //});
//                       },
//                       imageLink:
//                           snapshot.data!.docChanges[index].doc['imageUrl'],
//                       productTitle:
//                           snapshot.data!.docChanges[index].doc['name'],
//                       productDesc: "");
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// addToBasket(String id, String name, String category, String description,
//     String imageUrl, String price) {
//   basketProd.add(Product(
//       id: id,
//       name: name,
//       category: category,
//       description: description,
//       imageUrl: imageUrl,
//       price: price));
// }
