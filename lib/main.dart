import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../blocks/blocks.dart';
import '/models/models.dart';
import 'blocks/login/auth/firebase_auth_provider.dart';
import 'blocks/login/login_bloc.dart';
import 'blocks/login/login_event.dart';
import 'repositories/repositories.dart';
import 'config/theme.dart';
import 'config/app_router.dart';

import 'screens/home/intro/home/home_page_intro.dart';
import 'simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCLPHdPQscw7J5pHho3vNIAWG8BzSadvDI",
        appId: "1:799306159315:web:98432c0577227df6c33026",
        messagingSenderId: "799306159315",
        projectId: "berchem-pizza",
        storageBucket: "berchem-pizza.appspot.com"),
  );
  await Hive.initFlutter();
  Hive.registerAdapter(PlaceAdapter());

  BlocOverrides.runZoned(
    () {
      runApp(MyApp());
    },
    blocObserver: SimpleBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GeolocationRepository>(
          create: (_) => GeolocationRepository(),
        ),
        RepositoryProvider<PlacesRepository>(
          create: (_) => PlacesRepository(),
        ),
        // RepositoryProvider<RestaurantRepository>(
        //   create: (_) => RestaurantRepository(),
        // ),
        RepositoryProvider<LocalStorageRepository>(
          create: (_) => LocalStorageRepository(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          // BlocProvider(
          //   create: (context) => RestaurantsBloc(
          //     restaurantRepository: context.read<RestaurantRepository>(),
          //   ),
          // ),
          BlocProvider(
            create: (context) => AutocompleteBloc(
              placesRepository: context.read<PlacesRepository>(),
            )..add(const LoadAutocomplete()),
          ),
          // BlocProvider(
          //   create: (context) => FilterBloc(
          //     restaurantsBloc: context.read<RestaurantsBloc>(),
          //   )..add(LoadFilter()),
          // ),
          BlocProvider(
            create: (context) => VoucherBloc(
              voucherRepository: VoucherRepository(),
            )..add(LoadVouchers()),
          ),
          BlocProvider(
            create: (context) => BasketBloc(
              voucherBloc: BlocProvider.of<VoucherBloc>(context),
            )..add(StartBasket()),
          ),
          BlocProvider(create: (context) => AuthBloc(FirebaseAuthProvider())),
          // BlocProvider(
          //   create: (context) => LocationBloc(
          //     geolocationRepository: context.read<GeolocationRepository>(),
          //     placesRepository: context.read<PlacesRepository>(),
          //     localStorageRepository: context.read<LocalStorageRepository>(),
          //     restaurantRepository: context.read<RestaurantRepository>(),
          //   )..add(const LoadMap()),
          // ),
        ],
        child: MaterialApp(
          title: 'FoodDelivery',
          debugShowCheckedModeBanner: false,
          theme: theme(),
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: HomePageIntro.routeName,
        ),
      ),
    );
  }
}
