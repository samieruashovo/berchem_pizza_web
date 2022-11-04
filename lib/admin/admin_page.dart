import 'package:berchem_pizza_web/admin/upload_item_to_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Admin"),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => const UploadItem())));
                  },
                  child: const Icon(Icons.add))
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
                        return LayoutBuilder(builder: (context, constrains) {
                          return GridView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: _producs.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 0.8,
                                mainAxisSpacing: 8.0,
                                crossAxisSpacing: 8.0,
                              ),
                              itemBuilder: (_, index) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.14,
                                      clipBehavior: Clip.none,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff7c94b6),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              colorFilter: ColorFilter.mode(
                                                  Colors.black.withOpacity(0.5),
                                                  BlendMode.dstATop),
                                              image: NetworkImage(
                                                  _producs[index]
                                                      ['imageUrl']))),
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
                                                _producs[index]["name"],
                                                style: const TextStyle(
                                                    fontSize: 15),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "${_producs[index]["price"]} \$",
                                                style: TextStyle(
                                                    color:
                                                        Colors.green.shade400,
                                                    fontSize: 13),
                                              )
                                            ]),
                                        //Expanded(child: SizedBox.shrink()),
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(Icons.edit)),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(Icons.delete)),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                );
                              });
                        });
                      }
                    }))));
  }
}
