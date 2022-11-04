import 'package:berchem_pizza_web/admin/admin_page.dart';
import 'package:berchem_pizza_web/screens/login/login_page.dart';
import 'package:berchem_pizza_web/screens/login/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocks/blocks.dart';
import '../../models/models.dart';
import '../../models/promo_model.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

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
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        //scrollDirection: Axis.vertical,
        child: Row(
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
                        'Top Rated',
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
                                  onTap: () {},
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
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                            Colors
                                                                .black
                                                                .withOpacity(
                                                                    0.5),
                                                            BlendMode.dstATop),
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
                                                _producs[index]["price"],
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
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                // padding: const EdgeInsets.symmetric(
                                                //     horizontal: ,
                                                //     vertical: 20),
                                                textStyle: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            child: const Text("Add to cart"),
                                          ),
                                        )
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
                padding: EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width * 0.23,
                height: MediaQuery.of(context).size.height* 0.90,
                child: const BasketView()),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.grey),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UserLoginView()));
            },
          ),
          const Text(
            "Berchem Pizza",
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.home, color: Colors.grey),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AdminScreen()));
            },
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

class BasketView extends StatefulWidget {
  const BasketView({super.key});

  @override
  State<BasketView> createState() => _BasketViewState();
}

class _BasketViewState extends State<BasketView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Basket"),
          Column(
            children: [
              const Text("total"),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                      onPressed: () {}, child: const Text("Chekcout")))
            ],
          ),
        ],
      ),
      // width: MediaQuery.of(context).size.width * 0.10,
    );
  }
}
