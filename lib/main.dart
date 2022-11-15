import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocks/login/auth/firebase_auth_provider.dart';
import 'blocks/login/login_bloc.dart';

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
  Bloc.observer = SimpleBlocObserver();
  runApp(
    
    const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(FirebaseAuthProvider())),
      ],
      child: MaterialApp(
        title: 'Berchem Pizza',
        debugShowCheckedModeBanner: false,
        theme: theme(),
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: HomePageIntro.routeName,
      ),
    );
  }
}
