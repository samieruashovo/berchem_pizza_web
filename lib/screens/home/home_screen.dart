import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocks/blocks.dart';
import '../../models/models.dart';
import '../../models/promo_model.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => HomeScreen(),
      settings: RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 125.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: Promo.promos.length,
                  itemBuilder: (context, index) {
                    return PromoBox(promo: Promo.promos[index]);
                  },
                ),
              ),
            ),
            FoodSearchBox(),
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
            BlocBuilder<RestaurantsBloc, RestaurantsState>(
              builder: (context, state) {
                if (state is RestaurantsLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is RestaurantsLoaded) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.restaurants.length,
                      itemBuilder: (context, index) {
                        return RestaurantCard(
                          restaurant: state.restaurants[index],
                        );
                      },
                    ),
                  );
                } else {
                  return Text('Something went wrong');
                }
              },
            ),
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
      leading: IconButton(
        icon: Icon(Icons.person, color: Colors.white),
        onPressed: () {},
      ),
      centerTitle: false,
      title: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state is LocationLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is LocationLoaded) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, LocationScreen.routeName);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CURRENT LOCATION',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                  ),
                  Text(
                    state.place.name,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            );
          } else {
            return Text('Something went wrong.');
          }
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}

/*

import 'package:flutter/material.dart';


import '../../constants.dart';
import 'components/body.dart';
import 'components/footer.dart';
import 'components/header_container.dart';

import 'components/menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            DrawerHeader(
              child: Center(
                child: Text(
                  "Foodie",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w900,
                      color: kSecondaryColor),
                ),
              ),
            ),
            MobMenu()
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              //header
              HeaderContainer(),
              //body
              BodyContainer(),
              //footer
              SizedBox(
                height: 30,
              ),
              Footer(),
              //now we make our website responsive
            ],
          ),
        ),
      ),
    );
  }
}
*/