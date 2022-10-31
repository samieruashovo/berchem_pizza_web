// ignore_for_file: avoid_print

import 'package:berchem_pizza_web/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/home/home_screen.dart';
import 'screens/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: const FirebaseOptions(
      apiKey: "AIzaSyCLPHdPQscw7J5pHho3vNIAWG8BzSadvDI",
      appId: "1:799306159315:web:98432c0577227df6c33026",
      messagingSenderId: "799306159315",
      projectId: "berchem-pizza",
    ),
  );
  runApp(MyApp());
}

/*
const firebaseConfig = {
    apiKey: "AIzaSyCLPHdPQscw7J5pHho3vNIAWG8BzSadvDI",
    authDomain: "berchem-pizza.firebaseapp.com",
    projectId: "berchem-pizza",
    storageBucket: "berchem-pizza.appspot.com",
    messagingSenderId: "799306159315",
    appId: "1:799306159315:web:98432c0577227df6c33026",
    measurementId: "G-VKMNVP2VFK"
  };*/

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          //fontFamily: 'Montserrat',
        ),
        //home: const HomeScreen(),
        home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("error");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return const SignUp();
            }
            return const CircularProgressIndicator();
          },
        ));
  }
}
