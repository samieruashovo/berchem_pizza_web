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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                //color: Colors.red,
                height: 100.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: Category.categories.length,
                  itemBuilder: (context, index) {
                    return CategoryBox(category: Category.categories[index]);
                  },
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: SizedBox(
            //     height: 125.0,
            //     child: ListView.builder(
            //       shrinkWrap: true,
            //       scrollDirection: Axis.horizontal,
            //       itemCount: Promo.promos.length,
            //       itemBuilder: (context, index) {
            //         return PromoBox(promo: Promo.promos[index]);
            //       },
            //     ),
            //   ),
            // ),
            const FoodSearchBox(),
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
            Container(
              height: MediaQuery.of(context).size.height * 0.50,
              child: Expanded(
                  child: StreamBuilder(
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
                          return LayoutBuilder(builder: (context, constrains) {
                            return GridView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: _producs.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 1.1,
                                  mainAxisSpacing: 8.0,
                                  crossAxisSpacing: 8.0,
                                ),
                                itemBuilder: (_, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {},
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
                                                      BorderRadius.circular(12),
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "${_producs[index]["price"]} \$",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .green.shade400,
                                                          fontSize: 13),
                                                    )
                                                  ]),
                                            
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          });
                        }
                      })),
            )

            // BlocBuilder<RestaurantsBloc, RestaurantsState>(
            //   builder: (context, state) {
            //     if (state is RestaurantsLoading) {
            //       return const Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     }
            //     if (state is RestaurantsLoaded) {
            //       return Container(
            //         padding: const EdgeInsets.all(8.0),
            //         // child: ListView.builder(
            //         //   physics: const NeverScrollableScrollPhysics(),
            //         //   shrinkWrap: true,
            //         //   itemCount: state.restaurants.length,
            //         //   itemBuilder: (context, index) {
            //         //     // return RestaurantCard(
            //         //     //   restaurant: state.restaurants[index],
            //         //     // );
            //         //   },
            //         // ),
            //       );
            //     } else {
            //       return const Text('Something went wrong');
            //     }
            //   },
            // ),
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
      leading: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              //user account
              print("pressed");
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UserLoginView()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              //user account
              print("pressed");
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AdminScreen()));
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
